Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794052884;
	b=eDSsaCkBhPHpO/GR4RB4JV/oKPFFAKBCRAgKce3GvsVYfots6rXnwuM7iTbuIJ4Ikrjk
	 KtHf00NjnF170FSRQ2KkIITx8MkvJnorfvB+VXLtBE5XeuRzFKjOfqzn3L1GL/ztVFJdf
	 BQyrVyZ7jI5hYDPSHv/uHtbevfcOrn0qEwKswJRQFfiju4vL7WqwsO2KT6w17qk7wJF+3
	 nPXSxoLW7pkoS/GgJv0kamBXLAahhN+nN00+oBSGB9XF7UpHnImdGB0etdVaYXXjWT8WU
	 ejZHA/JDqJPZCM5bhLsIV+6hM5oKKToX7MnlNelxHwVVuXKVaaxxv/sQX3ATSsZV+Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794052884;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=hrj4JXzZ1TsgPylBSS9iKSCO976KUaXxCh80/VCZOeI=;
	b=L3+lmz2O4gbyl3gPV6i/F6KoI//MZ/zp4wiFBWXlyj/OlhjBH6jcx7rmR8P7Ns2NnRpe
	 xHtLwOglRY61pgsbFiLiusWGBM88MX/u9CYEJ3OqWFNLNTquyQf2O9GWgHkvITMUn/Ohi
	 oGBmIwH1Z+i2XnSvBjWk8VyK4At4soenbTKh0rAIEtdcFLTK02ezb7HaM8WRoj8wtnoit
	 xyC8aZ/6LnzmO8nrBakTomnqNmSAly2T2kns7HGSARkIzojQ5yOIcNLZicKFfkZXTZsuW
	 Tom+2YmlZ+39tu1/Boshd+ySuAQ49JdHhhAtjVWMlthwTGT/asFsGEpAOa7j1laPdFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Y0+XV4Ox;
	arc=none smtp.remote-ip=91.218.175.108
Received: from mta0.migadu.com (out-108.mta0.migadu.com [91.218.175.108])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFFD606A32E
	for <cgroups@vger.kernel.org>; Sat,  7 Nov 2026 12:01:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3EFFD606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Y0+XV4Ox
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=WAwIwB/wG7QJwBBWa9yFosmUNQG9PZLiWt4eFYdlm30=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794052881; v=1; x=1794657681;
 b=Y0+XV4OxPgbsQLMjhSzjBW6hXX6MtJj/wIu6AAO9QsFWMF5Ul9lrWSQNiKzGF4cfxNlRo/06
 Cbxb3RO3LgxT5sLEOmH8NemaJaaYqAgxYVZDYr7dB09alRel5rpIE7hh+Zyuq4ZsdGoLN8DuTAW
 Aif3RCKdCeOcyX7TNK5/jSJc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5b9fe3969bd8cba9;
	Sat, 07 Nov 2026 12:01:21 +0000
X-Mizu-Trace-ID: 5b9fe3969bd8cba9
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>,
	Chen Ridong <chenridong@huawei.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v3 0/4] cpuset: preparatory fixes and cleanups for partition rework
Date: Sat,  7 Nov 2026 20:00:56 +0800
Message-Id: <20261107120100.3587595-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
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

This is the first part of the cpuset local partition rework posted as
RFC v4 [1]. The rework is split into three parts to make it easier to
review and merge:

  1) fixes and preparatory cleanups (this series);
  2) introduce partition_enable/disable/update() and rework the local
     partition code on top of them;
  3) clean up the remaining partition state handling outside these
     helpers.

Patch 1 is a fix for an existing bug, found while looking into a review
comment on RFC v4: when cpuset.cpus.exclusive of an already invalid
partition root is cleared, its effective_xcpus is not reset, so its
former exclusive CPUs can't be claimed by a sibling. A test case is
added for it.

Patches 2-4 are the first three patches of RFC v4, rebased onto
next-20261104:

  2) add an early empty cpumask check in partition_xcpus_add/del(), so
     callers don't need to check it;
  3) settle the isolation state of CPUs given back to the parent in
     partition_xcpus_del(), so isolated_cpus_release() can be removed;
  4) generalize validate_partition() so it can be used for both local
     and remote partitions.

All patches build on their own, and test_cpuset_prs.sh passes with
this series applied.

[1] https://lore.kernel.org/all/20261101114206.2434398-1-ridong.chen@linux.dev/

Changes in v3:
  - Patch 3: merge isolated_cpus_set_state() into isolated_cpus_update(),
    dropping its @old_prs argument and the WARN_ON_ONCE(), and drop the
    state check in partition_xcpus_add() (Waiman).
    Drop the Acked-by from Guopeng as the patch changed.
  - Patch 4: use top_cpuset as the parent of a remote partition and pass
    the parent to tasks_nocpu_error() instead of parent_cs(cs) (Waiman).

Changes in v2:
  - Patch 1: force update_cpumasks_hier() after reset_partition_data(),
    so that the descendants don't keep the released exclusive CPUs, and
    add a test case for it (Sashiko).
  - Patch 1: fix the Fixes tags (Sashiko).
  - Link to v1: https://lore.kernel.org/all/20261105125215.2205892-1-ridong.chen@linux.dev/

Changes since RFC v4:
  - New patch 1 to fix the invalid partition effective_xcpus reset.
  - Patch 3: only settle the isolation state of the CPUs still owned by
    the parent when invalidating a child partition in
    compute_partition_effective_cpumask(), as the parent may be shrunk
    and not updated yet. This code is removed later in the rework.
  - Rebase onto next-20261104, which includes commit 362212853cd0
    ("cgroup/cpuset: Fix incorrect CPU accounting with parent's effective_xcpus expansion").

Chen Ridong (2):
  cpuset: add early empty cpumask check in partition_xcpus_add/del
  cpuset: generalize the validate_partition() interface

Ridong Chen (2):
  cgroup/cpuset: Reset partition data when an invalid partition stays
    invalid
  cpuset: settle isolation state when CPUs are given back to parent

 kernel/cgroup/cpuset.c                        | 236 +++++++-----------
 .../selftests/cgroup/test_cpuset_prs.sh       |   6 +
 2 files changed, 100 insertions(+), 142 deletions(-)


base-commit: 8b7179210b22f8e48a82c5ceacb9d56a9c4cfec4
-- 
2.34.1

