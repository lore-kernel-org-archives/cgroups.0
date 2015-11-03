From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RFC rdma cgroup
Date: Wed, 4 Nov 2015 00:41:08 +0530
Message-ID: <CAG53R5WUHZ7gcNGxcuadB5cGG3rnj_TKU_MEA-V5Q2Pmv19VTw@mail.gmail.com>
References: <CAG53R5Vd=tLbKPeKy8ZKP2DoHG-rnzW85COiE1Hk4GLv6SAZyA@mail.gmail.com>
	<563233D7.90808@mellanox.com>
	<CAG53R5UrfXdq=t97u=CoqUhQ2v+mZjZrLCxqyBw6n8g__nuP3g@mail.gmail.com>
	<56376889.2080908@mellanox.com>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=kZkSnadMKDCrvcA3OKac70eVrvGNcg+48dZasWUan1E=;
        b=mKiggI6GmO/wzub/1tC+di91fEBx4tAtZxBLkknNLMhU08ww4qOhyTuwtLt83Js1Hs
         nr00apt8UE0fvKF5wIZLl3te21scFZ7aNWHKIJVWryjZvgKZOxbeqycXITWExfEujF7o
         Jp0mz5mRM6IdJX1CUrTb62diV3yRlTysoZieqLFV6q9qPUTDhnGa//3JVkAN/5F9nDMZ
         X8Vg2l9H7mC8836kpkxXPt4SYyHDFOmaro9A4v3GcR5knUPCHra8jdUJiy/WjfREISDT
         /H6bwVyiFgNcYwRdilkg7kYKglUj9jYp8ISJSjaqqQ7TflMPlETMRtjKJBfGGzUXpU4r
         GRrg==
In-Reply-To: <56376889.2080908-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

>> Resource are defined as index and as match_table_t.
>>
>> enum rdma_resource_type {
>>         RDMA_VERB_RESOURCE_UCTX,
>>         RDMA_VERB_RESOURCE_AH,
>>         RDMA_VERB_RESOURCE_PD,
>>         RDMA_VERB_RESOURCE_CQ,
>>         RDMA_VERB_RESOURCE_MR,
>>         RDMA_VERB_RESOURCE_MW,
>>         RDMA_VERB_RESOURCE_SRQ,
>>         RDMA_VERB_RESOURCE_QP,
>>         RDMA_VERB_RESOURCE_FLOW,
>>         RDMA_VERB_RESOURCE_MAX,
>> };
>> So UAPI RDMA resources can evolve by just adding more entries here.
> Are the names that appear in userspace also controlled by uverbs? What
> about the vendor specific resources?

I am not sure I followed your question.
Basically any RDMA resource that is allocated through uverb API can be tracked.
uverb makes the call to charge/uncharge.
There is list rdma.resources.verbs.list. This file lists all the verbs
resource names of all the devices which have registered themselves to
rdma cgroup.
Similarly there is rdma.resource.hw.list. This file lists all hw
specific resource names, which means they are defined run time and
potentially different for each vendor.

So it looks like below,
#cat rdma.resources.verbs.list
Output:
mlx4_0 uctx ah pd cq mr mw srq qp flow
mlx4_1 uctx ah pd cq mr mw srq qp flow rss_wq

#cat rdma.resources.hw.list
hfi1 hw_qp hw_mr sw_pd
(This particular one is hypothical example, I haven't actually coded
this, unlike uverbs which is real).

