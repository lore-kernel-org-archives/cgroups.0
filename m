From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [Patch v2 1/3] mm/memcg: set memcg after css verified and got reference
Date: Wed, 30 Mar 2022 23:47:17 +0000
Message-ID: <20220330234719.18340-2-richard.weiyang@gmail.com>
References: <20220330234719.18340-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=F2sr6A+74F0K682i5KfFbDfyxE+MQpH5kf2WVRDaVIg=;
        b=DXlRh9VdTEpO7NS8UN7I/7xFcNqWI9MpkZUOkkXQrKpqPO+/o7s8ip5/V3wuJlw9OC
         N3JRk5k243KQRIuZCPQP2fwXOTj3I89ZdtinJXIsTV+Yyy1E8T+vW0I7IB2dOco/Idn9
         CG3tUrd4r5OzGyJRPpU3422sei2X2oIgWsBz6S6wAlgwQzPlkMw+E2SMYoOWVJ9v9nrM
         FFT3i2i6zxf7106D+R9OFTCDqr58JFeYzzWuOWg6KtBG6Qr1KppDZNE1fes9Kaguf5Z9
         Rj5p1RThizy2W3wNBRgnN6gGxCIGyH6cq10Ur8eWx9EWyHWotIdxRDSCOlXYEPUBXlA+
         31yQ==
In-Reply-To: <20220330234719.18340-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/memcontrol.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index dc193e83794d..eed9916cdce5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1057,15 +1057,10 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
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

