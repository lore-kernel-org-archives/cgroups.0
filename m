From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/5] mm: workingset: move the stats flush into workingset_test_recent()
Date: Thu, 21 Sep 2023 08:10:56 +0000
Message-ID: <20230921081057.3440885-5-yosryahmed@google.com>
References: <20230921081057.3440885-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695321233; x=1695926033; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ap3WQf9RL9Y6q/AtYDIGLhJT98YcDdn8KWtOOFcbuqo=;
        b=J/fwTB7gMMrC7BDhC8niQD7LKMDjG8Zb5IJgCU+64HOS36X/8cNTeTvKfAVZxegiaC
         PXqgVAy+Fv7prOLsno4smeXZDMvnV+U2vTybi1LtxSq5A0l0MNI0TeiCab52xBS6h5l3
         pdkT/yVsW9PFUuMOLGwIQuigfevHcmD6RP85pXd+c5JL1Qmm4N9ATOD/JTlynjFVpCKS
         sE9+ydW7KyPe1bAfVXTzLi7GsuEe9Q9qIGDMZM+XV96cfJ2o/PzpyDlISKrj5U1sLybm
         HSzwBxUKv0v9mTB4o2Io4f/7d2TwRTZ5zEp8aKXHdHS4+av+Wq3MzdQ42QSeRHjsm8Rp
         Uz8A==
In-Reply-To: <20230921081057.3440885-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

The workingset code flushes the stats in workingset_refault() to get
accurate stats of the eviction memcg. In preparation for more scoped
flushed and passing the eviction memcg to the flush call, move the call
to workingset_test_recent() where we have a pointer to the eviction
memcg.

The flush call is sleepable, and cannot be made in an rcu read section.
Hence, minimize the rcu read section by also moving it into
workingset_test_recent(). Furthermore, instead of holding the rcu read
lock throughout workingset_test_recent(), only hold it briefly to get a
ref on the eviction memcg. This allows us to make the flush call after
we get the eviction memcg.

As for workingset_refault(), nothing else there appears to be protected
by rcu. The memcg of the faulted folio (which is not necessarily the
same as the eviction memcg) is protected by the folio lock, which is
held from all callsites. Add a VM_BUG_ON() to make sure this doesn't
change from under us.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/workingset.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index b192e44a0e7c..79b338996088 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -425,8 +425,15 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset)
 	struct pglist_data *pgdat;
 	unsigned long eviction;
 
-	if (lru_gen_enabled())
-		return lru_gen_test_recent(shadow, file, &eviction_lruvec, &eviction, workingset);
+	rcu_read_lock();
+
+	if (lru_gen_enabled()) {
+		bool recent = lru_gen_test_recent(shadow, file,
+						  &eviction_lruvec, &eviction,
+						  workingset);
+		rcu_read_unlock();
+		return recent;
+	}
 
 	unpack_shadow(shadow, &memcgid, &pgdat, &eviction, workingset);
 	eviction <<= bucket_order;
@@ -451,6 +458,12 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset)
 	if (!mem_cgroup_disabled() && !eviction_memcg)
 		return false;
 
+	css_get(&eviction_memcg->css);
+	rcu_read_unlock();
+
+	/* Flush stats (and potentially sleep) outside the RCU read section */
+	mem_cgroup_flush_stats_ratelimited();
+
 	eviction_lruvec = mem_cgroup_lruvec(eviction_memcg, pgdat);
 	refault = atomic_long_read(&eviction_lruvec->nonresident_age);
 
@@ -493,6 +506,7 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset)
 		}
 	}
 
+	mem_cgroup_put(eviction_memcg);
 	return refault_distance <= workingset_size;
 }
 
@@ -519,19 +533,16 @@ void workingset_refault(struct folio *folio, void *shadow)
 		return;
 	}
 
-	/* Flush stats (and potentially sleep) before holding RCU read lock */
-	mem_cgroup_flush_stats_ratelimited();
-
-	rcu_read_lock();
-
 	/*
 	 * The activation decision for this folio is made at the level
 	 * where the eviction occurred, as that is where the LRU order
 	 * during folio reclaim is being determined.
 	 *
 	 * However, the cgroup that will own the folio is the one that
-	 * is actually experiencing the refault event.
+	 * is actually experiencing the refault event. Make sure the folio is
+	 * locked to guarantee folio_memcg() stability throughout.
 	 */
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	nr = folio_nr_pages(folio);
 	memcg = folio_memcg(folio);
 	pgdat = folio_pgdat(folio);
@@ -540,7 +551,7 @@ void workingset_refault(struct folio *folio, void *shadow)
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
 
 	if (!workingset_test_recent(shadow, file, &workingset))
-		goto out;
+		return;
 
 	folio_set_active(folio);
 	workingset_age_nonresident(lruvec, nr);
@@ -556,8 +567,6 @@ void workingset_refault(struct folio *folio, void *shadow)
 		lru_note_cost_refault(folio);
 		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + file, nr);
 	}
-out:
-	rcu_read_unlock();
 }
 
 /**
-- 
2.42.0.459.ge4e396fd5e-goog

