From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH -next 0/4] block/rq_qos: protect rq_qos apis with global mutex
Date: Wed,  4 Jan 2023 16:53:50 +0800
Message-ID: <20230104085354.2343590-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, hch@infradead.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com, yangerkun@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

This patchset is a new version, use a different solution suggested by
Tejun in [1].

[1] https://lore.kernel.org/all/Y6DP3aOSad8+D1yY@slm.duckdns.org/

Yu Kuai (4):
  block/rq_qos: move implementions of init/exit rq-qos apis to
    blk-rq-qos.c
  block/rq_qos: factor out a helper to add rq_qos and activate policy
  block/rq_qos: use a global mutex to protect rq_qos apis
  block/rq_qos: fail rq_qos_add() after rq_qos_exit()

 block/blk-iocost.c    |  14 +----
 block/blk-iolatency.c |   7 +--
 block/blk-rq-qos.c    | 118 ++++++++++++++++++++++++++++++++++++++++--
 block/blk-rq-qos.h    |  69 +++---------------------
 4 files changed, 125 insertions(+), 83 deletions(-)

-- 
2.31.1

