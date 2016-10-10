From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Mon, 10 Oct 2016 14:05:27 +0530
Message-ID: <CAG53R5WeWSrJ5-Gtt-cXpUr0r73zh3bqQM_G5zTue27tPtVEXA@mail.gmail.com>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com>
 <20161005112206.GC9282@leon.nu> <CAG53R5VNVb=8-LJbDRqjtOZG347ucPuc420bcfnDgBKMoKqU-w@mail.gmail.com>
 <20161010044623.GI9282@leon.nu> <CAG53R5UM6nSTZ7=0S9reKGX45CpNBi8soSDVZyXkN-z0_XXWWQ@mail.gmail.com>
 <20161010073343.GK9282@leon.nu>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=PzXDtMnm8H9x+lAPVYYxUPgXgWpNHDpXL8R0aiNk3Bs=;
        b=U0jVKMgtp927ddLwa6inZVQkY/0UkyGNGkYkMg/mSGpLwbHcF4BIa/P5DbF7Rha9UZ
         6D6yO62xjNo3ajX5H7CIbLOJaJxlR6jS9Alwo/ynXLHhtMAm65vhEie4AiS7VDdLAVd0
         mU9EYHESQHXUa4NPj/O1mpPEPQqonEO4G8HjC4pHH6yN4M8TgFjQibpY3CgW/vTyITKK
         20xFgHHy7xY1QWUeSf/VGblaFOWR6S4KeiRLUsfEQTEpkvIFcSnSo36R6fWIFG8+KJcD
         uDlASNaGhrahz3GOH9ThG0yyDd29taCQF5Mrp6aaaFC7jbab+Q97TwwAIcaLZTyR6O7Y
         cQ0A==
In-Reply-To: <20161010073343.GK9282-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

