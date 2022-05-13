From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/4] memcg: enable accounting for large allocations in
 mem_cgroup_css_alloc
Date: Fri, 13 May 2022 18:51:41 +0300
Message-ID: <212f1b74-7d4e-29f2-9e92-2a1820beff61@openvz.org>
References: <Ynv7+VG+T2y9rpdk@carbon>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=BfP2QbXgT8q1zmWgkJaryOzl/XyZ6at33g2N+Nc7zPk=;
        b=6txlcoWsI7zISUGe8NDPxDUvF4kxC8y2X+5UrIZhcNoNC4JYSC+cvbM3sadqCcowD5
         tBTAsgj2kyaKHkYS2MQXT3BnB/qshrnISvYN79+/iIGWgJJaJLjCM2zBwRoMUbxdcKbd
         YWtfJwqfhXXwkR+uTIjD8TZ0BDxmWa6rVDorB1nAFEXWNk6CeK2E6IW0ZLeYf8NgNPxX
         N+hEFX8HsYeMR9oALprdTIkHW+6sTaM1Z3Nrh/FOYbCU7ZQImBQ3NZRUPUoW7zp3Nvi6
         kb1HHi3tcQxLNSCyEGuVbibNfAS2WKstPOQgXJCqc5rLtsuiUof/D2Us/qfbG4/ITDwG
         oEhw==
Content-Language: en-US
In-Reply-To: <Ynv7+VG+T2y9rpdk@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

cgroup mkdir can be misused inside memcg limited container. It can allocate
a lot of host memory without memcg accounting, cause global memory shortage
and force OOM to kill random host process.

Below [1] is result of mkdir /sys/fs/cgroup/test tracing on VM with 4 cpus

number	bytes	$1*$2	sum	note	call_site
of	alloc
allocs
------------------------------------------------------------
1       14448   14448   14448   =       percpu_alloc_percpu:
1       8192    8192    22640           (mem_cgroup_css_alloc+0x54)
49      128     6272    28912           (__kernfs_new_node+0x4e)
49      96      4704    33616           (simple_xattr_alloc+0x2c)
49      88      4312    37928           (__kernfs_iattrs+0x56)
1       4096    4096    42024           (cgroup_mkdir+0xc7)
1       3840    3840    45864   =       percpu_alloc_percpu:
4       512     2048    47912           (alloc_fair_sched_group+0x166)
4       512     2048    49960           (alloc_fair_sched_group+0x139)
1       2048    2048    52008           (mem_cgroup_css_alloc+0x109)
	[smaller objects skipped]
---
Total			61728

'=' --  accounted allocations

This patch enabled accounting for one of the main memory hogs in this
experiment: allocation which are called inside mem_cgroup_css_alloc()

Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Link: [1] https://lore.kernel.org/all/1aa4cd22-fcb6-0e8d-a1c6-23661d618864-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org/
---
 mm/memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 598fece89e2b..52c6163ba6dc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5031,7 +5031,7 @@ static int alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
 {
 	struct mem_cgroup_per_node *pn;
 
-	pn = kzalloc_node(sizeof(*pn), GFP_KERNEL, node);
+	pn = kzalloc_node(sizeof(*pn), GFP_KERNEL_ACCOUNT, node);
 	if (!pn)
 		return 1;
 
@@ -5083,7 +5083,7 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
 	int __maybe_unused i;
 	long error = -ENOMEM;
 
-	memcg = kzalloc(struct_size(memcg, nodeinfo, nr_node_ids), GFP_KERNEL);
+	memcg = kzalloc(struct_size(memcg, nodeinfo, nr_node_ids), GFP_KERNEL_ACCOUNT);
 	if (!memcg)
 		return ERR_PTR(error);
 
-- 
2.31.1

