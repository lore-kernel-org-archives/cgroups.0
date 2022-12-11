From: Waiman Long <longman@redhat.com>
Subject: [PATCH-block v2 0/3] blk-cgroup: Fix potential UAF & miscellaneous cleanup
Date: Sun, 11 Dec 2022 17:20:55 -0500
Message-ID: <20221211222058.2946830-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670797276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pSMLLAxVMXnoWPwPea+ElcFQc/uDEfReQyP/onbm6ts=;
        b=Yx8PRi6/WCqBSS+vFv3eG+d+RJgsaiajZtz1pWe3TZwzgumByBh21XouIQ4dWkd9ahNqMz
        3XghyUKqP2wWVWqAapLuiSrLpAct7xqG6E8+a9yi9YlxzJqN14X14oV8AcZaVeZ550mfso
        a09mg/BKFXmPhugHwbZqVYmwxIWk3aw=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, Waiman Long <longman@redhat.com>

 v2:
  - Remove unnecessary rcu_read_{lock|unlock} from
    cgroup_rstat_css_cpu_flush() in patch 3.

It was found that blkcg_destroy_blkgs() may be called with all blkcg
references gone. This may potentially cause user-after-free and so
should be fixed. The last 2 patches are miscellaneous cleanups of
commit 3b8cc6298724 ("blk-cgroup: Optimize blkcg_rstat_flush()").

Waiman Long (3):
  bdi, blk-cgroup: Fix potential UAF of blkcg
  blk-cgroup: Don't flush a blkg if destroyed
  blk-cgroup: Flush stats at blkgs destruction path

 block/blk-cgroup.c     | 26 ++++++++++++++++++++++++++
 include/linux/cgroup.h |  1 +
 kernel/cgroup/rstat.c  | 18 ++++++++++++++++++
 mm/backing-dev.c       |  8 ++++++--
 4 files changed, 51 insertions(+), 2 deletions(-)

-- 
2.31.1

