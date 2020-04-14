From: svc_lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org
Subject: [PATCH v1 1/2] memcg, vmpressure: expose vmpressure controls
Date: Tue, 14 Apr 2020 13:18:39 -0400
Message-ID: <20200414171840.22053-2-lmoiseichuk@magicleap.com>
References: <20200414171840.22053-1-lmoiseichuk@magicleap.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=magicleap.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=pp09042018;
 bh=w/qRpVJWlv8XupjZp41y7klSw+TDxGexre95wiqpeCI=;
 b=pgH5rboVZk+3nYg7mmd6Ld7nY9hS6e+WeeHzj89AhxHvXqjz7XwQ5o6LV2375Ez/ZvUx
 EuCHniD600/Hv+mtSvUMX8HTmClj0K4lVpCBzyPHMjro+fbq2ahF0iH8OMl8p5vo+dod
 SDBu6GxsOoShOwtdcCDjhbaocRDalnSlEgNL+2tl5CdZ/jrEJEtV22AxrWZyjFlr1mML
 t7iOVEvN4i1ubdXu2B1RHs1QCZKrmFhVb7Mo/AatkIvmsryloaYAbVx3CyvrqL5BpO1F
 mp+Hcez+8FnUHYx5UVvqfN5cjcc1kDV/4KIYfm63KiJEbV4pfE0jDhWT/SKJLurOToZM Yw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=magicleap.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=w/qRpVJWlv8XupjZp41y7klSw+TDxGexre95wiqpeCI=;
        b=RzPGP4DK8FNrCIIritILyTbfeuCXhJPbCca+J7GL5RxguH77pGXSgz4gM+ADjSWDvL
         2Ns9zskvWM7zDx9uyod0wd0uM5YgnBPYbr1Egz2KPQkS+B+8EtrDkIa4ukU5iBYJ8jJg
         N07bD6qSQ+GwcUoS4UUcUKEIbU7o4COcBNtHU=
In-Reply-To: <20200414171840.22053-1-lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vinmenon-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Leonid Moiseichuk <lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>

From: Leonid Moiseichuk <lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>

Updated documentation for populating memcg vmpressure controls
with legacy defaults:
- memory.pressure_window (512 or SWAP_CLUSTER_MAX * 16)
- memory.pressure_level_critical_prio (3)
- memory.pressure_level_medium (60)
- memory.pressure_level_critical (95)

Signed-off-by: Leonid Moiseichuk <lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v1/memory.rst | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 0ae4f564c2d6..42508123a8e1 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -79,6 +79,12 @@ Brief summary of control files.
  memory.use_hierarchy		     set/show hierarchical account enabled
  memory.force_empty		     trigger forced page reclaim
  memory.pressure_level		     set memory pressure notifications
+ memory.pressure_window 	     set window size for scanned pages, better
+				     to perform it as vmscan reclaimer logic
+				     in chunks in multiple SWAP_CLUSTER_MAX
+ memory.pressure_level_critical_prio vmscan priority for critical level
+ memory.pressure_level_medium	     medium level pressure percents
+ memory.pressure_level_critical      critical level pressure percents
  memory.swappiness		     set/show swappiness parameter of vmscan
 				     (See sysctl's vm.swappiness)
  memory.move_charge_at_immigrate     set/show controls of moving charges
@@ -893,12 +899,16 @@ pressure, the system might be making swap, paging out active file caches,
 etc. Upon this event applications may decide to further analyze
 vmstat/zoneinfo/memcg or internal memory usage statistics and free any
 resources that can be easily reconstructed or re-read from a disk.
+The level threshold could be tuned using memory.pressure_level_medium.
 
 The "critical" level means that the system is actively thrashing, it is
 about to out of memory (OOM) or even the in-kernel OOM killer is on its
 way to trigger. Applications should do whatever they can to help the
 system. It might be too late to consult with vmstat or any other
-statistics, so it's advisable to take an immediate action.
+statistics, so it's advisable to take an immediate action. The level
+threshold could be tuned using memory.pressure_level_critical. Number
+of pages and vmscan priority handled as memory.pressure_window and
+memory.pressure_level_critical_prio.
 
 By default, events are propagated upward until the event is handled, i.e. the
 events are not pass-through. For example, you have three cgroups: A->B->C. Now
-- 
2.17.1

