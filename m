From: Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: [PATCH v10 0/3] Charge loop device i/o to issuing cgroup
Date: Tue, 16 Mar 2021 08:36:49 -0700
Message-ID: <20210316153655.500806-1-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Tkj0ia5hpCZDucubv8I4sizyR82LNTriAr2vMPAQj/E=;
        b=fmqt1PM3c9r4ycT0+M0peIYt0t0qYLcjBuaENLbx/bgURKlepe0/DFmwjyLv+NL1Bp
         6BU8XJAV59vNYUVC9nXjmBpPTRRNCP/CTiplDVoETJt9qLIDRkS7W2GRQKQczjlEU/yv
         NJ5y4i+hWh9cJyzwXPEsmB19k3cNXI7y8h4SyZmhZdnIIvSKoXFtqiMXn54u107oblhr
         qN9rTSkdIoB3UUciSVvUOqZeHFgmPwkCL456MECrA54N5VUoh3QnQqHqs+k3d4jOldwF
         cDzQ8oeLbXMQ+chuTZxAdS2KeMuB9lkB40aYVhq36Gfdj2n4zSKFXWJ4ANDmsMvl60rK
         qCuw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Hugh Dickins <hughd@google.com>, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <guro@fb.com>, Muchun Song <songmuchun@bytedance.com>, Alex Shi <alex.shi@linux.alibaba.com>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Chris Down <chris@chrisdown.name>, Yafang Shao <laoar.shao@gmail.com>, Wei Yang <richard.weiyang@gmail.com>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP CGROUP" <cgroups@vger.kernel.org>, linux-

No major changes, just rebasing and resubmitting

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

 drivers/block/loop.c       | 248 ++++++++++++++++++++++++++++++-------
 drivers/block/loop.h       |  15 ++-
 include/linux/memcontrol.h |  11 ++
 kernel/cgroup/cgroup.c     |   1 +
 mm/filemap.c               |   2 +-
 mm/memcontrol.c            |  15 ++-
 mm/shmem.c                 |   4 +-
 7 files changed, 242 insertions(+), 54 deletions(-)

-- 
2.30.2

