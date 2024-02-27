import 'package:flutter/material.dart';

List<Detail> details = [
  Detail(
    photo: Image.network(
        "https://agricology.co.uk/wp-content/uploads/2020/02/DSC02400.JPG"),
    title: 'Black-grass',
    about:
        'Black-grass is an annual grass weed that can be found in many cereal crops, especially wheat and barley fields. It competes with crops for nutrients, water, and sunlight, reducing yields and quality. Black-grass is difficult to control and can quickly develop resistance to herbicides.',
    methods: '''
    - Herbicides (e.g., flufenacet, pendimethalin)
    - Cultural control (e.g., crop rotation, delayed drilling)
    - Mechanical control (e.g., plowing, harrowing)
    ''',
  ),
  Detail(
    photo: Image.network(
        "https://barmac.com.au/wp-content/uploads/sites/3/2016/01/Charlock.jpg"),
    title: 'Charlock',
    about:
        'Charlock, also known as wild mustard, is a common weed found in arable crops, gardens, and waste areas. It can compete with crops for nutrients and water, reducing yields and quality. Charlock is difficult to control due to its rapid growth and prolific seed production.',
    methods: '''
    - Herbicides (e.g., glyphosate, diflufenican)
    - Cultural control (e.g., crop rotation, tillage)
    - Biological control (e.g., insects, pathogens)
    ''',
  ),
  Detail(
    photo: Image.network(
        "https://i.pinimg.com/originals/83/4a/ea/834aeaa439d55d5685d4ac8d621f451b.jpg"),
    title: 'Cleavers',
    about:
        'Cleavers, also known as bedstraw or goosegrass, is a weed commonly found in agricultural fields, gardens, and waste areas. It can compete with crops for nutrients, water, and sunlight, reducing yields and quality. Cleavers are known for their sticky stems and leaves, which can cling to clothing and machinery.',
    methods: '''
    - Herbicides (e.g., dicamba, 2,4-D)
    - Cultural control (e.g., crop rotation, mulching)
    - Mechanical control (e.g., hand pulling, mowing)
    ''',
  ),
  Detail(
    photo: Image.network(
        "https://plantura.garden/uk/wp-content/uploads/sites/2/2021/11/chickweed-white-flowers.jpg"),
    title: 'Common chickweed',
    about:
        'Common chickweed is a winter annual weed that can be found in many agricultural fields, gardens, and lawns. It competes with crops for nutrients, water, and sunlight, reducing yields and quality. Common chickweed is known for its prostrate growth habit and small white flowers.',
    methods: '''
    - Herbicides (e.g., atrazine, metribuzin)
    - Cultural control (e.g., crop rotation, cover crops)
    - Mechanical control (e.g., hoeing, hand weeding)
    ''',
  ),
  Detail(
    photo: Image.network(
        "https://cdn.wikifarmer.com/wp-content/uploads/2022/06/Weed-Management-in-Wheat-Farming.jpg"),
    title: 'Common wheat',
    about:
        'Common wheat, also known as bread wheat or Triticum aestivum, is a staple cereal crop grown worldwide for its edible grains. It is susceptible to various weeds that can compete for nutrients, water, and sunlight, reducing yields and quality. Common weeds in wheat fields include grasses, broadleaves, and sedges.',
    methods: '''
    - Herbicides (e.g., glyphosate, 2,4-D)
    - Cultural control (e.g., crop rotation, fallow periods)
    - Mechanical control (e.g., mowing, hand weeding)
    ''',
  ),
  Detail(
    photo: Image.network(
        "https://1.bp.blogspot.com/-NGx9_SnuAbs/XipDiYSC5PI/AAAAAAAAEIc/gKmZrJYrz4svrcY3haAvQscsMFdvG8mwwCLcBGAsYHQ/s1600/20200110_100839.jpg"),
    title: 'Fat Hen',
    about:
        'Fat hen, also known as lamb\'s quarters or Chenopodium album, is a common weed found in agricultural fields, gardens, and waste areas. It competes with crops for nutrients, water, and sunlight, reducing yields and quality. Fat hen is known for its white-mealy appearance and prolific seed production.',
    methods: '''
    - Herbicides (e.g., atrazine, metribuzin)
    - Cultural control (e.g., crop rotation, cover crops)
    - Mechanical control (e.g., hoeing, hand weeding)
    ''',
  ),
  Detail(
    photo: Image.network(
        "https://images.ctfassets.net/l2hapltrg3cz/3KXq1jtn5hkZ8XQaldSDdB/198497c177d8de2eb457cc9004907f19/loose_silky-bent_fh.jpg?fm=webp&w=1920&q=85"),
    title: 'Loose Silky-bent',
    about:
        'Loose silky-bent, also known as Alopecurus myosuroides, is a grass weed commonly found in wheat and barley fields. It competes with crops for nutrients, water, and sunlight, reducing yields and quality. Loose silky-bent is known for its tufted appearance and ability to produce large numbers of seeds.',
    methods: '''
    - Herbicides (e.g., flufenacet, pendimethalin)
    - Cultural control (e.g., crop rotation, delayed drilling)
    - Mechanical control (e.g., plowing, harrowing)
    ''',
  ),
  Detail(
    photo: Image.network(
        "https://agritech.tnau.ac.in/agriculture/images/maize/Parthenium%20hysterophorus.jpg"),
    title: 'Maize',
    about:
        'Maize, also known as corn or Zea mays, is a staple cereal crop grown worldwide for its edible grains. It is susceptible to various weeds that can compete for nutrients, water, and sunlight, reducing yields and quality. Common weeds in maize fields include grasses, broadleaves, and sedges.',
    methods: '''
    - Herbicides (e.g., atrazine, mesotrione)
    - Cultural control (e.g., crop rotation, cover crops)
    - Mechanical control (e.g., hoeing, hand weeding)
    ''',
  ),
  Detail(
    photo: Image.network(
        "https://c8.alamy.com/comp/ADPT9K/scentless-mayweed-tripleurospermum-inodorum-matricaria-perforata-cornfield-ADPT9K.jpg"),
    title: 'Scentless Mayweed',
    about:
        'Scentless mayweed, also known as Tripleurospermum inodorum, is a common weed found in agricultural fields, gardens, and waste areas. It competes with crops for nutrients, water, and sunlight, reducing yields and quality. Scentless mayweed is known for its small white flowers and strong odor when crushed.',
    methods: '''
    - Herbicides (e.g., glyphosate, dicamba)
    - Cultural control (e.g., crop rotation, mulching)
    - Mechanical control (e.g., hand pulling, mowing)
    ''',
  ),
  Detail(
    photo: Image.network(
        "https://cdn.mos.cms.futurecdn.net/cBDj5VPspHVRbg2gYX9Ws9.jpg"),
    title: 'Shepherd\'s Purse',
    about:
        'Shepherd\'s purse, also known as Capsella bursa-pastoris, is a common weed found in agricultural fields, gardens, and waste areas. It competes with crops for nutrients, water, and sunlight, reducing yields and quality. Shepherd\'s purse is known for its distinctive heart-shaped seed pods and rapid growth habit.',
    methods: '''
    - Herbicides (e.g., glyphosate, dicamba)
    - Cultural control (e.g., crop rotation, mulching)
    - Mechanical control (e.g., hand pulling, mowing)
    ''',
  ),
  Detail(
    photo: Image.network(
        "https://c8.alamy.com/comp/D09DF3/small-flowered-cranesbill-geranium-pusillum-in-flower-berry-head-D09DF3.jpg"),
    title: 'Small-flowered Cranesbill',
    about:
        'Small-flowered cranesbill, also known as Geranium pusillum, is a common weed found in agricultural fields, gardens, and waste areas. It competes with crops for nutrients, water, and sunlight, reducing yields and quality. Small-flowered cranesbill is known for its small pink or purple flowers and deeply lobed leaves.',
    methods: '''
    - Herbicides (e.g., glyphosate, dicamba)
    - Cultural control (e.g., crop rotation, mulching)
    - Mechanical control (e.g., hand pulling, mowing)
    ''',
  ),
  Detail(
    photo: Image.network(
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRy76prxW-O5GDZLmuV0WId_6MfaDVEEbYWUw&usqp=CAU"),
    title: 'Sugar beet',
    about:
        'Sugar beet, also known as Beta vulgaris subsp. vulgaris, is a root crop grown for sugar production. It is susceptible to various weeds that can compete for nutrients, water, and sunlight, reducing yields and quality. Common weeds in sugar beet fields include grasses, broadleaves, and sedges.',
    methods: '''
    - Herbicides (e.g., glyphosate, ethofumesate)
    - Cultural control (e.g., crop rotation, cover crops)
    - Mechanical control (e.g., hoeing, hand weeding)
    ''',
  ),
];

class Detail {
  final Image photo;
  final String title;
  final String about;
  final String methods;

  Detail({required this.photo, required this.title, required this.about, required this.methods});
}
