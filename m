From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [v4 2/4] mm, oom: cgroup-aware OOM killer
Date: Thu, 3 Aug 2017 15:01:11 +0200
Message-ID: <20170803130110.GU12521@dhcp22.suse.cz>
References: <20170726132718.14806-1-guro@fb.com>
 <20170726132718.14806-3-guro@fb.com>
 <20170801145435.GN15774@dhcp22.suse.cz>
 <20170801152548.GA29502@castle.dhcp.TheFacebook.com>
 <20170801170302.GB15518@dhcp22.suse.cz>
 <20170801181352.GA26074@castle.DHCP.thefacebook.com>
 <20170802072900.GA2524@dhcp22.suse.cz>
 <20170803124751.GA24563@castle.dhcp.TheFacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170803124751.GA24563-2xczL/1GIl5a1dPMsufgnw2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 03-08-17 13:47:51, Roman Gushchin wrote:
> On Wed, Aug 02, 2017 at 09:29:01AM +0200, Michal Hocko wrote:
> > On Tue 01-08-17 19:13:52, Roman Gushchin wrote:
> > > On Tue, Aug 01, 2017 at 07:03:03PM +0200, Michal Hocko wrote:
> > > > On Tue 01-08-17 16:25:48, Roman Gushchin wrote:
> > > > > On Tue, Aug 01, 2017 at 04:54:35PM +0200, Michal Hocko wrote:
> > > > [...]
> > > > > > I would reap out the oom_kill_process into a separate patch.
> > > > > 
> > > > > It was a separate patch, I've merged it based on Vladimir's feedback.
> > > > > No problems, I can divide it back.
> > > > 
> > > > It would make the review slightly more easier
> > > > > 
> > > > > > > -static void oom_kill_process(struct oom_control *oc, const char *message)
> > > > > > > +static void __oom_kill_process(struct task_struct *victim)
> > > > > > 
> > > > > > To the rest of the patch. I have to say I do not quite like how it is
> > > > > > implemented. I was hoping for something much simpler which would hook
> > > > > > into oom_evaluate_task. If a task belongs to a memcg with kill-all flag
> > > > > > then we would update the cumulative memcg badness (more specifically the
> > > > > > badness of the topmost parent with kill-all flag). Memcg will then
> > > > > > compete with existing self contained tasks (oom_badness will have to
> > > > > > tell whether points belong to a task or a memcg to allow the caller to
> > > > > > deal with it). But it shouldn't be much more complex than that.
> > > > > 
> > > > > I'm not sure, it will be any simpler. Basically I'm doing the same:
> > > > > the difference is that you want to iterate over tasks and for each
> > > > > task traverse the memcg tree, update per-cgroup oom score and find
> > > > > the corresponding memcg(s) with the kill-all flag. I'm doing the opposite:
> > > > > traverse the cgroup tree, and for each leaf cgroup iterate over processes.
> > > > 
> > > > Yeah but this doesn't fit very well to the existing scheme so we would
> > > > need two different schemes which is not ideal from maint. point of view.
> > > > We also do not have to duplicate all the tricky checks we already do in
> > > > oom_evaluate_task. So I would prefer if we could try to hook there and
> > > > do the special handling there.
> > > 
> > > I hope, that iterating over all tasks just to check if there are
> > > in-flight OOM victims might be optimized at some point.
> > > That means, we would be able to choose a victim much cheaper.
> > > It's not easy, but it feels as a right direction to go.
> > 
> > You would have to count per each oom domain and that sounds quite
> > unfeasible to me.
> 
> It's hard, but traversing the whole cgroup tree from bottom to top
> for each task is just not scalable.

We are talking about the oom path which is a slow path. Besides that
memcg hierarchies will not be very deep usually (we are not talking
about hundreds). 

> This is exactly why I've choosen a compromise right now: let's
> iterate over all tasks, but do it by iterating over the cgroup tree.
> 
> >  
> > > Also, adding new tricks to the oom_evaluate_task() will make the code
> > > even more hairy. Some of the existing tricks are useless for memcg selection.
> > 
> > Not sure what you mean but oom_evaluate_task has been usable for both
> > global and memcg oom paths so far. I do not see any reason why this
> > shouldn't hold for a different oom killing strategy.
> 
> Yes, but in both cases we've evaluated tasks, not cgroups.
> 
> > 
> > > > > Also, please note, that even without the kill-all flag the decision is made
> > > > > on per-cgroup level (except tasks in the root cgroup).
> > > > 
> > > > Yeah and I am not sure this is a reasonable behavior. Why should we
> > > > consider memcgs which are not kill-all as a single entity?
> > > 
> > > I think, it's reasonable to choose a cgroup/container to blow off based on
> > > the cgroup oom_priority/size (including hierarchical settings), and then
> > > kill one biggest or all tasks depending on cgroup settings.
> > 
> > But that doesn't mean you have to treat even !kill-all memcgs like a
> > single entity. In fact we should compare killable entities which is
> > either a task or the whole memcg if configured that way.
> 
> I believe it's absolutely valid user's intention to prioritize some
> cgroups over other, even if only one task should be killed in case of OOM.

This is mixing different concepts which I really dislike. The semantic
is getting really fuzzy. How are you going to apply memcg priority when
you are killing a single task? What portion of the memcgs priority does
the task get? Then you have that root is special...

No I really dislike this. We should start simple and compare killable
entities. If you want to apply memcg priority then only on the whole
memcgs.
-- 
Michal Hocko
SUSE Labs
