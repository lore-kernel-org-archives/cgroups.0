From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Thu, 10 Sep 2015 16:22:10 -0400
Message-ID: <20150910202210.GL8114@mtj.duckdns.org>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
 <20150908152340.GA13749@mtj.duckdns.org>
 <CAG53R5VnYJ9+VEKtbnFO1HntSp=O=ZGiknucbQ-QLuEk_UP44w@mail.gmail.com>
 <20150910164946.GH8114@mtj.duckdns.org>
 <CAG53R5XyfQxrA+FUKFaZi7ZBhSz-SW6eGkGUZpdo6hUTBkAO-g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=lO/XMt53E7YkSCpv9sIU6JTcD1/zUGi0xmYAXouAkDw=;
        b=WOkoRxS+UN1qt1wRv0rnDTP8CB+a9NaOBAoi7tD+4yHV414iZ2bjjUE0pf2E9YxpJS
         8YHnZaaHsHdqtMzV1SV5Ol7ugJYBvvPiqv2wKT9vMIf5cOEcUIl+f6P0BUkT7niKp/Eb
         vLeBkMrnzY4gckprL8UbuBnt5qNcW1IIE336G1kNUm4k38RFqOeHLRjRlYlza9Ck5GHY
         tPJw3xCEx2FciK0Q1Cb6qlcFnkBJY+zqbfKMdJ2skDJWYkclbRlemT4pJYVmvW40AHA0
         iJXJX4j3xCjLDc1DFRQC5C0qNWgu+bYFgysqmisE+IKQsnAvT+G2/nersXnF/NfdXuFb
         VrdQ==
Content-Disposition: inline
In-Reply-To: <CAG53R5XyfQxrA+FUKFaZi7ZBhSz-SW6eGkGUZpdo6hUTBkAO-g@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Haggai Eran <haggaie@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

Hello, Parav.

On Thu, Sep 10, 2015 at 11:16:49PM +0530, Parav Pandit wrote:
> >> These resources include are-  QP (queue pair) to transfer data, CQ
> >> (Completion queue) to indicate completion of data transfer operation,
> >> MR (memory region) to represent user application memory as source or
> >> destination for data transfer.
> >> Common resources are QP, SRQ (shared received queue), CQ, MR, AH
> >> (Address handle), FLOW, PD (protection domain), user context etc.
> >
> > It's kinda bothering that all these are disparate resources.
> 
> Actually not. They are linked resources. Every QP needs associated one
> or two CQ, one PD.
> Every QP will use few MRs for data transfer.

So, if that's the case, let's please implement something higher level.
The goal is providing reasonable isolation or protection.  If that can
be achieved at a higher level of abstraction, please do that.

> Here is the good programming guide of the RDMA APIs exposed to the
> user space application.
> 
> http://www.mellanox.com/related-docs/prod_software/RDMA_Aware_Programming_user_manual.pdf
> So first version of the cgroups patch will address the control
> operation for section 3.4.
> 
> > I suppose that each restriction comes from the underlying hardware and
> > there's no accepted higher level abstraction for these things?
>
> There is higher level abstraction which is through the verbs layer
> currently which does actually expose the hardware resource but in
> vendor agnostic way.
> There are many vendors who support these verbs layer, some of them
> which I know are Mellanox, Intel, Chelsio, Avago/Emulex whose drivers
> which support these verbs are in <drivers/infiniband/hw/> kernel tree.
> 
> There is higher level APIs above the verb layer, such as MPI,
> libfabric, rsocket, rds, pgas, dapl which uses underlying verbs layer.
> They all rely on the hardware resource. All of these higher level
> abstraction is accepted and well used by certain application class. It
> would be long discussion to go over them here.

Well, the programming interface that userland builds on top doesn't
matter too much here but if there is a common resource abstraction
which can be made in terms of constructs that consumers of the
facility would care about, that likely is a better choice than
exposing whatever hardware exposes.

> > I'm doubtful that these things are gonna be mainstream w/o building up
> > higher level abstractions on top and if we ever get there we won't be
> > talking about MR or CQ or whatever.
> 
> Some of the higher level examples I gave above will adapt to resource
> allocation failure. Some are actually adaptive to few resource
> allocation failure, they do query resources. But its not completely
> there yet. Once we have this notion of limited resource in place,
> abstraction layer would adapt to relatively smaller value of such
> resource.
>
> These higher level abstraction is mainstream. Its shipped at least in
> Redhat Enterprise Linux.

Again, I was talking more about resource abstraction - e.g. something
along the line of "I want N command buffers".

> > Also, whatever next-gen is
> > unlikely to have enough commonalities when the proposed resource knobs
> > are this low level,
> 
> I agree that resource won't be common in next-gen other transport
> whenever they arrive.
> But with my existing background working on some of those transport,
> they appear similar in nature and it might seek similar knobs.

I don't know.  What's proposed in this thread seems way too low level
to be useful anywhere else.  Also, what if there are multiple devices?
Is that a problem to worry about?

> In past I have discussions with Liran Liss from Mellanox as well on
> this topic and we also agreed to have such cgroup controller.
> He has recent presentation at Linux foundation event indicating to
> have cgroup for RDMA.
> Below is the link to it.
> http://events.linuxfoundation.org/sites/events/files/slides/containing_rdma_final.pdf
> Slides 1 to 7 and slide 13 will give you more insight to it.
> Liran and I had similar presentation to RDMA audience with less slides
> in RDMA openfabrics summit in March 2015.
>
> I am ok to create separate cgroup for rdma, if community thinks that way.
> My preference would be still use device cgroup for above extensions
> unless there are fundamental issues that I am missing.

The thing is that they aren't related at all in any way.  There's no
reason to tie them together.  In fact, the way we did devcg is
backward.  The ideal solution would have been extending the usual ACL
to understand cgroups so that it's a natural growth of the permission
system.

You're talking about actual hardware resources.  That has nothing to
do with access permissions on device nodes.

> I would let you make the call.
> Rdma and other is just another type of device with different
> characteristics than character or block, so one device cgroup with sub
> functionalities can allow setting knobs.
> Every device category will have their own set of knobs for resources,
> ACL, limits, policy.

I'm kinda doubtful we're gonna have too many of these.  Hardware
details being exposed to userland this directly isn't common.

> And I think cgroup is certainly better control point than sysfs or
> spinning of new control infrastructure for this.
> That said, I would like to hear your and communities view on how they
> would like to see this shaping up.

I'd say keep it simple and do the minimum. :)

Thanks.

-- 
tejun
