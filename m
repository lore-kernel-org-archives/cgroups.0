From: Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: [PATCH V12 0/3] Charge loop device i/o to issuing cgroup
Date: Fri,  2 Apr 2021 12:16:31 -0700
Message-ID: <20210402191638.3249835-1-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LnxM2dCsgefp2lTqtmiMsTgHl3EHT3phtkcM0CuctsU=;
        b=sexUDEANAJW6Wcofc3gTufIIY3OVzBHVz66e60XJSMOYq0momOVoT1/oSTROjNQAyO
         D8/s6Joupk3LV08oTkklRtksM5DRiYMbzCopEdPBUGrn8O3zoOAipt71aFRGv2ZanlBl
         vO2GozZTnPskqZfhgTlFk95cwMNQU+m339bV7RkCZSySqCTRmQHot0CU2gqFG66di69J
         NLYQSNDERUfyzQHXHoVwSYJHd/ZLxBf5wdfiYR1w8ySfWzTwxxMx3ryHMA+WgOWaXbWQ
         HhzFx3Yldxiyuf0WWLuAGodViVzYnMi84D2KpIbOaqfNTgwTJ/LjUaGqp4slRUQ2cuam
         kDig==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Hugh Dickins <hughd@google.com>, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <guro@fb.com>, Muchun Song <songmuchun@bytedance.com>, Yang Shi <shy828301@gmail.com>, Alex Shi <alex.shi@linux.alibaba.com>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Wei Yang <richard.weiyang@gmail.com>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP CGROUP" <cgroups@vger.kernel.org>, "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>

No major changes, rebased on top of latest mm tree

Changes since V12:

* Small change to get_mem_cgroup_from_mm to avoid needing
  get_active_memcg

Changes since V11:

* Removed WQ_MEM_RECLAIM flag from loop workqueue. Technically, this
  can be driven by writeback, but this was causing a warning in xfs
  and likely other filesystems aren't equipped to be driven by reclaim
  at the VFS layer.
* Included a small fix from Colin Ian King.
* reworked get_mem_cgroup_from_mm to institute the necessary charge
  priority.

Changes since V10:

* Added page-cache charging to mm: Charge active memcg when no mm is set

Changes since V9:

* Rebased against linus's branch which now includes Roman Gushchin's
  patch this series is based off of

Changes since V8:

* Rebased on top of Roman Gushchin's patch
  (https://lkml.org/lkml/2020/8/21/1464) which provides the nesting
  support for setting active memcg. Dropped the patch from this series
  that did the same thing.

Changes since V7:

* Rebased against linus's branch

Changes since V6:

* Added separate spinlock for worker synchronization
* Minor style changes

Changes since V5:

* Fixed a missing css_put when failing to allocate a worker
* Minor style changes

Changes since V4:

Only patches 1 and 2 have changed.

* Fixed irq lock ordering bug
* Simplified loop detach
* Added support for nesting memalloc_use_memcg

Changes since V3:

* Fix race on loop device destruction and deferred worker cleanup
* Ensure charge on shmem_swapin_page works just like getpage
* Minor style changes

Changes since V2:

* Deferred destruction of workqueue items so in the common case there
  is no allocation needed

Changes since V1:

* Split out and reordered patches so cgroup charging changes are
  separate from kworker -> workqueue change

* Add mem_css to struct loop_cmd to simplify logic

The loop device runs all i/o to the backing file on a separate kworker
thread which results in all i/o being charged to the root cgroup. This
allows a loop device to be used to trivially bypass resource limits
and other policy. This patch series fixes this gap in accounting.

A simple script to demonstrate this behavior on cgroupv2 machine:

'''
#!/bin/bash
set -e

CGROUP=/sys/fs/cgroup/test.slice
LOOP_DEV=/dev/loop0

if [[ ! -d $CGROUP ]]
then
    sudo mkdir $CGROUP
fi

grep oom_kill $CGROUP/memory.events

# Set a memory limit, write more than that limit to tmpfs -> OOM kill
sudo unshare -m bash -c "
echo \$\$ > $CGROUP/cgroup.procs;
echo 0 > $CGROUP/memory.swap.max;
echo 64M > $CGROUP/memory.max;
mount -t tmpfs -o size=512m tmpfs /tmp;
dd if=/dev/zero of=/tmp/file bs=1M count=256" || true

grep oom_kill $CGROUP/memory.events

# Set a memory limit, write more than that limit through loopback
# device -> no OOM kill
sudo unshare -m bash -c "
echo \$\$ > $CGROUP/cgroup.procs;
echo 0 > $CGROUP/memory.swap.max;
echo 64M > $CGROUP/memory.max;
mount -t tmpfs -o size=512m tmpfs /tmp;
truncate -s 512m /tmp/backing_file
losetup $LOOP_DEV /tmp/backing_file
dd if=/dev/zero of=$LOOP_DEV bs=1M count=256;
losetup -D $LOOP_DEV" || true

grep oom_kill $CGROUP/memory.events
'''

Naively charging cgroups could result in priority inversions through
the single kworker thread in the case where multiple cgroups are
reading/writing to the same loop device. This patch series does some
minor modification to the loop driver so that each cgroup can make
forward progress independently to avoid this inversion.

With this patch series applied, the above script triggers OOM kills
when writing through the loop device as expected.

Dan Schatzberg (3):
  loop: Use worker per cgroup instead of kworker
  mm: Charge active memcg when no mm is set
  loop: Charge i/o to mem and blk cg

 drivers/block/loop.c       | 244 ++++++++++++++++++++++++++++++-------
 drivers/block/loop.h       |  15 ++-
 include/linux/memcontrol.h |   6 +
 kernel/cgroup/cgroup.c     |   1 +
 mm/filemap.c               |   2 +-
 mm/memcontrol.c            |  49 +++++---
 mm/shmem.c                 |   4 +-
 7 files changed, 253 insertions(+), 68 deletions(-)

-- 
2.30.2

