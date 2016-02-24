From: Haggai Eran <haggaie@mellanox.com>
Subject: Re: [PATCHv6 1/3] rdmacg: Added rdma cgroup controller
Date: Wed, 24 Feb 2016 15:13:30 +0200
Message-ID: <56CDAC7A.6030206@mellanox.com>
References: <1455966006-13774-1-git-send-email-pandit.parav@gmail.com>
 <1455966006-13774-2-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1; h=From:To:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=WLcbmRCPRZZGA1QcVSYEKCncvkNkb5j1ORHVUi6G4f4=;
 b=Qcy7rdHUi44ryFvcv9ibgXrcDdUXpg36nX0txCu9eca2ZNKt8WRbKjXwHDpr8HOudYlcnQmfj/o5/oPWluuBoGs3r4V7UsFb1IpDFw1wF/m3aMNecNSdAsBjwr36jbt6mCRlHIxo9qTk7ZtXH3YNe69VIhkMuyU6pjK+yl/B3Lk=
In-Reply-To: <1455966006-13774-2-git-send-email-pandit.parav@gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Parav Pandit <pandit.parav@gmail.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com
Cc: corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

Hi,

Overall I the patch looks good to me. I have a few comments below.

On 20/02/2016 13:00, Parav Pandit wrote:
> Resource pool is created/destroyed dynamically whenever
> charging/uncharging occurs respectively and whenever user
> configuration is done. Its a tradeoff of memory vs little more code
Its -> It's
> space that creates resource pool whenever necessary,
> instead of creating them during cgroup creation and device registration
> time.
> 
> Signed-off-by: Parav Pandit <pandit.parav@gmail.com>

> diff --git a/include/linux/cgroup_rdma.h b/include/linux/cgroup_rdma.h
> new file mode 100644
> index 0000000..b370733
> --- /dev/null
> +++ b/include/linux/cgroup_rdma.h

> +struct rdmacg_device {
> +	struct rdmacg_pool_info pool_info;
> +	struct list_head	rdmacg_list;
> +	struct list_head	rpool_head;
> +	spinlock_t		rpool_lock;	/* protects rsource pool list */
rsource -> resource

> +	char			*name;
> +};
> +
> +/* APIs for RDMA/IB stack to publish when a device wants to
> + * participate in resource accounting
> + */
> +int rdmacg_register_device(struct rdmacg_device *device);
> +void rdmacg_unregister_device(struct rdmacg_device *device);
> +
> +/* APIs for RDMA/IB stack to charge/uncharge pool specific resources */
> +int rdmacg_try_charge(struct rdma_cgroup **rdmacg,
> +		      struct rdmacg_device *device,
> +		      int resource_index,
> +		      int num);
> +void rdmacg_uncharge(struct rdma_cgroup *cg,
> +		     struct rdmacg_device *device,
> +		     int resource_index,
> +		     int num);
> +void rdmacg_query_limit(struct rdmacg_device *device,
> +			int *limits, int max_count);
You can drop the max_count parameter, and require the caller to
always provide pool_info->table_len items, couldn't you?

> +
> +#endif	/* CONFIG_CGROUP_RDMA */
> +#endif	/* _CGROUP_RDMA_H */
> diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
> index 0df0336a..d0e597c 100644
> --- a/include/linux/cgroup_subsys.h
> +++ b/include/linux/cgroup_subsys.h
> @@ -56,6 +56,10 @@ SUBSYS(hugetlb)
>  SUBSYS(pids)
>  #endif
>  
> +#if IS_ENABLED(CONFIG_CGROUP_RDMA)
> +SUBSYS(rdma)
> +#endif
> +
>  /*
>   * The following subsystems are not supported on the default hierarchy.
>   */
> diff --git a/init/Kconfig b/init/Kconfig
> index 2232080..1741b65 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1054,6 +1054,16 @@ config CGROUP_PIDS
>  	  since the PIDs limit only affects a process's ability to fork, not to
>  	  attach to a cgroup.
>  
> +config CGROUP_RDMA
> +	bool "RDMA controller"
> +	help
> +	  Provides enforcement of RDMA resources defined by IB stack.
> +	  It is fairly easy for consumers to exhaust RDMA resources, which
> +	  can result into resource unavailibility to other consumers.
unavailibility -> unavailability
> +	  RDMA controller is designed to stop this from happening.
> +	  Attaching processes with active RDMA resources to the cgroup
> +	  hierarchy is allowed even if can cross the hierarchy's limit.
> +
>  config CGROUP_FREEZER
>  	bool "Freezer controller"
>  	help
> diff --git a/kernel/Makefile b/kernel/Makefile
> index baa55e5..501f5df 100644

