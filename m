Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793776588;
	b=4uA20nMf1iMwJOyMDFns9MMN0bwL4iojigUdQpEeLKucfZz54iTiI51t84pYf/fO4Z82
	 kAmh5leAJCYlYCeH3GJqCrKRfY4V1V188npmVMliPFwosw2xZLD9FcV/LRx8xRRkecUU4
	 uvxhN+obcKK2E4nK/RYGwgovoqEwyRbU0kcow6iRNOrv6ex83XnH7Ie6MAuJAfE1a92DC
	 vUVJbkaZTkalkQD6AIMuhQL85nLmyHefa4z6JJ2ADECb5b7/6YqyZvtqDdvMRXfXo3dAV
	 lFd5eTT+fhcB8ZUS5nx/VSUF7uonrqenfHaNT/KeevJ/PlQnjMv5mztSIOB5unH6plw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793776588;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=sq8GeUPUbWD5/l9webTykYpDaibNcYX0trvCELNClDY=;
	b=SOkp6dBPY6PJEW1sliHRDRn/hWyMQHGsbmXx1eLXyixwPKxN7jBpVsPR9pZnPpvpY2/J
	 GpOE+4LYexC+i3hpI+OIa7PDVCNdXioPzvX2j+A3sj0JTRBtEDvMM3UKZVjakvSyVrKv7
	 ADs9NUfTKkf4i6xUFP3Hy0zOKXVQEDgLTk5bZ+rwExXdI9wJxK7qahoZrX3ruAAwHaQmv
	 Eybv0tqOm6sXDwFGDzU1DMhP4QST0Aix0RvsWEkXTt/2jnzj3ic5Vcd82ZXPeXWFBn6qm
	 VBSL9+/+J8sT1r0c8lpMiXa0mvso8Z0jTsRJMpdszOItrQ9VfVVy6VTD3fOkAvXdBwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ASCmtkw1;
	arc=none smtp.remote-ip=95.215.58.5
Received: from mta1.migadu.com (out-5.mta1.migadu.com [95.215.58.5])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B436606A332
	for <cgroups@vger.kernel.org>; Wed,  4 Nov 2026 07:16:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B436606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ASCmtkw1
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=0NMn6LfHJXdY0del5TIwB9PNJWC94DBmPcplZLgt9NE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793776580; v=1; x=1794381380;
 b=ASCmtkw1exsVpYkJRoJjNg4dJnicckKvkH2fYjpv1OQqOu28dB3sx5qYIMPS9Od72Sj5aPDW
 0odhTPBfbPSoRST5AEhwSeAbi1oKIVvxrhisrw7ubpXuFGH2B14F1FUpRjqPpyxyPSc0dT4x3jW
 IP3ZxRAwVye9NoljUFGR/4s4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3f4a2e5a750a33d9;
	Wed, 04 Nov 2026 07:16:20 +0000
X-Mizu-Trace-ID: 3f4a2e5a750a33d9
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: longman@redhat.com
Cc: ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH] cgroup/cpuset: Fail if isolated CPUs don't leave any boot domain housekeeping CPU
Date: Wed,  4 Nov 2026 15:16:00 +0800
Message-ID: <20261104071600.474587-1-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
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

With the "domain" flag of the isolcpus= boot option, the CPUs isolated
at boot are excluded from the sched domains and the remaining CPUs
become the boot domain housekeeping CPUs. An isolated partition is
allowed to use the boot isolated CPUs, but it must not take over all
the boot domain housekeeping CPUs.

prstate_housekeeping_conflict() checks that rule for root partitions
only. The 2nd check covers the nohz_full case as it is gated by
housekeeping_enabled(HK_TYPE_KERNEL_NOISE) which is not enabled by
isolcpus=domain. So on an isolcpus=domain,<cpus> boot, an isolated
partition can claim all the remaining boot domain housekeeping CPUs.
The state is committed, but the sched domain rebuild at the end of
the write finds no housekeeping CPU left for the boot domain and
hits WARNs and an OOPS in partition_sched_domains().
housekeeping_update() cannot accept the configuration either as it
cannot empty the boot domain housekeeping mask.
With an "isolcpus=domain,10-31" boot where CPUs 0-9 are the boot
domain housekeeping CPUs, for example:

  # echo 0-9 > A/cpuset.cpus
  # echo isolated > A/cpuset.cpus.partition
  WARNING: kernel/sched/topology.c:3089 at build_sched_domains+...
  WARNING: kernel/cgroup/cpuset.c:1478 at cpuset_update_sd_hk_unlock+...
  RIP: 0010:partition_sched_domains+0x3b8

Fix that by extending prstate_housekeeping_conflict() to reject an
isolated partition update that would leave no active boot domain
housekeeping CPU outside the isolated CPUs. The CPUs released back
to the boot domain by the same update are taken into account, so
replacing one of the last housekeeping CPUs with another one in a
single update remains allowed. The new check is only performed when
housekeeping_enabled(HK_TYPE_KERNEL_NOISE) is disabled so that the
existing nohz_full behavior is unchanged.

Add test cases in test_cpuset_prs.sh to verify that taking over all
the boot domain housekeeping CPUs is rejected while swapping one of
them with another one is allowed.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c                        | 36 +++++++++++++++++++
 .../selftests/cgroup/test_cpuset_prs.sh       | 30 ++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 6e136888fc8e..c1ed556ddb1a 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1403,6 +1403,42 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
 	if (del_cpus && cpumask_empty(del_cpus))
 		del_cpus = NULL;
 
