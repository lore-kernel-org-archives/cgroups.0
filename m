From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Mon, 14 Sep 2015 14:18:40 -0600
Message-ID: <20150914201840.GA8764@obsidianresearch.com>
References: <CAG53R5WtuPA=J_GYPzNTAKbjB1r0K90qhXEDxLNf7vxYyxgrKA@mail.gmail.com>
 <20150911040413.GA18850@htj.duckdns.org>
 <55F25781.20308@redhat.com>
 <20150911145213.GQ8114@mtj.duckdns.org>
 <1828884A29C6694DAF28B7E6B8A82373A903A586@ORSMSX109.amr.corp.intel.com>
 <20150911194311.GA18755@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373A903A5DB@ORSMSX109.amr.corp.intel.com>
 <CAG53R5XsMwnLK7L4q1mQx3_wEJNv1qthOr5TsX0o43kRWaiWrg@mail.gmail.com>
 <20150914172832.GA21652@obsidianresearch.com>
 <CAG53R5XHTv-o+pGHdw+hGgtv4N3ZkH0WTs6o_W3zK_6jAnVsNA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=obsidianresearch.com; s=rsa1;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=PtDQnyVLOvQD9HKSiPjDhCKZu8/phCmNMx2BbWLDy4g=;
	b=QzZFevX20GYbOjpAl1hLx9ibAkzkCW1uTtWj9N9FvehphRqK2WPipZX17EDmRkShmzY1u4SrlQXdpn176gjovSTjVHeKXFm478JZ028vNfPUQTogjOR+m1I3D98LQFxkVtXl7grhvW1/d2uwm+8T2gWyfhClKL0xIAZQyl5jgKk=;
Content-Disposition: inline
In-Reply-To: <CAG53R5XHTv-o+pGHdw+hGgtv4N3ZkH0WTs6o_W3zK_6jAnVsNA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav@gmail.com>
Cc: "Hefty, Sean" <sean.hefty@intel.com>, Tejun Heo <tj@kernel.org>, Doug Ledford <dledford@redhat.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "lizefan@huawei.com" <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, "james.l.morris@oracle.com" <james.l.morris@oracle.com>, "serge@hallyn.com" <serge@hallyn.com>, Haggai Eran <haggaie@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, "raindel@mellanox.com" <raindel@mellanox.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>

On Tue, Sep 15, 2015 at 12:24:41AM +0530, Parav Pandit wrote:
> On Mon, Sep 14, 2015 at 10:58 PM, Jason Gunthorpe
> <jgunthorpe@obsidianresearch.com> wrote:
> > On Mon, Sep 14, 2015 at 04:39:33PM +0530, Parav Pandit wrote:
> >
> >> 1. How does the % of resource, is different than absolute number? With
> >> rest of the cgroups systems we define absolute number at most places
> >> to my knowledge.
> >
> > There isn't really much choice if the abstraction is a bundle of all
> > resources. You can't use an absolute number unless every possible
> > hardware limited resource is defined, which doesn't seem smart to me
> > either.
> 
> Absolute number of percentage is representation for a given property.
> That property needs definition. Isn't it?
> How do we say that "Some undefined" resource you give certain amount,
> which user doesn't know about what to administer, or configure.
> It has to be quantifiable entity.

Each vendor can quantify exactly what HW resources their
implementation has and how the above limit impacts their card. There
will be many variations, and IIRC, some vendors have resource pools
not directly related to the standard PD/QP/MR/CQ/AH verbs resources.

> > It is not abstract enough, and doesn't match our universe of
> > hardware very well.

> Why does the user need to know the actual hardware resource limits or
> define hardware based resource.

Because actual hardware resources *ARE* the limit. We cannot abstract
it away. The hardware/driver has real, fixed, immutable limits. No API
abstraction can possibly change that.

The limits are such there *IS NO* API boundary that can bundle them
into something simpler. There will always be apps that require wildly
different ratios of the basic verbs resources (PD/QP/CQ/AH/MR)

Either we control each and every vendor's limited resource directly
(which is where you started), or we just roll them up into a 'all
resource' bundle and control them indirectly. There just isn't a
mythical third 'better API' choice with the hardware we have today.

> (a) how many number of RDMA connections are allowed instead of QP, or CQ or AH.
> (b) how many data transfer buffers to use.

None of that accurately reflects what the real HW limits actually are.

> > ie Presumably some fairly small limitation like 10MB is enough for
> > most non-MPI jobs.
> 
> Container application always write a simple for loop code to take away
> majority of QP with 10MB limit.

No, the HW and kmem limits must work together, the HW limit would
prevent exhaustion outside the container.

> Imagine instead of tcp_bytes or kmem bytes, its "some memory
> resource", how would someone debug/tune a system with abstract knobs?

Well, we have the memcg controller that does track kmem. The subsystem
specific kmem limit is to force fair sharing of the limited kmem
resource within the overall memcg limit.

They are complementary.

A fictional rdma_kmem and tcp_kmem would serve very similar purposes.

> > UAPI wise, nobdy has to care if the limit is actually # of QPs or
> > something else.

> If we dont care about resource, we cannot tune or limit it. number of
> MRs used by MPI vs rsocket vs accelio is way different.

So? I don't think it is really important to have an exact, precise,
limit. The HW pools are pretty big, unless you plan to run tens of
thousands of containers eacg with tiny RDMA limits, it is fine to talk
in broader terms (ie 10% of all HW limited resource) which is totally
adaquate to hard-prevent run away or exhaustion scenarios.

Jason
