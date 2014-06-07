    var MeCab = new require('mecab-async')
      , mecab = new MeCab()
    ;
    mecab.parse('いつもニコニコあなたの隣に這い寄る混沌ニャルラトホテプです！', function(err, result) {
        if (err) throw err;
        console.log(result);
    });
