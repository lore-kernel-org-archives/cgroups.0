From: Zi Yan <zi.yan@sent.com>
Subject: [PATCH v3 1/7] mm/memcg: use order instead of nr in split_page_memcg()
Date: Mon,  3 Apr 2023 16:18:33 -0400
Message-ID: <20230403201839.4097845-2-zi.yan@sent.com>
References: <20230403201839.4097845-1-zi.yan@sent.com>
Reply-To: Zi Yan <ziy@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sent.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:reply-to:sender:subject:subject:to:to; s=fm2; t=
        1680553144; x=1680639544; bh=Yr+uFjBJL/0qCDkJMJuMYA8+4U49oyS8kQR
        IZ4QnQ48=; b=T1hetx0z1aJK2O8iBf1XvbqRSf2LI5NbMRJIZbD7uStCjfYTwWu
        LJGnCoWYcbaqpoiUrntElnYceDUE5dsSh5Ku+hBbgvndzIdg1RoPOlpMQblhIZEj
        Gj9N8O5K106uCqM170WRD7HzCaPjrz+LrVUSe85Y2mDdavpdEAQwrn4H17Ft3gZV
        4i1+Y9GQdBSJAMy41kpcfLa/idIEkFFLl3C4BwKjk/9zNnr+jhhFMl8lURKOJePr
        WUFqi+HV8uSXTAynXN9pclE+IFtgQQ5tFcHeF3Hdw+WTPtgbvTJf/fpYERORW3zX
        w9l3SsHoMN9zpXheXCSyiSDa8U3ezvl9WFQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1680553144; x=1680639544; bh=Yr+uFjBJL/0qCDkJMJuMYA8+4U49oyS8kQR
        IZ4QnQ48=; b=sXEJDM7KET2Hz2FHW38uAUF1gFqDFEOhVRtiWCqszLoqwd1QDsa
        XpDhu5g5zULZEpHyMzC0XVamd3bmgfGCMbzr8ic5lVeNWN+70QI+kqdzTDEJVJlQ
        lF5zFAKYBWZxkHlKZ/5jObCMfNlOGCacD3+oDf582G15K8Un92Y2c5oKigRFMxqa
        ZXeJYHTlEteuxWOv4laEB07bJgRtG5KeX65vfCX09baLQsAuneHGOMJxAm6qe1z0
        +eOvk/9J9zol6wjU0NxawPfRaYWPNDFUvbyjqYXN0nwNts9yMrGDgrS/wuklV3dq
        WcJctYgIhA+94PoWt+7EwS1GfgHOq/BOyvA==
In-Reply-To: <20230403201839.4097845-1-zi.yan@sent.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Yang Shi <shy828301@gmail.com>, Yu Zhao <yuzhao@google.com>, linux-mm@kvack.org
Cc: Zi Yan <ziy@nvidia.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Ryan Roberts <ryan.roberts@arm.com>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, Zach O'Keefe <zokeefe@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org

From: Zi Yan <ziy@nvidia.com>

We do not have non power of two pages, using nr is error prone if nr
is not power-of-two. Use page order instead.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/memcontrol.h | 4 ++--
 mm/huge_memory.c           | 3 ++-
 mm/memcontrol.c            | 3 ++-
 mm/page_alloc.c            | 4 ++--
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index aa69ea98e2d8..e06a61ea4fc1 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1151,7 +1151,7 @@ static inline void memcg_memory_event_mm(struct mm_st=
ruct *mm,
 	rcu_read_unlock();
 }
=20
-void split_page_memcg(struct page *head, unsigned int nr);
+void split_page_memcg(struct page *head, int order);
=20
 unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 						gfp_t gfp_mask,
@@ -1588,7 +1588,7 @@ void count_memcg_event_mm(struct mm_struct *mm, enum =
vm_event_item idx)
 {
 }
=20
-static inline void split_page_memcg(struct page *head, unsigned int nr)
+static inline void split_page_memcg(struct page *head, int order)
 {
 }
=20
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 81a5689806af..3bb003eb80a3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2512,10 +2512,11 @@ static void __split_huge_page(struct page *page, st=
ruct list_head *list,
 	struct address_space *swap_cache =3D NULL;
 	unsigned long offset =3D 0;
 	unsigned int nr =3D thp_nr_pages(head);
+	int order =3D folio_order(folio);
 	int i;
=20
 	/* complete memcg works before add pages to LRU */
-	split_page_memcg(head, nr);
+	split_page_memcg(head, order);
=20
 	if (PageAnon(head) && PageSwapCache(head)) {
 		swp_entry_t entry =3D { .val =3D page_private(head) };
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 681e7528a714..cab2828e188d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3414,11 +3414,12 @@ void obj_cgroup_uncharge(struct obj_cgroup *objcg, =
size_t size)
 /*
  * Because page_memcg(head) is not set on tails, set it now.
  */
-void split_page_memcg(struct page *head, unsigned int nr)
+void split_page_memcg(struct page *head, int order)
 {
 	struct folio *folio =3D page_folio(head);
 	struct mem_cgroup *memcg =3D folio_memcg(folio);
 	int i;
+	unsigned int nr =3D 1 << order;
=20
 	if (mem_cgroup_disabled() || !memcg)
 		return;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0767dd6bc5ba..d84b121d1e03 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2781,7 +2781,7 @@ void split_page(struct page *page, unsigned int order)
 	for (i =3D 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
 	split_page_owner(page, 1 << order);
-	split_page_memcg(page, 1 << order);
+	split_page_memcg(page, order);
 }
 EXPORT_SYMBOL_GPL(split_page);
=20
@@ -4997,7 +4997,7 @@ static void *make_alloc_exact(unsigned long addr, uns=
igned int order,
 		struct page *last =3D page + nr;
=20
 		split_page_owner(page, 1 << order);
-		split_page_memcg(page, 1 << order);
+		split_page_memcg(page, order);
 		while (page < --last)
 			set_page_refcounted(last);
=20
--=20
2.39.2

