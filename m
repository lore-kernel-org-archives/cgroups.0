From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH RFC] memcg: notify about global mem_cgroup_id space depletion
Date: Sat, 25 Jun 2022 17:04:27 +0300
Message-ID: <c53e1df0-5174-66de-23cc-18797f0b512d@openvz.org>
References: <YrXDV7uPpmDigh3G@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=P4+NIZh0+FuNtpaxK6+hjjWOuYrxTf6SJFt+dTJJxto=;
        b=j8MthZMi7RVwBJqVMUfnHVHFR5zj5MeoLZOa3BxwPZ1FLgoE9Ys0FlepkG5k1jy0Ar
         1jd1cU1J0OwwcYO1fa3uCSE8SYVa/y2JS27/ypUs79A+KpiOvGdu1RQl3xi074/bc00v
         RL1IGWckKGZwUazwHBZlN6KhGst6eN5PwXkAyTUo0D47JHNUaNg9HxNN5376TXha3PAd
         5zYzFHqepDuzLYgKW6g1dwQ9NhMNJNTEVHNMZjI54ILaUSlAXylzhfvFCOV4dLG4fr1e
         IIFSmh0qjFSp9/y89//v2cWpEP2dIMxPqfFT+OlCWT+2SQWWooWlSouK15V5avd6IEK1
         1cxg==
Content-Language: en-US
In-Reply-To: <YrXDV7uPpmDigh3G-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Currently host owner is not informed about the exhaustion of the
global mem_cgroup_id space. When this happens, systemd cannot
start a new service, but nothing points to the real cause of
this failure.

Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 mm/memcontrol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d4c606a06bcd..5229321636f2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5317,6 +5317,7 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
 				 1, MEM_CGROUP_ID_MAX + 1, GFP_KERNEL);
 	if (memcg->id.id < 0) {
 		error = memcg->id.id;
+		pr_notice_ratelimited("mem_cgroup_id space is exhausted\n");
 		goto fail;
 	}
 
-- 
2.36.1

