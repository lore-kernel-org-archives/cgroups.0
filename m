From: Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org>
Subject: Re: [RFC][PATCH 0/9] Make containers kernel objects
Date: Tue, 30 May 2017 09:03:13 +0800
Message-ID: <1496106193.2570.1.camel@themaw.net>
References: <149547014649.10599.12025037906646164347.stgit@warthog.procyon.org.uk>
         <87lgpoww67.fsf@xmission.com> <1495907132.4591.3.camel@primarydata.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=cc
        :content-transfer-encoding:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-sender
        :x-me-sender:x-sasl-enc:x-sasl-enc; s=fm1; bh=BbZ08qXaxrGyc/uZGT
        7NISE7/MMCCUxF2rkhEvNg44A=; b=VzdRHhObtAIBJRXLdsIQ4uwLg+itCxY50Y
        nuq1nC8SNApMDr+fYL25mORp2/68EalFiLOFugqtlup6Odv2LzhNF0ktQdh/jCag
        LhsV3+uV0pHjU4S+4d/JlvOdr3yQWelBTvimT/kB5TOgWIpeBmN39cv8rxuxYQJ+
        4DOME508xpHhJ0FagOKetOduTG0s3VNOvU/J32WRmZo/KVViklrSHROlr7xHJehZ
        SbNke07JYmT8CXJekgS8zLOMSlrZTs5oH+SjA4wlnMgMrgTwlL9UoY//LcSzV5cg
        BUyhXL8DlLrUFf21ntr8aMb9MdE8nnQSJyHYJQ5gUAY5TEUUW8WQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-sender:x-me-sender:x-sasl-enc:x-sasl-enc; s=
        fm1; bh=BbZ08qXaxrGyc/uZGT7NISE7/MMCCUxF2rkhEvNg44A=; b=PNxzgdZu
        bCnFA3jho0jcW6GcwARQXNVMwhM5dGRNYhWAyzr2xOV+Lqg+3MuPrVMP5aRYsefI
        F7a48A+DmK4ekXh2eSO0TC7Rb2MzagJ73jHzYHqcQSzZOWqnbL/gzzGzPdefhHsq
        PvpTOeplCBC2eoi0r0trlXJXQjZcih2bU1+gbQ0ObHT9rmctIlE9DPPLT5IqkfX7
        Sdw/BQTnJPAr2I5CcF7t6ZMyrosHIuyDwjqIUDAcMEZQK1EQy7RTJkMoJb0OuAtx
        OlKlRC6x1rqJPYER1a+Gr87pvETe3d6qZ8v0iS6eUwGzFiRDnkI4fwL4MTKLpKCF
        k/kgJj6UxRRFQg==
In-Reply-To: <1495907132.4591.3.camel-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Trond Myklebust <trondmy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, "ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sat, 2017-05-27 at 17:45 +0000, Trond Myklebust wrote:
> On Mon, 2017-05-22 at 14:04 -0500, Eric W. Biederman wrote:
> > David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
> > 
> > > Here are a set of patches to define a container object for the
> > > kernel and
> > > to provide some methods to create and manipulate them.
> > > 
> > > The reason I think this is necessary is that the kernel has no idea
> > > how to
> > > direct upcalls to what userspace considers to be a container -
> > > current
> > > Linux practice appears to make a "container" just an arbitrarily
> > > chosen
> > > junction of namespaces, control groups and files, which may be
> > > changed
> > > individually within the "container".
> > > 
> > 
> > I think this might possibly be a useful abstraction for solving the
> > keyring upcalls if it was something created implicitly.
> > 
> > fork_into_container for use by keyring upcalls is currently a
> > security
> > vulnerability as it allows escaping all of a containers cgroups.  But
> > you have that on your list of things to fix.  However you don't have
> > seccomp and a few other things.
> > 
> > Before we had kthreadd in the kernel upcalls always had issues
> > because
> > the code to reset all of the userspace bits and make the forked
> > task suitable for running upcalls was always missing some detail.  It
> > is
> > a very bug-prone kind of idiom that you are talking about.  It is
> > doubly
> > bug-prone because the wrongness is visible to userspace and as such
> > might get become a frozen KABI guarantee.
> > 
> > Let me suggest a concrete alternative:
> > 
> > - At the time of mount observer the mounters user namespace.
> > - Find the mounters pid namespace.
> > - If the mounters pid namespace is owned by the mounters user
> > namespace
> >   walk up the pid namespace tree to the first pid namespace owned by
> >   that user namespace.
> > - If the mounters pid namespace is not owned by the mounters user
> >   namespace fail the mount it is going to need to make upcalls as
> >   will not be possible.
> > - Hold a reference to the pid namespace that was found.
> > 
> > Then when an upcall needs to be made fork a child of the init process
> > of the specified pid namespace.  Or fail if the init process of the
> > pid namespace has died.
> > 
> > That should always work and it does not require keeping expensive
> > state
> > where we did not have it previously.  Further because the semantics
> > are
> > fork a child of a particular pid namespace's init as features get
> > added
> > to the kernel this code remains well defined.
> > 
> > For ordinary request-key upcalls we should be able to use the same
> > rules
> > and just not save/restore things in the kernel.
> > 
> > A huge advantage of my alternative (other than not being a bit-rot
> > magnet) is that it should drop into existing container infrastructure
> > without problems.  The rule for container implementors is simple to
> > use
> > security key infrastructure you need to have created a pid namespace
> > in
> > your user namespace.
> > 
> 
> While this may be part of a solution, I don't see how it can deal with
> issues such as the need to set up an RPCSEC_GSS session on behalf of
> the user. The issue there is that while the mount may have been created
> in a parent namespace, the actual call to kinit to set up a kerberos
> context is likely to have been made inside the container. It may even
> have been done using a completely separate net namespace. So in order
> to set up my RPCSEC_GSS session, I may need to do so from inside the
> user container.
> 
> In that kind of environment, might it perhaps make sense to just allow
> an upcall executable running in the root init namespace to tunnel
> through (using setns()) so it can actually execute in the context of
> the child container? That would keep security policy with the init
> namespace, but would also ensure that the container environment rules
> may be applied if and when appropriate.
> 
> In addition to today's upcall mechanism, we would need the ability to
> pass in the nsproxy (and root directory) for the confined process that
> triggered the upcall and/or the namespace for the mountpoint. I'm
> assuming that could be done by passing in a file descriptor to the
> appropriate /proc entries?

Maybe I don't quite understand what your describing ....

But the information needed (I think) is readily available at the time of the
upcall from within the container (it's not clear that really is the case based
on a later discussion). Then the process run in the init namespace can pick that
up and call (a slightly modified) setns().

I went down that burrow for quite a while and ended up leaving it at, as
Biederman so elegantly describes as, a bad half-assed implementation.

In fact I stopped perusing that approach for a couple of reasons, not the least
of which was a lack of in-depth knowledge of all the sub-systems involved (and a
complete lack of useful suggestions or help from others that are familiar with
them, that was when I stopped bothering to post the series to LKML), but also
because I thought it would lead to having an island of code sensitive to other
changes, an isolated bug-magnet so to speak.

> 
> The downside of an approach like this is that it requires container
> awareness in the upcall executables themselves. If the executables
> don't know what they are doing, they could end up leaking information
> from the init namespace to the process running in the container via the
> keyring.

Probably, maybe, but one of the requirements I was working to was this should
work without having to modify upcall binaries.

Ian
