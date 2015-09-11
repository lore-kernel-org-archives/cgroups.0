From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Fri, 11 Sep 2015 10:52:13 -0400
Message-ID: <20150911145213.GQ8114@mtj.duckdns.org>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
 <20150908152340.GA13749@mtj.duckdns.org>
 <CAG53R5VnYJ9+VEKtbnFO1HntSp=O=ZGiknucbQ-QLuEk_UP44w@mail.gmail.com>
 <20150910164946.GH8114@mtj.duckdns.org>
 <CAG53R5XyfQxrA+FUKFaZi7ZBhSz-SW6eGkGUZpdo6hUTBkAO-g@mail.gmail.com>
 <20150910202210.GL8114@mtj.duckdns.org>
 <CAG53R5WtuPA=J_GYPzNTAKbjB1r0K90qhXEDxLNf7vxYyxgrKA@mail.gmail.com>
 <20150911040413.GA18850@htj.duckdns.org>
 <55F25781.20308@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=QQ0sYe4DlT/SoSS3uxZVgG0PPLeFUCv+GIKglkkAHn4=;
        b=DuO4GfVANzB1acp3CyrL5LN9Gb6pD88nORrfVX7yZMOoIos7MhSyKBx8MBGFCpJpl0
         iUdeb67xhOX1lsJh7DlA1wl/XtcGP/IaLI3ucezb5/X5Bg4yYdbxokCVaSnBQvAB2Rgy
         ybIiO4A3K41ztmAZDgoO+/umDQD0s9PcMiHlZ7y6SCXzDFuIrG1UfIsFWRP2FHcMgKLh
         uxgFPTdEIsfIaqlbrfRLBdltJ35UbjhJE6MZ1V/vo0aBaSDmaZ6h3Pat10JdM0X+Qm7A
         pKPMNrutTR+39JyyS67Fq1JXxxkGIqvTscT6+So4NtHoDKVeKimlnfAFSdkg0fzAiAtE
         4ZZw==
Content-Disposition: inline
In-Reply-To: <55F25781.20308-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Doug.

On Fri, Sep 11, 2015 at 12:24:33AM -0400, Doug Ledford wrote:
> > My uneducated suspicion is that the abstraction is just not developed
> > enough.
> 
> The abstraction is 10+ years old.  It has had plenty of time to ferment
> and something better for the specific use case has not emerged.

I think that is likely more reflective of the use cases rather than
anything inherent in the concept.

> >  It should be possible to virtualize these resources through,
> > most likely, time-sharing to the level where userland simply says "I
> > want this chunk transferred there" and OS schedules the transfer
> > prioritizing competing requests.
> 
> No.  And if you think this, then you miss the *entire* point of RDMA
> technologies.  An analogy that I have used many times in presentations
> is that, in the networking world, the kernel is both a postman and a
> copy machine.  It receives all incoming packets and must sort them to
> the right recipient (the postman job) and when the user space
> application is ready to use the information it must copy it into the
> user's VM space because it couldn't just put the user's data buffer on
> the RX buffer list since each buffer might belong to anyone (the copy
> machine).  In the RDMA world, you create a new queue pair, it is often a
> long lived connection (like a socket), but it belongs now to the app and
> the app can directly queue both send and receive buffers to the card and
> on incoming packets the card will be able to know that the packet
> belongs to a specific queue pair and will immediately go to that apps
> buffer.  You can *not* do this with TCP without moving to complete TCP
> offload on the card, registration of specific sockets on the card, and
> then allowing the application to pre-register receive buffers for a
> specific socket to the card so that incoming data on the wire can go
> straight to the right place.  If you ever get to the point of "OS
> schedules the transfer" then you might as well throw RDMA out the window
> because you have totally trashed the benefit it provides.

I don't know.  This sounds like classic "this is painful so it must be
good" bare metal fantasy.  I get that rdma succeeds at bypassing a lot
of overhead.  That's great but that really isn't exclusive with having
more accessible mechanisms built on top.  The crux of cost saving is
the hardware knowing where the incoming data belongs and putting it
there directly.  Everything else is there to facilitate that and if
you're declaring that it's impossible to build accessible abstractions
for that, I can't agree with you.

Note that this is not to say that rdma should do that in the operating
system.  As you said, people have been happy with the bare abstraction
for a long time and, given relatively specialized use cases, that can
be completely fine but please do note that the lack of proper
abstraction isn't an inherent feature.  It's just easier that way and
putting in more effort hasn't been necessary.

> > It could be that given the use cases rdma might not need such level of
> > abstraction - e.g. most users want to be and are pretty close to bare
> > metal, but, if that's true, it also kinda is weird to build
> > hierarchical resource distribution scheme on top of such bare
> > abstraction.
> 
> Not really.  If you are going to have a bare abstraction, this one isn't
> really a bad one.  You have devices.  On a device, you allocate
> protection domains (PDs).  If you don't care about cross connection
> issues, you ignore this and only use one.  If you do care, this acts
> like a process's unique VM space only for RDMA buffers, it is a domain
> to protect the data of one connection from another.  Then you have queue
> pairs (QPs) which are roughly the equivalent of a socket.  Each QP has
> at least one Completion Queue where you get the events that tell you
> things have completed (although they often use two, one for send
> completions and one for receive completions).  And then you use some
> number of memory registrations (MRs) and address handles (AHs) depending
> on your usage.  Since RDMA stands for Remote Direct Memory Access, as
> you can imagine, giving a remote machine free reign to access all of the
> physical memory in your machine is a security issue.  The MRs help to
> control what memory the remote host on a specific QP has access to.  The
> AHs control how we actually route packets from ourselves to the remote host.
> 
> Here's the deal.  You might be able to create an abstraction above this
> that hides *some* of this.  But it can't hide even nearly all of it
> without loosing significant functionality.  The problem here is that you
> are thinking about RDMA connections like sockets.  They aren't.  Not
> even close.  They are "how do I allow a remote machine to directly read
> and write into my machines physical memory in an even remotely close to
> secure manner?"  These resources aren't hardware resources, they are the
> abstraction resources needed to answer that question.

So, the existence of resource limitations is fine.  That's what we
deal with all the time.  The problem usually with this sort of
interfaces which expose implementation details to users directly is
that it severely limits engineering manuevering space.  You usually
want your users to express their intentions and a mechanism to
arbitrate resources to satisfy those intentions (and in a way more
graceful than "we can't, maybe try later?"); otherwise, implementing
any sort of high level resource distribution scheme becomes painful
and usually the only thing possible is preventing runaway disasters -
you don't wanna pin unused resource permanently if there actually is
contention around it, so usually all you can do with hard limits is
overcommiting limits so that it at least prevents disasters.

cpuset is a special case but think of cpu, memory or io controllers.
Their resource distribution schemes are a lot more developed than
what's proposed in this patchset and that's a necessity because nobody
wants to cripple their machines for resource control.  This is a lot
more like the pids controller and that controller's almost sole
purpose is preventing runaway workload wrecking the whole machine.

It's getting rambly but the point is that if the resource being
controlled by this controller is actually contended for performance
reasons, this sort of hard limiting is inherently unlikely to be very
useful.  If the resource isn't and the main goal is preventing runaway
hogs, it'll be able to do that but is that the goal here?  For this to
be actually useful for performance contended cases, it'd need higher
level abstractions.

Thanks.

-- 
tejun
