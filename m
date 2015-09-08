From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCH 5/7] devcg: device cgroup's extension for RDMA resource.
Date: Tue, 8 Sep 2015 15:48:39 +0530
Message-ID: <CAG53R5V9ydty2--amXFFDiDd01gGYE0Oh5jV0OhysQmfhWHDPQ@mail.gmail.com>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
	<1441658303-18081-6-git-send-email-pandit.parav@gmail.com>
	<55EE9AE0.5030508@mellanox.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=G5l+BJvQfRj24XN8FCFNe5UtyQ2t74tlL/uU4l2Eqwk=;
        b=pF6wEqbitYm1+QaXH1Btrm6/GtX+2W1D0E7T+TqChFxY3Q5NmoASJrjJDYzY8X0Wat
         0ZsLATWgFb1LB0oO7X3pj4hUK29EHXJ4U5VFrUVVjdSb+rKzuenQCvXc2vS2zrwODU8j
         ZqdRnE8ziNPoBu5RlkvkUjfhC7P0svuMmr0K7hNx39GcNptyrewooJX62ep01qqkRpmr
         s3EYL5tMvBDZxOQcXCZT4ij2NFa72aGoFMZKlvfJc5iFveGR/znbPnCqGCRWhO3Bz+5I
         fMPeMGTDClYPRcxDrK0COCsd1W72gi6waaHpZ3q7x01dGOqwSC3hKxr2MRcVXqlrxFLi
         e7zg==
In-Reply-To: <55EE9AE0.5030508@mellanox.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haggai Eran <haggaie@mellanox.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On Tue, Sep 8, 2015 at 1:52 PM, Haggai Eran <haggaie@mellanox.com> wrote:
> On 07/09/2015 23:38, Parav Pandit wrote:
>> +/* RDMA resources from device cgroup perspective */
>> +enum devcgroup_rdma_rt {
>> +     DEVCG_RDMA_RES_TYPE_UCTX,
>> +     DEVCG_RDMA_RES_TYPE_CQ,
>> +     DEVCG_RDMA_RES_TYPE_PD,
>> +     DEVCG_RDMA_RES_TYPE_AH,
>> +     DEVCG_RDMA_RES_TYPE_MR,
>> +     DEVCG_RDMA_RES_TYPE_MW,
> I didn't see memory windows in dev_cgroup_files in patch 3. Is it used?

ib_uverbs_dereg_mr() needs a fix in my patch for MW and alloc_mw()
also needs to use it.
I will fix it.

>> +     DEVCG_RDMA_RES_TYPE_SRQ,
>> +     DEVCG_RDMA_RES_TYPE_QP,
>> +     DEVCG_RDMA_RES_TYPE_FLOW,
>> +     DEVCG_RDMA_RES_TYPE_MAX,
>> +};
>
>> +struct devcgroup_rdma_tracker {
>> +     int limit;
>> +     atomic_t usage;
>> +     int failcnt;
>> +};
> Have you considered using struct res_counter?

No. I will look into the structure and see if it fits or not.

>
>> + * RDMA resource limits are hierarchical, so the highest configured limit of
>> + * the hierarchy is enforced. Allowing resource limit configuration to default
>> + * cgroup allows fair share to kernel space ULPs as well.
> In what way is the highest configured limit of the hierarchy enforced? I
> would expect all the limits along the hierarchy to be enforced.
>
In  hierarchy, of say 3 cgroups, the smallest limit of the cgroup is applied.

Lets take example to clarify.
Say cg_A, cg_B, cg_C
Role              name                           limit
Parent           cg_A                           100
Child_level1  cg_B (child of cg_A)    20
Child_level2: cg_C (child of cg_B)    50

If the process allocating rdma resource belongs to cg_C, limit lowest
limit in the hierarchy is applied during charge() stage.
If cg_A limit happens to be 10, since 10 is lowest, its limit would be
applicable as you expected.
this is similar to newly added PID subsystem in functionality.

