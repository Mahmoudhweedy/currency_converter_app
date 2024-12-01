import 'package:cached_network_image/cached_network_image.dart';
import 'package:currency_converter_app/domain/entity/country_entity.dart';
import 'package:currency_converter_app/presentation/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

import '../../core/networking/api_constants.dart';

class CurrencyCard extends StatelessWidget {
  final Country? country;
  final Function onSelect;
  final Function(String?)? onChanged;
  final TextEditingController? controller;
  final String hintText;
  final bool enabled;
  const CurrencyCard({
    super.key,
    required this.country,
    required this.onSelect,
    this.onChanged,
    required this.hintText,
    this.enabled = true,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => onSelect(),
              child: Row(
                children: [
                  country == null
                      ? const SizedBox()
                      : CachedNetworkImage(
                          imageUrl:
                              '${ApiConstants.flagsBaseUrl}${country?.id.toLowerCase()}.png',
                          width: 40,
                          height: 30,
                          fit: BoxFit.cover,
                        ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          country == null ? '' : country!.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          country == null ? '' : country!.currencyName,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppTextFormField(
              controller: controller,
              hintText: hintText,
              onChanged: onChanged,
              enabled: enabled,
              suffixIcon: SizedBox(
                width: 20,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(country == null ? '' : country!.currencySymbol,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[600],
                        )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
