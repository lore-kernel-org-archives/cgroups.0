From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [patch -mm v2 2/3] mm, memcg: replace cgroup aware oom killer
 mount option with tunable
Date: Tue, 30 Jan 2018 13:08:52 +0100
Message-ID: <20180130120852.GA21609@dhcp22.suse.cz>
References: <alpine.DEB.2.10.1801251553030.161808@chino.kir.corp.google.com>
 <20180125160016.30e019e546125bb13b5b6b4f@linux-foundation.org>
 <alpine.DEB.2.10.1801261415090.15318@chino.kir.corp.google.com>
 <20180126143950.719912507bd993d92188877f@linux-foundation.org>
 <alpine.DEB.2.10.1801261441340.20954@chino.kir.corp.google.com>
 <20180126161735.b999356fbe96c0acd33aaa66@linux-foundation.org>
 <20180129104657.GC21609@dhcp22.suse.cz>
 <20180129191139.GA1121507@devbig577.frc2.facebook.com>
 <20180130085445.GQ21609@dhcp22.suse.cz>
 <20180130115846.GA4720@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180130115846.GA4720-B3w7+ongkCiLfgCeKHXN1g2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue 30-01-18 11:58:51, Roman Gushchin wrote:
> On Tue, Jan 30, 2018 at 09:54:45AM +0100, Michal Hocko wrote:
> > On Mon 29-01-18 11:11:39, Tejun Heo wrote:
> 
> Hello, Michal!
> 
> > diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
> > index 2eaed1e2243d..67bdf19f8e5b 100644
> > --- a/Documentation/cgroup-v2.txt
> > +++ b/Documentation/cgroup-v2.txt
> > @@ -1291,8 +1291,14 @@ This affects both system- and cgroup-wide OOMs. For a cgroup-wide OOM
> >  the memory controller considers only cgroups belonging to the sub-tree
> >  of the OOM'ing cgroup.
> >  
> > -The root cgroup is treated as a leaf memory cgroup, so it's compared
> > -with other leaf memory cgroups and cgroups with oom_group option set.
>                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> IMO, this statement is important. Isn't it?
> 
> > +Leaf cgroups are compared based on their cumulative memory usage. The
> > +root cgroup is treated as a leaf memory cgroup as well, so it's
> > +compared with other leaf memory cgroups. Due to internal implementation
> > +restrictions the size of the root cgroup is a cumulative sum of
> > +oom_badness of all its tasks (in other words oom_score_adj of each task
> > +is obeyed). Relying on oom_score_adj (appart from OOM_SCORE_ADJ_MIN)
> > +can lead to overestimating of the root cgroup consumption and it is
> 
> Hm, and underestimating too. Also OOM_SCORE_ADJ_MIN isn't any different
> in this case. Say, all tasks except a small one have OOM_SCORE_ADJ set to
> -999, this means the root croup has extremely low chances to be elected.
> 
> > +therefore discouraged. This might change in the future, though.
> 
> Other than that looks very good to me.

This?

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index 2eaed1e2243d..34ad80ee90f2 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -1291,8 +1291,15 @@ This affects both system- and cgroup-wide OOMs. For a cgroup-wide OOM
 the memory controller considers only cgroups belonging to the sub-tree
 of the OOM'ing cgroup.
 
-The root cgroup is treated as a leaf memory cgroup, so it's compared
-with other leaf memory cgroups and cgroups with oom_group option set.
+Leaf cgroups and cgroups with oom_group option set are compared based
+on their cumulative memory usage. The root cgroup is treated as a
+leaf memory cgroup as well, so it's compared with other leaf memory
+cgroups. Due to internal implementation restrictions the size of
+the root cgroup is a cumulative sum of oom_badness of all its tasks
+(in other words oom_score_adj of each task is obeyed). Relying on
+oom_score_adj (appart from OOM_SCORE_ADJ_MIN) can lead to over or
+underestimating of the root cgroup consumption and it is therefore
+discouraged. This might change in the future, though.
 
 If there are no cgroups with the enabled memory controller,
 the OOM killer is using the "traditional" process-based approach.
-- 
Michal Hocko
SUSE Labs
