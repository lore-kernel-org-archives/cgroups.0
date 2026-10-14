Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38583541478
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 14:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791986795; cv=none; b=dbtSgZEcdBH4Lu9rajoGBQfmIQNBkn/Yf9aA1VtQMc/PpTo28ZKxLvZmWjh/gourNQ4oavYAwb9bmGewupFkoZfpQ0g5uCLJ05hQoW5rNjMwD4nuIqXqE1Bq8jhx1Lym9cZgLYWINHWOyI/ygVctE3IvkBzwUWjbdFTqXG2dl0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791986795; c=relaxed/simple;
	bh=LujFeEFHTlf8r4xtThYtsf09EiQBw8KWvKyt7TX32pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unB8j9hqYfGn53LgFK5Ebsj5wkHWZaCshmadJdz31xZSuRg5i7Nydh9tMRd6lBw1orTkaoiCHJDVIBAIXYPM3r6bavJT98Tx9k08n462l2CHpV8ub6DFik5z6xO4y4SNkTbsOXQyy7+hDHSqf3jbfsQU/MQcc1do4fBp63ovyE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IvDbb0Np; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IvDbb0Np"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791986789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hrZAE//JZ9CGtwCWdm+Bf3yq42GOp1UifGGCYSiPHgA=;
	b=IvDbb0NpB6xYW9DezUY2Qwu7DpFsGEpmp4VTglodlSEkr2DnvI1kEztSVjyfvMjhw8v344
	r7CBcyUrAYFUCZWJYNtf0qHetm5pPahrSytKiB5M406LMlsk4MhBiEI05aHEteYN+nqoWZ
	Dy4LMH8N1zFZXE+lmLx7qh8+8RvFSVc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-417-UklYtfWNN0aE0IJFyRAuNA-1; Wed,
 14 Oct 2026 14:06:25 +0000
X-MC-Unique: UklYtfWNN0aE0IJFyRAuNA-1
X-Mimecast-MFC-AGG-ID: UklYtfWNN0aE0IJFyRAuNA_1791986783
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 661181800656;
	Wed, 14 Oct 2026 14:06:23 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.rmtusnh.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DF47A418;
	Wed, 14 Oct 2026 14:06:20 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>
Cc: cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Hui Peng <benquike@gmail.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH-next v3 7/9] selftests/cgroup: Add tests for isolcpus housekeeping check
Date: Wed, 14 Oct 2026 10:05:46 -0400
Message-ID: <20261014140548.575122-8-longman@redhat.com>
In-Reply-To: <20261014140548.575122-1-longman@redhat.com>
References: <20261014140548.575122-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Whenever a partition is enabled or the cpumask of a valid partition
changes, a housekeeping check will be performed to ensure that the
change won't violate the imposed housekeeping constraints. One of the
constraints is that a boot-time isolated CPU will not be used to form
a non-isolated root partition. This requires the presence of boot-time
isolated CPUs when a test is run.

The test_cpuset_prs.sh test script is now updated to run a set a
special housekeeping check tests that will only be run if a suitable
boot-time isolated CPU is present. This will enable us to detect bugs
or regressions in the housekeeping checking code though a "isolcpus="
boot parameter with CPUs beyond CPU 8 must be present.

This patch also includes a minor fix to the REMOTE_TEST_MATRIX to avoid
test failure when the -v option is used.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 .../selftests/cgroup/test_cpuset_prs.sh       | 120 ++++++++++++++----
 1 file changed, 98 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 85a4f87840b4..5aac0df86593 100755
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
+	echo "Boot isolated CPUs: $BOOT_ISOLCPUS"
+	[[ $FIRST_ISOLCPUS -le 8 ]] &&
+		skip_test "Boot isolated CPUs overlap CPUs to be tested"
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
@@ -446,6 +457,46 @@ TEST_MATRIX=(
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
+
+	# Passing an boot isolated CPU down to a child root partition will invalidate it
+	" C2-3,I:X2-3 CX2-3,I .    .       .    P1      .      .     0 A1:I|A2:2-3 A2:P1 ."
+	" C2-3,I:X2-3 CX2-3,I:P1 . .     X2-3,I  .      .      .     0 A1:2-3,I|A2:2-3,I A2:P-1 ."
+
+	# An invalidated root partition must stay invalid when cpus grows but
+	# effective xcpus still contains a boot isolated CPU.
+	" CX1,I:P1   .      .      .     C1,2,I  .      .      .     0 A1:1-2,I|XA1:1,I A1:P-1 ."
+
+	# Growing cpus.exclusive must not revive it either
+	" CX1-2,I:X1,I:P1 . .      .     X1,2,I  .      .      .     0 A1:1-2,I|XA1:1-2,I A1:P-1 ."
+)
+
 #
 # Cpuset controller remote partition test matrix.
 #
@@ -498,8 +549,8 @@ REMOTE_TEST_MATRIX=(
 							 p1:P1|c11:P1|c12:P-1"
 	# Narrowing cpuset.cpus to previously sibling-excluded CPUs should
 	# not return CPUs that were never actually owned.
-	"  C1-4:P1   .   C1-2:P1  C1-3:P2  .       .  \
-	      .      .     .       C3      .       .     p1:4|c11:1-2|c12:3 \
+	"  C1-5:P1   .   C1-2:P1  C1-3:P2  .       .  \
+	      .      .     .       C3      .       .     p1:4-5|c11:1-2|c12:3 \
 							 p1:P1|c11:P1|c12:P2 3"
 	# Expanding cpuset.cpus to include a previously sibling-excluded CPU
 	# after the sibling has become a member should correctly request it.
@@ -543,6 +594,27 @@ write_cpu_online()
 	pause 0.05
 }
 
+#
+# Set the CPUS variable
+#  $1 - the passed in cpu parameter
+#
+# The special "I" CPU if present is being replaced by the first boot CPU
+# and assigned to the "CPUS" variable when the TEST_ISOLCPUS flag is set.
+# If not, the program will exit with an error.
+#
+set_cpus()
+{
+	local cpus=$1
+	if [[ $(expr "$cpus" : ".*I") -gt 0 ]]
+	then
+		[[ -z "$TEST_ISOLCPUS" ]] &&
+			skip_test "Special 'I' CPU added to non-isolcpus testing matrix!"
+		CPUS=$(echo $cpus | sed -e "s/I/$FIRST_ISOLCPUS/")
+	else
+		CPUS=$cpus
+	fi
+}
+
 #
 # Set controller state
 #  $1 - cgroup directory
@@ -577,16 +649,16 @@ set_ctrl_state()
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
@@ -980,8 +1052,11 @@ run_state_test()
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
@@ -1000,7 +1075,7 @@ run_state_test()
 		NEW_A3=$7
 		NEW_B1=$8
 		RESULT=$9
-		ECPUS=${10}
+		ECPUS=$(echo ${10} | sed -e "s/I/${FIRST_ISOLCPUS}/g")
 		STATES=${11}
 		ICPUS=${12}
 
@@ -1286,6 +1361,7 @@ test_inotify()
 trap cleanup 0 2 3 6
 run_state_test TEST_MATRIX
 run_remote_state_test REMOTE_TEST_MATRIX
+TEST_ISOLCPUS=1 run_state_test ISOLCPUS_TEST_MATRIX
 test_isolated
 test_boot_isolated
 test_inotify
-- 
2.55.0

