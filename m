From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: allow management of subtrees by new cgroup
 namespaces
Date: Mon, 02 May 2016 22:26:15 -0400
Message-ID: <1462242375.3093.12.camel@HansenPartnership.com>
References: <1462110065-4904-1-git-send-email-asarai@suse.de>
	 <1462110065-4904-2-git-send-email-asarai@suse.de>
	 <1462226406.3036.17.camel@HansenPartnership.com> <572805FD.9080202@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
	s=20151216; t=1462242387;
	bh=sUcFCxlu8o/m42aq5LSo+BPRWopIVEuYIoqv77h3xbM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=i5tLoR0JGYcsWWlA865RwUdaPuNaEMjk7DtwR+C7BNK7ZowA9bdpZAZcfad3MKc+q
	 +OlL/sh4cS/MZvgmQNLz8BdoZoMfPTa5pgsTjNvltZjzxEBWT0VIMVVsCyL3m2Rw5T
	 qiyi7uj4T7uCUMXgqBxcAPkLCnVzcWzwfxJTajOo=
In-Reply-To: <572805FD.9080202-l3A5Bk7waGM@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

On Tue, 2016-05-03 at 11:59 +1000, Aleksa Sarai wrote:
> > > Change the mode of the cgroup directory for each cgroup
> > > association,
> > > allowing the process to create subtrees and modify the limits of
> > > the
> > > subtrees *without* allowing the process to modify its own limits.
> > > Due
> > > to the cgroup core restrictions and unix permission model, this
> > > allows for processes to create new subtrees without breaking the
> > > cgroup limits for the process.
> > 
> > Actually, that's not really what this patch does.  If you unshare
> > without having created any cgroups, it sets the other permission of 
> > the entire top level hierarchy to o+rwx:
> 
> While that is odd, it makes sense (because that's the "current 
> cgroup" you are in). But I agree with your point that this patch is 
> less than ideal.
> 
> > ironically, this now makes the root group a permission denier (at 
> > least for my distribution), because if I were in the root group 
> > (and not root), the r-x on the group would rule the rwx on other 
> > ... I really
> > don't think that sounds correct.
> 
> You're right, that's odd. I'm confused why your root cgroups have u-w
> though.

I've never bothered to inquire.  This is openSUSE Leap 42.1, so it's
either something systemd or something suse.

> > Perhaps what you should to be arguing then that the default 
> > permissions of the cgroup directories need to be all rwx for 
> > everyone and then your patch becomes unnecessary?
> 
> I don't think that would be the nicest way of dealing with this (then 
> a process can make very large numbers of cgroups all over the tree,
> which might not cause huge issues but would still be a pain for
> administrators and systemds alike).

Beware of what you cite as a problem.  Any user can enter a user
namespace and then unshare a cgroup namespace.  This means that what
you seem to want is equivalent to any user at all being able to create
a cgroup hierarchy.  This means that either it is a problem, and the
cgroup namespace will have to be restricted in some way over how it can
create subordinate cgroups or it's not a problem and we might as well
just see what happens if any old user can do it.

> > Alternatively, if the desire is fully to virtualize /sys/fs/cgroups
> > , then I think we have to decide how that would happen.  I think 
> > the default requirements would be that a pid namespace be 
> > established (so only the tasks in that pid namespace would be able 
> > to be controlled by the cgroup namespace.  That, I think requires 
> > that any given cgroup namespace "own" a pid namespace (being the 
> > one present when it was created) but that it only gets a new 
> > virtual set of directories owned by the userns owner if there's a 
> > pid namespace established for the cgroup and cgroup->user_ns == 
> > pid_ns->user_ns (meaning we established a user ns then a pid one 
> > then a cgroup one, so it's now safe to treat root in the user_ns as
> > owning the virtualized cgroup directories).
> 
> I know this is probably a stupid question, but why couldn't we just 
> compare the user_ns with the tcred->user_ns?

If any old user namespace can unshare a cgroup namespace and manipulate
the tree, then that condition is just fine.  If we're going to require
they have to create a pid namespace as well, then you need a more
elaborate condition.

>  Or are you worried about a process in a cgroup namespace moving 
> processes to a subtree that isn't in the same pid namespace (even 
> though they're in the same user namespace)?

The corner case I'm worrying about is what happens to a process owned
by the user that gets moved by the administrator to a more confining
cgroup after the establishment of the cgroup namespace?  If we allow
too much capability to the user_ns->owner, then they could just take it
out again.  The semantics of who can do what after the namespace is
established seem to need better definition.  One answer might be that
after the cgroup namespace is established, the real admin can't safely
move the processes, which is why they should be better confined (say
within a pid namespace) so it's not *all* processes owned by this user
that can escape control, merely ones that the user has declared a
desire to control the cgroups for).

James


>  I don't mind implementing that this way (although we'd have to
> change a bunch of the checks with pid_ns to use the cgroup_ns
> ->pid_ns), I'm just wondering if it's necessary.
> 
> > We could do this in the same way that proc gets virtualized after
> > remounting (in a new mount namespace) on fork into a pid namespace.
> 
> I actually really like this idea. I'll get to work on it.
> 
