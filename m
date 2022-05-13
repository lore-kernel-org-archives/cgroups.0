From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 4/4] memcg: enable accounting for allocations in
 alloc_fair_sched_group
Date: Fri, 13 May 2022 18:52:20 +0300
Message-ID: <30f5b95a-db87-3924-6ad0-4c302c924ff0@openvz.org>
References: <Ynv7+VG+T2y9rpdk@carbon>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=B97ovzBTCo6Rpt8pan1l5/t89Mv44hmEDRujwkHt9Ic=;
        b=Gn8g+5fjv7e1DNvpLJ5tu50Zc48R9MGuaEXQSp7RNvhogmOV11JQQefjUfc1WAIjlK
         dJ/Lin0vXk+AFC5NAEVYN2uyQ/gVoUsQbdGSNQXxKRCPgLwfFI/l9Bdy731b3hcb9sZ0
         M9Y0mpjbO9Uy/K1xvNR9RdgPtgC2prB26Xi8anmhW3UIQ1yx1q2nGP5nymZuPcIO4zAl
         d9HNvFH9D6xBd+fZ9EhSkrrOJCdp0ME9jdlh24Az1mJ3jeZXcyBhCoUXZDDqEuirAx5s
         UJSJC4S+K2fYuUMqxdXQJbU8gdSPCbignrbxY+XB/Xjch9vQJ0hN6qZ0RIGgOcOB1QxS
         TuPA==
Content-Language: en-US
In-Reply-To: <Ynv7+VG+T2y9rpdk@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Creating of each new cpu cgroup allocates two 512-bytes kernel objects
per CPU. This is especially important for cgroups shared parent memory
cgroup. In this scenario, on nodes with multiple processors, these
allocations become one of the main memory consumers.

Accounting for this memory helps to avoid misuse inside memcg-limited
contianers.

Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 kernel/sched/fair.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a68482d66535..46e66acf7475 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -11529,12 +11529,12 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 
 	for_each_possible_cpu(i) {
 		cfs_rq = kzalloc_node(sizeof(struct cfs_rq),
-				      GFP_KERNEL, cpu_to_node(i));
+				      GFP_KERNEL_ACCOUNT, cpu_to_node(i));
 		if (!cfs_rq)
 			goto err;
 
 		se = kzalloc_node(sizeof(struct sched_entity_stats),
-				  GFP_KERNEL, cpu_to_node(i));
+				  GFP_KERNEL_ACCOUNT, cpu_to_node(i));
 		if (!se)
 			goto err_free_rq;
 
-- 
2.31.1

