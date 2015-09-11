From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Fri, 11 Sep 2015 09:09:58 +0530
Message-ID: <CAG53R5WtuPA=J_GYPzNTAKbjB1r0K90qhXEDxLNf7vxYyxgrKA@mail.gmail.com>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
	<20150908152340.GA13749@mtj.duckdns.org>
	<CAG53R5VnYJ9+VEKtbnFO1HntSp=O=ZGiknucbQ-QLuEk_UP44w@mail.gmail.com>
	<20150910164946.GH8114@mtj.duckdns.org>
	<CAG53R5XyfQxrA+FUKFaZi7ZBhSz-SW6eGkGUZpdo6hUTBkAO-g@mail.gmail.com>
	<20150910202210.GL8114@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=W2GsAHhXvS1YwOPEcq7DppYEs62rhOFLdpFjNYYdIZg=;
        b=pYMOVmFIs9h1N5t0CJP1DyeGw1izrW4BtO2CinITS0/fpGtONdW9TidKXq/y1s6MmR
         WpzL9pa3Ye6Bvl1BCxZ9psDfZ2geOPGQKsCy2DyIhqx9XfSez+tALPFeU2kpRVTIwCy3
         Qik//gJ+lnJj90Hn5IQaWAl9KmN3XA5oCp2+EX/F3x8mACxaqgZxGUUMwXlTPxC3DSe9
         wJsGjRFEJ/ONNAEFBsHNVKIHmfkNC9AC3rkEluTZQY06kkYWmt+ZR3ZeVIo3TsfdU8JL
         AjCMrGIuv/J0wxvRI8jmajTUWDEGGS4/oEZwzS5NSEku/4vdFR3MMlfP+smDCaGD0NqE
         HPxA==
In-Reply-To: <20150910202210.GL8114@mtj.duckdns.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Haggai Eran <haggaie@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On Fri, Sep 11, 2015 at 1:52 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Parav.
>
> On Thu, Sep 10, 2015 at 11:16:49PM +0530, Parav Pandit wrote:
>> >> These resources include are-  QP (queue pair) to transfer data, CQ
>> >> (Completion queue) to indicate completion of data transfer operation,
>> >> MR (memory region) to represent user application memory as source or
>> >> destination for data transfer.
>> >> Common resources are QP, SRQ (shared received queue), CQ, MR, AH
>> >> (Address handle), FLOW, PD (protection domain), user context etc.
>> >
>> > It's kinda bothering that all these are disparate resources.
>>
>> Actually not. They are linked resources. Every QP needs associated one
>> or two CQ, one PD.
>> Every QP will use few MRs for data transfer.
>
> So, if that's the case, let's please implement something higher level.
> The goal is providing reasonable isolation or protection.  If that can
> be achieved at a higher level of abstraction, please do that.
>
>> Here is the good programming guide of the RDMA APIs exposed to the
>> user space application.
>>
>> http://www.mellanox.com/related-docs/prod_software/RDMA_Aware_Programming_user_manual.pdf
>> So first version of the cgroups patch will address the control
>> operation for section 3.4.
>>
>> > I suppose that each restriction comes from the underlying hardware and
>> > there's no accepted higher level abstraction for these things?
>>
>> There is higher level abstraction which is through the verbs layer
>> currently which does actually expose the hardware resource but in
>> vendor agnostic way.
>> There are many vendors who support these verbs layer, some of them
>> which I know are Mellanox, Intel, Chelsio, Avago/Emulex whose drivers
>> which support these verbs are in <drivers/infiniband/hw/> kernel tree.
>>
>> There is higher level APIs above the verb layer, such as MPI,
>> libfabric, rsocket, rds, pgas, dapl which uses underlying verbs layer.
>> They all rely on the hardware resource. All of these higher level
>> abstraction is accepted and well used by certain application class. It
>> would be long discussion to go over them here.
>
> Well, the programming interface that userland builds on top doesn't
> matter too much here but if there is a common resource abstraction
> which can be made in terms of constructs that consumers of the
> facility would care about, that likely is a better choice than
> exposing whatever hardware exposes.
>

Tejun,
The fact is that user level application uses hardware resources.
Verbs layer is software abstraction for it. Drivers are hiding how
they implement this QP or CQ or whatever hardware resource they
project via API layer.
For all of the userland on top of verb layer I mentioned above, the
common resource abstraction is these resources AH, QP, CQ, MR etc.
Hardware (and driver) might have different view of this resource in
their real implementation.
For example, verb layer can say that it has 100 QPs, but hardware
might actually have 20 QPs that driver decide how to efficiently use
it.

>> > I'm doubtful that these things are gonna be mainstream w/o building up
>> > higher level abstractions on top and if we ever get there we won't be
>> > talking about MR or CQ or whatever.
>>
>> Some of the higher level examples I gave above will adapt to resource
>> allocation failure. Some are actually adaptive to few resource
>> allocation failure, they do query resources. But its not completely
>> there yet. Once we have this notion of limited resource in place,
>> abstraction layer would adapt to relatively smaller value of such
>> resource.
>>
>> These higher level abstraction is mainstream. Its shipped at least in
>> Redhat Enterprise Linux.
>
> Again, I was talking more about resource abstraction - e.g. something
> along the line of "I want N command buffers".
>

Yes. We are still talking of resource abstraction here.
RDMA and IBTA defines these resources. On top of these resources
various frameworks are build.
so for example,
User land is tuning environment deploying for MPI application,
it would configure:
10 processes from the PID controller,
10 CPUs in cpuset controller,
1 PD, 20 CQ, 10 QP, 100 MRs in rdma controller,

say user land is tuning environment for deploying rsocket application
for 100 connections,
it would configure, 100 PD, 100 QP, 200 MR.
When verb layer see failure with it, they will adapt to live with what
they have at lower performance.

Since every higher level which I mentioned in different in the way, it
uses RDMA resources, we cannot generalize it as "N command buffers".
That generalization in my mind is the - rdma resources - central common entity.

>> > Also, whatever next-gen is
>> > unlikely to have enough commonalities when the proposed resource knobs
>> > are this low level,
>>
>> I agree that resource won't be common in next-gen other transport
>> whenever they arrive.
>> But with my existing background working on some of those transport,
>> they appear similar in nature and it might seek similar knobs.
>
> I don't know.  What's proposed in this thread seems way too low level
> to be useful anywhere else.  Also, what if there are multiple devices?
> Is that a problem to worry about?
>
o.k. It doesn't have to be useful anywhere else. If it suffice the
need of RDMA applications, its fine for near future.
This patch allows limiting resources across multiple devices.
As we go along the path, and if requirement come up to have knob on
per device basis, thats something we can extend in future.

>
>> I would let you make the call.
>> Rdma and other is just another type of device with different
>> characteristics than character or block, so one device cgroup with sub
>> functionalities can allow setting knobs.
>> Every device category will have their own set of knobs for resources,
>> ACL, limits, policy.
>
> I'm kinda doubtful we're gonna have too many of these.  Hardware
> details being exposed to userland this directly isn't common.
>

Its common in RDMA applications. Again they may not be real hardware
resource, its just API layer which defines those RDMA constructs.

>> And I think cgroup is certainly better control point than sysfs or
>> spinning of new control infrastructure for this.
>> That said, I would like to hear your and communities view on how they
>> would like to see this shaping up.
>
> I'd say keep it simple and do the minimum. :)
>
o.k. In that case new rdma cgroup controller which does rdma resource
accounting is possibly the most simplest form?
Make sense?

> Thanks.
>
> --
> tejun
