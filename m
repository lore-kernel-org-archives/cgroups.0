From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/14] cgroup: make cgroup_destroy_locked() test cgroup_is_populated()
Date: Fri,  9 Oct 2015 23:29:34 -0400
Message-ID: <1444447781-16182-8-git-send-email-tj@kernel.org>
References: <1444447781-16182-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=06TabEe4isVpmKsaND45ZE0esNQ20pVZRGTqF3AYsBo=;
        b=ingyVleA4Mq6h08q5lIbXqzQkwypNZs7BN7ZjUFBeZushlOLWx/YNX3NjlEt6DbBsn
         g15b+WX7VDAjxNcvRC6OYI46y17o40wIzyf+jMhOOq9bQTOAvN4NM8fkxd30EVZe/Gm2
         2U90qcBgh0SGkEzuV4bMsoxFW/fV6fn55iFVjSkGtKWj69LSeWvFCqPSE4+1UjBS4YSM
         qdbL0PpnQtfyXilwv1Yh0VpfX+neSWxCMII31YbjPwrOUFdJmeFiEL1j5ck1uUaE9uym
         EK8jI170BVxt+comvVjulEZc9UdwNelMYAtB2m+6ouKCRbGyuRBfWTWcRSBTQEIvVLKH
         6uXw==
In-Reply-To: <1444447781-16182-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, cyphar@cyphar.com, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

cgroup_destroy_locked() currently tests whether any css_sets are
associated to reject removal if the cgroup contains tasks.  This works
because a css_set's refcnt converges with the number of tasks linked
to it and thus there's no css_set linked to a cgroup if it doesn't
have any live tasks.

To help tracking resource usage of zombie tasks, putting the ref of
css_set will be separated from disassociating the task from the
css_set which means that a cgroup may have css_sets linked to it even
when it doesn't have any live tasks.

This patch updates cgroup_destroy_locked() so that it tests
cgroup_is_populated(), which counts the number of populated css_sets,
instead of whether cgrp->cset_links is empty to determine whether the
cgroup is populated or not.  This ensures that rmdirs won't be
incorrectly rejected for cgroups which only contain zombie tasks.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ba11496..b8da97a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4996,16 +4996,15 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	__releases(&cgroup_mutex) __acquires(&cgroup_mutex)
 {
 	struct cgroup_subsys_state *css;
-	bool empty;
 	int ssid;
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	/* css_set_rwsem synchronizes access to ->cset_links */
-	down_read(&css_set_rwsem);
-	empty = list_empty(&cgrp->cset_links);
-	up_read(&css_set_rwsem);
-	if (!empty)
+	/*
+	 * Only migration can raise populated from zero and we're already
+	 * holding cgroup_mutex.
+	 */
+	if (cgroup_is_populated(cgrp))
 		return -EBUSY;
 
 	/*
-- 
2.4.3
