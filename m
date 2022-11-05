From: Waiman Long <longman@redhat.com>
Subject: [PATCH v10 0/3] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Fri,  4 Nov 2022 20:58:59 -0400
Message-ID: <20221105005902.407297-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667609965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CCZSaJ900ZMJsX6FSPePp5c1TELOc3F+zYif5LY5DHo=;
        b=HLo3xYfH7MFfDKWhSY8QVN5rJ8ETrW6w3BJJ6MBVWGMssnVuK5tcJdXStpICq60U/pigO1
        7wcuRDhuXnDAyyTwOaD2TxPmYwDH673Mb8Uj4R2lrkTmwYJDsPzqk3uJ2vqpbkbDxU7jUi
        OXozWix9JgkWcz+o9WmG6p5dR2GwQKc=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Hillf Danton <hdanton@sina.com>, Waiman Long <longman@redhat.com>

 v10:
  - Update patch 3 to rename the rstat function to
    cgroup_rstat_css_cpu_flush().

 v9:
  - Remove patch "llist: Allow optional sentinel node terminated lockless
    list" for now. This will be done as a follow-up patch.
  - Add a new lqueued field to blkg_iostat_set to store the status of
    whether lnode is in a lockless list.
  - Add a new patch 3 to speed up the freeing of blkcg by flushing out
    the rstat lockless lists at blkcg offline time.

 v8:
  - Update the llist patch to make existing llist functions and macros
    work for both NULL and sentinel terminated lockless list as much
    as possible and leave only the initialization and removal functions
    to have a sentinel terminated llist variants.

This patch series improves blkcg_rstat_flush() performance by eliminating
unnecessary blkg enumeration and flush operations for those blkg's and
blkg_iostat_set's that haven't been updated since the last flush.

Waiman Long (3):
  blk-cgroup: Return -ENOMEM directly in blkcg_css_alloc() error path
  blk-cgroup: Optimize blkcg_rstat_flush()
  blk-cgroup: Flush stats at blkgs destruction path

 block/blk-cgroup.c     | 103 +++++++++++++++++++++++++++++++++++------
 block/blk-cgroup.h     |  10 ++++
 include/linux/cgroup.h |   1 +
 kernel/cgroup/rstat.c  |  20 ++++++++
 4 files changed, 119 insertions(+), 15 deletions(-)

-- 
2.31.1

