From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv3 1/3] rdmacg: Added rdma cgroup controller.
Date: Sat, 30 Jan 2016 13:30:15 -0500
Message-ID: <20160130183015.GP32380@htj.duckdns.org>
References: <1454167387-31260-1-git-send-email-pandit.parav@gmail.com>
 <1454167387-31260-2-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=mEjJg2BiHIa7acMJ5kffQIqrFotxsG9vnMiazSh6xmA=;
        b=kfrGFy9TdkH2drCwYCx/o2ynNtNXbTP+wMsXWu5vygdAImA0eEj/DYcfixsE63KUiW
         uRsmL+xkn2/lGIgqTEGXbo2X6myH3fqweKakmtj96hhsKnAGDGamDaN42vlwGN7mq4V+
         pdA6c6sbJEg+QQVXTioPQ+YpBC1rgwD3YuLjdJZg7sCSVpWLc0ZqcIl0fNY6AL58A6F5
         QKOVUqy9F74Ois4wqmRplYIW5bm/xNMIqlcDzbB1uJQE2YyiQ17XN13scrtjDiSB8W6z
         1l0YD4Hx7m60M0zyjQ6RYrBW9eSDd583X51ysv4Usd4Dnx9ZZ4pOBAHq2ymjbz6/IQW+
         1FRQ==
Content-Disposition: inline
In-Reply-To: <1454167387-31260-2-git-send-email-pandit.parav@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com, corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

Hello,

On Sat, Jan 30, 2016 at 08:53:05PM +0530, Parav Pandit wrote:
> +#ifdef CONFIG_CGROUP_RDMA
> +#define RDMACG_MAX_RESOURCE_INDEX (64)

The list of resources are known at compile time.  Why is this separate
fixed number necessary?

> +struct match_token;

There's no circular dependency issue here.  Include the appropriate
header.

> +struct rdmacg_device;
> +
> +struct rdmacg_pool_info {
> +	struct match_token *resource_table;
> +	int resource_count;
> +};
> +
> +struct rdmacg_resource_pool_ops {
> +	struct rdmacg_pool_info*
> +		(*get_resource_pool_tokens)(struct rdmacg_device *);
> +};

Why does it need external op table?  The types of resources are gonna
be fixed at compile time.  The only thing necessary is each device
declaring which resources are to be used.

> +struct rdmacg_device {
> +	struct rdmacg_resource_pool_ops
> +				*rpool_ops[RDMACG_RESOURCE_POOL_TYPE_MAX];
> +	struct list_head        rdmacg_list;
> +	char                    *name;
> +};
> +
> +/* APIs for RDMA/IB stack to publish when a device wants to
> + * participate in resource accounting
> + */

Please read CodingStyle.

> +config CGROUP_RDMA
> +	bool "RDMA controller"
> +	help
> +	  Provides enforcement of RDMA resources at RDMA/IB verb level and
> +	  enforcement of any RDMA/IB capable hardware advertized resources.
                                                      ^^^^^^^^^?
> +	  Its fairly easy for applications to exhaust RDMA resources, which
          ^^^
> +	  can result into kernel consumers or other application consumers of
                     ^ in ^ just say "consumers"?
> +	  RDMA resources left with no resources. RDMA controller is designed
          ^ The sentence doesn't read well.
> +	  to stop this from happening.
> +	  Attaching existing processes with active RDMA resources to the cgroup
> +	  hierarchy will be allowed even if can cross the hierarchy's limit.
                                         ^^^^^?

> +#define RDMACG_USR_CMD_REMOVE "remove"

Why is this necessary?

> +/* resource tracker per resource for rdma cgroup */
> +struct cg_resource {
> +	int max;
> +	atomic_t usage;
> +};

rdmacg_resource?  Also, wouldn't it be better to use u64?

> +/**
> + * pool type indicating either it got created as part of default
> + * operation or user has configured the group.
> + * Depends on the creator of the pool, its decided to free up
> + * later or not.
> + */
> +enum rpool_creator {
> +	RDMACG_RPOOL_CREATOR_DEFAULT,
> +	RDMACG_RPOOL_CREATOR_USR,
> +};

Why does this matter?

