From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] memcg: deprecate memory.force_empty knob
Date: Mon, 12 May 2014 17:34:58 +0200
Message-ID: <20140512153458.GJ9564@dhcp22.suse.cz>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <1399671091-23867-3-git-send-email-tj@kernel.org>
 <20140512145324.GE9564@dhcp22.suse.cz>
 <20140512145803.GF9564@dhcp22.suse.cz>
 <20140512150014.GB1421@htj.dyndns.org>
 <20140512152015.GH9564@dhcp22.suse.cz>
 <20140512152507.GD1421@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140512152507.GD1421-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org

On Mon 12-05-14 11:25:07, Tejun Heo wrote:
> On Mon, May 12, 2014 at 05:20:15PM +0200, Michal Hocko wrote:
> > On Mon 12-05-14 11:00:14, Tejun Heo wrote:
> > > On Mon, May 12, 2014 at 04:58:03PM +0200, Michal Hocko wrote:
> > > > @@ -4793,6 +4793,10 @@ static int mem_cgroup_force_empty_write(struct cgroup_subsys_state *css,
> > > >  
> > > >  	if (mem_cgroup_is_root(memcg))
> > > >  		return -EINVAL;
> > > > +	pr_info("%s (%d): memory.force_empty is deprecated and will be removed.",
> > > > +			current->comm, task_pid_nr(current));
> > > > +	pr_cont(" Let us know if you know if it needed in your usecase at");
> > > > +	pr_cont(" linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org\n");
> > > >  	return mem_cgroup_force_empty(memcg);
> > > 
> > > It probably would be way easier to just mark the knob with
> > > CFTYPE_INSANE.
> > 
> > That would prevent from creating the file, right? I do not mind that but
> > I would like to see people complaining before.
> 
> Oh sure, if you wanna see people complaining before the roll out of
> unified hierarchy, but let's make sure it's also marked with
> CFTYPE_INSANE.  It's easy to remove the flag afterwards.  The other
> way isn't, so...
---
From 6f2a33df7750f0794b03f7a85aba02a4e631f2a0 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Date: Mon, 12 May 2014 16:20:46 +0200
Subject: [PATCH] memcg: deprecate memory.force_empty knob

force_empty has been introduced primarily to drop memory before it gets
reparented on the group removal. This alone doesn't sound fully
justified because reparented pages which are not in use can be reclaimed
also later when there is a memory pressure on the parent level.

Mark the knob CFTYPE_INSANE which tells the cgroup core that it
shouldn't create the knob with the experimental sane_behavior. Other
users will get informed about the deprecation and asked to tell us more.
But I expect that most users will be simply cgroup remove handlers
which do that since ever without having any good reason for it.

If somebody really cares and the reparented pages, which would be dropped
otherwise, push out more important ones then we should fix the
reparenting code and put pages to the tail.

Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 Documentation/cgroups/memory.txt | 3 +++
 mm/memcontrol.c                  | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index f0f67b44ea07..fc9fad984bfb 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -477,6 +477,9 @@ About use_hierarchy, see Section 6.
   write will still return success. In this case, it is expected that
   memory.kmem.usage_in_bytes == memory.usage_in_bytes.
 
+  Please note that this knob is considered deprecated and will be removed
+  in future.
+
   About use_hierarchy, see Section 6.
 
 5.2 stat file
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b030b15b626a..ee123f3d40d5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4793,6 +4793,10 @@ static int mem_cgroup_force_empty_write(struct cgroup_subsys_state *css,
 
 	if (mem_cgroup_is_root(memcg))
 		return -EINVAL;
+	pr_info("%s (%d): memory.force_empty is deprecated and will be removed.",
+			current->comm, task_pid_nr(current));
+	pr_cont(" Let us know if you know if it needed in your usecase at");
+	pr_cont(" linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org\n");
 	return mem_cgroup_force_empty(memcg);
 }
 
@@ -6037,6 +6041,7 @@ static struct cftype mem_cgroup_files[] = {
 	},
 	{
 		.name = "force_empty",
+		.flags = CFTYPE_INSANE,
 		.trigger = mem_cgroup_force_empty_write,
 	},
 	{
-- 
2.0.0.rc0

-- 
Michal Hocko
SUSE Labs
