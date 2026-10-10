Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43338399368
	for <cgroups@vger.kernel.org>; Sat, 10 Oct 2026 08:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791620979; cv=none; b=D2+H8c6h6JWMKG07j+LhuWIpgVKJNTaQq0mgGzB1VLwYatkOYU+WgBYJ33GDf5cr7jrY46YTtRCzTGKdafJ4NgqVoN1vWk3O684m8TBD61v1hEfkFUWBDrEisOJjLEkS4fMUpwc07nSzhmO1cR7d7DohyPeMLQ25Jvc46ffmMH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791620979; c=relaxed/simple;
	bh=wemRMvJXRsdXJg0zK7hzUz8eslL4RJfnRzpPkRCJHHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaETI/nqQfc6GGIHLW3pdKwQk8gQImuMFqmUyc4UMnTpQ+VM+XSJg3VCwcco+Ax1GXa6o36km4ZpF6OTO+hSrKMu2vJa/VPI9K3C5PzVtuEAhDUX+C/aWYl5sKAVgOOU6SVEFit55NF1gwRsIMVEwF0TpA/ZQgxQxTEhBfhQ5fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zm1g2Lhx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zm1g2Lhx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791620977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wi0PyvptVAB6sZgcYrYRmOEGvWnEz/WqGXB3++Gy8Y4=;
	b=Zm1g2Lhxruc6TkYkWCdlHRK8MY7wiMwTbgrKXom+6IJ8Wo2lyfwk0U8LvThEtfY6V09Ryq
	kFzMIZtcQy8LkNOXqdkkgQsJDUZt8W+dUzik5fOF1LDQe0yoqcBIXBLKekYF9hL/nBbCHz
	0r3FOe+pWqgrs89w4I+q1eJNHKFUMPY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-503-lX7RDpmGPEWvdV1JSmP7Yw-1; Sat,
 10 Oct 2026 08:29:35 +0000
X-MC-Unique: lX7RDpmGPEWvdV1JSmP7Yw-1
X-Mimecast-MFC-AGG-ID: lX7RDpmGPEWvdV1JSmP7Yw_1791620973
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E35719560AD;
	Sat, 10 Oct 2026 08:29:33 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C4B68180034F;
	Sat, 10 Oct 2026 08:29:30 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Hui Peng <benquike@gmail.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH-next 5/5] selftests/cgroup: Add tests for housekeeping check
Date: Sat, 10 Oct 2026 04:28:48 -0400
Message-ID: <20261010082848.193182-6-longman@redhat.com>
In-Reply-To: <20261010082848.193182-1-longman@redhat.com>
References: <20261010082848.193182-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Whenever a partition is enabled or the cpumask of a valid partition
changes, a housekeeping check will be performed to ensure that the
change won't violate the imposed housekeeping constraints. One of the
constraints is that a boot-time isolated CPU will not be used to form
a non-isolated root partition.  This requires the presence of boot-time
isolated CPUs when a test is run.

The test_cpuset_prs.sh test script is now updated to run a set a
special housekeeping check tests that will only be run if a suitable
boot-time isolated CPU is present. This will enable us to detect bugs
or regressions in the housekeeping checking code though a "isolcpus="
boot parameter with CPUs beyond CPU 8 must be present.

Adding test to check for exhaustion of all the housekeeping CPUs is
much harder and so will not be attempted at this time.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 .../selftests/cgroup/test_cpuset_prs.sh       | 105 ++++++++++++++----
 1 file changed, 85 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 7efd5e645767..6cfe90b09107 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -86,26 +86,37 @@ echo "" > test/cpuset.cpus
 
 #
 # If isolated CPUs have been reserved at boot time (as shown in
-# cpuset.cpus.isolated), these isolated CPUs should be outside of CPUs 0-8
-# that will be used by this script for testing purpose. If not, some of
-# the tests may fail incorrectly. Wait a bit and retry again just in case
-# these isolated CPUs are leftover from previous run and have just been
-# cleaned up earlier in this script.
+# /sys/devices/system/cpu/isolated), these isolated CPUs should be outside of
+# CPUs 0-8 that will be used by this script for testing purpose. If not, some
+# of the tests may fail incorrectly.
 #
