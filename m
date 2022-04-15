From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: [PATCH 2/4] kselftests: memcg: speed up the memory.high test
Date: Thu, 14 Apr 2022 17:01:31 -0700
Message-ID: <20220415000133.3955987-3-roman.gushchin@linux.dev>
References: <20220415000133.3955987-1-roman.gushchin@linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1649980911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ka6qQQskUc/bYspKrrZopLIlbaTgRjrO9/vj2k3mAsU=;
        b=wp05x2nDGuHhLPy+P4GdOWff81+K1abp8o5tuqik6xqDvkyZ/oSb8zPKoJdbJXS0z26MwT
        P8Kj2Z2Ek+0hQqQeoTDsZjIeeOR1YxkTgZRXdeu3c4v4QGRVFLSqd6ohvg8jDYxZ+1lpKV
        dcMTGqq4kL0n/Bxm/VAcnLYnUTbCP/c=
In-Reply-To: <20220415000133.3955987-1-roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>

After commit 0e4b01df8659 ("mm, memcg: throttle allocators when
failing reclaim over memory.high") allocating memory over memory.high
became very time consuming. But it's exactly what the memory.high
test from cgroup kselftests is doing: it tries to allocate 100M with
30M memory.high value. It takes forever to complete.

In order to keep it passing (or failing) in a reasonable amount of
time let's try to allocate only a little over 30M: 31M to be precise.

With this change test_memcontrol finishes in a reasonable amount of
time:
  $ time ./test_memcontrol
  ok 1 test_memcg_subtree_control
  ok 2 test_memcg_current
  ok 3 test_memcg_min
  ok 4 test_memcg_low
  ok 5 test_memcg_high
  ok 6 test_memcg_max
  ok 7 test_memcg_oom_events
  ok 8 test_memcg_swap_max
  ok 9 test_memcg_sock
  ok 10 test_memcg_oom_group_leaf_events
  ok 11 test_memcg_oom_group_parent_events
  ok 12 test_memcg_oom_group_score_events

  real	0m2.273s
  user	0m0.064s
  sys	0m0.739s

Signed-off-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 00b430e7f2a2..9c1f19fe2e37 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -607,7 +607,7 @@ static int test_memcg_high(const char *root)
 	if (cg_write(memcg, "memory.high", "30M"))
 		goto cleanup;
 
-	if (cg_run(memcg, alloc_anon, (void *)MB(100)))
+	if (cg_run(memcg, alloc_anon, (void *)MB(31)))
 		goto cleanup;
 
 	if (!cg_run(memcg, alloc_pagecache_50M_check, NULL))
-- 
2.35.1

