From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH v10 8/9] cgroup: add tracing points for cgroup v2 freezer
Date: Fri,  5 Apr 2019 10:47:07 -0700
Message-ID: <20190405174708.1010-9-guro@fb.com>
References: <20190405174708.1010-1-guro@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+Xwgw7oNRWc5QUjdIzS9HWKC+CrbutV7TwPIITbbDd4=;
        b=XDqeaeSnd2hPunQJv8l1EwYu+c818r6D50Dm5yMr6X0anpwLI1ih2M5mjd9pkF2Fjv
         +pnI4yAVsepRQ4w8wNmvSUBUGMtA3JQ4C4m7VF2irPc7ACPEEPSAnlasFp978zTu2vHE
         C+E5kA5Kf5iJRYpPulrRj7cv4MjjxSSS3kxJMSknmy5oytN/V5z2+trE17uoFb8nt4TR
         6I3s4t3NAWtn5/8Dqg9kVEdsroQrJeeq/plurZSLRxrOOyLN6r0+TOmvYG0Doi5W0bct
         uP7VcTKdZN8E/wg0mibnD1x/X1s59oXpcXGxtu0WmYvq1JufuqFX87vgpJY1UvEcSLLH
         rUBA==
In-Reply-To: <20190405174708.1010-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

Add cgroup:cgroup_freeze and cgroup:cgroup_unfreeze events,
which are using the existing cgroup tracing infrastructure.

Add the cgroup_event event class, which is similar to the cgroup
class, but contains an additional integer field to store a new
value (the level field is dropped).

Also add two tracing events: cgroup_notify_populated and
cgroup_notify_frozen, which are raised in a generic way using
the TRACE_CGROUP_PATH() macro.

This allows to trace cgroup state transitions and is generally
helpful for debugging the cgroup freezer code.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 include/trace/events/cgroup.h | 55 +++++++++++++++++++++++++++++++++++
 kernel/cgroup/cgroup.c        |  2 ++
 kernel/cgroup/freezer.c       | 15 +++++++++-
 3 files changed, 71 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/cgroup.h b/include/trace/events/cgroup.h
index a401ff5e7847..a566cc521476 100644
--- a/include/trace/events/cgroup.h
+++ b/include/trace/events/cgroup.h
@@ -103,6 +103,20 @@ DEFINE_EVENT(cgroup, cgroup_rename,
 	TP_ARGS(cgrp, path)
 );
 
