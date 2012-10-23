From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/7] cgroup_freezer: don't stall transition to FROZEN
	for PF_NOFREEZE or PF_FREEZER_SKIP tasks
Date: Tue, 23 Oct 2012 17:55:33 +0200
Message-ID: <20121023155533.GC16201@redhat.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org> <1350426526-14254-5-git-send-email-tj@kernel.org> <20121022183453.GA24687@redhat.com> <20121022211822.GF5951@atj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121022211822.GF5951-OlzNCW9NnSVy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: rjw-KKrjLPT3xs0@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 10/22, Tejun Heo wrote:
>
> On Mon, Oct 22, 2012 at 08:34:53PM +0200, Oleg Nesterov wrote:
> >
> > Hmm. We seem to "leak" PF_NOFREEZE if a kernel thread execs?
> > Perhaps do_execve_common() should do set_freezable() before return.
> >
> > Or, at least, simply clear this flag along with PF_KTHREAD in
> > flush_old_exec().
>
> Ooh, ouch, definitely.  We should clear that.  Can you please make a
> patch?

Sure... but what do you think is better?

I'd prefer to simply clear PF_NOFREEZE (without set_freezable), but
obviously this doesn't look exactly right from cgroup_freezer pov.

Oleg.
