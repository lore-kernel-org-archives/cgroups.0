From: Roman Gushchin <guro@fb.com>
Subject: Re: [v5 4/4] mm, oom, docs: describe the cgroup-aware OOM killer
Date: Thu, 17 Aug 2017 13:16:47 +0100
Message-ID: <20170817121647.GA26107@castle.DHCP.thefacebook.com>
References: <20170814183213.12319-1-guro@fb.com>
 <20170814183213.12319-5-guro@fb.com>
 <alpine.DEB.2.10.1708141544280.63207@chino.kir.corp.google.com>
 <20170815141350.GA4510@castle.DHCP.thefacebook.com>
 <alpine.DEB.2.10.1708151349280.104516@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=10j0WvjUKSv+lGbiqlPNUgsGwgx5Xr4mHhIBJPhpM/0=;
 b=Q9crIEWVjqW3+pilpTEcIUQuXm1FvZzZ3cHdLWxPNF+Zan7pdmjqnQQa27+jRdqoB2Ww
 oZ9d8faHAxRE96pOvlG6qlCUL/X4OSyPmtDzo9PMiWzpWH8uSosPezkTBXcwmeTIJvN+
 vk/vvaF0bfnHBBZT3yDkJ6xqOYAwFOIf8Ks= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=10j0WvjUKSv+lGbiqlPNUgsGwgx5Xr4mHhIBJPhpM/0=;
 b=NzviE1uhLi83xMjy1hUiaoYr/r5nfn8MvZYs10QHBRWkBviJePnjWaYYZQ1pWF7bqQsoejy/1cHg/7JUNAle7PwLqSqqfN9XZWbsHPpSZxdtvrrhNIQreUgGAthF8l+hg/LG6dagdYND5sPLNAa+48ttu0CqElep7DNlKWfPkkk=
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1708151349280.104516@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Hi David!

Please, find an updated version of docs patch below.

Thanks!

Roman

--

From 97805b3dcccb9420d2c4380e88e202164ead0e45 Mon Sep 17 00:00:00 2001
From: Roman Gushchin <guro@fb.com>
Date: Fri, 2 Jun 2017 11:29:14 +0100
Subject: [PATCH 4/4] mm, oom, docs: describe the cgroup-aware OOM killer

Update cgroups v2 docs.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: kernel-team@fb.com
Cc: cgroups@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 Documentation/cgroup-v2.txt | 62 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index dec5afdaa36d..0e93c5b9cbd2 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -48,6 +48,7 @@ v1 is available under Documentation/cgroup-v1/.
        5-2-1. Memory Interface Files
        5-2-2. Usage Guidelines
        5-2-3. Memory Ownership
+       5-2-4. OOM Killer
      5-3. IO
        5-3-1. IO Interface Files
        5-3-2. Writeback
@@ -1002,6 +1003,34 @@ PAGE_SIZE multiple when read back.
 	high limit is used and monitored properly, this limit's
 	utility is limited to providing the final safety net.
 
+  memory.oom_kill_all_tasks
+
+	A read-write single value file which exists on non-root
+	cgroups.  The default is "0".
+
+	If set, OOM killer will kill all processes attached to the cgroup
+	if selected as an OOM victim.
+
+	Be default, the OOM killer respects the /proc/pid/oom_score_adj
+	value -1000, and will never kill the task, unless oom_kill_all_tasks
+	is set.
+
+  memory.oom_priority
+
+	A read-write single value file which exists on non-root
+	cgroups.  The default is "0".
+
+	An integer number within the [-10000, 10000] range,
+	which defines the order in which the OOM killer selects victim
+	memory cgroups.
+
+	OOM killer prefers memory cgroups with larger priority if they
+	are populated with eligible tasks.
+
+	The oom_priority value is compared within sibling cgroups.
+
+	The root cgroup has the oom_priority 0, which cannot be changed.
+
   memory.events
 	A read-only flat-keyed file which exists on non-root cgroups.
 	The following entries are defined.  Unless specified
@@ -1206,6 +1235,39 @@ POSIX_FADV_DONTNEED to relinquish the ownership of memory areas
 belonging to the affected files to ensure correct memory ownership.
 
 
+OOM Killer
+~~~~~~~~~~~~~~~~~~~~~~~
+
+Cgroup v2 memory controller implements a cgroup-aware OOM killer.
+It means that it treats cgroups as first class OOM entities.
+
+Under OOM conditions the memory controller tries to make the best
+choice of a victim, hierarchically looking for the largest memory
+consumer. By default, it will look for the biggest task in the
+biggest leaf memory cgroup.
+
+By default, all memory cgroups have oom_priority 0, and OOM killer
+will choice the cgroup with the largest memory consuption recursively
+on each level. For non-root cgroups it's possible to change
+the oom_priority, and it will cause the OOM killer to look
+at the priority value first, and compare sizes only of memory
+cgroups with equal priority.
+
+A user can change this behavior by enabling the per-cgroup
+oom_kill_all_tasks option. If set, OOM killer will kill all processes
+attached to the cgroup if selected as an OOM victim.
+
+Tasks in the root cgroup are treated as independent memory consumers,
+and are compared with other memory consumers (leaf memory cgroups).
+The root cgroup doesn't support the oom_kill_all_tasks feature.
+
+This affects both system- and cgroup-wide OOMs. For a cgroup-wide OOM
+the memory controller considers only cgroups belonging to the sub-tree
+of the OOM'ing cgroup.
+
+If there are no cgroups with the enabled memory controller,
+the OOM killer is using the "traditional" process-based approach.
+
 IO
 --
 
-- 
2.13.5

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
