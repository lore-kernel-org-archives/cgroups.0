From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: RFC rdma cgroup
Date: Mon, 2 Nov 2015 15:43:37 +0200
Message-ID: <56376889.2080908@mellanox.com>
References: <CAG53R5Vd=tLbKPeKy8ZKP2DoHG-rnzW85COiE1Hk4GLv6SAZyA@mail.gmail.com>
 <563233D7.90808@mellanox.com>
 <CAG53R5UrfXdq=t97u=CoqUhQ2v+mZjZrLCxqyBw6n8g__nuP3g@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG53R5UrfXdq=t97u=CoqUhQ2v+mZjZrLCxqyBw6n8g__nuP3g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

On 29/10/2015 20:46, Parav Pandit wrote:
> On Thu, Oct 29, 2015 at 8:27 PM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> On 28/10/2015 10:29, Parav Pandit wrote:
>>> 3. Resources are not defined by the RDMA cgroup. Resources are defined
>>> by RDMA/IB subsystem and optionally by HCA vendor device drivers.
>>> Rationale: This allows rdma cgroup to remain constant while RDMA/IB
>>> subsystem can evolve without the need of rdma cgroup update. A new
>>> resource can be easily added by the RDMA/IB subsystem without touching
>>> rdma cgroup.
>> Resources exposed by the cgroup are basically a UAPI, so we have to be
>> careful to make it stable when it evolves. I understand the need for
>> vendor specific resources, following the discussion on the previous
>> proposal, but could you write on how you plan to allow these set of
>> resources to evolve?
> 
> Its fairly simple.
> Here is the code snippet on how resources are defined in my tree.
> It doesn't have the RSS work queues yet, but can be added right after
> this patch.
> 
> Resource are defined as index and as match_table_t.
> 
> enum rdma_resource_type {
>         RDMA_VERB_RESOURCE_UCTX,
>         RDMA_VERB_RESOURCE_AH,
>         RDMA_VERB_RESOURCE_PD,
>         RDMA_VERB_RESOURCE_CQ,
>         RDMA_VERB_RESOURCE_MR,
>         RDMA_VERB_RESOURCE_MW,
>         RDMA_VERB_RESOURCE_SRQ,
>         RDMA_VERB_RESOURCE_QP,
>         RDMA_VERB_RESOURCE_FLOW,
>         RDMA_VERB_RESOURCE_MAX,
> };
> So UAPI RDMA resources can evolve by just adding more entries here.
Are the names that appear in userspace also controlled by uverbs? What
about the vendor specific resources?

>>> 8. Typically each RDMA cgroup will have 0 to 4 RDMA devices. Therefore
>>> each cgroup will have 0 to 4 verbs resource pool and optionally 0 to 4
>>> hw resource pool per such device.
>>> (Nothing stops to have more devices and pools, but design is around
>>> this use case).
>> In what way does the design depend on this assumption?
> 
> Current code when performs resource charging/uncharging, it needs to
> identify the resource pool which one to charge to.
> This resource pool is maintained as list_head and so its linear search
> per device.
> If we are thinking of 100 of RDMA devices per container, than liner
> search will not be good way and different data structure needs to be
> deployed.
Okay, sounds fine to me.

>>> (c) When process migrate from one to other cgroup, resource is
>>> continue to be owned by the creator cgroup (rather css).
>>> After process migration, whenever new resource is created in new
>>> cgroup, it will be owned by new cgroup.
>> It sounds a little different from how other cgroups behave. I agree that
>> mostly processes will create the resources in their cgroup and won't
>> migrate, but why not move the charge during migration?
>>
> With fork() process doesn't really own the resource (unlike other file
> and socket descriptors).
> Parent process might have died also.
> There is possibly no clear way to transfer resource to right child.
> Child that cgroup picks might not even want to own RDMA resources.
> RDMA resources might be allocated by one process and freed by other
> process (though this might not be the way they use it).
> Its pretty similar to other cgroups with exception in migration area,
> such exception comes from different behavior of how RDMA resources are
> owned, created and used.
> Recent unified hierarchy patch from Tejun equally highlights to not
> frequently migrate processes among cgroups.
> 
> So in current implementation, (like other),
> if process created a RDMA resource, forked a child.
> child and parent both can allocate and free more resources.
> child moved to different cgroup. But resource is shared among them.
> child can free also the resource. All crazy combinations are possible
> in theory (without much use cases).
> So at best they are charged to the first cgroup css in which
> parent/child are created and reference is hold to CSS.
> cgroup, process can die, cut css remains until RDMA resources are freed.
> This is similar to process behavior where task struct is release but
> id is hold up for a while.

I guess there aren't a lot of options when the resources can belong to
multiple cgroups. So after migrating, new resources will belong to the
new cgroup or the old one?

>> I finally wanted to ask about other limitations an RDMA cgroup could
>> handle. It would be great to be able to limit a container to be allowed
>> to use only a subset of the MAC/VLAN pairs programmed to a device,
> 
> Truly. I agree. That was one of the prime reason I originally has it
> as part of the device cgroup.
> Where RDMA was just one category.
> But Tejun's opinion was to have rdma's own cgroup.
> Current internal data structure and interface between rdma cgroup and
> uverbs are tied to ib_device structure.
> which I think easy to overcome by abstracting out as new
> resource_device which can be used beyond RDMA as well.
> 
> However my bigger concern is interface to user land.
> We already have two use cases and I am inclined to make it as as
> "device resource cgroup" instead of "rdma cgroup".
> I seek Tejun's input here.
> Initial implementation can expose rdma resources under device resource
> cgroup, as it evolves we can add other net resources such as mac, vlan
> as you described.

When I was talking about limiting to MAC/VLAN pairs I only meant
limiting an RDMA device's ability to use that pair (e.g. use a GID that
uses the specific MAC VLAN pair). I don't understand how that makes the
RDMA cgroup any more generic than it is.

>  or
>> only a subset of P_Keys and GIDs it has. Do you see such limitations
>> also as part of this cgroup?
>>
> At present no. Because GID, P_key resources are created from the
> bottom up, either by stack or by network. They are kind of not tied to
> the user processes, unlike mac, vlan, qp which are more application
> driven or administrative driven.
They are created from the network, after the network administrator
configured them this way.

> For applications that doesn't use RDMA-CM, query_device and query_port
> will filter out the GID entries based on the network namespace in
> which caller process is running.
This could work well for RoCE, as each entry in the GID table is
associated with a net device and a network namespace. However, in
InfiniBand, the GID table isn't directly related to the network
namespace. As for the P_Keys, you could deduce the set of P_Keys of a
namespace by the set of IPoIB netdevs in the network namespace, but
InfiniBand is designed to also work without IPoIB, so I don't think it's
a good idea.

I think it would be better to allow each cgroup to limit the pkeys and
gids its processes can use.

> It was in my TODO list while we were working on RoCEv2 and GID
> movement changes but I never got chance to chase that fix.
> 
> One of the idea I was considering is: to create virtual RDMA device
> mapped to physical device.
> And configure GID count limit via configfs for each such device.
You could probably achieve what you want by creating a virtual RDMA
device and use the device cgroup to limit access to it, but it sounds to
me like an overkill.

Regards,
Haggai
