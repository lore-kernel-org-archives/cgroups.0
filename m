From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH 3/4] provide a function to register more cftype files into memcg
Date: Tue, 20 Mar 2012 20:50:55 +0400
Message-ID: <1332262256-13407-4-git-send-email-glommer@parallels.com>
References: <1332262256-13407-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332262256-13407-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

The function mem_cgroup_register_cftype() is provided here, so
an optional memcg subsystem that needs to register files at
a time later than memcg initialization can do it.

Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
CC: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CC: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 include/linux/memcontrol.h |    1 +
 mm/memcontrol.c            |    6 ++++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 4d34356..bcf8de3 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -141,6 +141,7 @@ static inline bool mem_cgroup_disabled(void)
 	return false;
 }
 
+int mem_cgroup_register_cftype(const struct cftype *cfts);
 void mem_cgroup_update_page_stat(struct page *page,
 				 enum mem_cgroup_page_stat_item idx,
 				 int val);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f7c6727..bd91a46 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -444,6 +444,12 @@ struct cgroup_subsys_state *mem_cgroup_css(struct mem_cgroup *memcg)
 	return &memcg->css;
 }
 
+int mem_cgroup_register_cftype(const struct cftype *cfts)
+{
+	return WARN_ON(cgroup_add_cftypes(&mem_cgroup_subsys, cfts));
+}
+EXPORT_SYMBOL(mem_cgroup_register_cftype);
+
 static struct mem_cgroup_per_zone *
 page_cgroup_zoneinfo(struct mem_cgroup *memcg, struct page *page)
 {
-- 
1.7.7.6
