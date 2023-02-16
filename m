From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v3 4/4] mm: change to return bool for
 isolate_movable_page()
Date: Thu, 16 Feb 2023 14:46:58 -0800
Message-ID: <20230216144658.18add74d133be070f07cf1f5@linux-foundation.org>
References: <cover.1676424378.git.baolin.wang@linux.alibaba.com>
        <cb877f73f4fff8d309611082ec740a7065b1ade0.1676424378.git.baolin.wang@linux.alibaba.com>
        <Y+z91pcxAuygc92J@casper.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676587619;
        bh=9oeCHSLszN1ZlteZIP+mKzpT4ngVcpBp4cDal0zXZL0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XklABHGuz67Jr6L6q/GiqwCZqRGFa+meW1H0YZ/7JApSIsmEX8CEMBZVPkJ8B+60O
         FlR0T0McnQ+zkZBfm7a39gFwYc8vtAuogsrnhflLLTuwcTv+vtD/qfquyn7FMcATsT
         3jqW32IAcaubqFDEOIYbQmm1CSWaRBHcflvOu1P0=
In-Reply-To: <Y+z91pcxAuygc92J-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, sj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, naoya.horiguchi-YMj9X0ASwKA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, osalvador-l3A5Bk7waGM@public.gmane.org, mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, damon-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 15 Feb 2023 15:44:22 +0000 Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> >  extern struct page *alloc_migration_target(struct page *page, unsigned long private);
> > -extern int isolate_movable_page(struct page *page, isolate_mode_t mode);
> > +extern bool isolate_movable_page(struct page *page, isolate_mode_t mode);
> 
> You can drop the 'extern' here.

There are a bunch of them, so a separate patch would be better.


--- a/include/linux/migrate.h~a
+++ a/include/linux/migrate.h
@@ -62,16 +62,16 @@ extern const char *migrate_reason_names[
 
 #ifdef CONFIG_MIGRATION
 
-extern void putback_movable_pages(struct list_head *l);
+void putback_movable_pages(struct list_head *l);
 int migrate_folio_extra(struct address_space *mapping, struct folio *dst,
 		struct folio *src, enum migrate_mode mode, int extra_count);
 int migrate_folio(struct address_space *mapping, struct folio *dst,
 		struct folio *src, enum migrate_mode mode);
-extern int migrate_pages(struct list_head *l, new_page_t new, free_page_t free,
-		unsigned long private, enum migrate_mode mode, int reason,
-		unsigned int *ret_succeeded);
-extern struct page *alloc_migration_target(struct page *page, unsigned long private);
-extern bool isolate_movable_page(struct page *page, isolate_mode_t mode);
+int migrate_pages(struct list_head *l, new_page_t new, free_page_t free,
+		  unsigned long private, enum migrate_mode mode, int reason,
+		  unsigned int *ret_succeeded);
+struct page *alloc_migration_target(struct page *page, unsigned long private);
+bool isolate_movable_page(struct page *page, isolate_mode_t mode);
 
 int migrate_huge_page_move_mapping(struct address_space *mapping,
 		struct folio *dst, struct folio *src);
@@ -142,8 +142,8 @@ const struct movable_operations *page_mo
 }
 
 #ifdef CONFIG_NUMA_BALANCING
-extern int migrate_misplaced_page(struct page *page,
-				  struct vm_area_struct *vma, int node);
+int migrate_misplaced_page(struct page *page, struct vm_area_struct *vma,
+			   int node);
 #else
 static inline int migrate_misplaced_page(struct page *page,
 					 struct vm_area_struct *vma, int node)
_

