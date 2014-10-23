From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] memcg: Fix NULL pointer deref in task_in_mem_cgroup()
Date: Thu, 23 Oct 2014 15:38:30 -0400
Message-ID: <20141023193830.GB558@phnom.home.cmpxchg.org>
References: <1414082865-4091-1-git-send-email-jack@suse.cz>
 <20141023181929.GB15937@phnom.home.cmpxchg.org>
 <20141023183435.GD21034@quack.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141023183435.GD21034-+0h/O2h83AeN3ZZ/Hiejyg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, Oct 23, 2014 at 08:34:35PM +0200, Jan Kara wrote:
> On Thu 23-10-14 14:19:29, Johannes Weiner wrote:
> > On Thu, Oct 23, 2014 at 06:47:45PM +0200, Jan Kara wrote:
> > > 'curr' pointer in task_in_mem_cgroup() can be NULL when we race with
> > > somebody clearing task->mm. Check for it before dereferencing the
> > > pointer.
> > 
> > If task->mm is already NULL, we fall back to mem_cgroup_from_task(),
> > which definitely returns a memcg unless you pass NULL in there.  So I
> > don't see how that could happen, and the NULL checks in the fallback
> > branch as well as in __mem_cgroup_same_or_subtree seem bogus to me.
>   OK, I admittedly don't understand that code much. I was just wondering
> that we check 'curr' for being NULL in all the places except for that one
> which looked suspicious... If curr cannot be NULL, then we should just
> remove those checks I assume.

Agreed.  They make the code quite hard to understand and change
because all callchains need to be verified up the stack.

Thanks for the nudge, I'm going to remove the bogus ones.