>> +int devcgroup_rdma_get_max_resource(struct seq_file *sf, void *v)
>> +{
>> +     struct dev_cgroup *dev_cg = css_to_devcgroup(seq_css(sf));
>> +     int type = seq_cft(sf)->private;
>> +     u32 usage;
>> +
>> +     if (dev_cg->rdma.tracker[type].limit == DEVCG_RDMA_MAX_RESOURCES) {
>> +             seq_printf(sf, "%s\n", DEVCG_RDMA_MAX_RESOURCE_STR);
>> +     } else {
>> +             usage = dev_cg->rdma.tracker[type].limit;
> If this is the resource limit, don't name it 'usage'.
>
o.k. This is typo mistake from usage show function I made. I will change it.

>> +             seq_printf(sf, "%u\n", usage);
>> +     }
>> +     return 0;
>> +}
>
>> +int devcgroup_rdma_get_max_resource(struct seq_file *sf, void *v)
>> +{
>> +     struct dev_cgroup *dev_cg = css_to_devcgroup(seq_css(sf));
>> +     int type = seq_cft(sf)->private;
>> +     u32 usage;
>> +
>> +     if (dev_cg->rdma.tracker[type].limit == DEVCG_RDMA_MAX_RESOURCES) {
>> +             seq_printf(sf, "%s\n", DEVCG_RDMA_MAX_RESOURCE_STR);
> I'm not sure hiding the actual number is good, especially in the
> show_usage case.

This is similar to following other controller same as newly added PID
subsystem in showing max limit.

>
>> +     } else {
>> +             usage = dev_cg->rdma.tracker[type].limit;
>> +             seq_printf(sf, "%u\n", usage);
>> +     }
>> +     return 0;
>> +}
>
>> +void devcgroup_rdma_uncharge_resource(struct ib_ucontext *ucontext,
>> +                                   enum devcgroup_rdma_rt type, int num)
>> +{
>> +     struct dev_cgroup *dev_cg, *p;
>> +     struct task_struct *ctx_task;
>> +
>> +     if (!num)
>> +             return;
>> +
>> +     /* get cgroup of ib_ucontext it belong to, to uncharge
>> +      * so that when its called from any worker tasks or any
>> +      * other tasks to which this resource doesn't belong to,
>> +      * it can be uncharged correctly.
>> +      */
>> +     if (ucontext)
>> +             ctx_task = get_pid_task(ucontext->tgid, PIDTYPE_PID);
>> +     else
>> +             ctx_task = current;
>> +     dev_cg = task_devcgroup(ctx_task);
>> +
>> +     spin_lock(&ctx_task->rdma_res_counter->lock);
> Don't you need an rcu read lock and rcu_dereference to access
> rdma_res_counter?

I believe, its not required because when uncharge() is happening, it
can happen only from 3 contexts.
(a) from the caller task context, who has made allocation call, so no
synchronizing needed.
(b) from the dealloc resource context, again this is from the same
task context which allocated, it so this is single threaded, no need
to syncronize.
(c) from the fput() context when process is terminated abruptly or as
part of differed cleanup, when this is happening there cannot be
allocator task anyway.

>
>> +     ctx_task->rdma_res_counter->usage[type] -= num;
>> +
>> +     for (p = dev_cg; p; p = parent_devcgroup(p))
>> +             uncharge_resource(p, type, num);
>> +
>> +     spin_unlock(&ctx_task->rdma_res_counter->lock);
>> +
>> +     if (type == DEVCG_RDMA_RES_TYPE_UCTX)
>> +             rdma_free_res_counter(ctx_task);
>> +}
>> +EXPORT_SYMBOL(devcgroup_rdma_uncharge_resource);
>
>> +int devcgroup_rdma_try_charge_resource(enum devcgroup_rdma_rt type, int num)
>> +{
>> +     struct dev_cgroup *dev_cg = task_devcgroup(current);
>> +     struct task_rdma_res_counter *res_cnt = current->rdma_res_counter;
>> +     int status;
>> +
>> +     if (!res_cnt) {
>> +             res_cnt = kzalloc(sizeof(*res_cnt), GFP_KERNEL);
>> +             if (!res_cnt)
>> +                     return -ENOMEM;
>> +
>> +             spin_lock_init(&res_cnt->lock);
>> +             rcu_assign_pointer(current->rdma_res_counter, res_cnt);
> Don't you need the task lock to update rdma_res_counter here?
>
No. this is the caller task allocating it, so its single threaded.
It needs to syncronize with migration thread which is reading counters
of all the processes, while they are getting allocated and freed.
Therefore rcu() is sufficient.

>> +     }
>> +
>> +     /* synchronize with migration task by taking lock, to avoid
>> +      * race condition of performing cgroup resource migration
>> +      * in non atomic way with this task, which can leads to leaked
>> +      * resources in older cgroup.
>> +      */
>> +     spin_lock(&res_cnt->lock);
>> +     status = try_charge_resource(dev_cg, type, num);
>> +     if (status)
>> +             goto busy;
>> +
>> +     /* single task updating its rdma resource usage, so atomic is
>> +      * not required.
>> +      */
>> +     current->rdma_res_counter->usage[type] += num;
>> +
>> +busy:
>> +     spin_unlock(&res_cnt->lock);
>> +     return status;
>> +}
>> +EXPORT_SYMBOL(devcgroup_rdma_try_charge_resource);
>
> Regards,
> Haggai
