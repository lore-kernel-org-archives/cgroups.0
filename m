From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC][PATCH] cgroup: fix race between fork and cgroup freezing
Date: Mon, 12 Mar 2012 09:10:40 -0700
Message-ID: <20120312161040.GA23255@google.com>
References: <4F587199.6050404@cn.fujitsu.com>
 <20120308182622.GC25508@google.com>
 <4F59A27D.9080705@cn.fujitsu.com>
 <20120309165313.GA24890@google.com>
 <4F5DBB8C.6090904@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=CEyDxkkX5s9kS4o0TJfu+uzJu3SoXV2HoRHEoBuZ940=;
        b=sgHyGjiyeIGnGN0NS1iQm3LBA9rqv2cr+5tGcyLDih8SrCcxkEm5YPJvICrABrWhMu
         COWiimVG6W4IEdZO71qsXbE/2ngiLaF8mSpkczsYk2s+zRfwoVf2wYLabb2SlS2RZZA0
         L252mJPH4An1C3cjP8lbnsXTzVajbmzAyP6pT0+qNWxpLhtXiFMcXDwxb5x0llzeoPYY
         VziRsdq2I06Dmf17ltttADQr/H00cfTDvAKseFglgM0E1hipaCFMsw6ATTCJ+b1KlSSe
         U6gUha9kssRbgJQ1f7BHBp+D12gu79fRutxYA8M968Y+Ff9FHIWFqgR8eyUOT100CsxR
         HEIQ==
Content-Disposition: inline
In-Reply-To: <4F5DBB8C.6090904-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?utf-8?B?57yqIOWLsA==?= <miaox-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello,

On Mon, Mar 12, 2012 at 05:02:04PM +0800, Li Zefan wrote:
> - We still need some kind of locking to syncronize fork and the traverser.
> fork side is protected by tasklist_lock, while the traverser takes
> css_set_lock.

Can't we do both after tasklist_lock is released under css_set_lock?

> - After linking the new task to css set list, the task is visible and thus
> can be moved to another cgroup, which makes things more complicated and
> the subsystem callbacks may have to acquire cgroup_mutex.

Hmmm... freezer currently doesn't allow migrating in and out of frozen
cgroup and even when it does callbacks in the migration path should
synchronize against freezer->lock.  I *think* that should be enough
and can't see why this will be simpler or more complex depending on
when fork callback is called.

> - The task_counter subsystem wants to get notified before the new task
> is linked, so it's able to abort the fork.

This one maybe but for this cgroup_fork_callbacks() is already too
late, isn't it?  We better have pre-fork callbacks instead, no?

Thanks.

-- 
tejun
