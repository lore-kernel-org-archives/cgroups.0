Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA16F381E94;
	Sun,  2 Aug 2026 11:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785669937; cv=none; b=iOM/ZlzoEqWT1EEL5l2s1McL3pzIoG7Gy/wcp4CcxI0CGo6b1TpFwJvT5hiVseN/KuDEGpItoMS8jhE9/UfCyQSqiU5iSarcmXhsfqhH+oqoVBII4H6tonhhgl7Yw0uwDJNYKXJ9dWBlP1ejm0mUdFehqPI8Dg1rrNpTPwxeta8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785669937; c=relaxed/simple;
	bh=dBrl1Pp9HQ4n78J1Ir0K119S/z+p2hrZdQg7yU7uW/k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hjj8V1zi5wUqGZFFtkvjR18nSuAGwX2Wgj49IwJ+jq9xQhF4xCJa9zhDCrC9gKS9YmP2eWWONeYO9MDOn2VpbRhZPmY19wzrcVxMmqGi3YINAo/k3kZow6eFZQsxi9uMdtin4pv2hs7RFAZwxg/ZbBsujaw3lGlWHfP0ny5BaaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IPY1/T8r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IPY1/T8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6051F00A3A;
	Sun,  2 Aug 2026 11:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785669935;
	bh=mfWYTY/Qd1tUhLyp54yJEpcWt0Lp1lIRHIVNWZlerm4=;
	h=From:To:Cc:Subject:Date;
	b=IPY1/T8rhORUhN8leb4f7zc90vjCYpCJZQXA3v99A4RA8OdQTFtbN3V7UcpwB8xMe
	 EkB1/GO/Rl/h5WWdW6Ti+ewC4/C2ko+w4cIZ7Qt8DpfCpINyO9cwgU/9yrcSyv0jT+
	 G9zZ+DjYVHFAO+xXZm9ZzJNbdyrLqg6a3T4Z4YijG2H3UsXzK7Xy57YdTxmgPsOU4e
	 MOLaf3CobrgSR8cCOb+1XUimBwZwkq3Z/igbCLGZFvfAlx2L0Io4neOyLeYXjUdRm9
	 HzMM0lb+gzrsMdpK6rmYYB3InE2dbpWfUHzyzHZSPmGE67TltcwsqL04QgT4qfW3i7
	 iiL8NuCuzrrRw==
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
Date: Sun,  2 Aug 2026 19:25:16 +0800
Message-ID: <20260802112525.3933753-1-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
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

