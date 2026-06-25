Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A476C3043CF;
	Thu, 25 Jun 2026 02:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782356266; cv=none; b=cvAzcHqKlRZ+y8JrAIXHeNQq5iOKyjfVXhwiCdU8lpOXr3z1l1HLFOyq6WDWNlp3m1dOjBHOj//cZpioKAba/a7kYQKRSUX6GBYKawA1m5KWR4ZwJzlXo7sxvguVBVyceU+5eyE6U3TzQHP2RZR/OZLNZ6uAoE96YQu/CO6lwVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782356266; c=relaxed/simple;
	bh=+2BaVSRcmfKPFyAkrMMcMTaSPgyr5m4hwjQOUV1tuXc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=d37MlKDQUjHITtExWmwQf4iI2sEgLRgKbd6Kd8AjZZIVBlX94f9TicQay4lL7dwktfglAS+Or+xQUZPw9AUeAZ43P+TnS3FBzLiCaCHdBmqCGg0BRcJArTVQrBOq26Ttt7plsHbQPDidNJeDa9MwMgK9yqaC7Qg82DmPk0rteW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jJnEy7CN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jJnEy7CN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEABB1F000E9;
	Thu, 25 Jun 2026 02:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782356265;
	bh=+CQEh/h3ctyid1Zt6PFqXUhg8V5QGLVmjzIWJD0rmVU=;
	h=From:To:Cc:Subject:Date;
	b=jJnEy7CNSEDx49IHTxZ4hjWBtgeCPMMh2+pW7RcE9e+8Af373X6QJaW24JNbPi7Wv
	 2KruFq2N2YIRht8iRCZTtwBCF6ZbdgzG3z44QeRLzi1M0IfHwyU+3bFLnIlxBxmsWP
	 1XUcOoQ+uMy0JNT4RTf3jNgG5yyOr/9OEaBn67cS+4N3UAtNOvHPunO6iE636O2kOd
	 2Nb8v2TwL5gOhi8xE0IdHrkZq1oGPE//WHfKnpC44UMY/fzozP7Me89mxdgY1uHiul
	 H92vdddPhB1E7yXer6tiWQjtNYF0xwwlAjo5Tg+TMW+Iv4XgR5QgL9DFvrknxGSTat
	 htzAtOsP3ltbQ==
From: Yu Kuai <yukuai@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>,
	Zheng Qixing <zhengqixing@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Tang Yizhou <yizhou.tang@shopee.com>,
	Yu Kuai <yukuai@fygo.io>,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] blk-cgroup: fix blkg list and policy data races
Date: Thu, 25 Jun 2026 10:57:35 +0800
Message-ID: <20260625025739.2459651-1-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

Hi,

This series fixes races around q->blkg_list and blkg policy data
lifetime.

Patch 1 protects blkg_destroy_all()'s q->blkg_list walk with
blkcg_mutex.

Patches 2-3 fix races between blkcg_activate_policy() and concurrent
blkg destruction.

Patch 4 factors the policy data teardown loop into a helper after the
race fixes.

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
