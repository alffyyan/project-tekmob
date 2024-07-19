import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanner_main/main.dart';
import 'package:scanner_main/ui/screens/home/components/file_list_item.dart';

import '../../../../bloc/home/home_bloc.dart';

class ScanyListItem extends StatelessWidget {
  const ScanyListItem({
    super.key,
    required this.item,
    required this.index,
    required this.onTap,
  });

  final FileListItem item;
  final int index;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final isSelected = state.selectedItems[index];

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: InkWell(
            onTap: onTap,
            onLongPress: () {
              context.read<HomeBloc>().add(const ToggleEditMode());
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: item.imageUrl != null && item.imageUrl!.isNotEmpty ? Image.network(
                          item.imageUrl!,
                          width: 93,
                          height: 110,
                          fit: BoxFit.cover,
                        ) : Image.asset(
                          'assets/images/icons/files/pdf_icon.png',
                          width: 93,
                          height: 110,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: $styles.text.bodyTextLargeMedium
                                .copyWith(color: $styles.colors.mainBlack),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.date,
                            style: $styles.text.labelBold
                                .copyWith(color: $styles.colors.mainBlack),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.file_copy_outlined,
                                color: $styles.colors.supportingGray,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                item.qty,
                                style: $styles.text.labelBold.copyWith(
                                    color: $styles.colors.supportingGray),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Checkbox(
                        checkColor: Colors.white,
                        activeColor: $styles.colors.primary,
                        side:
                        BorderSide(width: 2, color: $styles.colors.primary),
                        value: isSelected,
                        onChanged: (value) {
                          if (value! && !state.isEditMode) {
                            context.read<HomeBloc>().add(const ToggleEditMode());
                          }
                          context.read<HomeBloc>().add(CheckItem(index, value));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