+	/*
+	 * With boot time domain isolation (isolcpus= with the domain flag),
+	 * the CPUs that are not isolated at boot become the boot domain
+	 * housekeeping CPUs. An isolated partition must not take over all
+	 * of them. Otherwise housekeeping_update() will fail later when
+	 * the isolated CPUs are handed over, leaving the sched domains in
+	 * an inconsistent state. This case isn't covered by the 2nd check
+	 * below which requires nohz_full to be enabled.
+	 */
+	if (!housekeeping_enabled(HK_TYPE_KERNEL_NOISE) &&
+	    housekeeping_enabled(HK_TYPE_DOMAIN_BOOT) && (new_prs == PRS_ISOLATED)) {
+		cpumask_var_t boot_hk_cpus;
+
+		if (!alloc_cpumask_var(&boot_hk_cpus, GFP_KERNEL))
+			return true;
+
+		/*
+		 * Compute the isolated CPUs after this update: the CPUs
+		 * released by it (@del_cpus) leave the isolated set and
+		 * become available to the boot domain again, unless they
+		 * are returned to an isolated parent instead.
+		 */
+		if (del_cpus && parent_prs != PRS_ISOLATED)
+			cpumask_andnot(boot_hk_cpus, isolated_cpus, del_cpus);
+		else
+			cpumask_copy(boot_hk_cpus, isolated_cpus);
+		cpumask_andnot(boot_hk_cpus,
+			       housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT),
+			       boot_hk_cpus);
+		cpumask_andnot(boot_hk_cpus, boot_hk_cpus, new_cpus);
+		res = !cpumask_intersects(boot_hk_cpus, cpu_active_mask);
+		free_cpumask_var(boot_hk_cpus);
+		if (res)
+			return true;
+	}
+
 	/*
 	 * Exit 2nd check early and return false if
 	 * 1) there is no boot time isolated nohz_full CPU
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index bdca6c471f87..8c7af34b51c8 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -133,6 +133,17 @@ LAST_PRESENT_CPU=$(cat /sys/devices/system/cpu/present | sed -e "s/.*[,-]//")
 [[ -n "$FIRST_NOHZ_FULL_CPU" && "$FIRST_NOHZ_FULL_CPU" = 8 &&
    "$LAST_NOHZ_FULL_CPU" = $LAST_PRESENT_CPU ]] && RUN_NOHZ_FULL_TESTS=1
 
+# The isolcpus domain test matrix assumes that the boot domain
+# housekeeping CPUs are exactly 0-9, i.e. an
+# "isolcpus=domain,10-<last>" boot.
+RUN_ISOLCPUS_DOMAIN_TESTS=
+if grep -q "isolcpus=.*domain" /proc/cmdline 2>/dev/null &&
+	[[ -z "$(cat /sys/devices/system/cpu/nohz_full 2>/dev/null)" ]]
+then
+	[[ "$(cat /sys/devices/system/cpu/isolated)" = "10-$LAST_PRESENT_CPU" ]] &&
+		RUN_ISOLCPUS_DOMAIN_TESTS=1
+fi
+
 #
 # If isolated CPUs have been reserved at boot time (as shown in
 # /sys/devices/system/cpu/isolated), these isolated CPUs should be outside of
@@ -602,6 +613,24 @@ ISOLCPUS_TEST_MATRIX=(
 	" CX1-2,I:X1,I:P1 . .      .     X1,2,I  .      .      .     0 A1:1-2,I|XA1:1-2,I A1:P-1 ."
 )
 
+# Test matrix to be run when the system is booted with
+# "isolcpus=domain,10-<last>" so that CPUs 0-9 are the boot domain
+# housekeeping CPUs.
+ISOLCPUS_DOMAIN_TEST_MATRIX=(
+	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
+	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------
+	# Using all the boot domain housekeeping CPUs in an isolated
+	# partition is not allowed
+	" C0-9      .      .      .     P2      .      .      .     0 A1:0-9  A1:P-2  ."
+
+	# Replacing some of the boot domain housekeeping CPUs with other
+	# ones in a single update is allowed
+	" C2-9:P2   .      .      .    C0-4     .      .      .     0 A1:0-4  A1:P2   0-4"
+
+	# Taking over the last housekeeping CPU by an update is not allowed
+	" C0-8:P2   .      .      .    C0-9     .      .      .     0 A1:0-9  A1:P-2  ."
+)
+
 # Test matrix to be run when boot time nohz_full CPUs cover all CPUs except CPUs 0-7
 # This also means that CPU 8 is available and is a nohz_full CPU.
 NOHZ_FULL_TEST_MATRIX=(
@@ -1472,6 +1501,7 @@ test_inotify()
 run_state_test TEST_MATRIX
 run_remote_state_test REMOTE_TEST_MATRIX
 TEST_ISOLCPUS=1 run_state_test ISOLCPUS_TEST_MATRIX
+[[ -n "$RUN_ISOLCPUS_DOMAIN_TESTS" ]] && run_state_test ISOLCPUS_DOMAIN_TEST_MATRIX
 [[ -n "$RUN_NOHZ_FULL_TESTS" ]] && run_state_test NOHZ_FULL_TEST_MATRIX
 test_isolated
 test_boot_isolated
-- 
2.43.0

