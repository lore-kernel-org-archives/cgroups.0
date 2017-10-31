From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RESEND v12 3/6] mm, oom: cgroup-aware OOM killer
Date: Tue, 31 Oct 2017 20:06:44 +0100
Message-ID: <20171031190644.fgwpmvreseurxsgd@dhcp22.suse.cz>
References: <20171019185218.12663-1-guro@fb.com>
 <20171019185218.12663-4-guro@fb.com>
 <CALvZod7V1iNACeDJuuSDrMMGMo7YX+gZ87gq=S4rP=Eh9Wh5kQ@mail.gmail.com>
 <20171031152923.ndyxpdmx3npyqoqf@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171031152923.ndyxpdmx3npyqoqf@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guro@fb.com>, Linux MM <linux-mm@kvack.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Tue 31-10-17 16:29:23, Michal Hocko wrote:
> On Tue 31-10-17 08:04:19, Shakeel Butt wrote:
> > > +
> > > +static void select_victim_memcg(struct mem_cgroup *root, struct oom_control *oc)
> > > +{
> > > +       struct mem_cgroup *iter;
> > > +
> > > +       oc->chosen_memcg = NULL;
> > > +       oc->chosen_points = 0;
> > > +
> > > +       /*
> > > +        * The oom_score is calculated for leaf memory cgroups (including
> > > +        * the root memcg).
> > > +        */
> > > +       rcu_read_lock();
> > > +       for_each_mem_cgroup_tree(iter, root) {
> > > +               long score;
> > > +
> > > +               if (memcg_has_children(iter) && iter != root_mem_cgroup)
> > > +                       continue;
> > > +
> > 
> > Cgroup v2 does not support charge migration between memcgs. So, there
> > can be intermediate nodes which may contain the major charge of the
> > processes in their leave descendents. Skipping such intermediate nodes
> > will kind of protect such processes from oom-killer (lower on the list
> > to be killed). Is it ok to not handle such scenario? If yes, shouldn't
> > we document it?
> 
> Yes, this is a real problem and the one which is not really solvable
> without the charge migration. You simply have no clue _who_ owns the
> memory so I assume that admins will need to setup the hierarchy which
> allows subgroups to migrate tasks to be oom_group.

Hmm, scratch that. I have completely missed that the memory controller
disables tasks migration completely in v2. I thought the standard
restriction about the write access to the target cgroup and a common
ancestor holds for all controllers but now I've noticed that we
simply disallow the migration altogether. This wasn't the case before
1f7dd3e5a6e4 ("cgroup: fix handling of multi-destination migration from
subtree_control enabling") which I wasn't aware of.
-- 
Michal Hocko
SUSE Labs