+DEFINE_EVENT(cgroup, cgroup_freeze,
+
+	TP_PROTO(struct cgroup *cgrp, const char *path),
+
+	TP_ARGS(cgrp, path)
+);
+
+DEFINE_EVENT(cgroup, cgroup_unfreeze,
+
+	TP_PROTO(struct cgroup *cgrp, const char *path),
+
+	TP_ARGS(cgrp, path)
+);
+
 DECLARE_EVENT_CLASS(cgroup_migrate,
 
 	TP_PROTO(struct cgroup *dst_cgrp, const char *path,
@@ -149,6 +163,47 @@ DEFINE_EVENT(cgroup_migrate, cgroup_transfer_tasks,
 	TP_ARGS(dst_cgrp, path, task, threadgroup)
 );
 
+DECLARE_EVENT_CLASS(cgroup_event,
+
+	TP_PROTO(struct cgroup *cgrp, const char *path, int val),
+
+	TP_ARGS(cgrp, path, val),
+
+	TP_STRUCT__entry(
+		__field(	int,		root			)
+		__field(	int,		id			)
+		__field(	int,		level			)
+		__string(	path,		path			)
+		__field(	int,		val			)
+	),
+
+	TP_fast_assign(
+		__entry->root = cgrp->root->hierarchy_id;
+		__entry->id = cgrp->id;
+		__entry->level = cgrp->level;
+		__assign_str(path, path);
+		__entry->val = val;
+	),
+
+	TP_printk("root=%d id=%d level=%d path=%s val=%d",
+		  __entry->root, __entry->id, __entry->level, __get_str(path),
+		  __entry->val)
+);
+
+DEFINE_EVENT(cgroup_event, cgroup_notify_populated,
+
+	TP_PROTO(struct cgroup *cgrp, const char *path, int val),
+
+	TP_ARGS(cgrp, path, val)
+);
+
+DEFINE_EVENT(cgroup_event, cgroup_notify_frozen,
+
+	TP_PROTO(struct cgroup *cgrp, const char *path, int val),
+
+	TP_ARGS(cgrp, path, val)
+);
+
 #endif /* _TRACE_CGROUP_H */
 
 /* This part must be outside protection */
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 6895464b54c6..57edcf398d71 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -816,6 +816,8 @@ static void cgroup_update_populated(struct cgroup *cgrp, bool populated)
 			break;
 
 		cgroup1_check_for_release(cgrp);
+		TRACE_CGROUP_PATH(notify_populated, cgrp,
+				  cgroup_is_populated(cgrp));
 		cgroup_file_notify(&cgrp->events_file);
 
 		child = cgrp;
diff --git a/kernel/cgroup/freezer.c b/kernel/cgroup/freezer.c
index 9d8cda478fc9..3bfbb3c8baf3 100644
--- a/kernel/cgroup/freezer.c
+++ b/kernel/cgroup/freezer.c
@@ -6,6 +6,8 @@
 
 #include "cgroup-internal.h"
 
+#include <trace/events/cgroup.h>
+
 /*
  * Propagate the cgroup frozen state upwards by the cgroup tree.
  */
@@ -28,6 +30,7 @@ static void cgroup_propagate_frozen(struct cgroup *cgrp, bool frozen)
 			    cgrp->nr_descendants) {
 				set_bit(CGRP_FROZEN, &cgrp->flags);
 				cgroup_file_notify(&cgrp->events_file);
+				TRACE_CGROUP_PATH(notify_frozen, cgrp, 1);
 				desc++;
 			}
 		} else {
@@ -35,6 +38,7 @@ static void cgroup_propagate_frozen(struct cgroup *cgrp, bool frozen)
 			if (test_bit(CGRP_FROZEN, &cgrp->flags)) {
 				clear_bit(CGRP_FROZEN, &cgrp->flags);
 				cgroup_file_notify(&cgrp->events_file);
+				TRACE_CGROUP_PATH(notify_frozen, cgrp, 0);
 				desc++;
 			}
 		}
@@ -73,6 +77,7 @@ void cgroup_update_frozen(struct cgroup *cgrp)
 		clear_bit(CGRP_FROZEN, &cgrp->flags);
 	}
 	cgroup_file_notify(&cgrp->events_file);
+	TRACE_CGROUP_PATH(notify_frozen, cgrp, frozen);
 
 	/* Update the state of ancestor cgroups. */
 	cgroup_propagate_frozen(cgrp, frozen);
@@ -189,6 +194,11 @@ static void cgroup_do_freeze(struct cgroup *cgrp, bool freeze)
 		clear_bit(CGRP_FREEZE, &cgrp->flags);
 	spin_unlock_irq(&css_set_lock);
 
+	if (freeze)
+		TRACE_CGROUP_PATH(freeze, cgrp);
+	else
+		TRACE_CGROUP_PATH(unfreeze, cgrp);
+
 	css_task_iter_start(&cgrp->self, 0, &it);
 	while ((task = css_task_iter_next(&it))) {
 		/*
@@ -312,6 +322,9 @@ void cgroup_freeze(struct cgroup *cgrp, bool freeze)
 	 * In both cases it's better to notify a user, that there is
 	 * nothing to wait for.
 	 */
-	if (!applied)
+	if (!applied) {
+		TRACE_CGROUP_PATH(notify_frozen, cgrp,
+				  test_bit(CGRP_FROZEN, &cgrp->flags));
 		cgroup_file_notify(&cgrp->events_file);
+	}
 }
-- 
2.20.1

