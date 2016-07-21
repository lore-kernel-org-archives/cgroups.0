From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 3/3] cgroup: relax common ancestor restriction for
 direct descendants
Date: Thu, 21 Jul 2016 09:33:30 -0500
Message-ID: <20160721143330.GA5751@mail.hallyn.com>
References: <20160718161816.13040-1-asarai@suse.de>
 <20160718161816.13040-4-asarai@suse.de>
 <20160720155147.GG4574@htj.duckdns.org>
 <6e975d80-4077-fb8b-ec84-708e37c8e149@suse.de>
 <20160720230228.GA19588@mtj.duckdns.org>
 <982fcf3a-3685-9bd7-dd95-7bff255c9421@suse.de>
 <20160720231949.GB19588@mtj.duckdns.org>
 <379e5b13-29d4-ca75-1935-0a64f3db8d27@suse.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <379e5b13-29d4-ca75-1935-0a64f3db8d27-l3A5Bk7waGM@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <cbrauner-l3A5Bk7waGM@public.gmane.org>, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>

Quoting Aleksa Sarai (asarai-l3A5Bk7waGM@public.gmane.org):
> >>I feel like the permission model makes sense in certain cases (the common
> >>ancestor restriction, as well as the ability for a parent to apply limits to
> >>children by setting its own limits). Neither of those are violated (if you
> >>read the commit that introduced the common ancestor restriction).
> >>
> >>Maybe if you give me a usecase of when it might be important that a process
> >>must not be able to move to a sub-cgroup of its current one, I might be able
> >>to understand your concerns? From my perspective, I think that's actually
> >>quite useful.
> >
> >cgroup is used to keep track of which processes belong where and
> >allowing processes to be moved out of its cgroup like this would be
> >surprising to say the least.
> 
> Would you find it acceptable if we added a bit that would make this
> not happen (you could specify that a cgroup should not allow a
> process to move itself to a sub-cgroup)? Or an aggregate
> cgroup.procs that gives you all of the processes in the entire
> branch of the tree? Surely this is something that can be fixed
> without unnecessarily restricting users from doing useful things.
> 
> >>The reason I'm doing this is so that we might be able to _practically_ use
> >>cgroups as an unprivileged user (something that will almost certainly be
> >>useful to not just the container crowd, but people also planning on using
> >>cgroups as advanced forms of rlimits).
> >
> >I don't get why we need this fragile dance with permissions at all
> >when the same functionality can be achieved by delegating explicitly.
> 
> The key words being "unprivileged user". Currently, if I am a
> regular user on a system and I want to use the freezer cgroup to
> pause a process I am running, I have to *go to the administrator and
> ask them to give me permission to do that*. Why is that necessary? I

Ths is of course solvable using something like libpam-cgfs or
libpam-cgm (and others).  Since this sounds like a question of
policy, not mechanism, userspace seems like the right place.  Is
there a downside to that (or, as Tejun put it, "delegating explicitly")?
