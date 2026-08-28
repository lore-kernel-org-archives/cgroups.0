Received: from mta1.migadu.com (out-162.mta1.migadu.com [95.215.58.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A59C39A07E
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 09:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787911019; cv=none; b=VdTnPak04hxNl31jl0A9Xx5bs662T62YudidDF9r37Wno5AbMFX9rD/B84xAhRHEi3iWKEYTU1i4NSpxIjqwnPgMA4IE8GtUIYqyOtO05ZjhVxEUbZe/URefj6swa7Qubf/WGJCUBAl5ga1wwrGMAChfCG6ycvva29SrpFHCipQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787911019; c=relaxed/simple;
	bh=/vXroZTZEjVjhV/E5ewR9YdbGKmUxqENa6uHPDP6v7U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HWoLZh9eWvwUm5zsQwiVTizoj46dlLrSVVltxJ8YZQF4JBVzdUSYUUeTsel1a91bFR0TsDM1HFMr48P4zIPlLWLRwSeosXtvls3g1T/HUKWOii/noTlI8gRWi0+3az7X9dfBLpUVrSS7ZvWSj9hIj3Z5i/w5nH5udpiASJkYWlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O/kveUZP; arc=none smtp.client-ip=95.215.58.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O/kveUZP"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=/vXroZTZEjVjhV/E5ewR9YdbGKmUxqENa6uHPDP6v7U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787911015; v=1; x=1788515815;
 b=O/kveUZP3VksbQQuUXJ4gLYpnIZuK4Yno/ylCTk8JBjZF98cnYdlCrm3loel+cTRluAqOeke
 MX4NbAJMbYATuCtVbtkuLOyTtcT8YpsLq3Vuu/5GFtx93hzBzOyRr+85D4YI3wGfW+RtTJnP9ik
 ompkKNfpVqiw74jbckRMVIEc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7c5a43284bb5f1ee;
	Fri, 28 Aug 2026 09:56:55 +0000
X-Mizu-Trace-ID: 7c5a43284bb5f1ee
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: cgroups@vger.kernel.org,
	longman@redhat.com,
	ridong.chen@linux.dev
Cc: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH v2 0/6] cgroup/cpuset: Fix partition type transitions
Date: Fri, 28 Aug 2026 17:56:37 +0800
Message-ID: <20260828095643.13395-1-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

Several partition type-change and validation paths use effective_xcpus,
which also includes CPUs assigned to valid child partitions. This can
change a child's isolation accounting, make a valid parent transition
fail housekeeping validation or invalidate a parent during a later
CPU-mask update.

Once type-change checks are limited to CPUs owned by the parent, a root
child can hold the last housekeeping CPU while its parent is isolated.
Returning that CPU when the child becomes a member must not consume the
last housekeeping CPU.

A type change that fails housekeeping validation can also leave CPUs
allocated to the invalid partition instead of returning them to the
partition which owns the invalidated subtree.

Use CPUs owned directly by a partition for type-change accounting and
validation. Recheck the housekeeping constraint when child CPUs return,
and release partition CPUs after failed type-change validation. Add
focused selftests for each case.

This is based on cgroup/for-7.3-fixes (87d347a8c854 "selftests/cgroup:
Add test for preserving boot-isolated CPUs").

Testing:
- Ran tools/testing/selftests/cgroup/test_cpuset_prs.sh with
  isolcpus=domain,15; all applicable tests passed.
- Ran the housekeeping CPU-return tests with
  nohz_full=1-14 isolcpus=domain,15; both cases passed.
- Ran targeted A/B tests covering child-owned CPU accounting and
  validation, housekeeping CPU return, and CPU release after local and
  remote type-change validation failures.

Changes in v2:
- split the type-transition fixes from the original series;
- merge the child-owned accounting and validation changes;
- validate trial CPU masks against CPUs owned directly by the partition;
- handle a root child returning the last housekeeping CPU, including
  nested isolated ancestors;
- use the common partition-disable path after type-change validation
  failure;
- initialize boot-isolated CPU data during selftest setup;
- split the accounting, child-owned validation and housekeeping-return
  tests.

Link: https://lore.kernel.org/all/20260820124202.517160-1-guopeng.zhang@linux.dev/

Guopeng Zhang (6):
  cgroup/cpuset: Respect child CPU ownership in type changes
  selftests/cgroup: Add tests for type-change isolation accounting
  selftests/cgroup: Add tests for type changes with child-owned CPUs
  selftests/cgroup: Add tests for housekeeping CPU return to isolated
    parents
  cgroup/cpuset: Release CPUs when type-change validation fails
  selftests/cgroup: Add CPU release tests for type-change validation
    failures

 kernel/cgroup/cpuset.c                        | 101 +++++-
 .../selftests/cgroup/test_cpuset_prs.sh       | 310 +++++++++++++++++-
 2 files changed, 398 insertions(+), 13 deletions(-)


base-commit: 87d347a8c8545a9234d1dd215023064413284c34
-- 
2.43.0
