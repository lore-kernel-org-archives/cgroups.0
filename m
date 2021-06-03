From: Waiman Long <longman@redhat.com>
Subject: [PATCH 4/5] cgroup/cpuset: Update description of cpuset.cpus.partition in cgroup-v2.rst
Date: Thu,  3 Jun 2021 17:24:15 -0400
Message-ID: <20210603212416.25934-5-longman@redhat.com>
References: <20210603212416.25934-1-longman@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622755502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=thMjmtJh5+hm9zST5bagiDDjjocf7BWJz4f5zZJsM5c=;
        b=FnQW/IzJUBw19JykRcwOLz9rAiwlRRurGEvWMrrlpw3EfKJkBMVRjC3Fw1SJk1lO4Qk2Hq
        l+aNZIaVnvJi2ptn1Alg4XnZ5LCYgaMby7OzdN+eSKfxLO+R/zOcB5ginBgwVVNYsa4JZ7
        +fL/F4Y8/ilFI2YAYQ5WgO6Uiws+kY8=
In-Reply-To: <20210603212416.25934-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Waiman Long <longman@redhat.com>

Update Documentation/admin-guide/cgroup-v2.rst on the new "root-nolb"
cpuset partition type as well as the ability to create non-top cpuset
partition with no cpu allocated to it.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index b1e81aa8598a..36a923cabeb0 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2010,8 +2010,9 @@ Cpuset Interface Files
 	It accepts only the following input values when written to.
 
 	  ========	================================
-	  "root"	a partition root
-	  "member"	a non-root member of a partition
+	  "member"	Non-root member of a partition
+	  "root"	Partition root
+	  "root-nolb"	Partition root with no load balancing
 	  ========	================================
 
 	When set to be a partition root, the current cgroup is the
@@ -2020,6 +2021,10 @@ Cpuset Interface Files
 	partition roots themselves and their descendants.  The root
 	cgroup is always a partition root.
 
+        With "root-nolb", the CPUs in that partition root will be in an
+        isolated state with no load balancing by the scheduler.  Tasks in
+        such a partition must be explicitly bind to each individual CPU.
+
 	There are constraints on where a partition root can be set.
 	It can only be set in a cgroup if all the following conditions
 	are true.
@@ -2038,9 +2043,12 @@ Cpuset Interface Files
 	file cannot be reverted back to "member" if there are any child
 	cgroups with cpuset enabled.
 
-	A parent partition cannot distribute all its CPUs to its
-	child partitions.  There must be at least one cpu left in the
-	parent partition.
+	A parent partition may distribute all its CPUs to its child
+	partitions as long as it is not the root cgroup and there is no
+	task directly associated with that parent partition.  Otherwise,
+	there must be at least one cpu left in the parent partition.
+	A new task cannot be moved to a partition root with no effective
+	cpu.
 
 	Once becoming a partition root, changes to "cpuset.cpus" is
 	generally allowed as long as the first condition above is true,
@@ -2056,6 +2064,7 @@ Cpuset Interface Files
 	  ==============	==============================
 	  "member"		Non-root member of a partition
 	  "root"		Partition root
+	  "root-nolb"		Partition root with no load balancing
 	  "root invalid"	Invalid partition root
 	  ==============	==============================
 
-- 
2.18.1

