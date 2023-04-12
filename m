From: Waiman Long <longman@redhat.com>
Subject: [RFC PATCH 4/5] cgroup/cpuset: Documentation update for the new "isolcpus" partition
Date: Wed, 12 Apr 2023 11:37:57 -0400
Message-ID: <20230412153758.3088111-5-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681313913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=k6rrgRvWYYfVtAToY1FAF0Jliiym6oOFi31ZayQ1IeY=;
        b=fTAyIeLpwyWKoGxWTazIw+CR/tgCODfV95/wwsttnMF97hEdWyChc/iqZtEZ8HU77c977s
        6YDqP6I7juwljEqgBGNbyNAnD7xH6Koa3vNCk75dQ3SITszc+Es0MzRHLlUvu6Sxhj8V2p
        RsQo6cOUDqnqjQVQdvqbsj+yAlaVre4=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Waiman Long <longman@redhat.com>

This patch updates the cgroup-v2.rst file to include information about
the new "isolcpus" partition type.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 89 +++++++++++++++++++------
 1 file changed, 70 insertions(+), 19 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index f67c0829350b..352a02849fa7 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2225,7 +2225,8 @@ Cpuset Interface Files
 	  ==========	=====================================
 	  "member"	Non-root member of a partition
 	  "root"	Partition root
-	  "isolated"	Partition root without load balancing
+	  "isolcpus"	Partition root for isolated CPUs pool
+	  "isolated"	Partition root for isolated CPUs
 	  ==========	=====================================
 
 	The root cgroup is always a partition root and its state
@@ -2237,24 +2238,41 @@ Cpuset Interface Files
 	its descendants except those that are separate partition roots
 	themselves and their descendants.
 
+	When set to "isolcpus", the CPUs in that partition root will
+	be in an isolated state without any load balancing from the
+	scheduler.  This partition root is special as there can be at
+	most one instance of it in a system and no task or child cpuset
+	is allowed in this cgroup.  It acts as a pool of isolated CPUs to
+	be pulled into other "isolated" partitions.  The "cpuset.cpus"
+	of an "isolcpus" partition root contains the list of isolated
+	CPUs it holds, where "cpuset.cpus.effective" contains the list
+	of freely available isolated CPUs that are ready to be pull
+	into other "isolated" partition.
+
 	When set to "isolated", the CPUs in that partition root will
 	be in an isolated state without any load balancing from the
 	scheduler.  Tasks placed in such a partition with multiple
 	CPUs should be carefully distributed and bound to each of the
-	individual CPUs for optimal performance.
-
-	The value shown in "cpuset.cpus.effective" of a partition root
-	is the CPUs that the partition root can dedicate to a potential
-	new child partition root. The new child subtracts available
-	CPUs from its parent "cpuset.cpus.effective".
-
-	A partition root ("root" or "isolated") can be in one of the
-	two possible states - valid or invalid.  An invalid partition
-	root is in a degraded state where some state information may
-	be retained, but behaves more like a "member".
-
-	All possible state transitions among "member", "root" and
-	"isolated" are allowed.
+	individual CPUs for optimal performance.  The isolated CPUs can
+	come from either the parent partition root or from an "isolcpus"
+	partition if the parent cannot satisfy its request.
+
+	The value shown in "cpuset.cpus.effective" of a partition root is
+	the CPUs that the partition root can dedicate to a potential new
+	child partition root. The new child partition subtracts available
+	CPUs from its parent "cpuset.cpus.effective". An exception is
+	an "isolated" partition that pulls its isolated CPUs from the
+	"isolcpus" partition root that is not its direct parent.
+
+	A partition root can be in one of the two possible states -
+	valid or invalid.  An invalid partition root is in a degraded
+	state where some state information may be retained, but behaves
+	more like a "member".
+
+	All possible state transitions among "member", "root", "isolcpus"
+	and "isolated" are allowed.  However, the partition root may
+	not be valid if the corresponding prerequisite conditions are
+	not met.
 
 	On read, the "cpuset.cpus.partition" file can show the following
 	values.
@@ -2262,16 +2280,18 @@ Cpuset Interface Files
 	  =============================	=====================================
 	  "member"			Non-root member of a partition
 	  "root"			Partition root
-	  "isolated"			Partition root without load balancing
+	  "isolcpus"			Partition root for isolated CPUs pool
+	  "isolated"			Partition root for isolated CPUs
 	  "root invalid (<reason>)"	Invalid partition root
+	  "isolcpus invalid (<reason>)"	Invalid isolcpus partition root
 	  "isolated invalid (<reason>)"	Invalid isolated partition root
 	  =============================	=====================================
 
 	In the case of an invalid partition root, a descriptive string on
-	why the partition is invalid is included within parentheses.
+	why the partition is invalid may be included within parentheses.
 
-	For a partition root to become valid, the following conditions
-	must be met.
+	For a "root" partition root to become valid, the following
+	conditions must be met.
 
 	1) The "cpuset.cpus" is exclusive with its siblings , i.e. they
 	   are not shared by any of its siblings (exclusivity rule).
@@ -2281,6 +2301,37 @@ Cpuset Interface Files
 	4) The "cpuset.cpus.effective" cannot be empty unless there is
 	   no task associated with this partition.
 
+        A valid "isolcpus" partition root requires the following
+        conditions.
+
+        1) The parent cgroup is a valid partition root.
+        2) The "cpuset.cpus" must be a subset of parent's "cpuset.cpus"
+           including an empty cpu list.
+        3) There can be no more than one valid "isolcpus" partition.
+        4) No task or child cpuset is allowed.
+
+        Note that an "isolcpus" partition is not exclusive and its
+        isolated CPUs can be distributed down sibling cgroups even
+        though they may not appear in their "cpuset.cpus.effective".
+
+        A valid "isolated" partition root can pull isolated CPUs from
+        either its parent partition or from the "isolcpus" partition.
+        It also requires the following conditions to be met.
+
+	1) The "cpuset.cpus" is exclusive with its siblings , i.e. they
+	   are not shared by any of its siblings (exclusivity rule).
+	2) The "cpuset.cpus" is not empty and must be a subset of
+	   parent's "cpuset.cpus".
+	3) The "cpuset.cpus.effective" cannot be empty unless there is
+	   no task associated with this partition.
+
+        If pulling isolated CPUS from "isolcpus" partition,
+        the "cpuset.cpus" must also be a subset of "isolcpus"
+        partition's "cpuset.cpus" and all the requested CPUs must
+        be available for pulling, i.e. in "isolcpus" partition's
+        "cpuset.cpus.effective". In this case, its hierarchical parent
+        does not need to be a valid partition root.
+
 	External events like hotplug or changes to "cpuset.cpus" can
 	cause a valid partition root to become invalid and vice versa.
 	Note that a task cannot be moved to a cgroup with empty
-- 
2.31.1

