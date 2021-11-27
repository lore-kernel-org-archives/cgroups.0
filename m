From: Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH 2/2] cgroup: get the wrong css for css_alloc() during cgroup_init_subsys()
Date: Sat, 27 Nov 2021 14:59:19 +0000
Message-ID: <20211127145919.31159-2-richard.weiyang@gmail.com>
References: <20211127145919.31159-1-richard.weiyang@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DUa+iyqQFoJCh85Xx5S5yIjQywwrD3DfTPEYMfJnePI=;
        b=IV8FhjwGkFzEgsoXII9eGrWzVHjEaXWRN69iJiFJjhAX/kTN5xHcBw2Iqw4sKvP7gO
         rbTgoaOSEo/d2JeSeOLnmIWox4CRXLhvsYOeASh3JUaed10kfpGtRmCKHDKG6lQDuGGm
         7om0B3fYCm/W3gkkWo4VY8yklz3w0/BuBNBE/bfF4vmI3qXhy7C4nToQJc34NLBPRC/l
         W8mT+ify/i4Oe+enAYROQcr5kM5eWKU6lCh5Jjq+ojAlkx5abgm2b13nV0L2U3MfwHyQ
         5Z7KQWlzP1kGiHbSUCFgocXai/PX+r5mZbTJ1tZiXRM8hN0ne/ApMxPuztPDdqa7AO7n
         u3sg==
In-Reply-To: <20211127145919.31159-1-richard.weiyang@gmail.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Wei Yang <richard.weiyang@gmail.com>

css_alloc() needs the parent css, while cgroup_css() gets current
cgropu's css. So we are getting the wrong css during
cgroup_init_subsys().

Fortunately, cgrp_dfl_root.cgrp's css is not set yet, so the value we
pass to css_alloc() doesn't harm to the system.

Let's pass NULL directly during init, since we know there is no parent
yet.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index dffef5836ff7..452a723d4a36 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5709,7 +5709,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 
 	/* Create the root cgroup state for this subsystem */
 	ss->root = &cgrp_dfl_root;
-	css = ss->css_alloc(cgroup_css(&cgrp_dfl_root.cgrp, ss));
+	css = ss->css_alloc(NULL);
 	/* We don't handle early failures gracefully */
 	BUG_ON(IS_ERR(css));
 	init_and_link_css(css, ss, &cgrp_dfl_root.cgrp);
-- 
2.33.1

