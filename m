From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] memcg: Fix NULL pointer deref in task_in_mem_cgroup()
Date: Fri, 24 Oct 2014 09:36:05 -0400
Message-ID: <20141024133605.GA17987@phnom.home.cmpxchg.org>
References: <1414082865-4091-1-git-send-email-jack@suse.cz>
 <20141023181929.GB15937@phnom.home.cmpxchg.org>
 <20141024085807.GA28644@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141024085807.GA28644-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri, Oct 24, 2014 at 10:58:07AM +0200, Michal Hocko wrote:
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
> 
> It came from 3a981f482cc2 (memcg: fix use_hierarchy css_is_ancestor oops
> regression). I do not see mem_cgroup_same_or_subtree called from
> page_referenced path so it is probably gone.

It's still there in invalid_page_referenced_vma().  And it can still
pass NULL.

> task_in_mem_cgroup is just confused because curr can never be NULL as
> the task is never NULL.

That's correct.

My patches to clean all this up have been stress-tested over night, I
will send them out in a jiffy.

Thanks
