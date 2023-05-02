<div class="row">
	<div class="col-md-12">
	<?php if (isset($_GET["periode"])) {
		$sqlKriteria = "";
		$namaKriteria = [];
		$queryKriteria = $connection->query("SELECT a.kd_kriteria, a.nama FROM kriteria a JOIN model b USING(kd_kriteria) WHERE b.kd_periode=$_GET[periode]");
		while ($kr = $queryKriteria->fetch_assoc()) {
			$sqlKriteria .= "SUM(
				IF(
					c.kd_kriteria=".$kr["kd_kriteria"].",
					IF(c.sifat='max', nilai.nilai/c.normalization, c.normalization/nilai.nilai), 0
				)
			) AS ".strtolower(str_replace(" ", "_", $kr["nama"])).",";
			$namaKriteria[] = strtolower(str_replace(" ", "_", $kr["nama"]));
		}
		$sql = "SELECT
			(SELECT nama FROM mahasiswa WHERE nim=mhs.nim) AS nama,
			(SELECT nim FROM mahasiswa WHERE nim=mhs.nim) AS nim,
			(SELECT tahun_mengajukan FROM mahasiswa WHERE nim=mhs.nim) AS tahun,
			$sqlKriteria
			SUM(
				IF(
						c.sifat = 'max',
						nilai.nilai / c.normalization,
						c.normalization / nilai.nilai
				) * c.bobot
			) AS rangking
		FROM
			nilai
			JOIN mahasiswa mhs USING(nim)
			JOIN (
				SELECT
						nilai.kd_kriteria AS kd_kriteria,
						kriteria.sifat AS sifat,
						(
							SELECT bobot FROM model WHERE kd_kriteria=kriteria.kd_kriteria AND kd_periode=periode.kd_periode
						) AS bobot,
						ROUND(
							IF(kriteria.sifat='max', MAX(nilai.nilai), MIN(nilai.nilai)), 1
						) AS normalization
					FROM nilai
					JOIN kriteria USING(kd_kriteria)
					JOIN periode ON kriteria.kd_periode=periode.kd_periode
					WHERE periode.kd_periode=$_GET[periode]
				GROUP BY nilai.kd_kriteria
			) c USING(kd_kriteria)
		WHERE kd_periode=$_GET[periode]
		GROUP BY nilai.nim"; ?>
	<?php
			$sql1 = "SELECT
			(SELECT nama FROM mahasiswa WHERE nim=mhs.nim) AS nama,
			(SELECT nim FROM mahasiswa WHERE nim=mhs.nim) AS nim,
			(SELECT tahun_mengajukan FROM mahasiswa WHERE nim=mhs.nim) AS tahun,
			$sqlKriteria
			SUM(
				IF(
						c.sifat = 'max',
						nilai.nilai / c.normalization,
						c.normalization / nilai.nilai
				) * c.bobot
			) AS rangking
		FROM
			nilai
			JOIN mahasiswa mhs USING(nim)
			JOIN (
				SELECT
						nilai.kd_kriteria AS kd_kriteria,
						kriteria.sifat AS sifat,
						(
							SELECT bobot FROM model WHERE kd_kriteria=kriteria.kd_kriteria AND kd_periode=periode.kd_periode
						) AS bobot,
						ROUND(
							IF(kriteria.sifat='max', MAX(nilai.nilai), MIN(nilai.nilai)), 1
						) AS normalization
					FROM nilai
					JOIN kriteria USING(kd_kriteria)
					JOIN periode ON kriteria.kd_periode=periode.kd_periode
					WHERE periode.kd_periode=$_GET[periode]
				GROUP BY nilai.kd_kriteria
			) c USING(kd_kriteria)
		WHERE kd_periode=$_GET[periode]
		GROUP BY nilai.nim
		ORDER BY rangking DESC"; 
	?>

	<?php
		$dataAwal = "SELECT
		(SELECT nama FROM mahasiswa WHERE nim=mhs.nim) AS nama,
		(SELECT nim FROM mahasiswa WHERE nim=mhs.nim) AS nim,
		nilai
	FROM
		nilai
		JOIN mahasiswa mhs USING(nim)
	WHERE kd_periode=$_GET[periode]";
	?>
		<?php 
		$bobot = array();
		$query = $connection->query("SELECT bobot FROM model WHERE kd_periode=$_GET[periode]"); while($row1 = $query->fetch_assoc()): ?>
			<?php array_push($bobot, $row1['bobot']) ?>
		<?php endwhile ?>
	  <div class="panel panel-info">
	      <div class="panel-heading"><h3 class="text-center"><h2 class="text-center"><?php $query = $connection->query("SELECT * FROM periode WHERE kd_periode=$_GET[periode]"); echo $query->fetch_assoc()["nama"]; ?></h2></h3></div>
	      <div class="panel-body">
