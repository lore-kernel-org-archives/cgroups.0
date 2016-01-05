From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv1 3/6] rdmacg: implements rdma cgroup
Date: Tue, 5 Jan 2016 17:01:28 -0500
Message-ID: <20160105220128.GJ5995@mtj.duckdns.org>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
 <1452020286-9508-4-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Return-path: <linux-security-module-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=9x21+NytVooFrB1LWOs3h3K4mrIbLj12CnaSMvT2P+4=;
        b=v0d9DuY9dIJRu05L9KZXKudPs83/zXo55Mcuq7eYVF8f8wzm4o3h+7Hw2x4Assi4Pz
         Ukhs5DIRUnNP6ZTSUq8hc/j4d0ySKNBInKUtkFyHYvlO1IB7130Sz7JEPD7KGBihfM2n
         UPa3HvuaEbGmrgfvAyDXhQHqbubwPNsR6Zf5Kag/n4bbqw73AoFiRH7hgd6ca407c/XY
         2n1sWLqIwk7tdLKEmlUZCFcGmaP4Lb5JWnpvMcTGbbMAXC/nOZGWJseFKwhm/q/KDAa+
         s337nzbbYPlHbIP88oNNGZ3xNVI4irMkKWMnpJIn7h/A4mJYBc9E8u9sxqRuRUJ863Gp
         qfCA==
Content-Disposition: inline
In-Reply-To: <1452020286-9508-4-git-send-email-pandit.parav@gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com, corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

Hello,

On Wed, Jan 06, 2016 at 12:28:03AM +0530, Parav Pandit wrote:
> +/* hash table to keep map of tgid to owner cgroup */
> +DEFINE_HASHTABLE(pid_cg_map_tbl, 7);
> +DEFINE_SPINLOCK(pid_cg_map_lock);	/* lock to protect hash table access */
> +
> +/* Keeps mapping of pid to its owning cgroup at rdma level,
> + * This mapping doesn't change, even if process migrates from one to other
> + * rdma cgroup.
> + */
> +struct pid_cg_map {
> +	struct pid *pid;		/* hash key */
> +	struct rdma_cgroup *cg;
> +
> +	struct hlist_node hlist;	/* pid to cgroup hash table link */
> +	atomic_t refcnt;		/* count active user tasks to figure out
> +					 * when to free the memory
> +					 */
> +};

Ugh, there's something clearly wrong here.  Why does the rdma
controller need to keep track of pid cgroup membership?

> +static void _dealloc_cg_rpool(struct rdma_cgroup *cg,
> +			      struct cg_resource_pool *rpool)
> +{
> +	spin_lock(&cg->cg_list_lock);
> +
> +	/* if its started getting used by other task,
> +	 * before we take the spin lock, then skip,
> +	 * freeing it.
> +	 */

Please follow CodingStyle.

> +	if (atomic_read(&rpool->refcnt) == 0) {
> +		list_del_init(&rpool->cg_list);
> +		spin_unlock(&cg->cg_list_lock);
> +
> +		_free_cg_rpool(rpool);
> +		return;
> +	}
> +	spin_unlock(&cg->cg_list_lock);
> +}
> +
> +static void dealloc_cg_rpool(struct rdma_cgroup *cg,
> +			     struct cg_resource_pool *rpool)
> +{
> +	/* Don't free the resource pool which is created by the
> +	 * user, otherwise we miss the configured limits. We don't
> +	 * gain much either by splitting storage of limit and usage.
> +	 * So keep it around until user deletes the limits.
> +	 */
> +	if (atomic_read(&rpool->creator) == RDMACG_RPOOL_CREATOR_DEFAULT)
> +		_dealloc_cg_rpool(cg, rpool);

I'm pretty sure you can get away with an fixed length array of
counters.  Please keep it simple.  It's a simple hard limit enforcer.
There's no need to create a massive dynamic infrastrucure.

Thanks.

-- 
tejun
