From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH] memcg, oom: no oom-kill for __GFP_RETRY_MAYFAIL
Date: Sun, 28 Apr 2019 16:56:13 -0700
Message-ID: <20190428235613.166330-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=yu6NcO6qkqCy2IZdfcCLb2i4aKMiT552Q3oiWALCBq0=;
        b=t0IuUsXn9gaq3SQut1xYfgcWiEy8RtkERl2pBXCiH9XceacJW0QWyY0WBZHCewi6u6
         YRjtmVCPM0+qoQv1Z87j/N+3XJ6aoclitm6grIraYu8Y9Bqhjs/dhYKOjl3kFgZZJthp
         pG7y7jAYeykyDXhBxasCXYScBOh8nNzAxjTMW89k/5W00JPfrgSZ9b5ObblARtA3d0rr
         KacNMeGFpwmM7JL572xU2Rag7vO9sZNeLdQO7gbiSSqb9VOrg7HXmC04PDokV2Tk6AJU
         C6mcwZUohipajKu8TC+IP/nEKyhgdFNNkhV+kO/BxejCC4n5s/0FpqjJ2o1Bvmw+R4+U
         Husw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>

The documentation of __GFP_RETRY_MAYFAIL clearly mentioned that the
OOM killer will not be triggered and indeed the page alloc does not
invoke OOM killer for such allocations. However we do trigger memcg
OOM killer for __GFP_RETRY_MAYFAIL. Fix that.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
---
 mm/memcontrol.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2713b45ec3f0..99eca724ed3b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2294,7 +2294,6 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	unsigned long nr_reclaimed;
 	bool may_swap = true;
 	bool drained = false;
-	bool oomed = false;
 	enum oom_status oom_status;
 
 	if (mem_cgroup_is_root(memcg))
@@ -2381,7 +2380,7 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (nr_retries--)
 		goto retry;
 
-	if (gfp_mask & __GFP_RETRY_MAYFAIL && oomed)
+	if (gfp_mask & __GFP_RETRY_MAYFAIL)
 		goto nomem;
 
 	if (gfp_mask & __GFP_NOFAIL)
@@ -2400,7 +2399,6 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	switch (oom_status) {
 	case OOM_SUCCESS:
 		nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
-		oomed = true;
 		goto retry;
 	case OOM_FAILED:
 		goto force;
-- 
2.21.0.593.g511ec345e18-goog

