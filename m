From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 1/3] loop: Use worker per cgroup instead of kworker
Date: Tue, 6 Apr 2021 09:44:51 +0800
Message-ID: <CACVXFVPgVf2fkf_00pLTiYbUhX-YpGxAJMfnPY0hPeYUhpB+=g@mail.gmail.com>
References: <20210402191638.3249835-1-schatzberg.dan@gmail.com> <20210402191638.3249835-2-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GhFuSU0adajGubBX4Ule4ocsHQm4xPIfHN+0ZP2284Q=;
        b=Wn7ZoBDph7CMtJHFrM/2HqLQhhknorL39ExoxjRlEWg0ChI34+pe7PBgVLf9IVyQHP
         x1jd40BR14iSbCYze82mZLAL3xuUfeNkUR+PfMAuL1+O+1+mekmbAyflotP2lCKFNbK/
         qjXLsrpoIpXnRANynkRppL5bQ+3iOXLGRP6tSA8LpOxwI7F80q2e7Lm6/HZv3rleQ2C6
         5t7WM30+YhlCpcYcM5xk4Daow6smkIoTt1XRch/0FAv9s+6Kbq5W1ueLwabvaKzbNnj2
         vHmP233UcxBsOlISyE7eI65P8WHtacA589Az3egFcgLAYv0yUiTS6XA+l9YNrEwUAOSl
         I7mw==
In-Reply-To: <20210402191638.3249835-2-schatzberg.dan@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Hugh Dickins <hughd@google.com>, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <guro@fb.com>, Muchun Song <songmuchun@bytedance.com>, Yang Shi <shy828301@gmail.com>, Alex Shi <alex.shi@linux.alibaba.com>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Wei Yang <richard.weiyang@gmail.com>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>

