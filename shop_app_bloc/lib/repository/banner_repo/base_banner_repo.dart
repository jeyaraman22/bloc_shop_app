
import 'package:shop_app_bloc/model/banner_model.dart';

abstract class BaseBannerImageRepo{
  Future<List<BannerModel>> getAllImages();
}