Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793883174;
	b=ibw3oEP5WjSl1+MAmbcV8Bj+m9ZPf0+bgILuirKNARdB2gbxNLKMIQJTiQUbRRx1VD2W
	 C7emyKbKokoWYSfcnwecg5nQWtNAuePb7bma+MbDEO9KTmSCZGkfO+ZbYKXbS8hLkEXV0
	 QXBdg3lcslm3IYO7sTAws/0g/SrRC+RrMf66CYkflQo5yvbpeWt8SglMAWWgPS0J2S8ke
	 mmi6lFqtIWGfuxV2vt5Zx6jzidIZj8EmuaLRA0FAIUn386tYIALh7TOgJpuAG5DE8PAF2
	 2iP+FChBjXEA9nI4wGQQ+oXMjVHRnlObaU6s6xxvsUOYeAkkhRQLbEhwREEihY6giig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793883174;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=RTgQRTFtisig+XhJkIfb6eg7MdcCPg80PyEHZzaAC08=;
	b=qEA6tMpunp1kqvVpW3fF1fp70HWPZ+8TCR6F+fAZvDJe/6XX+QUrtWPc0a93BtF0jaOh
	 GBK1JrFFwvYM+ZSYI8QqZzKfUbuwlsw1HmlCiz1yVf1CPKPiRnx8/wY3k8KS2OPYn2aSY
	 lxdr4kWBB5YybDuT1hbXox2RGzLCbySbkvNpD4BM4OBobQpisXtfKovu/iuI3ILZ3slZ1
	 fAUMx/HTUvaEcy1kMqb+oHdU1hBpKD1GP6V+bEv4noAu3S9O6riMET8GI5K5YkbxMuNKS
	 Q1CUfcyluHNYw5bf5ClucKAMPpF+bFBxd1qnowMaH3M2Pcwo+0FLGkUsGceiP6rhnMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	arc=none smtp.remote-ip=91.218.175.182
Received: from mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81944606A33F
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 12:52:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81944606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=mUgM79iUHbJsNdD4rDYze8gDWIqMls6PBPkzr43vslw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793883166; v=1; x=1794487966;
 b=eocEAXbk4HDy9IlZDyIMQySSckN/hqGXXclU97FyWxI7S2mhfko6TvjW/8uLamS4WtKf0iP5
 Gcxt3BJzRpVhq0cPmfluCDlmiL/+w/DK3oOonvbQURZV63Iqe33XPqFpJVWVRJ5mWjY7EeZFPeR
 xj1ptRCufrTBmhoutaqkwICo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 661658dd28fab252;
	Thu, 05 Nov 2026 12:52:46 +0000
X-Mizu-Trace-ID: 661658dd28fab252
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH 1/4] cgroup/cpuset: Reset partition data when an invalid partition stays invalid
Date: Thu,  5 Nov 2026 20:52:12 +0800
Message-Id: <20261105125215.2205892-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261105125215.2205892-1-ridong.chen@linux.dev>
References: <20261105125215.2205892-1-ridong.chen@linux.dev>
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

From: Ridong Chen <chenridong@xiaomi.com>

When cpuset.cpus or cpuset.cpus.exclusive of a partition root is
changed, update_cpumask() and update_exclusive_cpumask() copy the new
effective_xcpus computed for the trial cpuset into the cpuset, and call
reset_partition_data() only if the partition was valid before and is
invalid now:

	if ((old_prs > 0) && !is_partition_valid(cs))
		reset_partition_data(cs);

An invalid partition root (old_prs < 0) that stays invalid is not
covered. Its effective_xcpus is then left with the trial value, which
is computed from user_xcpus() and so falls back to cpuset.cpus when
cpuset.cpus.exclusive is cleared. As an invalid partition root does not
own any exclusive CPUs, and rm_siblings_excl_cpus() treats a non-empty
effective_xcpus of a sibling without cpuset.cpus.exclusive as owned,
those CPUs can then no longer be claimed by a sibling:

  # A1: cpuset.cpus=2-3, cpuset.cpus.exclusive=2-3, root, with tasks
  # offline CPUs 2-3 -> A1 becomes invalid
  echo > A1/cpuset.cpus.exclusive
  cat A1/cpuset.cpus.exclusive.effective    # 2-3, expected empty
  echo 3 > B1/cpuset.cpus.exclusive         # -EINVAL

Reset the partition data whenever the cpuset is a partition root, valid
or not, and ends up invalid. Add a test case for it.

Fixes: f62a5d39368e ("cgroup/cpuset: Remove remote_partition_check() & make update_cpumasks_hier() handle remote partition")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20261101114206.2434398-1-ridong.chen%40linux.dev?part=15
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c                            | 4 ++--
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3052413e41e7..bc16fd1b1c5e 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2607,7 +2607,7 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	spin_lock_irq(&callback_lock);
 	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
 	cpumask_copy(cs->effective_xcpus, trialcs->effective_xcpus);
-	if ((old_prs > 0) && !is_partition_valid(cs))
+	if (old_prs && !is_partition_valid(cs))
 		reset_partition_data(cs);
 	spin_unlock_irq(&callback_lock);
 
@@ -2672,7 +2672,7 @@ static int update_exclusive_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	spin_lock_irq(&callback_lock);
 	cpumask_copy(cs->exclusive_cpus, trialcs->exclusive_cpus);
 	cpumask_copy(cs->effective_xcpus, trialcs->effective_xcpus);
-	if ((old_prs > 0) && !is_partition_valid(cs))
+	if (old_prs && !is_partition_valid(cs))
 		reset_partition_data(cs);
 	spin_unlock_irq(&callback_lock);
 
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index bdca6c471f87..9c0c78ca6329 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -434,6 +434,10 @@ TEST_MATRIX=(
 	# cpuset.cpus is allowed, but those extra CPUs are ignored.
 	"  C2-3:P1   C3:P1  .      .      .     C2-4    .      .     0 A1:|A2:2-3 A1:P1|A2:P1"
 
+	# Clearing cpuset.cpus.exclusive of an invalid partition releases its
+	# exclusive CPUs, so a sibling can claim them.
+	" CX2-3:P1    .     .     C3  T:O2=0:O3=0:X  .     .      X3   0 XA1:|XB1:3 A1:P-1"
+
 	# A child cannot recover until its exclusive CPUs are available again.
 	" CX1-4:P1 CX3-4:P1 .     .     X1-2     .      .      .     0 A1:1-2|A2:1-2|XA2: A1:P1|A2:P-1"
 	" CX1-4:P1 CX3-4:P1 .     .  X1-2:X1-4   .      .      .     0 A1:1-2|A2:3-4|XA2:3-4 A1:P1|A2:P1"
-- 
2.34.1

