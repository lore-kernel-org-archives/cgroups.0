Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C0D2C21F8;
	Wed,  3 Jun 2026 13:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780493275; cv=none; b=spwJa2OtEM/hQL4E3Tgvp652OtJKNBfUK2Pq0I6pXuEtPtUa4rgL+uZbXrFLCsGEOtb1Qh6yr728W5GStfN5FuCCo4YNgM5WdoEDyv88tjFGLshuMNLMuEMJsyLRhU5cNU4+lypgCNdgo/3hmj0z/QozgKB0JbAEYAMzfIMeteI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780493275; c=relaxed/simple;
	bh=Tode6jzd2RHWnJg99+/egW5XlPIb2sKjlBLWEkFGGsM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Gj+w8kHnI5dWcGgy0FAAAGt4GeC4NthiuykCLSB3CuryKP9LvvXcWAp74vGFXjKMOkhkNJ2IsJ7r80MLQdWS3tlB2dHa2QauXr4X8sJj/Qc51xrXj0NK+2cROmwoHD9Gml4Ek21I0nuBb26XkoAoHvaUQhfzJ4R6V+hfJiIZ4p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277D21F00893;
	Wed,  3 Jun 2026 13:27:49 +0000 (UTC)
From: Yu Kuai <yukuai@fygo.io>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] blk-cgroup: fix blkg list and policy data races
Date: Wed,  3 Jun 2026 21:27:40 +0800
Message-ID: <cover.1780492756.git.yukuai@fygo.io>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This small series fixes races between blkg destruction, q->blkg_list
iteration, and blkcg policy activation.

The first two patches serialize q->blkg_list walks in blkg_destroy_all()
and BFQ writeback weight-raising teardown with blkcg_mutex. The next two
patches close policy activation races with concurrent blkg destruction,
including skipping blkgs that are already dying. The final patch factors
the common policy data teardown loop.

This uses blkcg_mutex rather than extending queue_lock coverage because
the races are about blkg list visibility and policy-data lifetime, not
request-queue dispatch state. blkg_free_workfn() already uses
blkcg_mutex to serialize policy-data freeing with policy deactivation
and removes blkgs from q->blkg_list only after that teardown. Taking the
same mutex around the remaining q->blkg_list walkers gives one sleepable
serialization point for blkg lifetime, avoids adding more queue_lock
nesting, and prepares the follow-up conversion that removes queue_lock
from blkcg list protection entirely.

Yu Kuai (2):
  blk-cgroup: protect q->blkg_list iteration in blkg_destroy_all() with
    blkcg_mutex
  bfq: protect q->blkg_list iteration in bfq_end_wr_async() with
    blkcg_mutex

Zheng Qixing (3):
  blk-cgroup: fix race between policy activation and blkg destruction
  blk-cgroup: skip dying blkg in blkcg_activate_policy()
  blk-cgroup: factor policy pd teardown loop into helper

 block/bfq-cgroup.c  |  3 ++-
 block/bfq-iosched.c |  6 +++++
 block/blk-cgroup.c  | 65 ++++++++++++++++++++++++---------------------
 3 files changed, 43 insertions(+), 31 deletions(-)

-- 
2.51.0
