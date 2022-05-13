From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/4] memcg: enable accounting for struct cgroup
Date: Fri, 13 May 2022 18:52:12 +0300
Message-ID: <a17be77f-dc3b-d69a-16e2-f7309959c525@openvz.org>
References: <Ynv7+VG+T2y9rpdk@carbon>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=EoRCzFgdqymU94vAV2iJ0vqJH+w1nYNzWrX56BJFK5A=;
        b=PQ1JGa4uyb8yMkUdsAm4Nt9mj9ncphlDfrDvRbPZYFDeH2DUMyZv3Nlv4C2VVX83CM
         2gEOM/vV0TlfADwx2QvGxXWHr9C/RM/onavTakiX8tERXNg9OdVBey51Na0iQnlbbstt
         AoEaInLDNa2zgzydNcT5Sdn/QuQ5Qfdd6ibSZqOTOBpF+lKkDe0TwZp/wBz1z5HcLO5c
         8zgAjxrQyB052eIvSU4BbLlZySBZrPpr932JWX+fT5bxyXWGAXGu9nx7mcdq6IqCF+VQ
         TTBR8HK8sInoUF0IAVdMjhfQ9x5pXUm7gMllPun0H9v7ux2hEofCG7my4kvmA6sKYKGc
         5EhQ==
Content-Language: en-US
In-Reply-To: <Ynv7+VG+T2y9rpdk@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Creating each new cgroup allocates 4Kb for struct cgroup. This is the
largest memory allocation in this scenario and is epecially important
for small VMs with 1-2 CPUs.

Accounting of this memory helps to avoid misuse inside memcg-limited
containers.

Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index adb820e98f24..7595127c5b3a 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5353,7 +5353,7 @@ static struct cgroup *cgroup_create(struct cgroup *parent, const char *name,
 
 	/* allocate the cgroup and its ID, 0 is reserved for the root */
 	cgrp = kzalloc(struct_size(cgrp, ancestor_ids, (level + 1)),
-		       GFP_KERNEL);
+		       GFP_KERNEL_ACCOUNT);
 	if (!cgrp)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.31.1

