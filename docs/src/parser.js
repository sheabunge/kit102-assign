'use strict';

class ParseError extends Error {
	constructor(message) {
		super();
		this.message = message;
	}
}

export class Attribute {

	constructor(name) {
		this.name = name;
		this.primary_key = false;
		this.foreign_key = false;
		this.foreign_key_n = 0;
	}

	toString() {
		let result = this.name;

		if (this.foreign_key) {
			result += ' [fk' + (this.foreign_key_n === 0 ? '' : this.foreign_key_n.toString()) + ']';
		}

		return result;
	}
}

export class Relation {

	constructor(name) {
		this.name = name;
		this.attributes = [];
		this.primary_keys = [];
		this.foreign_keys = [];
	}

	add_attribute(attribute) {

		if (attribute.foreign_key) {
			if (this.foreign_keys.length === 1) {
				this.foreign_keys[0].foreign_key_n = 1;
			}

			if (this.foreign_keys.length !== 0) {
				attribute.foreign_key_n = this.foreign_keys.length + 1;
			}

			this.foreign_keys.push(attribute);
			console.log(attribute);
		}

		if (attribute.primary_key) {
			this.primary_keys.push(attribute);
		} else {
			this.attributes.push(attribute);
		}
	}

	toFormattedString() {
		let pk = '';
		let sep = '<span class="relation-sep">,</span> ';

		let wrapAttribute = (att) => {
			return `<span class="relation-attribute${att.foreign_key ? ' relation-fk' : ''}">${att.toString()}</span>`
		};

		for (let att of this.primary_keys) {
			pk += wrapAttribute(att) + sep;
		}

		let tuple = [];
		for (let att of this.attributes) {
			tuple.push(wrapAttribute(att));
		}

		return '<code class="relation">' +
			`<span class="relation-name">${this.name}</span>` +
			'<span class="relation-tuple">' +
				'<span class="relation-open–tuple">(</span>' +
				`<span class="relation-pk">${pk}[pk]</span>${tuple.length ? ' ' : ''}${tuple.join(sep)}` +
				'<span class="relation-close–tuple">)</span>' +
			'</span>' +
			'</code>';
	}
}

export class SchemaParser {

	constructor(data) {
		this.data = data;
		this.size = data.length;
		this.pointer = 0;
		this.relation = null;
	}

	parse() {

		try {
			this._parse();

		} catch (error) {
			if (!(error instanceof ParseError)) {
				throw error;
			}

			console.log(error.message);
		}

		return this.relation;
	}

	_parse() {

		let relation_name = this.read(/[A-Z]+/)[0];
		this.relation = new Relation(relation_name);

		this.read(/\(/);

		const FK_RE = /\[fk\d?]/;
		const PK_RE = /\[pk]/;
		const ATT_RE = /\w+/;

		while (!this.try_read(PK_RE)) {
			let m = this.read(ATT_RE);
			let attribute = new Attribute(m[0]);
			attribute.primary_key = true;

			if (this.try_read(FK_RE)) {
				attribute.foreign_key = true;
			}

			this.read(/,/);
			this.relation.add_attribute(attribute);
		}

		while (!this.try_read(/\)/)) {
			let m = this.read(ATT_RE);
			let attribute = new Attribute(m[0]);

			if (this.try_read(FK_RE)) {
				attribute.foreign_key = true;
			}

			this.try_read(/,/);
			this.relation.add_attribute(attribute);
		}
	}

	end() {
		return this.pointer === this.size;
	}

	remaining() {
		return this.data.substr(this.pointer);
	}

	eat_whitespace() {
		let m = this.remaining().match(/^\s+/);

		if (m) {
			this.pointer += m[0].length;
		}
	}

	try_read(pattern) {
		let result = this.peek(pattern);

		if (result) {
			this.pointer += result[0].length;
			this.eat_whitespace();
		}

		return result;
	}

	peek(pattern) {
		pattern = new RegExp('^' + pattern.source);
		return this.remaining().match(pattern);
	}

	read(pattern) {
		let result = this.peek(pattern);

		if (!result) throw new ParseError('invalid match ' + pattern + ' of ' + this.remaining());

		this.pointer += result[0].length;
		this.eat_whitespace();

		return result;
	}
}
