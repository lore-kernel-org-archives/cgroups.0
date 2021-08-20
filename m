From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 2/2] mm: unexport {,un}lock_page_memcg
Date: Fri, 20 Aug 2021 11:58:15 +0200
Message-ID: <20210820095815.445392-3-hch@lst.de>
References: <20210820095815.445392-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=nzUrzTYf+SxA9DhkR1ixsQBSLVoS1UsUtkY4TuBivPg=; b=JoPBlcJiFqV74veGWFe1sBI6Ng
        sSqpzCCSwBgVyHB08j9McLOlR3cKFBhyMcM5xzEaYClvs4XfWxXAuSHiC9pg7sCuqkRwfYygAa5gd
        qy3YJIAzot89NYNSk2ntP5jTiUBj05ROneWiPfxBo6F3HTFopgpp+RWecy19gWmSuafxTkyxR9CRh
        X+sYrZArif2/DzhEAuXF4thtO+TjEybpgk7bks4HCQuY9KPg4zHXxwbG96bBpDUDCdX97Sb9OsYHF
        iz3omvxWYed9N8aa6GScN9rCBQXVl7aWy9JbdSH0rob2x6BHLJ6atPqy2+vd5l9hz03G3V9AUFw3n
        FTiz/57w==;
In-Reply-To: <20210820095815.445392-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

These are only used in built-in core mm code.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 mm/memcontrol.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4cb4349065931..6a74a180e3eae 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2019,7 +2019,6 @@ void lock_page_memcg(struct page *page)
 {
 	folio_memcg_lock(page_folio(page));
 }
-EXPORT_SYMBOL(lock_page_memcg);
 
 static void __folio_memcg_unlock(struct mem_cgroup *memcg)
 {
@@ -2052,7 +2051,6 @@ void unlock_page_memcg(struct page *page)
 {
 	folio_memcg_unlock(page_folio(page));
 }
-EXPORT_SYMBOL(unlock_page_memcg);
 
 struct obj_stock {
 #ifdef CONFIG_MEMCG_KMEM
-- 
2.30.2

