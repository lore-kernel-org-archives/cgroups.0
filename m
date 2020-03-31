From: Chris Down <chris@chrisdown.name>
Subject: [PATCH] mm, memcg: Do not high throttle allocators based on
 wraparound
Date: Tue, 31 Mar 2020 16:24:24 +0100
Message-ID: <20200331152424.GA1019937@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=6PtH4wzWMiH5JmxAt904ilpPuqtvXlZEsu04wa6si/k=;
        b=P8qu2lfTpI9t1V10h5AQtX1pY3rsMg/xWtmYiBZTO8QwsPjlZ48gV9R/FoFJmeJWE0
         6N9UVOHFvpnOaSH+7UMgcWEAHiG7XS3XGxcYf4DGWJ7JjdHdvf5MBmfs7Auv00Bns8rd
         7JaAJ9XeB4dUlJrtAGbvmVJaQ85yG05sxP8nA=
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Jakub Kicinski <kuba@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

From: Jakub Kicinski <kuba@kernel.org>

If a cgroup violates its memory.high constraints, we may end
up unduly penalising it. For example, for the following hierarchy:

A:   max high, 20 usage
A/B: 9 high, 10 usage
A/C: max high, 10 usage

We would end up doing the following calculation below when calculating
high delay for A/B:

A/B: 10 - 9 = 1...
A:   20 - PAGE_COUNTER_MAX = 21, so set max_overage to 21.

This gets worse with higher disparities in usage in the parent.

I have no idea how this disappeared from the final version of the patch,
but it is certainly Not Good(tm). This wasn't obvious in testing
because, for a simple cgroup hierarchy with only one child, the result
is usually roughly the same. It's only in more complex hierarchies that
things go really awry (although still, the effects are limited to a
maximum of 2 seconds in schedule_timeout_killable at a maximum).

[chris@chrisdown.name: changelog]

Fixes: e26733e0d0ec ("mm, memcg: throttle allocators based on ancestral memory.high")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: stable@vger.kernel.org # 5.4.x
---
 mm/memcontrol.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index eecf003b0c56..75a978307863 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2336,6 +2336,9 @@ static unsigned long calculate_high_delay(struct mem_cgroup *memcg,
 		usage = page_counter_read(&memcg->memory);
 		high = READ_ONCE(memcg->high);
 
+		if (usage <= high)
+			continue;
+
 		/*
 		 * Prevent division by 0 in overage calculation by acting as if
 		 * it was a threshold of 1 page
-- 
2.26.0

