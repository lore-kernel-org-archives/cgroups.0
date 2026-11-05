Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.152
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793883846;
	b=KdutWtM+dn/esfXV0rzvcB+8IJ4SVUmmlsXTK+HqOZP6GB3QG6DU85DSgNvQgQeA3LXF
	 kyJpfkZcUMxndIwxC7q5qWyuwY6HGPQGXv7Hbr4c1l2Rg87MBJS90DK7zod39S4gu5ckh
	 7mpStRQKHQxXtzetV3WTWbJhmVUYh/ZnsZ47mmQ6IsaNBq+1LbEvKeXgupFlC106iFjnF
	 NHE9nBtBo4/LAiR19OWRxhamEy6HiWSNXeEJlAEwobRoqNm44tb3XzK5A+Bm2PBHA7M+T
	 Fc410OmjQa0F8WIDIbhJgVQeI1H+4jGbjj8oZlEhVJ6ti7GjBbYUrviGjlefz/H36Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793883846;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=sgbLrcxTeylS2tTwYG+2EjZV3LVE3hY2nMCig9BEnS4=;
	b=Ub6WDOdmWMeeAiPcK4jFCyaPkrO/pPnDbxxrhcMK6dINFBEXynrTUw8xfBFCo1SxNPhY
	 yDUHs9CZ1t6wffikpA1gBDTSHLOF6WXQ7X8imZkv3oSqBHev8jNXM9vjwKa8NTEq4EHgV
	 72h/T0aofBDyG7QXGSVA0KyPZFwBwEIzgser8CU6NMZyUYlzPYLMey3nnuaomrV5SlA3y
	 kCzLuOyzm1BrCUPfS5ffVGEpOOrttVte2AG0bXHlyq0dSQpK03rVkRVpZGXegHRCCi0eW
	 tucfi297uKe73IZJidpeNb3VlheoH80UVVeE/gnJsc6UGkUBVb853L77wAK9pg/molA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=eA2pu2Vo;
	arc=none smtp.remote-ip=91.218.175.152
Received: from mta0.migadu.com (out-152.mta0.migadu.com [91.218.175.152])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE04606A329
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 13:04:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1CE04606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=eA2pu2Vo
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=cfaQSLQ9ELpJBlHf9ZZBFIOFhuynIrAaIwVD/PN2CW0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793883844; v=1; x=1794488644;
 b=eA2pu2VoNogwwMpgWMdkoj8ojz23aeiUTLkzHl78EVvFYGoY5lTRWZMgEBCVGz0iRK97sLPV
 c5MIzDBg+vhii4f+5WijPhA2TK4WEJDhAut3sdqST/SE1waNZJFRVRiPDlnROGEPFgRA7Qah2+y
 UHYlYfhITTnAV5U7psF380yo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id bf83dafda9bc04a5;
	Thu, 05 Nov 2026 13:04:04 +0000
X-Mizu-Trace-ID: bf83dafda9bc04a5
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: longman@redhat.com,
	tj@kernel.org,
	ridong.chen@linux.dev
Cc: guopeng.zhang@linux.dev,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH v2 1/3] cgroup/cpuset: Reject updates that empty the top sched domain
Date: Thu,  5 Nov 2026 21:03:42 +0800
Message-ID: <20261105130344.664336-2-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261105130344.664336-1-guopeng.zhang@linux.dev>
References: <20261105130344.664336-1-guopeng.zhang@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

Boot-isolated CPUs remain in top_cpuset.effective_cpus, but are excluded
from its scheduling domain by generate_sched_domains(). Checking only
effective_cpus when distributing CPUs to partitions can therefore allow
all boot domain housekeeping CPUs to be taken from the top cpuset.

The resulting empty domain triggers a warning in build_sched_domains()
and can cause an out-of-bounds CPU access in build_perf_domains(). Both
root and isolated partitions can trigger this, whether local or remote.
For example, on a 32-CPU system booted with isolcpus=domain,10-31:

  echo 0-9 > A/cpuset.cpus
  echo root > A/cpuset.cpus.partition
  Oops: general protection fault
  RIP: 0010:build_perf_domains+...

Require local and remote partition creation and CPU mask updates to
leave an active boot domain housekeeping CPU in the top cpuset,
accounting for CPUs returned by the same update.

Add test cases to test_cpuset_prs.sh to verify that every partition
update leaves an active boot domain housekeeping CPU in the top cpuset.

