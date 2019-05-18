From: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Subject: Re: CFQ idling kills I/O performance on ext4 with blkio cgroup
 controller
Date: Sat, 18 May 2019 13:50:42 -0700
Message-ID: <46c6a4be-f567-3621-2e16-0e341762b828@csail.mit.edu>
References: <8d72fcf7-bbb4-2965-1a06-e9fc177a8938@csail.mit.edu>
 <1812E450-14EF-4D5A-8F31-668499E13652@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1812E450-14EF-4D5A-8F31-668499E13652@linaro.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Paolo Valente <paolo.valente@linaro.org>
Cc: linux-fsdevel@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, linux-ext4@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, jack@suse.cz, jmoyer@redhat.com, tytso@mit.edu, amakhalov@vmware.com, anishs@vmware.com, srivatsab@vmware.com

On 5/18/19 11:39 AM, Paolo Valente wrote:
> I've addressed these issues in my last batch of improvements for BFQ,
> which landed in the upcoming 5.2. If you give it a try, and still see
> the problem, then I'll be glad to reproduce it, and hopefully fix it
> for you.
>

Hi Paolo,

Thank you for looking into this!

I just tried current mainline at commit 72cf0b07, but unfortunately
didn't see any improvement:

dd if=/dev/zero of=/root/test.img bs=512 count=10000 oflag=dsync

With mq-deadline, I get:

5120000 bytes (5.1 MB, 4.9 MiB) copied, 3.90981 s, 1.3 MB/s

With bfq, I get:
5120000 bytes (5.1 MB, 4.9 MiB) copied, 84.8216 s, 60.4 kB/s

Please let me know if any more info about my setup might be helpful.

Thank you!

Regards,
Srivatsa
VMware Photon OS

> 
>> Il giorno 18 mag 2019, alle ore 00:16, Srivatsa S. Bhat <srivatsa@csail.mit.edu> ha scritto:
>>
>>
>> Hi,
>>
>> One of my colleagues noticed upto 10x - 30x drop in I/O throughput
>> running the following command, with the CFQ I/O scheduler:
>>
>> dd if=/dev/zero of=/root/test.img bs=512 count=10000 oflags=dsync
>>
>> Throughput with CFQ: 60 KB/s
>> Throughput with noop or deadline: 1.5 MB/s - 2 MB/s
>>
>> I spent some time looking into it and found that this is caused by the
>> undesirable interaction between 4 different components:
>>
>> - blkio cgroup controller enabled
>> - ext4 with the jbd2 kthread running in the root blkio cgroup
>> - dd running on ext4, in any other blkio cgroup than that of jbd2
>> - CFQ I/O scheduler with defaults for slice_idle and group_idle
>>
>>
>> When docker is enabled, systemd creates a blkio cgroup called
>> system.slice to run system services (and docker) under it, and a
>> separate blkio cgroup called user.slice for user processes. So, when
>> dd is invoked, it runs under user.slice.
>>
>> The dd command above includes the dsync flag, which performs an
>> fdatasync after every write to the output file. Since dd is writing to
>> a file on ext4, jbd2 will be active, committing transactions
>> corresponding to those fdatasync requests from dd. (In other words, dd
>> depends on jdb2, in order to make forward progress). But jdb2 being a
>> kernel thread, runs in the root blkio cgroup, as opposed to dd, which
>> runs under user.slice.
>>
>> Now, if the I/O scheduler in use for the underlying block device is
>> CFQ, then its inter-queue/inter-group idling takes effect (via the
>> slice_idle and group_idle parameters, both of which default to 8ms).
>> Therefore, everytime CFQ switches between processing requests from dd
>> vs jbd2, this 8ms idle time is injected, which slows down the overall
>> throughput tremendously!
>>
>> To verify this theory, I tried various experiments, and in all cases,
>> the 4 pre-conditions mentioned above were necessary to reproduce this
>> performance drop. For example, if I used an XFS filesystem (which
>> doesn't use a separate kthread like jbd2 for journaling), or if I dd'ed
>> directly to a block device, I couldn't reproduce the performance
>> issue. Similarly, running dd in the root blkio cgroup (where jbd2
>> runs) also gets full performance; as does using the noop or deadline
>> I/O schedulers; or even CFQ itself, with slice_idle and group_idle set
>> to zero.
>>
>> These results were reproduced on a Linux VM (kernel v4.19) on ESXi,
>> both with virtualized storage as well as with disk pass-through,
>> backed by a rotational hard disk in both cases. The same problem was
>> also seen with the BFQ I/O scheduler in kernel v5.1.
>>
>> Searching for any earlier discussions of this problem, I found an old
>> thread on LKML that encountered this behavior [1], as well as a docker
>> github issue [2] with similar symptoms (mentioned later in the
>> thread).
>>
>> So, I'm curious to know if this is a well-understood problem and if
>> anybody has any thoughts on how to fix it.
>>
>> Thank you very much!
>>
>>
>> [1]. https://lkml.org/lkml/2015/11/19/359
>>
>> [2]. https://github.com/moby/moby/issues/21485
>>     https://github.com/moby/moby/issues/21485#issuecomment-222941103
>>
>> Regards,
>> Srivatsa
> 

