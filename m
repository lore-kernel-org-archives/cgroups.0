From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC] memcg: close the race window between OOM detection
 and killing
Date: Fri, 5 Jun 2015 04:29:36 +0900
Message-ID: <20150604192936.GR20091@mtj.duckdns.org>
References: <20150603031544.GC7579@mtj.duckdns.org>
 <20150603144414.GG16201@dhcp22.suse.cz>
 <20150603193639.GH20091@mtj.duckdns.org>
 <20150604093031.GB4806@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=fqZU7kcmDCreJ+XtvYAWsjSQxEbetl5zWWQ/AlX+4pA=;
        b=cXAAPcSu6+a82+CK6edFG9dFAfWm0G2b0lHxewO5PaqiHjz4loIOUx0F7wLfehxaUk
         7/fKD5cUAhkteglGYA+5tqu9kIePfSPDcSjrail/2GP39k2AfLUY5H4eio5Kdrplk1Nu
         WYxQMvdP08x3ymq8PduCzLaWhxRV8Xvc9eo/YsLkoIII+PlUJH4fctVjCt8G88TGRZB6
         y4M7ypGkliu98F/fnZz9ccnNFRWeYCHDoSXbNu0Kl+vxCAE4OjJg/+f8FCMqi1F+OaCM
         Lno+vDMttCftHFAGQKi7mAb/ut+1kLsdtVDBiCdskE2w1DZztEZVUhedIyBHjV7DYZ6b
         n0Mw==
Content-Disposition: inline
In-Reply-To: <20150604093031.GB4806-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hello, Michal.

On Thu, Jun 04, 2015 at 11:30:31AM +0200, Michal Hocko wrote:
> > Hmmm?  In -mm, if __alloc_page_may_oom() fails trylock, it never calls
> > out_of_memory().
> 
> Sure but the oom_lock might be free already. out_of_memory doesn't wait
> for the victim to finish. It just does schedule_timeout_killable.

That doesn't matter because the detection and TIF_MEMDIE assertion are
atomic w.r.t. oom_lock and TIF_MEMDIE essentially extends the locking
by preventing further OOM kills.  Am I missing something?

> > The main difference here is that the alloc path does the whole thing
> > synchrnously and thus the OOM detection and killing can be put in the
> > same critical section which isn't the case for the memcg OOM handling.
> 
> This is true but there is still a time window between the last
> allocation attempt and out_of_memory when the OOM victim might have
> exited and another task would be selected.

Please see above.

> > > This is not the only reason. In-kernel memcg oom handling needs it
> > > as well. See 3812c8c8f395 ("mm: memcg: do not trap chargers with
> > > full callstack on OOM"). In fact it was the in-kernel case which has
> > > triggered this change. We simply cannot wait for oom with the stack and
> > > all the state the charge is called from.
> > 
> > Why should this be any different from OOM handling from page allocator
> > tho? 
> 
> Yes the global OOM is prone to deadlock. This has been discussed a lot
> and we still do not have a good answer for that. The primary problem
> is that small allocations do not fail and retry indefinitely so an OOM
> victim might be blocked on a lock held by a task which is the allocator.
> This is less likely and harder to trigger with standard loads than in
> memcg environment though.

Deadlocks from infallible allocations getting interlocked are
different.  OOM killer can't really get around that by itself but I'm
not talking about those deadlocks but at the same time they're a lot
less likely.  It's about OOM victim trapped in a deadlock failing to
release memory because someone else is waiting for that memory to be
released while blocking the victim.  Sure, the two issues are related
but once you solve things getting blocked on single OOM victim, it
becomes a lot less of an issue.

> There have been suggestions to add an OOM timeout and ignore the
> previous OOM victim after the timeout expires and select a new
> victim. This sounds attractive but this approach has its own problems
> (http://marc.info/?l=linux-mm&m=141686814824684&w=2).

Here are the the issues the message lists

 (1) you can needlessly panic the machine because no other processes
 are eligible for oom kill after declaring that the first oom kill
 victim cannot make progress,

This is extremely unlikely unless most processes in the system are
involved in the same deadlock.  All processes have SIGKILL pending but
nobody can exit?  In such cases, panic prolly isn't such a bad idea.
I mean, where would you go from there?

 (2) it can lead to unnecessary oom killing if the oom kill victim can
 exit but hasn't be scheduled or is in the process of exiting,

It's a matter of having a reasonable timeout.  OOM killing isn't an
exact operation to begin with and if an OOM victim fails to release
memory in, say 10s or whatever, finding another target is the right
thing to do.

 (3) you can easily turn the oom killer into a serial oom killer since
 there's no guarantee the next process that is chosen won't be
 affected by the same problem, and

And how is that worse than deadlocking?  OOM killer is a mechanism to
prevent the system from complete lockup at the cost of essentially
randomly butchering its workload.  The nasty userland memcg OOM hack
aside, by the time OOM killing has engaged, the system is already at
the end of the rope.

 (4) this doesn't fix the problem if an oom disabled process is wedged
 trying to allocate memory while holding a mutex that others are
 waiting

*All* others in the system are waiting on this particular OOM disabled
process and nobody can release any memory?  Yeah, panic then.

The arguments in that message aren't really against adding timeouts
but a lot more for wholesale removal of OOM killing.  That's an
awesome goal but is way far fetched at the moment.

> I am convinced that a more appropriate solution for this is to not
> pretend that small allocation never fail and start failing them after
> OOM killer is not able to make any progress (GFP_NOFS allocations would
> be the first candidate and the easiest one to trigger deadlocks via
> i_mutex). Johannes was also suggesting an OOM memory reserve which would
> be used for OOM contexts.

I don't follow why you reached such conclusion.  The arguments don't
really make sense to me.  Once you accept that OOM killer is a
sledgehammer rather than a surgical blade, the direction to take seems
pretty obvious to me and it *can't* be a precision mechanism - no
matter what, it's killing a random process with SIGKILL.

> Also OOM killer can be improved and shrink some of the victims memory
> before killing it (e.g. drop private clean pages and their page tables).

And why would we go to that level of sophiscation.  Just wait a while
and kill more until it gets unwedged.  That will achieve most effects
of being a lot more sophiscated with a lot less complexity and again
those minute differences don't matter here.

> > Gees... I dislike this approach even more.  Grabbng the oom lock and
> > doing everything synchronously with timeout will be far simpler and
> > easier to follow.
> 
> It might sound easier but it has its own problems...

I'm still failing to see what the problems are.

Thanks.

-- 
tejun
