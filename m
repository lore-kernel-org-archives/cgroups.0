From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] memcg: make memcg->event_list_lock irqsafe
Date: Mon, 30 Aug 2021 10:29:53 -0700
Message-ID: <20210830172953.207257-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=LVV3UHlk75yje1xXSFFRWyfRbrh8OImERx560ZLqV78=;
        b=IvtVU2ecU6KZCoDqCW093hiZ2lhwtQIofFW8UZrOYtk+4S6cXBZM8LYiHxTLo4DA62
         Mcsr5juVYUrOy8rNyG1yZ7voTbgtLZowhpm4tnGY655pEJvnJp7fyMZTqiMH1sQS94hr
         9UX3sA2Bb364oAvBYogFtLGQ1YCTDOAgIbFSxHqXCrfUwhq49GCKEQbLyH/0HeZAZCCH
         T5ilQHDzPuxCXeyzVeQjK6gBJHf4UkTwnOl2zR/K51CKwqjq2xQmcZYfaxYnOM37SYRS
         8CIAN6O9Bq5BWHogtAPODwYydCw1lsWmC5+GKMkgJl7k0H6KCXzSLTMvK8Mejsyaoirg
         ajVA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

The memcg->event_list_lock is usually taken in the normal context but
when the userspace closes the corresponding eventfd, eventfd_release
through memcg_event_wake takes memcg->event_list_lock with interrupts
disabled. This is not an issue on its own but it creates a nested
dependency from eventfd_ctx->wqh.lock to memcg->event_list_lock.

Independently, for unrelated eventfd, eventfd_signal() can be called in
the irq context, thus making eventfd_ctx->wqh.lock an irq lock. For
example, FPGA DFL driver, VHOST VPDA driver and couple of VFIO drivers.
This will force memcg->event_list_lock to be an irqsafe lock as well.

One way to break the nested dependency between eventfd_ctx->wqh.lock and
memcg->event_list_lock is to add an indirection. However the simplest
solution would be to make memcg->event_list_lock irqsafe. This is cgroup
v1 feature, is in maintenance and may get deprecated in near future. So,
no need to add more code.

BTW this has been discussed previously [1] but there weren't irq users
of eventfd_signal() at the time.

[1] https://www.spinics.net/lists/cgroups/msg06248.html

Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 999e626f4111..a73689caee5d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4851,9 +4851,9 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 
 	vfs_poll(efile.file, &event->pt);
 
-	spin_lock(&memcg->event_list_lock);
+	spin_lock_irq(&memcg->event_list_lock);
 	list_add(&event->list, &memcg->event_list);
-	spin_unlock(&memcg->event_list_lock);
+	spin_unlock_irq(&memcg->event_list_lock);
 
 	fdput(cfile);
 	fdput(efile);
@@ -5280,12 +5280,12 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 	 * Notify userspace about cgroup removing only after rmdir of cgroup
 	 * directory to avoid race between userspace and kernelspace.
 	 */
-	spin_lock(&memcg->event_list_lock);
+	spin_lock_irq(&memcg->event_list_lock);
 	list_for_each_entry_safe(event, tmp, &memcg->event_list, list) {
 		list_del_init(&event->list);
 		schedule_work(&event->remove);
 	}
-	spin_unlock(&memcg->event_list_lock);
+	spin_unlock_irq(&memcg->event_list_lock);
 
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
-- 
2.33.0.259.gc128427fd7-goog

