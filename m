From: Zi Yan <zi.yan-vRdzynncJC4@public.gmane.org>
Subject: [PATCH 1/5] mm: memcg: make memcg huge page split support any order split.
Date: Mon, 20 Mar 2023 20:48:25 -0400
Message-ID: <20230321004829.2012847-2-zi.yan@sent.com>
References: <20230321004829.2012847-1-zi.yan@sent.com>
Reply-To: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sent.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:reply-to:sender:subject:subject:to:to; s=fm2; t=
        1679359730; x=1679446130; bh=0Tzs8PaBhDS7gnrC9VJc1BLc6ZqSPN615n0
        3F+KtioE=; b=Fq31bFDh7TW17tQxDKm3QuqWpUUozaf6KcCIGz7Z6OjBE/xKfMI
        +YMwa559U7k/zFh9J9lEl7sAjRLg9yKpaXa5QCyo2ORuR+QCNPGQyETnMZdOA/3V
        M8KOVZyGFXkRDZqvKUi/3ZjUedIyo3csEN6BTe4asByFlBlVISekm+uHb7gGHryf
        kJo0fXs32dR6z7XUQ03cvb2rgBwVtxVPl/SSWuaBGrYqpOlNH3nohVUy4HYbzRb6
        +A1CfKMVbX22bdu8mygQ6PLc/g3kSAAij3PxKCSKN/HG4z1GndMIUZ8SqTVKdZC+
        QD+hfXcRKgZLu/LjShA362ay9h+HvzfW7Zg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1679359730; x=1679446130; bh=0Tzs8PaBhDS7gnrC9VJc1BLc6ZqSPN615n0
        3F+KtioE=; b=GuhsskQZstlXVlxY6sW5bBEdR+lJnuzUE2+2GjdthnhLPidQm65
        rnFPK1OQDhX3VlHC9l/Wl/YXeTWQQpvg88tBgccVY7jc0J/oGZWBqDx9hf7UA1Uq
        6WDTqOrmDKyFn9UUEFl8isZS6SaxBUdACAWX69eiaEpNe9TyvwDmAkgIBFod5IAp
        1GBe882iEMuLdC8HeV27NWeoFXCLQnLG+qiqKUhT2FIFS0gciMBkl17OtrgnjauZ
        PCPLE9vkuxOpg1Xn0rjxiyNAR9dA6A9fqLF9uMh2MFbXViUhMW2aNtDi+aTMMz+/
        ApQhl5zkIlRECcS/rJVS2tzmUS/GLwwFUrA==
In-Reply-To: <20230321004829.2012847-1-zi.yan-vRdzynncJC4@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>

It sets memcg information for the pages after the split. A new parameter
new_nr is added to tell the number of subpages in the new page, always 1
for now. It prepares for upcoming changes to support split huge page to
any lower order.

Signed-off-by: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
---
 include/linux/memcontrol.h | 5 +++--
 mm/huge_memory.c           | 2 +-
 mm/memcontrol.c            | 8 ++++----
 mm/page_alloc.c            | 2 +-
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index aa69ea98e2d8..ee1021129142 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1151,7 +1151,7 @@ static inline void memcg_memory_event_mm(struct mm_st=
ruct *mm,
 	rcu_read_unlock();
 }
=20
-void split_page_memcg(struct page *head, unsigned int nr);
+void split_page_memcg(struct page *head, unsigned int nr, unsigned int new=
_nr);
=20
 unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 						gfp_t gfp_mask,
@@ -1588,7 +1588,8 @@ void count_memcg_event_mm(struct mm_struct *mm, enum =
vm_event_item idx)
 {
 }
=20
-static inline void split_page_memcg(struct page *head, unsigned int nr)
+static inline void split_page_memcg(struct page *head, unsigned int nr,
+						unsigned int new_nr)
 {
 }
=20
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 81a5689806af..30e3e300c42e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2515,7 +2515,7 @@ static void __split_huge_page(struct page *page, stru=
ct list_head *list,
 	int i;
=20
 	/* complete memcg works before add pages to LRU */
-	split_page_memcg(head, nr);
+	split_page_memcg(head, nr, 1);
=20
 	if (PageAnon(head) && PageSwapCache(head)) {
 		swp_entry_t entry =3D { .val =3D page_private(head) };
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 681e7528a714..8e505201baf0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3414,7 +3414,7 @@ void obj_cgroup_uncharge(struct obj_cgroup *objcg, si=
ze_t size)
 /*
  * Because page_memcg(head) is not set on tails, set it now.
  */
-void split_page_memcg(struct page *head, unsigned int nr)
+void split_page_memcg(struct page *head, unsigned int nr, unsigned int new=
_nr)
 {
 	struct folio *folio =3D page_folio(head);
 	struct mem_cgroup *memcg =3D folio_memcg(folio);
@@ -3423,13 +3423,13 @@ void split_page_memcg(struct page *head, unsigned i=
nt nr)
 	if (mem_cgroup_disabled() || !memcg)
 		return;
=20
-	for (i =3D 1; i < nr; i++)
+	for (i =3D new_nr; i < nr; i +=3D new_nr)
 		folio_page(folio, i)->memcg_data =3D folio->memcg_data;
=20
 	if (folio_memcg_kmem(folio))
-		obj_cgroup_get_many(__folio_objcg(folio), nr - 1);
+		obj_cgroup_get_many(__folio_objcg(folio), nr / new_nr - 1);
 	else
-		css_get_many(&memcg->css, nr - 1);
+		css_get_many(&memcg->css, nr / new_nr - 1);
 }
=20
 #ifdef CONFIG_SWAP
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2e72fdbdd8db..59c2b6696698 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3531,7 +3531,7 @@ void split_page(struct page *page, unsigned int order)
 	for (i =3D 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
 	split_page_owner(page, 1 << order);
-	split_page_memcg(page, 1 << order);
+	split_page_memcg(page, 1 << order, 1);
 }
 EXPORT_SYMBOL_GPL(split_page);
=20
--=20
2.39.2

