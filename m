Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0377B3ACA61;
	Sun,  2 Aug 2026 11:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785669962; cv=none; b=H+JD+aBWJhesVXV3Nh4wkjJiBp8qim+lX4SLolVHMAuBM/yROQwo+mPBMUTB2Owy/B48U3rhq9A8F/gmY4UieU+JqEzpMDQr82G5nnH8TewcG2Mh5WsUIFU1mgDJRGwoRn4E2Z801TbWiMP1B5lrbI8SU3kYEnUFAxohSbX0nJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785669962; c=relaxed/simple;
	bh=dBrl1Pp9HQ4n78J1Ir0K119S/z+p2hrZdQg7yU7uW/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7awa/w9T05X3jddVQrhaPRaFDQU1A0cLQ3khTkMNrklCCApoJ1cPpSx5bblXJKbX1l/5rP0bRkb0EV7KrrKDikpqhvywPUYj/8ETrtZKfDixM9tEsQSMm+SJmBbCivMuEWXZodUM5KMfWyNkDQiIq0hyPTL2qzu4vsuIV5zn7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MJdQENa3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MJdQENa3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9157D1F000E9;
	Sun,  2 Aug 2026 11:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785669960;
	bh=mfWYTY/Qd1tUhLyp54yJEpcWt0Lp1lIRHIVNWZlerm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MJdQENa3gvXxFzb1ifGAgZFWH1Fs4NkjvxzI06IEm3p3yi//ZaALKOdXeNgKPenjZ
	 hBPyQlsdyS58oFquIzbTiGufWyzgIeuUpe1CZqLrccryYZZ8rj9RKL0OY3NV8v5/iU
	 Z2fStEmCMi+OEipXIJP855oZ3AQZYh4gUXHsQXTgIgwKtBtTBTNEEsNbcpyMQJzOQ6
	 aDykoS0aRTCC8+AZfO4nWPE7T7pHefIxLi1swTAO0VOE3Kk4Q+WkFdJd7K1z8a97AG
	 uEwwl1MSZr2cvmbSSsJx5stgJ7Ttc3vaYTeB2LnlZCf/B8TKDHrxgJ2/U/DFYne5da
	 S95j6tGStPVtQ==
From: Yu Kuai <yukuai@kernel.org>
To: tj@kernel.org,
	axboe@kernel.dk
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhengqixing@huawei.com,
	hch@lst.de,
	yizhou.tang@shopee.com,
	yukuai@fygo.io,
	nilay@linux.ibm.com
Subject: [PATCH v4 0/4] blk-cgroup: fix blkg list and policy data races
Date: Sun,  2 Aug 2026 19:25:21 +0800
Message-ID: <20260802112525.3933753-6-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260802112525.3933753-1-yukuai@kernel.org>
References: <20260802112525.3933753-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

This set fix some problems that are reported long time ago with minimal changes,
the blkcg_mutex refactor I'm working on can fix these problems as well, but it's
complicated and may not land in this merge window. So I think this set should land
in this merge window first.

Patch 1 protects blkg_destroy_all()'s q->blkg_list walk with
blkcg_mutex.

Patches 2-3 fix races between blkcg_activate_policy() and concurrent
blkg destruction.

Patch 4 factors the policy data teardown loop into a helper after the
race fixes.

Changes since v3:
- Rebase on the latest for-7.3/block branch.

Changes since v2:
- Rebase on the latest block-7.2 branch.

Changes since v1:
- Drop the BFQ q->blkg_list patch because the current block tree already
  has a stronger fix in commit 17b2d950a3c0 ("block, bfq: protect async
  queue reset with blkcg locks").
- Add Reviewed-by tags from Tang Yizhou.

Yu Kuai (1):
  blk-cgroup: protect q->blkg_list iteration in blkg_destroy_all() with
    blkcg_mutex

Zheng Qixing (3):
  blk-cgroup: fix race between policy activation and blkg destruction
  blk-cgroup: skip dying blkg in blkcg_activate_policy()
  blk-cgroup: factor policy pd teardown loop into helper

 block/blk-cgroup.c | 65 +++++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 30 deletions(-)

-- 
2.51.0

