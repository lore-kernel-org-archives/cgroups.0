From: Vasily Averin <vvs@openvz.org>
Subject: [PATCH mm v3 6/9] memcg: enable accounting for percpu allocation of
 struct cgroup_rstat_cpu
Date: Mon, 30 May 2022 14:26:36 +0300
Message-ID: <2fbede88-6ef7-4ce7-b3a3-ec349bc2cc06@openvz.org>
References: <06505918-3b8a-0ad5-5951-89ecb510138e@openvz.org>
 <cover.1653899364.git.vvs@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=lq150UndXxHEWEhIvsqNd7aCUGl0NaprSMERTMCukMc=;
        b=yL39YrAU3i/NoAsVN95rMmJdSBldmOz1PwlQ73jfMuWdBXrupcnQd2G2xM7mDHLOTw
         5cG1/LbM9ELIeheHf4QRIj9qoEGrwWMMYtTwVRLQaMrZRY2GTI6OHsCLJntYiy66xJLY
         dcyIU7JJNYbu0N8ONgoWHtdXARu59CTqL/J5y5kDSzriAP6IQIHw/6y+net9f403FUOP
         Aes5Xixs/Zs3CgFNNxQ0wi8z2ztQjubVeeh91mEi5dPW+K70JTAiWKmInlePnVUr/5IK
         DTGNdcEdAZiKlmqMNwtccV54snA1/n0921UB4g/zMC0+ndU8bwXFam+o5cqi5VihlEFc
         srgA==
Content-Language: en-US
In-Reply-To: <cover.1653899364.git.vvs@openvz.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel@openvz.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Muchun Song <songmuchun@bytedance.com>, cgroups@vger.kernel.org

struct cgroup_rstat_cpu is percpu allocated for each new cgroup and
can consume a significant portion of all allocated memory on nodes
with a large number of CPUs.

Common part of the cgroup creation:
Allocs  Alloc   $1*$2   Sum	Allocation
number  size
--------------------------------------------
16  ~   352     5632    5632    KERNFS
1   +   4096    4096    9728    (cgroup_mkdir+0xe4)
1       584     584     10312   (radix_tree_node_alloc.constprop.0+0x89)
1       192     192     10504   (__d_alloc+0x29)
2       72      144     10648   (avc_alloc_node+0x27)
2       64      128     10776   (percpu_ref_init+0x6a)
1       64      64      10840   (memcg_list_lru_alloc+0x21a)
percpu:
1   +   192     192     192     call_site=psi_cgroup_alloc+0x1e
1   +   96      96      288     call_site=cgroup_rstat_init+0x5f
2       12      24      312     call_site=percpu_ref_init+0x23
1       6       6       318     call_site=__percpu_counter_init+0x22

 '+' -- to be accounted,
 '~' -- partially accounted

Signed-off-by: Vasily Averin <vvs@openvz.org>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 kernel/cgroup/rstat.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 24b5c2ab5598..2904b185b01b 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -257,7 +257,8 @@ int cgroup_rstat_init(struct cgroup *cgrp)
 
 	/* the root cgrp has rstat_cpu preallocated */
 	if (!cgrp->rstat_cpu) {
-		cgrp->rstat_cpu = alloc_percpu(struct cgroup_rstat_cpu);
+		cgrp->rstat_cpu = alloc_percpu_gfp(struct cgroup_rstat_cpu,
+						   GFP_KERNEL_ACCOUNT);
 		if (!cgrp->rstat_cpu)
 			return -ENOMEM;
 	}
-- 
2.36.1