> +/**
> + * uncharge_cg_resource - uncharge resource for rdma cgroup
> + * @cg: pointer to cg to uncharge and all parents in hierarchy
It only uncharges a single cg, right?
> + * @device: pointer to ib device
> + * @index: index of the resource to uncharge in cg (resource pool)
> + * @num: the number of rdma resource to uncharge
> + *
> + * It also frees the resource pool in the hierarchy for the resource pool
> + * which was created as part of charing operation.
charing -> charging
> + */
> +static void uncharge_cg_resource(struct rdma_cgroup *cg,
> +				 struct rdmacg_device *device,
> +				 int index, int num)
> +{
> +	struct rdmacg_resource_pool *rpool;
> +	struct rdmacg_pool_info *pool_info = &device->pool_info;
> +
> +	spin_lock(&cg->rpool_list_lock);
> +	rpool = find_cg_rpool_locked(cg, device);
Is it possible for rpool to be NULL?

> +
> +	/*
> +	 * A negative count (or overflow) is invalid,
> +	 * it indicates a bug in the rdma controller.
> +	 */
> +	rpool->resources[index].usage -= num;
> +
> +	WARN_ON_ONCE(rpool->resources[index].usage < 0);
> +	rpool->refcnt--;
> +	if (rpool->refcnt == 0 && rpool->num_max_cnt == pool_info->table_len) {
> +		/*
> +		 * No user of the rpool and all entries are set to max, so
> +		 * safe to delete this rpool.
> +		 */
> +		list_del(&rpool->cg_list);
> +		spin_unlock(&cg->rpool_list_lock);
> +
> +		free_cg_rpool(rpool);
> +		return;
> +	}
> +	spin_unlock(&cg->rpool_list_lock);
> +}

> +/**
> + * charge_cg_resource - charge resource for rdma cgroup
> + * @cg: pointer to cg to charge
> + * @device: pointer to rdmacg device
> + * @index: index of the resource to charge in cg (resource pool)
> + * @num: the number of rdma resource to charge
> + */
> +static int charge_cg_resource(struct rdma_cgroup *cg,
> +			      struct rdmacg_device *device,
> +			      int index, int num)
> +{
> +	struct rdmacg_resource_pool *rpool;
> +	s64 new;
> +	int ret = 0;
> +
> +retry:
> +	spin_lock(&cg->rpool_list_lock);
> +	rpool = find_cg_rpool_locked(cg, device);
> +	if (!rpool) {
> +		spin_unlock(&cg->rpool_list_lock);
> +		ret = alloc_cg_rpool(cg, device);
> +		if (ret)
> +			goto err;
> +		else
> +			goto retry;
Instead of retrying after allocation of a new rpool, why not just return the
newly allocated rpool (or the existing one) from alloc_cg_rpool?

> +	}
> +	new = num + rpool->resources[index].usage;
> +	if (new > rpool->resources[index].max) {
> +		ret = -EAGAIN;
> +	} else {
> +		rpool->refcnt++;
> +		rpool->resources[index].usage = new;
> +	}
> +	spin_unlock(&cg->rpool_list_lock);
> +err:
> +	return ret;
> +}

