'use strict';

import {SchemaParser} from './parser';

(function () {
	const areas = document.querySelectorAll('.schema');

	for (const area of areas) {
		let final = [];
		const lines = area.innerHTML.trim().split('\n');

		for (let line of lines) {
			line = line.trim();

			if (!line) {
				final.push('<br>');
				continue;
			}

			const parser = new SchemaParser(line);
			let relation = parser.parse();
			final.push(relation.toFormattedString());
		}

		area.innerHTML = final.join('\n');
	}
})();
