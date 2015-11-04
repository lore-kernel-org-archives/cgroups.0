From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: RFC rdma cgroup
Date: Wed, 4 Nov 2015 13:58:27 +0200
Message-ID: <5639F2E3.8090101@mellanox.com>
References: <CAG53R5Vd=tLbKPeKy8ZKP2DoHG-rnzW85COiE1Hk4GLv6SAZyA@mail.gmail.com>
 <563233D7.90808@mellanox.com>
 <CAG53R5UrfXdq=t97u=CoqUhQ2v+mZjZrLCxqyBw6n8g__nuP3g@mail.gmail.com>
 <56376889.2080908@mellanox.com>
 <CAG53R5WUHZ7gcNGxcuadB5cGG3rnj_TKU_MEA-V5Q2Pmv19VTw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG53R5WUHZ7gcNGxcuadB5cGG3rnj_TKU_MEA-V5Q2Pmv19VTw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

On 03/11/2015 21:11, Parav Pandit wrote:
> So it looks like below,
> #cat rdma.resources.verbs.list
> Output:
> mlx4_0 uctx ah pd cq mr mw srq qp flow
> mlx4_1 uctx ah pd cq mr mw srq qp flow rss_wq
What happens if you set a limit of rss_wq to mlx4_0 in this example?
Would it fail? I think it would be simpler for administrators if they
can configure every resource supported by uverbs. If a resource is not
supported by a specific device, you can never go over the limit anyway.

> #cat rdma.resources.hw.list
> hfi1 hw_qp hw_mr sw_pd
> (This particular one is hypothical example, I haven't actually coded
> this, unlike uverbs which is real).
Sounds fine to me. We will need to be careful to make sure that driver
maintainers don't break backward compatibility with this interface.

>> I guess there aren't a lot of options when the resources can belong to
>> multiple cgroups. So after migrating, new resources will belong to the
>> new cgroup or the old one?
> Resource always belongs to the cgroup in which its created, regardless
> of process migration.
> Again, its owned at the css level instead of cgroup. Therefore
> original cgroup can also be deleted but internal reference to data
> structure and that is freed and last rdma resource is freed.
Okay.

>>> For applications that doesn't use RDMA-CM, query_device and query_port
>>> will filter out the GID entries based on the network namespace in
>>> which caller process is running.
>> This could work well for RoCE, as each entry in the GID table is
>> associated with a net device and a network namespace. However, in
>> InfiniBand, the GID table isn't directly related to the network
>> namespace. As for the P_Keys, you could deduce the set of P_Keys of a
>> namespace by the set of IPoIB netdevs in the network namespace, but
>> InfiniBand is designed to also work without IPoIB, so I don't think it's
>> a good idea.
> Got it. Yeah, this code can be under if(device_type RoCE).
IIRC there's a core capability for the new GID table code that contains
namespace, so you can use that.

>> I think it would be better to allow each cgroup to limit the pkeys and
>> gids its processes can use.
> 
> o.k. So the use case is P_Key? So I believe requirement would similar
> to device cgroup.
> Where set of GID table entries are configured as white list entries.
> and when they are queried or used during create_ah or modify_qp, its
> compared against the white list (or in other words as ACL).
> If they are found in ACL, they are reported in query_device or in
> create_ah, modify_qp. If not they those calls are failed with
> appropriate status?
> Does this look ok? 
Yes, that sounds good to me.

> Can we address requirement as additional feature just after first path?
> Tejun had some other idea on this kind of requirement, and I need to
> discuss with him.
Of course. I think there's use for the RDMA cgroup even without a pkey
or GID ACL, just to make sure one application doesn't hog hardware
resources.

>>> One of the idea I was considering is: to create virtual RDMA device
>>> mapped to physical device.
>>> And configure GID count limit via configfs for each such device.
>> You could probably achieve what you want by creating a virtual RDMA
>> device and use the device cgroup to limit access to it, but it sounds to
>> me like an overkill.
> 
> Actually not much. Basically this virtual RDMA device points to the
> struct device of the physical device itself.
> So only overhead is linking this structure to native device structure
> and  passing most of the calls to native ib_device with thin filter
> layer in control path.
> post_send/recv/poll_cq will directly go native device and same performance.
Still, I think we already have code that wraps ib_device calls for
userspace, which is the ib_uverbs module. There's no need for an extra
layer.

Regards,
Haggai