On Sat, Apr 3, 2021 at 3:17 AM Dan Schatzberg <schatzberg.dan@gmail.com> wrote:
>
> Existing uses of loop device may have multiple cgroups reading/writing
> to the same device. Simply charging resources for I/O to the backing
> file could result in priority inversion where one cgroup gets
> synchronously blocked, holding up all other I/O to the loop device.
>
> In order to avoid this priority inversion, we use a single workqueue
> where each work item is a "struct loop_worker" which contains a queue of
> struct loop_cmds to issue. The loop device maintains a tree mapping blk
> css_id -> loop_worker. This allows each cgroup to independently make
> forward progress issuing I/O to the backing file.
>
> There is also a single queue for I/O associated with the rootcg which
> can be used in cases of extreme memory shortage where we cannot allocate
> a loop_worker.
>
> The locking for the tree and queues is fairly heavy handed - we acquire
> a per-loop-device spinlock any time either is accessed. The existing
> implementation serializes all I/O through a single thread anyways, so I
> don't believe this is any worse.
>
> Fixes-from: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>
> ---
>  drivers/block/loop.c | 203 ++++++++++++++++++++++++++++++++++++-------
>  drivers/block/loop.h |  12 ++-
>  2 files changed, 178 insertions(+), 37 deletions(-)
>
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index d58d68f3c7cd..4750b373d4bb 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -71,7 +71,6 @@
>  #include <linux/writeback.h>
>  #include <linux/completion.h>
>  #include <linux/highmem.h>
> -#include <linux/kthread.h>
>  #include <linux/splice.h>
>  #include <linux/sysfs.h>
>  #include <linux/miscdevice.h>
> @@ -84,6 +83,8 @@
>
>  #include <linux/uaccess.h>
>
> +#define LOOP_IDLE_WORKER_TIMEOUT (60 * HZ)
> +
>  static DEFINE_IDR(loop_index_idr);
>  static DEFINE_MUTEX(loop_ctl_mutex);
>
> @@ -921,27 +922,83 @@ static void loop_config_discard(struct loop_device *lo)
>         q->limits.discard_alignment = 0;
>  }
>
> -static void loop_unprepare_queue(struct loop_device *lo)
> -{
> -       kthread_flush_worker(&lo->worker);
> -       kthread_stop(lo->worker_task);
> -}
> +struct loop_worker {
> +       struct rb_node rb_node;
> +       struct work_struct work;
> +       struct list_head cmd_list;
> +       struct list_head idle_list;
> +       struct loop_device *lo;
> +       struct cgroup_subsys_state *css;
> +       unsigned long last_ran_at;
> +};
>
> -static int loop_kthread_worker_fn(void *worker_ptr)
> -{
> -       current->flags |= PF_LOCAL_THROTTLE | PF_MEMALLOC_NOIO;
> -       return kthread_worker_fn(worker_ptr);
> -}
> +static void loop_workfn(struct work_struct *work);
> +static void loop_rootcg_workfn(struct work_struct *work);
> +static void loop_free_idle_workers(struct timer_list *timer);
>
> -static int loop_prepare_queue(struct loop_device *lo)
> +static void loop_queue_work(struct loop_device *lo, struct loop_cmd *cmd)
>  {
> -       kthread_init_worker(&lo->worker);
> -       lo->worker_task = kthread_run(loop_kthread_worker_fn,
> -                       &lo->worker, "loop%d", lo->lo_number);
> -       if (IS_ERR(lo->worker_task))
> -               return -ENOMEM;
> -       set_user_nice(lo->worker_task, MIN_NICE);
> -       return 0;
> +       struct rb_node **node = &(lo->worker_tree.rb_node), *parent = NULL;
> +       struct loop_worker *cur_worker, *worker = NULL;
> +       struct work_struct *work;
> +       struct list_head *cmd_list;
> +
> +       spin_lock_irq(&lo->lo_work_lock);
> +
> +       if (!cmd->css)
> +               goto queue_work;
> +
> +       node = &lo->worker_tree.rb_node;
> +
> +       while (*node) {
> +               parent = *node;
> +               cur_worker = container_of(*node, struct loop_worker, rb_node);
> +               if (cur_worker->css == cmd->css) {
> +                       worker = cur_worker;
> +                       break;
> +               } else if ((long)cur_worker->css < (long)cmd->css) {
> +                       node = &(*node)->rb_left;
> +               } else {
> +                       node = &(*node)->rb_right;
> +               }
> +       }
> +       if (worker)
> +               goto queue_work;
> +
> +       worker = kzalloc(sizeof(struct loop_worker), GFP_NOWAIT | __GFP_NOWARN);
> +       /*
> +        * In the event we cannot allocate a worker, just queue on the
> +        * rootcg worker
> +        */
> +       if (!worker)
> +               goto queue_work;
> +
> +       worker->css = cmd->css;
> +       css_get(worker->css);
> +       INIT_WORK(&worker->work, loop_workfn);
> +       INIT_LIST_HEAD(&worker->cmd_list);
> +       INIT_LIST_HEAD(&worker->idle_list);
> +       worker->lo = lo;
> +       rb_link_node(&worker->rb_node, parent, node);
> +       rb_insert_color(&worker->rb_node, &lo->worker_tree);
> +queue_work:
> +       if (worker) {
> +               /*
> +                * We need to remove from the idle list here while
> +                * holding the lock so that the idle timer doesn't
> +                * free the worker
> +                */
> +               if (!list_empty(&worker->idle_list))
> +                       list_del_init(&worker->idle_list);
> +               work = &worker->work;
> +               cmd_list = &worker->cmd_list;
> +       } else {
> +               work = &lo->rootcg_work;
> +               cmd_list = &lo->rootcg_cmd_list;
> +       }
> +       list_add_tail(&cmd->list_entry, cmd_list);
> +       queue_work(lo->workqueue, work);
> +       spin_unlock_irq(&lo->lo_work_lock);
>  }
>
>  static void loop_update_rotational(struct loop_device *lo)
> @@ -1127,12 +1184,23 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
>             !file->f_op->write_iter)
>                 lo->lo_flags |= LO_FLAGS_READ_ONLY;
>
> -       error = loop_prepare_queue(lo);
> -       if (error)
> +       lo->workqueue = alloc_workqueue("loop%d",
> +                                       WQ_UNBOUND | WQ_FREEZABLE,
> +                                       0,
> +                                       lo->lo_number);
> +       if (!lo->workqueue) {
> +               error = -ENOMEM;
>                 goto out_unlock;
> +       }
>
>         set_disk_ro(lo->lo_disk, (lo->lo_flags & LO_FLAGS_READ_ONLY) != 0);
>
> +       INIT_WORK(&lo->rootcg_work, loop_rootcg_workfn);
> +       INIT_LIST_HEAD(&lo->rootcg_cmd_list);
> +       INIT_LIST_HEAD(&lo->idle_worker_list);
> +       lo->worker_tree = RB_ROOT;
> +       timer_setup(&lo->timer, loop_free_idle_workers,
> +               TIMER_DEFERRABLE);
>         lo->use_dio = lo->lo_flags & LO_FLAGS_DIRECT_IO;
>         lo->lo_device = bdev;
>         lo->lo_backing_file = file;
> @@ -1200,6 +1268,7 @@ static int __loop_clr_fd(struct loop_device *lo, bool release)
>         int err = 0;
>         bool partscan = false;
>         int lo_number;
> +       struct loop_worker *pos, *worker;
>
>         mutex_lock(&lo->lo_mutex);
>         if (WARN_ON_ONCE(lo->lo_state != Lo_rundown)) {
> @@ -1219,6 +1288,18 @@ static int __loop_clr_fd(struct loop_device *lo, bool release)
>         /* freeze request queue during the transition */
>         blk_mq_freeze_queue(lo->lo_queue);
>
> +       destroy_workqueue(lo->workqueue);
> +       spin_lock_irq(&lo->lo_work_lock);
> +       list_for_each_entry_safe(worker, pos, &lo->idle_worker_list,
> +                               idle_list) {
> +               list_del(&worker->idle_list);
> +               rb_erase(&worker->rb_node, &lo->worker_tree);
> +               css_put(worker->css);
> +               kfree(worker);
> +       }
> +       spin_unlock_irq(&lo->lo_work_lock);
> +       del_timer_sync(&lo->timer);
> +
>         spin_lock_irq(&lo->lo_lock);
>         lo->lo_backing_file = NULL;
>         spin_unlock_irq(&lo->lo_lock);
> @@ -1255,7 +1336,6 @@ static int __loop_clr_fd(struct loop_device *lo, bool release)
>
>         partscan = lo->lo_flags & LO_FLAGS_PARTSCAN && bdev;
>         lo_number = lo->lo_number;
> -       loop_unprepare_queue(lo);
>  out_unlock:
>         mutex_unlock(&lo->lo_mutex);
>         if (partscan) {
> @@ -2026,7 +2106,7 @@ static blk_status_t loop_queue_rq(struct blk_mq_hw_ctx *hctx,
>         } else
>  #endif
>                 cmd->css = NULL;
> -       kthread_queue_work(&lo->worker, &cmd->work);
> +       loop_queue_work(lo, cmd);
>
>         return BLK_STS_OK;
>  }
> @@ -2056,26 +2136,82 @@ static void loop_handle_cmd(struct loop_cmd *cmd)
>         }
>  }
>
> -static void loop_queue_work(struct kthread_work *work)
> +static void loop_set_timer(struct loop_device *lo)
> +{
> +       timer_reduce(&lo->timer, jiffies + LOOP_IDLE_WORKER_TIMEOUT);
> +}
> +
> +static void loop_process_work(struct loop_worker *worker,
> +                       struct list_head *cmd_list, struct loop_device *lo)
> +{
> +       int orig_flags = current->flags;
> +       struct loop_cmd *cmd;
> +
> +       current->flags |= PF_LOCAL_THROTTLE | PF_MEMALLOC_NOIO;
> +       spin_lock_irq(&lo->lo_work_lock);
> +       while (!list_empty(cmd_list)) {
> +               cmd = container_of(
> +                       cmd_list->next, struct loop_cmd, list_entry);
> +               list_del(cmd_list->next);
> +               spin_unlock_irq(&lo->lo_work_lock);
> +
> +               loop_handle_cmd(cmd);
> +               cond_resched();
> +
> +               spin_lock_irq(&lo->lo_work_lock);
> +       }
> +
> +       /*
> +        * We only add to the idle list if there are no pending cmds
> +        * *and* the worker will not run again which ensures that it
> +        * is safe to free any worker on the idle list
> +        */
> +       if (worker && !work_pending(&worker->work)) {
> +               worker->last_ran_at = jiffies;
> +               list_add_tail(&worker->idle_list, &lo->idle_worker_list);
> +               loop_set_timer(lo);
> +       }
> +       spin_unlock_irq(&lo->lo_work_lock);
> +       current->flags = orig_flags;
> +}
> +
> +static void loop_workfn(struct work_struct *work)
>  {
> -       struct loop_cmd *cmd =
> -               container_of(work, struct loop_cmd, work);
> +       struct loop_worker *worker =
> +               container_of(work, struct loop_worker, work);
> +       loop_process_work(worker, &worker->cmd_list, worker->lo);
> +}
>
> -       loop_handle_cmd(cmd);
> +static void loop_rootcg_workfn(struct work_struct *work)
> +{
> +       struct loop_device *lo =
> +               container_of(work, struct loop_device, rootcg_work);
> +       loop_process_work(NULL, &lo->rootcg_cmd_list, lo);
>  }
>
> -static int loop_init_request(struct blk_mq_tag_set *set, struct request *rq,
> -               unsigned int hctx_idx, unsigned int numa_node)
> +static void loop_free_idle_workers(struct timer_list *timer)
>  {
> -       struct loop_cmd *cmd = blk_mq_rq_to_pdu(rq);
> +       struct loop_device *lo = container_of(timer, struct loop_device, timer);
> +       struct loop_worker *pos, *worker;
>
> -       kthread_init_work(&cmd->work, loop_queue_work);
> -       return 0;
> +       spin_lock_irq(&lo->lo_work_lock);
> +       list_for_each_entry_safe(worker, pos, &lo->idle_worker_list,
> +                               idle_list) {
> +               if (time_is_after_jiffies(worker->last_ran_at +
> +                                               LOOP_IDLE_WORKER_TIMEOUT))
> +                       break;
> +               list_del(&worker->idle_list);
> +               rb_erase(&worker->rb_node, &lo->worker_tree);
> +               css_put(worker->css);
> +               kfree(worker);
> +       }
> +       if (!list_empty(&lo->idle_worker_list))
> +               loop_set_timer(lo);
> +       spin_unlock_irq(&lo->lo_work_lock);
>  }
>
>  static const struct blk_mq_ops loop_mq_ops = {
>         .queue_rq       = loop_queue_rq,
> -       .init_request   = loop_init_request,
>         .complete       = lo_complete_rq,
>  };
>
> @@ -2164,6 +2300,7 @@ static int loop_add(struct loop_device **l, int i)
>         mutex_init(&lo->lo_mutex);
>         lo->lo_number           = i;
>         spin_lock_init(&lo->lo_lock);
> +       spin_lock_init(&lo->lo_work_lock);
>         disk->major             = LOOP_MAJOR;
>         disk->first_minor       = i << part_shift;
>         disk->fops              = &lo_fops;
> diff --git a/drivers/block/loop.h b/drivers/block/loop.h
> index a3c04f310672..9289c1cd6374 100644
> --- a/drivers/block/loop.h
> +++ b/drivers/block/loop.h
> @@ -14,7 +14,6 @@
>  #include <linux/blk-mq.h>
>  #include <linux/spinlock.h>
>  #include <linux/mutex.h>
> -#include <linux/kthread.h>
>  #include <uapi/linux/loop.h>
>
>  /* Possible states of device */
> @@ -54,8 +53,13 @@ struct loop_device {
>
>         spinlock_t              lo_lock;
>         int                     lo_state;
> -       struct kthread_worker   worker;
> -       struct task_struct      *worker_task;
> +       spinlock_t              lo_work_lock;
> +       struct workqueue_struct *workqueue;
> +       struct work_struct      rootcg_work;
> +       struct list_head        rootcg_cmd_list;
> +       struct list_head        idle_worker_list;
> +       struct rb_root          worker_tree;
> +       struct timer_list       timer;
>         bool                    use_dio;
>         bool                    sysfs_inited;
>
> @@ -66,7 +70,7 @@ struct loop_device {
>  };
>
>  struct loop_cmd {
> -       struct kthread_work work;
> +       struct list_head list_entry;
>         bool use_aio; /* use AIO interface to handle I/O */
>         atomic_t ref; /* only for aio */
>         long ret;
> --
> 2.30.2
>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming Lei
