From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH v1 3/3] cgroup: relax common ancestor restriction for
 direct descendants
Date: Thu, 21 Jul 2016 07:51:49 -0700
Message-ID: <1469112709.2331.11.camel@HansenPartnership.com>
References: <20160718161816.13040-1-asarai@suse.de>
	 <20160718161816.13040-4-asarai@suse.de>
	 <20160720155147.GG4574@htj.duckdns.org>
	 <6e975d80-4077-fb8b-ec84-708e37c8e149@suse.de>
	 <20160720230228.GA19588@mtj.duckdns.org>
	 <982fcf3a-3685-9bd7-dd95-7bff255c9421@suse.de>
	 <20160720231949.GB19588@mtj.duckdns.org>
	 <379e5b13-29d4-ca75-1935-0a64f3db8d27@suse.de>
	 <20160721143330.GA5751@mail.hallyn.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
	s=20151216; t=1469112711;
	bh=cZJeYcdJZJmWC3xiZDfFIJQpfA2DKUiz07S6lC5cDe4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=cQR4jMEVJEjU09KydQbr2Pqx12nYwPLlAJH7Q97vf6iohU+SXqlwSYZQeCwZAeW0Y
	 YvTIbJB7IPsPbc4bg9N3Qdbp4nXnfUvHY4IPhw3NpT5SRcnDys103NPBGfxFOPKRPw
	 1U4AMrEAUmq0OcHCY3hQGIza1SwkN2CLCFuRXS1A=
In-Reply-To: <20160721143330.GA5751-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <cbrauner-l3A5Bk7waGM@public.gmane.org>, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org

On Thu, 2016-07-21 at 09:33 -0500, Serge E. Hallyn wrote:
> Quoting Aleksa Sarai (asarai-l3A5Bk7waGM@public.gmane.org):

> > > > The reason I'm doing this is so that we might be able to
> > > > _practically_ use cgroups as an unprivileged user (something
> > > > that will almost certainly be useful to not just the container
> > > > crowd, but people also planning on using cgroups as advanced
> > > > forms of rlimits).
> > >=20
> > > I don't get why we need this fragile dance with permissions at=20
> > > all when the same functionality can be achieved by delegating
> > > explicitly.
> >=20
> > The key words being "unprivileged user". Currently, if I am a
> > regular user on a system and I want to use the freezer cgroup to
> > pause a process I am running, I have to *go to the administrator=20
> > and ask them to give me permission to do that*. Why is that
> > necessary?
>=20
> Ths is of course solvable using something like libpam-cgfs or
> libpam-cgm (and others).  Since this sounds like a question of
> policy, not mechanism, userspace seems like the right place.  Is
> there a downside to that (or, as Tejun put it, "delegating=20
> explicitly")?

Unprivileged containers should "just work" by default as much as
possible.  There are cases where they can't and policy input is
required, like the userns mapping to additional ids beyond the current
one, we can still set up the default case without intervention (a
single mapping root to current id).

What I haven't really heard yet in the debate is the policy reason why
an unprivileged user shouldn't set up their own cgroups as children of
the current ones (inheriting the constraints).

I have heard

 * it would give power to move other tasks to more rigid constraints.=20
   =C2=A0To which the answer is only to allow movememnt of tasks in the
   current cgroupns
 * It violates the permissions delegation model. =C2=A0This one doesn't
   really make too much sense to me: in the same way the userns is root
   in its own domain, cgroups ns is effective root for the restricted
   cgroups (and only for processes within its ns).

Perhaps the question should be asked the other way around:  if we were
explicitly delegating permission to every user in the system to set up
their own sub cgroups, how would you advise it be done?

James
