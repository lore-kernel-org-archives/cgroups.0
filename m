Received: from mta1.migadu.com (out-32.mta1.migadu.com [95.215.58.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A46443E41
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 12:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787229750; cv=none; b=lIJDzhUfuVK7faRCVje1NfFtpaAriMD1jyW22fZ8y2D/S/XeuBQ/PNwMCScgZdUJm6qeF5sCF2MQWCHJOadPRLWglpGz9oGNZ0aMynqiNZzCsl5bwzUDBoeQR7NMo5vPs7CwO4KDXDAz09uBpX1WNxtNxUWLtjky5sPctmgPaUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787229750; c=relaxed/simple;
	bh=6gabYFqQnKZwQPnrvz21HfNVbdBxpKDdatlnF6ReL1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPv7x0ToyzsUeh6faXE4Vrwkbgf7ta+gh/A1kChJAwWdN9YsF+WabNBU3FNSwm1j6bvrVkaQs4Jy/LOAG56Jc093UeKb6E2TX1L6C4s5LztNbQFjahJw0pSxrZkKejaxntlGLga8ok5646CI9d4mhgFjpdaBlmFFkcF2Jlx/Rm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EtLDgSWU; arc=none smtp.client-ip=95.215.58.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EtLDgSWU"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=6gabYFqQnKZwQPnrvz21HfNVbdBxpKDdatlnF6ReL1Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787229746; v=1; x=1787834546;
 b=EtLDgSWU5/gfiwD7SSHeTgwOtbYZ1uKnOeiQSMIzViNJ9cM6T+3+GRVZ2eWFkIaENPHAXaWZ
 pr7XipiqRTpH1gIH4LH0e3b7YE5y+lAztjeCJhj7bTwVc0qohjkaUnB1OOV/tsK5pDiU4hsqHO1
 SqEOIyzXYcIzXLptBvEpiR5U=
X-Envelope-To: cgroups@vger.kernel.org
Received: from zgp.. (223.70.159.239)
	by smtp.migadu.com with ESMTPS id c14d578c93727d8e;
	Thu, 20 Aug 2026 12:42:26 +0000
X-Mizu-Trace-ID: c14d578c93727d8e
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: longman@redhat.com,
	cgroups@vger.kernel.org
Cc: ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH 02/17] cgroup/cpuset: Preserve boot-isolated CPUs on partition release
Date: Thu, 20 Aug 2026 20:41:47 +0800
Message-ID: <20260820124202.517160-3-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260820124202.517160-1-guopeng.zhang@linux.dev>
References: <20260820124202.517160-1-guopeng.zhang@linux.dev>
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

