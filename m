From: Martin Boutin <martboutin@gmail.com>
Subject: cgroups-blkio CFQ scheduling does not work well in a RAID5 configuration.
Date: Fri, 29 Nov 2013 09:06:08 -0500
Message-ID: <CACtJ3Hak1pvYLRDSC3MELeo_jV8_1Tp8rjte5SODyvNauoFv4g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-raid-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=wRDAnhZnCS+2NwHkdvzkl17KzQARvbDZAPY5qlLFAi4=;
        b=JJtIUIZ2QMq6k88M7ivuimGfFGoXszgPAoWNrkVqmPpnxOIWJvhfF3yggOYPdhxJ6O
         jO1Q755nAv+adpT9dFI6aEWvDeGXJVf8wBYlkMgTeMavj3BtcMJfj1nv++qA/JdRA+yG
         MoGB3tMaGjn3kZIcnA69fL88XjyJJwi4DE/eAVZz5aLBIDVL1cWuUZtXwj+WcuwYP7sM
         6GNRkPa404TaG+zQN6oRv8UrQ6RKRlMkafeUtGwukQGnDu3876OonKIe4z3cQ7QjUa7N
         6pjAZ5KZfoLcOAREV+Q1TuiCYHOGYGDZ1O9QN5JkozN8imJtKvogWYs8Wm78jC5sty68
         okkQ==
Sender: linux-raid-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, "Kernel.org-Linux-cgroups" <cgroups@vger.kernel.org>

Hello list,

Today I was trying to figure out how to get block I/O prioritization
working for a certain process. The process is a streaming server that
reads a big file stored in a filesystem (xfs) on top of a RAID5
configuration using 3 disks, using O_DIRECT.

I'm setting up cgroups this way:
$ echo 1000 > /sys/fs/cgroup/blkio/prio/blkio.weight
$ echo 10 > /sys/fs/cgroup/blkio/blkio.leaf_weight

meaning that all the tasks in the prio cgroup will have unconstrained
access time to the disk, while all the other tasks will have their
disk access time weighted by a factor.

If I ignore the RAID5 setup, create a XFS filesystem on /dev/sdb2,
mount it on /data and put my streaming daemon in the prio cgroup and
run the daemon by streaming around 250MiB/s of data, while I launch
fio with disk I/O intensive tasks. For a period of 5 minutes, the
streaming deamon had to stop streaming in about 5 times to rebuffer.

Now, if I consider the same scenario but using the RAID5 device and
letting the daemon stream 500MiB/s of data (because the RAID has
around twice the throughput of a single drive), after a period of 5
minutes the streaming daemon had to stop streaming in about 50 times!
This is 10 times more than the single drive case.

While streaming, I observed both blkio.sectors and blkio.io_queued for
both cgroups (the root node and prio). If only the streaming daemon is
run (therefore fio is stopped), the sector count in prio/blkio.sectors
increases while (root)/blkio.sectors does not. This confirms the
streaming daemon is correctly identified as in the prio cgroup.
Then, while both the streaming daemon and fio run, observing io_queued
shows that for the root cgroup there is about 50 queued request in
total (in average), while for the prio cgroup there is only one
ocasional delayed request from time to time.

$ uname -a
Linux haswell1 3.10.10 #9 SMP PREEMPT Fri Nov 29 11:38:20 CET 2013
i686 GNU/Linux

Any ideas?

Thanks,
-- 
Martin Boutin
