From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/14] cgroup: make css_sets pin the associated cgroups
Date: Fri,  9 Oct 2015 23:29:33 -0400
Message-ID: <1444447781-16182-7-git-send-email-tj@kernel.org>
References: <1444447781-16182-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=M7HF6BlXuqvx8qKHeKb0J70b52sbQsTqwmeAeUu0mtU=;
        b=qODqByo1rKKtNI1Q24Fr4+B0E9uswFpNdPSJ1+pUWOxZY5b3koZ+cin6JdHzMQukSe
         S6zz7I//ZHiICiRBX1IvtiRrOis/QKjrp3KSeVhUDrWpP1dDtAaxNRQ12sICiO5EjzaK
         nAmKZpMVdMvEtdwTSIWgY4h4WoM7T4wB+prFGqDPr5bIfqpUYS9g4/WzM2ZkPaysCvl9
         hEKzVZwEBrPmmOqAF96xaFnZYaj8k015fHADyPUjeuv4ZF3qR8Qs1vpulmzp33VPDWnv
         Jl2MYy1azi9B+dELWoqwmnSlCo/BsOnNn0OvbTi7yt7PXHyDi0HMUkeVPeM6cLV+bSX2
         OmSQ==
In-Reply-To: <1444447781-16182-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, cyphar@cyphar.com, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

Currently, css_sets don't pin the associated cgroups.  This is okay as
a cgroup with css_sets associated are not allowed to be removed;
however, to help resource tracking for zombie tasks, this is scheduled
to change such that a cgroup can be removed even when it has css_sets
associated as long as none of them are populated.

To ensure that a cgroup doesn't go away while css_sets are still
associated with it, make each associated css_set hold a reference on
the cgroup.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ab5c9a5..ba11496 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -705,6 +705,7 @@ static void put_css_set_locked(struct css_set *cset)
 	list_for_each_entry_safe(link, tmp_link, &cset->cgrp_links, cgrp_link) {
 		list_del(&link->cset_link);
 		list_del(&link->cgrp_link);
+		cgroup_put(link->cgrp);
 		kfree(link);
 	}
 
@@ -919,6 +920,8 @@ static void link_css_set(struct list_head *tmp_links, struct css_set *cset,
 	 * is sorted by order of hierarchy creation
 	 */
 	list_add_tail(&link->cgrp_link, &cset->cgrp_links);
+
+	cgroup_get(cgrp);
 }
 
 /**
@@ -4998,10 +5001,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	/*
-	 * css_set_rwsem synchronizes access to ->cset_links and prevents
-	 * @cgrp from being removed while put_css_set() is in progress.
-	 */
+	/* css_set_rwsem synchronizes access to ->cset_links */
 	down_read(&css_set_rwsem);
 	empty = list_empty(&cgrp->cset_links);
 	up_read(&css_set_rwsem);
-- 
2.4.3
