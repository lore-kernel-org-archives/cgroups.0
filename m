Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25D036D9EB;
	Wed,  4 Mar 2026 07:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772609893; cv=none; b=bFAz363/PxGtaVck+j68e7IuPXLB+rQWU0k0ZKmtf2VL8qfnogYmtPaPfSH4N+oDtfVEApUAh807q8MPvyPb+/ztLLOPXpdAaiGnqQ8sj/cfTuRh0l4YOJbve/9hbd0rjKEld6PS8Nl7HkA4CONTpLXlmbNGFh+3Bn0LsPBiFzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772609893; c=relaxed/simple;
	bh=f1bpQYIZui21k5bgNFbVyOEc+yWnqPnJhdVlPA/la6M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=V6IK4k5VtM5e3rqTVTFeZXPeK782Epp+GL6TuXf2+FDEbfbkhPcCguWpLHtREOY9LiXHi6Bb+OpMGw/2Ly9S6WE2cgiEWfyyNyLK7xXxlZefyl1XD5b/s1hhci9ztjPaKwL27oF3TM6pVCa6aIED5yWBj83RRpEUsz3BSOxs8o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49943C19423;
	Wed,  4 Mar 2026 07:38:11 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zheng Qixing <zhengqixing@huawei.com>,
	Ming Lei <ming.lei@redhat.com>,
	Nilay Shroff <nilay@linux.ibm.com>
Subject: [PATCH v3 0/7] blk-cgroup: fix races related to blkg_list iteration
Date: Wed,  4 Mar 2026 15:38:01 +0800
Message-ID: <20260304073809.3438679-1-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series fixes several race conditions related to q->blkg_list iteration
and improves the locking around blkcg policy activation/deactivation.

Patch 1-2: Protect q->blkg_list iteration with blkcg_mutex in blkg_destroy_all()
and bfq_end_wr_async() to prevent races with blkg_free_workfn().

Patch 3-4: Fix use-after-free and memory leak issues in blkcg_activate_policy()
by extending blkcg_mutex coverage and skipping dying blkgs.

Patch 5: Refactor policy pd teardown into a helper function.

Patch 6: Restructure blkcg_activate_policy() to allocate pds before freezing
the queue, avoiding potential deadlocks from percpu allocation. Also fix
locking order in blkcg_deactivate_policy() to be consistent with
blkcg_activate_policy() (mutex -> freeze).

Patch 7: Move rq_qos_mutex handling inside rq_qos_add()/rq_qos_del() to
simplify the locking and eliminate potential deadlocks.

Note: queue_lock is still used in many places to protect queue blkg.
Future work is to convert it to blkcg_mutex entirely.

Changes v2 -> v3:
- Patch 2: Wrap mutex_lock/unlock with #ifdef CONFIG_BFQ_GROUP_IOSCHED to
  fix compile error when CONFIG_BLK_CGROUP is disabled.
- Patch 6: Fix locking order in blkcg_deactivate_policy() to match
  blkcg_activate_policy() (mutex -> freeze instead of freeze -> mutex).
- Patch 7: Remove stale lockdep_assert_held() in iolatency_set_limit().

Changes v1 -> v2:
- Link: https://lore.kernel.org/all/20260108014416.3656493-1-zhengqixing@huaweicloud.com/

Yu Kuai (4):
  blk-cgroup: protect q->blkg_list iteration in blkg_destroy_all() with
    blkcg_mutex
  bfq: protect q->blkg_list iteration in bfq_end_wr_async() with
    blkcg_mutex
  blk-cgroup: allocate pds before freezing queue in
    blkcg_activate_policy()
  blk-rq-qos: move rq_qos_mutex acquisition inside rq_qos_add/del

Zheng Qixing (3):
  blk-cgroup: fix race between policy activation and blkg destruction
  blk-cgroup: skip dying blkg in blkcg_activate_policy()
  blk-cgroup: factor policy pd teardown loop into helper

 block/bfq-cgroup.c    |   3 +-
 block/bfq-iosched.c   |   6 ++
 block/blk-cgroup.c    | 205 ++++++++++++++----------------------------
 block/blk-cgroup.h    |   2 -
 block/blk-iocost.c    |  11 +--
 block/blk-iolatency.c |   5 --
 block/blk-rq-qos.c    |  31 ++++---
 block/blk-wbt.c       |   2 -
 8 files changed, 97 insertions(+), 168 deletions(-)

-- 
2.51.0

