From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v4 3/4] mm: memcg: let non-unified root stats flushes help
 unified flushes
Date: Thu, 31 Aug 2023 16:56:10 +0000
Message-ID: <20230831165611.2610118-4-yosryahmed@google.com>
References: <20230831165611.2610118-1-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693500981; x=1694105781; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dJkwDc7Wxmywu9Yo0ZIK2ppmyNcYkDsKDS48R26U4fo=;
        b=onL+yixI1Hw0E45nLUTeAKG663+oWCI/D3IutTPmf516S6mKwzXdm4mDaMAodk1W6b
         pn7YH+wPBUVBEabXF7KYa+w3QY7DXyiviyVcEqCWY2muuS9/RrHv2ld43n7Sif8YE/i1
         z6bYsupweiuPGNaewF8ZMWmsE3tyCIkl1kV871VT9aqseA9ry3W2bUsRq9eSGs9mAt4o
         jMVD/ltODgDJ1HWQEWFhc4uCZW/kxy2mCyroQibAO/6/yXGXd4goPGDD5oebkowPsqyR
         v9ax0IHNnSt7UPX3WXpER33Lr6ZFY6BJzOdNTOgP2qw2dajW9JCIwWLLnvCl8Df+S8xA
         XNuw==
In-Reply-To: <20230831165611.2610118-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Tejun Heo <tj@kernel.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

Unified flushing of memcg stats keeps track of the magnitude of pending
updates, and only allows a flush if that magnitude exceeds a threshold.
It also keeps track of the time at which ratelimited flushing should be
allowed as flush_next_time.

A non-unified flush on the root memcg has the same effect as a unified
flush, so let it help unified flushing by resetting pending updates and
kicking flush_next_time forward. Move the logic into the common
do_stats_flush() helper, and do it for all root flushes, unified or
not.

There is a subtle change here, we reset stats_flush_threshold before a
flush rather than after a flush. This probably okay because:

(a) For flushers: only unified flushers check stats_flush_threshold, and
those flushers skip anyway if there is another unified flush ongoing.
Having them also skip if there is an ongoing non-unified root flush is
actually more consistent.

(b) For updaters: Resetting stats_flush_threshold early may lead to more
atomic updates of stats_flush_threshold, as we start updating it
earlier. This should not be significant in practice because we stop
updating stats_flush_threshold when it reaches the threshold anyway. If
we start early and stop early, the number of atomic updates remain the
same. The only difference is the scenario where we reset
stats_flush_threshold early, start doing atomic updates early, and then
the periodic flusher kicks in before we reach the threshold. In this
case, we will have done more atomic updates. However, since the
threshold wasn't reached, then we did not do a lot of updates anyway.

Suggested-by: Michal Koutn=C3=BD <mkoutny@suse.com>
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 mm/memcontrol.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8c046feeaae7..94d5a6751a9e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -647,6 +647,11 @@ static inline void memcg_rstat_updated(struct mem_cgro=
up *memcg, int val)
  */
 static void do_stats_flush(struct mem_cgroup *memcg)
 {
+	/* for unified flushing, root non-unified flushing can help as well */
+	if (mem_cgroup_is_root(memcg)) {
+		WRITE_ONCE(flush_next_time, jiffies_64 + 2*FLUSH_TIME);
+		atomic_set(&stats_flush_threshold, 0);
+	}
 	cgroup_rstat_flush(memcg->css.cgroup);
 }
=20
@@ -665,11 +670,8 @@ static void do_unified_stats_flush(void)
 	    atomic_xchg(&stats_unified_flush_ongoing, 1))
 		return;
=20
-	WRITE_ONCE(flush_next_time, jiffies_64 + 2*FLUSH_TIME);
-
 	do_stats_flush(root_mem_cgroup);
=20
-	atomic_set(&stats_flush_threshold, 0);
 	atomic_set(&stats_unified_flush_ongoing, 0);
 }
=20
--=20
2.42.0.rc2.253.gd59a3bf2b4-goog

