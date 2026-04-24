Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C06432D438
	for <cgroups@vger.kernel.org>; Fri, 24 Apr 2026 04:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777003287; cv=none; b=QAR3+r+tTNpSH85k2LpQHLczCoIhrUm+O4oxrSOTOKcqJtfu7wxKmLqohsVwn/ryQWJoaN9fW+zZxOLHocJxipO2nKhH7TDMrMKSl8KC1PAO9hdAVMSmNw6ezaeirvhGEDPcUn0EhAOcS6SY9cUNHC+jOAv26pF1IBMM8M05uxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777003287; c=relaxed/simple;
	bh=4sEhtV2sdnZlSSTimxUu9Mzvl64JPYHYNeY172r9P/w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KffdUBMbRKZyCJvnR2I7dgvJXhx6EV1SZi/9pYx7eo4+KobweIfy0Z1kWklektzuHcTrvIPwdh+oRnqz3BF8j2h2K2YQjFiNhnnR5+hINTJVUUuq8m8rQJBFhkfqn7aO91s4k0p4zSzhnijMkzZclTeeNDMl6YKwJ4s158ak0vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=M5c51Ncx; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="M5c51Ncx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777003273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=byksxEzb9nJLBwk663d+8vGN4H+tPBFRKcO5GaHPgT4=;
	b=M5c51NcxbBvz74sZpZC5FRP5+muglkXSkh41uSP6psI1H+4G+Z81buzzSHQXdqJ2//nO4/
	gxdvHJtTWxBEGfcBWrA0haH1rrxWU68HhU7b0y6ivIPv+qo60BaqyPw/47o0XizCytoJOX
	NTjxeDuRlzDuFtMz5Fxkss4gk9fzzVk=
From: Li Wang <li.wang@linux.dev>
To: akpm@linux-foundation.org,
	tj@kernel.org,
	longman@redhat.com,
	roman.gushchin@linux.dev,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	jiayuan.chen@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	mkoutny@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 0/8] selftests/cgroup: improve zswap tests robustness and support large page sizes
Date: Fri, 24 Apr 2026 12:00:51 +0800
Message-ID: <20260424040059.12940-1-li.wang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This patchset aims to fix various spurious failures and improve the overall
robustness of the cgroup zswap selftests.

The primary motivation is to make the tests compatible with architectures
that use non-4K page sizes (such as 64K on ppc64le and arm64). Currently,
the tests rely heavily on hardcoded 4K page sizes and fixed memory limits.
On 64K page size systems, these hardcoded values lead to sub-page granularity
accesses, incorrect page count calculations, and insufficient memory pressure
to trigger zswap writeback, ultimately causing the tests to fail.

Additionally, this series addresses OOM kills occurring in test_swapin_nozswap
by dynamically scaling memory limits, and prevents spurious test failures
when zswap is built into the kernel but globally disabled.

Changes in v7:
  Replace my work email by li.wang@linux.dev address.
  Add Acked-by: Nhat Pham <nphamcs@gmail.com> to series.
  Rebase to the latest branch (only one tiny conflict resolved).

Changes in v6:
  Patch 4/8: Use page_size instead of BUF_SIZE
             Declear page_size as int but not size_t
  Patch 5/8: Use page_size replace the sysconf(_SC_PAGE_SIZE).
  Patch 7/8: Adjust the code comments.
  Patch 8/8: Declear long type for elapsed and count variables.

Changes in v5:
  Patch 1/8: Defined PATH_ZSWAP and PATH_ZSWAP_ENABLED macros.
  Patch 4/8: Merge Waiman's work into this patch (use page_size).
  Patch 5/8: Change pagesize by the global page_size.
  Patch 6/8: Swap data patterns: use getrandom() for wb_group and simple
             memset for zw_group to fix the reversed allocation logic.
  Patch 7/8: Setting zswap.max to zswap_usage/4 to increase writeback pressure.
  Patch 8/8: New added. Just add loops for read zswpwb more times.

Test all passed on:
  x86_64(4k), aarch64(4K, 64K), ppc64le(64K).

Li Wang (8):
  selftests/cgroup: skip test_zswap if zswap is globally disabled
  selftests/cgroup: avoid OOM in test_swapin_nozswap
  selftests/cgroup: use runtime page size for zswpin check
  selftests/cgroup: rename PAGE_SIZE to BUF_SIZE in cgroup_util
  selftests/cgroup: replace hardcoded page size values in test_zswap
  selftest/cgroup: fix zswap test_no_invasive_cgroup_shrink on large
    pagesize system
  selftest/cgroup: fix zswap attempt_writeback() on 64K pagesize system
  selftests/cgroup: test_zswap: wait for asynchronous writeback

 .../selftests/cgroup/lib/cgroup_util.c        |  18 +-
 .../cgroup/lib/include/cgroup_util.h          |   4 +-
 tools/testing/selftests/cgroup/test_core.c    |   2 +-
 tools/testing/selftests/cgroup/test_freezer.c |   2 +-
 .../selftests/cgroup/test_memcontrol.c        |  19 +-
 tools/testing/selftests/cgroup/test_zswap.c   | 181 ++++++++++++------
 6 files changed, 152 insertions(+), 74 deletions(-)

-- 
2.53.0

