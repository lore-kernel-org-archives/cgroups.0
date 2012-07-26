From: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [Devel] Re: containers and cgroups mini-summit @ Linux Plumbers
Date: Thu, 26 Jul 2012 13:16:29 -0500
Message-ID: <20120726181629.GB17824@serge-laptop>
References: <4FFDF321.4030103@openvz.org>
 <500FD022.6000608@parallels.com>
 <877gtr6uo5.fsf@xmission.com>
 <50110AE6.2080701@parallels.com>
 <50110D53.2090407@parallels.com>
 <874nou6bx1.fsf@xmission.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <874nou6bx1.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Suleiman-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Souhlal <ssouhlal-HZy0K5TPuP5AfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Kleikamp <dave.kleikamp-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Dhaval Giani <dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Maxim-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Rohit Seth <rohitseth-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Patlasov <MPatlasov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

Quoting Eric W. Biederman (ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org):
> Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> writes:
> 
> >>>
> >>> Another old issue is that unless I have missed something control groups
> >>> are still broken for generic use in containers.  Does anyone care?
> >>> Are there any plans on fixing this issue?
> >>>
> >
> > What is "generic use in containers" ? I am using them alright, but not
> > sure if this counts as generic or specific =)
> 
> The general container use case would be.
> 
> - Create a new mount namespace.
> - Create fresh mounts of all of the control groups like I would do at
>   boot, with no consideration to any other control group state.
> - Start forking processes.
> 
> The expected semantics would be something like chroot for control
> groups, where all of the control groups that are created by fresh mounts
> are relative to whatever state the process of being in a control group
> that the process that mounted them was in.
> 
> Last I looked the closest you could come to that was bind mounts, and
> even with bind mounts you get into weird things where control groups are
> bound into hierarchies and you may be running a distribution that wants
> it's control groups bound into different hierarchies.
> 
> Last I looked this was just about a total disaster, and the only thing
> that allowed systemd to run in containers was the fact that systemd did
> not user controllers.
> 
> Eric

(Sorry, please disregard my last email :)

Yes, what we do now in ubuntu quantal is the bind mounts you mention,
and only optionally (using a startup hook).
Each container is brought up in say
/sys/fs/cgroup/devices/lxc/container1/container1.real, and that dir is
bind-mounted under /sys/fs/cgroup/devices in the guest.  The guest
is not allowed to mount cgroup fs himself.

It's certainly not ideal (and in cases where cgroup allows you to
raise your own limits, worthless).  The 'fake cgroup root' has been
mentioned before to address this.  Definately worth discussing.

thanks,
-serge
