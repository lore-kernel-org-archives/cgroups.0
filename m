From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [Patch v2] cgroup: return early if it is already on preloaded list
Date: Tue, 14 Dec 2021 00:46:07 +0000
Message-ID: <20211214004607.9296-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=kSriUcr2RHlsa/k2Omom4FRrCUVVZTUaNFBbTKOcsT8=;
        b=naxeXMBFCpq38O3k+pVvJGj0gGYcPhbWVAT8G7ARuCaUZ7Tce88QMVO47ld3Coh+tB
         /NKR85ihfLqmLPynGBFUnqrTrCHNmyLhBtr6uEVplKhcb2a3HKQEglQFSgEzXKMuMLc7
         3wXCIXOYljRLJLErKfHoJb4JlfqZMcTC5NO17wzxzTTTroAMPD5FG7QwOq1R7w+YrPfY
         2mRBRK4O2csy9BCUYb6fNJEuGjCFEjf1skmdwOvJN6lZ8Bst2eqtJYB5gTUxuyUKeuDQ
         LpLUm8QkHCI3zoNm9Mt1uOSaUmnCOOzpkgDqkhYes9XbMqkyE12Tof6Xto/sLPIgprQn
         FoMg==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

If a cset is already on preloaded list, this means we have already setup
this cset properly for migration.

This patch just relocate the root cgrp lookup which isn't used anyway
when the cset is already on the preloaded list.

[tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org: rephrase the commit log]

Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

---
v2: rephrase commit log
---
 kernel/cgroup/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 452a723d4a36..2cf729afe834 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2648,11 +2648,11 @@ void cgroup_migrate_add_src(struct css_set *src_cset,
 	if (src_cset->dead)
 		return;
 
-	src_cgrp = cset_cgroup_from_root(src_cset, dst_cgrp->root);
-
 	if (!list_empty(&src_cset->mg_preload_node))
 		return;
 
+	src_cgrp = cset_cgroup_from_root(src_cset, dst_cgrp->root);
+
 	WARN_ON(src_cset->mg_src_cgrp);
 	WARN_ON(src_cset->mg_dst_cgrp);
 	WARN_ON(!list_empty(&src_cset->mg_tasks));
-- 
2.33.1

