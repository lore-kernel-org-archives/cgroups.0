Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5D954147B
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 14:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791986799; cv=none; b=RJOKMe1VYOzTLOgO8jvUrDZancMvQ2rt6AKRnclkXtA9GHAVLvCf6uBp+53NOpTfDyelS4LEzVCDKjGqKRxwRlggRL3vdC7Kc0Hhf6VvURCDnqOCq6wMwrlGgwV8IrsUWyWRNtY3lZWD9ych+/LqHo21/9aYEvfLzq1ir/lvzt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791986799; c=relaxed/simple;
	bh=sLM+d/afnm9lvK0+kiSdP3q0DvNVsU3pkhnyYdTWfVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DFTr8a4fvsOvygrrW8r3OoUF4LC7QrKOTEF+HZP+SpglrKLW9wMhaCMcquLJALoxf2I1Y9dVtdR4cRTYG8ErMbar9+tHjPUd2OA1QwdPIeY5S7szhUcAngCjptWWbh8iGUNkUor9jh82M+SwSnw0hQ1sWvAgVgxpCGSy8nIR8vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BUF0eXj8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BUF0eXj8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791986789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QTzp8VnlCd8dfqsE91Djisu8typghT8lpYfIn2jEIjg=;
	b=BUF0eXj8HlzRhz8AtA/FRKLmTAC0Viryt6yQgbVW+ygz/dqH/rHa/EauZN76DznLlbRPDw
	G62UfroRYs3D3eMDediLFQdx1NuGbK1/NbDHQFXEuZqTyrnJY8o7rEmB3hS36BhTWE2NnX
	DSFvyjEJaD656B0pjUQE8kXwwNDQ0NE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-288-wBE7XJLZP5ClEggcvTou1w-1; Wed,
 14 Oct 2026 14:06:27 +0000
X-MC-Unique: wBE7XJLZP5ClEggcvTou1w-1
X-Mimecast-MFC-AGG-ID: wBE7XJLZP5ClEggcvTou1w_1791986785
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9908619560B6;
	Wed, 14 Oct 2026 14:06:25 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.rmtusnh.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9BE12418;
	Wed, 14 Oct 2026 14:06:23 +0000 (UTC)
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
Subject: [PATCH-next v3 8/9] selftests/cgroup: Add tests for nohz_full housekeeping check
Date: Wed, 14 Oct 2026 10:05:47 -0400
Message-ID: <20261014140548.575122-9-longman@redhat.com>
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

When a boot time nohz_full CPUs are present and they cover CPUs 0-7,
some of the test cases may fail.  So the test run will be skipped with
a warning message in this case. On the other hand, if the boot time
nohz_full CPUs cover all the CPUs except 0-7, a special set of nohz_full
specific housekeeping check related tests could be run to make sure the
housekeeping check are behaving properly. The test_cpuset_prs.sh test
script is now updated to do exactly that.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 .../selftests/cgroup/test_cpuset_prs.sh       | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 5aac0df86593..ea0ebbdf4bb3 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -84,6 +84,29 @@ echo member > test/cpuset.cpus.partition
 echo "" > test/cpuset.cpus
 [[ $RESULT -eq 0 ]] && skip_test "Child cgroups are using cpuset!"
 
+#
+# If nohz_full CPUs have been reserved at boot time, they should not include
+# CPUs 0-7 as that may fail some of the test cases. On the other hand if the
+# set of nohz_full CPUs includes all the CPUs except 0-7, we can run a special
+# set of housekeeping CPUs exhaustion tests to see if the cpuset code will
+# reject them.
+#
+NOHZ_FULL_CPUS=$(cat /sys/devices/system/cpu/nohz_full)
+FIRST_NOHZ_FULL_CPU=
+LAST_NOHZ_FULL_CPU=
+RUN_NOHZ_FULL_TESTS=
+LAST_PRESENT_CPU=$(cat /sys/devices/system/cpu/present | sed -e "s/.*[,-]//")
+[[ -n "$NOHZ_FULL_CPUS" ]] && {
+	FIRST_NOHZ_FULL_CPU=$(echo $NOHZ_FULL_CPUS | sed -e "s/[,-].*//")
+	LAST_NOHZ_FULL_CPU=$(echo $NOHZ_FULL_CPUS | sed -e "s/.*[,-]//")
+	echo "Boot nohz_full CPUs: $NOHZ_FULL_CPUS"
+}
+[[ -n "$FIRST_NOHZ_FULL_CPU" && "$FIRST_NOHZ_FULL_CPU" -le 7 ]] &&
+	skip_test "Boot NOHZ_FULL CPUs overlap CPUs to be tested!"
+
+[[ -n "$FIRST_NOHZ_FULL_CPU" && "$FIRST_NOHZ_FULL_CPU" = 8 &&
+   "$LAST_NOHZ_FULL_CPU" = $LAST_PRESENT_CPU ]] && RUN_NOHZ_FULL_TESTS=1
+
 #
 # If isolated CPUs have been reserved at boot time (as shown in
 # /sys/devices/system/cpu/isolated), these isolated CPUs should be outside of
@@ -497,6 +520,16 @@ ISOLCPUS_TEST_MATRIX=(
 	" CX1-2,I:X1,I:P1 . .      .     X1,2,I  .      .      .     0 A1:1-2,I|XA1:1-2,I A1:P-1 ."
 )
 
+# Test matrix to be run when boot time nohz_full CPUs cover all CPUs except CPUs 0-7
+NOHZ_FULL_TEST_MATRIX=(
+	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
+	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------
+	# Using all the nohz_full HK CPUs 0-7 in isolated partition is not allowed
+	" C0-7       .      .      .      P2     .      .      .     0 A1:0-7 A1:P-2 ."
+	" C1-7:P2 C5-7:P2   .      .       .     .      .    C0:P2   0 A1:1-4|A2:5-7|B1:0
+								       A1:P2|A2:P2|B1:P-2 1-7"
+)
+
 #
 # Cpuset controller remote partition test matrix.
 #
@@ -1362,6 +1395,7 @@ trap cleanup 0 2 3 6
 run_state_test TEST_MATRIX
 run_remote_state_test REMOTE_TEST_MATRIX
 TEST_ISOLCPUS=1 run_state_test ISOLCPUS_TEST_MATRIX
+[[ -n "$RUN_NOHZ_FULL_TESTS" ]] && run_state_test NOHZ_FULL_TEST_MATRIX
 test_isolated
 test_boot_isolated
 test_inotify
-- 
2.55.0

