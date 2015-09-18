From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 8/8] memcg: generate file modified notifications on
 "memory.events"
Date: Fri, 18 Sep 2015 18:01:59 -0400
Message-ID: <20150918220159.GB2893@mtj.duckdns.org>
References: <1439315889-3492-1-git-send-email-tj@kernel.org>
 <1439315889-3492-9-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=octX8XfFlJYd6s5SSM37lk2iYCWEN6Fj4LpTU2/DveM=;
        b=lgT87E+TLj/w/enmF4H3at143YmPI3RyVdMMVv0RhcbBqlezL1nfTPMOJ4j6pccy+X
         TWksSJBqLvUFwx4lAAB8Wnf89fPqD98/BM2kfjaLFB+EgaPV28PMgeKDDy0VkjV31nzj
         vwzE+usJ1I17xSrngZuH+8XyOJw+VwUveU4s3//qmvm0tU9eQSIx7FIHXY5o+brBABM1
         GvIKtr2OTAIu/Wr7WSl7QS9T47pyAExLK9BjPNeTpRZpatXdakCncjFO+oxZm2Notd5w
         a50+52BhECajbQjdGHNT/ExJiw3S80Gchmq4FgIhdA4muN6geDByDqGwKC4DfTmSZTRt
         ZSkw==
Content-Disposition: inline
In-Reply-To: <1439315889-3492-9-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

cgroup core only recently grew generic notification support.  Wire up
"memory.events" so that it triggers a file modified event whenever its
content changes.

v2: Refreshed on top of mem_cgroup relocation.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Acked-by: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
Hello,

Once cgroup/for-4.4 gets propagated to mm, this should apply cleanly.
Alternatively, I can apply it through the cgroup tree.  Which would
you prefer?

Thanks.

 include/linux/memcontrol.h |    4 ++++
 mm/memcontrol.c            |    1 +
 2 files changed, 5 insertions(+)

--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -213,6 +213,9 @@ struct mem_cgroup {
 	/* OOM-Killer disable */
 	int		oom_kill_disable;
 
+	/* handle for "memory.events" */
+	struct cgroup_file events_file;
+
 	/* protect arrays of thresholds */
 	struct mutex thresholds_lock;
 
@@ -286,6 +289,7 @@ static inline void mem_cgroup_events(str
 		       unsigned int nr)
 {
 	this_cpu_add(memcg->stat->events[idx], nr);
+	cgroup_file_notify(&memcg->events_file);
 }
 
 bool mem_cgroup_low(struct mem_cgroup *root, struct mem_cgroup *memcg);
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5202,6 +5202,7 @@ static struct cftype memory_files[] = {
 	{
 		.name = "events",
 		.flags = CFTYPE_NOT_ON_ROOT,
+		.file_offset = offsetof(struct mem_cgroup, events_file),
 		.seq_show = memory_events_show,
 	},
 	{ }	/* terminate */