-# These pre-isolated CPUs should stay in an isolated state throughout the
+# The current set of isolated CPUs (as shown in cpuset.cpus.isolated) should
+# be the same as the boot value. If not, wait a bit and retry again just in
+# case these isolated CPUs are leftover from previous run and have just been
+# cleaned up earlier in this script. If they still don't match, we report an
+# warning and skip the test.
+#
+# These boot isolated CPUs should stay in an isolated state throughout the
 # testing process for now.
 #
-BOOT_ISOLCPUS=$(cat $CGROUP2/cpuset.cpus.isolated)
+BOOT_ISOLCPUS=$(cat /sys/devices/system/cpu/isolated)
+CURRENT_ISOLCPUS=$(cat $CGROUP2/cpuset.cpus.isolated)
+FIRST_ISOLCPUS=
+TEST_ISOLCPUS=
+
 [[ -n "$BOOT_ISOLCPUS" ]] && {
+	FIRST_ISOLCPUS=$(echo $BOOT_ISOLCPUS | sed -e "s/[,-].*//")
+	[[ $FIRST_ISOLCPUS -le 8 ]] &&
+		skip_test "Boot-isolated CPUs ($BOOT_ISOLCPUS) overlap CPUs to be tested"
+	echo "Boot-isolated CPUs: $BOOT_ISOLCPUS"
+}
+
+[[ "$BOOT_ISOLCPUS" != "$CURRENT_ISOLCPUS" ]] && {
 	sleep 0.5
-	BOOT_ISOLCPUS=$(cat $CGROUP2/cpuset.cpus.isolated)
+	CURRENT_ISOLCPUS=$(cat $CGROUP2/cpuset.cpus.isolated)
+	[[ "$BOOT_ISOLCPUS" != "$CURRENT_ISOLCPUS" ]] &&
+		skip_test "Current isolated CPUs ($CURRENT_ISOLCPUS) don't match boot isolated CPUs!"
 }
-if [[ -n "$BOOT_ISOLCPUS" ]]
-then
-	[[ $(echo $BOOT_ISOLCPUS | sed -e "s/[,-].*//") -le 8 ]] &&
-		skip_test "Pre-isolated CPUs ($BOOT_ISOLCPUS) overlap CPUs to be tested"
-	echo "Pre-isolated CPUs: $BOOT_ISOLCPUS"
-fi
 
 cleanup()
 {
@@ -202,7 +213,7 @@ test_add_proc()
 #
 # ECPUs    - effective CPUs of cpusets
 # Pstate   - partition root state
-# ISOLCPUS - isolated CPUs (<icpus>[,<icpus2>])
+# ISOLCPUS - isolated CPUs (<icpus>[,<icpus2>] or .)
 #
 # Note that if there are 2 fields in ISOLCPUS, the first one is for
 # sched-debug matching which includes offline CPUs and single-CPU partitions
@@ -444,6 +455,35 @@ TEST_MATRIX=(
 	"   C0-3     .      .    C4-5   X3-5     .      .      .     1 A1:0-3|B1:4-5"
 )
 
+# Test matrix with boot time isolated CPUs present for housekeeping check testing
+ISOLCPUS_TEST_MATRIX=(
+	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
+	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------
+	# A local isolated partition containing boot isolated CPU cannot be
+	# switched to root partition.
+	" C1-2,I:P2  .      .      .      P1     .      .      .     0 A1:1-2,I A1:P-1 ."
+
+	# A remote isolated partition containing boot isolated CPU cannot be
+	# switched to root partition.
+	" X1-2,I CX1-2,I:P2 .      .       .    P1      .      .     0 A2:1-2,I A2:P-1 ."
+
+	# A local isolated partition with a boot isolated CPU distributed to a
+	# child isolated partition also cannot be switched to a root partition.
+	" C1-3,I:P2 C1,I:P2 .      .      P1     .      .      .     0 A1:1-3,I|A2:1,I A1:P-1|A2:P-2 ."
+
+	# A remote isolated partition with a boot isolated CPU distributed to a
+	# child isolated partition also cannot be switched to a root partition.
+	" X1-3,I C1-3,I:P2 C1,I:P2 .       .    P1      .      .     0 A2:1-3,I|A3:1,I A2:P-1|A3:P-2 ."
+
+	# The cpumask of a local root partition cannot be changed to include a
+	# boot isolated CPU.
+	" C1-2:P1    .      .      .     C2,I    .      .      .     0 A1:2,I A1:P-1 ."
+
+	# The cpumask of a remote root partition cannot be changed to include a
+	# boot isolated CPU.
+	" CX1-2,I  CX1-2:P1 .      .       .   CX2,I    .      .     0 A1:1-2,I|A2:2,I A2:P-1 ."
+)
+
 #
 # Cpuset controller remote partition test matrix.
 #
@@ -541,6 +581,27 @@ write_cpu_online()
 	pause 0.05
 }
 