>>>> (c) When process migrate from one to other cgroup, resource is
>>>> continue to be owned by the creator cgroup (rather css).
>>>> After process migration, whenever new resource is created in new
>>>> cgroup, it will be owned by new cgroup.
>>> It sounds a little different from how other cgroups behave. I agree that
>>> mostly processes will create the resources in their cgroup and won't
>>> migrate, but why not move the charge during migration?
>>>
>> With fork() process doesn't really own the resource (unlike other file
>> and socket descriptors).
>> Parent process might have died also.
>> There is possibly no clear way to transfer resource to right child.
>> Child that cgroup picks might not even want to own RDMA resources.
>> RDMA resources might be allocated by one process and freed by other
>> process (though this might not be the way they use it).
>> Its pretty similar to other cgroups with exception in migration area,
>> such exception comes from different behavior of how RDMA resources are
>> owned, created and used.
>> Recent unified hierarchy patch from Tejun equally highlights to not
>> frequently migrate processes among cgroups.
>>
>> So in current implementation, (like other),
>> if process created a RDMA resource, forked a child.
>> child and parent both can allocate and free more resources.
>> child moved to different cgroup. But resource is shared among them.
>> child can free also the resource. All crazy combinations are possible
>> in theory (without much use cases).
>> So at best they are charged to the first cgroup css in which
>> parent/child are created and reference is hold to CSS.
>> cgroup, process can die, cut css remains until RDMA resources are freed.
>> This is similar to process behavior where task struct is release but
>> id is hold up for a while.
>
> I guess there aren't a lot of options when the resources can belong to
> multiple cgroups. So after migrating, new resources will belong to the
> new cgroup or the old one?
Resource always belongs to the cgroup in which its created, regardless
of process migration.
Again, its owned at the css level instead of cgroup. Therefore
original cgroup can also be deleted but internal reference to data
structure and that is freed and last rdma resource is freed.

>
> When I was talking about limiting to MAC/VLAN pairs I only meant
> limiting an RDMA device's ability to use that pair (e.g. use a GID that
> uses the specific MAC VLAN pair). I don't understand how that makes the
> RDMA cgroup any more generic than it is.
>
Oh ok. That doesn't. I meant that I wanted to limit how many vlans a
given container can create.
We have just high level capabilities (7) to enable such creation, but
not the count.

>>  or
>>> only a subset of P_Keys and GIDs it has. Do you see such limitations
>>> also as part of this cgroup?
>>>
>> At present no. Because GID, P_key resources are created from the
>> bottom up, either by stack or by network. They are kind of not tied to
>> the user processes, unlike mac, vlan, qp which are more application
>> driven or administrative driven.
> They are created from the network, after the network administrator
> configured them this way.
>
>> For applications that doesn't use RDMA-CM, query_device and query_port
>> will filter out the GID entries based on the network namespace in
>> which caller process is running.
> This could work well for RoCE, as each entry in the GID table is
> associated with a net device and a network namespace. However, in
> InfiniBand, the GID table isn't directly related to the network
> namespace. As for the P_Keys, you could deduce the set of P_Keys of a
> namespace by the set of IPoIB netdevs in the network namespace, but
> InfiniBand is designed to also work without IPoIB, so I don't think it's
> a good idea.
Got it. Yeah, this code can be under if(device_type RoCE).

>
> I think it would be better to allow each cgroup to limit the pkeys and
> gids its processes can use.

o.k. So the use case is P_Key? So I believe requirement would similar
to device cgroup.
Where set of GID table entries are configured as white list entries.
and when they are queried or used during create_ah or modify_qp, its
compared against the white list (or in other words as ACL).
If they are found in ACL, they are reported in query_device or in
create_ah, modify_qp. If not they those calls are failed with
appropriate status?
Does this look ok? Can we address requirement as additional feature
just after first path?
Tejun had some other idea on this kind of requirement, and I need to
discuss with him.

>
>> It was in my TODO list while we were working on RoCEv2 and GID
>> movement changes but I never got chance to chase that fix.
>>
>> One of the idea I was considering is: to create virtual RDMA device
>> mapped to physical device.
>> And configure GID count limit via configfs for each such device.
> You could probably achieve what you want by creating a virtual RDMA
> device and use the device cgroup to limit access to it, but it sounds to
> me like an overkill.

Actually not much. Basically this virtual RDMA device points to the
struct device of the physical device itself.
So only overhead is linking this structure to native device structure
and  passing most of the calls to native ib_device with thin filter
layer in control path.
post_send/recv/poll_cq will directly go native device and same performance.


>
> Regards,
> Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
