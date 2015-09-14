From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Tue, 15 Sep 2015 00:24:41 +0530
Message-ID: <CAG53R5XHTv-o+pGHdw+hGgtv4N3ZkH0WTs6o_W3zK_6jAnVsNA@mail.gmail.com>
References: <CAG53R5XyfQxrA+FUKFaZi7ZBhSz-SW6eGkGUZpdo6hUTBkAO-g@mail.gmail.com>
	<20150910202210.GL8114@mtj.duckdns.org>
	<CAG53R5WtuPA=J_GYPzNTAKbjB1r0K90qhXEDxLNf7vxYyxgrKA@mail.gmail.com>
	<20150911040413.GA18850@htj.duckdns.org>
	<55F25781.20308@redhat.com>
	<20150911145213.GQ8114@mtj.duckdns.org>
	<1828884A29C6694DAF28B7E6B8A82373A903A586@ORSMSX109.amr.corp.intel.com>
	<20150911194311.GA18755@obsidianresearch.com>
	<1828884A29C6694DAF28B7E6B8A82373A903A5DB@ORSMSX109.amr.corp.intel.com>
	<CAG53R5XsMwnLK7L4q1mQx3_wEJNv1qthOr5TsX0o43kRWaiWrg@mail.gmail.com>
	<20150914172832.GA21652@obsidianresearch.com>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=qLt0pufYPXU8SQLpOr43jJvYP50YAc6SZEQpkR1vA7A=;
        b=altGKITBgLMMyYa+tGQqj5Ji+JTvctl8hpcyNG+kvwzcjoiw3yLK2zMOr1SPUApmiO
         BuS77YMYAe6vYj5fzWuAj7CJ+GdULM3y/fC/o/KrZh0at5RNGN+92eESl5AZc3xNvEeN
         es+AGPuSLrtSEAl09fwN8OL0Ops12G8mufELW/ny/odE9ZO8K94x1qmjI9bYA6HbjIfO
         h1hF6IXdl58LnzROoJ6DNx725fapgNHzo+rZb4CU7wHooz/fIpJIwnYawhRoWmPxMsXX
         /mCgRx9+K3ACtbPnOv0Fx11orhlzqyEPv8tk4O6lKRtOGJmKc84K7G35tYBI9u0eXfI9
         /1hg==
In-Reply-To: <20150914172832.GA21652-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Sep 14, 2015 at 10:58 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Mon, Sep 14, 2015 at 04:39:33PM +0530, Parav Pandit wrote:
>
>> 1. How does the % of resource, is different than absolute number? With
>> rest of the cgroups systems we define absolute number at most places
>> to my knowledge.
>
> There isn't really much choice if the abstraction is a bundle of all
> resources. You can't use an absolute number unless every possible
> hardware limited resource is defined, which doesn't seem smart to me
> either.

Absolute number of percentage is representation for a given property.
That property needs definition. Isn't it?
How do we say that "Some undefined" resource you give certain amount,
which user doesn't know about what to administer, or configure.
It has to be quantifiable entity.

It is not abstract enough, and doesn't match our universe of
> hardware very well.
>
Why does the user need to know the actual hardware resource limits or
define hardware based resource.

RDMA verbs is the abstraction point.
We could well define
(a) how many number of RDMA connections are allowed instead of QP, or CQ or AH.
(b) how many data transfer buffers to use.

The fact is we have so many mid layers, which uses these resources
differently, above abstraction does not fit the bill.
But we know the mid layers how they operate, and how they use the RDMA
resource keeping.
So if we deploy MPI application for given cluster of container, we can
accurately configure the RDMA resource, isn't it?

Another example would be, if we don't want only 50% resources to be
given to all containers and rest 50% to kernel consumers such as NFS,
all containers can reside in single rdma cgroup limited to given
limits.


>> 2. bytes of  kernel memory for RDMA structures
>> One QP of one vendor might consume X bytes and other Y bytes. How does
>> the application knows how much memory to give.
>
> I don't see this distinction being useful at such a fine granularity
> where the control side needs to distinguish between 1 and 2 QPs.
>
> The majority use for control groups has been along with containers to
> prevent a container for exhausting resources in a way that impacts
> another.
>
Right. Thats the intention.

> In that use model limiting each container to N MB of kernel memory
> makes it straightforward to reason about resource exhaustion in a
> multi-tennant environment. We have other controllers that do this,
> just more indirectly (ie limiting the number of inotifies, or the
> number of fds indirectly cap kernel memory consumption)
>
> ie Presumably some fairly small limitation like 10MB is enough for
> most non-MPI jobs.

Container application always write a simple for loop code to take away
majority of QP with 10MB limit.
>
>> Application doing 100 QP allocation, still within limit of memory of
>> cgroup leaves other applications without any QP.
>
> No, if the HW has a fixed QP pool then it would hit #1 above. Both are
> active at once. For example you'd say a container cannot use more than
> 10% of the device's hardware resources, or more than 10MB of kernel
> memory.
>
Right. we need to define this resource pool, right?
Why it cannot be verbs abstraction?
How many resources are really used to implement verb layer in reality
is left to hardware vendor
Abstract pool just added confusion instead of clarity.

Imagine instead of tcp_bytes or kmem bytes, its "some memory
resource", how would someone debug/tune a system with abstract knobs?

> If on an mlx card, you probably hit the 10% of QP resources first. If
> on an qib card there is no HW QP pool (well, almost, QPNs are always
> limited), so you'd hit the memory limit instead.
>
> In either case, we don't want to see a container able to exhaust
> either all of kernel memory or all of the HW resources to deny other
> containers.
>
> If you have a non-container use case in mind I'd be curious to hear
> it..

Container is the prime case. Additionally equally prime case of non
container use case.
Today, application can take up all the resource being first class
citizan, and NFS mount will fail.
So without container also we should be able to restrict resources to
user mode app.


>
>> I don't see a point of memory footprint based scheme, as memory limits
>> are well addressed by more smarter memory controller anyway.
>
> I don't thing #1 is controlled but another controller. This is long
> lived kernel-side memory allocations to support RDMA resource
> allocation - we certainly have nothing in the rdma layer that is
> tracking this stuff.
>
Some drivers performs mmap() of kernel memory to user space, some
drivers does user space page allocation and maps to device.
Putting or tracking all those is just so intrusive changes spreading
down the vendor drivers or ib layer which may not be right way to
track.
Memory allocation tracking I believe should be left to memcg.


>> If the hardware vendor defines the resource pool without saying its
>> resource QP or MR, how would actually management/control point can
>> decide what should be controlled to what limit?
>
> In the kernel each HW driver has to be involved to declare what it's
> hardware resource limits are.
>
> In user space, it is just a simple limiter knob to prevent resource
> exhaustion.
>
> UAPI wise, nobdy has to care if the limit is actually # of QPs or
> something else.
>

If we dont care about resource, we cannot tune or limit it. number of
MRs used by MPI vs rsocket vs accelio is way different.



> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
