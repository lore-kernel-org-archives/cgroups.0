From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Thu, 10 Sep 2015 23:16:49 +0530
Message-ID: <CAG53R5XyfQxrA+FUKFaZi7ZBhSz-SW6eGkGUZpdo6hUTBkAO-g@mail.gmail.com>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
	<20150908152340.GA13749@mtj.duckdns.org>
	<CAG53R5VnYJ9+VEKtbnFO1HntSp=O=ZGiknucbQ-QLuEk_UP44w@mail.gmail.com>
	<20150910164946.GH8114@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=sy6TDcyayJqnLp5yPoY4pnAAunuu10yX/V4Hp6EYshM=;
        b=Q0RYT2g+4PgUNqBIADk0BS1N0pS4jp20PUAIMQ9M1Le3z2ybJOTBJeoPXNsOoPsj7n
         LrdL+ff3yEFl/waA1A/sXJFxxco1gWele3CCTqYsUJzuLaG/8jp5S880TPXkLJTVvGDJ
         1OEMoI2XlBIRGAWqR5U1Vte7XU+nGzP/AGimBOj0OfjAiLDSjPUTXYo1IbFaA54/kvtn
         8JspQPx1wAhwbABr0g9HjaPCXYi78yExGoBY/4kj+q60OnrntaboAxlWqa3Zo7AytGPh
         BlxsmVpQwjP8lsif5+TQbQR7BzFEGAXk5cTVuwdcP6vGSai90bTlpnwJ0a0p+B4+D9y9
         +luA==
In-Reply-To: <20150910164946.GH8114-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Sep 10, 2015 at 10:19 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, Parav.
>
> On Wed, Sep 09, 2015 at 09:27:40AM +0530, Parav Pandit wrote:
>> This is one old white paper, but most of the reasoning still holds true on RDMA.
>> http://h10032.www1.hp.com/ctg/Manual/c00257031.pdf
>
> Just read it.  Much appreciated.
>
> ...
>> These resources include are-  QP (queue pair) to transfer data, CQ
>> (Completion queue) to indicate completion of data transfer operation,
>> MR (memory region) to represent user application memory as source or
>> destination for data transfer.
>> Common resources are QP, SRQ (shared received queue), CQ, MR, AH
>> (Address handle), FLOW, PD (protection domain), user context etc.
>
> It's kinda bothering that all these are disparate resources.

Actually not. They are linked resources. Every QP needs associated one
or two CQ, one PD.
Every QP will use few MRs for data transfer.
Here is the good programming guide of the RDMA APIs exposed to the
user space application.

http://www.mellanox.com/related-docs/prod_software/RDMA_Aware_Programming_user_manual.pdf
So first version of the cgroups patch will address the control
operation for section 3.4.


> I suppose that each restriction comes from the underlying hardware and
> there's no accepted higher level abstraction for these things?
>
There is higher level abstraction which is through the verbs layer
currently which does actually expose the hardware resource but in
vendor agnostic way.
There are many vendors who support these verbs layer, some of them
which I know are Mellanox, Intel, Chelsio, Avago/Emulex whose drivers
which support these verbs are in <drivers/infiniband/hw/> kernel tree.

There is higher level APIs above the verb layer, such as MPI,
libfabric, rsocket, rds, pgas, dapl which uses underlying verbs layer.
They all rely on the hardware resource. All of these higher level
abstraction is accepted and well used by certain application class. It
would be long discussion to go over them here.


>> >> This patch-set allows limiting rdma resources to set of processes.
>> >> It extend device cgroup controller for limiting rdma device limits.
>> >
>> > I don't think this belongs to devcg.  If these make sense as a set of
>> > resources to be controlled via cgroup, the right way prolly would be a
>> > separate controller.
>> >
>>
>> In past there has been similar comment to have dedicated cgroup
>> controller for RDMA instead of merging with device cgroup.
>> I am ok with both the approach, however I prefer to utilize device
>> controller instead of spinning of new controller for new devices
>> category.
>> I anticipate more such need would arise and for new device category,
>> it might not be worth to have new cgroup controller.
>> RapidIO though very less popular and upcoming PCIe are on horizon to
>> offer similar benefits as that of RDMA and in future having one
>> controller for each of them again would not be right approach.
>>
>> I certainly seek your and others inputs in this email thread here whether
>> (a) to continue to extend device cgroup (which support character,
>> block devices white list) and now RDMA devices
>> or
>> (b) to spin of new controller, if so what are the compelling reasons
>> that it can provide compare to extension.
>
> I'm doubtful that these things are gonna be mainstream w/o building up
> higher level abstractions on top and if we ever get there we won't be
> talking about MR or CQ or whatever.

Some of the higher level examples I gave above will adapt to resource
allocation failure. Some are actually adaptive to few resource
allocation failure, they do query resources. But its not completely
there yet. Once we have this notion of limited resource in place,
abstraction layer would adapt to relatively smaller value of such
resource.
These higher level abstraction is mainstream. Its shipped at least in
Redhat Enterprise Linux.

> Also, whatever next-gen is
> unlikely to have enough commonalities when the proposed resource knobs
> are this low level,

I agree that resource won't be common in next-gen other transport
whenever they arrive.
But with my existing background working on some of those transport,
they appear similar in nature and it might seek similar knobs.

> so let's please keep it separate, so that if/when
> this goes out of fashion for one reason or another, the controller can
> silently wither away too.
>
>> Current scope of the patch is limited to RDMA resources as first
>> patch, but for fact I am sure that there are more functionality in
>> pipe to support via this cgroup by me and others.
>> So keeping atleast these two aspects in mind, I need input on
>> direction of dedicated controller or new one.
>>
>> In future, I anticipate that we might have sub directory to device
>> cgroup for individual device class to control.
>> such as,
>> <sys/fs/cgroup/devices/
>>      /char
>>      /block
>>      /rdma
>>      /pcie
>>      /child_cgroup..1..N
>> Each controllers cgroup access files would remain within their own
>> scope. We are not there yet from base infrastructure but something to
>> be done as it matures and users start using it.
>
> I don't think that jives with the rest of cgroup and what generic
> block or pcie attributes are directly exposed to applications and need
> to be hierarchically controlled via cgroup?
>
I do agree that currently cgroup doesn't have notion of sub cgroup or
above hierarchy today.
so until than I was considering to implement it under devices cgroup
as generic place without the hierarchy shown above.
Therefore current interface is at device cgroup level.

If you are suggesting to have rdma cgroup as separate entity for near
future, its fine with me.
Later on when next-gen arrives we might have scope to make rdma cgroup
as more generic one. But than it might look like what I described
above.

In past I have discussions with Liran Liss from Mellanox as well on
this topic and we also agreed to have such cgroup controller.
He has recent presentation at Linux foundation event indicating to
have cgroup for RDMA.
Below is the link to it.
http://events.linuxfoundation.org/sites/events/files/slides/containing_rdma_final.pdf
Slides 1 to 7 and slide 13 will give you more insight to it.
Liran and I had similar presentation to RDMA audience with less slides
in RDMA openfabrics summit in March 2015.

I am ok to create separate cgroup for rdma, if community thinks that way.
My preference would be still use device cgroup for above extensions
unless there are fundamental issues that I am missing.
I would let you make the call.
Rdma and other is just another type of device with different
characteristics than character or block, so one device cgroup with sub
functionalities can allow setting knobs.
Every device category will have their own set of knobs for resources,
ACL, limits, policy.
And I think cgroup is certainly better control point than sysfs or
spinning of new control infrastructure for this.
That said, I would like to hear your and communities view on how they
would like to see this shaping up.

> Thanks.
>
> --
> tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
