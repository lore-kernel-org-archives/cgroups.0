From: Roman Gushchin <guro@fb.com>
Subject: [RFC 1/4] cgroup: keep track of number of descent cgroups
Date: Wed, 2 Aug 2017 17:55:29 +0100
Message-ID: <20170802165532.22277-2-guro@fb.com>
References: <20170802165532.22277-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=6EmvzNCsS9/6ea7/tFUD3Q4dX1LSDMfpazxXxF4fIDk=;
 b=CBsmW1SuAUf90KXInBRm9EygfGTLNQxUgzVt0PVnEkC4tnVlKyPozQ2uQtY2f4FDiQvM
 whW3h3Du5LHqsqtXwesfaQQm8n7jaA5Az3RjI1jfftxPj1zJSo8S40nn5/M6nbXOr3+W
 CFqTprvNfcHwkGzhmopxUCXt2DAe3J3RwwU= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=6EmvzNCsS9/6ea7/tFUD3Q4dX1LSDMfpazxXxF4fIDk=;
 b=KbBmeK/rhGuIF8TYLD+2swWTXp51lLk3gEz8ShzOj5hxzRsxLrX6IVYyH7IvaKevPpP976cqNJZlu2mQGPWRTogfWg7YRd4u7QgLb6rHTzBn6Gk0ZpsYLgD7OXw7pcEffmlH/w+qAw045CxJWNRBjOVtZAW2X0B58DkO+emon9k=
In-Reply-To: <20170802165532.22277-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org
Cc: Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan@huawei.com>, Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, kernel-team@fb.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Keep track of the number of online and dying descent cgroups.

This data will be used later to add an ability to control cgroup
hierarchy (limit the depth and the number of descent cgroups)
and display hierarchy stats.

Signed-off-by: Roman Gushchin <guro@fb.com>
Suggested-by: Tejun Heo <tj@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan@huawei.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: kernel-team@fb.com
Cc: cgroups@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/cgroup-defs.h |  8 ++++++++
 kernel/cgroup/cgroup.c      | 19 +++++++++++++++++--
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 9d741959f218..58b4c425a155 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -274,6 +274,14 @@ struct cgroup {
 	int level;
 
 	/*
+	 * Keep track of total numbers of visible and dying descent cgroups.
+	 * Dying cgroups are cgroups which were deleted by a user,
+	 * but are still existing because someone else is holding a reference.
+	 */
+	int nr_descendants;
+	int nr_dying_descendants;
+
+	/*
 	 * Each non-empty css_set associated with this cgroup contributes
 	 * one to nr_populated_csets.  The counter is zero iff this cgroup
 	 * doesn't have any tasks.
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 85f6a112344b..cfdbb1e780de 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4408,9 +4408,15 @@ static void css_release_work_fn(struct work_struct *work)
 		if (ss->css_released)
 			ss->css_released(css);
 	} else {
+		struct cgroup *tcgrp;
+
 		/* cgroup release path */
 		trace_cgroup_release(cgrp);
 
+		for (tcgrp = cgroup_parent(cgrp); tcgrp;
+		     tcgrp = cgroup_parent(tcgrp))
+			tcgrp->nr_dying_descendants--;
+
 		cgroup_idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
 		cgrp->id = -1;
 
@@ -4609,9 +4615,13 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
 	cgrp->root = root;
 	cgrp->level = level;
 
-	for (tcgrp = cgrp; tcgrp; tcgrp = cgroup_parent(tcgrp))
+	for (tcgrp = cgrp; tcgrp; tcgrp = cgroup_parent(tcgrp)) {
 		cgrp->ancestor_ids[tcgrp->level] = tcgrp->id;
 
+		if (tcgrp != cgrp)
+			tcgrp->nr_descendants++;
+	}
+
 	if (notify_on_release(parent))
 		set_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
 
@@ -4817,7 +4827,7 @@ static void kill_css(struct cgroup_subsys_state *css)
 static int cgroup_destroy_locked(struct cgroup *cgrp)
 	__releases(&cgroup_mutex) __acquires(&cgroup_mutex)
 {
-	struct cgroup *parent = cgroup_parent(cgrp);
+	struct cgroup *tcgrp, *parent = cgroup_parent(cgrp);
 	struct cgroup_subsys_state *css;
 	struct cgrp_cset_link *link;
 	int ssid;
@@ -4865,6 +4875,11 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	if (parent && cgroup_is_threaded(cgrp))
 		parent->nr_threaded_children--;
 
+	for (tcgrp = cgroup_parent(cgrp); tcgrp; tcgrp = cgroup_parent(tcgrp)) {
+		tcgrp->nr_descendants--;
+		tcgrp->nr_dying_descendants++;
+	}
+
 	cgroup1_check_for_release(cgroup_parent(cgrp));
 
 	/* put the base reference */
-- 
2.13.3

