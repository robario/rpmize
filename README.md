rpmize
======
Build rpm more easily, inspired by checkinstall.

usage
=====

    $ curl http://ftp.gnu.org/gnu/hello/hello-2.8.tar.gz | tar zxvf -
    $ cd ./hello-2.8
    $ /path/to/rpmize

You should complete only build sections(%prep, %build and %install) via $EDITOR.

    1 %install
    2 %{configure}
    3 %{makeinstall}

After you save the above written, a spec file will be shown.
The %description section contains a meta data for the next packaging time.
You can modify the spec at this timing.
However you should not change the meta data and build sections.
And you should not put anything into %files section.

Next, rpmiz run the install process and complete the spec file, automatically.
You will see %files section is filled via $EDITOR.

Last, rpmiz package a rpm to your %{_rpmdir}.

topic
=====
checkinstallの問題点
- rootで実行するのが嫌。修正して使ってみたけどやはり限界。
- doc-pakが作られてしまう（perlのテストに失敗する）description-pakも作られてしまう。ゴミが残る。
- 結局色々オプションを付けないといけない
- 古めのautotoolsに対応できてない（気がする）し、そもそもautotoolsじゃない場合に対応できてない（気がする）

TODO
- prefixをオプション指定できるようにする
- trap 'rm -rf ゴミファイル ; exit $?' EXIT SIGHUP SIGINT SIGTERM
- エラー時に止まるようにする＆途中で止められるようにする
- 取れるqueryformatを全て取って埋める
- ソースディレクトリを汚さないようにする
- より新しいname,version,releaseである未インストールの
  $(rpm --eval '%{_rpmdir}')/$(uname --machine)/${name}-*-*.*.rpm
  が存在すれば、version,release以外をそっちから持ってくる
- searching rpmforge

  ```
  temp=$(mktemp --suffix=.spec)
  curl --location --output ${temp} "https://raw.github.com/repoforge/rpms/master/specs/${package}/${package}.spec"
  summary="$(grep '^Summary:' ${temp} | sed 's,^Summary: *,,')"
  license="$(grep '^License:' ${temp} | sed 's,^License: *,,')"
  description=$(awk '/%description/,/%prep/{print}' "${temp}" | head --lines=-1 | grep --invert-match '^%description')
  rm --force ${temp}
  ```