On Mon, Oct 10, 2016 at 1:03 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Mon, Oct 10, 2016 at 11:59:45AM +0530, Parav Pandit wrote:
>> Hi Leon,
>>
>> On Mon, Oct 10, 2016 at 10:16 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> > On Thu, Oct 06, 2016 at 07:19:24PM +0530, Parav Pandit wrote:
>> >> Hi Leon,
>> >>
>> >> On Wed, Oct 5, 2016 at 4:52 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> >> > On Wed, Aug 31, 2016 at 02:07:24PM +0530, Parav Pandit wrote:
>> >> >> rdmacg: IB/core: rdma controller support
>> >> >>
>> >> >> Overview:
>> >> >> Currently user space applications can easily take away all the rdma
>> >> >> device specific resources such as AH, CQ, QP, MR etc. Due to which other
>> >> >> applications in other cgroup or kernel space ULPs may not even get chance
>> >> >> to allocate any rdma resources. This results into service unavailibility.
>> >> >>
>> >> >> RDMA cgroup addresses this issue by allowing resource accounting,
>> >> >> limit enforcement on per cgroup, per rdma device basis.
>> >> >>
>> >> >> RDMA uverbs layer will enforce limits on well defined RDMA verb
>> >> >> resources without any HCA vendor device driver involvement.
>> >> >>
>> >> >> RDMA uverbs layer will not do limit enforcement of HCA hw vendor
>> >> >> specific resources. Instead rdma cgroup provides set of APIs
>> >> >> through which vendor specific drivers can do resource accounting
>> >> >> by making use of rdma cgroup.
>> >> >
>> >> > Hi Parav,
>> >> > I want to propose an extension to the RDMA cgroup which can be done as
>> >> > follow-up patches.
>> >> >
>> >> > Let's add new global type, which will control whole HCA (for example in percentages). It will
>> >> > allow natively define new objects without need to introduce them to the user.
>> >> >
>> >> In other cgroup such as CPU, this is done using cpu.weight API. Where
>> >> percentage or weight is configured by the user.
>> >> In this mode, resources taken away from other cgroup proportionately.
>> >> It works for cpu because its mainly stateless resource unlike rdma
>> >> resources.
>> >> So if we want to simplify user configuration similarly,
>> >> percentage/weight configuration can be extended.
>> >> This way they need not be introduced to users.
>> >> I hope your definition of "user" is actual end-user and not rdma cgroup. Right?
>> >
>> > Yes, "user" -> "admin".
>> > I think that percentage is more intuitive to them and will be much easier to
>> > explain how to use it. I always have in mind "swappiness" field and the
>> > numerous questions on how to configure it.
>> >
>> >> In other words, new object should be still added as new enum value in
>> >> rdma_cgroup.h?
>> >
>> > Yes, I had in mind something like IB_CGROUP_HCA, this is why it can be
>> > done as a future work after accepting current patches.
>> >
>> What I meant is,
>> today we have RDMACG_VERB_RESOURCE_QP etc,
>> We will additionally have RDMACG_VERB_RESOURCE_INDIRECT_TBL etc in
>> cgroup_rdma.h.
>> So that its available for admin to override it.
>
> IMHO, we are talking about the same. My global HCA object will be
> overwritten by more granular VERBS objects in case they exists.
>
>>
>> >> Only than it can be overwritten by specific UVERBs type as you
>> >> described below. I think thats what you meant as you described below.
>> >
>> > Exactly.
>> >
>> >>
>> >> Otherwise charging/uncharging this new percentage resource can get messy.
>> >
>> > Agree
>> >
>> >>
>> >> > This HCA share will be overwritten by specific UVERBS types which you
>> >> > already defined.
>> >> >
>> >> > What do you think?
>> >>
>> >> So to refine your proposal from cgroup perspective, instead of adding
>> >> new resource type in rdma_cgroup.h for percentage, I prefer to have
>> >>
>> >> Existing
>> >> 1. rdma.max
>> >> 2. rdma.current
>> >> New,
>> >> 3. rdma.weight
>> >> This ABI will have similar API to say
>> >> echo "mlx4_0 50" > rdma.weight.
>> >> Where 50 is weight of the resources.
>> >> For example,
>> >> for one cgroup instance weight=sum=100% resource for a given cgroup.
>> >> for three cgroup instances percentage=(weight/sum)% = 50/(50+50+50) = 33%.
>> >> One cgroup gets 33% resource.
>> >>
>> >> Weight can be in range of 1 to 10,000 similar to cpu cgroup.
>> >
>> > This is exactly what I don't like, the percentage will remove from the
>> > user the translation needs between weight and actual limitation.
>> >
>> > IMHO CPU used weights because everything there is in weights :).
>> >
>> I admit weight are not very intuitive, I was aligning to the existing
>> other cgroup interfaces which achieves similar functionality.
>> I will let Tejun approve the "percentage" or "ratio" new file
>> interface as its little different than weight.
>
> Sure, let's close the main idea first and see if it makes sense for
> other participants.
>
>>
>> >>
>> >> This might work if applications running in all cgroups are similar.
>> >> But weight doesn't do justice, when there are different type of
>> >> applications running in each cgroup. Such as few running libfabric
>> >> based apps, few running MPI, others directly using ibverbs.
>> >> So as you said rdma.max configuration would be required for management
>> >> plane to override weight (percentage) for certain resources.
>> >
>> > Why?
>> > The device exposes max values during initialization and if user asked
>> > for 20% percent of HCA, he will get max*0.2.
>>
>> Because every application may not be equivalent of other application.
>> For example, some require one to one QP and PD mapping.
>> Some share single PD across multiple QPs.
>> Some have ratio of 100 MRs per QP, as factor of memory size and operations.
>> some servers like to have 1K MRs per QP.
>> So if we have just weight, it will equally distributes MRs per QP in
>> all cgroup and that either leads to unused resource per cgroup or,
>> lesser number of cg instances.
>> So fine tuning required for individual one, which we already have.
>
> I afraid that it is over complicating which can be done by curious user
> in his user-space scripts: limit the global HCA -> read max values ->
> overwrite with specific mapping.
>
>>
>> weight or percentage helps in abstracting as starting point. So I like
>> to add it too.
>
> Let's start simple

Yes. I will rebase and test my patch today and see if requires resending.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
