From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH v9 3/9] cgroup: protect cgroup->nr_(dying_)descendants by css_set_lock
Date: Sat, 16 Mar 2019 10:58:06 -0700
Message-ID: <20190316175812.6787-4-guro@fb.com>
References: <20190316175812.6787-1-guro@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pSVREjPCAv5T2ZXAYt7SDw0JOGFlD724donHrtDZGs4=;
        b=gwzhwtuYHAukJnuCVE538uazrdK6lMvAnBOSu2ZJL8T/RzBz73VGy9TYw3ELDMkriz
         H0EdPTa4z4G9HOheuqpLS9KnS2TIpPVE1kkiRHGj3R72fZtBoeEH+JIRVpXAxlP13Uzy
         zngGXAzT5DCbVbalF12VD3qtnkCYBIrxtUbAh458w5jkQd4xqtzOhGgENrUCdZUKesTb
         G8tF8PHci7Ec+yjdVYVJ0KkvYJlWssDi4h31/R/1pyLF+2KZ5p4KZAvFJ+IaAz6bvP8J
         WAImBgK1fhFSRakIcxykVU5d2K2W2aZ9HdASO6Wso+25ayUerc9YcNu4dh6eyVTyMKjl
         TsWw==
In-Reply-To: <20190316175812.6787-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guro@fb.com>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

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
 include/linux/cgroup-defs.h | 5 +++++
 kernel/cgroup/cgroup.c      | 6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 120d1d40704b..319c07305500 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -348,6 +348,11 @@ struct cgroup {
 	 * Dying cgroups are cgroups which were deleted by a user,
 	 * but are still existing because someone else is holding a reference.
 	 * max_descendants is a maximum allowed number of descent cgroups.
+	 *
+	 * nr_descendants and nr_dying_descendants are protected
+	 * by cgroup_mutex and css_set_lock. It's fine to read them holding
+	 * any of cgroup_mutex and css_set_lock; for writing both locks
+	 * should be held.
 	 */
 	int nr_descendants;
 	int nr_dying_descendants;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index b230afccf635..7438c24297d4 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4758,9 +4758,11 @@ static void css_release_work_fn(struct work_struct *work)
 		if (cgroup_on_dfl(cgrp))
 			cgroup_rstat_flush(cgrp);
 
+		spin_lock_irq(&css_set_lock);
 		for (tcgrp = cgroup_parent(cgrp); tcgrp;
 		     tcgrp = cgroup_parent(tcgrp))
 			tcgrp->nr_dying_descendants--;
+		spin_unlock_irq(&css_set_lock);
 
 		cgroup_idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
 		cgrp->id = -1;
@@ -4978,12 +4980,14 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
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
@@ -5268,10 +5272,12 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
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
2.20.1

