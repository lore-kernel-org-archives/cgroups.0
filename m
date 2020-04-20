From: Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: [PATCH 0/4] Charge loop device i/o to issuing cgroup
Date: Mon, 20 Apr 2020 18:39:28 -0400
Message-ID: <20200420223936.6773-1-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DYVGKptuNao3T/Cw5MVydseWWvnB3P8P6bY7urNsYE4=;
        b=ZTvAXfQirkhPYwWin4gaTNuQ42l+Obs3whqemoax3hucfHKWlC19ImBWdeBO0MYz9S
         KrjfYP5kNdW+Sg5lblu5swpCyPtMN/naDZ2SlCHqd+5jkTR7aMofBNTfCBzhFPcxS3TB
         tbPix1/O9HErM8CNUqIyTj8QqgF3AO4ZCfjCAKlc3HLIj5a0cYQ68ebLK8yX3baCZihs
         L0iJTd31iGBMC91rn/1DaFPSOakptQYq5ZT5FC16X+JZTM2GMDNsZ34n93sI1+2FybVF
         NxG/Rqg8po4ejbaExawn8ZKMfICTrgTxHOBJOAGW85lEjsUcfSf9AgItY4xRQvkI+Nm+
         dpNQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 
Cc: Dan Schatzberg <schatzberg.dan@gmail.com>, Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Yang Shi <yang.shi@linux.alibaba.com>, Ingo Molnar <mingo@kernel.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx>

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

Dan Schatzberg (4):
  loop: Use worker per cgroup instead of kworker
  mm: support nesting memalloc_use_memcg()
  mm: Charge active memcg when no mm is set
  loop: Charge i/o to mem and blk cg

 drivers/block/loop.c                 | 246 ++++++++++++++++++++++-----
 drivers/block/loop.h                 |  14 +-
 fs/buffer.c                          |   6 +-
 fs/notify/fanotify/fanotify.c        |   5 +-
 fs/notify/inotify/inotify_fsnotify.c |   5 +-
 include/linux/memcontrol.h           |   6 +
 include/linux/sched/mm.h             |  28 +--
 kernel/cgroup/cgroup.c               |   1 +
 mm/memcontrol.c                      |  11 +-
 mm/shmem.c                           |   4 +-
 10 files changed, 246 insertions(+), 80 deletions(-)

-- 
2.24.1

