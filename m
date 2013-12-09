From: Martin Boutin <martboutin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cgroups-blkio CFQ scheduling does not work well in a RAID5 configuration.
Date: Mon, 9 Dec 2013 10:05:45 +0100
Message-ID: <CACtJ3HaU-N2O+JJQekKOvP3aLiMHvPJyubfO4-Qyny6_Mk62=w@mail.gmail.com>
References: <CACtJ3Hak1pvYLRDSC3MELeo_jV8_1Tp8rjte5SODyvNauoFv4g@mail.gmail.com>
	<CACtJ3HZ7WdJX1i72jpfB9+QDZwa77MBFSxW1W=XZU81b=MNtJw@mail.gmail.com>
	<CAGqmV7pPb-Gh=B_Cjv0Az+PBxTHtPX=ECqkvFdd2Ej-hTfLqOQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=qXcTQr7RrakbinxRYRazaDWKVDDuHgwb4pmdHKrY654=;
        b=mWgtvm61Q0TdU1hmuMuIiDxK1D4pDROaXUsXV9phXQuR84WbHz8cWSzrMBN7ZYJDVg
         6NysW7Uf13uiBZlruew35dHHxZwQ01Ax6y/AO4jZR9segIvi/mk6bvVZBe6pncXTcqD2
         DhdxjTV9Up21R8y0OZWuSAL3BPPg70BU36uw9GSXzmMxN7Oe08iNxEpz+FayP1JSmfkc
         QoQciD0EhEQB3XyvbRvIhSzPgSnQstlbitT4zW6axH4enmixXhDUWDuEafzPAyF31l2u
         uOi+nO64vOtIozeF/uhUX00u/ItrDnxSF0jKxP877wkXSG1L5CKOXdetksv5wLAT6TLx
         6zIQ==
In-Reply-To: <CAGqmV7pPb-Gh=B_Cjv0Az+PBxTHtPX=ECqkvFdd2Ej-hTfLqOQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: CoolCold <coolthecold-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "Kernel.org-Linux-RAID" <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kernel.org-Linux-cgroups" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Any thoughts here?

- Martin

On Sun, Dec 1, 2013 at 11:44 AM, CoolCold <coolthecold-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I hope Neil will shed some light here, interesting question.
>
>
> On Fri, Nov 29, 2013 at 6:15 PM, Martin Boutin <martboutin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> I forgot to suggest that this might have to do with md0_raid5 process.
>> The process has to take care of RAID parity for both processes
>> (streaming daemon and fio). By default it stays in the root cgroup
>> which means that RAID-related I/O will be unprioritized even for
>> processes in the prio cgroup, this might be introducing delays in the
>> I/O.
>> Otherwise I cannot put the md0_raid5 process in the prio cgroup either
>> because that would have RAID-related I/O from all other processes
>> stealing disk time from priority processes.
>>
>> On Fri, Nov 29, 2013 at 9:06 AM, Martin Boutin <martboutin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> wrote:
>> > Hello list,
>> >
>> > Today I was trying to figure out how to get block I/O prioritization
>> > working for a certain process. The process is a streaming server that
>> > reads a big file stored in a filesystem (xfs) on top of a RAID5
>> > configuration using 3 disks, using O_DIRECT.
>> >
>> > I'm setting up cgroups this way:
>> > $ echo 1000 > /sys/fs/cgroup/blkio/prio/blkio.weight
>> > $ echo 10 > /sys/fs/cgroup/blkio/blkio.leaf_weight
>> >
>> > meaning that all the tasks in the prio cgroup will have unconstrained
>> > access time to the disk, while all the other tasks will have their
>> > disk access time weighted by a factor.
>> >
>> > If I ignore the RAID5 setup, create a XFS filesystem on /dev/sdb2,
>> > mount it on /data and put my streaming daemon in the prio cgroup and
>> > run the daemon by streaming around 250MiB/s of data, while I launch
>> > fio with disk I/O intensive tasks. For a period of 5 minutes, the
>> > streaming deamon had to stop streaming in about 5 times to rebuffer.
>> >
>> > Now, if I consider the same scenario but using the RAID5 device and
>> > letting the daemon stream 500MiB/s of data (because the RAID has
>> > around twice the throughput of a single drive), after a period of 5
>> > minutes the streaming daemon had to stop streaming in about 50 times!
>> > This is 10 times more than the single drive case.
>> >
>> > While streaming, I observed both blkio.sectors and blkio.io_queued for
>> > both cgroups (the root node and prio). If only the streaming daemon is
>> > run (therefore fio is stopped), the sector count in prio/blkio.sectors
>> > increases while (root)/blkio.sectors does not. This confirms the
>> > streaming daemon is correctly identified as in the prio cgroup.
>> > Then, while both the streaming daemon and fio run, observing io_queued
>> > shows that for the root cgroup there is about 50 queued request in
>> > total (in average), while for the prio cgroup there is only one
>> > ocasional delayed request from time to time.
>> >
>> > $ uname -a
>> > Linux haswell1 3.10.10 #9 SMP PREEMPT Fri Nov 29 11:38:20 CET 2013
>> > i686 GNU/Linux
>> >
>> > Any ideas?
>> >
>> > Thanks,
>> > --
>> > Martin Boutin
>>
>>
>>
>> --
>> Martin Boutin
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
>
> --
> Best regards,
> [COOLCOLD-RIPN]



-- 
Martin Boutin
