From: Dawei Li <set_pte_at@outlook.com>
Subject: [PATCH 0/2] block: queue flag helpers and atomic refcnt impl
Date: Tue, 11 Oct 2022 22:52:44 +0800
Message-ID: <TYCP286MB2323C42B3A3E18F296A06D41CA239@TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2bBy9sw36qcFhorM+iNFTH7B/8r5UMCmWvqfteMHnNY=;
 b=VprE1niqM/yyyFASg7FZ5LpQ/EtljQ5ETMBGywkfftCclL4q/c1fTwqtJljtN7xTEpG2kDonDxP3cJ/ot6oP+tHfhlMPmuTHgbi/27TpZOgExCMGCcXBmlCJInGwJpx/A7/sfrPS6BA1h5rbgFxD+y/I41yA7Dy5imVjHOklK3uFGWRY6h1EczDnaXxwpg95Osbxiv6Ihl1WWq0s/FcfxWFkUTQLZ8Uv7m6qQaS9nur8kfA3HCkuy47D8JciDORcGtjFQsKni/BhFIKu5AzozOOefe+XLYgOabBOueHvNq57Q3qCvqF2cH7ii+XAIDKIS7tgRiLRu+ukDAO8LXhvIA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk, tj@kernel.org, paolo.valente@linaro.org
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Dawei Li <set_pte_at@outlook.com>

This patchset includes enhancement on block layer:
1. Complete missing blk_queue_xxx() helpers which is responsible
   for denoting whether an attribute of request queue is set.

2. Make the referene count of bfq_group/bfq_queue atomic.

Dawei Li (2):
  block: Add helper for queue_flags bit test
  block: Make refcnt of bfq_group/bfq_queue atomic

 block/bfq-cgroup.c     |  8 +++----
 block/bfq-iosched.c    | 54 ++++++++++++++++++++++--------------------
 block/bfq-iosched.h    |  6 ++---
 block/bfq-wf2q.c       |  6 ++---
 block/blk-core.c       |  7 +++---
 block/blk-mq-tag.c     |  8 +++----
 block/blk-mq.c         |  8 +++----
 block/blk-mq.h         |  2 +-
 block/blk-settings.c   |  2 +-
 block/blk-sysfs.c      | 12 +++++-----
 block/blk-timeout.c    |  2 +-
 block/blk-wbt.c        |  2 +-
 include/linux/blkdev.h | 19 +++++++++++----
 13 files changed, 71 insertions(+), 65 deletions(-)

-- 
2.25.1

