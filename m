From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv10 1/3] rdmacg: Added rdma cgroup controller
Date: Mon, 4 Apr 2016 15:36:40 -0400
Message-ID: <20160404193640.GA7822@mtj.duckdns.org>
References: <1458850962-16057-1-git-send-email-pandit.parav@gmail.com>
 <1458850962-16057-2-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3XQePzNxyLMYSuBKZ+Grp/sqUIMNJK13x39MpkAJd20=;
        b=NgvifbbePkmdaJxmKuK/s7ZMhUTlbQ3ZFO1Rm4xR7BRBtdJyZQehzkLX+sMrjIAudv
         y/zp3t4Z8zzdFRlUkpjT6dMaslWfk/Pntvph4t+kBCnOLoXm520XTKRZ9zD6go1K/478
         XVEzRaSKLfynjMtsW0cjnCxpGp0HiLU/vkd5Fz5vDahEP4kLpdQXa80BWezsigaGRStK
         1BPK/gYDndB+ctpdc8IDKiT8e3wd9tPsC4Q/tbHuoSrJJUc6YIAW8PW3bSVvkGN8NxgP
         JYaAleMrnEaSpKUecwM6YLLJ+5WRzOMWg3r9UrpVQFwC6wz78Nejficcsf/krbbraHnW
         GgpA==
Content-Disposition: inline
In-Reply-To: <1458850962-16057-2-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Parav.

Sorry about the delay.

