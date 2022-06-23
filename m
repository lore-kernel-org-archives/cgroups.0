From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH mm v5 9/9] memcg: enable accounting for perpu allocation of
 struct rt_rq
Date: Thu, 23 Jun 2022 17:52:01 +0300
Message-ID: <a4d96dd1-63ec-7a14-3039-9901d7e38244@openvz.org>
References: <4e685057-b07d-745d-fdaa-1a6a5a681060@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=GpreIe1vVrFK0GRTTTBCrmu4K38+/AoKp6X51SotBdU=;
        b=2uzehPa+7Yh1/1yI1Z5UrlQSBeyJcy6RsaVimJTiqlPLLRwUTOoHga1Wb1egu6p0wr
         H4yVijZAlfpr1xU4lEH1LNys0LFqKbKhTvHcKfJN0QQnqLklYEEUW4JNuFdZP9h1Zlmu
         pgUzAi4h5gzZMlV5HEAx9NHHw8mHh72qr5FZF9tx+uUOCdvUuPNtzgsxyZItchwHqvwc
         27BKuqvxrJvJkYcdvswWerNHUVfq4ecN5rBvXuLkqYoXEhXdLKw9vWYgZvIb6gFgw7Ec
         QNjDw3kOBNAZtq1hleAu9lG2BqZJu4Y1MITm+G0yIj7c0AYmDdz9vRi8wuTMvlSLeK+8
         uS0g==
Content-Language: en-US
In-Reply-To: <4e685057-b07d-745d-fdaa-1a6a5a681060-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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

Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Acked-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
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