<!-- Tabel Normalisassi -->
			<h3 class="text-center">Tabel Hasil Normalisasi</h3>
	          <table class="table table-condensed table-hover" border="1">
	              <thead>
	                  <tr>
							<th>NIM</th>
							<th>Nama</th>
							<?php $query = $connection->query("SELECT nama FROM kriteria WHERE kd_periode=$_GET[periode]"); while($row = $query->fetch_assoc()): ?>
								<th><?=$row["nama"]?></th>
							<?php endwhile ?>
	                  </tr>
	              </thead>
	              <tbody>
					<?php $query = $connection->query($sql); while($row = $query->fetch_assoc()): ?>
					<?php
					$rangking = number_format((float) $row["rangking"], 8, '.', '');
					$q = $connection->query("SELECT nim FROM hasil WHERE nim='$row[nim]' AND kd_periode='$_GET[periode]' AND tahun='$row[tahun]'");
					if (!$q->num_rows) {
					$connection->query("INSERT INTO hasil VALUES(NULL, '$_GET[periode]', '$row[nim]', '".$rangking."', '$row[tahun]')");
					}
					?>
					<tr>
						<td><?=$row["nim"]?></td>
						<td><?=$row["nama"]?></td>
						<?php for($i=0; $i<count($namaKriteria); $i++): ?>
						<th><?=number_format((float) $row[$namaKriteria[$i]], 8, '.', '');?></th>
						<?php endfor ?>
					</tr>
					<?php endwhile;?>
	              </tbody>
	          </table>
<br>
<!-- Tabel Kali Bobot -->
			<h3 class="text-center">Tabel Hasil Perkalian Bobot</h3>
	          <table class="table table-condensed table-hover" border="1">
	              <thead>
	                  <tr>
							<th>NIM</th>
							<th>Nama</th>
							<?php $query = $connection->query("SELECT nama FROM kriteria WHERE kd_periode=$_GET[periode]"); while($row = $query->fetch_assoc()): ?>
								<th><?=$row["nama"]?></th>
							<?php endwhile ?>
							<th>Nilai</th>
	                  </tr>
	              </thead>
	              <tbody>
					<?php $query = $connection->query($sql); while($row = $query->fetch_assoc()): ?>
						<?php
						$rangking = number_format((float) $row["rangking"], 8, '.', '');
						$q = $connection->query("SELECT nim FROM hasil WHERE nim='$row[nim]' AND kd_periode='$_GET[periode]' AND tahun='$row[tahun]'");
						if (!$q->num_rows) {
						$connection->query("INSERT INTO hasil VALUES(NULL, '$_GET[periode]', '$row[nim]', '".$rangking."', '$row[tahun]')");
						}
						?>
						<tr>
							<td><?=$row["nim"]?></td>
							<td><?=$row["nama"]?></td>
							<?php for($i=0; $i<count($namaKriteria); $i++): ?>
								<th>
									<?php
									$hasilKali = number_format((float) $row[$namaKriteria[$i]], 8, '.', '')*$bobot[$i];
									echo number_format($hasilKali, 8, '.', '')
									?>
								</th>
							<?php endfor ?>
							<td><?=$rangking?></td>
						</tr>
					<?php endwhile;?>	
	              </tbody>
	          </table>

<!-- Tabel Ranking -->
<br>
			<h3 class="text-center">Tabel Ranking</h3>
	          <table class="table table-condensed table-hover" border="1">
	              <thead>
	                  <tr>
							<th>NIM</th>
							<th>Nama</th>
							<th>Nilai</th>
							<th>Ranking</th>
	                  </tr>
	              </thead>
	              <tbody>
					<?php $rank=1; $query = $connection->query($sql1); while($row = $query->fetch_assoc()): ?>
						<?php
						$rangking = number_format((float) $row["rangking"], 8, '.', '');
						$q = $connection->query("SELECT nim FROM hasil WHERE nim='$row[nim]' AND kd_periode='$_GET[periode]' AND tahun='$row[tahun]'");
						if (!$q->num_rows) {
						$connection->query("INSERT INTO hasil VALUES(NULL, '$_GET[periode]', '$row[nim]', '".$rangking."', '$row[tahun]')");
						}
						?>
						<tr>
							<td><?=$row["nim"]?></td>
							<td><?=$row["nama"]?></td>
							<td><?=$rangking?></td>
							<td><?=$rank?></td>
						</tr>
					<?php $rank++; endwhile;?>	
	              </tbody>
	          </table>
	      </div>
	  </div>
	<?php } else { ?>
		<h1>periode belum dipilih...</h1>
	<?php } ?>
	</div>
</div>
