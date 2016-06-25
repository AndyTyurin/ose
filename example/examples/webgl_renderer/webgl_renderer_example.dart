import 'dart:html';
import 'dart:web_gl';
import 'dart:typed_data';
import 'dart:async';

import 'package:ose/ose.dart';

void main() {

	// Create renderer.
	WebGLRenderer renderer = new WebGLRenderer(
		width: document.documentElement.clientWidth,
		height: document.documentElement.clientHeight
	);

	// Start renderer.
	renderer.start();
}