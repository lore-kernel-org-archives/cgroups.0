From: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 0/3] Charge loop device i/o to issuing cgroup
Date: Thu, 20 Feb 2020 11:51:50 -0500
Message-ID: <cover.1582216294.git.schatzberg.dan@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6XRtdyMfa57xpaqGTGErpzosHOBJSLkhLdrjsJIgZOk=;
        b=GMVJvohK6Uqosdx++Q1UIJDcIwc443iVBHapmNkU3PGw0Gp/Zvb4sb4UC5bp2Vqnjh
         3CNcPOyt+wKRKUoubWndo5lXBiYketttaeW/0TFZNT506r2ehW2MDLqDwKxIN4eTRL6l
         Bbe/9ss0aC0grEW3nn0C41VmK4UZ0iE4dj4Z897q8UHKgHY2T1n9bsgu9G2OYcIDvx+B
         u5klU2+Lw4xtVQXGaop6kWnEt+i2w3JLr/ZPKKBW51NDmVrAy3ZO3uQda80EIss6Qyv+
         H/1orrfd8yQMyvriQ2xSQnzBmiCfFYpDXHVpOfkmdv3fLAt2kdPWJQVF2RC+gEgheTWP
         kuGQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 
Cc: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "open list:BLOCK LAYER" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP CGROUP" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE
        CONTROLLER MEMCG" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

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

 drivers/block/loop.c       | 229 +++++++++++++++++++++++++++++++------
 drivers/block/loop.h       |  14 ++-
 include/linux/memcontrol.h |   6 +
 kernel/cgroup/cgroup.c     |   1 +
 mm/memcontrol.c            |  11 +-
 mm/shmem.c                 |   2 +-
 6 files changed, 217 insertions(+), 46 deletions(-)

-- 
2.17.1

