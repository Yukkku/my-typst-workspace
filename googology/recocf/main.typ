#set text(font: "Source Han Serif", lang: "ja");
#show raw: set text(font: "Source Han Mono");

#let mtxt(c) = math.text(font: "Source Han Serif", c);

#align(center)[
  #text(size: 1.5em)[*非再帰順序数を生成する順序数崩壊関数*]\
  2026-11-10#h(2em)Yukkku
]

= はじめに

変な順序数崩壊関数とその周辺のアイデアを思いつき, 数ヶ月くらい構想を練っていました.
とりあえず形にしたので上げます

これから定義するシステムの気持ちとして, まず拡張ブーフホルツの$psi$関数はおおざっぱに以下のように定義されています
#block(stroke: (left: 1pt), inset: (y: 0.5em, left: 1em))[
  $psi_alpha (beta)=$定義域を制限した$psi$と加法で表現できない最小の順序数
]
一方, ここで定義する"非再帰的$psi$関数"はおおざっぱに以下のように定義されます
#block(stroke: (left: 1pt), inset: (y: 0.5em, left: 1em))[
  $psi_alpha (beta)=$定義域を制限した$psi$と*全ての再帰的な演算*(未定義の概念)で表現できない最小の順序数
]

"おおざっぱに"と書いたようにこの定義は厳密な定義とは一致しませんが, この方針で定義された非再帰的$psi$関数は各種非再帰順序数を生成できるようになっていると期待します

= 簡易版定義

#let syon(c) = $lr(chevron.l.double#c chevron.r.double)$
#let interpret = math.mono("interpret");
#let Com = math.serif("Com");

コンビネータ計算を用いる. $S K I$コンビネータの$S, K$に加えて, これから定義する$Z$と, 順序数$alpha$毎にコンビネータ$syon(alpha),Psi^(<alpha)$を導入する.
これらのコンビネータを組み合わせて作れるコンビネータ全体を$Com$と書く

関数$interpret:Com->"On"union{bot}$を以下のように定める
- 任意の$a in Com$について,
  - $a$を簡約して最終的に$syon(beta)$になったとき, $interpret[a]=beta$
  - そのようにならないとき, $interpret[a]=bot$

各コンビネータの振舞いは以下のように定める
$
             S= & lambda a b c. a c(b c) \
             K= & lambda a b. a \
   syon(alpha)= & lambda f. cases(
                    syon(sup{interpret[f syon(beta)]+1 mid(|)beta in alpha})#h(2em) & "if" forall beta in alpha:interpret[f syon(beta)]!=bot,
                    "undefined" & "otherwise",
                  ) \
             Z= & lambda a b c. cases(
                    b & "if" interpret[a]=0,
                    c & "if" interpret[a]in"On"without{0},
                    "undefined"#h(2em) & "otherwise",
                  ) \
  Psi^(<alpha)= & lambda b c. cases(
                    psi_interpret[b] (interpret[c])#h(2em) & "if" interpret[b]!=bot\,interpret[c]in alpha,
                    "undefined" & "otherwise",
                  )
$

