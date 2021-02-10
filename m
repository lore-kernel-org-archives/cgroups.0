From: Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [RFC PATCH 8/9] drm/gem: Associate GEM objects with drm cgroup
Date: Wed, 10 Feb 2021 08:52:29 +0100
Message-ID: <faeaef17-3656-ca31-3be9-49354db3116e@suse.de>
References: <20210126214626.16260-1-brian.welty@intel.com>
 <20210126214626.16260-9-brian.welty@intel.com>
 <YCJp//kMC7YjVMXv@phenom.ffwll.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1344061703=="
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <YCJp//kMC7YjVMXv-dv86pmgwkMBes7Z6vYuT8azUEOm+Xw19@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, Eero Tamminen <eero.t.tamminen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============1344061703==
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="t358AJk9LGksusmvn059A4ACV9zuTsn4c"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--t358AJk9LGksusmvn059A4ACV9zuTsn4c
Content-Type: multipart/mixed; boundary="37ZsdYh6Dp4INO2q6vcaH93ikD1BsiH24";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>
To: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,
 Eero Tamminen <eero.t.tamminen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>,
 Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org,
 dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>,
 amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?Q?Christian_K=c3=b6nig?=
 <christian.koenig-5C7GfCeVMHo@public.gmane.org>
Message-ID: <faeaef17-3656-ca31-3be9-49354db3116e-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [RFC PATCH 8/9] drm/gem: Associate GEM objects with drm cgroup
References: <20210126214626.16260-1-brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 <20210126214626.16260-9-brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 <YCJp//kMC7YjVMXv-dv86pmgwkMBes7Z6vYuT8azUEOm+Xw19@public.gmane.org>
In-Reply-To: <YCJp//kMC7YjVMXv-dv86pmgwkMBes7Z6vYuT8azUEOm+Xw19@public.gmane.org>

--37ZsdYh6Dp4INO2q6vcaH93ikD1BsiH24
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi

