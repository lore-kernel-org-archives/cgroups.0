From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup] cgroup: set the correct return code if hierarchy
 limits are reached
Date: Mon, 27 Jun 2022 05:12:55 +0300
Message-ID: <d8a9e9c6-856e-1502-95ac-abf9700ff568@openvz.org>
References: <186d5b5b-a082-3814-9963-bf57dfe08511@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=J1m6KgphNIic/L8WHuZiss6XcSSiZCMzYR1UJoO0HMc=;
        b=Kxte3o580Pu1piGMd/tMaeKLcaYVnazjes2jkA1MeRbEVwuAjE11CCbYmYRlNLpsTw
         ouDSlFLtVKYo+Ypvn/e4PTGdQBuBZSF8EMqVPtqqJKVIpYXcBsUFENRymu17f8RNCuqY
         Pm/82bhd295KDLa0ilJFqdTMh4JkoC+poaMfMlNN2V80LjCvpchBMl+H7N8FrRyJPJh+
         nTSBgMNVuORpGb3zfKVzKxBUE8bd8rfxtdIgZUi1lUKL4fUx6ppsM0QVQldCU+CnZYsd
         ZJteSZJMdcqSyoMY+ubnkpFtWTm+0VbsbNradd5tM5mDISvt1wyV+NF6yVISG4BfRLXj
         XbrQ==
Content-Language: en-US
In-Reply-To: <186d5b5b-a082-3814-9963-bf57dfe08511-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

When cgroup_mkdir reaches the limits of the cgroup hierarchy, it should
not return -EAGAIN, but instead react similarly to reaching the global
limit.

Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 1be0f81fe8e1..243239553ea3 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5495,7 +5495,7 @@ int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name, umode_t mode)
 		return -ENODEV;
 
 	if (!cgroup_check_hierarchy_limits(parent)) {
-		ret = -EAGAIN;
+		ret = -ENOSPC;
 		goto out_unlock;
 	}
 
-- 
2.36.1

