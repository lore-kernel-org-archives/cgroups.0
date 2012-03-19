From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC][PATCH] cgroup: fix race between fork and cgroup freezing
Date: Mon, 19 Mar 2012 14:44:16 +0100
Message-ID: <20120319134413.GC2660@somewhere>
References: <4F587199.6050404@cn.fujitsu.com>
 <20120308182622.GC25508@google.com>
 <4F59A27D.9080705@cn.fujitsu.com>
 <20120309165313.GA24890@google.com>
 <4F5DBB8C.6090904@cn.fujitsu.com>
 <20120312161040.GA23255@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=PtfgFPg3QZFx580shjPh0jcK3kpl7Rd212xWuNlyNww=;
        b=AXnUnGY9hpxMB+HjOrSzxRqUs0bl6Q0soBf9nr1Hg6z2Y7QuUCIRB/5QnMyxC4tIKv
         fOtTt2iFVbXBoiTmMHxuVpUXPWqLd78V47WlYB+bkjpEc3AaX6XlgzsHC+IQt4Eup2sm
         ZuBn7D0y2Lvykniwpn+vrH+nNLzY1wWA1ZPUuE7GvWa99KACTgN97HhRo7p8cEcP1JSh
         I5S9MkmSNkwxyIOEc4jFb8Xk8mYNkqBotownX4qARV5beri/NBwvRq3XCpvUsBjFM/K4
         VvwC6/WmtIDu52carkHkjXTT1M1HH96IugHIJXuTXONjF0Tq1GSaH3r4M8cbe1dShbGn
         MJKg==
Content-Disposition: inline
In-Reply-To: <20120312161040.GA23255-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?utf-8?B?57yqIOWLsA==?= <miaox-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Mon, Mar 12, 2012 at 09:10:40AM -0700, Tejun Heo wrote:
> Hello,
> 
> On Mon, Mar 12, 2012 at 05:02:04PM +0800, Li Zefan wrote:
> > - We still need some kind of locking to syncronize fork and the traverser.
> > fork side is protected by tasklist_lock, while the traverser takes
> > css_set_lock.
> 
> Can't we do both after tasklist_lock is released under css_set_lock?
> 
> > - After linking the new task to css set list, the task is visible and thus
> > can be moved to another cgroup, which makes things more complicated and
> > the subsystem callbacks may have to acquire cgroup_mutex.
> 
> Hmmm... freezer currently doesn't allow migrating in and out of frozen
> cgroup and even when it does callbacks in the migration path should
> synchronize against freezer->lock.  I *think* that should be enough
> and can't see why this will be simpler or more complex depending on
> when fork callback is called.
> 
> > - The task_counter subsystem wants to get notified before the new task
> > is linked, so it's able to abort the fork.
> 
> This one maybe but for this cgroup_fork_callbacks() is already too
> late, isn't it?  We better have pre-fork callbacks instead, no?

Nope, cgroup_fork_callbacks() is called soon enough to be able
to cancel a fork. The task counter subsystem cancels from that point.