+#
+# Set the CPUS values
+#  $1 - the passed in cpu parameter
+#
+# The special ",I" suffix if present is being replaced by the first boot CPU
+# and assigned to the "CPUS" variable when the TEST_ISOLCPUS flag is set.
+# If not, the program will exit with an error.
+#
+set_cpus()
+{
+	local cpus=$1
+	if [[ $(expr "$cpus" : .*,I) -gt 0 ]]
+	then
+		[[ -z "$TEST_ISOLCPUS" ]] &&
+			skip_test "',I' added to non-isolcpus testing matrix!"
+		CPUS=$(echo $cpus | sed -e "s/,I/,$FIRST_ISOLCPUS/")
+	else
+		CPUS=$cpus
+	fi
+}
+
 #
 # Set controller state
 #  $1 - cgroup directory
@@ -575,16 +636,16 @@ set_ctrl_state()
 		}
 		case $CMD in
 		    X*)
-			CPUS=${CMD#?}
+			set_cpus ${CMD#?}
 			COMM="echo $CPUS > $XFILE"
 			eval $COMM $REDIRECT
 			;;
 		    CX*)
-			CPUS=${CMD#??}
+			set_cpus ${CMD#??}
 			COMM="echo $CPUS > $CFILE; echo $CPUS > $XFILE"
 			eval $COMM $REDIRECT
 			;;
-		    C*) CPUS=${CMD#?}
+		    C*) set_cpus ${CMD#?}
 			COMM="echo $CPUS > $CFILE"
 			eval $COMM $REDIRECT
 			;;
@@ -978,8 +1039,11 @@ run_state_test()
 	I=0
 	eval CNT="\${#$TEST[@]}"
 
+	# Skip isolcpus specific test matrix if FIRST_ISOLCPUS not defined
+	[[ -n "$TEST_ISOLCPUS" && -z "$FIRST_ISOLCPUS" ]] && return
+
 	reset_cgroup_states
-	console_msg "Running state transition test ..."
+	console_msg "Running state transition test for $TEST ..."
 
 	while [[ $I -lt $CNT ]]
 	do
@@ -998,7 +1062,7 @@ run_state_test()
 		NEW_A3=$7
 		NEW_B1=$8
 		RESULT=$9
-		ECPUS=${10}
+		ECPUS=$(echo ${10} | sed -e "s/,I/,${FIRST_ISOLCPUS}/g")
 		STATES=${11}
 		ICPUS=${12}
 
@@ -1284,6 +1348,7 @@ test_inotify()
 trap cleanup 0 2 3 6
 run_state_test TEST_MATRIX
 run_remote_state_test REMOTE_TEST_MATRIX
+TEST_ISOLCPUS=1 run_state_test ISOLCPUS_TEST_MATRIX
 test_isolated
 test_boot_isolated
 test_inotify
-- 
2.55.0

