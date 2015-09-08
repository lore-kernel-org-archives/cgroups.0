From: Haggai Eran <haggaie@mellanox.com>
Subject: Re: [PATCH 5/7] devcg: device cgroup's extension for RDMA resource.
Date: Tue, 8 Sep 2015 11:22:56 +0300
Message-ID: <55EE9AE0.5030508@mellanox.com>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
 <1441658303-18081-6-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1441658303-18081-6-git-send-email-pandit.parav@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Parav Pandit <pandit.parav@gmail.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com
Cc: corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On 07/09/2015 23:38, Parav Pandit wrote:
> +/* RDMA resources from device cgroup perspective */
> +enum devcgroup_rdma_rt {
> +	DEVCG_RDMA_RES_TYPE_UCTX,
> +	DEVCG_RDMA_RES_TYPE_CQ,
> +	DEVCG_RDMA_RES_TYPE_PD,
> +	DEVCG_RDMA_RES_TYPE_AH,
> +	DEVCG_RDMA_RES_TYPE_MR,
> +	DEVCG_RDMA_RES_TYPE_MW,
I didn't see memory windows in dev_cgroup_files in patch 3. Is it used?
> +	DEVCG_RDMA_RES_TYPE_SRQ,
> +	DEVCG_RDMA_RES_TYPE_QP,
> +	DEVCG_RDMA_RES_TYPE_FLOW,
> +	DEVCG_RDMA_RES_TYPE_MAX,
> +};

> +struct devcgroup_rdma_tracker {
> +	int limit;
> +	atomic_t usage;
> +	int failcnt;
> +};
Have you considered using struct res_counter?

> + * RDMA resource limits are hierarchical, so the highest configured limit of
> + * the hierarchy is enforced. Allowing resource limit configuration to default
> + * cgroup allows fair share to kernel space ULPs as well.
In what way is the highest configured limit of the hierarchy enforced? I
would expect all the limits along the hierarchy to be enforced.

> +int devcgroup_rdma_get_max_resource(struct seq_file *sf, void *v)
> +{
> +	struct dev_cgroup *dev_cg = css_to_devcgroup(seq_css(sf));
> +	int type = seq_cft(sf)->private;
> +	u32 usage;
> +
> +	if (dev_cg->rdma.tracker[type].limit ==	DEVCG_RDMA_MAX_RESOURCES) {
> +		seq_printf(sf, "%s\n", DEVCG_RDMA_MAX_RESOURCE_STR);
> +	} else {
> +		usage = dev_cg->rdma.tracker[type].limit;
If this is the resource limit, don't name it 'usage'.

> +		seq_printf(sf, "%u\n", usage);
> +	}
> +	return 0;
> +}

> +int devcgroup_rdma_get_max_resource(struct seq_file *sf, void *v)
> +{
> +	struct dev_cgroup *dev_cg = css_to_devcgroup(seq_css(sf));
> +	int type = seq_cft(sf)->private;
> +	u32 usage;
> +
> +	if (dev_cg->rdma.tracker[type].limit ==	DEVCG_RDMA_MAX_RESOURCES) {
> +		seq_printf(sf, "%s\n", DEVCG_RDMA_MAX_RESOURCE_STR);
I'm not sure hiding the actual number is good, especially in the
show_usage case.

> +	} else {
> +		usage = dev_cg->rdma.tracker[type].limit;
> +		seq_printf(sf, "%u\n", usage);
> +	}
> +	return 0;
> +}

> +void devcgroup_rdma_uncharge_resource(struct ib_ucontext *ucontext,
> +				      enum devcgroup_rdma_rt type, int num)
> +{
> +	struct dev_cgroup *dev_cg, *p;
> +	struct task_struct *ctx_task;
> +
> +	if (!num)
> +		return;
> +
> +	/* get cgroup of ib_ucontext it belong to, to uncharge
> +	 * so that when its called from any worker tasks or any
> +	 * other tasks to which this resource doesn't belong to,
> +	 * it can be uncharged correctly.
> +	 */
> +	if (ucontext)
> +		ctx_task = get_pid_task(ucontext->tgid, PIDTYPE_PID);
> +	else
> +		ctx_task = current;
> +	dev_cg = task_devcgroup(ctx_task);
> +
> +	spin_lock(&ctx_task->rdma_res_counter->lock);
Don't you need an rcu read lock and rcu_dereference to access
rdma_res_counter?

> +	ctx_task->rdma_res_counter->usage[type] -= num;
> +
> +	for (p = dev_cg; p; p = parent_devcgroup(p))
> +		uncharge_resource(p, type, num);
> +
> +	spin_unlock(&ctx_task->rdma_res_counter->lock);
> +
> +	if (type == DEVCG_RDMA_RES_TYPE_UCTX)
> +		rdma_free_res_counter(ctx_task);
> +}
> +EXPORT_SYMBOL(devcgroup_rdma_uncharge_resource);

> +int devcgroup_rdma_try_charge_resource(enum devcgroup_rdma_rt type, int num)
> +{
> +	struct dev_cgroup *dev_cg = task_devcgroup(current);
> +	struct task_rdma_res_counter *res_cnt = current->rdma_res_counter;
> +	int status;
> +
> +	if (!res_cnt) {
> +		res_cnt = kzalloc(sizeof(*res_cnt), GFP_KERNEL);
> +		if (!res_cnt)
> +			return -ENOMEM;
> +
> +		spin_lock_init(&res_cnt->lock);
> +		rcu_assign_pointer(current->rdma_res_counter, res_cnt);
Don't you need the task lock to update rdma_res_counter here?

> +	}
> +
> +	/* synchronize with migration task by taking lock, to avoid
> +	 * race condition of performing cgroup resource migration
> +	 * in non atomic way with this task, which can leads to leaked
> +	 * resources in older cgroup.
> +	 */
> +	spin_lock(&res_cnt->lock);
> +	status = try_charge_resource(dev_cg, type, num);
> +	if (status)
> +		goto busy;
> +
> +	/* single task updating its rdma resource usage, so atomic is
> +	 * not required.
> +	 */
> +	current->rdma_res_counter->usage[type] += num;
> +
> +busy:
> +	spin_unlock(&res_cnt->lock);
> +	return status;
> +}
> +EXPORT_SYMBOL(devcgroup_rdma_try_charge_resource);

Regards,
Haggai
