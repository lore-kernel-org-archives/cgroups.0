From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Thu, 8 Sep 2016 09:12:19 +0300
Message-ID: <20160908061219.GK18398@leon.nu>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com>
 <1472632647-1525-2-git-send-email-pandit.parav@gmail.com>
 <20160831093836.GC3694@leon.nu>
 <CAG53R5U9_QVOAAnbqxWG80G=ROSYjgRXrNkJU1BpcpHCfVOe8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mPOSj6iWmtyhwOMz"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG53R5U9_QVOAAnbqxWG80G=ROSYjgRXrNkJU1BpcpHCfVOe8A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Christoph Hellwig <hch@lst.de>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org


--mPOSj6iWmtyhwOMz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 07, 2016 at 08:37:23PM +0530, Parav Pandit wrote:
> Hi Leon,
>
> >> Signed-off-by: Parav Pandit <pandit.parav@gmail.com>
> >> +static struct rdmacg_resource_pool *
> >> +get_cg_rpool_locked(struct rdma_cgroup *cg, struct rdmacg_device *device)
> >> +{
> >> +     struct rdmacg_resource_pool *rpool;
> >> +
> >> +     rpool = find_cg_rpool_locked(cg, device);
> >> +     if (rpool)
> >> +             return rpool;
> >> +
> >> +     rpool = kzalloc(sizeof(*rpool), GFP_KERNEL);
> >> +     if (!rpool)
> >> +             return ERR_PTR(-ENOMEM);
> >> +
> >> +     rpool->device = device;
> >> +     set_all_resource_max_limit(rpool);
> >> +
> >> +     INIT_LIST_HEAD(&rpool->cg_node);
> >> +     INIT_LIST_HEAD(&rpool->dev_node);
> >> +     list_add_tail(&rpool->cg_node, &cg->rpools);
> >> +     list_add_tail(&rpool->dev_node, &device->rpools);
> >> +     return rpool;
> >> +}
> >
> > <...>
> >
> >> +     for (p = cg; p; p = parent_rdmacg(p)) {
> >> +             rpool = get_cg_rpool_locked(p, device);
> >> +             if (IS_ERR_OR_NULL(rpool)) {
> >
> > get_cg_rpool_locked always returns !NULL (error, or pointer)
>
> Can this change go as incremental change after this patch, since this
> patch is close to completion?
> Or I need to revise v13?

Sure, it is cleanup. It is not worth of respinning.

>
> >
> >> +                     ret = PTR_ERR(rpool);
> >> +                     goto err;
> >
> > I didn't review the whole series yet.
>
> Did you get a chance to review the series?

We need to decide on fundamental question before reviewing it, which is
"how to fit rdmacg to new ABI model".

Thanks

--mPOSj6iWmtyhwOMz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX0QFDAAoJEORje4g2clinMBwQAMZJiRq9X4BASDHbPvWKQJi5
cUXcNg/NCV3BZ1g/uZWOffcUDDzV16W51wqyCw6cOq8lWuchng80yA65pzmVf+9s
v3G7PY4kxDTb9GjnlGzBAo1x6hz+6TEMfTZMtPW6AhUuzg9TaFgquyFvkjph58th
8S9NsEf3fg0x1GY1GgnNq8cCivwDB2jg+vCegxIMat+gIazRwQPeG6Au2I0UOngX
hn7n89SFMEK7YPMNei1N9E0NnXdEmdAOYsOiJQUiKiY5Hc7GXVSz1jrpL19I4+q9
BusK9uUiwSjzgLOKZtUBKs7AjU2VhUJXjY/5s2d0q7FeHaQ95J0ALeGR7Y2IUwUZ
zI3EPRbuw4brpC3t8jy367dA7Vok8QUHo81QYcQOCQQltapZI0a+jIxzo9t3wo9F
LJdidJJMtVDs33T515Xl7Dr2g/w+U68w/BV6gJR9t4IyqZxrSGcXCQ4aBt4v+UD9
FvbCDuAo3+nc2pALGEEBpOmPxUqKh8oDGpP+2DR/LTwpfw3usWk262l7T3lX2/Gn
ROCm7l4tvllZYWyUgDTnGT7euAoeL7XA5Vt9xNVN/+qPk8m88yVN9jO2bKd87+bB
tJ8gyriLBZCnXXbCjqRZCmJ1/JPUoUYDhw4P4tO2inI2PryrG8Mwhm3wbgmOnc1F
Srq5fw141XHxKBD6OMSB
=qcRA
-----END PGP SIGNATURE-----

--mPOSj6iWmtyhwOMz--
