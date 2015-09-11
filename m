From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Fri, 11 Sep 2015 10:13:59 +0530
Message-ID: <CAG53R5WW8QRHmopva260BPgvfH3xeq16d2ChGTcEtBwFbhNdfw@mail.gmail.com>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
	<20150908152340.GA13749@mtj.duckdns.org>
	<CAG53R5VnYJ9+VEKtbnFO1HntSp=O=ZGiknucbQ-QLuEk_UP44w@mail.gmail.com>
	<20150910164946.GH8114@mtj.duckdns.org>
	<CAG53R5XyfQxrA+FUKFaZi7ZBhSz-SW6eGkGUZpdo6hUTBkAO-g@mail.gmail.com>
	<20150910202210.GL8114@mtj.duckdns.org>
	<CAG53R5WtuPA=J_GYPzNTAKbjB1r0K90qhXEDxLNf7vxYyxgrKA@mail.gmail.com>
	<20150911040413.GA18850@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=Jb7AmTHPdUrDe8GPWn4F9GNLpga+hNICb6cWRVNd4Pg=;
        b=gHq5WJq8O2stcmZEM79efOu9fB3+vnD1IdVClRiHdSSPjyI/oRi2LPLRd6NOGhNted
         IW6gDGrTPYvSTfTJhWZ7rI8csyElUA9FCgY8Bx7JnqF+nYB5aOkOuxDdPibIVmYwk7T8
         0sAdV4uhKAYlTKrZwaus1Hcp+xKlRSrm43TufR2f+k9FI6ljN2BHEyLK/rdD2cpdalSf
         D2oqIBYg1U38QpKWqRnMUq+BnDlBAh2xlKhHk7PGWId1xPINpnouWd7MGtBZGa3kCFfe
         2eARwANHEPDdXyckgbARQvjmCbTBP0Yp/HILFrlLEGfIFlMXyg73CIbPSZerTwov0SFf
         NX5w==
In-Reply-To: <20150911040413.GA18850@htj.duckdns.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Haggai Eran <haggaie@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On Fri, Sep 11, 2015 at 9:34 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Parav.
>
> On Fri, Sep 11, 2015 at 09:09:58AM +0530, Parav Pandit wrote:
>> The fact is that user level application uses hardware resources.
>> Verbs layer is software abstraction for it. Drivers are hiding how
>> they implement this QP or CQ or whatever hardware resource they
>> project via API layer.
>> For all of the userland on top of verb layer I mentioned above, the
>> common resource abstraction is these resources AH, QP, CQ, MR etc.
>> Hardware (and driver) might have different view of this resource in
>> their real implementation.
>> For example, verb layer can say that it has 100 QPs, but hardware
>> might actually have 20 QPs that driver decide how to efficiently use
>> it.
>
> My uneducated suspicion is that the abstraction is just not developed
> enough.  It should be possible to virtualize these resources through,
> most likely, time-sharing to the level where userland simply says "I
> want this chunk transferred there" and OS schedules the transfer
> prioritizing competing requests.

Tejun,
That is such a perfect abstraction to have at OS level, but not sure
how much close it can be to bare metal RDMA it can be.
I have started discussion on that front as well as part of other
thread, but its certainly long way to go.
Most want to enjoy the performance benefit of the bare metal
interfaces it provides.

Such abstraction that you mentioned, exists, the only difference is
instead of its OS as central entity, its the higher level libraries,
drivers and hw together does it today for the applications.


>
> It could be that given the use cases rdma might not need such level of
> abstraction - e.g. most users want to be and are pretty close to bare
> metal, but, if that's true, it also kinda is weird to build
> hierarchical resource distribution scheme on top of such bare
> abstraction.
>
> ...
>> > I don't know.  What's proposed in this thread seems way too low level
>> > to be useful anywhere else.  Also, what if there are multiple devices?
>> > Is that a problem to worry about?
>>
>> o.k. It doesn't have to be useful anywhere else. If it suffice the
>> need of RDMA applications, its fine for near future.
>> This patch allows limiting resources across multiple devices.
>> As we go along the path, and if requirement come up to have knob on
>> per device basis, thats something we can extend in future.
>
> You kinda have to decide that upfront cuz it gets baked into the
> interface.

Well, all the interfaces are not yet defined. Except the test and
benchmark utilities, real world applications wouldn't really bother
much about which device are they are going through.
so I expect that per device level control would nice for very specific
applications, but I don't anticipate that in first place.
If others have different view, I would be happy to hear that.

Even if we extend per device control, I would expect per cgroup
control at top level without which its uncontrolled access.

>
>> > I'm kinda doubtful we're gonna have too many of these.  Hardware
>> > details being exposed to userland this directly isn't common.
>>
>> Its common in RDMA applications. Again they may not be real hardware
>> resource, its just API layer which defines those RDMA constructs.
>
> It's still a very low level of abstraction which pretty much gets
> decided by what the hardware and driver decide to do.
>
>> > I'd say keep it simple and do the minimum. :)
>>
>> o.k. In that case new rdma cgroup controller which does rdma resource
>> accounting is possibly the most simplest form?
>> Make sense?
>
> So, this fits cgroup's purpose to certain level but it feels like
> we're trying to build too much on top of something which hasn't
> developed sufficiently.  I suppose it could be that this is the level
> of development that rdma is gonna reach and dumb cgroup controller can
> be useful for some use cases.  I don't know, so, yeah, let's keep it
> simple and avoid doing crazy stuff.
>

o.k. thanks. I would wait for some more time to collect more feedback.
In absence of that,

I will send updated patch V1 which will include,
(a) functionality of this patch in new rdma cgroup as you recommended,
(b) fixes for comments from Haggai for this patch
(c) more fixes which I have done in mean time

> Thanks.
>
> --
> tejun