Am 09.02.21 um 11:54 schrieb Daniel Vetter:
> *: vmwgfx is the only non-gem driver, but there's plans to move at leas=
t
> vmwgfx internals (maybe not the uapi, we'll see) over to gem. Once that=
's
> done it's truly all gpu memory.

Do you have a URL to the discussion?

While I recent worked on GEM, I thought that vmwgfx could easily switch=20
to the GEM internals without adopting the interface.

Personally, I think we should consider renaming struct drm_gem_object et =

al. It's not strictly GEM UAPI, but nowadays anything memory-related.=20
Maybe drm_mem_object would fit.

Best regards
Thomas

>> ---
>>   drivers/gpu/drm/drm_gem.c | 89 +++++++++++++++++++++++++++++++++++++=
++
>>   include/drm/drm_gem.h     | 17 ++++++++
>>   2 files changed, 106 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
>> index c2ce78c4edc3..a12da41eaafe 100644
>> --- a/drivers/gpu/drm/drm_gem.c
>> +++ b/drivers/gpu/drm/drm_gem.c
>> @@ -29,6 +29,7 @@
>>   #include <linux/slab.h>
>>   #include <linux/mm.h>
>>   #include <linux/uaccess.h>
>> +#include <linux/cgroup_drm.h>
>>   #include <linux/fs.h>
>>   #include <linux/file.h>
>>   #include <linux/module.h>
>> @@ -112,6 +113,89 @@ drm_gem_init(struct drm_device *dev)
>>   	return drmm_add_action(dev, drm_gem_init_release, NULL);
>>   }
>>  =20
>> +/**
>> + * drm_gem_object_set_cgroup - associate GEM object with a cgroup
>> + * @obj: GEM object which is being associated with a cgroup
>> + * @task: task associated with process control group to use
>> + *
>> + * This will acquire a reference on cgroup and use for charging GEM
>> + * memory allocations.
>> + * This helper could be extended in future to migrate charges to anot=
her
>> + * cgroup, print warning if this usage occurs.
>> + */
>> +void drm_gem_object_set_cgroup(struct drm_gem_object *obj,
>> +			       struct task_struct *task)
>> +{
>> +	/* if object has existing cgroup, we migrate the charge... */
>> +	if (obj->drmcg) {
>> +		pr_warn("DRM: need to migrate cgroup charge of %lld\n",
>> +			atomic64_read(&obj->drmcg_bytes_charged));
>> +	}
>> +	obj->drmcg =3D drmcg_get(task);
>> +}
>> +EXPORT_SYMBOL(drm_gem_object_set_cgroup);
>> +
>> +/**
>> + * drm_gem_object_unset_cgroup - clear GEM object's associated cgroup=

>> + * @obj: GEM object
>> + *
>> + * This will release a reference on cgroup.
>> + */
>> +void drm_gem_object_unset_cgroup(struct drm_gem_object *obj)
>> +{
>> +	WARN_ON(atomic64_read(&obj->drmcg_bytes_charged));
>> +	drmcg_put(obj->drmcg);
>> +}
>> +EXPORT_SYMBOL(drm_gem_object_unset_cgroup);
>> +
>> +/**
>> + * drm_gem_object_charge_mem - try charging size bytes to DRM cgroup
>> + * @obj: GEM object which is being charged
>> + * @size: number of bytes to charge
>> + *
>> + * Try to charge @size bytes to GEM object's associated DRM cgroup.  =
This
>> + * will fail if a successful charge would cause the current device me=
mory
>> + * usage to go above the cgroup's GPU memory maximum limit.
>> + *
>> + * Returns 0 on success.  Otherwise, an error code is returned.
>> + */
>> +int drm_gem_object_charge_mem(struct drm_gem_object *obj, u64 size)
>> +{
>> +	int ret;
>> +
>> +	ret =3D drm_cgroup_try_charge(obj->drmcg, obj->dev,
>> +				    DRMCG_TYPE_MEM_CURRENT, size);
>> +	if (!ret)
>> +		atomic64_add(size, &obj->drmcg_bytes_charged);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL(drm_gem_object_charge_mem);
>> +
>> +/**
>> + * drm_gem_object_uncharge_mem - uncharge size bytes from DRM cgroup
>> + * @obj: GEM object which is being uncharged
>> + * @size: number of bytes to uncharge
>> + *
>> + * Uncharge @size bytes from the DRM cgroup associated with specified=

>> + * GEM object.
>> + *
>> + * Returns 0 on success.  Otherwise, an error code is returned.
>> + */
>> +void drm_gem_object_uncharge_mem(struct drm_gem_object *obj, u64 size=
)
>> +{
>> +	u64 charged =3D atomic64_read(&obj->drmcg_bytes_charged);
>> +
>> +	if (WARN_ON(!charged))
>> +		return;
>> +	if (WARN_ON(size > charged))
>> +		size =3D charged;
>> +
>> +	atomic64_sub(size, &obj->drmcg_bytes_charged);
>> +	drm_cgroup_uncharge(obj->drmcg, obj->dev, DRMCG_TYPE_MEM_CURRENT,
>> +			    size);
>> +}
>> +EXPORT_SYMBOL(drm_gem_object_uncharge_mem);
>> +
>>   /**
>>    * drm_gem_object_init - initialize an allocated shmem-backed GEM ob=
ject
>>    * @dev: drm_device the object should be initialized for
>> @@ -156,6 +240,8 @@ void drm_gem_private_object_init(struct drm_device=
 *dev,
>>   	obj->dev =3D dev;
>>   	obj->filp =3D NULL;
>>  =20
>> +	drm_gem_object_set_cgroup(obj, current);
>> +
>>   	kref_init(&obj->refcount);
>>   	obj->handle_count =3D 0;
>>   	obj->size =3D size;
>> @@ -950,6 +1036,9 @@ drm_gem_object_release(struct drm_gem_object *obj=
)
>>  =20
>>   	dma_resv_fini(&obj->_resv);
>>   	drm_gem_free_mmap_offset(obj);
>> +
>> +	/* Release reference on cgroup used with GEM object charging */
>> +	drm_gem_object_unset_cgroup(obj);
>>   }
>>   EXPORT_SYMBOL(drm_gem_object_release);
>>  =20
>> diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
>> index 240049566592..06ea10fc17bc 100644
>> --- a/include/drm/drm_gem.h
>> +++ b/include/drm/drm_gem.h
>> @@ -37,6 +37,7 @@
>>   #include <linux/kref.h>
>>   #include <linux/dma-resv.h>
>>  =20
>> +#include <drm/drm_cgroup.h>
>>   #include <drm/drm_vma_manager.h>
>>  =20
>>   struct dma_buf_map;
>> @@ -222,6 +223,17 @@ struct drm_gem_object {
>>   	 */
>>   	struct file *filp;
>>  =20
>> +	/**
>> +	 * @drmcg:
>> +	 *
>> +	 * cgroup used for charging GEM object page allocations against. Thi=
s
>> +	 * is set to the current cgroup during GEM object creation.
>> +	 * Charging policy is up to the DRM driver to implement and should b=
e
>> +	 * charged when allocating backing store from device memory.
>> +	 */
>> +	struct drmcg *drmcg;
>> +	atomic64_t drmcg_bytes_charged;
>> +
>>   	/**
>>   	 * @vma_node:
>>   	 *
>> @@ -417,4 +429,9 @@ int drm_gem_fence_array_add_implicit(struct xarray=
 *fence_array,
>>   int drm_gem_dumb_map_offset(struct drm_file *file, struct drm_device=
 *dev,
>>   			    u32 handle, u64 *offset);
>>  =20
>> +void drm_gem_object_set_cgroup(struct drm_gem_object *obj,
>> +			       struct task_struct *task);
>> +void drm_gem_object_unset_cgroup(struct drm_gem_object *obj);
>> +int drm_gem_object_charge_mem(struct drm_gem_object *obj, u64 size);
>> +void drm_gem_object_uncharge_mem(struct drm_gem_object *obj, u64 size=
);
>>   #endif /* __DRM_GEM_H__ */
>> --=20
>> 2.20.1
>>
>=20

--=20
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
(HRB 36809, AG N=C3=BCrnberg)
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer


--37ZsdYh6Dp4INO2q6vcaH93ikD1BsiH24--

--t358AJk9LGksusmvn059A4ACV9zuTsn4c
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmAjkL0FAwAAAAAACgkQlh/E3EQov+D/
DA/9FuoxspimR/1k4JtNsUWDSx1lHZXLFoUIF3YYkJMb2+lU8r40EzEcaK4dCjMjNnJcWojEodwU
tGeD495XQ86ZtwU/OMA9vFXVh624tywF3h9Tn4LTcX6Q3AqDk/SDTbJwVHM+7ADQlREhvlCX42N8
XKzQe5AuN5+Eu1jU/uTJokirswB+1voV2i/m2lECZt8KKDLV3INlkY1d9XdqoIpJN1GRSKxUdLEe
0x9m9dDUqW6mFH3RRprwl0/2yZ3qeZ/WNhEgWhN02GZ2/dWQQ2Hl72j5EQuT2ma6QK05hQakEF2q
XXifa4i+EwR4v10sfK7Eb6wG3eD0TBjMZb4hkquJJXqK4RX78QGxoZ73ilvQyw4ESEgq8N0GvsTQ
m+xP9BLuZaryZLP8yAjpzzFdDXFDXFKQykgPcgqXPCYkXorWtY6WAbI9AuRTQ7P0UC5EyJbKwubU
r9m38RkjhDi7uIGeUv2/03Edkwsqcy1dud93GDFf3+IniGUbMUTn2yjWhuUK6bWiUua6PW+B0Fa+
vqzcwhk0qPo9u+Ul5f3OcW8ihS3UqzanqI+hp4e2LL2TcwznyXEgjjfEc5k44xGwIBUw1nZ5bIGS
7L7Fm08I8I/sxIk2d5e9UkDSEw0OePqoD8WQzNT/mhLiM2AY5OlXwxoMVpkLG79GMEozUiAQcjLS
Wg4=
=LnX9
-----END PGP SIGNATURE-----

--t358AJk9LGksusmvn059A4ACV9zuTsn4c--

--===============1344061703==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
amd-gfx mailing list
amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
https://lists.freedesktop.org/mailman/listinfo/amd-gfx

--===============1344061703==--
