From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Thu, 13 Oct 2016 16:34:55 +0530
Message-ID: <CAG53R5Uai0sG+i02R34Eg1LZUSZbt4arz2KAqB4cbxtgp2VLRg@mail.gmail.com>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com>
 <20161005112206.GC9282@leon.nu> <CAG53R5VNVb=8-LJbDRqjtOZG347ucPuc420bcfnDgBKMoKqU-w@mail.gmail.com>
 <20161010044623.GI9282@leon.nu> <CAG53R5UM6nSTZ7=0S9reKGX45CpNBi8soSDVZyXkN-z0_XXWWQ@mail.gmail.com>
 <20161010122545.GA27360@mtj.duckdns.org> <CAG53R5V5yE4PsDBjP9BieG_=39M0G1kx-AfBEzWK4LUCxNnYBA@mail.gmail.com>
 <20161010132014.GD29742@mtj.duckdns.org> <CAG53R5ULKCqtw45E6t4hYdRV+y_OQqVazf=7A7Ax_XAJ2K0_dw@mail.gmail.com>
 <20161013103430.GB9282@leon.nu>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=bgjohb1qhr37aq6MpVLIl2GIBZSgNgIZ451We5ZkkW8=;
        b=F3sEHhJv54EnUf51rK8cRHFMxVOFX7u/E8XjQo8ZefXQO+Sl5/RrQ2uvlmzGZxbt8J
         oRlb52cuj1RurSgtOkPvhcYBSoJsoVvFjUHjlfejGKyA++ljxy01hKP3JW8iFXIWM63w
         4jRgj0PPNJdY0MMD2r8AnXKm6JQqgbnGvwZ3HlA4afAEpcTzSgSKmlrSbdjh6BwCxv0u
         Who0c+ljoCFD0RJm0oAOxcJwLsfyBDK2Xah1O0mxcDS+WhMJe6D+kPtF610MeQ+Dxdw+
         Pn2zs1IlwsHWgUBOo7JkZgWBU2RVFfcqWEhleC4AvSSsQbfGz8CNlkuUfPb9qoI2aOfO
         ktjw==
In-Reply-To: <20161013103430.GB9282-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi Leon,


On Thu, Oct 13, 2016 at 4:04 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Mon, Oct 10, 2016 at 07:02:11PM +0530, Parav Pandit wrote:
>> Hi Tejun,
>>
>> On Mon, Oct 10, 2016 at 6:50 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> > Hello, Parav.
>> >
>> > On Mon, Oct 10, 2016 at 06:43:59PM +0530, Parav Pandit wrote:
>> >> > Also, I don't get what you mean by using percentage and when people
>> >> > brought up this idea, it always has been stemming from
>> >> > misunderstanding.  Can you please elaborate how percentage based
>> >> > proportional control would work?  What would 100% mean when cgroups
>> >> > can come and go?
>> >>
>> >> When 100% is given to one cgroup, all resources of all type can be
>> >> charged by processes of that cgroup.
>> >> Resources are stateful resource. So when cgroup goes away, they go
>> >> back to global pool (or hw).
>> >> Giving 100% to two cgroups is configuration error anyway (or without config).
>> >
>> > That isn't proportional control.  That's using percentage as the unit
>> > to implement absolute limits.  Proportional control implies work
>> > conservation.
>> >
>> >> As you know weight configuration allows automatic increase/decrease of
>> >> resource to other cgroups when one of them go away, as opposed to
>> >> absolute value. How this is going to work in exact terms for stateful
>> >
>> > Hmm.... so are you saying that ti'd be work-conserving?
>> They cannot be work conversing.
>>
>> > But what does
>> > it mean to say "30%" and then have it all resources when there are no
>> > other users.  Also, is it even possible to take back what have already
>> > been allocated and are in use?
>> >
>> Most resources that I know of, and whats described in current
>> cgroup_rdma.h are not work conversing, therefore it cannot be taken
>> back.
>>
>> >> Nop. Thats not true.
>> >> (a) Every new resource has to be defined in cgroup_rdma.h
>> >> (b) charge()/uncharge() has to happen by the cgroup for each.
>> >> (c) Letting drivers do will make things fall apart. There are no APIs
>> >> exposed either to let drivers know process cgroup either. There is no
>> >> intention either.
>> >>
>> >> (d) ratio means -if adapter has
>> >> 100 resources of type - A,
>> >> 80 resource of type - B,
>> >>
>> >> 10% for cgroup-1 means,
>> >> 10 resource of type - A
>> >> 8 resource of type - B
>> >
>> > So, this is not work-conserving.  There's too much confusion here.
>>
>> Give me some more time, I will think more and take feeback from Leon
>> and others on
>> (a) how can we implement or want to implement weight like
>> functionality for non-work-conversing resource
>
> I'm not fully understand the question. RDMA resources are static and
> won't be recalculated dynamically for running cgroups consumers while
> new cgroup is started. In this situation, weights and percentages are
> the same.
>
Let me try again to take weights example.

total resources distributed is based on equation:

resource_of_cg = weight_of_cg * max_resource_of_hca / (sum of all weights)

say there is only one cg-A. Lets say it has weight of 20.
max_resource_of_hca = 100.

So total resource_for_cg_A = (20 * 100) / 20 = 100 (all resources).

Now new cg-B is created with weight of 20.
So with new cg-B, cg-A and cg-B will get 50 resources.

With cg-C creation with weight of 20, each cg gets 33 resources.

Which means that resources are recalculated dynamically on
running/creating new cgroups.

>> (b) what could be its acceptable limitations of that interface would be
>> before we propose you.
>
> More easy is to summarize requirements:
> 1. It needs to be convenient for users.
> 2. It can limit any future objects without change in user tools.

Why don't we have such requirements on the actual dataplane and
control plane APIs side (similar to having abstract socket APIs).
Instead we expect applications to change to make use of new verbs
objects for performance, functionality etc.

New future objects can be limited if we introduce weights/percentage
knob but at the cost of not able to tune for performance.
Usually end-users will use application templates when they deploy for
specific applications, such as mongodb, MPI cluster, glusterFS cluster
etc.
So those application specific plug-in would program exact ratio of MR
to QP or PD to QP etc by writing values to rdma.max depending on MPI
rank, cluster size etc.

weights API allow to auto adjust the value for existing cgroups when
new cgroups are added/removed when deployed application is not well
defined.

>
>>
>> At minimum we would need to expose actual value in rdma.max in
>> subsequent patch, instead of exposing just "max" string. I don't want
>> to complicate this discussion but similar functionality is needed for
>> pid controller as well to expose actual value.
>>
>> >
>> > Thanks.
>> >
>> > --
>> > tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
