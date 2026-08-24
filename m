Received: from mta1.migadu.com (out-8.mta1.migadu.com [95.215.58.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE170493632
	for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 02:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787536919; cv=none; b=LOPQdLlT0uCpYAvfAhfmatxm3jw4WlMRzPvq17oVVqILUnwnhxYU0Epj8jLPzB09Snyz9CdKouamZTE854pJxIH/TNKBl3AuWUBn0gHEo2HCchMrGf2k8ON533nH8K5WWokhXGgBKCLwdWqn+eKPqz7ug4AZYqlMXP8pKGqhdmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787536919; c=relaxed/simple;
	bh=xHrIUmHkTESiRVHALuYcyRT7XTgZFarmWufBgGwSz6A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s32DjLZldQY9/wKO4XOQ2N0vUhqM1Tnj/mw+QzfXNCps7Az4AHhMjAc07lxae3Jqua4dTMxBkTQdDxL263Lq/zLbPtJrDqG2D74N+bOUdX/7zBCmZFfg578oU785AdKqh/qay2wDDWh3JqjWu1d6mVWPpmpOOHpAedUL2andUT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sFxIOS4I; arc=none smtp.client-ip=95.215.58.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sFxIOS4I"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=xHrIUmHkTESiRVHALuYcyRT7XTgZFarmWufBgGwSz6A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787536915; v=1; x=1788141715;
 b=sFxIOS4ILNEaBQWRRsT4VOq3vJ7BJ7EoaGkPQfZkbLJTSRH/zLKiwlZ1Gsn5oDDOQQ1Gbc/7
 ngHQgnZuyAZnfmUhLZqqISw1MJvvc5H/0q3te7vwMFACMuDS1Ah9U2TvYvvXGAYkmwmSWwa+Bws
 f0a/PoOgyXIPYugltro6lLlU=
X-Envelope-To: cgroups@vger.kernel.org
Received: from zgp.. (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 48be7f349129c02e;
	Mon, 24 Aug 2026 02:01:55 +0000
X-Mizu-Trace-ID: 48be7f349129c02e
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
Subject: [PATCH v2 0/3] cgroup/cpuset: Preserve boot-isolated CPUs on partition release
Date: Mon, 24 Aug 2026 10:01:37 +0800
Message-ID: <20260824020140.21130-1-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

This series fixes the loss of boot-isolated CPUs when an isolated cpuset
partition is released. It also removes a selftest comparison against a
boot-only sysfs mask which cannot track dynamic cpuset isolation.

---
Changes since v1:
- split the boot-isolation fixes from the original 17-patch series;
- explain why the boot-only sysfs mask cannot validate dynamic cpuset
  isolation;
- add reproducers and observed/expected results to patches 1 and 2;
- no code changes.

Link: https://lore.kernel.org/all/20260820124202.517160-1-guopeng.zhang@linux.dev/

Guopeng Zhang (3):
  selftests/cgroup: Drop invalid boot isolation comparison
  cgroup/cpuset: Preserve boot-isolated CPUs on partition release
  selftests/cgroup: Add test for preserving boot-isolated CPUs

 kernel/cgroup/cpuset.c                        | 39 ++++++++---
 .../selftests/cgroup/test_cpuset_prs.sh       | 64 +++++++++++++++++--
 2 files changed, 87 insertions(+), 16 deletions(-)


base-commit: 6a746cd265aed59107ebdaa9ce039bb832922969
-- 
2.43.0
