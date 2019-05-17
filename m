From: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Subject: CFQ idling kills I/O performance on ext4 with blkio cgroup controller
Date: Fri, 17 May 2019 15:16:01 -0700
Message-ID: <8d72fcf7-bbb4-2965-1a06-e9fc177a8938@csail.mit.edu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-ext4@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, paolo.valente@linaro.org, jack@suse.cz, jmoyer@redhat.com, tytso@mit.edu, amakhalov@vmware.com, anishs@vmware.com, srivatsab@vmware.com, "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>


Hi,

One of my colleagues noticed upto 10x - 30x drop in I/O throughput
running the following command, with the CFQ I/O scheduler:

dd if=/dev/zero of=/root/test.img bs=512 count=10000 oflags=dsync

Throughput with CFQ: 60 KB/s
Throughput with noop or deadline: 1.5 MB/s - 2 MB/s

I spent some time looking into it and found that this is caused by the
undesirable interaction between 4 different components:

- blkio cgroup controller enabled
- ext4 with the jbd2 kthread running in the root blkio cgroup
- dd running on ext4, in any other blkio cgroup than that of jbd2
- CFQ I/O scheduler with defaults for slice_idle and group_idle


When docker is enabled, systemd creates a blkio cgroup called
system.slice to run system services (and docker) under it, and a
separate blkio cgroup called user.slice for user processes. So, when
dd is invoked, it runs under user.slice.

The dd command above includes the dsync flag, which performs an
fdatasync after every write to the output file. Since dd is writing to
a file on ext4, jbd2 will be active, committing transactions
corresponding to those fdatasync requests from dd. (In other words, dd
depends on jdb2, in order to make forward progress). But jdb2 being a
kernel thread, runs in the root blkio cgroup, as opposed to dd, which
runs under user.slice.

Now, if the I/O scheduler in use for the underlying block device is
CFQ, then its inter-queue/inter-group idling takes effect (via the
slice_idle and group_idle parameters, both of which default to 8ms).
Therefore, everytime CFQ switches between processing requests from dd
vs jbd2, this 8ms idle time is injected, which slows down the overall
throughput tremendously!

To verify this theory, I tried various experiments, and in all cases,
the 4 pre-conditions mentioned above were necessary to reproduce this
performance drop. For example, if I used an XFS filesystem (which
doesn't use a separate kthread like jbd2 for journaling), or if I dd'ed
directly to a block device, I couldn't reproduce the performance
issue. Similarly, running dd in the root blkio cgroup (where jbd2
runs) also gets full performance; as does using the noop or deadline
I/O schedulers; or even CFQ itself, with slice_idle and group_idle set
to zero.

These results were reproduced on a Linux VM (kernel v4.19) on ESXi,
both with virtualized storage as well as with disk pass-through,
backed by a rotational hard disk in both cases. The same problem was
also seen with the BFQ I/O scheduler in kernel v5.1.

Searching for any earlier discussions of this problem, I found an old
thread on LKML that encountered this behavior [1], as well as a docker
github issue [2] with similar symptoms (mentioned later in the
thread).

So, I'm curious to know if this is a well-understood problem and if
anybody has any thoughts on how to fix it.

Thank you very much!


[1]. https://lkml.org/lkml/2015/11/19/359

[2]. https://github.com/moby/moby/issues/21485
     https://github.com/moby/moby/issues/21485#issuecomment-222941103

Regards,
Srivatsa