関数$psi:"On"times"On"->"On"$を以下のように定義する
$
  psi_alpha (0) & =Omega_alpha \
  psi_alpha (beta+1) & =min{gamma in"On"mid(|){S,K,Z,Psi^(<beta+1)}union{syon(delta)mid(|)delta in Omega_alpha}#mtxt[の組合せで]syon(gamma)#mtxt[を作れない]} \
  psi_alpha (beta) & =sup{psi_alpha (gamma)mid(|)gamma in beta}#h(2em) (beta#mtxt[が極限順序数のとき]) \
$

= 定義

== 前準備

- 弱到達不能基数の存在を仮定し, 最小の弱到達不能基数を$II$と書く
- 適当な関数$f$の$n$回反復合成を$f^n$と表す
- 乗算記号$times$は常に集合の直積を表す. 順序数演算として用いることは無い
- $Omega:"On"->"On"$は以下のように定義される
  $
    Omega_alpha=cases(
      1 & "if" alpha=0,
      aleph_alpha #h(2em) & "if" alpha>0
    )
  $

== コンビネータ

以下のいずれかに当てはまる記号列をコンビネータと呼び, コンビネータ全体の集合を$Com$と書く
- 記号$S, K, Z, Psi$
- 任意の$alpha in II$について, $syon(alpha)$
- 任意の$a,b in Com$について, $(a b)$

任意の$alpha in II$について, 以下のいずれかに当てはまるコンビネータ全体の集合を$Com_alpha$と書く
- 記号$S, K, Z, Psi$
- 任意の$beta in Omega_alpha$について, $syon(beta)$
- 任意の$a,b in Com_alpha$について, $(a b)$

== 計算

以下, コンビネータの括弧との混同を防ぐため, 関数適用の括弧を角括弧$[#h(0.5em)]$で書くことにする

#let apply = math.mono("apply");
関数
$
  apply:(Com->II union{bot})times Com & ->Com \
                                (f,a) & |->apply_f [a] \
$
を以下のように定義する
#block(stroke: (left: 1pt), inset: (y: 0.5em, left: 1em))[
  任意の$f: Com->II union{bot}$について,
  - 任意の$a,b,c in Com$について, $apply_f [(((S a)b)c)]=((a c)(b c))$
  - 任意の$a,b in Com$について, $apply_f [((K a)b)]=a$
  - 任意の$a in Com$について, $f[a]!=bot$なら,
    - もし$f[a]=0$なら, $apply_f [(Z a)]=K$
    - もし$f[a]!=0$なら, $apply_f [(Z a)]=(S K)$
  - 任意の$a,b in Com$について, $f[a]!=bot,f[a]!=bot,f[((Psi syon(f[a]))syon(f[b]))]!=bot$なら,\
    - $apply_f [((Psi a)b)]=syon(f[((Psi syon(f[a]))syon(f[b]))])$
  - 任意の$alpha in II,g in Com$について, 任意の$beta in alpha$について$f[(g syon(beta))]!=bot$なら,\
    - $apply_f [(syon(alpha)g)]=syon(sup{f[(g syon(beta))]+1mid(|)beta in alpha})$
  - 上記のいずれにも当てはまらないなら, 任意の$a,b in Com$について,
    - $apply_f [(a b)]=(apply_f [a] b)$
  - 上記のいずれにも当てはまらないなら, 任意の$a in Com$について, $apply_f [a]=a$
]

#pagebreak()

== 閉包

#let closure = math.mono("closure");
関数
$
  closure:(II+1) times(Com->II union{bot})times Com & ->II union{bot} \
                                        (alpha,f,c) & |->closure_alpha [f,c] \
$
を以下のように定義する. 以下, $closure_alpha [f]=(c|->closure_alpha [f,c])$とする
#block(stroke: (left: 1pt), inset: (y: 0.5em, left: 1em))[
  任意の$f:Com->II union{bot},c:Com$について,
  - $closure_0[f,c]=f[c]$
  - 任意の$alpha in II$について,
    - ある$n in omega,beta in II$が存在して$apply^n_(closure_alpha [f])[c]=syon(beta)$なら, $closure_(alpha+1)[f,c]=beta$
    - そうでないなら, $closure_(alpha+1)[f,c]=closure_alpha [f,c]$
  - 任意の$alpha in II+1$について, $alpha$が極限順序数のとき,
    - $beta in alpha$が存在して$closure_beta [f,b]!=bot$なら, $closure_alpha [f,b]=closure_beta [f,b]$
    - そうでないなら, $closure_alpha [f,c]=f[c]$
]

$closure_II [f,c], closure_II [f]$を, それぞれ$closure[f,c], closure[f]$と書く

== 順序数崩壊関数

