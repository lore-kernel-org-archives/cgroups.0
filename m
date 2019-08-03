From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET] writeback, memcg: Implement foreign inode flushing
Date: Sat,  3 Aug 2019 07:01:51 -0700
Message-ID: <20190803140155.181190-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=AiTM5WxUhwBn/0+fPLrU4NXRLZPLKnlQS1xIhWaJzpg=;
        b=tfT01MLuJKUwtU61ZxhKrZL6uuTYcpg4nXhf60oe0IrgWdG+XWg7SytG8ERsq3bvX8
         A+e4WnbVDrMQxtUgmUCHknAGfXaYg+2CxcWZ2ZbT6n7dMSHoxs5u/cz8JXmfAqH/cBPt
         aXnpRRuUe2fQtDlx3L2JHIJwPUaNpVX5L6s+NZ/q9HjqbhhbPhoSd680vE+8vvxS8y8K
         /IjAIxVBjB2wm3P06AH/7CgQgSjnsSyc9euHSKr9iuS17mANP+9NnfW22gTMHIt/RGwY
         PQ2chv1aMEKUWdBpJywMQP3q7/mQrd3UQdDY+QtZLHmq3nSvFRpZdaBN1SmpQ5Ar2/IC
         tE3A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk, jack@suse.cz, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, guro@fb.com, akpm@linux-foundation.org

Hello,

There's an inherent mismatch between memcg and writeback.  The former
trackes ownership per-page while the latter per-inode.  This was a
deliberate design decision because honoring per-page ownership in the
writeback path is complicated, may lead to higher CPU and IO overheads
and deemed unnecessary given that write-sharing an inode across
different cgroups isn't a common use-case.

Combined with inode majority-writer ownership switching, this works
well enough in most cases but there are some pathological cases.  For
example, let's say there are two cgroups A and B which keep writing to
different but confined parts of the same inode.  B owns the inode and
A's memory is limited far below B's.  A's dirty ratio can rise enough
to trigger balance_dirty_pages() sleeps but B's can be low enough to
avoid triggering background writeback.  A will be slowed down without
a way to make writeback of the dirty pages happen.

This patchset implements foreign dirty recording and foreign mechanism
so that when a memcg encounters a condition as above it can trigger
flushes on bdi_writebacks which can clean its pages.  Please see the
last patch for more details.

This patchset contains the following four patches.

 0001-writeback-Generalize-and-expose-wb_completion.patch
 0002-bdi-Add-bdi-id.patch
 0003-writeback-memcg-Implement-cgroup_writeback_by_id.patch
 0004-writeback-memcg-Implement-foreign-dirty-flushing.patch

0001-0003 are prep patches which expose wb_completion and implement
bdi->id and flushing by bdi and memcg IDs.

0004 implement foreign inode flushing.

Thanks.  diffstat follows.

 fs/fs-writeback.c                |  111 ++++++++++++++++++++++++----------
 include/linux/backing-dev-defs.h |   23 +++++++
 include/linux/backing-dev.h      |    3 
 include/linux/memcontrol.h       |   35 ++++++++++
 include/linux/writeback.h        |    4 +
 mm/backing-dev.c                 |   65 +++++++++++++++++++-
 mm/memcontrol.c                  |  125 +++++++++++++++++++++++++++++++++++++++
 mm/page-writeback.c              |    4 +
 8 files changed, 335 insertions(+), 35 deletions(-)

--
tejun

