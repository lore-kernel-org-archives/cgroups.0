From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/9 v3] cgroup: add cgroup_subsys->post_create()
Date: Thu, 8 Nov 2012 11:07:15 -0800
Message-ID: <20121108190715.GD9672@htj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-pm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=NeJ4/JbUzsyU62UH9m79et8MzE4MLEJoLhLq6dMF0Hg=;
        b=QZD/dwTqmec/nq/R19f1EjMD9PlHxY7U5Nj+4QBEo5ohO0OzoTmbTz5e1WKAMMGjWY
         bDTOb5j2EQnNyuiQQAE5YLJfn2ca2W3pb8aMBF2RdrHgmZQYZa04uUzmc7ulxLhVOZWx
         wfBQb+78kP3VzSeqi8OoppKE5g6iZS4nsl8vOyyFhhVA1JHWC3yif9cJgze9alR387WL
         iT9KEalB91PK7r5N6cmfhzOLjFhNr3x1xi1U9ELUX4mJUxakrw+NO6b4pCrRps/oEY+h
         h0YoP5QhbVb7swNaYF75Z9f9eAZGsQV6oJlMeqGWrVPT3vVhCVSWrJJLDisqyuFUS4/G
         3AUg==
Content-Disposition: inline
In-Reply-To: <1351931915-1701-2-git-send-email-tj@kernel.org>
Sender: linux-pm-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, mhocko@suse.cz, rjw@sisk.pl
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, fweisbec@gmail.com, Glauber Costa <glommer@parallels.com>

Subject: cgroup: add cgroup_subsys->post_create()

Currently, there's no way for a controller to find out whether a new
cgroup finished all ->create() allocatinos successfully and is
considered "live" by cgroup.

This becomes a problem later when we add generic descendants walking
to cgroup which can be used by controllers as controllers don't have a
synchronization point where it can synchronize against new cgroups
appearing in such walks.

This patch adds ->post_create().  It's called after all ->create()
succeeded and the cgroup is linked into the generic cgroup hierarchy.
This plays the counterpart of ->pre_destroy().

When used in combination with the to-be-added generic descendant
iterators, ->post_create() can be used to implement reliable state
inheritance.  It will be explained with the descendant iterators.

v2: Added a paragraph about its future use w/ descendant iterators per
    Michal.

v3: Forgot to add ->post_create() invocation to cgroup_load_subsys().
    Fixed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Glauber Costa <glommer@parallels.com>
---
Oops, forgot updating cgroup_load_subsys().  Hate that it's a
different path from cgroup_init_subsys(). :(

Thanks.

 include/linux/cgroup.h |    1 +
 kernel/cgroup.c        |   15 +++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -438,6 +438,7 @@ int cgroup_taskset_size(struct cgroup_ta
 
 struct cgroup_subsys {
 	struct cgroup_subsys_state *(*create)(struct cgroup *cgrp);
+	void (*post_create)(struct cgroup *cgrp);
 	void (*pre_destroy)(struct cgroup *cgrp);
 	void (*destroy)(struct cgroup *cgrp);
 	int (*can_attach)(struct cgroup *cgrp, struct cgroup_taskset *tset);
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4059,10 +4059,15 @@ static long cgroup_create(struct cgroup
 	if (err < 0)
 		goto err_remove;
 
-	/* each css holds a ref to the cgroup's dentry */
-	for_each_subsys(root, ss)
+	for_each_subsys(root, ss) {
+		/* each css holds a ref to the cgroup's dentry */
 		dget(dentry);
 
+		/* creation succeeded, notify subsystems */
+		if (ss->post_create)
+			ss->post_create(cgrp);
+	}
+
 	/* The cgroup directory was pre-locked for us */
 	BUG_ON(!mutex_is_locked(&cgrp->dentry->d_inode->i_mutex));
 
@@ -4280,6 +4285,9 @@ static void __init cgroup_init_subsys(st
 
 	ss->active = 1;
 
+	if (ss->post_create)
+		ss->post_create(&ss->root->top_cgroup);
+
 	/* this function shouldn't be used with modular subsystems, since they
 	 * need to register a subsys_id, among other things */
 	BUG_ON(ss->module);
@@ -4389,6 +4397,9 @@ int __init_or_module cgroup_load_subsys(
 
 	ss->active = 1;
 
+	if (ss->post_create)
+		ss->post_create(&ss->root->top_cgroup);
+
 	/* success! */
 	mutex_unlock(&cgroup_mutex);
 	return 0;
