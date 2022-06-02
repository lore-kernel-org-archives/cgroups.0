From: Waiman Long <longman@redhat.com>
Subject: [PATCH v5 0/3] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Thu,  2 Jun 2022 09:35:40 -0400
Message-ID: <20220602133543.128088-1-longman@redhat.com>
References: <20220601211824.89626-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654176955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RM/VM/BkJCFXBDQbLQtl/dczfhsVjGbr9q7yL7pUo/s=;
        b=QA/3Iap+GlzPb876wRGr6EHw9SD6QlDq2FIwoJOtwx65w8Wu4ysUkDMqBy59qpAvE9NPnP
        wY/xmq3PH2ZbCWSwIV04kstp3mLomGRFiXzHBYYDmv2l7pSWwhWqMuW5Lec3v8fAZ61Sbh
        Gs2l5xoJtxZZCciMoHigM+zLk1Y6v7U=
In-Reply-To: <20220601211824.89626-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Waiman Long <longman@redhat.com>

 v5:
  - Add a new patch 2 to eliminate the use of intermediate "ret"
    variable in blkcg_css_alloc() to fix compilation warning reported
    by kernel test robot.

 v4:
  - Update comment and eliminate "inline" keywords as suggested by TJ.

 v3:
  - Update comments in patch 2.
  - Put rcu_read_lock/unlock() in blkcg_rstat_flush().
  - Use READ_ONCE/WRITE_ONCE() to access lnode->next to reduce data
    races.
  - Get a blkg reference when putting into the lockless list and put it
    back when removed.
 
This patch series improves blkcg_rstat_flush() performance by eliminating
unnecessary blkg enumeration and flush operations for those blkg's and
blkg_iostat_set's that haven't been updated since the last flush.

Waiman Long (3):
  blk-cgroup: Correctly free percpu iostat_cpu in blkg on error exit
  blk-cgroup: Return -ENOMEM directly in blkcg_css_alloc() error path
  blk-cgroup: Optimize blkcg_rstat_flush()

 block/blk-cgroup.c | 103 ++++++++++++++++++++++++++++++++++++++-------
 block/blk-cgroup.h |   9 ++++
 2 files changed, 96 insertions(+), 16 deletions(-)

-- 
2.31.1

