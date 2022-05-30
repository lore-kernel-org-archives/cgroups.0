From: Vasily Averin <vvs@openvz.org>
Subject: [PATCH mm v3 5/9] memcg: enable accounting for percpu allocation of
 struct psi_group_cpu
Date: Mon, 30 May 2022 14:26:26 +0300
Message-ID: <14a70615-1240-9538-8be9-b2aedcb0fc11@openvz.org>
References: <06505918-3b8a-0ad5-5951-89ecb510138e@openvz.org>
 <cover.1653899364.git.vvs@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=xFFlfL4fe1ilOdXrhQDtJsKH7Nsk6vFtTN8mntfqwUg=;
        b=34zCQZXlG6JFBzjyCw0P2LGetND/flm33L/Fc6uf6jHK6/jEfMO96WNnf7hXhsDOas
         vlwNhLfTkafo3h9lT+WD69MjpNURqriIr07F8QtefHyBUTaEmU8U483Y1ln8oOuRxbpp
         LR4GsOA+lHlX1CBAj+3X99k3UES9/06Fbi80YUczOu5arE7/vqr02S58TZWW8WtAQnxc
         YuucM1hIVCx2HLssP7y2ZKkHD0uS5v6R2fTS4ubTc1FG6IRG4hxPb/nYOG7cDQglfeiH
         mC930GXFgsHBQqKKrjUzfs6TUJacEj78xhRipAbhjT0duobsK209zKxFbdiBs/Dxk7hO
         dPFg==
Content-Language: en-US
In-Reply-To: <cover.1653899364.git.vvs@openvz.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel@openvz.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Muchun Song <songmuchun@bytedance.com>, cgroups@vger.kernel.org

struct pci_group_cpu is percpu allocated for each new cgroup and can
consume a significant portion of all allocated memory on nodes with
a large number of CPUs.

Common part of the cgroup creation:
Allocs  Alloc   $1*$2   Sum     Allocation
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
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 kernel/sched/psi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index a337f3e35997..f3ec8553283e 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -957,7 +957,8 @@ int psi_cgroup_alloc(struct cgroup *cgroup)
 	if (static_branch_likely(&psi_disabled))
 		return 0;
 
-	cgroup->psi.pcpu = alloc_percpu(struct psi_group_cpu);
+	cgroup->psi.pcpu = alloc_percpu_gfp(struct psi_group_cpu,
+					    GFP_KERNEL_ACCOUNT);
 	if (!cgroup->psi.pcpu)
 		return -ENOMEM;
 	group_init(&cgroup->psi);
-- 
2.36.1

