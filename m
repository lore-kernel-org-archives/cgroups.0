From: Waiman Long <longman@redhat.com>
Subject: [PATCH v12 07/10] cgroup/cpuset: Relocate a code block in validate_change()
Date: Thu,  1 Sep 2022 16:57:42 -0400
Message-ID: <20220901205745.323326-8-longman@redhat.com>
References: <20220901205745.323326-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662065904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yjsoi9jMIhi4zCKfFUwtWjEtMVRAwWq9W9IHBrQtpuI=;
        b=QZQfM2J6FPuYHgUQAC7kjCf2UScmNF2Y9m0Pfmshu9umEttd7oWjapKPosJpnKAUMzOBqS
        P6rgQUT8G1ouw2jld3kaT1RUtVL+UHzdaSxbXZVnbbiIVMqyt86HB4L0llMWitnQSJHjyf
        VOErfn9a83NjQd5PKyznVWM+rXsgxt0=
In-Reply-To: <20220901205745.323326-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Waiman Long <longman@redhat.com>

This patch moves down the exclusive cpu and memory check in
validate_change(). There is no functional change.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 15fcd2f86108..b0d921d03f62 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -741,22 +741,6 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 
 	par = parent_cs(cur);
 
-	/*
-	 * If either I or some sibling (!= me) is exclusive, we can't
-	 * overlap
-	 */
-	ret = -EINVAL;
-	cpuset_for_each_child(c, css, par) {
-		if ((is_cpu_exclusive(trial) || is_cpu_exclusive(c)) &&
-		    c != cur &&
-		    cpumask_intersects(trial->cpus_allowed, c->cpus_allowed))
-			goto out;
-		if ((is_mem_exclusive(trial) || is_mem_exclusive(c)) &&
-		    c != cur &&
-		    nodes_intersects(trial->mems_allowed, c->mems_allowed))
-			goto out;
-	}
-
 	/*
 	 * Cpusets with tasks - existing or newly being attached - can't
 	 * be changed to have empty cpus_allowed or mems_allowed.
@@ -781,6 +765,22 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 				       trial->cpus_allowed))
 		goto out;
 
+	/*
+	 * If either I or some sibling (!= me) is exclusive, we can't
+	 * overlap
+	 */
+	ret = -EINVAL;
+	cpuset_for_each_child(c, css, par) {
+		if ((is_cpu_exclusive(trial) || is_cpu_exclusive(c)) &&
+		    c != cur &&
+		    cpumask_intersects(trial->cpus_allowed, c->cpus_allowed))
+			goto out;
+		if ((is_mem_exclusive(trial) || is_mem_exclusive(c)) &&
+		    c != cur &&
+		    nodes_intersects(trial->mems_allowed, c->mems_allowed))
+			goto out;
+	}
+
 	ret = 0;
 out:
 	rcu_read_unlock();
-- 
2.31.1

