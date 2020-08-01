From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: remove useless check on page->mem_cgroup
Date: Sat, 1 Aug 2020 11:58:41 +0800
Message-ID: <9338716f-ca0e-057f-8d94-03e2b3f70281@linux.alibaba.com>
References: <1596166480-22814-1-git-send-email-alex.shi@linux.alibaba.com>
 <20200731151655.GB491801@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200731151655.GB491801-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



=D4=DA 2020/7/31 =CF=C2=CE=E711:16, Johannes Weiner =D0=B4=B5=C0:
>>  	if (!entry.val) {
>>  		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
> Uncharged readahead pages are gone, but I'm not 100% sure uncharged
> pages in general are gone. ISTR that the !page->mem_cgroup check in
> mem_cgroup_uncharge() prevented a crash - although that is of course a
> much broader interface, whereas the ones you change should only apply
> to LRU pages (which are hopefully all charged).
>=20
> Nevertheless, to avoid unnecessary crashes if we discover that we've
> been wrong, how about leaving the branches for now, but adding a (new)
> VM_WARN_ON_ONCE_PAGE() to them?


Right, let's see if other unexcepted things happens, and then do actions.
So it's the patch:

From 28893cf8e55b98665cce58c0ba6d54aeafb63a62 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Date: Sat, 1 Aug 2020 10:43:55 +0800
Subject: [PATCH] mm/memcg: warning on !memcg after readahead page charged

Since readahead page is charged on memcg too, in theory we don't have to
check this exception now. Before safely remove them all, add a warning
for the unexpected !memcg.

Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.g=
mane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 include/linux/mmdebug.h |  8 ++++++++
 mm/memcontrol.c         | 15 ++++++++-------
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
index 2ad72d2c8cc5..639e98a3384e 100644
--- a/include/linux/mmdebug.h
+++ b/include/linux/mmdebug.h
@@ -37,6 +37,13 @@
 			BUG();						\
 		}							\
 	} while (0)
+#define VM_WARN_ON_ONCE_PAGE(cond, page)				\
+	do {								\
+		if (unlikely(cond)) {					\
+			dump_page(page, "VM_WARN_ON_ONCE_PAGE(" __stringify(cond)")");\
+			WARN_ON_ONCE(cond);				\
+		}							\
+	} while (0)
 #define VM_WARN_ON(cond) (void)WARN_ON(cond)
 #define VM_WARN_ON_ONCE(cond) (void)WARN_ON_ONCE(cond)
 #define VM_WARN_ONCE(cond, format...) (void)WARN_ONCE(cond, format)
@@ -48,6 +55,7 @@
 #define VM_BUG_ON_MM(cond, mm) VM_BUG_ON(cond)
 #define VM_WARN_ON(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_ONCE(cond) BUILD_BUG_ON_INVALID(cond)
+#define VM_WARN_ON_ONCE_PAGE(cond, page)  BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ONCE(cond, format...) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN(cond, format...) BUILD_BUG_ON_INVALID(cond)
 #endif
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e84c2b5596f2..0174c31f6491 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1322,10 +1322,8 @@ struct lruvec *mem_cgroup_page_lruvec(struct page *p=
age, struct pglist_data *pgd
 	}
=20
 	memcg =3D page->mem_cgroup;
-	/*
-	 * Swapcache readahead pages are added to the LRU - and
-	 * possibly migrated - before they are charged.
-	 */
+	/* Readahead page is charged too, to see if other page uncharged */
+	VM_WARN_ON_ONCE_PAGE(!memcg, page);
 	if (!memcg)
 		memcg =3D root_mem_cgroup;
=20
@@ -6897,8 +6895,9 @@ void mem_cgroup_migrate(struct page *oldpage, struct =
page *newpage)
 	if (newpage->mem_cgroup)
 		return;
=20
-	/* Swapcache readahead pages can get replaced before being charged */
 	memcg =3D oldpage->mem_cgroup;
+	/* Readahead page is charged too, to see if other page uncharged */
+	VM_WARN_ON_ONCE_PAGE(!memcg, oldpage);
 	if (!memcg)
 		return;
=20
@@ -7095,7 +7094,8 @@ void mem_cgroup_swapout(struct page *page, swp_entry_=
t entry)
=20
 	memcg =3D page->mem_cgroup;
=20
-	/* Readahead page, never charged */
+	/* Readahead page is charged too, to see if other page uncharged */
+	VM_WARN_ON_ONCE_PAGE(!memcg, page);
 	if (!memcg)
 		return;
=20
@@ -7159,7 +7159,8 @@ int mem_cgroup_try_charge_swap(struct page *page, swp=
_entry_t entry)
=20
 	memcg =3D page->mem_cgroup;
=20
-	/* Readahead page, never charged */
+	/* Readahead page is charged too, to see if other page uncharged */
+	VM_WARN_ON_ONCE_PAGE(!memcg, page);
 	if (!memcg)
 		return 0;
=20
--=20
1.8.3.1

