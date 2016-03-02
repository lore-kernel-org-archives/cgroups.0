From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv9 1/3] rdmacg: Added rdma cgroup controller
Date: Wed, 2 Mar 2016 12:39:49 -0500
Message-ID: <20160302173949.GG29826@mtj.duckdns.org>
References: <1456859137-13646-1-git-send-email-pandit.parav@gmail.com>
 <1456859137-13646-2-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bTqV4V9ZsXgCjNOTEbSqz+QcWCiUFONXIW7gSzCUPEw=;
        b=UAY2X+Jv9CCMzVVkNeY79xCdCM6Op1GOi/zc3PxBR/ExF9zU/bAh+dItFk3syTs79g
         cRD9s1VqoE/C7LIKGE0WyMHK/XcFTN9diCmA5nXO+SIUSa50J9VCg6YAadOWxsYK+Sii
         XeI9OA134cvJMkoxzV3JPTMNgQIwwVfKMeq4uKgyvHfBjQfaTkrxyvD7r+75v3BIzqs4
         qKwiZ+CXWKQcpFua/G/lh/usNkTa9pTNd8utBXLZv1a/GmROi7z6BrvImEFW1vG5aa9W
         Z35PTxW/tA3fkhCKN5W2CGSDX6QSrefY+A2yna+sdum+wODJZI4jyK5Hme4YyULI3k6N
         wnxA==
Content-Disposition: inline
In-Reply-To: <1456859137-13646-2-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Wed, Mar 02, 2016 at 12:35:35AM +0530, Parav Pandit wrote:
> diff --git a/include/linux/cgroup_rdma.h b/include/linux/cgroup_rdma.h
> new file mode 100644
> index 0000000..2da3d6c
> --- /dev/null
> +++ b/include/linux/cgroup_rdma.h
> @@ -0,0 +1,50 @@
> +#ifndef _CGROUP_RDMA_H
> +#define _CGROUP_RDMA_H
> +
> +#include <linux/cgroup.h>
> +
> +#ifdef CONFIG_CGROUP_RDMA
> +
> +struct rdma_cgroup {
> +	struct cgroup_subsys_state	css;
> +
> +	spinlock_t rpool_list_lock;	/* protects resource pool list */
> +	struct list_head rpool_head;	/* head to keep track of all resource
> +					 * pools that belongs to this cgroup.
> +					 */

I think we usually don't tail wing these comments.

> +};
> +
> +struct rdmacg_pool_info {
> +	const char **resource_name_table;
> +	int table_len;

Align fields consistently?  I've said this multiple times now but
please make the available resources constant and document them in
Documentation/cgroup-v2.txt.

> +};
> +
> +struct rdmacg_device {
> +	struct rdmacg_pool_info pool_info;
> +	struct list_head	rdmacg_list;
> +	struct list_head	rpool_head;
> +	/* protects resource pool list */
> +	spinlock_t		rpool_lock;
> +	char			*name;
> +};
> +
> +/* APIs for RDMA/IB stack to publish when a device wants to
> + * participate in resource accounting
> + */

Please follow CodingStyle.  Wasn't this pointed out a couple times
already?

> +enum rdmacg_file_type {
> +	RDMACG_RESOURCE_MAX,
> +	RDMACG_RESOURCE_STAT,
> +};

Heh, usually not a good sign.  If you're using this to call into a
common function and then switch out on the file type, just switch out
at the method level and factor out common part into helpers.

> +/* resource tracker per resource for rdma cgroup */
> +struct rdmacg_resource {
> +	int max;
> +	int usage;
> +};

Align fields?

> +/**

The above indicates kerneldoc comments, which this isn't.

> + * resource pool object which represents, per cgroup, per device
> + * resources. There are multiple instance
> + * of this object per cgroup, therefore it cannot be embedded within
> + * rdma_cgroup structure. It is maintained as list.

Consistent paragraph fill?

> + */
> +struct rdmacg_resource_pool {
> +	struct list_head cg_list;
> +	struct list_head dev_list;
> +
> +	struct rdmacg_device *device;
> +	struct rdmacg_resource *resources;
> +	struct rdma_cgroup *cg;	/* owner cg used during device cleanup */
> +
> +	int	refcnt;		/* count active user tasks of this pool */
> +	int	num_max_cnt;	/* total number counts which are set to max */
> +};

Formatting.

> +static inline void set_resource_limit(struct rdmacg_resource_pool *rpool,
> +				      int index, int new_max)

Is inline necessary?  Compiler can figure out these.

> +static struct rdmacg_resource_pool*
                                     ^
				     space

> +find_cg_rpool_locked(struct rdma_cgroup *cg,
> +		     struct rdmacg_device *device)
...
> +static void uncharge_cg_resource(struct rdma_cgroup *cg,
> +				 struct rdmacg_device *device,
> +				 int index, int num)
> +{
...
> +	rpool->refcnt--;
> +	if (rpool->refcnt == 0 && rpool->num_max_cnt == pool_info->table_len) {

If the caller charges 2 and then uncharges 1 two times, the refcnt
underflows?  Why not just track how many usages are zero?

...
> +void rdmacg_uncharge(struct rdma_cgroup *cg,
> +		     struct rdmacg_device *device,
> +		     int index, int num)
> +{
> +	struct rdma_cgroup *p;
> +
> +	for (p = cg; p; p = parent_rdmacg(p))
> +		uncharge_cg_resource(p, device, index, num);
> +
> +	css_put(&cg->css);
> +}
> +EXPORT_SYMBOL(rdmacg_uncharge);

So, I suppose the code is trying to save lock contention with
fine-grained locking; however, as the code is currently structured,
it's just increasing the number of lock ops and it'd be highly likely
to cheaper to simply use a single lock.  If you're working up the tree
grabbing lock at each level, per-node locking doesn't save you
anything.  Also, it introduces conditions where charges are spuriously
denied when there are racing requestors.  If scalability becomes an
issue, the right way to address is adding percpu front cache.

> +void rdmacg_query_limit(struct rdmacg_device *device,
> +			int *limits)
> +{
> +	struct rdma_cgroup *cg, *p;
> +	struct rdmacg_resource_pool *rpool;
> +	struct rdmacg_pool_info *pool_info;
> +	int i;
> +
> +	cg = task_rdmacg(current);
> +	pool_info = &device->pool_info;

Nothing seems to prevent @cg from going away if this races with
@current being migrated to a different cgroup.  Have you run this with
lockdep and rcu debugging enabled?  This should have triggered a
warning.

...
> +	for (p = cg; p; p = parent_rdmacg(p)) {
> +		spin_lock(&cg->rpool_list_lock);
> +		rpool = find_cg_rpool_locked(cg, device);
> +		if (rpool) {
> +			for (i = 0; i < pool_info->table_len; i++)
> +				limits[i] = min_t(int, limits[i],
> +					rpool->resources[i].max);

So, the O complexity wise, things like the above are pretty bad and
the above pattern is used in hot paths.  I suppose there can only be a
handful of devices per system?

Thanks.

-- 
tejun