> +struct rdma_cgroup {
> +	struct cgroup_subsys_state	css;
> +
> +	/* protects resource pool list */
> +	spinlock_t			rpool_list_lock;

Is this lock still being used?

> +	/*
> +	 * head to keep track of all resource pools
> +	 * that belongs to this cgroup.
> +	 */
> +	struct list_head		rpool_head;
> +};
> +
> +struct rdmacg_pool_info {
> +	const char	**resource_name_table;
> +	int		table_len;

It's a bit bothering that resource type defs are outside the
controller in a way the controller can't know and assumed to have the
same type and range.  Architecting kernel code so that allow building
modules separately can modify behaviors usually isn't a priority and
styling things like this makes implementing specific one-off behaviors
cumbersome.

It now looks okay but let's say in the future someone wants to use a
different type and/or ranges for one of the resources, given the above
framework, that person is most likely to blow up pool_info - first
with types and min, max values and maybe later with callback handlers
and so on, when the only thing which would have been necessary is an
one-off handling of that specific setting in the interface functions.

Making things modular comes at the cost of complexity and ad-hoc
flexiblity.  There are cases where such overhead is warranted but as I
mentioned before, I don't think this is one of them.  Please look back
on how this patchset developed.  It has been a continuous process of
cutting down complexities which didn't need to be there which is the
opposite of what we usually want to do - buliding up sophiscation and
complexity as necessary from something simple.  Please cut down this
part too.

> +};
> +
> +struct rdmacg_device {
> +	struct rdmacg_pool_info pool_info;
> +	struct list_head	rdmacg_list;
> +	struct list_head	rpool_head;
> +	/* protects resource pool list */
> +	spinlock_t		rpool_lock;

Does this still need to be a separate lock?

> +#define RDMACG_MAX_STR "max"
> +
> +static DEFINE_MUTEX(dev_mutex);

Can you please prefix the above with rdmacg?

> +static LIST_HEAD(dev_list_head);

Ditto, how about rdmacg_dev_list?

> +/*
> + * resource pool object which represents per cgroup, per device
> + * resources. There are multiple instance of this object per cgroup,
                                            ^s
> + * therefore it cannot be embedded within rdma_cgroup structure. It
> + * is maintained as list.
> + */
> +struct rdmacg_resource_pool {
> +	struct list_head	cg_list;
> +	struct list_head	dev_list;

Isn't it more conventional to use OBJ_list or OBJs for the head and
_node or _link for the members?

> +static int
> +alloc_cg_rpool(struct rdma_cgroup *cg, struct rdmacg_device *device)
> +{
> +	struct rdmacg_resource_pool *rpool, *other_rpool;
> +	struct rdmacg_pool_info *pool_info = &device->pool_info;
> +	int ret;
> +
> +	rpool = kzalloc(sizeof(*rpool), GFP_KERNEL);
> +	if (!rpool) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +	rpool->resources = kcalloc(pool_info->table_len,
> +				   sizeof(*rpool->resources),
> +				   GFP_KERNEL);
> +	if (!rpool->resources) {
> +		ret = -ENOMEM;
> +		goto alloc_err;
> +	}
> +
> +	rpool->device = device;
> +	INIT_LIST_HEAD(&rpool->cg_list);
> +	INIT_LIST_HEAD(&rpool->dev_list);
> +	spin_lock_init(&device->rpool_lock);
> +	set_all_resource_max_limit(rpool);
> +
> +	spin_lock(&rpool_list_lock);
> +
> +	other_rpool = find_cg_rpool_locked(cg, device);
> +
> +	/*
> +	 * if other task added resource pool for this device for this cgroup
> +	 * than free up which was recently created and use the one we found.
> +	 */

* It's usually a good idea to have hierarchical objects to be created
  all the way to the root when a leaf node is requested and link
  parent at each level.  That way, when a descendant object is looked
  up, the caller can always deref its ->parent pointer till it reaches
  the top.

* Unless it's a very hot path, using a mutex which protects creation
  of new nodes is usually simpler than doing alloc -> lock ->
  try-insert.  The concurrency in the creation path doesn't matter and
  even if it mattered it isn't a good idea to bang on allocation path
  concurrently anyway.

> +static void
> +uncharge_cg_resource_locked(struct rdma_cgroup *cg,
> +			    struct rdmacg_device *device,
> +			    int index)
> +{
> +	struct rdmacg_resource_pool *rpool;
> +	struct rdmacg_pool_info *pool_info = &device->pool_info;
> +
> +	rpool = find_cg_rpool_locked(cg, device);

So, with each pool linking to its parent, instead of looking up at
each level, it can just follow ->parent recursively.

> +	/*
> +	 * A negative count (or overflow) is invalid,
> +	 * it indicates a bug in the rdma controller.
> +	 */
> +	WARN_ON_ONCE(rpool->resources[index].usage < 0);
> +	rpool->usage_sum--;

What guarantees that this count wouldn't overflow?  More on this
later.

> +/**
> + * rdmacg_uncharge_resource - hierarchically uncharge rdma resource count
> + * @device: pointer to rdmacg device
> + * @index: index of the resource to uncharge in cg in given resource pool
> + * @num: the number of rdma resource to uncharge
> + *
> + */
> +void rdmacg_uncharge(struct rdma_cgroup *cg,
> +		     struct rdmacg_device *device,
> +		     int index)
> +{
> +	struct rdma_cgroup *p;
> +
> +	spin_lock(&rpool_list_lock);
> +	for (p = cg; p; p = parent_rdmacg(p))
> +		uncharge_cg_resource_locked(p, device, index);
> +	spin_unlock(&rpool_list_lock);
> +
> +	css_put(&cg->css);

Hmm... what css ref is the above putting?

> +int rdmacg_try_charge(struct rdma_cgroup **rdmacg,
> +		      struct rdmacg_device *device,
> +		      int index)
> +{
...
> +	spin_lock(&rpool_list_lock);
> +	for (p = cg; p; p = parent_rdmacg(p)) {
> +retry:
> +		rpool = find_cg_rpool_locked(p, device);

Here, too, you can look up the leaf node once and walk up the
hierarhcy.  Maybe create a helper, say rdmacg_get_pool_and_lock(),
which looks up an existing node or creates all pools from leaf to root
and returns with the lock held?

...
> +err:
> +	spin_lock(&rpool_list_lock);
> +	for (q = cg; q != p; q = parent_rdmacg(q))
> +		uncharge_cg_resource_locked(q, device, index);

If some resources are not very plentiful and contended, dropping lock
before error handling like above could lead to spurious failures.  It
looks like the above is from trying to create pool at each level while
charging up.  Creating all necessary pools at the outset should make
the code simpler and more robust.

> +	spin_unlock(&rpool_list_lock);
> +	css_put(&cg->css);

Ditto, where is this from?

> +void rdmacg_query_limit(struct rdmacg_device *device, int *limits)
> +{
> +	struct rdma_cgroup *cg, *p;
> +	struct rdmacg_resource_pool *rpool;
> +	struct rdmacg_pool_info *pool_info;
> +	int i;
> +
> +	pool_info = &device->pool_info;
> +
> +	for (i = 0; i < pool_info->table_len; i++)
> +		limits[i] = S32_MAX;
> +
> +	cg = get_current_rdmacg();
> +	/*
> +	 * Check in hirerchy which pool get the least amount of
> +	 * resource limits.
> +	 */
> +	spin_lock(&rpool_list_lock);
> +	for (p = cg; p; p = parent_rdmacg(p)) {
> +		rpool = find_cg_rpool_locked(cg, device);

Ditto with lookup here.

> +static struct rdmacg_device *rdmacg_get_device_locked(const char *name)
> +{
> +	struct rdmacg_device *device;

lockdep_assert_held() would be nice.

> +	list_for_each_entry(device, &dev_list_head, rdmacg_list)
> +		if (!strcmp(name, device->name))
> +			return device;
> +
> +	return NULL;
> +}
> +
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

Hmm... except for new_limits allocation and alloc_cg_rpool()
invocation, both of which can be done at the head of the function,
nothing seems to require a mutex here.  If we move them to the head of
the function, can we get rid of dev_mutex entirely?

> +	ret = rdmacg_parse_limits(options, pool_info, new_limits, &enables);
> +	if (ret)
> +		goto opt_err;
> +
> +retry:
> +	spin_lock(&rpool_list_lock);
> +	rpool = find_cg_rpool_locked(cg, device);
> +	if (!rpool) {
> +		spin_unlock(&rpool_list_lock);
> +		ret = alloc_cg_rpool(cg, device);
> +		if (ret)
> +			goto opt_err;
> +		else
> +			goto retry;
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

Maybe we can use for_each_set_bit()?

> +	if (rpool->usage_sum == 0 &&
> +	    rpool->num_max_cnt == pool_info->table_len) {
> +		/*
> +		 * No user of the rpool and all entries are set to max, so
> +		 * safe to delete this rpool.
> +		 */
> +		list_del(&rpool->cg_list);
> +		spin_unlock(&rpool_list_lock);
> +
> +		free_cg_rpool(rpool);

Can't we just count the number of resources which either have !max
setting or !0 usage?

> +static u32 *get_cg_rpool_values(struct rdma_cgroup *cg,
> +				struct rdmacg_device *device,
> +				enum rdmacg_file_type sf_type,
> +				int count)
> +{
> +	struct rdmacg_resource_pool *rpool;
> +	u32 *value_tbl;
> +	int i, ret;
> +
> +	value_tbl = kcalloc(count, sizeof(u32), GFP_KERNEL);
> +	if (!value_tbl) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}

Do we need this type of interface?  Why not let the caller look up the
target pool and call this function with pool and resource index?

Thanks.

-- 
tejun
