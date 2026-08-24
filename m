Received: from mta0.migadu.com (out-66.mta0.migadu.com [91.218.175.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4771D5160
	for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 02:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787536924; cv=none; b=MwPxQJUoTIUWpRysJ7iYb8H7RM+dxe3Dsndy0bc452jTJyMc1YC1qumgiqqxYRYTcgcQ7BlIrRaRTSu/55V9e9alyTq0Hzbl/vW2QtAl/kLrtRiaE6ETIiBOhwAohc4oc2BaemDPtQZ2wCaXrBoTSALQEhCoDOY3uI3xXMCD1Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787536924; c=relaxed/simple;
	bh=oPU623iWilh9XaksB9VuYgRSYCtbcJaJP8c1AFVWnYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKHOJgI3KZfu3SS31Mu1c53BrpnbvIYZbnBO1D/mzE3+J0sCEg+P6mX9KFL61QfTMLmxLnq1FlrIEf0ko3mjAOZnii/lNSflPXMOnPHZ1n5qeVV907a4mGG3EpL5ykAZwYZKAgazfPgbxJboszOSiMosCY4GIOYf5HAl5+8YFFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=m3WGmHuu; arc=none smtp.client-ip=91.218.175.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="m3WGmHuu"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=oPU623iWilh9XaksB9VuYgRSYCtbcJaJP8c1AFVWnYY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787536921; v=1; x=1788141721;
 b=m3WGmHuuFsqCKGrefPnLWg0hXhNte/Er7JNc9GhSux3ijWoDr8xitSu75HHfaqLbIlW9i+UP
 4knGG2HBvVNyhAERSjeT/HViZV95U3tkNzk5ENp27HvcX7FzMboH5qQZPJT8hQjAt2fQl/Hc+Bt
 po85d0COwaWTPTbjFZsXzDgE=
X-Envelope-To: cgroups@vger.kernel.org
Received: from zgp.. (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 5ca004a53aa70452;
	Mon, 24 Aug 2026 02:02:00 +0000
X-Mizu-Trace-ID: 5ca004a53aa70452
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
Subject: [PATCH v2 1/3] selftests/cgroup: Drop invalid boot isolation comparison
Date: Mon, 24 Aug 2026 10:01:38 +0800
Message-ID: <20260824020140.21130-2-guopeng.zhang@linux.dev>
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

check_isolcpus() clears ISOLCPUS before rebuilding it from sched domain
data. Comparing that empty value with
/sys/devices/system/cpu/isolated makes the test fail whenever
isolcpus=domain is present.

That sysfs file is generated from HK_TYPE_DOMAIN_BOOT and does not change
when cpuset updates HK_TYPE_DOMAIN. Re-reading it cannot validate dynamic
housekeeping updates. The cpuset.cpus.isolated and sched domain checks
already cover the two dynamic interfaces, so remove the invalid comparison.

This can be reproduced on a kernel booted with isolcpus=domain,15:

    # tools/testing/selftests/cgroup/test_cpuset_prs.sh

The test fails its first state-matrix isolation check before the change and
continues past that check afterward.

Fixes: 6df415aa46ec ("cgroup/cpuset: Defer housekeeping_update() calls from CPU hotplug to workqueue")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index da8f7b920178..fdb3185570d4 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -797,7 +797,6 @@ check_isolcpus()
 	EXPECTED_ISOLCPUS=$1
 	ISCPUS=${CGROUP2}/cpuset.cpus.isolated
 	ISOLCPUS=$(cat $ISCPUS)
-	HKICPUS=$(cat /sys/devices/system/cpu/isolated)
 	LASTISOLCPU=
 	SCHED_DOMAINS=/sys/kernel/debug/sched/domains
 	if [[ $EXPECTED_ISOLCPUS = . ]]
@@ -835,11 +834,6 @@ check_isolcpus()
 	ISOLCPUS=
 	EXPECTED_ISOLCPUS=$EXPECTED_SDOMAIN
 
-	#
-	# The inverse of HK_TYPE_DOMAIN cpumask in $HKICPUS should match $ISOLCPUS
-	#
-	[[ "$ISOLCPUS" != "$HKICPUS" ]] && return 1
-
 	#
 	# Use the sched domain in debugfs to check isolated CPUs, if available
 	#
-- 
2.43.0