> +static ssize_t rdmacg_resource_set_max(struct kernfs_open_file *of,
> +				       char *buf, size_t nbytes, loff_t off)
> +{
> +	struct rdma_cgroup *cg = css_rdmacg(of_css(of));
> +	const char *dev_name;
> +	struct rdmacg_resource_pool *rpool;
> +	struct rdmacg_device *device;
> +	char *options = strstrip(buf);
> +	struct rdmacg_pool_info *pool_info;
> +	u64 enables = 0;
This limits the number of resources to 64. Sounds fine to me, but I think 
there should be a check somewhere (maybe in rdmacg_register_device()?) to
make sure someone doesn't pass too many resources.
 
> +	int *new_limits;
> +	int i = 0, ret = 0;
> +
> +	/* extract the device name first */
> +	dev_name = strsep(&options, " ");
> +	if (!dev_name) {
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
> +	/* acquire lock to synchronize with hot plug devices */
> +	mutex_lock(&dev_mutex);
> +
> +	device = rdmacg_get_device_locked(dev_name);
> +	if (!device) {
> +		ret = -ENODEV;
> +		goto parse_err;
> +	}
> +
> +	pool_info = &device->pool_info;
> +
> +	new_limits = kcalloc(pool_info->table_len, sizeof(int), GFP_KERNEL);
> +	if (!new_limits) {
> +		ret = -ENOMEM;
> +		goto parse_err;
> +	}
> +
> +	ret = rdmacg_parse_limits(options, pool_info, new_limits, &enables);
> +	if (ret)
> +		goto opt_err;
> +
> +retry:
> +	spin_lock(&cg->rpool_list_lock);
> +	rpool = find_cg_rpool_locked(cg, device);
> +	if (!rpool) {
> +		spin_unlock(&cg->rpool_list_lock);
> +		ret = alloc_cg_rpool(cg, device);
> +		if (ret)
> +			goto opt_err;
> +		else
> +			goto retry;
You can avoid the retry here too. Perhaps this can go into a function.

> +	}
> +
> +	/* now set the new limits of the rpool */
> +	while (enables) {
> +		/* if user set the limit, enables bit is set */
> +		if (enables & BIT(i)) {
> +			enables &= ~BIT(i);
> +			set_resource_limit(rpool, i, new_limits[i]);
> +		}
> +		i++;
> +	}
> +	if (rpool->refcnt == 0 &&
> +	    rpool->num_max_cnt == pool_info->table_len) {
> +		/*
> +		 * No user of the rpool and all entries are
> +		 * set to max, so safe to delete this rpool.
> +		 */
> +		list_del(&rpool->cg_list);
> +		spin_unlock(&cg->rpool_list_lock);
> +		free_cg_rpool(rpool);
> +	} else {
> +		spin_unlock(&cg->rpool_list_lock);
> +	}
You should consider putting this piece of code in a function (the
check of the reference counts and release of the rpool).

> +
> +opt_err:
> +	kfree(new_limits);
> +parse_err:
> +	mutex_unlock(&dev_mutex);
> +err:
> +	return ret ?: nbytes;
> +}
> +

> +
> +static int print_rpool_values(struct seq_file *sf,
This can return void.

> +			      struct rdmacg_pool_info *pool_info,
> +			      u32 *value_tbl)
> +{
> +	int i;
> +
> +	for (i = 0; i < pool_info->table_len; i++) {
> +		seq_puts(sf, pool_info->resource_name_table[i]);
> +		seq_putc(sf, '=');
> +		if (value_tbl[i] == S32_MAX)
> +			seq_puts(sf, RDMACG_MAX_STR);
> +		else
> +			seq_printf(sf, "%d", value_tbl[i]);
> +		seq_putc(sf, ' ');
> +	}
> +	return 0;
> +}
> +

Thanks,
Haggai
