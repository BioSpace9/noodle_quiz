/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Firebase SDKをインポート
const admin = require('firebase-admin');

// Firebaseの初期化
admin.initializeApp({
// ここにFirebaseの設定を記述
});

// Firestoreのインスタンスを取得
const db = admin.firestore();

// ドキュメントを追加する関数
async function addQuizDocuments() {
const quizCollection = db.collection('quiz');

for (let i = 0; i < 10; i++) {
await quizCollection.add({
name: '', // String
region: '', // String
type: '', // String
opt1: '', // String
opt2: '', // String
opt3: '', // String
comment: '', // String
image: '', // String
createdDate: admin.firestore.Timestamp.now() // Timestamp
});
}

console.log('10 documents added to the quiz collection.');
}

// 関数の実行
addQuizDocuments();

*/