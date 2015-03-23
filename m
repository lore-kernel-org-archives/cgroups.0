From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 16/18] writeback: reset wb_domain->dirty_limit[_tstmp] when memcg domain size changes
Date: Mon, 23 Mar 2015 01:07:45 -0400
Message-ID: <1427087267-16592-17-git-send-email-tj@kernel.org>
References: <1427087267-16592-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yOSpFLqGaTmaNkS3Qrx9g+T1oPVZh5f1yh/N1P3Y5B4=;
        b=cuuXW6e3Wvm0YzPsoGFMb8ADuoUX4aC5RUomS7nHQp/o3UYO4ZdsRIK7G9+AW77wXn
         zhhPv7/xoXLjsdcwASL3ySOkbb5EwygzeHox0/NhdBsz3QZYRk88OFvVvHkcnbOT/gk5
         pgG13IKOsdGym7Qat8BldxDV2w6Ys5p3ojq8xsoUWDJyHiKERKSn4wmfqzst2FK9GgAn
         P+CPv3RadGYwBd7lCd8vU+D7VjgX/cY8s8E/YrmJrm4tTDMNEPaffTL3WlK/K1IsttpA
         ZiUw1bTFEKhEhg6wP0wdVkWdqVD4YqDombl4VJ9gICbc9CnByqkhmHzUQqUGkptkq8sY
         w+hA==
In-Reply-To: <1427087267-16592-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

The amount of available memory to a memcg wb_domain can change as
memcg configuration changes.  A domain's ->dirty_limit exists to
smooth out sudden drops in dirty threshold; however, when a domain's
size actually drops significantly, it hinders the dirty throttling
from adjusting to the new configuration leading to unexpected
behaviors including unnecessary OOM kills.

This patch resolves the issue by adding wb_domain_size_changed() which
resets ->dirty_limit[_tstmp] and making memcg call it on configuration
changes.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/writeback.h | 20 ++++++++++++++++++++
 mm/memcontrol.c           | 12 ++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index e421625..9ae0648 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -132,6 +132,26 @@ struct wb_domain {
 	unsigned long dirty_limit;
 };
 
+/**
+ * wb_domain_size_changed - memory available to a wb_domain has changed
+ * @dom: wb_domain of interest
+ *
+ * This function should be called when the amount of memory available to
+ * @dom has changed.  It resets @dom's dirty limit parameters to prevent
+ * the past values which don't match the current configuration from skewing
+ * dirty throttling.  Without this, when memory size of a wb_domain is
+ * greatly reduced, the dirty throttling logic may allow too many pages to
+ * be dirtied leading to consecutive unnecessary OOMs and may get stuck in
+ * that situation.
+ */
+static inline void wb_domain_size_changed(struct wb_domain *dom)
+{
+	spin_lock(&dom->lock);
+	dom->dirty_limit_tstamp = jiffies;
+	dom->dirty_limit = 0;
+	spin_unlock(&dom->lock);
+}
+
 /*
  * fs/fs-writeback.c
  */	
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2a74cf3..108acfc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4096,6 +4096,11 @@ static void memcg_wb_domain_exit(struct mem_cgroup *memcg)
 	wb_domain_exit(&memcg->cgwb_domain);
 }
 
+static void memcg_wb_domain_size_changed(struct mem_cgroup *memcg)
+{
+	wb_domain_size_changed(&memcg->cgwb_domain);
+}
+
 struct wb_domain *mem_cgroup_wb_domain(struct bdi_writeback *wb)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
@@ -4117,6 +4122,10 @@ static void memcg_wb_domain_exit(struct mem_cgroup *memcg)
 {
 }
 
+static void memcg_wb_domain_size_changed(struct mem_cgroup *memcg)
+{
+}
+
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
 /*
@@ -4715,6 +4724,7 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 	memcg->low = 0;
 	memcg->high = PAGE_COUNTER_MAX;
 	memcg->soft_limit = PAGE_COUNTER_MAX;
+	memcg_wb_domain_size_changed(memcg);
 }
 
 #ifdef CONFIG_MMU
@@ -5347,6 +5357,7 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 
 	memcg->high = high;
 
+	memcg_wb_domain_size_changed(memcg);
 	return nbytes;
 }
 
@@ -5379,6 +5390,7 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 	if (err)
 		return err;
 
+	memcg_wb_domain_size_changed(memcg);
 	return nbytes;
 }
 
-- 
2.1.0
