import '../models/individual_report_item.dart';
import '../models/cross_report_item.dart';

final List<IndividualReportItem> dummyIndividualReports = [
  IndividualReportItem(
    gene: 'SLC6A20',
    disease: 'Hyperglycinuria',
    arabicDisease: 'فرط الغلايسين في الدم',
    clinicalSignificance: 'Uncertain significance',
    inheritance: 'Unknown',
    confidenceLevel: '1',
  ),
  IndividualReportItem(
    gene: 'NEB',
    disease: 'Nemaline myopathy 2',
    arabicDisease: 'نيمالين مايوباثي 2',
    clinicalSignificance: 'Uncertain significance',
    inheritance: 'Biallelic autosomal',
    confidenceLevel: '3',
  ),
  IndividualReportItem(
    gene: 'SCN1A',
    disease: 'Severe myoclonic epilepsy',
    arabicDisease: 'الصرع الرمعي الشديد',
    clinicalSignificance: 'Pathogenic',
    inheritance: 'Monoallelic autosomal',
    confidenceLevel: 'Not specified',
  ),
];

final List<CrossReportItem> dummyCrossReports = [
  CrossReportItem(
    sectionTitle: 'Autosomal Recessive Risks',
    disease: 'Cystic Fibrosis',
    gene: 'CFTR',
    inheritance: 'Autosomal Recessive',
    clinicalSignificance: 'Pathogenic',
    affectedRisk: '25%',
    carrierRisk: '50%',
    healthyRisk: '25%',
  ),
  CrossReportItem(
    sectionTitle: 'Dominant Risks',
    disease: 'Emery-Dreifuss muscular dystrophy',
    gene: 'SYNE1',
    inheritance: 'Autosomal Dominant',
    clinicalSignificance: 'Likely pathogenic',
    affectedRisk: '50%',
    carrierRisk: '0%',
    healthyRisk: '50%',
  ),
  CrossReportItem(
    sectionTitle: 'X-Linked Risks',
    disease: 'Duchenne Muscular Dystrophy',
    gene: 'DMD',
    inheritance: 'X-Linked',
    clinicalSignificance: 'Pathogenic',
    affectedRisk: '50%',
    carrierRisk: 'N/A',
    healthyRisk: 'N/A',
  ),
];
