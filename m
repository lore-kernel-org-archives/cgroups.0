From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] mm: memcg: normalize the value passed into memcg_rstat_updated()
Date: Fri, 22 Sep 2023 08:25:42 +0000
Message-ID: <20230922082542.466579-3-yosryahmed@google.com>
References: <20230922082542.466579-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695371149; x=1695975949; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rIAAYaTevangAQtHpP5uU5ftp8AXloDBwmYe1UIN8vQ=;
        b=XBjbXg+OCwQRzWSTySzeE3xjrZNExAPDUkhbOvLO3oyemoMhg+n+/8OOQeFtp8zjtd
         NcZ3ngZPDetAfxubUT4T3c1GPJr8I0Nddh0dWkf80zfGvDegE2CnxRh+72pQ7AIvbs88
         8btKp3IZGxFzOC8uOHfXSeAcH08Mv3ky2Ebz6VMCS9sMET/7+w6IjMNQBJAIXcR/76fx
         fGh/11DdtjCr/tS+5l4GURiVu0p2Eavakt4072+jZlw8LUSZsH3rqq0e7n8Kb5YKscWh
         NOe8Ds6BFFjw1MAIB2W5695bokZTXu1o4tggtxZRq54TzLRr/IVijIsmKIVKamb6q+fH
         DdqA==
In-Reply-To: <20230922082542.466579-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

memcg_rstat_updated() uses the value of the state update to keep track
of the magnitude of pending updates, so that we only do a stats flush
when it's worth the work. Most values passed into memcg_rstat_updated()
are in pages, however, a few of them are actually in bytes or KBs.

To put this into perspective, a 512 byte slab allocation today would
look the same as allocating 512 pages. This may result in premature
flushes, which means unnecessary work and latency.

Normalize all the state values passed into memcg_rstat_updated() to
pages. Round up non-zero sub-page to 1 page, because
memcg_rstat_updated() ignores 0 page updates.

Fixes: 5b3be698a872 ("memcg: better bounds on the memcg stats updates")
Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 683aa8405c22..ea050908338a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -761,6 +761,22 @@ unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
 	return x;
 }
 
+static int memcg_page_state_unit(int item);
+
+/*
+ * Normalize the value passed into memcg_rstat_updated() to be in pages. Round
+ * up non-zero sub-page updates to 1 page as zero page updates are ignored.
+ */
+static int memcg_state_val_in_pages(int idx, int val)
+{
+	int unit = memcg_page_state_unit(idx);
+
+	if (!val || unit == PAGE_SIZE)
+		return val;
+	else
+		return max(val * unit / PAGE_SIZE, 1UL);
+}
+
 /**
  * __mod_memcg_state - update cgroup memory statistics
  * @memcg: the memory cgroup
@@ -773,7 +789,7 @@ void __mod_memcg_state(struct mem_cgroup *memcg, int idx, int val)
 		return;
 
 	__this_cpu_add(memcg->vmstats_percpu->state[idx], val);
-	memcg_rstat_updated(memcg, val);
+	memcg_rstat_updated(memcg, memcg_state_val_in_pages(idx, val));
 }
 
 /* idx can be of type enum memcg_stat_item or node_stat_item. */
@@ -824,7 +840,7 @@ void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 	/* Update lruvec */
 	__this_cpu_add(pn->lruvec_stats_percpu->state[idx], val);
 
-	memcg_rstat_updated(memcg, val);
+	memcg_rstat_updated(memcg, memcg_state_val_in_pages(idx, val));
 	memcg_stats_unlock();
 }
 
-- 
2.42.0.515.g380fc7ccd1-goog