関数$h:(II+1)times Com->Com union{bot},psi:II times(II+1)->II$を以下のように定義する
$
          h_beta [c] & =cases(
                         psi_gamma (delta)#h(2em) & "if" #mtxt[ある]gamma in II\,delta in beta#mtxt[が存在して]c=((Psi syon(gamma))syon(delta)),
                         bot & "otherwise"
                       ) \
       psi_alpha (0) & =Omega_alpha \
  psi_alpha (beta+1) & =min{gamma in II mid(|)forall c in Com_alpha: closure[h_(beta+1),c]!=gamma} \
    psi_alpha (beta) & =sup{psi_alpha (gamma)mid(|)gamma in beta}#h(2em) (beta#mtxt[が極限順序数のとき]) \
$

== おまけ

関数$interpret:Com->II union{bot}$を$interpret=closure[h_II]$と定義する

= 補足/解説

- $II$の存在を仮定しているのは, "クラスが集合になるか"等の本質とは関係のない議論を避けるためです. 順序数のクラス$"On"$の代わりに使用しています
- $psi$の挙動が極限順序数で場合分けされているのは, これが無いと極限が保存されなくて分かりにくくなるからです

= 評価

"私の想定通りに定義ができている"という願望込みで具体的な値を評価します. (願望込みなので論理展開が厳密じゃないです. 明確な欠陥あったら教えて)
- コンビネータの括弧は左結合で適度に省略します
- $S$と$K$の表現能力に頼ってラムダ式$lambda x. (...)$や再帰的な定義を使います

== 補題

ちゃんとした証明を書こうとしたら大変なことになったので証明の概要だけ書きます

=== 補題1
#block(stroke: (left: 1pt), inset: (y: 0.5em, left: 1em))[
  任意の$alpha,beta in II without{0}$と$f in Com$について,
  - $alpha<=beta$
  - $interpret[f syon(alpha)]!=bot$
  - $interpret[f syon(beta)]!=bot$
  なら, $interpret[f syon(alpha)]<=interpret[f syon(beta)]$
]

コンビネータの表現能力によりこれは"適当なコンビネータが持ついくつかの順序数コンビネータを, より大きいものに置き換えると全体の値は小さくならない"のように言い換えられます.

で, コンビネータの計算は超限帰納法によって定義したため, これが偽なら「最初の反例」が存在するはずで, 順序数を生成するパターンを全部試せばどれも最初の反例になり得ないと示せます

=== 補題2

#block(stroke: (left: 1pt), inset: (y: 0.5em, left: 1em))[
  任意の$alpha in II, f in Com$について, $interpret[syon(alpha)f]!=bot$なら,\
  $ "cf"(interpret[syon(alpha)f])in{1,"cf"(alpha)} $
]

$beta=interpret[syon(alpha)f]$とします. $"cf"(beta)!=1$なら, 順序数コンビネータの定義にある$+1$の部分によって, $f$が$beta$で非有界に振る舞うことが保証されます. 補題1で示した単調性から, このとき$"cf"(alpha)$が$"cf"(beta)$より大きく小さくても矛盾すると言うことができます

== $psi_alpha (0)$の値

$psi_alpha (0)=Omega_alpha$です. 定義から明らかです

== $psi_0(1)$の値

$psi_0(1)=omega$になります
- $Psi syon(0)syon(0)$から$syon(1)$を得られ, 後者関数$lambda x. syon(1)(K x)$で任意の有限順序数を構成できるため, $psi_0(1)>=omega$です
- 補題2により$syon(omega)$が得られないため, $psi_0(1)<=omega$です

== $psi_0 (2)$の値

$psi_alpha (2)=omega_1^"CK"$と予想しますが, 私の数学力では上から抑えられませんでした.
とりあえず, $psi_alpha (2)>=omega_1^"CK"$を示します

