From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/3] mm/memcg: set memcg after css verified and got reference
Date: Fri, 25 Feb 2022 00:34:35 +0000
Message-ID: <20220225003437.12620-2-richard.weiyang@gmail.com>
References: <20220225003437.12620-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=S87rTjKN5bfLSWPPikhQAx5WdDBuNstKMGrhVDOGPDk=;
        b=PN2wcsqgc+wbNZTHug2Cw1wY8pOFK7Hpan6j6WTlSX5V9URldyHCNJkFFGWSZ7PlJ/
         A/DzETsq2Ts1WOB3cSzjv61qGt7yBLz0RfXfRgiACddXKDki8cq8tDbYZXwgxe8vpgLX
         uv3kB74ECDqTy3bLUkKnRSNnRo0fYx+lp3rrO6f0kzyZr2JInCpgHY9TrZcDOLznVzIr
         mIm2ZnByOOX4kpajylS6pPLOqY8zXihSAtBDBLE5NZX4ieRcM8CSRg0xEzPhfbzyT+mM
         oiJZDXxDbZbjj/I1PNYWkgY8BNjz6s7i1T6cfxQNoodJgX9z9AoOX7Bg9PvjBlbtAb47
         gCaA==
In-Reply-To: <20220225003437.12620-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Instead of reset memcg when css is either not verified or not got
reference, we can set it after these process.

No functional change, just simplified the code a little.

Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 36e9f38c919d..9464fe2aa329 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1040,15 +1040,10 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 		 * is provided by the caller, so we know it's alive
 		 * and kicking, and don't take an extra reference.
 		 */
-		memcg = mem_cgroup_from_css(css);
-
-		if (css == &root->css)
-			break;
-
-		if (css_tryget(css))
+		if (css == &root->css || css_tryget(css)) {
+			memcg = mem_cgroup_from_css(css);
 			break;
-
-		memcg = NULL;
+		}
 	}
 
 	if (reclaim) {
-- 
2.33.1

