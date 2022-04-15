From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: [PATCH 3/4] MAINTAINERS: add corresponding kselftests to cgroup entry
Date: Thu, 14 Apr 2022 17:01:32 -0700
Message-ID: <20220415000133.3955987-4-roman.gushchin@linux.dev>
References: <20220415000133.3955987-1-roman.gushchin@linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1649980914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hmYLxb1+mMr6jmOwnIg2k48EEFJdR9ToYiqAQACrt3M=;
        b=nfzHyoF3QlG0i3ONCxWOVkP22GqWy34FQSUolZw34J6jzLgX3HnZJW//B8a7oIXF18S5Lj
        6q+QBKlYxNFwuJhjmv06yLBxj6h0wbsU2Q7lC7w3ogchvkCNC4Pfke1EFRxtDGdTwuCZh+
        8BDA/ZA6jVpPFrWjLd2z1e5nwQ6yOdw=
In-Reply-To: <20220415000133.3955987-1-roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

List cgroup kselftests in the cgroup MAINTAINERS entry.
These are tests covering core, freezer and cgroup.kill
functionality.

Signed-off-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index d5731c03a485..44dabe0145ae 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4996,6 +4996,7 @@ F:	Documentation/admin-guide/cgroup-v1/
 F:	Documentation/admin-guide/cgroup-v2.rst
 F:	include/linux/cgroup*
 F:	kernel/cgroup/
+F:	tools/testing/selftests/cgroup/
 
 CONTROL GROUP - BLOCK IO CONTROLLER (BLKIO)
 M:	Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
-- 
2.35.1

