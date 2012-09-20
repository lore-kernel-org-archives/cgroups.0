From: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [Announce] Checkpoint-restore tool v0.2
Date: Thu, 20 Sep 2012 08:05:51 -0500
Message-ID: <20120920130551.GB4605@sergelap>
References: <500D09C9.7060903@parallels.com>
 <505AECF0.6070607@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <505AECF0.6070607-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lwn-T1hC0tSOHrs@public.gmane.org, "criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org" <criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, users-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Congratulations, Pavel and criu team, that's awesome!

Quoting Pavel Emelyanov (xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org):
> Hi!
> 
> I'm happy to announce that the next big step is done by the CRIU project.
> 
> The major achievement so far -- the tool can now dump and restore a simple LXC
> container. Another notable feature is the initial support for PTYs which is enough
> to play with c/r of a container with active ssh sessions from outside, or with
> a screen app with some simple stuff running inside.
> 
> A HOWTO describing an LXC container dump and restore is at http://criu.org/LXC
> 
> 
> The v0.2 can be downloaded from
> 
> 	http://download.openvz.org/criu/crtools-0.2.tar.bz2
> 
> 
> Other project resources are
> 
>   documentation and news:             http://criu.org
>   mainling list:                      https://openvz.org/mailman/listinfo/criu
>   git repo:                           http://git.criu.org/?p=crtools.git
>   kernel with not-yet-merged patches: https://github.com/cyrillos/linux-2.6.git
> 
> Thanks,
> Pavel
> _______________________________________________
> Containers mailing list
> Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
