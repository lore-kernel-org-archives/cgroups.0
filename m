Received: from mta0.migadu.com (out-44.mta0.migadu.com [91.218.175.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C75344064B
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 12:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787229741; cv=none; b=PSMzvxXp+JEahN2JkBEapnKlmVxUSzi3BnuQqdYUz1ABAvy1DIy+K1eK1VuwWIVBWdQrQkJNboMuMQcIFRcls2lydb4EjPvAOuZnL7Q9sLVDBDlZCLIBwiSS4Ruml2aJ+zyZo6QKR0h7RBdK/eq4LJvnlBu4MYxu9TyXCvne190=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787229741; c=relaxed/simple;
	bh=NtCwpw6pTJcQl9m5fqZIXoMRk0VT+F99Mjx7WfVdmKI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AIMFvqiByihuX5K4YLKd3ZV2+ZbzNix/aUJuUb5eRb6rrAPqb5++wUvbzWgwRlrZxNM9ia29fWZOZa8KbUoS62qhjc2sbU+X08xWIzcTXpVKhtf7P2SGyfwZbik9RHrc6mTCgBXEc+P7pTED66QzuBljOy45y82dqHX+6uhOYIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PhyTClXj; arc=none smtp.client-ip=91.218.175.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PhyTClXj"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=NtCwpw6pTJcQl9m5fqZIXoMRk0VT+F99Mjx7WfVdmKI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787229736; v=1; x=1787834536;
 b=PhyTClXj+7i9YeKoO9XGsXxz6wG7BnMd3ID+XXgMxc0/5ceG67KOm8V2EYNDOcCYEo8WEJQj
 vTrPSnlpX7A2q0JHWNDI+VUs5t6uxnwwBzY86dxmaIhQ9w+lCTDBP4v1Iiy0uWwt8zSCc1I+uBH
 svhEW6CDiOC+WmhnMaiWlp80=
X-Envelope-To: cgroups@vger.kernel.org
Received: from zgp.. (223.70.159.239)
	by smtp.migadu.com with ESMTPS id b262bd0701bfd5d0;
	Thu, 20 Aug 2026 12:42:16 +0000
X-Mizu-Trace-ID: b262bd0701bfd5d0
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: longman@redhat.com,
	cgroups@vger.kernel.org
Cc: ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH 00/17] cgroup/cpuset: Fix partition CPU ownership and isolation accounting
Date: Thu, 20 Aug 2026 20:41:45 +0800
Message-ID: <20260820124202.517160-1-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

update_prstate() uses effective_xcpus for isolation accounting and
housekeeping checks when switching a partition between root and
isolated. The mask also includes CPUs granted to valid child partitions.
Such a type change can alter isolation accounting for child-owned CPUs
or fail a housekeeping check because of a CPU the parent does not own.

A rejected type change can leave CPUs assigned to the invalidated
partition instead of returning them to the partition that owns the
invalidated subtree. When cpuset.cpus changes, child validation can use
the old parent mask, and a remote update can observe stale cpus_allowed
when it revisits a cpuset. Direct and propagated invalidation can leave
isolated_cpus reflecting the released partition's type instead of the
type of the partition receiving its CPUs. Releasing an isolated
partition can clear boot-isolated CPUs from isolated_cpus.

Limit type-change checks and accounting to CPUs owned directly by the
partition. Preserve boot-isolated CPUs when a partition is released,
return CPUs after rejected type changes, validate children against the
new parent mask, and publish cpus_allowed before a partition update can
revisit the cpuset. Fix isolation accounting during direct and
propagated invalidation.

Patch 1 removes an invalid selftest comparison that makes
test_cpuset_prs.sh fail when boot-time domain isolation is configured.
Each kernel fix is followed by a focused selftest update.

Guopeng Zhang (17):
  selftests/cgroup: Drop invalid boot isolation comparison
  cgroup/cpuset: Preserve boot-isolated CPUs on partition release
  selftests/cgroup: Test boot-isolated CPU partition release
  cgroup/cpuset: Limit type-change accounting to owned CPUs
  selftests/cgroup: Test isolated CPU accounting on type changes
  cgroup/cpuset: Validate type changes against owned CPUs
  selftests/cgroup: Test type-change validation with child-owned CPUs
  cgroup/cpuset: Release CPUs when a type change is rejected
  selftests/cgroup: Test rejected partition type changes
  cgroup/cpuset: Fix isolated accounting on direct child invalidation
  selftests/cgroup: Test isolation accounting on direct child
    invalidation
  cgroup/cpuset: Invalidate children outside the new CPU mask
  selftests/cgroup: Test child invalidation after shrinking cpuset.cpus
  cgroup/cpuset: Publish cpus_allowed before partition updates
  selftests/cgroup: Test shrinking cpuset.cpus in a remote partition
  cgroup/cpuset: Fix isolated accounting on propagated invalidation
  selftests/cgroup: Test isolation accounting on propagated invalidation

 kernel/cgroup/cpuset.c                        | 162 ++++++++++--
 .../selftests/cgroup/test_cpuset_prs.sh       | 231 +++++++++++++++++-
 2 files changed, 361 insertions(+), 32 deletions(-)


base-commit: 6a746cd265aed59107ebdaa9ce039bb832922969
-- 
2.43.0
