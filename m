From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/3] memcg: limit the number of thresholds per-memcg
Date: Wed, 7 Aug 2013 16:37:27 +0200
Message-ID: <20130807143727.GA13279@dhcp22.suse.cz>
References: <1375874907-22013-1-git-send-email-mhocko@suse.cz>
 <20130807132210.GD27006@htj.dyndns.org>
 <20130807134654.GJ8184@dhcp22.suse.cz>
 <20130807135818.GG27006@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130807135818.GG27006-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

On Wed 07-08-13 09:58:18, Tejun Heo wrote:
> Hello,
> 
> On Wed, Aug 07, 2013 at 03:46:54PM +0200, Michal Hocko wrote:
> > OK, I have obviously misunderstood your concern mentioned in the other
> > email. Could you be more specific what is the DoS scenario which was
> > your concern, then?
> 
> So, let's say the file is write-accessible to !priv user which is
> under reasonable resource limits.  Normally this shouldn't affect priv
> system tools which are monitoring the same event as it shouldn't be
> able to deplete resources as long as the resource control mechanisms
> are configured and functioning properly; however, the memory usage
> event puts all event listeners into a single contiguous table which a
> !priv user can easily expand to a size where the table can no longer
> be enlarged and if a priv system tool or another user tries to
> register event afterwards, it'll fail.  IOW, it creates a shared
> resource which isn't properly provisioned and can be trivially filled
> up making it an easy DoS target.

OK, got your point. You are right and I haven't considered the size of
the table and the size restrictions of kmalloc. Thanks for pointing this
out!
---
From cde8a3333296eddd288780e78803610127401b6a Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Date: Wed, 7 Aug 2013 11:11:22 +0200
Subject: [PATCH] memcg: limit the number of thresholds per-memcg

There is no limit for the maximum number of threshold events registered
per memcg. It is even worse that all the events are stored in a
per-memcg table which is enlarged when a new event is registered. This
can lead to the following issue mentioned by Tejun:
"
So, let's say the file is write-accessible to !priv user which is
under reasonable resource limits.  Normally this shouldn't affect priv
system tools which are monitoring the same event as it shouldn't be
able to deplete resources as long as the resource control mechanisms
are configured and functioning properly; however, the memory usage
event puts all event listeners into a single contiguous table which a
!priv user can easily expand to a size where the table can no longer
be enlarged and if a priv system tool or another user tries to
register event afterwards, it'll fail.  IOW, it creates a shared
resource which isn't properly provisioned and can be trivially filled
up making it an easy DoS target.
"

Let's be more strict and cap the number of events that might be
registered. MAX_THRESHOLD_EVENTS value is more or less random. The
expectation is that it should be high enough to cover reasonable
usecases while not too high to allow excessive resources consumption.
1024 events consume something like 16KB which shouldn't be a big deal
and it should be good enough.

Reported-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 mm/memcontrol.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e4330cd..8247db3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5401,6 +5401,9 @@ static void mem_cgroup_oom_notify(struct mem_cgroup *memcg)
 		mem_cgroup_oom_notify_cb(iter);
 }
 
+/* Maximum number of treshold events registered per memcg. */
+#define MAX_THRESHOLD_EVENTS	1024
+
 static int mem_cgroup_usage_register_event(struct cgroup *cgrp,
 	struct cftype *cft, struct eventfd_ctx *eventfd, const char *args)
 {
@@ -5424,6 +5427,11 @@ static int mem_cgroup_usage_register_event(struct cgroup *cgrp,
 	else
 		BUG();
 
+	if (thresholds->primary->size == MAX_THRESHOLD_EVENTS) {
+		ret = -ENOSPC;
+		goto unlock;
+	}
+
 	usage = mem_cgroup_usage(memcg, type == _MEMSWAP);
 
 	/* Check if a threshold crossed before adding a new one */
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
