From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Mon, 14 Sep 2015 11:28:32 -0600
Message-ID: <20150914172832.GA21652@obsidianresearch.com>
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
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=obsidianresearch.com; s=rsa1;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=GzHIL+ld/RbzFjqpGLObpnxL/KMw82Y0vSz726vvHTo=;
	b=c5bi9KiCeIfUR39Bcv+zOp+swzzfpmB/v4zoAJVX4B++40qke1a24NVE5F1NsUjGqLrAIp6vcXmabM04FDQ3FfJJoPbt8sF2Een0ySZuvWBDdCT0ct5UZU5j2AXvPjrvzmT6t/wUyUMIHsW2ZqwKDnTXv1QvVyi8DXEd7k+k0AQ=;
Content-Disposition: inline
In-Reply-To: <CAG53R5XsMwnLK7L4q1mQx3_wEJNv1qthOr5TsX0o43kRWaiWrg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Sep 14, 2015 at 04:39:33PM +0530, Parav Pandit wrote:

> 1. How does the % of resource, is different than absolute number? With
> rest of the cgroups systems we define absolute number at most places
> to my knowledge.

There isn't really much choice if the abstraction is a bundle of all
resources. You can't use an absolute number unless every possible
hardware limited resource is defined, which doesn't seem smart to me
either. It is not abstract enough, and doesn't match our universe of
hardware very well.

> 2. bytes of  kernel memory for RDMA structures
> One QP of one vendor might consume X bytes and other Y bytes. How does
> the application knows how much memory to give.

I don't see this distinction being useful at such a fine granularity
where the control side needs to distinguish between 1 and 2 QPs.

The majority use for control groups has been along with containers to
prevent a container for exhausting resources in a way that impacts
another.

In that use model limiting each container to N MB of kernel memory
makes it straightforward to reason about resource exhaustion in a
multi-tennant environment. We have other controllers that do this,
just more indirectly (ie limiting the number of inotifies, or the
number of fds indirectly cap kernel memory consumption)

ie Presumably some fairly small limitation like 10MB is enough for
most non-MPI jobs.

> Application doing 100 QP allocation, still within limit of memory of
> cgroup leaves other applications without any QP.

No, if the HW has a fixed QP pool then it would hit #1 above. Both are
active at once. For example you'd say a container cannot use more than
10% of the device's hardware resources, or more than 10MB of kernel
memory.

If on an mlx card, you probably hit the 10% of QP resources first. If
on an qib card there is no HW QP pool (well, almost, QPNs are always
limited), so you'd hit the memory limit instead.

In either case, we don't want to see a container able to exhaust
either all of kernel memory or all of the HW resources to deny other
containers.

If you have a non-container use case in mind I'd be curious to hear
it..

> I don't see a point of memory footprint based scheme, as memory limits
> are well addressed by more smarter memory controller anyway.

I don't thing #1 is controlled but another controller. This is long
lived kernel-side memory allocations to support RDMA resource
allocation - we certainly have nothing in the rdma layer that is
tracking this stuff.

> If the hardware vendor defines the resource pool without saying its
> resource QP or MR, how would actually management/control point can
> decide what should be controlled to what limit?

In the kernel each HW driver has to be involved to declare what it's
hardware resource limits are.

In user space, it is just a simple limiter knob to prevent resource
exhaustion.

UAPI wise, nobdy has to care if the limit is actually # of QPs or
something else.

Jason
