From: Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH] cgroup: return early if it is already on preloaded list
Date: Sat, 11 Dec 2021 16:17:29 +0000
Message-ID: <20211211161729.10581-1-richard.weiyang@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=IHNV5z0x2jo1zjIuAESnRBcnC6JnxrBxV+EMdX4SQgo=;
        b=Nu28QEEe5uRu/XwGNZoYPdEhWEjIkWlgSm1IZEOmtMMceXKjkm+Klsboqr7sRee6/g
         n5HHyV5kLt1mxnI6nsWOv4Yrp2Tf/39hDgzKInsrsCE50q7o42JXRS4rFqZf47rQ9tkD
         pw8A6Prm8KprY2HyQTRyxM2TLqW0zKR9kcQmdSkhrmnHdN32DSyMnCprFKAYmCVAYmL8
         UvFvY7Hcz/neuuenM4vnKmZD9bvE+HoepYYDiaR2XI8YpG0fz/MmZm2opxUzfWaABipw
         UqwzhcgEG77C1txXtucsOXrUtpqUt/GoNy/dcJn7yeku2IDHqy5/NA1T6Y3dIEtEsFG/
         e4vA==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Wei Yang <richard.weiyang@gmail.com>

If it is already on preloaded list, this means we have already setup
this cset properly for migration.

Let's skip this cset on this condition.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
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

