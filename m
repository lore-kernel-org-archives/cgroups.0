From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v13 00/18] per memcg lru lock
Date: Sun, 21 Jun 2020 23:44:47 +0800
Message-ID: <5561f72b-8f9a-f84e-94a4-600c66084f29@linux.alibaba.com>
References: <1592555636-115095-1-git-send-email-alex.shi@linux.alibaba.com>
 <20200620160807.0e0997c3e0e3ca1b18e68a53@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200620160807.0e0997c3e0e3ca1b18e68a53-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org



=D4=DA 2020/6/21 =C9=CF=CE=E77:08, Andrew Morton =D0=B4=B5=C0:
> On Fri, 19 Jun 2020 16:33:38 +0800 Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRq=
YAgC/G2K4zDHf@public.gmane.org> wrote:
>=20
>> This is a new version which bases on linux-next, merged much suggestion
>> from Hugh Dickins, from compaction fix to less TestClearPageLRU and
>> comments reverse etc. Thank a lot, Hugh!
>>
>> Johannes Weiner has suggested:
>> "So here is a crazy idea that may be worth exploring:
>>
>> Right now, pgdat->lru_lock protects both PageLRU *and* the lruvec's
>> linked list.
>>
>> Can we make PageLRU atomic and use it to stabilize the lru_lock
>> instead, and then use the lru_lock only serialize list operations?
>=20
> I don't understand this sentence.  How can a per-page flag stabilize a
> per-pgdat spinlock?  Perhaps some additional description will help.

Hi Andrew,

Well, above comments miss a context, which lru_lock means new lru_lock on e=
ach
of memcg not the current per node lru_lock. Sorry!

Currently the lru bit changed under lru_lock, so isolate a page from lru ju=
st
need take lru_lock. New patch will change it with a atomic action alone fro=
m=20
lru_lock, so isolate a page need both actions: TestClearPageLRU and take the
lru_lock. like followings in isolate_lru_page():

The main reason for this comes from isolate_migratepages_block() in compact=
ion.c
we have to take lru bit before lru lock, that serialized the page isolation=
 in=20
memcg page charge/migration which will change page's lruvec and new lru_lock
in it. The current isolation just take lru lock directly which fails on gua=
rd=20
page's lruvec change(memcg change).

changes in isolate_lru_page():-	if (PageLRU(page)) {
+	if (TestClearPageLRU(page)) {
 		pg_data_t *pgdat =3D page_pgdat(page);
 		struct lruvec *lruvec;
+		int lru =3D page_lru(page);
=20
-		spin_lock_irq(&pgdat->lru_lock);
+		get_page(page);
 		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
-		if (PageLRU(page)) {
-			int lru =3D page_lru(page);
-			get_page(page);
-			ClearPageLRU(page);
-			del_page_from_lru_list(page, lruvec, lru);
-			ret =3D 0;
-		}
+		spin_lock_irq(&pgdat->lru_lock);
+		del_page_from_lru_list(page, lruvec, lru);
 		spin_unlock_irq(&pgdat->lru_lock);
+		ret =3D 0;
 	}

>=20

>>
>> Following Daniel Jordan's suggestion, I have run 208 'dd' with on 104
>> containers on a 2s * 26cores * HT box with a modefied case:
>> https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git/t=
ree/case-lru-file-readtwice
>>
>> With this patchset, the readtwice performance increased about 80%
>> in concurrent containers.
>>
>> Thanks Hugh Dickins and Konstantin Khlebnikov, they both brought this
>> idea 8 years ago, and others who give comments as well: Daniel Jordan,=20
>> Mel Gorman, Shakeel Butt, Matthew Wilcox etc.
>>
>> Thanks for Testing support from Intel 0day and Rong Chen, Fengguang Wu,
>> and Yun Wang. Hugh Dickins also shared his kbuild-swap case. Thanks!
>>
>> ...
>>
>>  24 files changed, 500 insertions(+), 357 deletions(-)
>=20
> It's a large patchset and afaict the whole point is performance gain.=20
> 80% in one specialized test sounds nice, but is there a plan for more
> extensive quantification?

Once I got 5% aim7 performance gain on 16 cores machine, and about 20+%
readtwice performance gain. the performance gain is increased a lot followi=
ng
larger cores.

Is there some suggestion for this?

>=20
> There isn't much sign of completed review activity here, so I'll go
> into hiding for a while.
>=20

Yes, it's relatively big. also much of change from comments part. :)
Anyway, thanks for look into!

Thanks
Alex
