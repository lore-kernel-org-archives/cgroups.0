From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch] mm, memcg: add memory.oom_control notification for
 system oom
Date: Mon, 18 Nov 2013 10:54:50 -0500
Message-ID: <20131118155450.GB3556@cmpxchg.org>
References: <alpine.DEB.2.02.1310301838300.13556@chino.kir.corp.google.com>
 <20131031054942.GA26301@cmpxchg.org>
 <alpine.DEB.2.02.1311131416460.23211@chino.kir.corp.google.com>
 <20131113233419.GJ707@cmpxchg.org>
 <alpine.DEB.2.02.1311131649110.6735@chino.kir.corp.google.com>
 <20131114032508.GL707@cmpxchg.org>
 <alpine.DEB.2.02.1311141447160.21413@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=vqmV43VkeVrme9JRx3wBMGMEVfgyUlzynm2tVFrg1PQ=;
	b=f7owF7rMvf2JvWTGjGpK/FsEPC9DzjTyBqx87sr+aYvpfkqPxAtMTc95KFrgxmga741VwEjZ4fzuUQU+Vw+eEDVdaRHsTqIlK+ZMfGmutdbFTx7bRdowVChPJleCGa+IAYDn9g7aQ87rkwTrHHRsNaNrwSO7kiMcRkvjOJVvL20=;
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311141447160.21413-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Nov 14, 2013 at 02:57:51PM -0800, David Rientjes wrote:
> On Wed, 13 Nov 2013, Johannes Weiner wrote:
> 
> > > > Somebody called out_of_memory() after they
> > > > failed reclaim, the machine is OOM.
> > > 
> > > While momentarily oom, the oom notifiers in powerpc and s390 have the 
> > > ability to free memory without requiring a kill.
> > 
> > So either
> > 
> > 1) they should be part of the regular reclaim process, or
> > 
> > 2) their invocation is severe enough to not be part of reclaim, at
> >    which point we should probably tell userspace about the OOM
> > 
> 
> (1) is already true, we can avoid oom by freeing memory for subsystems 
> using register_oom_notifier(), so we're not actually oom.  It's a late 
> callback into the kernel to free memory in a sense of reclaim.  It was 
> added directly into out_of_memory() purely for simplicity; it could be 
> moved to the page allocator if we move all of the oom_notify_list helpers 
> there as well.

If they can easily free it without any repercussions, they should
really be part of regular reclaim.  Maybe convert them to shrinkers.

And then you can use OOM notifiers to be notified about OOM.

> The same is true of silently setting TIF_MEMDIE for current so that it has 
> access to memory reserves and may exit when it has a pending SIGKILL or is 
> already exiting.
> 
> In both cases, we're not actually oom because either (a) the kernel can 
> still free memory and avoid actually killing a process, or (b) current 
> simply needs access to memory reserves so it may die.
> 
> We don't want to invoke the userspace oom handler when we first enter 
> direct reclaim, for example, for the same reason.

Reclaim is an option the kernel always has, the current task exiting
is a coincidence.

And accessing the emergency reserves means we are definitely no longer
A-OK, this is not comparable to the first direct reclaim invocation.

We exhausted our options and we got really lucky.  It should not be
considered the baseline and a user listening for "OOM conditions"
should be informed about this.
