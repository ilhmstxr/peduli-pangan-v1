import 'package:flutter/material.dart';
import 'alamat_list_screen.dart'; // for green color

enum AlamatType { home, store, office, other }

class AlamatFormScreen extends StatefulWidget {
  final bool isEdit;
  final Map<String, dynamic>? initial; // jika edit, isi initial value

  const AlamatFormScreen({super.key, this.isEdit = false, this.initial});

  @override
  State<AlamatFormScreen> createState() => _AlamatFormScreenState();
}

class _AlamatFormScreenState extends State<AlamatFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameC = TextEditingController();
  final _phoneC = TextEditingController();
  final _AlamatC = TextEditingController();
  final _cityC = TextEditingController();
  final _provinceC = TextEditingController();
  final _postalC = TextEditingController();
  final _countryC = TextEditingController(text: 'Indonesia');

  AlamatType _type = AlamatType.home;
  bool _isDefault = true;

  @override
  void initState() {
    super.initState();
    final init = widget.initial;
    if (init != null) {
      _nameC.text = init['name'] ?? '';
      _phoneC.text = init['phone'] ?? '';
      _AlamatC.text = init['Alamat'] ?? '';
      _cityC.text = init['city'] ?? '';
      _provinceC.text = init['province'] ?? '';
      _postalC.text = init['postal'] ?? '';
      _countryC.text = init['country'] ?? 'Indonesia';
      _isDefault = init['isDefault'] ?? false;
      _type = init['type'] ?? AlamatType.home;
    }
  }

  @override
  void dispose() {
    _nameC.dispose();
    _phoneC.dispose();
    _AlamatC.dispose();
    _cityC.dispose();
    _provinceC.dispose();
    _postalC.dispose();
    _countryC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isEdit ? 'Change Alamat' : 'New Alamat';
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _Input(text: 'isi nama anda', controller: _nameC),
                            const SizedBox(height: 12),
                            _PhoneField(controller: _phoneC),
                            const SizedBox(height: 12),
                            _Input(
                              text: 'isi alamat anda',
                              controller: _AlamatC,
                              maxLines: 3,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _Input(
                                    text: 'kota',
                                    controller: _cityC,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _Input(
                                    text: 'provinsi',
                                    controller: _provinceC,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _Input(
                                    text: 'kode pos',
                                    controller: _postalC,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _Input(
                                    text: 'negara',
                                    controller: _countryC,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _TypeSelector(
                              value: _type,
                              onChanged: (v) => setState(() => _type = v),
                            ),
                            const SizedBox(height: 8),
                            _DefaultSwitch(
                              value: _isDefault,
                              onChanged: (v) => setState(() => _isDefault = v),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 320),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AlamatListScreen.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _onSave,
                          child: const Text('Save',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 16,
              top: 12,
              child: _BackCircleButton(
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    // TODO: panggil VM/repository untuk simpan
    Navigator.of(context).maybePop();
  }
}

class _BackCircleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const _BackCircleButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AlamatListScreen.green,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
    );
  }
}

class _Input extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType? keyboardType;

  const _Input({
    required this.text,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: text,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
    );
  }
}

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  const _PhoneField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Prefix +62
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text('+62',
              style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'isi no.telp anda',
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
          ),
        ),
      ],
    );
  }
}

class _TypeSelector extends StatelessWidget {
  final AlamatType value;
  final ValueChanged<AlamatType> onChanged;

  const _TypeSelector({required this.value, required this.onChanged});

  Widget _item({
    required String label,
    required AlamatType type,
    Widget? trailing,
  }) {
    return Builder(builder: (context) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F4F6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: RadioListTile<AlamatType>(
          value: type,
          groupValue: value,
          onChanged: (v) => onChanged(v!),
          title: Text(label),
          activeColor: AlamatListScreen.green,
          controlAffinity: ListTileControlAffinity.trailing,
          secondary: trailing,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _item(label: 'Home', type: AlamatType.home),
        _item(label: 'Store', type: AlamatType.store),
        _item(label: 'Office', type: AlamatType.office),
        _item(
          label: 'Other',
          type: AlamatType.other,
          trailing: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.add, size: 18),
          ),
        ),
      ],
    );
  }
}

class _DefaultSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _DefaultSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SwitchListTile.adaptive(
        value: value,
        onChanged: onChanged,
        title: const Text('Set as default'),
        activeColor: Colors.white,
        activeTrackColor: AlamatListScreen.green,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
