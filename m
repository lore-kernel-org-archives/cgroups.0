From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Tue, 15 Sep 2015 08:38:54 +0530
Message-ID: <CAG53R5XY1q+AqJvgtK_Qd4Sai2kZX9vhDKD_2dNXpw4Gf=nz0A@mail.gmail.com>
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
	<20150914201840.GA8764@obsidianresearch.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=1EMe0M73sup8c8OIJlpfzyPW3QNPvss6vN66swhQfa8=;
        b=I0UcCV1xXG2duUsO4q3recTkvd+Vece4UQsUxh8gU/C0aNQP2PcsHRlM3R+59VDC7x
         DLLCM7iAbER4gvdB+/AgVHPNFE5b7I3xH55yJfVWhjCDpffuHcah96MIzLWo3IFvySpU
         xfRNej2xtPC0Nia038pCH9zwZooXu9SNVTJ2WaNUEJoVi06XmBLDr7dktiDXrmwsjff9
         Xqbf8LbYij7k6PVOe9Vht7ZPxUmJlCWKgfucyg3s0KIqnA3F8nzf+HwDAqKjBlqeq6uD
         0Noo8+08fzJhbfeu2zZVBNUXHSO9bP39IbAP/ADsze8M0epKByaCOJ7fH4/syu5jP5O4
         2IoQ==
In-Reply-To: <20150914201840.GA8764@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: "Hefty, Sean" <sean.hefty@intel.com>, Tejun Heo <tj@kernel.org>, Doug Ledford <dledford@redhat.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "lizefan@huawei.com" <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, "james.l.morris@oracle.com" <james.l.morris@oracle.com>, "serge@hallyn.com" <serge@hallyn.com>, Haggai Eran <haggaie@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, "raindel@mellanox.com" <raindel@mellanox.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>

> Because actual hardware resources *ARE* the limit. We cannot abstract
> it away. The hardware/driver has real, fixed, immutable limits. No API
> abstraction can possibly change that.
>
> The limits are such there *IS NO* API boundary that can bundle them
> into something simpler. There will always be apps that require wildly
> different ratios of the basic verbs resources (PD/QP/CQ/AH/MR)
>
> Either we control each and every vendor's limited resource directly
> (which is where you started), or we just roll them up into a 'all
> resource' bundle and control them indirectly. There just isn't a
> mythical third 'better API' choice with the hardware we have today.
>

As you precisely described, about wild ratio,
we are asking vendor driver (bottom most layer) to statically define
what the resource pool is, without telling him which application are
we going to run to use those pool.
Therefore vendor layer cannot ever define "right" resource pool.

If we try to fix defining "right" resource pool, we will have to come
up with API to modify/tune individual element of the pool.
Once we bring that complexity, it becomes what is proposed in this pachset.

Instead of bringing such complex solution, that affecting all the
layers which solves the same problem as this patch,
its better to keep definition of "bundle" in the user
library/application deployment engine.
where bundle is set of those resources.

May be instead of having invidividual files for each resource, at user
interface level, we can have rdma.bundle file.
this bundle cgroup file defines these resources such as
"ah 100
mr 100
qp 10"

> So? I don't think it is really important to have an exact, precise,
> limit. The HW pools are pretty big, unless you plan to run tens of
> thousands of containers eacg with tiny RDMA limits, it is fine to talk
> in broader terms (ie 10% of all HW limited resource) which is totally
> adaquate to hard-prevent run away or exhaustion scenarios.
>

rdma cgroup will allow us to run post 512 or 1024 containers without
using PCIe SR-IOV, without creating any vendor specific resource
pools.


> Jason
