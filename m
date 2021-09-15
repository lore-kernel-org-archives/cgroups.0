From: brookxu <brookxu.cn@gmail.com>
Subject: [PATCH v3 3/3] docs/cgroup: add entry for misc.events
Date: Wed, 15 Sep 2021 10:18:51 +0800
Message-ID: <7cb32b92b77188f50b46bb47eb728bcacf18c17f.1631671936.git.brookxu@tencent.com>
References: <3834f917d50a6f19402e179e917ef6a9dde5f64a.1631671936.git.brookxu@tencent.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=mjJOq2l9/1TGAZpwrREsl45rYpK7gUexDrTF0O7TVOE=;
        b=FrgumB802lOc8B4BExnulAfH/g8d9tm7wO15QrXk0LDXtE47qb9MIVHVN174MQleXg
         tWy2fhx311YpXG5MN4WCSd1YFTCxkR3xcqX2GLGx+0kbULFYrkj2C7KLBGlDaB+SmLJV
         G71mBdKxZRU8psK/fl2/GL09fSFygV+APEhVrRpv3AnYiYf0g4ajh+lN3wIvfyIVvBkL
         DmSVqKOVw5LYQYY5O7b5hb4FroGN2uK/k1T9j1WvXaEJj2QpxHz+lM7hiT9Xgi5znScP
         mdY4VMueqOX1aNTYavIOHfg8gEkaAEha2x7UT29Zu9rhp17GTo9Nnx7yUsqy1uEUxWo5
         03pg==
In-Reply-To: <3834f917d50a6f19402e179e917ef6a9dde5f64a.1631671936.git.brookxu@tencent.com>
In-Reply-To: <3834f917d50a6f19402e179e917ef6a9dde5f64a.1631671936.git.brookxu@tencent.com>
References: <3834f917d50a6f19402e179e917ef6a9dde5f64a.1631671936.git.brookxu@tencent.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org
Cc: vipinsh@google.com, mkoutny@suse.com, corbet@lwn.net, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

From: Chunguang Xu <brookxu@tencent.com>

Added descriptions of misc.events.

Signed-off-by: Chunguang Xu <brookxu@tencent.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index babbe04..e7acc55 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2310,6 +2310,16 @@ Miscellaneous controller provides 3 interface files. If two misc resources (res_
         Limits can be set higher than the capacity value in the misc.capacity
         file.
 
+  misc.events
+	A read-only flat-keyed file which exists on non-root cgroups. The
+	following entries are defined. Unless specified otherwise, a value
+	change in this file generates a file modified event. All fields in
+	this file are hierarchical.
+
+	  max
+		The number of times the cgroup's resource usage was
+		about to go over the max boundary.
+
 Migration and Ownership
 ~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
1.8.3.1

