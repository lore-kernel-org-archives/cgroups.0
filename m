From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v8 3/3] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Tue, 4 Oct 2022 18:53:37 -0400
Message-ID: <35942f9a-e21c-9317-3d9f-61cbac5f8dfd@redhat.com>
References: <20221004151748.293388-1-longman@redhat.com>
 <20221004151748.293388-4-longman@redhat.com> <YzyAT/lfyKhOnOpy@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664924100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DC7n5vrJm9+7rtzmCox+oVCN8flf2wk8nlQItN2YxhA=;
        b=W72N73GBVXuNma9FdfBikf9sd4fupF03OjMiVi6ldd4VlkkjCmlVIWvPDtbmcAls/AqL7R
        Lu5YEYC187FvMV2xrPretJbgVuvmgyGV3io4XKOWO1lfM8yEjd7JccxlI1CTOXD6WgDMoZ
        dvu3TF5yMSQlYhcKYa2UdBeXw6XLwjo=
Content-Language: en-US
In-Reply-To: <YzyAT/lfyKhOnOpy@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On 10/4/22 14:49, Michal Koutný wrote:
> Hello.
>
> On Tue, Oct 04, 2022 at 11:17:48AM -0400, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> To protect against destruction of blkg, a percpu reference is gotten
>> when putting into the lockless list and put back when removed.
> Just to conclude my previous remark about the loop, let me try
> explaining it more precisely:
>
> blkcg->lhead via blkg_iostat_set holds reference to blkcg_gq
>     (taken in in blk_cgroup_bio_start)
>
> blkcg_gq holds reference to its blkcg_gq->blkcg
>     (taken in blkg_create)
>
> The cycle has two edges, the latter is broken in __blkg_release but
> that's a release callback of the involved blkcg_gq->refcnt, so it won't
> be called.
>
> The first edges is broken in blkcg_rstat_flush and that's more promising.
> The current code does the final flushes -- in css_release_work_fn.
> The problem is that it's the release callback of blkcg->css, i.e. it's
> also referenced on the cycle, therefore this final flush won't happen
> before cycle is broken.
>
> Fortunately, any other caller of cgroup_rstat_flush comes to the rescue
> -- the blkcg_rstat_flush on the stuck blkcg would decompose lhead list
> and the reference cycle is broken.
>
> In summary, I think this adds the reference cycle but its survival time
> is limited to the soonest cgroup_rstat_flush call, which should not
> cause practical troubles.

Thanks for the explanation. I now get what you are referring to. Yes, 
this delayed blkcg removal problem is annoying. I think the following 
patch should eliminate this issue. What do you think?

Cheers,
Longman

----------------8<-------------[ cut here ]------------------

  block/blk-cgroup.c     | 15 ++++++++++++++-
  include/linux/cgroup.h |  1 +
  kernel/cgroup/rstat.c  | 20 ++++++++++++++++++++
  3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 63569b05db0d..f896caef9947 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1122,10 +1122,12 @@ struct list_head *blkcg_get_cgwb_list(struct 
cgroup_subsys_state *css)
   */
  static void blkcg_destroy_blkgs(struct blkcg *blkcg)
  {
+    int cpu;
+
      might_sleep();

+    css_get(&blkcg->css);
      spin_lock_irq(&blkcg->lock);
-
      while (!hlist_empty(&blkcg->blkg_list)) {
          struct blkcg_gq *blkg = hlist_entry(blkcg->blkg_list.first,
                          struct blkcg_gq, blkcg_node);
@@ -1148,6 +1150,17 @@ static void blkcg_destroy_blkgs(struct blkcg *blkcg)
      }

      spin_unlock_irq(&blkcg->lock);
+
+    /*
+     * Flush all the non-empty percpu lockless lists.
+     */
+    for_each_possible_cpu(cpu) {
+        struct llist_head *lhead = per_cpu_ptr(blkcg->lhead, cpu);
+
+        if (!llist_empty(lhead))
+            cgroup_rstat_css_flush(&blkcg->css, cpu);
+    }
+    css_put(&blkcg->css);
  }

  /**
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index ac5d0515680e..33e226a34073 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -763,6 +763,7 @@ void cgroup_rstat_flush(struct cgroup *cgrp);
  void cgroup_rstat_flush_irqsafe(struct cgroup *cgrp);
  void cgroup_rstat_flush_hold(struct cgroup *cgrp);
  void cgroup_rstat_flush_release(void);
+void cgroup_rstat_css_flush(struct cgroup_subsys_state *css, int cpu);

  /*
   * Basic resource stats.
diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index feb59380c896..a4e18d627b54 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -251,6 +251,26 @@ void cgroup_rstat_flush_release(void)
      spin_unlock_irq(&cgroup_rstat_lock);
  }

+/**
+ * cgroup_rstat_css_flush - flush stats for the given css and cpu
+ * @css: target css to be flush
+ * @cpu: the cpu that holds the stats to be flush
+ *
+ * A lightweight rstat flush operation for a given css and cpu.
+ * Only the cpu_lock is being held for mutual exclusion, the 
cgroup_rstat_lock
+ * isn't used.
+ */
+void cgroup_rstat_css_flush(struct cgroup_subsys_state *css, int cpu)
+{
+    raw_spinlock_t *cpu_lock = per_cpu_ptr(&cgroup_rstat_cpu_lock, cpu);
+
+    raw_spin_lock_irq(cpu_lock);
+    rcu_read_lock();
+    css->ss->css_rstat_flush(css, cpu);
+    rcu_read_unlock();
+    raw_spin_unlock_irq(cpu_lock);
+}
+
  int cgroup_rstat_init(struct cgroup *cgrp)
  {
      int cpu;
-- 


