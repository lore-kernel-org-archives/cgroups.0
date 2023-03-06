From: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2, 4/4] mm, memcg: Prevent memory.soft_limit_in_bytes load/store tearing
Date: Mon,  6 Mar 2023 23:41:38 +0800
Message-ID: <20230306154138.3775-5-findns94@gmail.com>
References: <20230306154138.3775-1-findns94@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678117341;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kK+Z862YESi30yZiQZC0bVwPclz8DCYbgAA/NRofcVQ=;
        b=MQT4Hnfv44YHIOGxCsajlC63JnDzxTzHLtNuHQ/4uiD559rPdzNVrnv4Px3cAWbxDT
         mINlBKvoJaziRxF2qQ48A+vB+8zsxIWkAgcnn431o0fdeuq+YmC8FrPglq91Yb0DDBkJ
         WCLdr+wil1dX/B6cEeylUBOsYJhZePeAW3jZ1aJkQWk2cbXPdeqFFkZtLAxMl1FEsIxI
         ZOYN/pszFbWfajWHX+xyZoGuf9/U9Vv9ybClKwIRhxirENLM5KmkGZl7e3gna1SBvxIm
         JgGvX3aNy1f0bzrfeRrAG0+mzAEsXE05Es60AK0gbwyXOMMURS2NJzZ+Y2ZsdTWsYAeT
         IXVA==
In-Reply-To: <20230306154138.3775-1-findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tangyeechou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The knob for cgroup v1 memory controller: memory.soft_limit_in_bytes
is not protected by any locking so it can be modified while it is used.
This is not an actual problem because races are unlikely.
But it is better to use READ_ONCE/WRITE_ONCE to prevent compiler from
doing anything funky.

The access of memcg->soft_limit is lockless,
so it can be concurrently set at the same time as we are
trying to read it.

Signed-off-by: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 26605b2f51b1..20566f59bbcb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3728,7 +3728,7 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 	case RES_FAILCNT:
 		return counter->failcnt;
 	case RES_SOFT_LIMIT:
-		return (u64)memcg->soft_limit * PAGE_SIZE;
+		return (u64)READ_ONCE(memcg->soft_limit) * PAGE_SIZE;
 	default:
 		BUG();
 	}
@@ -3870,7 +3870,7 @@ static ssize_t mem_cgroup_write(struct kernfs_open_file *of,
 		if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
 			ret = -EOPNOTSUPP;
 		} else {
-			memcg->soft_limit = nr_pages;
+			WRITE_ONCE(memcg->soft_limit, nr_pages);
 			ret = 0;
 		}
 		break;
-- 
2.17.1

