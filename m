From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/4] cgroup: define controller file conventions
Date: Sun,  2 Aug 2015 16:23:42 -0400
Message-ID: <1438547024-23497-3-git-send-email-tj@kernel.org>
References: <1438547024-23497-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=J9ZNAa64X0NXAjma889909SoxUfs6FLbiYV3/1EqtAo=;
        b=hqvzluYWI2F9EugSYXBAbKQtbkwXp0C1njr0aS4kD6XEe3s2HYzDy4OMuepmkJwOFJ
         Zyno0EVoX7/vGlMiEGmE1ysx5QEoW7yp2Y+SwHwVkLEEG8T2CZjUUXj+OblzaI3oXzjo
         kDf1U4a/VSmsSxR3zm8sTwQFPjeVe8qtvX/X7CV/22tu0yWS3U3Kq8O3OjnOsrrbYZL+
         XnIJoVVJJxRLpfIPElMtaTuLp6KA6mVY9U+is8wjd4bYtUqBuTnvCzvHUA2CBwkzClua
         y/55N3S4fa8jDKM4IVZppKR5Ar4w16ELCa7GwPlcwbYLbjQHUa5/FsoeLtiSaavH7luA
         Y5/A==
In-Reply-To: <1438547024-23497-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk, hannes@cmpxchg.org, lizefan@huawei.com
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com, avanzini.arianna@gmail.com, cgroups@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

Traditionally, each cgroup controller implemented whatever interface
it wanted leading to interfaces which are widely inconsistent.
Examining the requirements of the controllers readily yield that there
are only a few control schemes shared among all.

Two major controllers already had to implement new interface for the
unified hierarchy due to significant structural changes.  Let's take
the chance to establish common conventions throughout all controllers.

This patch defines CGROUP_WEIGHT_MIN/DFL/MAX to be used on all weight
based control knobs and documents the conventions that controllers
should follow on the unified hierarchy.  Except for io.weight knob,
all existing unified hierarchy knobs are already compliant.  A
follow-up patch will update io.weight.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 Documentation/cgroups/unified-hierarchy.txt | 75 ++++++++++++++++++++++++++---
 include/linux/cgroup.h                      |  9 ++++
 2 files changed, 76 insertions(+), 8 deletions(-)

diff --git a/Documentation/cgroups/unified-hierarchy.txt b/Documentation/cgroups/unified-hierarchy.txt
index 4e23d4c..ee6ce34 100644
--- a/Documentation/cgroups/unified-hierarchy.txt
+++ b/Documentation/cgroups/unified-hierarchy.txt
@@ -23,10 +23,13 @@ CONTENTS
 5. Other Changes
   5-1. [Un]populated Notification
   5-2. Other Core Changes
-  5-3. Per-Controller Changes
-    5-3-1. blkio
-    5-3-2. cpuset
-    5-3-3. memory
+  5-3. Controller file conventions
+    5-3-1. Format
+    5-3-2. Control knobs
+  5-4. Per-Controller Changes
+    5-4-1. blkio
+    5-4-2. cpuset
+    5-4-3. memory
 6. Planned Changes
   6-1. CAP for resource control
 
@@ -372,9 +375,65 @@ supported and the interface files "release_agent" and
 - The "cgroup.clone_children" file is removed.
 
 
-5-3. Per-Controller Changes
+5-3. Controller file conventions
 
-5-3-1. io
+5-3-1. Format
+
+In general, all controller files should be in one of the following
+formats whenever possible.
+
+- Values only files
+
+  VAL0 VAL1...\n
+
+- Flat keyed files
+
+  KEY0 VAL0\n
+  KEY1 VAL1\n
+  ...
+
+- Nested keyed files
+
+  KEY0 SUB_KEY0=VAL00 SUB_KEY1=VAL01...
+  KEY1 SUB_KEY0=VAL10 SUB_KEY1=VAL11...
+  ...
+
+For a writeable file, the format for writing should generally match
+reading; however, controllers may allow omitting later fields or
+implement restricted shortcuts for most common use cases.
+
+For both flat and nested keyed files, only the values for a single key
+can be written at a time.  For nested keyed files, the sub key pairs
+may be specified in any order and not all pairs have to be specified.
+
+
+5-3-2. Control knobs
+
+- Settings for a single feature should generally be implemented in a
+  single file.
+
+- In general, the root cgroup should be exempt from resource control
+  and thus shouldn't have resource control knobs.
+
+- If a controller implements ratio based resource distribution, the
+  control knob should be named "weight" and have the range [1, 10000]
+  and 100 should be the default value.  The values are chosen to allow
+  enough and symmetric bias in both directions while keeping it
+  intuitive (the default is 100%).
+
+- If a controller implements an absolute resource limit, the control
+  knob should be named "max".  The special token "max" should be used
+  to represent no limit for both reading and writing.
+
+- If a setting has configurable default value and specific overrides,
+  the default settings should be keyed with "default" and appear as
+  the first entry in the file.  Specific entries can use "default" as
+  its value to indicate inheritance of the default value.
+
+
+5-4. Per-Controller Changes
+
+5-4-1. io
 
 - blkio is renamed to io.  The interface is overhauled anyway.  The
   new name is more in line with the other two major controllers, cpu
@@ -432,7 +491,7 @@ supported and the interface files "release_agent" and
 	This file is available only on non-root cgroups.
 
 
-5-3-2. cpuset
+5-4-2. cpuset
 
 - Tasks are kept in empty cpusets after hotplug and take on the masks
   of the nearest non-empty ancestor, instead of being moved to it.
@@ -441,7 +500,7 @@ supported and the interface files "release_agent" and
   masks of the nearest non-empty ancestor.
 
 
-5-3-3. memory
+5-4-3. memory
 
 - use_hierarchy is on by default and the cgroup file for the flag is
   not created.
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index a593e29..c6bf9d3 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -22,6 +22,15 @@
 
 #ifdef CONFIG_CGROUPS
 
+/*
+ * All weight knobs on the default hierarhcy should use the following min,
+ * default and max values.  The default value is the logarithmic center of
+ * MIN and MAX and allows 100x to be expressed in both directions.
+ */
+#define CGROUP_WEIGHT_MIN		1
+#define CGROUP_WEIGHT_DFL		100
+#define CGROUP_WEIGHT_MAX		10000
+
 /* a css_task_iter should be treated as an opaque object */
 struct css_task_iter {
 	struct cgroup_subsys		*ss;
-- 
2.4.3
