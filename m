From: Shakeel Butt <shakeelb@google.com>
Subject: [RESEND PATCH v2 1/2] memcg, oom: no oom-kill for __GFP_RETRY_MAYFAIL
Date: Sun, 12 May 2019 09:09:26 -0700
Message-ID: <20190512160927.80042-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ZQi/sjipIMJL03RXDXGUBdRsbi1X2/+nI6E1TTfR44o=;
        b=rT6GYZe9JljSs+O2RaDoCdYaRjz42r+UWesVjP61KLuG6brTai+B8I0s6wONcIdeUT
         ZgBS6h91WxDWjJLdDl7mdy4nSk0wB5tEBBSyUohFeLAeQOweZF4nSJgoeSX+Z5lOzW7w
         w1Kh4U5cruF03Fr6NcBIc2mu420URojoYNetRwXEgPNIIXNvzdCfMX4cuXwBaod2hE8y
         AcVWU+jdpmBSZ75RVzArG/oirAEeyO6gh8KNjZ7rVUrwOjObNx6lGpqFGYsn7BWv0Bz4
         yPD+2/26OCSf5xX0lvA/2dklhzgpKqeKHWI2sajCsyjGu0mYRjb04/FHoNtrsslXB/MH
         Fe+A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>

The documentation of __GFP_RETRY_MAYFAIL clearly mentioned that the
OOM killer will not be triggered and indeed the page alloc does not
invoke OOM killer for such allocations. However we do trigger memcg
OOM killer for __GFP_RETRY_MAYFAIL. Fix that. This flag will used later
to not trigger oom-killer in the charging path for fanotify and inotify
event allocations.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
---
Changelog since v1:
- commit message updated.

 mm/memcontrol.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2535e54e7989..9548dfcae432 100644
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
2.21.0.1020.gf2820cf01a-goog

