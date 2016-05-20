From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH v4 0/2] cgroup: allow management of subtrees by new
 cgroup namespaces
Date: Fri, 20 May 2016 13:28:46 -0400
Message-ID: <1463765326.8091.42.camel@HansenPartnership.com>
References: <1463196000-13900-1-git-send-email-asarai@suse.de>
	 <573F23D0.2030500@suse.de> <20160520152244.GB5632@htj.duckdns.org>
	 <1463758258.8091.3.camel@HansenPartnership.com>
	 <20160520160352.GC5632@htj.duckdns.org>
	 <1463760550.8091.13.camel@HansenPartnership.com>
	 <20160520161759.GD5632@htj.duckdns.org>
	 <1463761509.8091.19.camel@HansenPartnership.com>
	 <20160520165326.GE5632@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
	s=20151216; t=1463765328;
	bh=RiRO2KCcND1jl6AtQ0q7Ai2UQQjbazEbXJj63pM/ICg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=lp5rRto1aV9kJDdlWOQSwmKLXZRDeHHvIfQ5UdnO8BV1ozvaU2EnRwXyPbhCyEDge
	 fSkryZpjoT9QYPGopQ/Nmvb23P0IcxK4e8wVdSX0olMTlZkvGQZs90HGbzowY/sDi0
	 xLxEmJyFpS98le97I7Jy1cTq2+q0xhQTlM4MV3xI=
In-Reply-To: <20160520165326.GE5632-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org

On Fri, 2016-05-20 at 12:53 -0400, Tejun Heo wrote:
> Hello,
> 
> On Fri, May 20, 2016 at 12:25:09PM -0400, James Bottomley wrote:
> > OK, so is the only problem cleanup?  If so, what if I proposed that
> > a
> 
> For generic cases, it's a much larger problem.  We'd have to change
> delegation model completely so that delegations are allowed by
> default, which btw can't be allowed on v1 hierarchies as some
> controllers don't behave properly hierarchically in v1 and would 
> allow unpriv users to escape the constraints of its ancestors.

Just so I'm clear: by delegation you mean create a subdirectory in the
cgroup hierarchy with a non-root owner?  We may have a solution for the
escape constraints problem: see below.

> > cgroup directory could only be created by the owner of the userns
> > (which would be any old unprivileged user) iff they create a cgroup 
> > ns and the cgroup ns would be responsible for removing it again, so
> > the cgroup subdirectory would be tied to the cgroup namespace as 
> > its holder and we'd use release of the cgroup to remove all the
> > directories?
> 
> Unfortunately, cgroup hierarchy isn't designed to support this sort 
> of automatic delegation.  Unpriv processes would be able to escape
> constraints on v1 with some controllers and on v2 controllers have to
> be explicitly enabled by root for delegated scope to have access to
> them.

Not necessarily.  We also talked about pinning the cgroup tree so that
once you enter the cgroup namespace, your current cgroup directory
becomes your root, meaning you can't cd back into the ancestors and
thus can't write their tasks file, meaning, I think, that it should be
impossible to escape ancestor constraints.

>   We can try to isolate these delegated subtrees and make them
> work transparently, which rgroup tried to do, but that collides
> directly with the vfs conventions (rgroups don't show up in cgroup 
> hierarchy at all so avoid this problem).

Well, let's see if we can solve it within the current framework first.

> 
> Why does an unpriv NS need to have cgroup delegated to it without
> cooperation from cgroup manager?

There's actually many answers to this.  The one I'm insterested in is
the ability for applications to make use of container features without
having to ask permission from some orchestration engine.  The problem
most people are looking at is how do I prevent the cgroup manager from
running as root, because that's a security problem waiting to happen.

>   If for resource control, I'm pretty sure we don't want to allow 
> that without explicit cooperation from the enclosing scope.

The enclosing scope should be allowed to define the parameters (happens
today with namespaces) but there shouldn't be an active "thing" which
is the permission gateway.

>   Overall, it feels like this is trying to work around an issue which
> should be solved from userland.

So it's not impossible to have some setuid (or CAP_ scoped) universal
binary do this.  We do this today for the user namespace range of uids
problem.  However, it would have to be something that operated
independently of the cgroup manager, since every container
orchestration system wants to be their own cgroup manager, so there's
no one true one.

James

