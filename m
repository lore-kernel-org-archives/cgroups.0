From: Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org>
Subject: Re: [RFC][PATCH 0/9] Make containers kernel objects
Date: Tue, 23 May 2017 17:38:40 +0800
Message-ID: <1495532320.2564.1.camel@themaw.net>
References: <149547014649.10599.12025037906646164347.stgit@warthog.procyon.org.uk>
         <1495472039.2757.19.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=cc
        :content-transfer-encoding:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-sender
        :x-me-sender:x-sasl-enc:x-sasl-enc; s=fm1; bh=7Peb6SfxGLIg0/WCc0
        TAdyrQjFr56sS3Fy+CFfBQPFE=; b=fLYDlOSEqA90uZN5R4yI5xIerL1fjkU1AZ
        sAKdsmaHKyVir6mafGUmF4a8RjvKeaCzhdBOWUlD8xz96GbzUa62z+AG8X7Ib6Nx
        BrLpQVHhbYhOc2gKWARh1TQO3BPpkGsyneXV2YYgiZyDUsrlTaWP6rih/JYOWl+Z
        qY9dAGUHxTeH4nZPL0gw/5RJ3UJ2oLhnIl/qF0VgcD7404aV9MPX3ejZkqYrOlYz
        dj7G3oGTzXKLpdGB97vzk0jUlNTaIOHf8WkH695UgUGboeVz6FScYIyTnHUYNlED
        6EPKJaoGpS5bTDgvGojtUNnSThEqO+9zRO9chEFfC1m+OFvo03zw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-sender:x-me-sender:x-sasl-enc:x-sasl-enc; s=
        fm1; bh=7Peb6SfxGLIg0/WCc0TAdyrQjFr56sS3Fy+CFfBQPFE=; b=K0BFiynL
        IXMrCYvcrt3PWWyLEm9DIIpLm6OVk8N2RO579LUtn0ijLy/P/l2DmsFFLuB6VTjI
        jbI73wlXPEnZJoahL7odtK0w2+hGsBFxqmCljuWk+X2Snxhfe2DH+fZBVK1Jk0Bq
        UM4V9MfrxMqWHwGXnM9QYYmMh8bzd7PAZCf/L76MftVnjRKhJTokFRCjPqxwanv0
        jic1LxRRz8GXlahXjwXT5NqOYO5WGkEriSp6sMbgRNf2tGawrARjnhhVRHZk1ko1
        Q+U8jFfTQorJ1H6Ty8Q/+a91Haz1hnR3zWx70Bh3gQJAaAMycomMmh1InwNgaUz0
        j7DBKNZNevjdLQ==
In-Reply-To: <1495472039.2757.19.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, trondmy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org
Cc: mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>

