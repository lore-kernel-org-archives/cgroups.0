From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Wed, 31 Aug 2016 12:38:36 +0300
Message-ID: <20160831093836.GC3694@leon.nu>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com>
 <1472632647-1525-2-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vOmOzSkFvhd7u8Ms"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1472632647-1525-2-git-send-email-pandit.parav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, hch@lst.de, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com, corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org


--vOmOzSkFvhd7u8Ms
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 31, 2016 at 02:07:25PM +0530, Parav Pandit wrote:
> Added rdma cgroup controller that does accounting, limit enforcement
> on rdma/IB verbs and hw resources.
>
> Added rdma cgroup header file which defines its APIs to perform
> charing/uncharing functionality. It also defined APIs for RDMA/IB
> stack for device registration. Devices which are registered will
> participate in controller functions of accounting and limit
> enforcements. It define rdmacg_device structure to bind IB stack
> and RDMA cgroup controller.
>
> RDMA resources are tracked using resource pool. Resource pool is per
> device, per cgroup entity which allows setting up accounting limits
> on per device basis.
>
> Currently resources are defined by the RDMA cgroup.
>
> Resource pool is created/destroyed dynamically whenever
> charging/uncharging occurs respectively and whenever user
> configuration is done. Its a tradeoff of memory vs little more code
> space that creates resource pool object whenever necessary, instead of
> creating them during cgroup creation and device registration time.
>
> Signed-off-by: Parav Pandit <pandit.parav@gmail.com>
> ---

<...>

> +
> +static struct rdmacg_resource_pool *
> +get_cg_rpool_locked(struct rdma_cgroup *cg, struct rdmacg_device *device)
> +{
> +	struct rdmacg_resource_pool *rpool;
> +
> +	rpool = find_cg_rpool_locked(cg, device);
> +	if (rpool)
> +		return rpool;
> +
> +	rpool = kzalloc(sizeof(*rpool), GFP_KERNEL);
> +	if (!rpool)
> +		return ERR_PTR(-ENOMEM);
> +
> +	rpool->device = device;
> +	set_all_resource_max_limit(rpool);
> +
> +	INIT_LIST_HEAD(&rpool->cg_node);
> +	INIT_LIST_HEAD(&rpool->dev_node);
> +	list_add_tail(&rpool->cg_node, &cg->rpools);
> +	list_add_tail(&rpool->dev_node, &device->rpools);
> +	return rpool;
> +}

<...>

> +	for (p = cg; p; p = parent_rdmacg(p)) {
> +		rpool = get_cg_rpool_locked(p, device);
> +		if (IS_ERR_OR_NULL(rpool)) {

get_cg_rpool_locked always returns !NULL (error, or pointer)

> +			ret = PTR_ERR(rpool);
> +			goto err;

I didn't review the whole series yet.

--vOmOzSkFvhd7u8Ms
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXxqWcAAoJEORje4g2clinatsP/RLqZ82RES+fIjFWRfe0kUE8
W1sYsHLVjsUeFgaBSnd8WUy4pnNN5uJze+OX5v8G4mMTDbamKpiYXVM3SDiYDSqY
npv38kH+p8tjDGduyQWkUOy1rJTokTITGRvcURndkHI4YCjQasgigSXl4WTP3k/K
qSPvmQ126tgMz0RjgOGscyZDAVybowehwclzTvwm6Qqg6dSAc3cljxQskP0+QuKb
PpL7vAjj0E3Kv1j+YgE23dHVnZuWclHCrv40oL2FGHQWR8vfAxnaRG0k9KNaSiuF
n5u8DSvk8bhA2Y6ktj+If2JDy5j7bj41Tb3Jg3EcnLcNmMgxfiWadeG1VYEZDZRX
M5M+SjTOsOOYZ+/5eCeigq6e54evYgBKLtGr+wdbXLmdnv9L9RtasfRHJHgnKqpX
6le2i8O3i0+qVAxbJzfHoFma9FXCixwXEkEN7hQw13nKL7zyth6ddxHhj16K6tXV
BZwvpQCAqHoDum/iAAFRijO42oFrgCaYb3RqnOYNWZKDda4NI2marWAqJSwLMK4y
LeaDfCKw8OiELCl+Uk9VIqvH0kJNcDoXDxiaMKg89GKkLRrprHOG3VZ2tk57dpPb
Q+zJKRgsIeou6PZTS9tERAdDxDSseT8kOgo9DUZH5vPzf5PoRWpb5ZTM87UzSU9V
FuHt1z0kAnYXYxtF0+mJ
=5lQa
-----END PGP SIGNATURE-----

--vOmOzSkFvhd7u8Ms--
