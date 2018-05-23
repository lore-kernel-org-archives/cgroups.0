From: Tejun Heo <tj@kernel.org>
Subject: [PATCH REPOST] mm: memcg: allow lowering memory.swap.max below the
 current usage
Date: Wed, 23 May 2018 11:50:41 -0700
Message-ID: <20180523185041.GR1718769@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=9U6A1Ro6rTIyzu6lM/AUu8I0xnd8/cO0kB0s+DrXUKg=;
        b=h3FNCqq5NFelKs3/BUgkNQFJMZG/jrs8XdggvVjBeL5RE9iyEaqEjOY/PIq1umM+bZ
         Z0FK9UqQeUIaT/DJUcJAq3Iyd8VrviFod8yfhMVn9TadGXVjKtL87EZmyzcdNurBihg6
         bRNr/sNGcRCrvnZFzcTcZo92eKX5J8jxLPQ3hTRjOYlOKBp7mZXbqbs4PWOAhAlUHjxs
         6EDP2nCWpAAZbNb3qW32awm6JaXAIKpAt27QCEuc/YhvLLM3Nc27lEyJUB5PB8E2shqH
         HMKR6qnvZlKXkelZwhP7INnhHW1rlShw1LrN7hpif0SafzPPbml+SqB//+MuybfgEyp6
         HYyA==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, kernel-team@fb.com, Michal Hocko <mhocko@kernel.org>, Shaohua Li <shli@fb.com>, Rik van Riel <riel@surriel.com>, cgroups@vger.kernel.org

Currently an attempt to set swap.max into a value lower than the
actual swap usage fails, which causes configuration problems as
there's no way of lowering the configuration below the current usage
short of turning off swap entirely.  This makes swap.max difficult to
use and allows delegatees to lock the delegator out of reducing swap
allocation.

This patch updates swap_max_write() so that the limit can be lowered
below the current usage.  It doesn't implement active reclaiming of
swap entries for the following reasons.

* mem_cgroup_swap_full() already tells the swap machinary to
  aggressively reclaim swap entries if the usage is above 50% of
  limit, so simply lowering the limit automatically triggers gradual
  reclaim.

* Forcing back swapped out pages is likely to heavily impact the
  workload and mess up the working set.  Given that swap usually is a
  lot less valuable and less scarce, letting the existing usage
  dissipate over time through the above gradual reclaim and as they're
  falted back in is likely the better behavior.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Rik van Riel <riel@surriel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shaohua Li <shli@fb.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: cgroups@vger.kernel.org
---
Hello, Andrew.

This was buried in the thread discussing Roman's original patch.  The
consensus seems to be that this simple approach is what we wanna do at
least for now.  Can you please pick it up?

Thanks.

 Documentation/cgroup-v2.txt |    5 +++++
 mm/memcontrol.c             |    6 +-----
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -1199,6 +1199,11 @@ PAGE_SIZE multiple when read back.
 	Swap usage hard limit.  If a cgroup's swap usage reaches this
 	limit, anonymous memory of the cgroup will not be swapped out.
 
+	When reduced under the current usage, the existing swap
+	entries are reclaimed gradually and the swap usage may stay
+	higher than the limit for an extended period of time.  This
+	reduces the impact on the workload and memory management.
+
 
 Usage Guidelines
 ~~~~~~~~~~~~~~~~
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6144,11 +6144,7 @@ static ssize_t swap_max_write(struct ker
 	if (err)
 		return err;
 
-	mutex_lock(&memcg_limit_mutex);
-	err = page_counter_limit(&memcg->swap, max);
-	mutex_unlock(&memcg_limit_mutex);
-	if (err)
-		return err;
+	xchg(&memcg->swap.limit, max);
 
 	return nbytes;
 }
