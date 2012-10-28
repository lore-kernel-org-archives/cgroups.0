From: "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>
Subject: Re: [PATCH v2 1/1] freezer: change ptrace_stop/do_signal_stop to use freezable_schedule()
Date: Sun, 28 Oct 2012 02:16:15 +0200
Message-ID: <3398462.AB3BSRdprj@vostro.rjw.lan>
References: <20121023153919.GA16201@redhat.com> <2718983.vORnrfWdbE@vostro.rjw.lan> <20121026212909.GW11442@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7Bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121026212909.GW11442-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Friday, October 26, 2012 02:29:09 PM Tejun Heo wrote:
> Hello,
> 
> On Fri, Oct 26, 2012 at 11:29:56PM +0200, Rafael J. Wysocki wrote:
> > Actually, what tree is it supposed to apply to?
> > 
> > The change in kernel/cgroup_freezer.c doesn't look like anything in
> > the current Linus' tree to me.
> 
> Ooh, right.  This depends on the earlier cgroup_freezer changes.
> Sorry about the confusion.  I'll apply it to the following branch (the
> same one used for the previous cgroup_freezer updates).
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git cgroup-freezer

OK

I haven't merged it yet, so I'll get this fix along with the rest.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
