From: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH 1/4] mm: Fix kernel-doc warning from tlb_flush_rmaps()
Date: Fri, 18 Aug 2023 21:06:27 +0100
Message-ID: <20230818200630.2719595-2-willy@infradead.org>
References: <20230818200630.2719595-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=hBTE4z1qFRK8GKVkm74TePYQyzNHYl26/C9WeYlReVs=; b=nCMQUJtkYsiL9VLEqUAbyMPRNU
        FkMc5ws1uHU5C7DeZssEFP6ua822AKo3VO0PvVhd6XFmc4viXKfWrynUKg+8rvSUk/rbq6DZa6JZY
        Pk82WHNbCI/6AjlbREUTYzzcPcFkqTBS4vZ4YzaclfawVnVQ7A1nM7TYp/okctf3RoFGtFPkGXXw5
        cNLUdxTup4Yqp9SiwXSKm/JuLnPYGad0o84JGBV04hdcelsREQakr7eapSVsU5hOV8vKRQUzfYAev
        V58r161EPRq1WZ+sNB3X/ELtxoGemEq849+vHpH1TzzZJfT2nk7dVfoDJfWoCm0WRLzWAO+CjdI7+
        iNXer5Mw==;
In-Reply-To: <20230818200630.2719595-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The vma parameter wasn't described.

Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
---
 mm/mmu_gather.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index ea9683e12936..4f559f4ddd21 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -63,6 +63,7 @@ static void tlb_flush_rmap_batch(struct mmu_gather_batch *batch, struct vm_area_
 /**
  * tlb_flush_rmaps - do pending rmap removals after we have flushed the TLB
  * @tlb: the current mmu_gather
+ * @vma: The memory area from which the pages are being removed.
  *
  * Note that because of how tlb_next_batch() above works, we will
  * never start multiple new batches with pending delayed rmaps, so
-- 
2.40.1

