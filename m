Received: from mta0.migadu.com (out-75.mta0.migadu.com [91.218.175.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5715325B091
	for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 02:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787536930; cv=none; b=S4y+hM70AkzWxSs6s4XgKnZtoXVOIgaQbsDth+ua2CqiLcBw+IxiSQdnhbYlKZmRzrj1YajELBkq60Lko3KZf0CwUJQMK+CFBXE1/3GoJ4adnEq9YyFzeKGceKAMCL8G5gqm4GPzqI2ZH/AvXQakDF3Bn3iUxZMkG+E57vAWPe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787536930; c=relaxed/simple;
	bh=zhkDTRg3fU16t0nSAOmBqRUjwq8Q7ubl21hlDlnXRhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnfmWhxbm+Nn1502M7KtD/8zMU2RxsU337/jpxvvKbuoOZpdDTSWeAFo9a5KXm6LpyJLeL9MMZU4VFbRdh98f/fvPvcR8H5VSBAN1ToOTQu+gZm8lKoDOHnZn5Neb27sNDpOtV2jtx8qVPOkj8Dn54riPSEOvCeU4rmsAURcCD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wy9gk+6Z; arc=none smtp.client-ip=91.218.175.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wy9gk+6Z"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=zhkDTRg3fU16t0nSAOmBqRUjwq8Q7ubl21hlDlnXRhU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787536926; v=1; x=1788141726;
 b=wy9gk+6ZHCcfVIMQnIji/a3hDz83MdJIldwUsIqrn9qQyD2oTH2AWnwKJ8o6Ai+rRu/F8OWU
 DxWCuhgMxCUUQWA7kZR3CXg8rOlW8el7rT3jUsXfCIY7CM3gmmHH2j7JOK8EFeE55wpQqD1BLup
 dVrlyyonKsTXo+kJqamneB2M=
X-Envelope-To: cgroups@vger.kernel.org
Received: from zgp.. (223.70.159.239)
	by smtp.migadu.com with ESMTPS id e17b4879cbf4d495;
	Mon, 24 Aug 2026 02:02:06 +0000
X-Mizu-Trace-ID: e17b4879cbf4d495
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH v2 2/3] cgroup/cpuset: Preserve boot-isolated CPUs on partition release
Date: Mon, 24 Aug 2026 10:01:39 +0800
Message-ID: <20260824020140.21130-3-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260824020140.21130-1-guopeng.zhang@linux.dev>
References: <20260824020140.21130-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

isolated_cpus tracks CPUs isolated with isolcpus= as well as CPUs in
isolated cpuset partitions. When an isolated partition is released,
isolated_cpus_update() removes its whole CPU mask. This also clears CPUs
which were already isolated at boot.

This can be reproduced on a cgroup v2 system booted with
isolcpus=domain,15:

    cd /sys/fs/cgroup
    echo +cpuset > cgroup.subtree_control
    mkdir cpuset-repro
    echo 15 > cpuset-repro/cpuset.cpus
    echo isolated > cpuset-repro/cpuset.cpus.partition
    echo member > cpuset-repro/cpuset.cpus.partition
    cat cpuset.cpus.isolated

CPU 15 is absent before the change. It must remain in
cpuset.cpus.isolated after the partition is released.

Update isolated_cpus one CPU at a time and keep CPUs outside the
boot-time domain housekeeping mask isolated.

Fixes: c188f33c864e ("cgroup/cpuset: Account for boot time isolated CPUs")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c | 39 +++++++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index d100634fa12b..2538faac9aba 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1259,6 +1259,28 @@ static void reset_partition_data(struct cpuset *cs)
 		cpumask_copy(cs->effective_cpus, parent->effective_cpus);
 }
 
+/* Return true if isolated_cpus changes. */
+static bool isolated_cpu_update(int new_prs, int cpu)
+{
+	lockdep_assert_held(&callback_lock);
+	lockdep_assert_held(&cpuset_mutex);
+
+	if (new_prs == PRS_ISOLATED) {
+		if (cpumask_test_cpu(cpu, isolated_cpus))
+			return false;
+		cpumask_set_cpu(cpu, isolated_cpus);
+		return true;
+	}
+
+	/* CPUs isolated at boot must remain isolated. */
+	if (!cpumask_test_cpu(cpu,
+			      housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)) ||
+	    !cpumask_test_cpu(cpu, isolated_cpus))
+		return false;
+	cpumask_clear_cpu(cpu, isolated_cpus);
+	return true;
+}
+
 /*
  * isolated_cpus_update - Update the isolated_cpus mask
  * @old_prs: old partition_root_state
@@ -1267,19 +1289,16 @@ static void reset_partition_data(struct cpuset *cs)
  */
 static void isolated_cpus_update(int old_prs, int new_prs, struct cpumask *xcpus)
 {
+	bool updated = false;
+	int cpu;
+
 	WARN_ON_ONCE(old_prs == new_prs);
 	lockdep_assert_held(&callback_lock);
 	lockdep_assert_held(&cpuset_mutex);
-	if (new_prs == PRS_ISOLATED) {
-		if (cpumask_subset(xcpus, isolated_cpus))
-			return;
-		cpumask_or(isolated_cpus, isolated_cpus, xcpus);
-	} else {
-		if (!cpumask_intersects(xcpus, isolated_cpus))
-			return;
-		cpumask_andnot(isolated_cpus, isolated_cpus, xcpus);
-	}
-	update_housekeeping = true;
+	for_each_cpu(cpu, xcpus)
+		updated |= isolated_cpu_update(new_prs, cpu);
+	if (updated)
+		update_housekeeping = true;
 }
 
 /*
-- 
2.43.0

