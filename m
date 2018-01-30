From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [patch -mm v2 2/3] mm, memcg: replace cgroup aware oom killer
 mount option with tunable
Date: Tue, 30 Jan 2018 13:20:11 +0100
Message-ID: <20180130122011.GB21609@dhcp22.suse.cz>
References: <alpine.DEB.2.10.1801261415090.15318@chino.kir.corp.google.com>
 <20180126143950.719912507bd993d92188877f@linux-foundation.org>
 <alpine.DEB.2.10.1801261441340.20954@chino.kir.corp.google.com>
 <20180126161735.b999356fbe96c0acd33aaa66@linux-foundation.org>
 <20180129104657.GC21609@dhcp22.suse.cz>
 <20180129191139.GA1121507@devbig577.frc2.facebook.com>
 <20180130085445.GQ21609@dhcp22.suse.cz>
 <20180130115846.GA4720@castle.DHCP.thefacebook.com>
 <20180130120852.GA21609@dhcp22.suse.cz>
 <20180130121315.GA5888@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180130121315.GA5888-B3w7+ongkCiLfgCeKHXN1g2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue 30-01-18 12:13:22, Roman Gushchin wrote:
> On Tue, Jan 30, 2018 at 01:08:52PM +0100, Michal Hocko wrote:
> > On Tue 30-01-18 11:58:51, Roman Gushchin wrote:
> > > On Tue, Jan 30, 2018 at 09:54:45AM +0100, Michal Hocko wrote:
> > > > On Mon 29-01-18 11:11:39, Tejun Heo wrote:
> > > 
> > > Hello, Michal!
> > > 
> > > > diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
> > > > index 2eaed1e2243d..67bdf19f8e5b 100644
> > > > --- a/Documentation/cgroup-v2.txt
> > > > +++ b/Documentation/cgroup-v2.txt
> > > > @@ -1291,8 +1291,14 @@ This affects both system- and cgroup-wide OOMs. For a cgroup-wide OOM
> > > >  the memory controller considers only cgroups belonging to the sub-tree
> > > >  of the OOM'ing cgroup.
> > > >  
> > > > -The root cgroup is treated as a leaf memory cgroup, so it's compared
> > > > -with other leaf memory cgroups and cgroups with oom_group option set.
> > >                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > IMO, this statement is important. Isn't it?
> > > 
> > > > +Leaf cgroups are compared based on their cumulative memory usage. The
> > > > +root cgroup is treated as a leaf memory cgroup as well, so it's
> > > > +compared with other leaf memory cgroups. Due to internal implementation
> > > > +restrictions the size of the root cgroup is a cumulative sum of
> > > > +oom_badness of all its tasks (in other words oom_score_adj of each task
> > > > +is obeyed). Relying on oom_score_adj (appart from OOM_SCORE_ADJ_MIN)
> > > > +can lead to overestimating of the root cgroup consumption and it is
> > > 
> > > Hm, and underestimating too. Also OOM_SCORE_ADJ_MIN isn't any different
> > > in this case. Say, all tasks except a small one have OOM_SCORE_ADJ set to
> > > -999, this means the root croup has extremely low chances to be elected.
> > > 
> > > > +therefore discouraged. This might change in the future, though.
> > > 
> > > Other than that looks very good to me.
> > 
> > This?
> > 
> > diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
> > index 2eaed1e2243d..34ad80ee90f2 100644
> > --- a/Documentation/cgroup-v2.txt
> > +++ b/Documentation/cgroup-v2.txt
> > @@ -1291,8 +1291,15 @@ This affects both system- and cgroup-wide OOMs. For a cgroup-wide OOM
> >  the memory controller considers only cgroups belonging to the sub-tree
> >  of the OOM'ing cgroup.
> >  
> > -The root cgroup is treated as a leaf memory cgroup, so it's compared
> > -with other leaf memory cgroups and cgroups with oom_group option set.
> > +Leaf cgroups and cgroups with oom_group option set are compared based
> > +on their cumulative memory usage. The root cgroup is treated as a
> > +leaf memory cgroup as well, so it's compared with other leaf memory
> > +cgroups. Due to internal implementation restrictions the size of
> > +the root cgroup is a cumulative sum of oom_badness of all its tasks
> > +(in other words oom_score_adj of each task is obeyed). Relying on
> > +oom_score_adj (appart from OOM_SCORE_ADJ_MIN) can lead to over or
> > +underestimating of the root cgroup consumption and it is therefore
> > +discouraged. This might change in the future, though.
> 
> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Andrew?

From 361275a05ad7026b8f721f8aa756a4975a2c42b1 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Date: Tue, 30 Jan 2018 09:54:15 +0100
Subject: [PATCH] oom, memcg: clarify root memcg oom accounting

David Rientjes has pointed out that the current way how the root memcg
is accounted for the cgroup aware OOM killer is undocumented. Unlike
regular cgroups there is no accounting going on in the root memcg
(mostly for performance reasons). Therefore we are suming up oom_badness
of its tasks. This might result in an over accounting because of the
oom_score_adj setting. Document this for now.

Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Signed-off-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
---
 Documentation/cgroup-v2.txt | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

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
2.15.1


-- 
Michal Hocko
SUSE Labs
