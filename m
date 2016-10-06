From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Thu, 6 Oct 2016 19:19:24 +0530
Message-ID: <CAG53R5VNVb=8-LJbDRqjtOZG347ucPuc420bcfnDgBKMoKqU-w@mail.gmail.com>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com> <20161005112206.GC9282@leon.nu>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=qHbgrmyoay+4qhBwzKrXujarpthtbCT6Pk2CUGzUh2s=;
        b=HlYiBXioC0hsrZ0CdU0ffPc2IYoz18m8YTtZEpgMP3U6kSmiQpnNFGfItzyRPoAxym
         xi143DI2KOwQ5GC9NatcAdhvLFmKKus4LTKyt2KPekri5x8WqL3Jx6vDcq6BcL/A8TAs
         +0KiivAuM89WY/6LjztUHCKkrbgUOFs47dkQWe4WWFKKJIhgmel+jkZkIA6c89LRaAdF
         /17FkUi1enZ1n6Iz5brnutgIIHXVjJzoZPLSDySCZ4Qr5LLEm2ceWrovlF4KmW5UljzJ
         sGXCMvgQAEUZ1+XniUPrz73R7CtLnSZc5D94RWfAJsoTmabw46kcmYrvztb/KhMlLIAc
         fDOQ==
In-Reply-To: <20161005112206.GC9282-2ukJVAZIZ/Y@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi Leon,

On Wed, Oct 5, 2016 at 4:52 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Wed, Aug 31, 2016 at 02:07:24PM +0530, Parav Pandit wrote:
>> rdmacg: IB/core: rdma controller support
>>
>> Overview:
>> Currently user space applications can easily take away all the rdma
>> device specific resources such as AH, CQ, QP, MR etc. Due to which other
>> applications in other cgroup or kernel space ULPs may not even get chance
>> to allocate any rdma resources. This results into service unavailibility.
>>
>> RDMA cgroup addresses this issue by allowing resource accounting,
>> limit enforcement on per cgroup, per rdma device basis.
>>
>> RDMA uverbs layer will enforce limits on well defined RDMA verb
>> resources without any HCA vendor device driver involvement.
>>
>> RDMA uverbs layer will not do limit enforcement of HCA hw vendor
>> specific resources. Instead rdma cgroup provides set of APIs
>> through which vendor specific drivers can do resource accounting
>> by making use of rdma cgroup.
>
> Hi Parav,
> I want to propose an extension to the RDMA cgroup which can be done as
> follow-up patches.
>
> Let's add new global type, which will control whole HCA (for example in percentages). It will
> allow natively define new objects without need to introduce them to the user.
>
In other cgroup such as CPU, this is done using cpu.weight API. Where
percentage or weight is configured by the user.
In this mode, resources taken away from other cgroup proportionately.
It works for cpu because its mainly stateless resource unlike rdma
resources.
So if we want to simplify user configuration similarly,
percentage/weight configuration can be extended.
This way they need not be introduced to users.
I hope your definition of "user" is actual end-user and not rdma cgroup. Right?
In other words, new object should be still added as new enum value in
rdma_cgroup.h?
Only than it can be overwritten by specific UVERBs type as you
described below. I think thats what you meant as you described below.

Otherwise charging/uncharging this new percentage resource can get messy.

> This HCA share will be overwritten by specific UVERBS types which you
> already defined.
>
> What do you think?

So to refine your proposal from cgroup perspective, instead of adding
new resource type in rdma_cgroup.h for percentage, I prefer to have

Existing
1. rdma.max
2. rdma.current
New,
3. rdma.weight
This ABI will have similar API to say
echo "mlx4_0 50" > rdma.weight.
Where 50 is weight of the resources.
For example,
for one cgroup instance weight=sum=100% resource for a given cgroup.
for three cgroup instances percentage=(weight/sum)% = 50/(50+50+50) = 33%.
One cgroup gets 33% resource.

Weight can be in range of 1 to 10,000 similar to cpu cgroup.

This might work if applications running in all cgroups are similar.
But weight doesn't do justice, when there are different type of
applications running in each cgroup. Such as few running libfabric
based apps, few running MPI, others directly using ibverbs.
So as you said rdma.max configuration would be required for management
plane to override weight (percentage) for certain resources.


>
> Except this proposal,
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Thanks.
