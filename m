From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] cgroup: use RCU free in create_css() failure path
Date: Thu, 24 Apr 2014 17:02:11 -0400
Message-ID: <1398373333-1521-5-git-send-email-tj@kernel.org>
References: <1398373333-1521-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WcKS5ZOeu0dFl8sHIiukImOzHrBCddnljrVDHDzCEVc=;
        b=Rpdz62TIE7Rft/rXwJrJ2/m9R1IAPb/Q7cDSrx10G8phxaHx7f5GS3sPKyDVGdSM8I
         q8fy2mTnk67g8huGieoww2QjtexoYbUD5MbOTn9QNqAJI11iy6l+Z4Jfej+siibd6QME
         UL9kdAH1AqviQymlNBiWc+Pz5BlrMirvoT4FlfpvGd+SUijBfjogoWWsp1KwQet49Hzr
         2zfFuqGgavUfM0nRzyIn4aLgP/R07UUg+KkdKso1Yj1rohomUmdEyiU3alXEoaj8X+ls
         aOUGvRgZ3k2EHYZotr55PeYRy3vryKQy86CRsa2jFE6CAcKkDGvfFJMJRHwbuk0cSVU1
         0lIQ==
In-Reply-To: <1398373333-1521-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org, mhocko@suse.cz, nasa4836@gmail.com, Tejun Heo <tj@kernel.org>

Currently, when create_css() fails in the middle, the half-initialized
css is freed by invoking cgroup_subsys->css_free() directly.  This
patch updates the function so that it invokes RCU free path instead.
As the RCU free path puts the parent css and owning cgroup, their
references are now acquired right after a new css is successfully
allocated.

This doesn't make any visible difference now but is to enable
implementing css->id and RCU protected lookup by such IDs.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7cb9c08..0e2c401 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4185,12 +4185,14 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
 	if (IS_ERR(css))
 		return PTR_ERR(css);
 
+	init_css(css, ss, cgrp);
+	cgroup_get(cgrp);
+	css_get(css->parent);
+
 	err = percpu_ref_init(&css->refcnt, css_release);
 	if (err)
 		goto err_free_css;
 
-	init_css(css, ss, cgrp);
-
 	err = cgroup_populate_dir(cgrp, 1 << ss->id);
 	if (err)
 		goto err_free_percpu_ref;
@@ -4199,9 +4201,6 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
 	if (err)
 		goto err_clear_dir;
 
-	cgroup_get(cgrp);
-	css_get(css->parent);
-
 	if (ss->broken_hierarchy && !ss->warned_broken_hierarchy &&
 	    parent->parent) {
 		pr_warn("%s (%d) created nested cgroup for controller \"%s\" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.\n",
@@ -4218,7 +4217,7 @@ err_clear_dir:
 err_free_percpu_ref:
 	percpu_ref_cancel_init(&css->refcnt);
 err_free_css:
-	ss->css_free(css);
+	call_rcu(&css->rcu_head, css_free_rcu_fn);
 	return err;
 }
 
-- 
1.9.0