On Mon, 2017-05-22 at 09:53 -0700, James Bottomley wrote:
> [Added missing cc to containers list]
> On Mon, 2017-05-22 at 17:22 +0100, David Howells wrote:
> > Here are a set of patches to define a container object for the kernel 
> > and to provide some methods to create and manipulate them.
> > 
> > The reason I think this is necessary is that the kernel has no idea 
> > how to direct upcalls to what userspace considers to be a container -
> > current Linux practice appears to make a "container" just an 
> > arbitrarily chosen junction of namespaces, control groups and files, 
> > which may be changed individually within the "container".
> 
> This sounds like a step in the wrong direction: the strength of the
> current container interfaces in Linux is that people who set up
> containers don't have to agree what they look like.  So I can set up a
> user namespace without a mount namespace or an architecture emulation
> container with only a mount namespace.
> 
> But ignoring my fun foibles with containers and to give a concrete
> example in terms of a popular orchestration system: in kubernetes,
> where certain namespaces are shared across pods, do you imagine the
> kernel's view of the "container" to be the pod or what kubernetes
> thinks of as the container?  This is important, because half the
> examples you give below are network related and usually pods share a
> network namespace.
> 
> > The kernel upcall mechanism then needs to decide which set of 
> > namespaces, etc., it must exec the appropriate upcall program. 
> >  Examples of this include:
> > 
> >  (1) The DNS resolver.  The DNS cache in the kernel should probably 
> > be per-network namespace, but in userspace the program, its
> > libraries and its config data are associated with a mount tree and a 
> > user namespace and it gets run in a particular pid namespace.
> 
> All persistent (written to fs data) has to be mount ns associated;
> there are no ifs, ands and buts to that.  I agree this implies that if
> you want to run a separate network namespace, you either take DNS from
> the parent (a lot of containers do) or you set up a daemon to run
> within the mount namespace.  I agree the latter is a slightly fiddly
> operation you have to get right, but that's why we have orchestration
> systems.
> 
> What is it we could do with the above that we cannot do today?
> 
> >  (2) NFS ID mapper.  The NFS ID mapping cache should also probably be
> >      per-network namespace.
> 
> I think this is a view but not the only one:  Right at the moment, NFS
> ID mapping is used as the one of the ways we can get the user namespace
> ID mapping writes to file problems fixed ... that makes it a property
> of the mount namespace for a lot of containers.  There are many other
> instances where they do exactly as you say, but what I'm saying is that
> we don't want to lose the flexibility we currently have.
> 
> >  (3) nfsdcltrack.  A way for NFSD to access stable storage for 
> > tracking of persistent state.  Again, network-namespace dependent, 
> > but also perhaps mount-namespace dependent.
> 
> So again, given we can set this up to work today, this sounds like more
> a restriction that will bite us than an enhancement that gives us extra
> features.
> 
> >  (4) General request-key upcalls.  Not particularly namespace 
> > dependent, apart from keyrings being somewhat governed by the user
> > namespace and the upcall being configured by the mount namespace.
> 
> All mount namespaces have an owning user namespace, so the data
> relations are already there in the kernel, is the problem simply
> finding them?
> 
> > These patches are built on top of the mount context patchset so that
> > namespaces can be properly propagated over submounts/automounts.
> 
> I'll stop here ... you get the idea that I think this is imposing a set
> of restrictions that will come back to bite us later.  If this is just
> for the sake of figuring out how to get keyring upcalls to work, then
> I'm sure we can come up with something.

You talk about a number of things I'm simply not aware of so I can't answer your
questions. But your points do sound like issues that need to be covered.

I think you mentioned user space used NFS ID mapper works fine.
I wonder, could you give more detail on that please.

Perhaps nsenter(1) is being used, I tried that as a possible usermode helper
solution and it probably did "work" in the sense of in container execution but
no-one liked it, it seems kernel folk expect to do things, well, in kernel.

Not only that there were other problems, probably request key sub system not
being namespace aware, or id caching within nfs or somewhere else, and there was
a question of not being able to cater for user namespace usage.

Anyway I do have a different view from my own experiences.

First there are a number of subsystems involved in creating a process from
within a container that has the container environment and, AFAICS (from the
usermode helper experience), it needs to be done from outside the container. For
example sub systems that need to be handled properly are the namespaces (and the
pid namespace in particular is tricky), credentials and cgroups, to name those
that come immediately to mind. I just couldn't get all that right after a number
of tries.

From this the problem that occurred to me is that we have a comprehensive
namespace implementation within the kernel but no container implementation to
help the binding together of the various sub systems for container use cases in
a way that satisfies container (or a process within an existing container)
creation.

The risk is that, as time passes, problems like usermode helper will be solved
in different places in different ways, not necessarily satisfactorily and
potentially hard to find when there are bugs and even harder to maintain than
the implementation here.

At least the interface here provides a "goto" place to define and maintain the
procedures required to do these things.

Yes, it would require change but change happens and the first pass may not be on
a par with what is currently done from a simplicity POV.

But why not see it as solving a kernel development problem and focus on what
needs to be done to make it on par with (and perhaps simpler) to cover the
current usage ....

Eric Biederman's comment is attractive indeed but I don't see how that solves
problem of having a containers sub system implementation which I think is
needed, if for no other reason than as a definition of correct usage and
localization of that usage for easier (right, nothing is easy) bug resolution.

Ian
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
