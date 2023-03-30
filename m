From: Shaun Tancheff <shaun.tancheff-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] memcg: Set memory min, low, high values along with max
Date: Fri, 31 Mar 2023 03:22:32 +0700
Message-ID: <20230330202232.355471-1-shaun.tancheff@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680207770;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OBkq6KxCtXfKvlem/Zb/2GDPHcnhhSsCCkCs5rwvqhw=;
        b=Ze1fJTTrAjpXdOhtpMZb/pWrc+OxYU0E2dF3+BqmPVjzlrkpBGMbVVwlILNlZ/qbnv
         mjaMFzag7RBRmgw0vQCsufH1JIGiRw7v2iYCClFpCDlDLUrU4Gswed1vjjTf2551B2t1
         y1KP+9T+SgP7GxAskck2N2B38gAgeP1h8RqHlYUanT4Tw9NI9VV37kqbYbk8tYCZyIDs
         wsJyTGiTuvI7HhK6m3Frln7sAMRGFQy5OYDvRxyd+y6Pt5PZs+MaAH06PlqCym4ehpQF
         eb2c6pzclizqej8lG5CHoN5ppB5BHUhjjXI3SqPMD1NHXZxMgzz3d4SwNuVISbEIS9K6
         2xMw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Shaun Tancheff <shaun-3FiXFqZnWiVWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "stable @ vger . kernel . org . Shaun Tancheff" <shaun.tancheff-ZPxbGqLxI0U@public.gmane.org>

From: Shaun Tancheff <shaun-3FiXFqZnWiVWk0Htik3J/w@public.gmane.org>

memcg-v1 does not expose memory min, low, and high.

These values should to be set to reasonable non-zero values
when max is set.

This patch sets them to 10%, 20% and 80% respective to max.

This fixes an issue with memory pressure with file systems
do an unbounded high rate of I/O hitting oom.

Signed-off-by: Shaun Tancheff <shaun.tancheff-ZPxbGqLxI0U@public.gmane.org>
---
 mm/memcontrol.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2eee092f8f11..0f5918d9dd2a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3491,6 +3491,15 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
 		if (max > counter->max)
 			enlarge = true;
 		ret = page_counter_set_max(counter, max);
+		if (!ret && !memsw) {
+			unsigned long min = (max / 10) + 1;
+			unsigned long low = min * 2;
+			unsigned long high = max - low;
+
+			page_counter_set_min(counter, min);
+			page_counter_set_low(counter, low);
+			page_counter_set_high(counter, high);
+		}
 		mutex_unlock(&memcg_max_mutex);
 
 		if (!ret)
-- 
2.34.1

