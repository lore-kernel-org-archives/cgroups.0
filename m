From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 16/16] cgroup: unexport functions
Date: Sun,  9 Feb 2014 08:52:44 -0500
Message-ID: <1391953964-22088-17-git-send-email-tj@kernel.org>
References: <1391953964-22088-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=j6ZjEdHvdLzkdwKtaCSDSZL8NEuC3wW/DzG9nWnSoGQ=;
        b=hJ77fDfhEF4ismCQ4XUw2aINWvsIHfjDr3HLzcySKmmwC7bR07ZIK4a/nxxr5qh7NH
         /7A7JNbNiqYyb8XWMpNNkNzC452iKZBlo65Yhp3cvCOH9MIGmgQxz2bLhZJ81BJ3IoLl
         owNiDLigaXsdcQM1oXo9DhOL/bQHTFDUXcUQE59iL7uNHu9qfU8VB1LZ0lPryxTuEIHx
         xcLJnPd+uY4Qh+3rntlcB2WXz7MHBwahPO+dR+mFMY3W3PalKxEejIVvOO2bJ2WIHPNz
         7uOn2jFsSzmniT4uJdmMvoF90rb62mJ38SYv1AyB4FN5SiIvXfQb8VSmIoIJ3RxW1q4D
         dVew==
In-Reply-To: <1391953964-22088-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

With module support gone, a lot of functions no longer need to be
exported.  Unexport them.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 057ab96..abb1873 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -242,7 +242,6 @@ bool cgroup_is_descendant(struct cgroup *cgrp, struct cgroup *ancestor)
 	}
 	return false;
 }
-EXPORT_SYMBOL_GPL(cgroup_is_descendant);
 
 static int cgroup_is_releasable(const struct cgroup *cgrp)
 {
@@ -1662,7 +1661,6 @@ struct task_struct *cgroup_taskset_first(struct cgroup_taskset *tset)
 		return tset->single.task;
 	}
 }
-EXPORT_SYMBOL_GPL(cgroup_taskset_first);
 
 /**
  * cgroup_taskset_next - iterate to the next task in taskset
@@ -1681,7 +1679,6 @@ struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset)
 	tc = flex_array_get(tset->tc_array, tset->idx++);
 	return tc->task;
 }
-EXPORT_SYMBOL_GPL(cgroup_taskset_next);
 
 /**
  * cgroup_task_migrate - move a task from one cgroup to another.
@@ -2364,7 +2361,6 @@ int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 	mutex_unlock(&cgroup_tree_mutex);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(cgroup_add_cftypes);
 
 /**
  * cgroup_task_count - count the number of tasks in a cgroup.
@@ -2438,7 +2434,6 @@ css_next_child(struct cgroup_subsys_state *pos_css,
 
 	return cgroup_css(next, parent_css->ss);
 }
-EXPORT_SYMBOL_GPL(css_next_child);
 
 /**
  * css_next_descendant_pre - find the next descendant for pre-order walk
@@ -2481,7 +2476,6 @@ css_next_descendant_pre(struct cgroup_subsys_state *pos,
 
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(css_next_descendant_pre);
 
 /**
  * css_rightmost_descendant - return the rightmost descendant of a css
@@ -2513,7 +2507,6 @@ css_rightmost_descendant(struct cgroup_subsys_state *pos)
 
 	return last;
 }
-EXPORT_SYMBOL_GPL(css_rightmost_descendant);
 
 static struct cgroup_subsys_state *
 css_leftmost_descendant(struct cgroup_subsys_state *pos)
@@ -2567,7 +2560,6 @@ css_next_descendant_post(struct cgroup_subsys_state *pos,
 	/* no sibling left, visit parent */
 	return css_parent(pos);
 }
-EXPORT_SYMBOL_GPL(css_next_descendant_post);
 
 /**
  * css_advance_task_iter - advance a task itererator to the next css_set
-- 
1.8.5.3
