From: Vasily Averin <vvs@openvz.org>
Subject: [PATCH mm v4 9/9] memcg: enable accounting for perpu allocation of
 struct rt_rq
Date: Mon, 13 Jun 2022 08:35:50 +0300
Message-ID: <fe741e8a-b729-1efa-ff63-137cc29adb6e@openvz.org>
References: <3e1d6eab-57c7-ba3d-67e1-c45aa0dfa2ab@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=GpreIe1vVrFK0GRTTTBCrmu4K38+/AoKp6X51SotBdU=;
        b=pOR7O1t5o1xCznms3YZVoDk//h+f8/fV4zwbTF71juOxY1C62zNSCCgDsAvK4WX+hN
         wsAJDy6ZwBwLoUy5BIB1oRNm4wHPLlfZ8DY1WmWTBalya5YxORe+47B+QWkq1whgFSPE
         NALVRGhpOBGJ8npvVljSdkejj7UwD33OQ3IXaaMzsb2YhN9Vd+x0GS1QdHn11aYnQdbh
         j81zIPiB/Y6l0WXfdX+sWHlsuHGnoM1TO/QbZl7dZQxj68I7nAVGUydJvYKOvwTV3L55
         15XFDDiDYb79xpH1rJssMF4rPQd99yM34z3FIvgplvSdziiZXPCcdj7IYtwxn7W+CSWX
         tHaw==
Content-Language: en-US
In-Reply-To: <3e1d6eab-57c7-ba3d-67e1-c45aa0dfa2ab@openvz.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel@openvz.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Muchun Song <songmuchun@bytedance.com>, cgroups@vger.kernel.org

If enabled in config, alloc_rt_sched_group() is called for each new
cpu cgroup and allocates a huge (~1700 bytes) percpu struct rt_rq.
This significantly exceeds the size of the percpu allocation in the
common part of cgroup creation.

Memory allocated during new cpu cgroup creation
(with enabled RT_GROUP_SCHED):
common part:    ~11Kb   +   318 bytes percpu
cpu cgroup:     ~2.5Kb  + ~2800 bytes percpu

Accounting for this memory helps to avoid misuse inside memcg-limited
containers.

Signed-off-by: Vasily Averin <vvs@openvz.org>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Muchun Song <songmuchun@bytedance.com>
---
 kernel/sched/rt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 8c9ed9664840..44a8fc096e33 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -256,7 +256,7 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 
 	for_each_possible_cpu(i) {
 		rt_rq = kzalloc_node(sizeof(struct rt_rq),
-				     GFP_KERNEL, cpu_to_node(i));
+				     GFP_KERNEL_ACCOUNT, cpu_to_node(i));
 		if (!rt_rq)
 			goto err;
 
-- 
2.36.1

