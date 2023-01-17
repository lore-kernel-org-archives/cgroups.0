From: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Subject: Re: [RFC 04/12] drm/cgroup: Track clients per owning
 process
Date: Tue, 17 Jan 2023 17:03:11 +0100
Message-ID: <20230117160311.GA15842@linux.intel.com>
References: <20230112165609.1083270-1-tvrtko.ursulin@linux.intel.com>
 <20230112165609.1083270-5-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1673971492; x=1705507492;
 h=date:from:to:cc:subject:message-id:references:
 mime-version:in-reply-to;
 bh=83QUm+B1soJY7/5R+o87e442WuYAgBdKXUVW9VPPJwY=;
 b=IubsWkpoktWBNxNWo8Q20thw0LC165CNAyzo7Oolz9r+RtyZIgAjm3Rp
 A/KNXhaa+IEwcTMt5Ph+RxLkBkgsEQZY9LVP3tYJxmTFH/aLk88lXdWnt
 aFtxpoz1uPdcB4ouCvVb7boRTeDp7yz3qtCWa3OfyL3MqBKtYNQlJ3nGJ
 hmC67UgXtRZghYLUei/7ZifIEYnggj8toKfMSOwe4PP5alA9kxuXsqbBq
 8qnV9g5hcBbyOUZcFx2FQQ352MwtCF5o1BYUroOLBp46aa6EV7XzLXvI8
 /SebZ+j30dkD1d3Jsvwwu9gZjHcHjt04nFfviYG1V2k9Nmx8AeVxDu4gp Q==;
Content-Disposition: inline
In-Reply-To: <20230112165609.1083270-5-tvrtko.ursulin@linux.intel.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Rob Clark <robdclark@chromium.org>, cgroups@vger.kernel.org, Dave Airlie <airlied@redhat.com>, Kenny.Ho@amd.com, Intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, "T . J . Mercier" <tjmercier@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zefan Li <lizefan.x@bytedance.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, Tejun Heo <tj@kernel.org>, =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>

Hi

On Thu, Jan 12, 2023 at 04:56:01PM +0000, Tvrtko Ursulin wrote:
> From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> 
> To enable propagation of settings from the cgroup drm controller to drm we
> need to start tracking which processes own which drm clients.
> 
> Implement that by tracking the struct pid pointer of the owning process in
> a new XArray, pointing to a structure containing a list of associated
> struct drm_file pointers.
> 
> Clients are added and removed under the filelist mutex and RCU list
> operations are used below it to allow for lockless lookup.
> 
> Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

<snip>

> +int drm_clients_open(struct drm_file *file_priv)
> +{
> +	struct drm_device *dev = file_priv->minor->dev;
> +	struct drm_pid_clients *clients;
> +	bool new_client = false;
> +	unsigned long pid;
> +
> +	lockdep_assert_held(&dev->filelist_mutex);
> +
> +	pid = (unsigned long)rcu_access_pointer(file_priv->pid);
> +	clients = xa_load(&drm_pid_clients, pid);
> +	if (!clients) {
> +		clients = __alloc_clients();
> +		if (!clients)
> +			return -ENOMEM;
> +		new_client = true;
> +	}
> +	atomic_inc(&clients->num);
> +	list_add_tail_rcu(&file_priv->clink, &clients->file_list);
> +	if (new_client) {
> +		void *xret;
> +
> +		xret = xa_store(&drm_pid_clients, pid, clients, GFP_KERNEL);
> +		if (xa_err(xret)) {
> +			list_del_init(&file_priv->clink);
> +			kfree(clients);
> +			return PTR_ERR(clients);

This looks incorrect, rather xa_err(xret) should be returned.

Regards
Stanislaw
