From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 2/3] memcg: Limit the number of events registered on
 oom_control
Date: Wed, 7 Aug 2013 19:30:51 +0200
Message-ID: <20130807173051.GD16343@dhcp22.suse.cz>
References: <1375874907-22013-1-git-send-email-mhocko@suse.cz>
 <1375874907-22013-2-git-send-email-mhocko@suse.cz>
 <20130807130836.GB27006@htj.dyndns.org>
 <20130807133746.GI8184@dhcp22.suse.cz>
 <20130807134741.GF27006@htj.dyndns.org>
 <20130807135734.GK8184@dhcp22.suse.cz>
 <20130807144730.GB13279@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130807144730.GB13279-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

On Wed 07-08-13 16:47:30, Michal Hocko wrote:
> On Wed 07-08-13 15:57:34, Michal Hocko wrote:
> [...]
> > Hmm, OK so you think that the fd limit is sufficient already?
> 
> Hmm, that would need to touch the code as well (the register callback
> would need to make sure only one event is registered per cfile). But yes
> this way would be better. I will send a new patch once I have an idle
> moment.

What do you think about the following? I am not sure about EINVAL maybe
there is a better way to tell userspace it is doing something wrong. I
would appreciate any suggestions. If this looks good I will post a
similar patch for vmpressure.
---
From 180614714348300836701bec618608059438efc2 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Date: Wed, 7 Aug 2013 18:51:40 +0200
Subject: [PATCH] memcg: Limit the number of events registered on oom_control

There is no limit for the maximum number of oom_control events
registered per memcg. This might lead to an user triggered memory
depletion if a regular user is allowed to register events because one
file descriptor might be used for arbitrary number of registrations.

Let's be more strict and cap the number of events to the number of
open file descriptors. Teach mem_cgroup_oom_register_event to check
the registered events and fail if the given cftype (target file file
descriptor) has been already registered. This will cap the number of
events to the maximum number of allowed open files so no user who is
allowed to register event can runaway the an existing limit.

Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 mm/memcontrol.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8247db3..f893a39 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -212,6 +212,7 @@ struct mem_cgroup_thresholds {
 struct mem_cgroup_eventfd_list {
 	struct list_head list;
 	struct eventfd_ctx *eventfd;
+	struct cftype *cft;
 };
 
 static void mem_cgroup_threshold(struct mem_cgroup *memcg);
@@ -5577,6 +5578,7 @@ static int mem_cgroup_oom_register_event(struct cgroup *cgrp,
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
 	struct mem_cgroup_eventfd_list *event;
 	enum res_type type = MEMFILE_TYPE(cft->private);
+	struct mem_cgroup_eventfd_list *ev, *tmp;
 
 	BUG_ON(type != _OOM_TYPE);
 	event = kmalloc(sizeof(*event),	GFP_KERNEL);
@@ -5585,7 +5587,20 @@ static int mem_cgroup_oom_register_event(struct cgroup *cgrp,
 
 	spin_lock(&memcg_oom_lock);
 
+	/*
+	 * Make sure that only one event is registered for the given
+	 * cftype - aka file descriptor. This caps the number of events
+	 * to number of file descriptors per process so the userspace doesn't
+	 * escape and depleate the memory.
+	 */
+	list_for_each_entry_safe(ev, tmp, &memcg->oom_notify, list) {
+		if (ev->cft == cft) {
+			kfree(event);
+			return -EINVAL;
+		}
+	}
 	event->eventfd = eventfd;
+	event->cft = cft;
 	list_add(&event->list, &memcg->oom_notify);
 
 	/* already in OOM ? */
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
