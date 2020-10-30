From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v20 04/20] mm/thp: use head for head page in
 lru_add_page_tail
Date: Fri, 30 Oct 2020 10:46:54 +0800
Message-ID: <06a5b7d8-bbf2-51b7-1352-2b630186e15f@linux.alibaba.com>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
 <1603968305-8026-5-git-send-email-alex.shi@linux.alibaba.com>
 <20201029135047.GE599825@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20201029135047.GE599825-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org



=D4=DA 2020/10/29 =CF=C2=CE=E79:50, Johannes Weiner =D0=B4=B5=C0:
> On Thu, Oct 29, 2020 at 06:44:49PM +0800, Alex Shi wrote:
>> Since the first parameter is only used by head page, it's better to make
>> it explicit.
>>
>> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@publi=
c.gmane.org>
>> Reviewed-by: Kirill A. Shutemov <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@=
public.gmane.org>
>> Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.or=
g>
>> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>> Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>> Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
>> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> ---
>>  mm/huge_memory.c | 12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 038db815ebba..93c0b73eb8c6 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -2346,19 +2346,19 @@ static void remap_page(struct page *page, unsign=
ed int nr)
>>  	}
>>  }
>> =20
>> -static void lru_add_page_tail(struct page *page, struct page *page_tail,
>> +static void lru_add_page_tail(struct page *head, struct page *page_tail,
>=20
> It may be better to pick either
> 	head and tail

Hi Johannes,

Thanks for comments!

Right, Consider functions in this file are using head/tail more as paramete=
rs
I will change to use head/tail too. And then, the 04th, 05th, and 18th patc=
h=20
will be changed accordingly.

Thanks
Alex

> or
> 	page_head and page_tail
>=20
> ?
>=20

From a9ee63a213f40eb4d5a69b52fbb348ff9cd7cf6c Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Date: Tue, 26 May 2020 16:49:22 +0800
Subject: [PATCH v21 04/20] mm/thp: use head for head page in lru_add_page_t=
ail

Since the first parameter is only used by head page, it's better to make
it explicit.

Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.g=
mane.org>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@pub=
lic.gmane.org>
Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 mm/huge_memory.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 038db815ebba..32a4bf5b80c8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2346,33 +2346,32 @@ static void remap_page(struct page *page, unsigned =
int nr)
 	}
 }
=20
-static void lru_add_page_tail(struct page *page, struct page *page_tail,
+static void lru_add_page_tail(struct page *head, struct page *tail,
 		struct lruvec *lruvec, struct list_head *list)
 {
-	VM_BUG_ON_PAGE(!PageHead(page), page);
-	VM_BUG_ON_PAGE(PageCompound(page_tail), page);
-	VM_BUG_ON_PAGE(PageLRU(page_tail), page);
+	VM_BUG_ON_PAGE(!PageHead(head), head);
+	VM_BUG_ON_PAGE(PageCompound(tail), head);
+	VM_BUG_ON_PAGE(PageLRU(tail), head);
 	lockdep_assert_held(&lruvec_pgdat(lruvec)->lru_lock);
=20
 	if (!list)
-		SetPageLRU(page_tail);
+		SetPageLRU(tail);
=20
-	if (likely(PageLRU(page)))
-		list_add_tail(&page_tail->lru, &page->lru);
+	if (likely(PageLRU(head)))
+		list_add_tail(&tail->lru, &head->lru);
 	else if (list) {
 		/* page reclaim is reclaiming a huge page */
-		get_page(page_tail);
-		list_add_tail(&page_tail->lru, list);
+		get_page(tail);
+		list_add_tail(&tail->lru, list);
 	} else {
 		/*
 		 * Head page has not yet been counted, as an hpage,
 		 * so we must account for each subpage individually.
 		 *
-		 * Put page_tail on the list at the correct position
+		 * Put tail on the list at the correct position
 		 * so they all end up in order.
 		 */
-		add_page_to_lru_list_tail(page_tail, lruvec,
-					  page_lru(page_tail));
+		add_page_to_lru_list_tail(tail, lruvec, page_lru(tail));
 	}
 }
=20
--=20
1.8.3.1

