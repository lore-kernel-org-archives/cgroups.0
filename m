From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH mm v4 5/9] memcg: enable accounting for percpu allocation of
 struct psi_group_cpu
Date: Mon, 13 Jun 2022 08:35:17 +0300
Message-ID: <33151594-4168-d01b-56b6-dc996d226a7d@openvz.org>
References: <3e1d6eab-57c7-ba3d-67e1-c45aa0dfa2ab@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=B3zm8wtF1vA2GYm2+mdF7egB2sMmmpE2kcaPBaO2eto=;
        b=aNTN9ecStVPQ2d3BHO8r2ERVbHTttzP8TpBGu400gwgeTcHpH5cOc8cGKcJF5B4VSG
         Pl404daaNaSR+XfYhnMPIJuJDZNnXll9sSKc8Bl7DpIBinOElRj9Cdogfo8nhbIPgz6H
         LEhnRv6PLI/1q4OQhQVbZHRXsvpYNjKANwS6bgzq+oxPSUzB7Oijv5PyZP6r2dUx8G0b
         5/U0JAHLUzb4KnI6Ev9AKyFvBj77iQEV+KqIkwQ1NbPYXEy0SxOYw8Yaln47mLwPQ3Ko
         TdBRQtjCGU4GK/9EIclgy8Gop96FJszFi5oVXiUUTrnqwe52akMXbhog8arLPS0+Gyux
         fXRQ==
Content-Language: en-US
In-Reply-To: <3e1d6eab-57c7-ba3d-67e1-c45aa0dfa2ab-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
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
 kernel/sched/psi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index ec66b40bdd40..c95e87269fc5 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -957,11 +957,12 @@ int psi_cgroup_alloc(struct cgroup *cgroup)
 	if (static_branch_likely(&psi_disabled))
 		return 0;
 
-	cgroup->psi = kmalloc(sizeof(struct psi_group), GFP_KERNEL);
+	cgroup->psi = kmalloc(sizeof(struct psi_group), GFP_KERNEL_ACCOUNT);
 	if (!cgroup->psi)
 		return -ENOMEM;
 
-	cgroup->psi->pcpu = alloc_percpu(struct psi_group_cpu);
+	cgroup->psi->pcpu = alloc_percpu_gfp(struct psi_group_cpu,
+					     GFP_KERNEL_ACCOUNT);
 	if (!cgroup->psi->pcpu) {
 		kfree(cgroup->psi);
 		return -ENOMEM;
-- 
2.36.1

