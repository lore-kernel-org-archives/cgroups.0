From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH v3 7/7] cgroup: document cgroup v2 freezer interface
Date: Fri, 16 Nov 2018 16:38:30 -0800
Message-ID: <20181117003830.15344-8-guro@fb.com>
References: <20181117003830.15344-1-guro@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=37Hf1x10NLuEt+wNwFB65vwUj5lPVMCSL7uBe89akZ4=;
        b=GEbzETZBCS/sOrvlWPM6Nhp9oQNy1y0bCkc1luh6bqDnYXjnaj8b118TW3aPXUNeJG
         ZsW1NtPfg2zP6VTm5m5uC0QoS6I9O4H53mzKOTFCfPqJZ9q5+FEbtZrlwTGl5c1jHy98
         mHQLxa5dl6Ag6j8kN0WsWmgNieYXFIzo7l9L3Xkkd0vc6bjj+YO5wMQGJ/ezU1FB1jBy
         Db9vvWfG4usAL/toFiuYFDe05h2fved91XnUuFJ6lpXbQZzPKl97JRdHHrMu6G/R2dRe
         j4EPl90x48QzEBlYfHwwMQZ7UxOUHOJBWlT/WLZoVTbPOMtkEVvIK2/+mYacf/akZ1BK
         es0Q==
In-Reply-To: <20181117003830.15344-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>, linux-doc@vger.kernel.org

Describe cgroup v2 freezer interface in the cgroup v2 admin guide.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-doc@vger.kernel.org
Cc: kernel-team@fb.com
---
 Documentation/admin-guide/cgroup-v2.rst | 26 +++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 184193bcb262..a065c0bed88c 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -862,6 +862,8 @@ All cgroup core files are prefixed with "cgroup."
 	  populated
 		1 if the cgroup or its descendants contains any live
 		processes; otherwise, 0.
+	  frozen
+		1 if the cgroup is frozen; otherwise, 0.
 
   cgroup.max.descendants
 	A read-write single value files.  The default is "max".
@@ -895,6 +897,30 @@ All cgroup core files are prefixed with "cgroup."
 		A dying cgroup can consume system resources not exceeding
 		limits, which were active at the moment of cgroup deletion.
 
+  cgroup.freeze
+	A read-write single value file which exists on non-root cgroups.
+	Allowed values are "0" and "1". The default is "0".
+
+	Writing "1" to the file causes freezing of the cgroup and all
+	descendant cgroups. This means that all belonging processes will
+	be stopped and will not run until the cgroup will be explicitly
+	unfrozen. Freezing of the cgroup may take some time; when the process
+	is complete, the "frozen" value in the cgroup.events control file
+	will be updated and the corresponding notification will be issued.
+
+	Cgroup can be frozen either by its own settings, either by settings
+	of any ancestor cgroups. If any of ancestor cgroups is frozen, the
+	cgroup will remain frozen.
+
+	Processes in the frozen cgroup can be killed by a fatal signal.
+	They also can enter and leave a frozen cgroup: either by an explicit
+	move by a user, either if freezing of the cgroup races with fork().
+	If a cgroup is moved to a frozen cgroup, it stops. If a process is
+	moving out of a frozen cgroup, it becomes running.
+
+	Frozen status of a cgroup doesn't affect any cgroup tree operations:
+	it's possible to delete a frozen (and empty) cgroup, as well as
+	create new sub-cgroups.
 
 Controllers
 ===========
-- 
2.17.2

