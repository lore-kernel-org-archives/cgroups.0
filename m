From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: update page struct member in comments
Date: Sat, 7 Nov 2020 21:34:15 +0800
Message-ID: <1491c150-1cc0-6062-08ea-9c891548a3bc@linux.alibaba.com>
References: <1604662413-5734-1-git-send-email-alex.shi@linux.alibaba.com>
 <20201106205140.GA2285866@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20201106205140.GA2285866-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



=D4=DA 2020/11/7 =C9=CF=CE=E74:51, Roman Gushchin =D0=B4=B5=C0:
> There are "page and memcg binding" and "page's memcg" used in similar cas=
es,
> I think it's more obvious than "page_memcg(page) being stable".
>=20
> Maybe it helps to address Ira's comment.
>=20
> Anyway, please feel free to add:
> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
>=20
> Thanks!

Thanks a lot! Roman.
here is the updated patch with your suggestion and ack.


From 0db2bd8f3833ec5e58c6978f771b05e4902e5156 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Date: Fri, 6 Nov 2020 19:33:33 +0800
Subject: [PATCH v2] mm/memcg: update page struct member in comments

The page->mem_cgroup member is replaced by memcg_data, and add a helper
page_memcg() for it. Need to update comments to avoid confusing.

Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.g=
mane.org>
Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 mm/memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7657f16cf992..b6560ab1adc4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1330,7 +1330,7 @@ void lruvec_memcg_debug(struct lruvec *lruvec, struct=
 page *page)
  * @page: the page
  * @pgdat: pgdat of the page
  *
- * This function relies on page->mem_cgroup being stable - see the
+ * This function relies on page's memcg being stable - see the
  * access rules in commit_charge().
  */
 struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_dat=
a *pgdat)
@@ -2942,7 +2942,7 @@ static void commit_charge(struct page *page, struct m=
em_cgroup *memcg)
 {
 	VM_BUG_ON_PAGE(page_memcg(page), page);
 	/*
-	 * Any of the following ensures page->mem_cgroup stability:
+	 * Any of the following ensures page's memcg stability:
 	 *
 	 * - the page lock
 	 * - LRU isolation
--=20
1.8.3.1

