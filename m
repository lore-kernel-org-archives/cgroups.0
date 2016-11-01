From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Tue, 1 Nov 2016 16:33:23 +0530
Message-ID: <CAG53R5VKwntDHX101+5aaGoyKMKQuiKQWam575iFAxhmKxhE1g@mail.gmail.com>
References: <20161013231413.GA32534@mtj.duckdns.org> <CAG53R5UciPpa5d8BWyR-tks3LBrBwRCN2NyBbbm1e3EE-OWSYQ@mail.gmail.com>
 <20161018215134.GB2761@htj.duckdns.org> <CAG53R5UEvkPBM0yFrR=fvEzyCrku2q=rLZyDVrSs9q+3hgbSmQ@mail.gmail.com>
 <20161019143345.GA18532@htj.duckdns.org> <CAG53R5WUyA7JBn=PeivUc5F5k210xf_HccPXFt3r7ZGYHOPaGA@mail.gmail.com>
 <20161019192006.GB3044@htj.duckdns.org> <CAG53R5X5dyo7J-UkeMxi_mSxgv=c54fV=anuCZtmf9kaYwDbPw@mail.gmail.com>
 <20161019200536.GC3044@htj.duckdns.org> <CAG53R5XkRKdo-SCaREZvov3AGp5MSd18RpQ+0HEu-htUzqwOOw@mail.gmail.com>
 <20161031065441.GY3617@leon.nu>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=DCEuK3qUDUnKrj+hvuHwU6NXcdPRxer6L2zh1aqA1U0=;
        b=l9CQltGGNgCWXgFWg+azFetyBWAT65NRPuQH0+tEWDCQ8oHwPHgmJCHXH9YPRgGcRN
         z84h3gDivLK06kpHWgygiP/rJp4qMCcyqgCwKMOTSCnaIehIglXRqSUfNt/ZcdC1Jwvr
         r8o8mws500hU2PTPyYgiFVnCcHuCIgavs5yvi/T0L2xmPK/yhptZ9EiWFXm9jG91HquT
         3vfIysYXmSAetA39K7+3JD2/kdFfqwt+tKBN037lBRxqPd+z9FW6Vtu1HB3527AkksOr
         pYnxfrBj37oHyUQAUsnO420ixiPfg9EvVm/MhsbowExKTBaHVaAUsre5trL1UU1Sp0kI
         wdPA==
In-Reply-To: <20161031065441.GY3617-2ukJVAZIZ/Y@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

On Mon, Oct 31, 2016 at 12:24 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Thu, Oct 20, 2016 at 01:48:27AM +0530, Parav Pandit wrote:
>> On Thu, Oct 20, 2016 at 1:35 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> > Hello, Parav.
>> >
>> > On Thu, Oct 20, 2016 at 01:24:42AM +0530, Parav Pandit wrote:
>> >> userland can get the max numbers using other framework which is used
>> >> by control & data plane available in C library form or in form of
>> >> system tools.
>> >> I was preferring to get and set through same interface because,
>> >> It simplifies user land software which is often not written in C so
>> >> its likely that it needs to rely on system tools and parse the
>> >> content, iterate through devices etc.
>> >> Getting these info through rdma.max just makes it simple. There will
>> >> be logic built to read/write rdma.max in userland anyway, which can be
>> >> leveraged for percentage calculation instead of doing it from two
>> >> places.
>> >
>> > Yeah, I get that this can be convenient in this case but it isn't a
>> > generic approach.  I'd much prefer keeping it in line with other
>> > resources.
>> >
>> Hmm. we don't have /proc/sys/kernel/pid_max type of simple interface
>> to get the max values for rdma resources.
>> rdma.max is close to that simplicity.
>
> Sorry for my late response (very long weekends and piles of mails after it) and
> for not clarifying our requirements better, which are very simple.
>
> 1. We will have vendor specific vendors objects in the future (new ABI
> support it and designed for that).
I will let others comments on it. The patch_v11 design was allowing
vendor specific objects and standard objects to be defined in IB core
and rdma cgroup was facilitator to do so. We didn't reach consensus on
that approach.

> 2. We don't want to fight for every addition of such objects to cgroup list.
Ditto comment as above.

> 3. We don't want to teach and/or rewrite scripts for "average" user after
> addition of new objects.
This we can possibly do by having new rdma.percentage knob, which gets
configured by default for every new object in rdma cgroup.
This way average user/administrator doesn't have to know about it.

> 4. Cgroup configuration should be as close as possible to "standard" if
> such exists, so all infinite internet guides will work for RDMA too.
I didnt follow this comment. Can you please explain? Are you saying
rdma cgroup should have define all the objects of IB spec?
>
> From my understanding of current status.
> My naive approach of introducing GLOBAL_HCA object is the way to go and the real question
> is to understand how to configure it, am I right?
>
Global object won't work for below reason.
Lets take example that makes life easier.
Lets say two new RDMA objects exist which are not part of rdma cgroup
standard resource definition.
say, indirection table and PSM tags.
Both are abstracted using one global_hca resource object.
Say its given 10%.
Now IB core performs charging of each such object using GLOBAL_HCA.
(Because cgroup level there is only one object GLOBAL_HCA).
So two or more resources are mapped to single object.
Which means, one object can be charged more with total limit still
under 10%, thats leads to same problem as not having cgroup at all.

So my opinion is:
(a) Let cgroup define the current standard objects and new reasonable
set of vendor specific objects in future.
(b) Add new rdma.percentage parameter so that any new standard object
or vendor specific object can be abstracted from average end user and
applications which are yet to catch up.
I believe this takes care of your point (1), (3), (4)?

In other hypothetical design,
we can have rdma group as just pid to cgroup mapping facilitator.
All the charging/uncharging logic moves to IB core in form of library,
that standard ABI uverbs and vendor specific layer invokes. In this
approach there will be code duplicated in every such vendor driver.
By doing so, more callbacks will also have to be moved down till IB
core and vendor drivers for cgroup creation/deletion/offline etc.

This also means that lack of standard object definitions, may creates
more confusion to end user and orchestration applications. I prefer to
avoid such design.

Parav
