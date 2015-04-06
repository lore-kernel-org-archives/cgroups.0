From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 17/19] writeback: reset wb_domain->dirty_limit[_tstmp] when memcg domain size changes
Date: Mon,  6 Apr 2015 16:04:32 -0400
Message-ID: <1428350674-8303-18-git-send-email-tj@kernel.org>
References: <1428350674-8303-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HfjvutpOIZWvdcLX2Du74DY2/1afrMQq+D9QCBKSj68=;
        b=hWT6fr9A+JABvJBpMu6xA1/7nS+fISAu6hLPdgolJ5t1LF+0QoknvNzSm07X0DF5pL
         ueOzWBHdQMqpA7uKh1kxYuObrfoK88gObdagBpfMsSHO+tnC71xKVIHuH5jg3lY4tXxv
         1m8pCQvFV0PzLYj0RblRql3RTzrcPNc4tgYL0tpX7hhuRJPHrRfX9yoH6WGu4htA6P1z
         QRu8fgXvRxi1ub6c3Q5cXL6mDgxg34TtZHYysD4SvgyRx8x+2L8CR1U6H6PkD0M80Gis
         Q1EiwHkNSxC+MD4N0aCyRIRajJvuZARhf0uhl+avUtfTJm3r8haLe4hUw+tz9yfqTyfk
         arNA==
In-Reply-To: <1428350674-8303-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, Tejun Heo <tj@kernel.org>

The amount of available memory to a memcg wb_domain can change as
memcg configuration changes.  A domain's ->dirty_limit exists to
smooth out sudden drops in dirty threshold; however, when a domain's
size actually drops significantly, it hinders the dirty throttling
from adjusting to the new configuration leading to unexpected
behaviors including unnecessary OOM kills.

This patch resolves the issue by adding wb_domain_size_changed() which
resets ->dirty_limit[_tstmp] and making memcg call it on configuration
changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Greg Thelen <gthelen@google.com>
---
 include/linux/writeback.h | 20 ++++++++++++++++++++
 mm/memcontrol.c           | 12 ++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index a9eb40f..5b86988 100644
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
