From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [Devel] Re: containers and cgroups mini-summit @ Linux Plumbers
Date: Thu, 26 Jul 2012 12:38:16 -0700
Message-ID: <87ipdauxcn.fsf@xmission.com>
References: <4FFDF321.4030103@openvz.org> <500FD022.6000608@parallels.com>
	<877gtr6uo5.fsf@xmission.com> <50110AE6.2080701@parallels.com>
	<50110D53.2090407@parallels.com> <874nou6bx1.fsf@xmission.com>
	<20120726181629.GB17824@serge-laptop>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120726181629.GB17824@serge-laptop> (Serge Hallyn's message of
	"Thu, 26 Jul 2012 13:16:29 -0500")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Suleiman-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Souhlal <ssouhlal-HZy0K5TPuP5AfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Kleikamp <dave.kleikamp-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Dhaval Giani <dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Maxim-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Rohit Seth <rohitseth-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Patlasov <MPatlasov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> writes:
> (Sorry, please disregard my last email :)
>
> Yes, what we do now in ubuntu quantal is the bind mounts you mention,
> and only optionally (using a startup hook).
> Each container is brought up in say
> /sys/fs/cgroup/devices/lxc/container1/container1.real, and that dir is
> bind-mounted under /sys/fs/cgroup/devices in the guest.  The guest
> is not allowed to mount cgroup fs himself.
>
> It's certainly not ideal (and in cases where cgroup allows you to
> raise your own limits, worthless).  The 'fake cgroup root' has been
> mentioned before to address this.  Definately worth discussing.

It is going to be interesting to see how all of the unprivileged
operations work when the user-namespaces start allowing unprivileged
users to do things (3.7 timeframe I hope).

I can see it making things both easier and harder.  I would hope not
actually being root will make it easier to keep from raising your own
limits.

Running some operations as non-root will catch other places off guard
where people were definitely expecting nothing of the kind.

There are a couple of networking memory limits exposed through sysctl
that I don't expect we want everyone changing, that I need to figure out
how to separate out from the rest.  A concept that hasn't existed
before.

Eric
