From: Haggai Eran <haggaie@mellanox.com>
Subject: Re: [PATCH 5/7] devcg: device cgroup's extension for RDMA resource.
Date: Tue, 8 Sep 2015 11:36:05 +0300
Message-ID: <55EE9DF5.7030401@mellanox.com>
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
So what happens if a process creates a ucontext, forks, and then the
child creates and destroys a CQ? If I understand correctly, created
resources are always charged to the current process (the child), but
when it is destroyed the owner of the ucontext (the parent) will be
uncharged.

Since ucontexts are not meant to be used by multiple processes, I think
it would be okay to always charge the owner process (the one that
created the ucontext).

> +	dev_cg = task_devcgroup(ctx_task);
> +
> +	spin_lock(&ctx_task->rdma_res_counter->lock);
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

