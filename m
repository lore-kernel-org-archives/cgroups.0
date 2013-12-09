From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: cgroups-blkio CFQ scheduling does not work well in a RAID5 configuration.
Date: Mon, 09 Dec 2013 14:50:28 -0600
Message-ID: <52A62D14.8020203@hardwarefreak.com>
References: <CACtJ3Hak1pvYLRDSC3MELeo_jV8_1Tp8rjte5SODyvNauoFv4g@mail.gmail.com>	<CACtJ3HZ7WdJX1i72jpfB9+QDZwa77MBFSxW1W=XZU81b=MNtJw@mail.gmail.com>	<CAGqmV7pPb-Gh=B_Cjv0Az+PBxTHtPX=ECqkvFdd2Ej-hTfLqOQ@mail.gmail.com> <CACtJ3HaU-N2O+JJQekKOvP3aLiMHvPJyubfO4-Qyny6_Mk62=w@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACtJ3HaU-N2O+JJQekKOvP3aLiMHvPJyubfO4-Qyny6_Mk62=w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Martin Boutin <martboutin@gmail.com>, CoolCold <coolthecold@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, "Kernel.org-Linux-cgroups" <cgroups@vger.kernel.org>

On 12/9/2013 3:05 AM, Martin Boutin wrote:
> Any thoughts here?

Your testing methodology is neither scientific nor thorough, and your
information is incomplete.  This may be why you're receiving no replies...

You suggest the problem is related to md because taking it out of the
loop shows "less breakage" of your streaming application.  However,
you're using XFS.  Thus this is applicable:

"As of kernel 3.2.12, the default i/o scheduler, CFQ, will defeat much
of the parallelization in XFS. "

http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E

It may simply be that the CFQ/XFS problem is manifesting itself more
prominently with md than single disk in your case.

Also, are you aligning XFS to the md geometry?  mkfs.xfs should have
aligned to md automatically but sometimes this may break.

I suggest testing with the deadline elevator.  I'd also suggest
benchmarking your disks individually and benchmarking the md0 RAID5
array and providing the results.  It's possible your RAID5 array is
actually performing slower than a single disk, but you don't know it
because you've not tested it.  What's your stripe_cache_size value?  The
default may be too low for your disks/array.  What is the configuration
of your RAID5 array?  Chunk size?

You said a single drive was streaming 250 MB/s.  That's impossible
unless you're using SSD.  If what you really meant is that you told your
streaming program to do 250MB/s then of course you'll get buffering as
the disks can't keep up with that rate, only about half that for a
single SATA drive.  You did not mention SSDs.  You didn't mention rust.
 You did not mention drive make/model/size.




> - Martin
> 
> On Sun, Dec 1, 2013 at 11:44 AM, CoolCold <coolthecold@gmail.com> wrote:
>> I hope Neil will shed some light here, interesting question.
>>
>>
>> On Fri, Nov 29, 2013 at 6:15 PM, Martin Boutin <martboutin@gmail.com> wrote:
>>>
>>> I forgot to suggest that this might have to do with md0_raid5 process.
>>> The process has to take care of RAID parity for both processes
>>> (streaming daemon and fio). By default it stays in the root cgroup
>>> which means that RAID-related I/O will be unprioritized even for
>>> processes in the prio cgroup, this might be introducing delays in the
>>> I/O.
>>> Otherwise I cannot put the md0_raid5 process in the prio cgroup either
>>> because that would have RAID-related I/O from all other processes
>>> stealing disk time from priority processes.
>>>
>>> On Fri, Nov 29, 2013 at 9:06 AM, Martin Boutin <martboutin@gmail.com>
>>> wrote:
>>>> Hello list,
>>>>
>>>> Today I was trying to figure out how to get block I/O prioritization
>>>> working for a certain process. The process is a streaming server that
>>>> reads a big file stored in a filesystem (xfs) on top of a RAID5
>>>> configuration using 3 disks, using O_DIRECT.
>>>>
>>>> I'm setting up cgroups this way:
>>>> $ echo 1000 > /sys/fs/cgroup/blkio/prio/blkio.weight
>>>> $ echo 10 > /sys/fs/cgroup/blkio/blkio.leaf_weight
>>>>
>>>> meaning that all the tasks in the prio cgroup will have unconstrained
>>>> access time to the disk, while all the other tasks will have their
>>>> disk access time weighted by a factor.
>>>>
>>>> If I ignore the RAID5 setup, create a XFS filesystem on /dev/sdb2,
>>>> mount it on /data and put my streaming daemon in the prio cgroup and
>>>> run the daemon by streaming around 250MiB/s of data, while I launch
>>>> fio with disk I/O intensive tasks. For a period of 5 minutes, the
>>>> streaming deamon had to stop streaming in about 5 times to rebuffer.
>>>>
>>>> Now, if I consider the same scenario but using the RAID5 device and
>>>> letting the daemon stream 500MiB/s of data (because the RAID has
>>>> around twice the throughput of a single drive), after a period of 5
>>>> minutes the streaming daemon had to stop streaming in about 50 times!
>>>> This is 10 times more than the single drive case.
>>>>
>>>> While streaming, I observed both blkio.sectors and blkio.io_queued for
>>>> both cgroups (the root node and prio). If only the streaming daemon is
>>>> run (therefore fio is stopped), the sector count in prio/blkio.sectors
>>>> increases while (root)/blkio.sectors does not. This confirms the
>>>> streaming daemon is correctly identified as in the prio cgroup.
>>>> Then, while both the streaming daemon and fio run, observing io_queued
>>>> shows that for the root cgroup there is about 50 queued request in
>>>> total (in average), while for the prio cgroup there is only one
>>>> ocasional delayed request from time to time.
>>>>
>>>> $ uname -a
>>>> Linux haswell1 3.10.10 #9 SMP PREEMPT Fri Nov 29 11:38:20 CET 2013
>>>> i686 GNU/Linux
>>>>
>>>> Any ideas?
>>>>
>>>> Thanks,
>>>> --
>>>> Martin Boutin
>>>
>>>
>>>
>>> --
>>> Martin Boutin
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>>
>> --
>> Best regards,
>> [COOLCOLD-RIPN]
> 
> 
> 
