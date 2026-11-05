Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793883853;
	b=fsYERmLkP6RDKAmB3AmqhVTTmeOuCTcaubBr1Da+3Ria+PdSiL1s9rVPjvjLzhOhsV6A
	 /d5m38UWEFtnVDxENR9vqTrkw0ra/TXRSvjqB6msyseSU/ccHMU/x0IdJ4kRfPMbA5061
	 4r7eZKBjGYEjpVXnGmxQDhcJxXFIVjxongt7MfYfTpi4AwambuEshYTNkVDeyxxNOEhGZ
	 VBFfwPP/gX+CnXaoxGHv3m+agd8dCZSARUdSlHdSZ7HZB3KE5dSZyidwMfnTBcPMuYre4
	 wcvR+sws/sIRmqTVi50FDHGIbVst0UohCBp/7wV8vSIVKwY3C4YEYH10AvPHEJ9x2Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793883853;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=FoSHuLGxpig1CAQC21sK890uLqq0mHMPZCaaAfT9pSg=;
	b=1v3CBHKn6ubvifDSDYAlDVECDMIksqHPzCD5xuR2UHDq6/wFe9QjDIfSmZ8KXFfmlnOt
	 /JciGMvNVWSR+vNj4lw49azF6kehdhAV9Yt/ae4Ku9kJv373bFfkVeOzHhpkyjELlRv83
	 mUXmIIhqlcnbSrJ/5442fwKkLfZB0Wm8kwmHsZxyQlBGGELvSbIxaUZPI7j5mGwPzJ3S0
	 ehhhx7tNIoIR3hgymgLxC+gsKQhAFxTsgkirPYXE/l+zVKmB0d1kzlTMa2STR/hL4g+y0
	 GOTVNPxQpLAEAbV5cuadUCDHMMHZC5gMc3wzd8bMWCpuW1owwQ7nEMfOCI65v5osiZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mw7MMl6m;
	arc=none smtp.remote-ip=95.215.58.33
Received: from mta1.migadu.com (out-33.mta1.migadu.com [95.215.58.33])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE12606A31B
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 13:04:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4FE12606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mw7MMl6m
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=8F+i2JLSDFi9B3hp21d4Qgjha4YEyOCj8MaTbrk2+bo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793883850; v=1; x=1794488650;
 b=mw7MMl6mN0opWVu6uRzE4+IJa8ap6RNpYKmj3rkEvduIycjkJ6/FSwgqLkgAndW2Yx//K2PC
 ofTqsHjsyTOHVRkPSgde1djAvvBcU//ZWCRfyub0VOj9PSM4ADAu9TYNBkdpkyVl0eqPPa+L3Od
 Em/hn+EGzzWxiHiulmUGMA30=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2f00fc6fe78d17f4;
	Thu, 05 Nov 2026 13:04:10 +0000
X-Mizu-Trace-ID: 2f00fc6fe78d17f4
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
Subject: [PATCH v2 2/3] cgroup/cpuset: Keep the top sched domain non-empty on CPU hotplug
Date: Thu,  5 Nov 2026 21:03:43 +0800
Message-ID: <20261105130344.664336-3-guopeng.zhang@linux.dev>
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

Configuration updates must leave an active boot domain housekeeping CPU
in the top cpuset, but CPU hotplug can still empty its scheduling domain.

For a local partition with child partitions, cpuset_hotplug_update_tasks()
passes the partition's own effective CPUs to tasks_nocpu_error(). The
embedded top_cpuset_sd_nocpu() check credits the old exclusive CPUs not
in that mask as CPUs being returned to the top cpuset. Those CPUs may
still belong to child partitions, so no such return takes place.
For example, with isolcpus=domain,10-31 on a 32-CPU system:

  echo 0,2-9 > A/cpuset.cpus
  echo root > A/cpuset.cpus.partition
  echo 5-9 > A/B/cpuset.cpus
  echo root > A/B/cpuset.cpus.partition
  echo 0 > /sys/devices/system/cpu/cpu1/online
  Oops: general protection fault
  RIP: 0010:build_perf_domains+...

Remote partition hotplug checks also miss the empty top scheduling
domain because they only examine the remote partition's own CPUs.

Check the local partition's full exclusive mask without crediting any
returned CPUs. For remote partitions, check the top scheduling domain
with all partition grants still excluded. Invalidate a partition through
its existing path to return its CPUs. Once an active boot domain
housekeeping CPU is returned, subsequent partitions no longer fail this
check.

Add hotplug test cases to test_cpuset_prs.sh to verify that the top
cpuset sched domain stays non-empty when the last housekeeping CPU
goes away.

Fixes: 9b496a8bbed9 ("cgroup/cpuset: Prevent leakage of isolated CPUs into sched domains")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c                            | 4 ++++
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 8 ++++++++
 2 files changed, 12 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index c405719ccd12..fc5454c2740f 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4053,6 +4053,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 		goto update_tasks;
 
 	if (is_remote_partition(cs) && (cpumask_empty(subpartitions_cpus) ||
+				       top_cpuset_sd_nocpu(subpartitions_cpus, NULL) ||
 				       (cpumask_empty(&new_cpus) &&
 					partition_is_populated(cs, NULL)))) {
 		WRITE_ONCE(cs->prs_err, PERR_HOTPLUG);
@@ -4067,9 +4068,12 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 	 * 2) parent is invalid or doesn't grant any cpus to child
 	 *    partitions.
 	 * 3) subpartitions_cpus is empty.
+	 * 4) top_cpuset has no active boot domain housekeeping CPU left.
 	 */
 	if (is_local_partition(cs) &&
 	    (!is_partition_valid(parent) ||
+	     (parent == &top_cpuset &&
+	      top_cpuset_sd_nocpu(cs->effective_xcpus, NULL)) ||
 	     tasks_nocpu_error(parent, cs, &new_cpus) ||
 	     cpumask_empty(subpartitions_cpus)))
 		partcmd = partcmd_invalidate;
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index e813ea9959f4..f03fffeab034 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -646,6 +646,14 @@ ISOLCPUS_DOMAIN_TEST_MATRIX=(
 
 	# An invalid partition can recover once it leaves a top-level HK CPU.
 	" C0-9:P1   .      .      .    C0-8     .      .      .     0 A1:0-8 A1:P1 ."
+
+	# Offlining CPU 1 leaves only boot-isolated CPUs in the top cpuset.
+	# A local root must not count its child's CPUs as already returned.
+	# In 1|, offline CPU 1 has no sched domain but is not cpuset-isolated.
+	" C0,2-9:P1 C5-9:P1 . . O1=0 . . . 0 A1:0,2-9|A2:5-9 A1:P-1|A2:P-1 1|"
+
+	# A remote root must return CPUs when the top domain loses its last HK CPU.
+	" X0,2-9 CX0,2-9:P1 . . O1=0 . . . 0 A2:0,2-9 A2:P-1 1|"
 )
 
 # Test matrix to be run when boot time nohz_full CPUs cover all CPUs except CPUs 0-7
-- 
2.43.0

