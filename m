From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: asynchronous reclaim for memory.high
Date: Wed, 19 Feb 2020 17:08:59 -0500
Message-ID: <20200219220859.GF54486@cmpxchg.org>
References: <20200219181219.54356-1-hannes@cmpxchg.org>
 <20200219183731.GC11847@dhcp22.suse.cz>
 <20200219191618.GB54486@cmpxchg.org>
 <20200219195332.GE11847@dhcp22.suse.cz>
 <20200219214112.4kt573kyzbvmbvn3@ca-dmjordan1.us.oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VnF5DCQHVLUnfSmn+1ERWkaSX6Vm56uQOFXrLzOaRr8=;
        b=KNCHQ7ChkERIcb/bdTd8hqb6netRcNVRd1DLmtBvs7LPPDhPPJ6M3is5PKZe9vNoT6
         Frcn3LOhDntoI0kybkgkdCbpb+X0b87pjt/TZLvRr0ypZe7gyIVM3Nn5bMohRaUGp922
         Rn/LmqIJFt2RPPl2OaTV1Sc4h1mRx/vJRLZP2Nfz49ehWSQl2TqXGnC4jfnTbte5Tvso
         w9kI50aIGRQgal37qMd3VBetpnqu0/191gyevyDlrqlsbUp96TWb3DO5FlvqatPEhKxJ
         n4NmHFp38ROakzQcUqixDZtBPRs4VY+EiWATwuQ8CsLRUf4hTThSgu1Tcy8jOB1dHmpG
         0QYg==
Content-Disposition: inline
In-Reply-To: <20200219214112.4kt573kyzbvmbvn3-S51bK0XF4qpuJJETbFA3a0B3C2bhBk7L0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, Feb 19, 2020 at 04:41:12PM -0500, Daniel Jordan wrote:
> On Wed, Feb 19, 2020 at 08:53:32PM +0100, Michal Hocko wrote:
> > On Wed 19-02-20 14:16:18, Johannes Weiner wrote:
> > > On Wed, Feb 19, 2020 at 07:37:31PM +0100, Michal Hocko wrote:
> > > > On Wed 19-02-20 13:12:19, Johannes Weiner wrote:
> > > > > This patch adds asynchronous reclaim to the memory.high cgroup limit
> > > > > while keeping direct reclaim as a fallback. In our testing, this
> > > > > eliminated all direct reclaim from the affected workload.
> > > > 
> > > > Who is accounted for all the work? Unless I am missing something this
> > > > just gets hidden in the system activity and that might hurt the
> > > > isolation. I do see how moving the work to a different context is
> > > > desirable but this work has to be accounted properly when it is going to
> > > > become a normal mode of operation (rather than a rare exception like the
> > > > existing irq context handling).
> > > 
> > > Yes, the plan is to account it to the cgroup on whose behalf we're
> > > doing the work.
> 
> How are you planning to do that?
> 
> I've been thinking about how to account a kernel thread's CPU usage to a cgroup
> on and off while working on the parallelizing Michal mentions below.  A few
> approaches are described here:
> 
> https://lore.kernel.org/linux-mm/20200212224731.kmss6o6agekkg3mw-S51bK0XF4qpuJJETbFA3a0B3C2bhBk7L0E9HWUfgJXw@public.gmane.org/

What we do for the IO controller is execute the work unthrottled but
charge the cgroup on whose behalf we are executing with whatever cost
or time or bandwith that was incurred. The cgroup will pay off this
debt when it requests more of that resource.

This is from blk-iocost.c:

	/*
	 * We're over budget.  If @bio has to be issued regardless,
	 * remember the abs_cost instead of advancing vtime.
	 * iocg_kick_waitq() will pay off the debt before waking more IOs.
	 * This way, the debt is continuously paid off each period with the
	 * actual budget available to the cgroup.  If we just wound vtime,
	 * we would incorrectly use the current hw_inuse for the entire
	 * amount which, for example, can lead to the cgroup staying
	 * blocked for a long time even with substantially raised hw_inuse.
	 */
	if (bio_issue_as_root_blkg(bio) || fatal_signal_pending(current)) {
		atomic64_add(abs_cost, &iocg->abs_vdebt);
		iocg_kick_delay(iocg, &now, cost);
		return;
	}

blk-iolatency.c has similar provisions. bio_issue_as_root_blkg() says this:

/**
 * bio_issue_as_root_blkg - see if this bio needs to be issued as root blkg
 * @return: true if this bio needs to be submitted with the root blkg context.
 *
 * In order to avoid priority inversions we sometimes need to issue a bio as if
 * it were attached to the root blkg, and then backcharge to the actual owning
 * blkg.  The idea is we do bio_blkcg() to look up the actual context for the
 * bio and attach the appropriate blkg to the bio.  Then we call this helper and
 * if it is true run with the root blkg for that queue and then do any
 * backcharging to the originating cgroup once the io is complete.
 */
static inline bool bio_issue_as_root_blkg(struct bio *bio)
{
        return (bio->bi_opf & (REQ_META | REQ_SWAP)) != 0;
}

The plan for the CPU controller is similar. When a remote execution
begins, flush the current runtime accumulated (update_curr) and
associate the current thread with another cgroup (similar to
current->active_memcg); when remote execution is done, flush the
runtime delta to that cgroup and unset the remote context.

For async reclaim, whether that's kswapd or the work item that I'm
adding here, we'd want the cycles to go to the cgroup whose memory is
being reclaimed.

> > > The problem is that we have a general lack of usable CPU control right
> > > now - see Rik's work on this: https://lkml.org/lkml/2019/8/21/1208.
> > > For workloads that are contended on CPU, we cannot enable the CPU
> > > controller because the scheduling latencies are too high. And for
> > > workloads that aren't CPU contended, well, it doesn't really matter
> > > where the reclaim cycles are accounted to.
> > > 
> > > Once we have the CPU controller up to speed, we can add annotations
> > > like these to account stretches of execution to specific
> > > cgroups. There just isn't much point to do it before we can actually
> > > enable CPU control on the real workloads where it would matter.
> 
> Which annotations do you mean?  I didn't see them when skimming through Rik's
> work or in this patch.

Sorry, they're not in Rik's patch. My point was that we haven't gotten
to making such fine-grained annotations because the CPU isolation as a
whole isn't something we have working in practice right now. It's not
relevant who is spending the cycles if we cannot enable CPU control.
