-- phpMyAdmin SQL Dump
-- version 3.5.2.2
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Feb 04, 2017 at 06:38 PM
-- Server version: 5.5.27
-- PHP Version: 5.4.7

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `periode`
--

-- --------------------------------------------------------

--
-- Table structure for table `periode`
--

DROP TABLE IF EXISTS `periode`;
CREATE TABLE IF NOT EXISTS `periode` (
  `kd_periode` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`kd_periode`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `periode`
--

INSERT INTO `periode` (`kd_periode`, `nama`) VALUES
(1, 'MAPRES 2023'),
(2, 'MAPRES 2022');

-- --------------------------------------------------------

--
-- Table structure for table `hasil`
--

DROP TABLE IF EXISTS `hasil`;
CREATE TABLE IF NOT EXISTS `hasil` (
  `kd_hasil` int(11) NOT NULL AUTO_INCREMENT,
  `kd_periode` int(11) NOT NULL,
  `nim` char(10) NOT NULL,
  `nilai` float DEFAULT NULL,
  `tahun` char(4) DEFAULT NULL,
  PRIMARY KEY (`kd_hasil`),
  KEY `fk_mahasiswa` (`nim`),
  KEY `fk_periode` (`kd_periode`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=21 ;


-- --------------------------------------------------------

--
-- Table structure for table `kriteria`
--

DROP TABLE IF EXISTS `kriteria`;
CREATE TABLE IF NOT EXISTS `kriteria` (
  `kd_kriteria` int(11) NOT NULL AUTO_INCREMENT,
  `kd_periode` int(11) NOT NULL,
  `nama` varchar(50) DEFAULT NULL,
  `sifat` enum('min','max') DEFAULT NULL,
  PRIMARY KEY (`kd_kriteria`),
  KEY `kd_periode` (`kd_periode`),
  KEY `kd_periode_2` (`kd_periode`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=17 ;

--
-- Dumping data for table `kriteria`
--

INSERT INTO `kriteria` (`kd_kriteria`, `kd_periode`, `nama`, `sifat`) VALUES
(1, 1, 'Piagam', 'max'),
(2, 1, 'IPK', 'max'),
(3, 1, 'Organisasi', 'min'),
(4, 1, 'Semester', 'min'),
(5, 2, 'Piagam', 'max'),
(6, 2, 'IPK', 'max'),
(7, 2, 'Organisasi', 'min'),
(8, 2, 'Semester', 'min');



-- --------------------------------------------------------

--
-- Table structure for table `mahasiswa`
--

DROP TABLE IF EXISTS `mahasiswa`;
CREATE TABLE IF NOT EXISTS `mahasiswa` (
  `nim` char(10) NOT NULL,
  `nama` varchar(30) NOT NULL,
  `alamat` varchar(100) DEFAULT NULL,
  `jenis_kelamin` enum('Laki-laki','Perempuan') DEFAULT NULL,
  `tahun_mengajukan` char(4) NOT NULL,
  PRIMARY KEY (`nim`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `mahasiswa`
--

INSERT INTO `mahasiswa` (`nim`, `nama`, `alamat`, `jenis_kelamin`, `tahun_mengajukan`) VALUES
('2111521015', 'Muhammad Irsyadul Fikri', 'Padang', 'Laki-laki', '2023'),
('2111521019', 'Thomas Nobel Asfar', 'Padang', 'Laki-laki', '2023'),
('2111521035', 'Ghina Fitri Hidayah', 'Padang', 'Perempuan', '2023'),
('2111523021', 'Hasya Zikra Alfrena', 'Padang', 'Perempuan', '2023'),
('2111527001', 'Sukma Anggarmadi', 'Padang', 'Laki-laki', '2023');

-- --------------------------------------------------------

--
-- Table structure for table `model`
--

DROP TABLE IF EXISTS `model`;
CREATE TABLE IF NOT EXISTS `model` (
  `kd_model` int(11) NOT NULL AUTO_INCREMENT,
  `kd_periode` int(11) NOT NULL,
  `kd_kriteria` int(11) NOT NULL,
  `bobot` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`kd_model`),
  KEY `fk_kriteria` (`kd_kriteria`),
  KEY `fk_periode` (`kd_periode`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=25 ;

--
-- Dumping data for table `model`
--

INSERT INTO `model` (`kd_model`, `kd_periode`, `kd_kriteria`, `bobot`) VALUES
(1, 1, 1, '0.50'),
(2, 1, 2, '0.30'),
(3, 1, 3, '0.15'),
(4, 1, 4, '0.05'),
(5, 2, 1, '0.50'),
(6, 2, 2, '0.30'),
(7, 2, 3, '0.15'),
(8, 2, 4, '0.05');



-- --------------------------------------------------------

--
-- Table structure for table `nilai`
--

DROP TABLE IF EXISTS `nilai`;
CREATE TABLE IF NOT EXISTS `nilai` (
  `kd_nilai` int(11) NOT NULL AUTO_INCREMENT,
  `kd_periode` int(11) DEFAULT NULL,
  `kd_kriteria` int(11) NOT NULL,
  `nim` char(10) NOT NULL,
  `nilai` float DEFAULT NULL,
  PRIMARY KEY (`kd_nilai`),
  KEY `fk_kriteria` (`kd_kriteria`),
  KEY `fk_mahasiswa` (`nim`),
  KEY `fk_periode` (`kd_periode`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=84 ;

--
-- Dumping data untuk tabel `nilai`
--

INSERT INTO `nilai` (`kd_nilai`, `kd_periode`, `kd_kriteria`, `nim`, `nilai`) VALUES
(84, 1, 1, '2111521015', 25),
(85, 1, 2, '2111521015', 100),
(86, 1, 3, '2111521015', 75),
(87, 1, 4, '2111521015', 50),
(88, 1, 1, '2111521019', 25),
(89, 1, 2, '2111521019', 100),
(90, 1, 3, '2111521019', 50),
(91, 1, 4, '2111521019', 50),
(92, 1, 1, '2111521035', 100),
(93, 1, 2, '2111521035', 100),
(94, 1, 3, '2111521035', 100),
(95, 1, 4, '2111521035', 50),
(96, 1, 1, '2111523021', 50),
(97, 1, 2, '2111523021', 100),
(98, 1, 3, '2111523021', 75),
(99, 1, 4, '2111523021', 50),
(100, 1, 1, '2111527001', 50),
(101, 1, 2, '2111527001', 100),
(102, 1, 3, '2111527001', 75),
(103, 1, 4, '2111527001', 50);



--
-- Table structure for table `pengguna`
--

DROP TABLE IF EXISTS `pengguna`;
CREATE TABLE IF NOT EXISTS `pengguna` (
  `kd_pengguna` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(30) NOT NULL,
  `password` varchar(60) NOT NULL,
  `status` enum('petugas','puket','mahasiswa') DEFAULT NULL,
  PRIMARY KEY (`kd_pengguna`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `pengguna`
--

INSERT INTO `pengguna` (`kd_pengguna`, `username`, `password`, `status`) VALUES
(1, 'admin', '21232f297a57a5a743894a0e4a801fc3', 'admin');
-- --------------------------------------------------------

--
-- Table structure for table `penilaian`
--

DROP TABLE IF EXISTS `penilaian`;
CREATE TABLE IF NOT EXISTS `penilaian` (
  `kd_penilaian` int(11) NOT NULL AUTO_INCREMENT,
  `kd_periode` int(11) DEFAULT NULL,
  `kd_kriteria` int(11) NOT NULL,
  `keterangan` varchar(20) NOT NULL,
  `bobot` int(3) DEFAULT NULL,
  PRIMARY KEY (`kd_penilaian`),
  KEY `fk_kriteria` (`kd_kriteria`),
  KEY `fk_periode` (`kd_periode`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=109 ;

--
-- Dumping data untuk tabel `penilaian`
--

INSERT INTO `penilaian` (`kd_penilaian`, `kd_periode`, `kd_kriteria`, `keterangan`, `bobot`) VALUES
(109, 1, 1, '1-3', 25),
(110, 1, 1, '4-6', 50),
(111, 1, 1, '7-9', 75),
(112, 1, 1, '>=10', 100),
(113, 1, 2, '<2,75', 25),
(114, 1, 2, '2,75-2,99', 50),
(115, 1, 2, '3,00-3,49', 75),
(116, 1, 2, '3,5-4,0', 100),
(117, 1, 3, '<1', 25),
(118, 1, 3, '1-3', 50),
(119, 1, 3, '4-6', 75),
(120, 1, 3, '>7', 100),
(121, 1, 4, '1-2', 25),
(122, 1, 4, '3-4', 50),
(123, 1, 4, '5-6', 75),
(124, 1, 4, '7-8', 100);




--
-- Constraints for dumped tables
--

--
-- Constraints for table `hasil`
--
ALTER TABLE `hasil`
  ADD CONSTRAINT `hasil_ibfk_1` FOREIGN KEY (`nim`) REFERENCES `mahasiswa` (`nim`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `hasil_ibfk_2` FOREIGN KEY (`kd_periode`) REFERENCES `periode` (`kd_periode`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `kriteria`
--
ALTER TABLE `kriteria`
  ADD CONSTRAINT `fk_periode` FOREIGN KEY (`kd_periode`) REFERENCES `periode` (`kd_periode`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `model`
--
ALTER TABLE `model`
  ADD CONSTRAINT `model_ibfk_1` FOREIGN KEY (`kd_kriteria`) REFERENCES `kriteria` (`kd_kriteria`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `model_ibfk_2` FOREIGN KEY (`kd_periode`) REFERENCES `periode` (`kd_periode`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `nilai`
--
ALTER TABLE `nilai`
  ADD CONSTRAINT `nilai_ibfk_1` FOREIGN KEY (`kd_kriteria`) REFERENCES `kriteria` (`kd_kriteria`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `nilai_ibfk_2` FOREIGN KEY (`nim`) REFERENCES `mahasiswa` (`nim`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `nilai_ibfk_3` FOREIGN KEY (`kd_periode`) REFERENCES `periode` (`kd_periode`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `penilaian`
--
ALTER TABLE `penilaian`
  ADD CONSTRAINT `penilaian_ibfk_1` FOREIGN KEY (`kd_kriteria`) REFERENCES `kriteria` (`kd_kriteria`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `penilaian_ibfk_2` FOREIGN KEY (`kd_periode`) REFERENCES `periode` (`kd_periode`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