Fixes: 9b496a8bbed9 ("cgroup/cpuset: Prevent leakage of isolated CPUs into sched domains")
Co-developed-by: Ridong Chen <ridong.chen@linux.dev>
Signed-off-by: Ridong Chen <ridong.chen@linux.dev>
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c                        | 48 ++++++++++++++++++-
 .../selftests/cgroup/test_cpuset_prs.sh       | 47 ++++++++++++++++++
 2 files changed, 93 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3052413e41e7..c405719ccd12 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1180,12 +1180,56 @@ static void update_partition_sd_lb(struct cpuset *cs, int old_prs)
 		cpuset_force_rebuild();
 }
 
+/*
+ * top_cpuset_sd_nocpu - Check if top_cpuset will have no sched domain CPU
+ * @add_cpus: CPUs to be taken away from top_cpuset
+ * @del_cpus: CPUs to be given back to top_cpuset, can be NULL
+ * Return: true if no active CPU will be left in the top_cpuset sched domain
+ *
+ * Note that @del_cpus may include CPUs that are also in @add_cpus and
+ * will stay in the partition. They are skipped by the @add_cpus check,
+ * so callers can pass the current effective_xcpus of a partition
+ * without masking it first.
+ *
+ * Boot time isolated CPUs stay in top_cpuset.effective_cpus, but they are
+ * excluded from the sched domain of top_cpuset in generate_sched_domains().
+ * So checking top_cpuset.effective_cpus alone is not enough to ensure that
+ * the top_cpuset sched domain won't become empty after @add_cpus are taken
+ * away from it. The sched domain of top_cpuset must keep at least one
+ * active boot domain housekeeping CPU.
+ */
+static bool top_cpuset_sd_nocpu(const struct cpumask *add_cpus,
+				const struct cpumask *del_cpus)
+{
+	const struct cpumask *hk_mask = housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT);
+	int cpu;
+
+	for_each_cpu_and(cpu, hk_mask, cpu_active_mask) {
+		if (cpumask_test_cpu(cpu, add_cpus))
+			continue;
+		if (cpumask_test_cpu(cpu, top_cpuset.effective_cpus) ||
+		    (del_cpus && cpumask_test_cpu(cpu, del_cpus)))
+			return false;
+	}
+	return true;
+}
+
 /*
  * tasks_nocpu_error - Return true if tasks will have no effective_cpus
  */
 static bool tasks_nocpu_error(struct cpuset *parent, struct cpuset *cs,
 			      struct cpumask *xcpus)
 {
+	/*
+	 * The top_cpuset always has tasks (kthreads at least), so its sched
+	 * domain can't be empty. The current effective_xcpus of a valid
+	 * partition will be given back to top_cpuset if not in @xcpus.
+	 */
+	if (parent == &top_cpuset &&
+	    top_cpuset_sd_nocpu(xcpus, is_partition_valid(cs)
+				     ? cs->effective_xcpus : NULL))
+		return true;
+
 	/*
 	 * A populated partition (cs or parent) can't have empty effective_cpus
 	 */
@@ -1724,7 +1768,7 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
 	 */
 	compute_excpus(cs, tmp->new_cpus);
 	if (!cpumask_intersects(tmp->new_cpus, cpu_active_mask) ||
-	    cpumask_subset(top_cpuset.effective_cpus, tmp->new_cpus))
+	    top_cpuset_sd_nocpu(tmp->new_cpus, NULL))
 		return PERR_INVCPUS;
 	if (cpumask_intersects(tmp->new_cpus, subpartitions_cpus))
 		return PERR_NOCPUS;
@@ -1828,7 +1872,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 		if (!capable(CAP_SYS_ADMIN))
 			WRITE_ONCE(cs->prs_err, PERR_ACCESS);
 		else if (cpumask_intersects(tmp->addmask, subpartitions_cpus) ||
-			 cpumask_subset(top_cpuset.effective_cpus, tmp->addmask))
+			 top_cpuset_sd_nocpu(tmp->addmask, tmp->delmask))
 			WRITE_ONCE(cs->prs_err, PERR_NOCPUS);
 		else if (prstate_housekeeping_conflict(prs, PRS_ROOT,
 						       excpus, tmp->delmask))
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index bdca6c471f87..e813ea9959f4 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -133,6 +133,15 @@ LAST_PRESENT_CPU=$(cat /sys/devices/system/cpu/present | sed -e "s/.*[,-]//")
 [[ -n "$FIRST_NOHZ_FULL_CPU" && "$FIRST_NOHZ_FULL_CPU" = 8 &&
    "$LAST_NOHZ_FULL_CPU" = $LAST_PRESENT_CPU ]] && RUN_NOHZ_FULL_TESTS=1
 
