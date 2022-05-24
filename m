From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH v4 06/11] mm: thp: make split queue lock safe when LRU pages are reparented
Date: Tue, 24 May 2022 14:05:46 +0800
Message-ID: <20220524060551.80037-7-songmuchun@bytedance.com>
References: <20220524060551.80037-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2mx9bPTY7AEcp+j24lhXXPGVls/yhivZ1agLRVxoLiw=;
        b=v+S3AKD3IZY1715alsr8yTzbsVUYEJKe+49LFvD+HdqE9G/w+5EjzEN0EwaEDyGrgn
         i9Ya3PVga4iPV58AJIeN1oTrMCpdjatANgHWEgSW8H8UHrlDSX4k0sGGqWcV7AXdFW13
         EAk3nLfKEjQm6om5mFrDB7o4f02o242GQEXT/WIFEL4yR/3PpF7M5gtnBfzi+dSVbTxu
         StmM8BZkmo2YtgyD2u3N/KxcgJyaZoQ5QI6XjNdjDbH/gX13NzTb6mqHMmzWnw0wjnjt
         6G2U6k80RGyCUtx5VNIlrbZZrmZIkm6UOOp3C70ojMsYgXdvqPAfokDNwMjQRVy8THGC
         Q/Ew==
In-Reply-To: <20220524060551.80037-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Similar to the lruvec lock, we use the same approach to make the split
queue lock safe when LRU pages are reparented.

Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 mm/huge_memory.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ea152bde441e..cc596034c487 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -543,9 +543,22 @@ static struct deferred_split *folio_split_queue_lock(struct folio *folio)
 {
 	struct deferred_split *queue;
 
+	rcu_read_lock();
+retry:
 	queue = folio_split_queue(folio);
 	spin_lock(&queue->split_queue_lock);
 
+	if (unlikely(folio_split_queue_memcg(folio, queue) != folio_memcg(folio))) {
+		spin_unlock(&queue->split_queue_lock);
+		goto retry;
+	}
+
+	/*
+	 * Preemption is disabled in the internal of spin_lock, which can serve
+	 * as RCU read-side critical sections.
+	 */
+	rcu_read_unlock();
+
 	return queue;
 }
 
@@ -554,9 +567,19 @@ folio_split_queue_lock_irqsave(struct folio *folio, unsigned long *flags)
 {
 	struct deferred_split *queue;
 
+	rcu_read_lock();
+retry:
 	queue = folio_split_queue(folio);
 	spin_lock_irqsave(&queue->split_queue_lock, *flags);
 
+	if (unlikely(folio_split_queue_memcg(folio, queue) != folio_memcg(folio))) {
+		spin_unlock_irqrestore(&queue->split_queue_lock, *flags);
+		goto retry;
+	}
+
+	/* See the comments in folio_split_queue_lock(). */
+	rcu_read_unlock();
+
 	return queue;
 }
 
-- 
2.11.0

