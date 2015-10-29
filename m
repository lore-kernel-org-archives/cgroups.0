From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: RFC rdma cgroup
Date: Thu, 29 Oct 2015 16:57:27 +0200
Message-ID: <563233D7.90808@mellanox.com>
References: <CAG53R5Vd=tLbKPeKy8ZKP2DoHG-rnzW85COiE1Hk4GLv6SAZyA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG53R5Vd=tLbKPeKy8ZKP2DoHG-rnzW85COiE1Hk4GLv6SAZyA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

On 28/10/2015 10:29, Parav Pandit wrote:
> 3. Resources are not defined by the RDMA cgroup. Resources are defined
> by RDMA/IB subsystem and optionally by HCA vendor device drivers.
> Rationale: This allows rdma cgroup to remain constant while RDMA/IB
> subsystem can evolve without the need of rdma cgroup update. A new
> resource can be easily added by the RDMA/IB subsystem without touching
> rdma cgroup.
Resources exposed by the cgroup are basically a UAPI, so we have to be
careful to make it stable when it evolves. I understand the need for
vendor specific resources, following the discussion on the previous
proposal, but could you write on how you plan to allow these set of
resources to evolve?

> 8. Typically each RDMA cgroup will have 0 to 4 RDMA devices. Therefore
> each cgroup will have 0 to 4 verbs resource pool and optionally 0 to 4
> hw resource pool per such device.
> (Nothing stops to have more devices and pools, but design is around
> this use case).
In what way does the design depend on this assumption?

> 9. Resource pool object is created in following situations.
> (a) administrative operation is done to set the limit and no previous
> resource pool exist for the device of interest for the cgroup.
> (b) no resource limits were configured, but IB/RDMA subsystem tries to
> charge the resource. so that when applications are running without
> limits and later on when limits are enforced, during uncharging, it
> correctly uncharges them, otherwise usage count will drop to negative.
> This is done using default resource pool.
> Instead of implementing any sort of time markers, default pool
> simplifies the design.
Having a default resource pool kind of implies there is a non-default
one. Is the only difference between the default and non-default the fact
that the second was created with an administrative operation and has
specified limits or is there some other difference?

> (c) When process migrate from one to other cgroup, resource is
> continue to be owned by the creator cgroup (rather css).
> After process migration, whenever new resource is created in new
> cgroup, it will be owned by new cgroup.
It sounds a little different from how other cgroups behave. I agree that
mostly processes will create the resources in their cgroup and won't
migrate, but why not move the charge during migration?

I finally wanted to ask about other limitations an RDMA cgroup could
handle. It would be great to be able to limit a container to be allowed
to use only a subset of the MAC/VLAN pairs programmed to a device, or
only a subset of P_Keys and GIDs it has. Do you see such limitations
also as part of this cgroup?

Thanks,
Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
