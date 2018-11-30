From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH v4 3/7] cgroup: protect cgroup->nr_(dying_)descendants by css_set_lock
Date: Fri, 30 Nov 2018 15:47:41 -0800
Message-ID: <20181130234745.6756-4-guro@fb.com>
References: <20181130234745.6756-1-guro@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/h4U+0DlXHetF6XB/+D6rzr4Gg58Kl4UP4B7kNYPeno=;
        b=JThfV7kp9wcDzrPZgdTbabbZpSVI9ItSk8wpytvn7gublh82rCVNJCNegNGUWFzSa9
         Y45i1Xye15z/9mArt2XiZRxQIMX8Wov4/aLURF6CHH73guSQIxKvZollYo4uuF7czSZZ
         nITwdevuuth3Bdo278SY3QMNUXp9WA/1SqxH/8dADzCWDLeEY0PKWvppCkffvmqCo40R
         HLcT2jshxHhN0cy60zW1jTiFl71YjACtAaTdrAEcmKIMpEM9pPeq3RCdhOE+dkoTH04Y
         v7VyFBdH4B6dtMmjzSMIpXQAoeqsUaLsoYZsFH/2VJsswK9f7IYOAt5U++kGcunyPq+3
         7gcA==
In-Reply-To: <20181130234745.6756-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>

The number of descendant cgroups and the number of dying
descendant cgroups are currently synchronized using the cgroup_mutex.

The number of descendant cgroups will be required by the cgroup v2
freezer, which will use it to determine if a cgroup is frozen
(depending on total number of descendants and number of frozen
descendants). It's not always acceptable to grab the cgroup_mutex,
especially from quite hot paths (e.g. exit()).

To avoid this, let's additionally synchronize these counters using
the css_set_lock.

So, it's safe to read these counters with either cgroup_mutex or
css_set_lock locked, and for changing both locks should be acquired.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: kernel-team@fb.com
---
 include/linux/cgroup-defs.h | 3 +++
 kernel/cgroup/cgroup.c      | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 8fcbae1b8db0..4327fd6e8121 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -348,6 +348,9 @@ struct cgroup {
 	 * Dying cgroups are cgroups which were deleted by a user,
 	 * but are still existing because someone else is holding a reference.
 	 * max_descendants is a maximum allowed number of descent cgroups.
+	 *
+	 * nr_descendants and nr_dying_descendants are protected
+	 * by cgroup_mutex and css_set_lock.
 	 */
 	int nr_descendants;
 	int nr_dying_descendants;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 7519a4307021..f89dde50f693 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4723,9 +4723,11 @@ static void css_release_work_fn(struct work_struct *work)
 		if (cgroup_on_dfl(cgrp))
 			cgroup_rstat_flush(cgrp);
 
+		spin_lock_irq(&css_set_lock);
 		for (tcgrp = cgroup_parent(cgrp); tcgrp;
 		     tcgrp = cgroup_parent(tcgrp))
 			tcgrp->nr_dying_descendants--;
+		spin_unlock_irq(&css_set_lock);
 
 		cgroup_idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
 		cgrp->id = -1;
@@ -4943,12 +4945,14 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
 	if (ret)
 		goto out_psi_free;
 
+	spin_lock_irq(&css_set_lock);
 	for (tcgrp = cgrp; tcgrp; tcgrp = cgroup_parent(tcgrp)) {
 		cgrp->ancestor_ids[tcgrp->level] = tcgrp->id;
 
 		if (tcgrp != cgrp)
 			tcgrp->nr_descendants++;
 	}
+	spin_unlock_irq(&css_set_lock);
 
 	if (notify_on_release(parent))
 		set_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
@@ -5233,10 +5237,12 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	if (parent && cgroup_is_threaded(cgrp))
 		parent->nr_threaded_children--;
 
+	spin_lock_irq(&css_set_lock);
 	for (tcgrp = cgroup_parent(cgrp); tcgrp; tcgrp = cgroup_parent(tcgrp)) {
 		tcgrp->nr_descendants--;
 		tcgrp->nr_dying_descendants++;
 	}
+	spin_unlock_irq(&css_set_lock);
 
 	cgroup1_check_for_release(parent);
 
-- 
2.17.2