> +/**
> + * resource pool object which represents, per cgroup, per device,
> + * per resource pool_type resources. There are multiple instance
> + * of this object per cgroup, therefore it cannot be embedded within
> + * rdma_cgroup structure. Its maintained as list.
> + */
> +struct cg_resource_pool {
> +	struct list_head cg_list;
> +	struct rdmacg_device *device;
> +	enum rdmacg_resource_pool_type type;
> +
> +	struct cg_resource *resources;
> +
> +	atomic_t refcnt;	/* count active user tasks of this pool */
> +	atomic_t creator;	/* user created or default type */

Why the hell would creator need to be an atomic?  You're just using
set and read on the field.  What's going on?

> +static struct rdmacg_resource_pool_ops*
> +	get_pool_ops(struct rdmacg_device *device,
> +		     enum rdmacg_resource_pool_type pool_type)

static struct rdmacg_resource_pool_ops *
get_pool_ops(...)

> +{
> +	return device->rpool_ops[pool_type];
> +}
...
> +static void _dealloc_cg_rpool(struct rdma_cgroup *cg,
> +			      struct cg_resource_pool *rpool)
> +{

Ugh... please refrain from single underscore prefixed names.  It's
best to give it a proper name.  e.g. if the function assumes lock is
grabbed by the user use _locked postfix and so on.

> +	spin_lock(&cg->cg_list_lock);
> +
> +	/* if its started getting used by other task, before we take the
> +	 * spin lock, then skip freeing it.
> +	 */

Again, CodingStyle.

> +static void dealloc_cg_rpool(struct rdma_cgroup *cg,
> +			     struct cg_resource_pool *rpool)
> +{
> +	/* Don't free the resource pool which is created by the
> +	 * user, otherwise we lose the configured limits. We don't
> +	 * gain much either by splitting storage of limit and usage.
> +	 * So keep it around until user deletes the limits.
> +	 */
> +	if (atomic_read(&rpool->creator) == RDMACG_RPOOL_CREATOR_DEFAULT)
> +		_dealloc_cg_rpool(cg, rpool);
> +}

The config is tied to the device.  If the device goes away, all its
pools go away.  If the device stays, all configs stay.

> +static struct cg_resource_pool*
> +	find_cg_rpool(struct rdma_cgroup *cg,
> +		      struct rdmacg_device *device,
> +		      enum rdmacg_resource_pool_type type)
> +
> +{
> +	struct cg_resource_pool *pool;
> +

lockdep_assert_held(...)

> +	list_for_each_entry(pool, &cg->rpool_head, cg_list)
> +		if (pool->device == device && pool->type == type)
> +			return pool;
> +
> +	return NULL;
> +}
> +
> +static struct cg_resource_pool*
> +	_get_cg_rpool(struct rdma_cgroup *cg,
> +		      struct rdmacg_device *device,
> +		      enum rdmacg_resource_pool_type type)
> +{
> +	struct cg_resource_pool *rpool;
> +
> +	spin_lock(&cg->cg_list_lock);
> +	rpool = find_cg_rpool(cg, device, type);
> +	if (rpool)
> +		goto found;
> +found:

That's one extremely silly way to write noop.

> +	spin_unlock(&cg->cg_list_lock);
> +	return rpool;
> +}

This function doesn't make any sense.  Push locking to the caller and
use find_cg_rpool().

> +static struct cg_resource_pool*
> +	get_cg_rpool(struct rdma_cgroup *cg,
> +		     struct rdmacg_device *device,
> +		     enum rdmacg_resource_pool_type type)
> +{
> +	struct cg_resource_pool *rpool, *other_rpool;
> +	struct rdmacg_pool_info *pool_info;
> +	struct rdmacg_resource_pool_ops *ops;
> +	int ret = 0;
> +
> +	spin_lock(&cg->cg_list_lock);
> +	rpool = find_cg_rpool(cg, device, type);
> +	if (rpool) {
> +		atomic_inc(&rpool->refcnt);
> +		spin_unlock(&cg->cg_list_lock);
> +		return rpool;
> +	}

Why does it need refcnting?  Things stay if the device is there.
Things go away if the device goes away.  No?  Can device go away while
resources are allocated?

> +	spin_unlock(&cg->cg_list_lock);
> +
> +	/* ops cannot be NULL at this stage, as caller made to charge/get
> +	 * the resource pool being aware of such need and invoking with
> +	 * because it has setup resource pool ops.
> +	 */
> +	ops = get_pool_ops(device, type);
> +	pool_info = ops->get_resource_pool_tokens(device);
> +	if (!pool_info) {
> +		ret = -EINVAL;
> +		goto err;
> +	}

Please just do

enum {
	RDMA_RES_VERB_A,
	RDMA_RES_VERB_B,
	...
	RDMA_RES_VERB_MAX,

	RDMA_RES_HW_BASE = RDMA_RES_VERB_MAX,
	RDMA_RES_HW_A = RDMA_RES_HW_BASE,
	RDMA_RES_HW_B,
	...
	RDMA_RES_HW_MAX,
};

static const char rdma_res_name[] = {
	[RDMA_RES_VERB_A]	= "...",
	...
};

And then let each device specify bitmap of resources that it supports
on registration.

> +	if (pool_info->resource_count == 0 ||
> +	    pool_info->resource_count > RDMACG_MAX_RESOURCE_INDEX) {
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
> +	/* allocate resource pool */
> +	rpool = alloc_cg_rpool(cg, device, pool_info->resource_count, type);
> +	if (IS_ERR_OR_NULL(rpool))
> +		return rpool;
> +
> +	/* cgroup lock is held to synchronize with multiple
> +	 * resource pool creation in parallel.
> +	 */
> +	spin_lock(&cg->cg_list_lock);
> +	other_rpool = find_cg_rpool(cg, device, type);
> +	/* if other task added resource pool for this device for this cgroup
> +	 * free up which was recently created and use the one we found.
> +	 */
> +	if (other_rpool) {
> +		atomic_inc(&other_rpool->refcnt);
> +		spin_unlock(&cg->cg_list_lock);
> +		_free_cg_rpool(rpool);
> +		return other_rpool;
> +	}
> +
> +	atomic_inc(&rpool->refcnt);
> +	list_add_tail(&rpool->cg_list, &cg->rpool_head);
> +
> +	spin_unlock(&cg->cg_list_lock);
> +	return rpool;
> +
> +err:
> +	spin_unlock(&cg->cg_list_lock);
> +	return ERR_PTR(ret);
> +}

You're grabbing the lock anyway.  Why bother with atomics at all?
Just grab the lock on entry, look up the entry and then do normal
integer ops.

The whole thing is still way more complex than it needs to be.  Please
slim it down.  It really shouldn't take half as much code.  Keep it
simple, please.

Thanks.

-- 
tejun
