From: Zi Yan <zi.yan-vRdzynncJC4@public.gmane.org>
Subject: [PATCH v2 1/7] mm/memcg: use order instead of nr in split_page_memcg()
Date: Tue, 28 Mar 2023 21:17:06 -0400
Message-ID: <20230329011712.3242298-2-zi.yan@sent.com>
References: <20230329011712.3242298-1-zi.yan@sent.com>
Reply-To: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sent.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:reply-to:sender:subject:subject:to:to; s=fm2; t=
        1680052655; x=1680139055; bh=Yr+uFjBJL/0qCDkJMJuMYA8+4U49oyS8kQR
        IZ4QnQ48=; b=c2vliS6JhQxy5/eS0afSs1yoR0oEYtCAkHHfJ2NY2HoMe7XHOOO
        CpMt1njwoyf3knkBXLIr/09frjWyWNQ6HWyDMuDMqDAsjwx4bN64V4Z1J5laPlco
        Q+70dNV/AvOttP16sojJ1qlpXAxPTYlsQ0mC1fdyenzk4Zcf7sRdZ/gKgFDqw6Si
        +6e6b+PpALSBM7Dc5XfhMCKS8eIeNEY/v1JZvJM9wjf+mxXnQbldnkPhHeZx6IYq
        wepPh+YKS1q6698TPsrzZRfUE9eF1inQwUrBZT6wI+fT84QDqizyidBrXPiNaeqN
        VLi8wAzUPIOSdjrZ9ZYc0RPUjkhHqg2J6Iw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1680052655; x=1680139055; bh=Yr+uFjBJL/0qCDkJMJuMYA8+4U49oyS8kQR
        IZ4QnQ48=; b=mKrpjOke7X6OEH7MkeQZ+uLgHdMAhITBjBpB7pRv9Ae+UiAhZ8X
        bOlmsLDdOJtdChgpQ7DlpAZoC0KEfS45ibzrvGH3CCbA2Hq3Bs7hBFwcAKuKOoh5
        y1hy12LARUXJ8yaaWC2CsIo79wufNnEBnWtYlLU5n3t87xuexEQ0JBGdWQWAo3EE
        V74ZQPgyulK1CJ8ZreNYH+SXNPkH9vccUk7fIoGTfN9YJruBbJLUGP1qRbbM7Tek
        U0YPeaz6CfQDmeAi/6BiXzHV9FYbJHa2bHHju+IWJ8h7lLbAPfe1QacehYnuL6EE
        q6S3li6xjFrlFPgAhZM1YtRNhgS6YUoyWtQ==
In-Reply-To: <20230329011712.3242298-1-zi.yan-vRdzynncJC4@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ryan Roberts <ryan.roberts-5wv7dgnIgG8@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Zach O'Keefe <zokeefe-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>

We do not have non power of two pages, using nr is error prone if nr
is not power-of-two. Use page order instead.

Signed-off-by: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
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