コンビネータによる以下のような順序数表現を$S$と$K$で構成することを考えます
$
        {0} & =lambda x y z. x \
  {alpha+1} & =lambda x y z. y {alpha} \
    {alpha} & =lambda x y z. z (lambda n. {alpha[n]})#h(2em) (alpha#mtxt[が極限順序数のとき]) \
$
ただし, $alpha[n]$は基本列で, $n$もこの順序数表現によって与えられます.
コンビネータの表現能力によって$S$と$K$で$omega_1^"CK"$未満の順序数の表現を作ることができます

さて, ${alpha}$を$syon(alpha)$に変換することを考えます. $Y$を不動点コンビネータとして, 以下のようにできます
$
     "Succ"= & lambda v. (lambda x y z. y v) \
  "Convert"= & lambda a. a \
             & #h(2em)syon(0) \
             & #h(2em) (lambda b. syon(1)(K("Convert" b))) \
             & #h(2em) (lambda f. syon(omega)((Y(lambda g h x. Z x \
             & #h(4em) ("Convert"(h{0})) \
             & #h(4em) (x(g(lambda c. h("Succ" c)))) \
             & #h(2em)))f)) \
$
こうやって$S$と$K$で表現した順序数表現を順序数コンビネータに変換してやることで, $omega_1^"CK"$未満の任意の順序数を作ることができます

= 想定動作

ここからは願望$10$割で想定する挙動を書きます

以下$omega_alpha^"CK"$を$"CK"(alpha)$と書きます. また, 最小の$"CK"$の不動点を$"CKFP"$と書きます

#table(
  columns: (auto, 1fr),
  $psi_0(0)$, $1$,
  $psi_0(1)$, $omega$,
  $psi_0(2)$, $"CK"(1)$,
  $psi_0(3)$, $"CK"(2)$,
  $psi_0(4)$, $"CK"(3)$,
  $psi_0(omega)$, $"CK"(omega)$,
  $psi_0(omega+1)$, $"CK"(omega+1)$,
  $psi_0("CKFP")$, $"CKFP"$,
  $psi_0("CKFP"+1)$, $"CK"("CKFP"+1)$,
  $psi_1(0)$, $Omega$,
  $psi_0(Omega)$, [最小の再帰的到達不能順序数],
  $psi_0(Omega+1)$, $"CK"(psi_0(Omega)+1)$,
  $psi_0(Omega 2)$, [$2$番目の再帰的到達不能順序数],
  $psi_0(Omega omega)$, $sup{psi_0(Omega n)mid(|)n in omega}$,
  $psi_0(Omega^2)$, [最小の$1$-再帰的到達不能順序数],
  $psi_0(Omega^2+Omega)$, [$psi_0(Omega^2)+1$番目の再帰的到達不能順序数],
  $psi_0(Omega^3)$, [最小の$2$-再帰的到達不能順序数],
  $psi_0(Omega^omega)$, $sup{psi_0(Omega^n)mid(|)n in omega}$,
  $psi_0(Omega^Omega)$, [最小のhyper-再帰的到達不能順序数],
  $psi_0(Omega^Omega+Omega^(psi_0(Omega^Omega)+1))$, [$2$番目の$psi_0(Omega^Omega)$-再帰的到達不能順序数],
  $psi_0(Omega^(Omega+1))$, [最小の$1$-hyper-再帰的到達不能順序数],
  $psi_0(Omega^(Omega 2))$, [最小のhyper-hyper-再帰的到達不能順序数],
  $psi_1(1)$, $"CK"(Omega+1)$,
  $psi_0(psi_1(1))$, [最小の再帰的マーロ順序数],
  $psi_0(psi_1(1)+Omega)$, [$psi_0(psi_1(1))+1$番目の再帰的到達不能順序数],
  $psi_0(psi_1(1)2)$, [$2$番目の再帰的マーロ順序数],
  $psi_0(psi_1(1)omega)$, $sup{psi_0(psi_1(1)n)mid(|)n in omega}$,
  $psi_0(psi_1(1)Omega)$, [再帰的マーロ順序数の極限の中で最小の許容順序数],
  $psi_0(psi_1(1)^2)$, [最小の$1$-再帰的マーロ順序数],
  $psi_0(psi_1(1)^3)$, [最小の$2$-再帰的マーロ順序数],
  $psi_0(psi_1(1)^Omega)$, [任意の$beta in alpha$で$beta$-再帰的マーロである最小の許容順序数$alpha$],
  $psi_0(psi_1(1)^(psi_1(1)))$, [最小のhyper-再帰的マーロ順序数],
  $psi_1(2)$, $"CK"(Omega+2)$,
  $psi_0(psi_1(2))$, [最小の再帰的コンパクト順序数],
  $psi_0(psi_1(3))$, [最小の$Pi^0_4$-反映順序数],
  $psi_0(psi_1(4))$, [最小の$Pi^0_5$-反映順序数],
)

