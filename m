Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519C218C33;
	Tue,  3 Feb 2026 08:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770105968; cv=none; b=dx/Y4ZxVrhjuSou6fUhq/SDAf1qkeJjWeYpQGWu1l5kLqLgqbKtwGoU8J4Dv4DNj97TNebRbCSx56DafmAeVrbeK/M2HxZfrmT8JtDwqg07pMrSE+jE4pwS3PnAT19LRJ8o6K5Awag8V6apNtWnU8JSIfPukwlXs+iVNvpsFXOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770105968; c=relaxed/simple;
	bh=A09B8MfOT+dT0aBZb6H28ukKLoLIzfx3LwL7sefAs+s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TCJKFWa30UBx8flYCv63Phm7HBgUhRyRWwKxOvrbsbQDa5AT04U27qoZWiFSswev14EYlkgAR3j3mU/GITdM0WBLavV7Db5N79dTzmsxai+u1jw77ga1+T6Ye1lYAotC093tFcm0gURE9H054PxUxSJs7E9QWKVz1DOZmuEnCB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BE6C116D0;
	Tue,  3 Feb 2026 08:06:04 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: tj@kernel.org,
	josef@toxicpanda.com,
	axboe@kernel.dk
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai@fnnas.com,
	zhengqixing@huawei.com,
	mkoutny@suse.com,
	hch@infradead.org,
	ming.lei@redhat.com,
	nilay@linux.ibm.com
Subject: [PATCH v2 0/7] blk-cgroup: fix races and deadlocks
Date: Tue,  3 Feb 2026 16:05:55 +0800
Message-ID: <20260203080602.726505-1-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Changes in v2:
 - check dying blkg early in patch 4;
 - add patch 7 to fix rq_qos_mutex related deadlocks;

This series fixes race conditions between blkcg_activate_policy() and
blkg destruction, and optimizes the policy activation path.

Patches 1-2 add missing blkcg_mutex protection for q->blkg_list iteration.

Patches 3-5 from Zheng Qixing fix use-after-free and memory leak issues
caused by races between policy activation and blkg destruction.

Patch 6 restructures blkcg_activate_policy() to allocate pds before
freezing the queue. This is a prep patch to fix deadlocks related to
percpu allocation with queue frozen, since some policies like iocost
and iolatency do percpu allocation in pd_alloc_fn().

Patch 7 reduces freeze queue contex by moving rq_qos_mutex into
rq_qos_add/del, so that allocate memory without queue frozen.

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

 block/bfq-cgroup.c  |   3 +-
 block/bfq-iosched.c |   2 +
 block/blk-cgroup.c  | 200 ++++++++++++++------------------------------
 block/blk-cgroup.h  |   2 -
 block/blk-iocost.c  |  11 +--
 block/blk-rq-qos.c  |  31 ++++---
 block/blk-wbt.c     |   2 -
 7 files changed, 90 insertions(+), 161 deletions(-)

-- 
2.51.0

