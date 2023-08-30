From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 3/4] mm: memcg: let non-unified root stats flushes help
 unified flushes
Date: Wed, 30 Aug 2023 17:53:34 +0000
Message-ID: <20230830175335.1536008-4-yosryahmed@google.com>
References: <20230830175335.1536008-1-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693418027; x=1694022827; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dJkwDc7Wxmywu9Yo0ZIK2ppmyNcYkDsKDS48R26U4fo=;
        b=4CrOY4QoRdDND9dvtODbK5A0YV+U7OqLoXHtqOIWs/OOn9gFjSvSGgqEgH/7NojirA
         DKpcmlIM2km86Z188faUY9lxCDvPOKKUAQHL6K5vdoF8AFL3jxEgLsAV20tuivA8Xncc
         eBJZD78LArPrzqy86bUAMmZU2ZTK3uVC521Ga5mTpUi6PTjlNYZzGHZ0GxSiWBnfnlxM
         ZUi5DajEwAxX5eT63OEz3v91aFqgovVcCpjlMkQs5X5AV652PIPYZa7fgZgSEydQE0yl
         AtVJRe3aEg/Z29/Uk5I/C2Ip6wnI2n3DQH8MUCzvSuEPwFbp8b9OZlMQbSlW7nJImWb1
         /QTg==
In-Reply-To: <20230830175335.1536008-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

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

Suggested-by: Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
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