= 対角化

ご覧のように, $psi$は巨大な非再帰順序数を生成します. $Com_0$の要素で, このシステム限界である$psi_0(II)$未満の任意の順序数を表現でき, 更に$Com_0$には自然数のゲーデル数を振ることができます

...もうお分かりですね? コンビネータを使って$psi_0(II)$未満の順序数に基本列を定めてFGHに入れます

== 定義

#let code = math.mono("code")
関数$code: Com_0->omega$を以下のように定義する. これは全単射になる
#block(stroke: (left: 1pt), inset: (y: 0.5em, left: 1em))[
  関数$"pair":omega times omega->omega$を$display("pair"(a,b)=((a+b)(a+b+1))/2+a)$と定義する. これは全単射になる
  - $code[syon(0)]=0$
  - $code[S]=1$
  - $code[K]=2$
  - $code[Z]=3$
  - $code[Psi]=4$
  - 任意の$a,b in Com_0$について, $code[(a b)]="pair"(code[a],code[b])+5$
]
$code$の逆関数を$code^(-1)$と書く. $interpret[code^(-1)(n)]$を$interpret'(n)$と書く

#let select = math.mono("select")
$select:II times II->II$を以下のように定義する
#block(stroke: (left: 1pt), inset: (y: 0.5em, left: 1em))[
  任意の$alpha,beta in II$について,
  - $A={n mid(|)n in omega,interpret'(n)!=bot,alpha<interpret'(n)<beta}$とする
  - もし, $A!=emptyset$なら, $select(alpha, beta)=interpret'(min(A))$
  - もし, $A=emptyset$なら, $select(alpha, beta)=alpha$
]
#let index = math.mono("index")
$index:II times omega->II$を以下のように定義する
#block(stroke: (left: 1pt), inset: (y: 0.5em, left: 1em))[
  任意の$alpha in II$について,
  - $index(alpha, 0)=0$
  - 任意の$n in omega$について, $index(alpha, n+1)=select(index(alpha, n), alpha)$
]

$f:II times omega->omega$を以下のように定義する

$
          f_0(n) & =n+1 \
  f_(alpha+1)(n) & =f_alpha^n (n) \
     f_alpha (n) & =f_index(alpha, n) (n)#h(2em) (alpha#mtxt[が極限順序数のとき]) \
$

"非再帰的$psi$限界数"を$f_(psi_0(II)+1) (10^10^100)$と定義する

= 展望

- 順序数崩壊関数を強くする方法として, 巨大基数を導入してそれを崩壊させる, という方法があります
- 大抵の順序数崩壊関数は, 基数の代わりにその再帰的類似を用いても同じ強さのものを作ることができます
- 非再帰的$psi$は各種巨大基数の再帰的類似を生成することができると予想されます

という訳で, 非再帰的$psi$関数で生成した巨大基数の再帰的類似を更に崩壊させることで巨大な再帰順序数を作ることができると予想できます. いつかやります
