From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Mon, 14 Sep 2015 19:34:09 +0530
Message-ID: <CAG53R5U7sYnR2w+Wrhh58Ud1HOrKLDCYxZZgK58FyAkJ8exshw@mail.gmail.com>
References: <20150908152340.GA13749@mtj.duckdns.org>
	<CAG53R5VnYJ9+VEKtbnFO1HntSp=O=ZGiknucbQ-QLuEk_UP44w@mail.gmail.com>
	<20150910164946.GH8114@mtj.duckdns.org>
	<CAG53R5XyfQxrA+FUKFaZi7ZBhSz-SW6eGkGUZpdo6hUTBkAO-g@mail.gmail.com>
	<20150910202210.GL8114@mtj.duckdns.org>
	<CAG53R5WtuPA=J_GYPzNTAKbjB1r0K90qhXEDxLNf7vxYyxgrKA@mail.gmail.com>
	<20150911040413.GA18850@htj.duckdns.org>
	<55F25781.20308@redhat.com>
	<20150911145213.GQ8114@mtj.duckdns.org>
	<1828884A29C6694DAF28B7E6B8A82373A903A586@ORSMSX109.amr.corp.intel.com>
	<20150911194311.GA18755@obsidianresearch.com>
	<1828884A29C6694DAF28B7E6B8A82373A903A5DB@ORSMSX109.amr.corp.intel.com>
	<CAG53R5XsMwnLK7L4q1mQx3_wEJNv1qthOr5TsX0o43kRWaiWrg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=qzXpm9/Ya+YJvgBq10EXMAbrUiGQCcBxI1OVg9aZrG8=;
        b=LuPef7p8x0c1Xrlu6c7l6FnWsNoJw9nd581yQk/QOHD4m+nToo8iMDTFVYuV8z7RTL
         YBJHFE1gPfz27NwdaBDBebv4y2+gBRmLHL7wgUcgMSQa/oWoQKD6c7JsemlNUbLvIPqU
         GNu0R1/Do/1phEm/QNtp8AlK/xF4c4oU0x9VtQfDbZhwYaHgeW5qOzPI5XqNR+ZKpejW
         YtrzaRouZcZ6LOlwSLpquhA9wQaQiTlzj77Zmy1y7RTNdwGm8jp4ivpOQc0hpgy4oFTi
         ogaA4CCxV4+gEcTcd6cWAzsX2kiQ0UXYPCaNXkSn6CgkM2p8hMCG2xJqSFwnuAVMKhAY
         j4zQ==
In-Reply-To: <CAG53R5XsMwnLK7L4q1mQx3_wEJNv1qthOr5TsX0o43kRWaiWrg@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Hefty, Sean" <sean.hefty@intel.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Tejun Heo <tj@kernel.org>, Doug Ledford <dledford@redhat.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "lizefan@huawei.com" <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, "james.l.morris@oracle.com" <james.l.morris@oracle.com>, "serge@hallyn.com" <serge@hallyn.com>, Haggai Eran <haggaie@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, "raindel@mellanox.com" <raindel@mellanox.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>

Hi Tejun,

I missed to acknowledge your point that we need both - hard limit and
soft limit/weight. Current patchset is only based on hard limit.
I see that weight would be another helfpul layer in chain that we can
implement after this as incremental that makes review, debugging
manageable?

Parav



