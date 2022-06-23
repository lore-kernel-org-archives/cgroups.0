From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH mm v5 5/9] memcg: enable accounting for percpu allocation of
 struct psi_group_cpu
Date: Thu, 23 Jun 2022 17:51:29 +0300
Message-ID: <b837e43e-f05c-9ae7-a582-c6d2d5907ea5@openvz.org>
References: <4e685057-b07d-745d-fdaa-1a6a5a681060@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=waMbR4Vj3d2Yx3tC82MaoYQ2maUSxBJAR+0Iakz5FDI=;
        b=YNvr4xo3AtwQzeXJO0a0Zs/pJf/cfhwOyUbueOMf0dW7rfYbzeNXzzeTckjXHZagnx
         IL85gF0d8dj8iu8D/NKKFFpKBqeU48c+utRpVkVyvj5DixZAKXeknlRq8N2LyZGOTi+R
         hGN8BepYHBGzguV4vsrHooHWcagsJSb29bCFzzGcw2QHmp3PiwCLs5lRYky96HtSBt7M
         EA4L0Sp+aBwKz/fZyvAIqFUTbxk9l9Tji0K20GNE67AGI98/zeiTxuFXgKawjUa1NN+o
         2Sces7CzSgUk2DMCdi7DOn11celMtSmNASSbOpBFHfM4AG9IAqxKziAlLGfROZMJkciM
         MZ7A==
Content-Language: en-US
In-Reply-To: <4e685057-b07d-745d-fdaa-1a6a5a681060-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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

Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
---
 kernel/sched/psi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index a337f3e35997..0da10159d3d9 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -957,7 +957,7 @@ int psi_cgroup_alloc(struct cgroup *cgroup)
 	if (static_branch_likely(&psi_disabled))
 		return 0;
 
-	cgroup->psi.pcpu = alloc_percpu(struct psi_group_cpu);
+	cgroup->psi.pcpu = alloc_percpu_gfp(struct psi_group_cpu, GFP_KERNEL_ACCOUNT);
 	if (!cgroup->psi.pcpu)
 		return -ENOMEM;
 	group_init(&cgroup->psi);
-- 
2.36.1

