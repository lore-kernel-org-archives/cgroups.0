From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RESEND v12 3/6] mm, oom: cgroup-aware OOM killer
Date: Tue, 31 Oct 2017 16:29:23 +0100
Message-ID: <20171031152923.ndyxpdmx3npyqoqf@dhcp22.suse.cz>
References: <20171019185218.12663-1-guro@fb.com>
 <20171019185218.12663-4-guro@fb.com>
 <CALvZod7V1iNACeDJuuSDrMMGMo7YX+gZ87gq=S4rP=Eh9Wh5kQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALvZod7V1iNACeDJuuSDrMMGMo7YX+gZ87gq=S4rP=Eh9Wh5kQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue 31-10-17 08:04:19, Shakeel Butt wrote:
> > +
> > +static void select_victim_memcg(struct mem_cgroup *root, struct oom_control *oc)
> > +{
> > +       struct mem_cgroup *iter;
> > +
> > +       oc->chosen_memcg = NULL;
> > +       oc->chosen_points = 0;
> > +
> > +       /*
> > +        * The oom_score is calculated for leaf memory cgroups (including
> > +        * the root memcg).
> > +        */
> > +       rcu_read_lock();
> > +       for_each_mem_cgroup_tree(iter, root) {
> > +               long score;
> > +
> > +               if (memcg_has_children(iter) && iter != root_mem_cgroup)
> > +                       continue;
> > +
> 
> Cgroup v2 does not support charge migration between memcgs. So, there
> can be intermediate nodes which may contain the major charge of the
> processes in their leave descendents. Skipping such intermediate nodes
> will kind of protect such processes from oom-killer (lower on the list
> to be killed). Is it ok to not handle such scenario? If yes, shouldn't
> we document it?

Yes, this is a real problem and the one which is not really solvable
without the charge migration. You simply have no clue _who_ owns the
memory so I assume that admins will need to setup the hierarchy which
allows subgroups to migrate tasks to be oom_group.

Or we might want to allow opt-in for charge migration in v2. To be
honest I wasn't completely happy about removing this functionality
altogether in v2 but there was a strong pushback back then that relying
on the charge migration doesn't have any sound usecase.

Anyway, I agree that documentation should be explicit about that.
-- 
Michal Hocko
SUSE Labs