On Mon, Sep 14, 2015 at 4:39 PM, Parav Pandit <pandit.parav@gmail.com> wrote:
> On Sat, Sep 12, 2015 at 1:36 AM, Hefty, Sean <sean.hefty@intel.com> wrote:
>>> > Trying to limit the number of QPs that an app can allocate,
>>> > therefore, just limits how much of the address space an app can use.
>>> > There's no clear link between QP limits and HW resource limits,
>>> > unless you assume a very specific underlying implementation.
>>>
>>> Isn't that the point though? We have several vendors with hardware
>>> that does impose hard limits on specific resources. There is no way to
>>> avoid that, and ultimately, those exact HW resources need to be
>>> limited.
>>
>> My point is that limiting the number of QPs that an app can allocate doesn't necessarily mean anything.  Is allocating 1000 QPs with 1 entry each better or worse than 1 QP with 10,000 entries?  Who knows?
>
> I think it means if its RDMA RC QP, than whether you can talk to 1000
> nodes or 1 node in network.
> When we deploy MPI application, it know the rank of the application,
> we know the cluster size of the deployment and based on that resource
> allocation can be done.
> If you meant to say from performance point of view, than resource
> count is possibly not the right measure.
>
> Just because we have not defined those interface for performance today
> in this patch set, doesn't mean that we won't do it.
> I could easily see a number_of_messages/sec as one interface to be
> added in future.
> But that won't stop process hoarders to stop taking away all the QPs,
> just the way we needed PID controller.
>
> Now when it comes to Intel implementation, if it driver layer knows
> (in future we new APIs) that whether 10 or 100 user QPs should map to
> few hw-QPs or more hw-QPs (uSNIC).
> so that hw-QP exposed to one cgroup is isolated from hw-QP exposed to
> other cgroup.
> If hw- implementation doesn't require isolation, it could just
> continue from single pool, its left to the vendor implementation on
> how to use this information (this API is not present in the patch).
>
> So cgroup can also provides a control point for vendor layer to tune
> internal resource allocation based on provided matrix, which cannot be
> done by just providing "memory usage by RDMA structures".
>
> If I have to compare it with other cgroup knobs, low level individual
> knobs by itself, doesn't serve any meaningful purpose either.
> Just by defined how much CPU to use or how much memory to use, it
> cannot define the application performance either.
> I am not sure, whether iocontroller can achieve 10 million IOPs by
> defining single CPU and 64KB of memory.
> all the knobs needs to be set in right way to reach desired number.
>
> In similar line RDMA resource knobs as individual knobs are not
> definition of performance, its just another knob.
>
>>
>>> If we want to talk about abstraction, then I'd suggest something very
>>> general and simple - two limits:
>>>  '% of the RDMA hardware resource pool' (per device or per ep?)
>>>  'bytes of kernel memory for RDMA structures' (all devices)
>>
>> Yes - this makes more sense to me.
>>
>
> Sean, Jason,
> Help me to understand this scheme.
>
> 1. How does the % of resource, is different than absolute number? With
> rest of the cgroups systems we define absolute number at most places
> to my knowledge.
> Such as (a) number_of_tcp_bytes, (b) IOPs of block device, (c) cpu cycles etc.
> 20% of QP = 20 QPs when 100 QPs are with hw.
> I prefer to keep the resource scheme consistent with other resource
> control points - i.e. absolute number.
>
> 2. bytes of  kernel memory for RDMA structures
> One QP of one vendor might consume X bytes and other Y bytes. How does
> the application knows how much memory to give.
> application can allocate 100 QP of each 1 entry deep or 1 QP of 100
> entries deep as in Sean's example.
> Both might consume almost same memory.
> Application doing 100 QP allocation, still within limit of memory of
> cgroup leaves other applications without any QP.
> I don't see a point of memory footprint based scheme, as memory limits
> are well addressed by more smarter memory controller anyway.
>
> I do agree with Tejun, Sean on the point that abstraction level has to
> be different for using RDMA and thats why libfabrics and other
> interfaces are emerging which will take its own time to get stabilize,
> integrated.
>
> Until pure IB style RDMA programming model exist - based on RDMA
> resource based scheme, I think control point also has to be on
> resources.
> Once a stable abstraction level is on table (possibly across fabric
> not just RDMA), than a right resource controller can be implemented.
> Even when RDMA abstraction layer arrives, as Jason mentioned, at the
> end it would consume some hw resource anyway, that needs to be
> controlled too.
>
> Jason,
> If the hardware vendor defines the resource pool without saying its
> resource QP or MR, how would actually management/control point can
> decide what should be controlled to what limit?
> We will need additional user space library component to decode than,
> after that it needs to be abstracted out as QP or MR so that it can be
> deal in vendor agnostic way as application layer.
> and than it would look similar to what is being proposed here?
