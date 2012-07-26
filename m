From: Andrea Righi <andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>
Subject: Re: containers and cgroups mini-summit @ Linux Plumbers
Date: Thu, 26 Jul 2012 13:16:44 +0200
Message-ID: <20120726111644.GB2024@thinkpad>
References: <4FFDF321.4030103@openvz.org>
 <500FB473.3090606@parallels.com>
 <871uk0b1p4.fsf@xmission.com>
 <500FC3C9.4010005@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=betterlinux.com;
	s=default; t=1343301412;
	bh=kS6QZSkChvZMCAOo7J8XUcFPZgorTXbwhEdK8+EnalU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:In-Reply-To;
	b=BTNRKdwbkP2gMEKsoJQoDA94k/Bx9UTsZBIlhZUQTrFzPZp3Ab4edzb5qWaNJynvA
	 SrEOh2jbIaiCILTnUejf4UwQqrTko3fjjOpxxFOoI4iVmnaeQ0KekftUetY3gfClF7
	 BYSwcZpKTeaZx7UG/TR0UxJ9wCKg0Qe38ygW1nrU=
Content-Disposition: inline
In-Reply-To: <500FC3C9.4010005-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Kir Kolyshkin <kir-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rohit Seth <rohitseth-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dhaval Giani <dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <ssouhlal-HZy0K5TPuP5AfugRpC6u6w@public.gmane.org>, Dave Kleikamp <dave.kleikamp-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Maxim Patlasov <MPatlasov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

On Wed, Jul 25, 2012 at 02:00:41PM +0400, Glauber Costa wrote:
> On 07/25/2012 02:00 PM, Eric W. Biederman wrote:
> > Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> writes:
> > 
> >> On 07/12/2012 01:41 AM, Kir Kolyshkin wrote:
> >>> Gentlemen,
> >>>
> >>> We are organizing containers mini-summit during next Linux Plumbers (San
> >>> Diego, August 29-31).
> >>> The idea is to gather and discuss everything relevant to namespaces,
> >>> cgroups, resource management,
> >>> checkpoint-restore and so on.
> >>>
> >>> We are trying to come up with a list of topics to discuss, so please
> >>> reply with topic suggestions, and
> >>> let me know if you are going to come.
> >>>
> >>> I probably forgot a few more people (such as, I am not sure who else
> >>> from Google is working
> >>> on cgroups stuff), so fill free to forward this to anyone you believe
> >>> should go,
> >>> or just let me know whom I missed.
> >>>
> >>> Regards,
> >>>   Kir.
> >>
> >> BTW, sorry for not replying before (vacations + post-vacations laziness)
> >>
> >> I would be interested in adding /proc virtualization to the discussion.
> >> By now it seems userspace would be the best place for that to happen, in
> >> a fuse overlay. I know Daniel has an initial implementation of that, and
> >> it would be good to have it as library that both OpenVZ and LXC (and
> >> whoever else wants) can use.
> >>
> >> Shouldn't take much time...
> > 
> > What would you need proc virtualization for?
> > 
> 
> proc provides a lot of information that userspace tools rely upon.
> For instance, when running top, you can draw per-process figures from
> what we have now, but you can't make sense of percentages without
> aggregating container-wide information.
> 
> When you read /proc/cpuinfo, as well, you would expect to see something
> that matches your container configuration.
> 
> "free" is another example. The list go on.

Another interesting feature IMHO would be the per-cgroup loadavg. A
typical use case could be a monitoring system that wants to know which
containers are more overloaded than others, instead of using a single
system-wide measure in /proc/loadavg.

-Andrea
