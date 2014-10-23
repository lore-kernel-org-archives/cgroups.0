From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] memcg: Fix NULL pointer deref in task_in_mem_cgroup()
Date: Thu, 23 Oct 2014 20:34:35 +0200
Message-ID: <20141023183435.GD21034@quack.suse.cz>
References: <1414082865-4091-1-git-send-email-jack@suse.cz>
 <20141023181929.GB15937@phnom.home.cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20141023181929.GB15937@phnom.home.cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org, linux-mm@kvack.org

On Thu 23-10-14 14:19:29, Johannes Weiner wrote:
> On Thu, Oct 23, 2014 at 06:47:45PM +0200, Jan Kara wrote:
> > 'curr' pointer in task_in_mem_cgroup() can be NULL when we race with
> > somebody clearing task->mm. Check for it before dereferencing the
> > pointer.
> 
> If task->mm is already NULL, we fall back to mem_cgroup_from_task(),
> which definitely returns a memcg unless you pass NULL in there.  So I
> don't see how that could happen, and the NULL checks in the fallback
> branch as well as in __mem_cgroup_same_or_subtree seem bogus to me.
  OK, I admittedly don't understand that code much. I was just wondering
that we check 'curr' for being NULL in all the places except for that one
which looked suspicious... If curr cannot be NULL, then we should just
remove those checks I assume.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
