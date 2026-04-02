Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF8C273D6D
	for <cgroups@vger.kernel.org>; Thu,  2 Apr 2026 06:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775111858; cv=none; b=ajuVB2HWFb8LCHMjBJvRNICs37hnVQwjEvUSmNya3KFU/LWNDJG0/qtVzMWrrwkGG/qzo+HAtwaxsBdI2CW5dR7V8AwLXbZx/G2IWqnkDOW4oUBow/J9jq+A7rCM1Hw+J5gWzNVLyy3QG0PGnqUnH2zdMKUsF45zQNYHeHQnUgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775111858; c=relaxed/simple;
	bh=mEPg2DvSUlXaoHR3OjRrYufSbyrK7gnFlb8nHPB+SZs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lOtuEe8IMDNaf5GH1v87SttXBT80vfbBB/p5F5IsfBTfZfDzRK4+2Q4CZC+VT8T2h4s4Yq0Y6RidzytIrsTHE+vgdUVyXk4FKDr8+mWlvdMGel9V0ZgvzpaZcZKRtz5X2aiVBafooc/ESiWPnQ0SJADvpAfQPw+TP/tEKtFLyDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hpj855FU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hpj855FU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775111855;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5ySkwRxMWsN/b1cF+ftDoDLaCJSoF5606499RQFGjCI=;
	b=hpj855FUXjoKNQZgwnMWuw1ycL9O3riqEyxB3xfpVpyM4T52kFtrG2jQTJ+PRBUSnce3kC
	oUewCoPKWbGXPV2CJsUMcb+//s90N7EDc2y57Kiy/tTzNP0of2dDnJ2I6VpsCe+zsIrJE6
	Pa2k6XskxIjPvPHql45vz6bKeeb/hF4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-563-P_vobo2hMEOZLwDmrychMw-1; Thu,
 02 Apr 2026 02:37:29 -0400
X-MC-Unique: P_vobo2hMEOZLwDmrychMw-1
X-Mimecast-MFC-AGG-ID: P_vobo2hMEOZLwDmrychMw_1775111846
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3A75019560AA;
	Thu,  2 Apr 2026 06:37:26 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.158])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3BB611800361;
	Thu,  2 Apr 2026 06:37:18 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	david@kernel.org,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	mhocko@suse.com,
	shuah@kernel.org,
	chengming.zhou@linux.dev,
	longman@redhat.com,
	nphamcs@gmail.com
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v6 0/8] selftests/cgroup: improve zswap tests robustness and support large page sizes
Date: Thu,  2 Apr 2026 14:37:06 +0800
Message-ID: <20260402063714.55124-1-liwang@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

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
 tools/testing/selftests/cgroup/test_zswap.c   | 179 ++++++++++++------
 6 files changed, 151 insertions(+), 73 deletions(-)

-- 
2.53.0

