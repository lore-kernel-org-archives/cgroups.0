From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH v2 6/6] cgroup: document cgroup v2 freezer interface
Date: Mon, 12 Nov 2018 15:04:22 -0800
Message-ID: <20181112230422.5911-8-guro@fb.com>
References: <20181112230422.5911-1-guro@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4w/uS5CdZfUu32Qk39NtHIWDaBjSkhBcPb+FbjjLeZ4=;
        b=dm7fPh0acIHGQ5Z8xnOsWcFO8KhDk63z8PKG4Xsb2XmwAE/FdYTEuVpCfdPSdc7aAp
         lP5biEwRbyS1xfrtITtHOt/ZF2KOEFOwAXgNowq/Q/2pciZpzq2vha9DlXLIEEoBMJ9/
         kfKb1nZjI5NhpHMV2ZEZW2vdmhsI5u9dl6y/nb8bsHGZSdWV15UUy6h/xl62aNc9AHSs
         /NVQ9IFh9vt50wfJtHygAy0i4K2J2mn9eqZhCvb9LvkixVOnGxrdE4r+zwCKamGv/5Vw
         BXvhhLvLdpAj0Oh4Hn364HwaVyTq+24naqFNkewsYzmJHfJIkhCC9q9TfT+ZrUoreABp
         4sKA==
In-Reply-To: <20181112230422.5911-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>

Describe cgroup v2 freezer interface in the cgroup v2 admin guide.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
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

