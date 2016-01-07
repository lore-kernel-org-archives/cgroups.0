From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] cgroup: use ->subtree_control when testing no internal process rule
Date: Thu,  7 Jan 2016 17:29:48 -0500
Message-ID: <1452205790-21331-5-git-send-email-tj@kernel.org>
References: <1452205790-21331-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=j6hC/9nKVOj7IcjH3ilbd7xM9VfCNSERkjpi7ulx+3A=;
        b=qxOuSxePnrOUObRl70KZIhGJ+1OOboPr/gzmoAvkVCmgRqbjZNCKkOKBfB+nhIOxh1
         8TewA5vjgFPysJ6G58Iagx3mayMMFjuYqZqHl+v17eLVM6SQ57wJiIUCe1ynn2uoBRte
         YEfxESU6DoqHAAoTEnUO94ZtGghDdUHcGZgziSl6CtM9hlBKg05qu57GU8MwKUQ9DK+g
         2z+rnkCLavNjriDGaNl2PelGQLUeJJOAlMm6xJnXZ7i8cvy8k/d/AdT0N/P4IzM2X0pd
         aOloOovi8nSwIOdp2EeXmU3HUVu2FldnE2/cradhpyCD/dwDdoQ9eDQgWTZ1Ma3NDOUQ
         H9ug==
In-Reply-To: <1452205790-21331-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org, a.p.zijlstra@chello.nl, mingo@redhat.com, acme@kernel.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

No internal process rule is enforced by cgroup_migrate_prepare_dst()
during process migration.  It tests whether the target cgroup's
->child_subsys_mask is zero which is different from "subtree_control"
write path which tests ->subtree_control.  This hasn't mattered
because up until now, both ->child_subsys_mask and ->subtree_control
are zero or non-zero at the same time.  However, with the planned
addition of implicit controllers, this will no longer be true.

This patch prepares for the change by making
cgorup_migrate_prepare_dst() test ->subtree_control instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 8a92043..8bc83fd 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2512,11 +2512,11 @@ static int cgroup_migrate_prepare_dst(struct cgroup *dst_cgrp,
 	lockdep_assert_held(&cgroup_mutex);
 
 	/*
-	 * Except for the root, child_subsys_mask must be zero for a cgroup
+	 * Except for the root, subtree_control must be zero for a cgroup
 	 * with tasks so that child cgroups don't compete against tasks.
 	 */
 	if (dst_cgrp && cgroup_on_dfl(dst_cgrp) && cgroup_parent(dst_cgrp) &&
-	    dst_cgrp->child_subsys_mask)
+	    dst_cgrp->subtree_control)
 		return -EBUSY;
 
 	/* look up the dst cset for each src cset and link it to src */
-- 
2.5.0