+# These tests require boot domain housekeeping CPUs to be exactly 0-9.
+# Check the actual masks to cover isolcpus= with or without explicit flags.
+DOMAIN_ISOLCPUS="10-$LAST_PRESENT_CPU"
+[[ "$LAST_PRESENT_CPU" = 10 ]] && DOMAIN_ISOLCPUS=10
+RUN_ISOLCPUS_DOMAIN_TESTS=
+[[ -z "$NOHZ_FULL_CPUS" &&
+	"$(cat /sys/devices/system/cpu/isolated)" = "$DOMAIN_ISOLCPUS" ]] &&
+	RUN_ISOLCPUS_DOMAIN_TESTS=1
+
 #
 # If isolated CPUs have been reserved at boot time (as shown in
 # /sys/devices/system/cpu/isolated), these isolated CPUs should be outside of
@@ -602,6 +611,43 @@ ISOLCPUS_TEST_MATRIX=(
 	" CX1-2,I:X1,I:P1 . .      .     X1,2,I  .      .      .     0 A1:1-2,I|XA1:1-2,I A1:P-1 ."
 )
 
+# Test matrix for isolcpus=domain,10-<last> or isolcpus=10-<last> boots.
+# The top cpuset must retain an active boot domain housekeeping CPU.
+ISOLCPUS_DOMAIN_TEST_MATRIX=(
+	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
+	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------
+	# Neither a root nor an isolated partition may take all boot HK CPUs.
+	" C0-9      .      .      .     P1      .      .      .     0 A1:0-9 A1:P-1 ."
+	" C0-9      .      .      .     P2      .      .      .     0 A1:0-9 A1:P-2 ."
+
+	# Growing cpuset.cpus must not take the last top-level HK CPU.
+	" C0-8:P1   .      .      .    C0-9     .      .      .     0 A1:0-9 A1:P-1 ."
+
+	# CPUs returned by the same update can keep the top sched domain alive.
+	" C2-9:P2   .      .      .    C0-4     .      .      .     0 A1:0-4 A1:P2 0-4"
+
+	# Root and isolated partitions together must leave a top-level HK CPU.
+	" C0-4:P1   .      .     C5-9    .      .      .     P2    0 A1:0-4|B1:5-9 A1:P1|B1:P-2 ."
+
+	# Remote partition creation must enforce the same constraint.
+	" X0-9    CX0-9    .      .      .     P1      .      .     0 A2:0-9 A2:P-1 ."
+
+	# Growing a remote partition through cpuset.cpus.exclusive is rejected.
+	" X0-9 C0-9:X0-8:P1 .     .      .    X0-9     .      .     0 A2:0-9 A2:P-1 ."
+
+	# Remote CPU replacements must account for the CPUs being returned.
+	" X0-9 C0-9:X2-9:P2 .     .      .    X0-4     .      .     0 A2:0-4 A2:P2 0-4"
+
+	# Local exclusive CPU updates must not consume the last top-level HK CPU.
+	" C0-9:X0-8:P2 .   .      .    X0-9     .      .      .     0 A1:0-9 A1:P-2 ."
+
+	# Ancestor updates must not grow a remote partition over the last HK CPU.
+	" X0-8 CX0-9:P1    .      .    X0-9     .      .      .     0 A2:0-9 A2:P-1 ."
+
+	# An invalid partition can recover once it leaves a top-level HK CPU.
+	" C0-9:P1   .      .      .    C0-8     .      .      .     0 A1:0-8 A1:P1 ."
+)
+
 # Test matrix to be run when boot time nohz_full CPUs cover all CPUs except CPUs 0-7
 # This also means that CPU 8 is available and is a nohz_full CPU.
 NOHZ_FULL_TEST_MATRIX=(
@@ -1472,6 +1518,7 @@ test_inotify()
 run_state_test TEST_MATRIX
 run_remote_state_test REMOTE_TEST_MATRIX
 TEST_ISOLCPUS=1 run_state_test ISOLCPUS_TEST_MATRIX
+[[ -n "$RUN_ISOLCPUS_DOMAIN_TESTS" ]] && run_state_test ISOLCPUS_DOMAIN_TEST_MATRIX
 [[ -n "$RUN_NOHZ_FULL_TESTS" ]] && run_state_test NOHZ_FULL_TEST_MATRIX
 test_isolated
 test_boot_isolated
-- 
2.43.0

