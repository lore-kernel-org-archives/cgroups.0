From: cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] mm: memcontrol: reference to tools/cgroup/memcg_slabinfo.py
Date: Fri, 10 Jun 2022 02:44:52 +0000
Message-ID: <20220610024451.744135-1-yang.yang29@zte.com.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wD58Q0nVdN+lpK7XOvbDvW4lZ7h1rqEWk+skYGgOvJ0=;
        b=Y6A0K30lWxEicLPPmjfvigg4Z03uPa39KfSU4jwd5vx9b6x5HxdPlyyVwybkBiEqAQ
         Q15JzwoiSLcUKwmQqfQZLOkbHx/bvsG8q4SQ8dnhpsKngiFuu+nYfYjMZ833CCyEKYQ3
         ztpR4i6TcGQUIE04Cq3wSu0pyDOglJGCx/URJroH+yN+0OWdOj7YUB99S07kecNm+T+g
         4bllY4ycfzaVRA7UJyChYPED0DNusFEaXz4h1vP61YO/M9cxKQvuTojmGDS6I4WOlYll
         qgjVIfP0PHaKlStMD0rk8R34u2rMEgjY54g2rkFPYv5zx6TbRkXI1gbkW6+ipw/bPz4t
         NhOw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yang Yang <yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

From: Yang Yang <yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

There is no slabinfo.py in tools/cgroup, but has memcg_slabinfo.py instead.

Signed-off-by: Yang Yang <yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index dfbc84313745..ca714699a8e9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4820,7 +4820,7 @@ static int mem_cgroup_slab_show(struct seq_file *m, void *p)
 {
 	/*
 	 * Deprecated.
-	 * Please, take a look at tools/cgroup/slabinfo.py .
+	 * Please, take a look at tools/cgroup/memcg_slabinfo.py .
 	 */
 	return 0;
 }
-- 
2.25.1

