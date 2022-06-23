From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH mm v5 6/9] memcg: enable accounting for percpu allocation of
 struct cgroup_rstat_cpu
Date: Thu, 23 Jun 2022 17:51:37 +0300
Message-ID: <9c7957f8-ba89-4c9a-bd61-d86bca18a546@openvz.org>
References: <4e685057-b07d-745d-fdaa-1a6a5a681060@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=fYBLg0GorDblKEye4tioxlFuzZ/2NCtjLKl9KE3W8YI=;
        b=ilILMVAcvthPkldn+Fa+LkoIG/WSsFH8M7YG6eZI6EykQ+3oB7c4PdbWYXjZqjJ+43
         FWPcHN93ez+UtYY/3FGn60gVrWz2wmHIsFXq/TFUle1S2965DVGnZ+G7T88vtlrYFmp+
         yXP01mugIN86XV+s+rNzVqBycfic42Rq5VXNV9DBPQH+yuwZrrP0STBifVHqjRAjGW7J
         uYweDn2FveDwN4KUNlAFLo/+FqPrpfOFrs2q/44dDgBdmYC7a4GXjqZwPQuqOjaHf6cx
         cJOheLE1U00l7XXoRAwkq1Qbu9NV/7vftEsfDxwdNHKeI9Z/sKkWD5mRMqV1KP3cgxL5
         p0uQ==
Content-Language: en-US
In-Reply-To: <4e685057-b07d-745d-fdaa-1a6a5a681060-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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

Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Acked-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
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

