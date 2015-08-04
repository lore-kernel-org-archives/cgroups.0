From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 1/3] cgroup: define controller file conventions
Date: Tue, 4 Aug 2015 15:31:01 -0400
Message-ID: <20150804193101.GI17598@mtj.duckdns.org>
References: <1438641689-14655-1-git-send-email-tj@kernel.org>
 <1438641689-14655-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=eSJw849rVbVYMboHR9H1jpI/XNXIdVYXW6uv+T6CbXM=;
        b=ujlyRq7nuBCPU9Uwncnbp9BOlXkAhKwTCp+tWjAP7NIS3NDxkFZt942DT4XgompHZm
         7qcK8ZZndD1mPJYAvaA/rYNKBq+P9bDqB/RXoeIBc7seELmXg6yNUX/ihUZD5D6pQ3R1
         q8WFNg/nyTde+7RfblM/FEpBNcKrvtB1Fc4i5qdxNokY0GzkiYmgjHkqt27UhrT0Hxtl
         kER05/eJ3498Ryz2VdAWiqfFy/vzktEMiyglPr55rqONphWS1X+sybbHVgyE8JyH7txB
         CEqcPxbaml3cpqu7HGO0rxe9v3J4FyPhEOhqeB8Rj94xV/c1sMfiJIfbZBIW9Z1rwBZP
         Dmqw==
Content-Disposition: inline
In-Reply-To: <1438641689-14655-2-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

From 6abc8ca19df0078de17dc38340db3002ed489ce7 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Tue, 4 Aug 2015 15:20:55 -0400

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

v2: Added descriptions of min, low and high knobs.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
---
Hello,

Added low/high descriptions and applied to the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.3-unified-base

The branch currently only contains this patch and will stay stable so
that it can be pulled from.  I kept the base weight as DFL for now.
If we decide to change it, I'll apply the change on top.

Thanks.

 Documentation/cgroups/unified-hierarchy.txt | 80 ++++++++++++++++++++++++++---
 include/linux/cgroup.h                      |  9 ++++
 2 files changed, 81 insertions(+), 8 deletions(-)

diff --git a/Documentation/cgroups/unified-hierarchy.txt b/Documentation/cgroups/unified-hierarchy.txt
index 86847a7..1ee9caf 100644
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
+  5-3. Controller File Conventions
+    5-3-1. Format
+    5-3-2. Control Knobs
+  5-4. Per-Controller Changes
+    5-4-1. blkio
+    5-4-2. cpuset
+    5-4-3. memory
 6. Planned Changes
   6-1. CAP for resource control
 
@@ -372,14 +375,75 @@ supported and the interface files "release_agent" and
 - The "cgroup.clone_children" file is removed.
 
 
-5-3. Per-Controller Changes
+5-3. Controller File Conventions
 
-5-3-1. blkio
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
+5-3-2. Control Knobs
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
+- If a controller implements an absolute resource guarantee and/or
+  limit, the control knobs should be named "min" and "max"
+  respectively.  If a controller implements best effort resource
+  gurantee and/or limit, the control knobs should be named "low" and
+  "high" respectively.
+
+  In the above four control files, the special token "max" should be
+  used to represent upward infinity for both reading and writing.
+
+- If a setting has configurable default value and specific overrides,
+  the default settings should be keyed with "default" and appear as
+  the first entry in the file.  Specific entries can use "default" as
+  its value to indicate inheritance of the default value.
+
+
+5-4. Per-Controller Changes
+
+5-4-1. blkio
 
 - blk-throttle becomes properly hierarchical.
 
 
-5-3-2. cpuset
+5-4-2. cpuset
 
 - Tasks are kept in empty cpusets after hotplug and take on the masks
   of the nearest non-empty ancestor, instead of being moved to it.
@@ -388,7 +452,7 @@ supported and the interface files "release_agent" and
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
