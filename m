From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup/cpuset: Fix wrong check in update_parent_subparts_cpumask()
Date: Tue, 31 Jan 2023 10:48:03 -0500
Message-ID: <20230131154803.192530-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675180091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jj+MngsoDFpfREm8kwbslfBpvRZkqzFwR4JCZm4vAvo=;
        b=K5SVmdrStxIOeJ63k/RLjyRQMp4nceXdYuE4vQnJQtlgSxsbQUHmHFvYl1NwDfqugw3hgo
        dpPxHgLYLfKbpaEcz2GEn1RiyHroMKBshGrf8gCS+lLkBF3+apJ8JchHyNvcEUcA9geiI/
        CDrhbxmy1sPG8XvUVTG3w6uo5bzGbNU=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Srinivas Pandruvada <srinivas.pandruvada-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

It was found that the check to see if a partition could use up all
the cpus from the parent cpuset in update_parent_subparts_cpumask()
was incorrect. As a result, it is possible to leave parent with no
effective cpu left even if there are tasks in the parent cpuset. This
can lead to system panic as reported in [1].

Fix this probem by updating the check to fail the enabling the partition
if parent's effective_cpus is a subset of the child's cpus_allowed.

Also record the error code when an error happens in update_prstate()
and add a test case where parent partition and child have the same cpu
list and parent has task. Enabling partition in the child will fail in
this case.

[1] https://www.spinics.net/lists/cgroups/msg36254.html

Fixes: f0af1bfc27b5 ("cgroup/cpuset: Relax constraints to partition & cpus changes")
Reported-by: Srinivas Pandruvada <srinivas.pandruvada-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c                            | 3 ++-
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index a29c0b13706b..205dc9edcaa9 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1346,7 +1346,7 @@ static int update_parent_subparts_cpumask(struct cpuset *cs, int cmd,
 		 * A parent can be left with no CPU as long as there is no
 		 * task directly associated with the parent partition.
 		 */
-		if (!cpumask_intersects(cs->cpus_allowed, parent->effective_cpus) &&
+		if (cpumask_subset(parent->effective_cpus, cs->cpus_allowed) &&
 		    partition_is_populated(parent, cs))
 			return PERR_NOCPUS;
 
@@ -2324,6 +2324,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		new_prs = -new_prs;
 	spin_lock_irq(&callback_lock);
 	cs->partition_root_state = new_prs;
+	WRITE_ONCE(cs->prs_err, err);
 	spin_unlock_irq(&callback_lock);
 	/*
 	 * Update child cpusets, if present.
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 186e1c26867e..75c100de90ff 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -268,6 +268,7 @@ TEST_MATRIX=(
 	# Taking away all CPUs from parent or itself if there are tasks
 	# will make the partition invalid.
 	"  S+ C2-3:P1:S+  C3:P1  .      .      T     C2-3    .      .     0 A1:2-3,A2:2-3 A1:P1,A2:P-1"
+	"  S+  C3:P1:S+    C3    .      .      T      P1     .      .     0 A1:3,A2:3 A1:P1,A2:P-1"
 	"  S+ $SETUP_A123_PARTITIONS    .    T:C2-3   .      .      .     0 A1:2-3,A2:2-3,A3:3 A1:P1,A2:P-1,A3:P-1"
 	"  S+ $SETUP_A123_PARTITIONS    . T:C2-3:C1-3 .      .      .     0 A1:1,A2:2,A3:3 A1:P1,A2:P1,A3:P1"
 
-- 
2.31.1

