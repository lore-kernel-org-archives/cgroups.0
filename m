From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH 1/4] mm: memcontrol: remove memcg check from memcg_oom_recover
Date: Sat, 13 Feb 2021 01:01:56 +0800
Message-ID: <20210212170159.32153-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hdVPqrFgHTgC5mTllAq9fBNSua/ngygoblWbV1oigUI=;
        b=Wqq++mXdhn6HE2fF23Wh8h9AFqcynW3GPMQs21nMApsmcn9L4h6O8KtYPRjAUeNCDn
         iNMu2YDjYyY8JDBGuTJAEVoQcXdkJcwdAMiDMk/43qpb0yi2y/gjcH86jMmW4oRF16x3
         L8UNDDz8q5XJPbV/D8jN4450QYrAUnCaJ5cUuSHsVoO/e/3r98A0TR3WAK0qaFp0ufcz
         5FcU7+Yz6okzH9k+R28b7nmm6Z9f63wUb2h6VTNDmLX3s/VAfDqzX8JRwrHt08eJ5okY
         cIbjgV0hM5kJGL5B1Ttc4NuCgqtZIs5c37uIrW6rDWoTarmMsvNlMxDDAHHWfGQAiIkl
         0GaA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

The memcg_oom_recover() almost never do anything but the test (because
oom_disabled is a rarely used) is just waste of cycles in some hot
paths (e.g. kmem uncharge). And it is very small, so it is better to
make it inline. Also, the parameter of memcg cannot be NULL, so removing
the check can reduce useless check.

Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 mm/memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8c035846c7a4..7afca9677693 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1925,7 +1925,7 @@ static int memcg_oom_wake_function(wait_queue_entry_t *wait,
 	return autoremove_wake_function(wait, mode, sync, arg);
 }
 
-static void memcg_oom_recover(struct mem_cgroup *memcg)
+static inline void memcg_oom_recover(struct mem_cgroup *memcg)
 {
 	/*
 	 * For the following lockless ->under_oom test, the only required
@@ -1935,7 +1935,7 @@ static void memcg_oom_recover(struct mem_cgroup *memcg)
 	 * achieved by invoking mem_cgroup_mark_under_oom() before
 	 * triggering notification.
 	 */
-	if (memcg && memcg->under_oom)
+	if (memcg->under_oom)
 		__wake_up(&memcg_oom_waitq, TASK_NORMAL, 0, memcg);
 }
 
-- 
2.11.0

