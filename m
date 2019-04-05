From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH v10 9/9] cgroup: document cgroup v2 freezer interface
Date: Fri,  5 Apr 2019 10:47:08 -0700
Message-ID: <20190405174708.1010-10-guro@fb.com>
References: <20190405174708.1010-1-guro@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sPwqK0qKQccz1rnM8spQH4fx1OfXTPfbuyAOOQ+8AD0=;
        b=dkTZWcoctKvv3aWGfJ+h5Whk/0MAavdY7xUT5DQ7kJVHQtRlg/JrdskB3bZPgjs1g9
         76JbeYYkdvA3DNH5puqxF/F6SzZyGnHj9eYb675X5n6iCh1oBMzHxkRfLqOdf8www1U9
         gtf2W8hpXxXkz3nAtnnquaVQMjRIUeXi8DlGUcq63gCvLtE9nocg8Sl+OeWIte+gv7Hl
         YOOKnqHG/zX+haCgiYcilgCgt8MF5/EacFL+a112Z87UPWKCdDY0quZpZfJk61z6+Nyu
         jqjnjXr7OYBN/yVNHl0bn6hrM/Dl2RB3UOZPjy3VfA6I1UB0UzUaoOSfZ08vGZKTy22q
         yNuw==
In-Reply-To: <20190405174708.1010-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>, Mike Rapoport <rppt@linux.ibm.com>, linux-doc@vger.kernel.org

Describe cgroup v2 freezer interface in the cgroup v2 admin guide.

Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-doc@vger.kernel.org
Cc: kernel-team@fb.com
---
 Documentation/admin-guide/cgroup-v2.rst | 27 +++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 20f92c16ffbf..88e746074252 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -864,6 +864,8 @@ All cgroup core files are prefixed with "cgroup."
 	  populated
 		1 if the cgroup or its descendants contains any live
 		processes; otherwise, 0.
+	  frozen
+		1 if the cgroup is frozen; otherwise, 0.
 
   cgroup.max.descendants
 	A read-write single value files.  The default is "max".
@@ -897,6 +899,31 @@ All cgroup core files are prefixed with "cgroup."
 		A dying cgroup can consume system resources not exceeding
 		limits, which were active at the moment of cgroup deletion.
 
+  cgroup.freeze
+	A read-write single value file which exists on non-root cgroups.
+	Allowed values are "0" and "1". The default is "0".
+
+	Writing "1" to the file causes freezing of the cgroup and all
+	descendant cgroups. This means that all belonging processes will
+	be stopped and will not run until the cgroup will be explicitly
+	unfrozen. Freezing of the cgroup may take some time; when this action
+	is completed, the "frozen" value in the cgroup.events control file
+	will be updated to "1" and the corresponding notification will be
+	issued.
+
+	A cgroup can be frozen either by its own settings, or by settings
+	of any ancestor cgroups. If any of ancestor cgroups is frozen, the
+	cgroup will remain frozen.
+
+	Processes in the frozen cgroup can be killed by a fatal signal.
+	They also can enter and leave a frozen cgroup: either by an explicit
+	move by a user, or if freezing of the cgroup races with fork().
+	If a process is moved to a frozen cgroup, it stops. If a process is
+	moved out of a frozen cgroup, it becomes running.
+
+	Frozen status of a cgroup doesn't affect any cgroup tree operations:
+	it's possible to delete a frozen (and empty) cgroup, as well as
+	create new sub-cgroups.
 
 Controllers
 ===========
-- 
2.20.1

