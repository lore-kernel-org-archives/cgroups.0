From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [RFC][PATCH 0/9] Make containers kernel objects
Date: Tue, 23 May 2017 08:02:31 -0700
Message-ID: <1495551751.10876.17.camel@HansenPartnership.com>
References: <1495472039.2757.19.camel@HansenPartnership.com>
         <149547014649.10599.12025037906646164347.stgit@warthog.procyon.org.uk>
         <32556.1495547529@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1495551753;
        bh=gHww/yf79orRz4b3aul40lboEjv3n3GlPItmzvB//Z0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qgSJF+/CIzjsE0wwHhSUOEi28zyABkohtCX8yxz4t6hjeSj4k15En137mZwPC4Maj
         htH68RbW6knG0vHc7S5boYs7iQPlrsE8IiVuMDoJo/JlhBh89EyxZSPwL1KPPKHA8C
         Adu7pqlFaWyg4xz90sX+kDhBgas3i8jLe7ZO6zMg=
In-Reply-To: <32556.1495547529-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trondmy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org

On Tue, 2017-05-23 at 14:52 +0100, David Howells wrote:
> James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> 
> > This sounds like a step in the wrong direction: the strength of the
> > current container interfaces in Linux is that people who set up
> > containers don't have to agree what they look like.
> 
> It may be a strength, but it is also a problem.
> 
> > So I can set up a user namespace without a mount namespace or an
> > architecture emulation container with only a mount namespace.
> 
> (I presume you mean with only the mount namespace separate)
> 
> Yep.  You can do that with this too.
> 
> > But ignoring my fun foibles with containers and to give a concrete
> > example in terms of a popular orchestration system: in kubernetes,
> > where certain namespaces are shared across pods, do you imagine the
> > kernel's view of the "container" to be the pod or what kubernetes
> > thinks of as the container?
> 
> Why not both?  If the net_ns is created in the pod container, then
> probably
> network-related upcalls should be directed there.  Unless instructed
> otherwise, upon creation a container object will inherit the caller's
> namespaces.

The pod isn't a container, it's a collection of containers.  Lets say
each container has a separate mount namespace but shares a network
namespace (this is a gross simplification, there are many other ways
you can set up a pod, but this one illustrates the point).  For your
upcall you'd have to pick a kubernetes container and you don't have the
information to do that, even with your current patches, because what
kubernetes has done.  This is where your view of "container" doesn't
match the kubernetes view.

> > This is important, because half the examples you give below are 
> > network related and usually pods share a network namespace.
> 
> Yeah - I'm more familiar with upcalls made by NFS, AFS and keyrings.

OK, so rather than getting into the technical back and forth below can
we agree that the kernel can't have a unitary view of "container"
because the current use cases (the orchestration systems) don't have
one?  Then the next step becomes how can we add an abstraction that
gives you what you want (as far as I can tell basically identifying a
set of namespaces for an upcall) in a way that doesn't bind the kernel
to have a unitary view of a container? And then we can tack the ideas
on to the Jeff/Eric subthread.

James

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
