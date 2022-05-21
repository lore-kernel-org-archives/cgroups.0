From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH mm v2 9/9] memcg: enable accounting for percpu allocation of
 struct rt_rq
Date: Sat, 21 May 2022 19:39:03 +0300
Message-ID: <d7094aa2-1cd0-835c-9fb7-d76003c47dad@openvz.org>
References: <Yn6aL3cO7VdrmHHp@carbon>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=6jvwz9W+Iz8zAbRj3RpjaqWTb9wfhWcoLKf0WgDlxvc=;
        b=z+7zb9+IXLxjeouRHXJcNV0+xrS40uzvpcAPCutozFR8IWdb2KWc/t9yiKX/jyzhj7
         ihKo6se9s6Vpj74Ev9988DNbDjBpqQ9URssroOdAgjND0KNPrfzja3+LfQqRSt211upy
         XTHVRdiyknklG9q0+EsRKSJ61ETF6Vql14xb+CJcmFGQ6vie5QKGaRXPmWr/J2nKoaI/
         nT3hsQNrJRvfvxSOrCUyudJPIkr1d3kKz/0mUU1OdsImWpQO6lswnLjdQeCY2UJCxDIl
         V742mWQPrgdj8a5cPsG23+DzDiB7dOIBqa2RBnHd2qrPzm5ObIXJCp6x/9A4wJfH953N
         D8rA==
Content-Language: en-US
In-Reply-To: <Yn6aL3cO7VdrmHHp@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

If enabled in config, alloc_rt_sched_group() is called for each new
cpu cgroup and allocates a huge (~1700 bytes) percpu struct rt_rq.
This significantly exceeds the size of the percpu allocation in the
common part of cgroup creation.

Memory allocated during new cpu cgroup creation
(with enabled RT_GROUP_SCHED):
common part:    ~11Kb   +   318 bytes percpu
cpu cgroup:     ~2.5Kb  + ~2800 bytes percpu

Accounting for this memory helps to avoid misuse inside memcg-limited
contianers.

Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 kernel/sched/rt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index a32c46889af8..2639d6dcebe6 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -206,7 +206,7 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 
 	for_each_possible_cpu(i) {
 		rt_rq = kzalloc_node(sizeof(struct rt_rq),
-				     GFP_KERNEL, cpu_to_node(i));
+				     GFP_KERNEL_ACCOUNT, cpu_to_node(i));
 		if (!rt_rq)
 			goto err;
 
-- 
2.36.1

