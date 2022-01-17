---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults
permalink: /
layout: home
---

This is the set of entries that we based our results on:
(This list as `.csv`, the literature as `.bib` and more details on the literature analysis can be found in the [base repository](https://github.com/r0light/qualitymodel-validations-review) of this site.)

<table class="literature">
  {% for row in site.data.final-set %}
    {% if forloop.first %}
    <tr>
      {% for pair in row %}
        <th>{{ pair[0] }}</th>
      {% endfor %}
    </tr>
    {% endif %}

    {% tablerow pair in row %}
      {{ pair[1] }}
    {% endtablerow %}
  {% endfor %}
</table>