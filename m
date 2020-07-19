From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v16 00/22] per memcg lru_lock
Date: Sun, 19 Jul 2020 08:23:14 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.2007190801490.3521@eggly.anvils>
References: <1594429136-20002-1-git-send-email-alex.shi@linux.alibaba.com> <CAKgT0UcKVyTXQ=tGv_uMV+fSvoH_-cuG9zA_zhE+S8Ou11gt=w@mail.gmail.com> <57c619e7-da7e-198e-3de8-530bf19b9450@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-1711634045-1595172209=:3521"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=npp/93Tw/UNG7wuun0xJ8aEfrE13mxMIaC451NaQlRA=;
        b=iIuQudLo0HnETmx/BDnV8c5T1wpkk40S8JmHxCI8QCrihJssRJAoA4LAc1g1Sv56+u
         +7Uxy/PX8+jpIV2AVoY72uTHc9VfxdqUCaKT2s2HX68YF2WAo36dtuzTM+yl+CL2sz9e
         HSymh8fwhiCqjKNOGM8uGrD9VIEoFZQWX+a6PKUM01TVkqgmbiNVzf34s40CFlUfUzVO
         mL7EXsnW9lMe/4KpIgCNUnd0rx5bUokjAI4nM7u67Ctl95KfH40HXALe7bVgFfyqiHAC
         NXqhfuoPNx64Fw6u9wdLe8J4ReWZh2Z+sM6DHwSQ3/RPAMhWcA5sTic67FmHgeSKoCzM
         5Szw==
In-Reply-To: <57c619e7-da7e-198e-3de8-530bf19b9450@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Alexander Duyck <alexander.duyck@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Daniel Jordan <daniel.m.jordan@oracle.com>, Yang Shi <yang.shi@linux.alibaba.com>, Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, kbuild test robot <lkp@intel.com>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, Shakeel Butt <shakeelb@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Wei Yang <richard.weiyang@gmail.com>, "Kirill A. Shutemov" <kirill@shutemov.name>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-1711634045-1595172209=:3521
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 17 Jul 2020, Alex Shi wrote:
> =E5=9C=A8 2020/7/16 =E4=B8=8B=E5=8D=8810:11, Alexander Duyck =E5=86=99=E9=
=81=93:
> >> Thanks for Testing support from Intel 0day and Rong Chen, Fengguang Wu=
,
> >> and Yun Wang. Hugh Dickins also shared his kbuild-swap case. Thanks!
> > Hi Alex,
> >=20
> > I think I am seeing a regression with this patch set when I run the
> > will-it-scale/page_fault3 test. Specifically the processes result is
> > dropping from 56371083 to 43127382 when I apply these patches.
> >=20
> > I haven't had a chance to bisect and figure out what is causing it,
> > and wanted to let you know in case you are aware of anything specific
> > that may be causing this.
>=20
>=20
> Thanks a lot for the info!
>=20
> Actually, the patch 17th, and patch 13th may changed performance a little=
,
> like the 17th, intel LKP found vm-scalability.throughput 68.0% improvemen=
t,
> and stress-ng.remap.ops_per_sec -76.3% regression, or stress-ng.memfd.ops=
_per_sec
>  +23.2%. etc.
>=20
> This kind performance interference is known and acceptable.

That may be too blithe a response.

I can see that I've lots of other mails to reply to, from you and from
others - I got held up for a week in advancing from gcc 4.8 on my test
machines. But I'd better rush this to you before reading further, because
what I was hunting the last few days rather invalidates earlier testing.
And I'm glad that I held back from volunteering a Tested-by - though,
yes, v13 and later are stable where the older versions were unstable.

I noticed that 5.8-rc5, with lrulock v16 applied, took significantly
longer to run loads than without it applied, when there should have been
only slight differences in system time. Comparing /proc/vmstat, something
that stood out was "pgrotated 0" for the patched kernels, which led here:

If pagevec_lru_move_fn() is now to TestClearPageLRU (I have still not
decided whether that's good or not, but assume here that it is good),
then functions called though it must be changed not to expect PageLRU!

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/swap.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- 5.8-rc5-lru16/mm/swap.c=092020-07-15 21:03:42.781236769 -0700
+++ linux/mm/swap.c=092020-07-18 13:28:14.000000000 -0700
@@ -227,7 +227,7 @@ static void pagevec_lru_move_fn(struct p
=20
 static void pagevec_move_tail_fn(struct page *page, struct lruvec *lruvec)
 {
-=09if (PageLRU(page) && !PageUnevictable(page)) {
+=09if (!PageUnevictable(page)) {
 =09=09del_page_from_lru_list(page, lruvec, page_lru(page));
 =09=09ClearPageActive(page);
 =09=09add_page_to_lru_list_tail(page, lruvec, page_lru(page));
@@ -300,7 +300,7 @@ void lru_note_cost_page(struct page *pag
=20
 static void __activate_page(struct page *page, struct lruvec *lruvec)
 {
-=09if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
+=09if (!PageActive(page) && !PageUnevictable(page)) {
 =09=09int lru =3D page_lru_base_type(page);
 =09=09int nr_pages =3D hpage_nr_pages(page);
=20
@@ -357,7 +357,8 @@ void activate_page(struct page *page)
=20
 =09page =3D compound_head(page);
 =09lruvec =3D lock_page_lruvec_irq(page);
-=09__activate_page(page, lruvec);
+=09if (PageLRU(page))
+=09=09__activate_page(page, lruvec);
 =09unlock_page_lruvec_irq(lruvec);
 }
 #endif
@@ -515,9 +516,6 @@ static void lru_deactivate_file_fn(struc
 =09bool active;
 =09int nr_pages =3D hpage_nr_pages(page);
=20
-=09if (!PageLRU(page))
-=09=09return;
-
 =09if (PageUnevictable(page))
 =09=09return;
=20
@@ -558,7 +556,7 @@ static void lru_deactivate_file_fn(struc
=20
 static void lru_deactivate_fn(struct page *page, struct lruvec *lruvec)
 {
-=09if (PageLRU(page) && PageActive(page) && !PageUnevictable(page)) {
+=09if (PageActive(page) && !PageUnevictable(page)) {
 =09=09int lru =3D page_lru_base_type(page);
 =09=09int nr_pages =3D hpage_nr_pages(page);
=20
@@ -575,7 +573,7 @@ static void lru_deactivate_fn(struct pag
=20
 static void lru_lazyfree_fn(struct page *page, struct lruvec *lruvec)
 {
-=09if (PageLRU(page) && PageAnon(page) && PageSwapBacked(page) &&
+=09if (PageAnon(page) && PageSwapBacked(page) &&
 =09    !PageSwapCache(page) && !PageUnevictable(page)) {
 =09=09bool active =3D PageActive(page);
 =09=09int nr_pages =3D hpage_nr_pages(page);

--0-1711634045-1595172209=:3521--
