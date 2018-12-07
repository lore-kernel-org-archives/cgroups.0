From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH v5 7/7] cgroup: document cgroup v2 freezer interface
Date: Fri,  7 Dec 2018 12:15:31 -0800
Message-ID: <20181207201531.1665-8-guro@fb.com>
References: <20181207201531.1665-1-guro@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6XRT3PIBruu3XRiswo1BJ+me6VnnM1g5UdR6upb//c0=;
        b=maFrqRoQMw6RJAiN+/YYnssncI3k9OlpsrMUv7FEh16SuZ45JstfYzUf9uMlPh9WRA
         /zd75KPy6OVK8X70t6tpl5nDDe2cdd7Dh4nh2Ku0fhUkyCTqfO019AIL6PEP7H1lxcHp
         g57AXbNAM1Aq4yA8Vj/EqJ7qbPUQEFiKZl6aZd29F1V4nT4oMcNnXfN1TEAh7pb9H/8R
         U8jFjCapNI8+hUfeQ6r0Oc9lKd3HNFo/5wT0LsgaFx9v0EUr3ew1apeThc8hOM/yX6cH
         WmsOeJvNXAcx91miWcdDhPui/STM9WNivjzuxP5shd5r5JaXmLT6w/Ib6eOVHbdSQgd9
         rHAg==
In-Reply-To: <20181207201531.1665-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>

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
index 07e06136a550..f8335e26b362 100644
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
2.17.2

