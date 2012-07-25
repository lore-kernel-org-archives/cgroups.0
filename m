From: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: containers and cgroups mini-summit @ Linux Plumbers
Date: Wed, 25 Jul 2012 07:15:47 -0500
Message-ID: <20120725121547.GB7960@sergelap>
References: <4FFDF321.4030103@openvz.org>
 <500FD022.6000608@parallels.com>
 <20120725115148.GA6213@sergelap>
 <500FDE1B.4090907@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <500FDE1B.4090907-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Kir Kolyshkin <kir-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rohit Seth <rohitseth-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dhaval Giani <dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <ssouhlal-HZy0K5TPuP5AfugRpC6u6w@public.gmane.org>, Dave Kleikamp <dave.kleikamp-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Maxim Patlasov <MPatlasov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

Quoting Glauber Costa (glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org):
> On 07/25/2012 03:51 PM, Serge Hallyn wrote:
> > Quoting Glauber Costa (glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org):
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
> >> I just came up with the following preliminary list of sessions:
> >>
> >> http://wiki.linuxplumbersconf.org/2012:containers
> > 
> > Thanks.  We could also add devices namespace to the list.  I'm fine NOT
> > having it in the list, as I think we're agreed that it should come after
> > user namespaces are complete.
> > 
> How about a "future of namespaces" generic placeholder?

Sure.  And I suppose syslog and time ns could also fall under that.  Issues
to discuss include:

1. what other namespaces do people expect to need?
2. justifications for the proposed namespaces, and other potential ways
   to address each.  I.e., for devices ns, two justifications are (1)
   per-container loop devices (could be pre-allocated with containers
   aware of which /dev/loopN index they may use), and (2) filtering
   uevents only to appropriate containers to limit the uevent storm when
   containers do udevadm trigger --action=add (not sure, but we can
   brainstorm other solutions).
3. semantics for the namespace - I.e syslog namespace, how do we decide
   whether/when to unshare it, is it owned by a user namespace or a pid
   namespace, etc.
