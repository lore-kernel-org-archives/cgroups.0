Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794469573;
	b=RNUlncimWXhw+2R1/aT9Yas9Vai2MrkhGdu68tC++gwWCoTUQUtdmcr8N+ZFhi8UU8S3
	 uhgjlhX3M63yuA3INvn6bi3IdpHvY4rpcabLIh2tcEQzzMKyCvep0V+zP6kfz5zoWNQGg
	 IWuHWZZfjWzlMxlXJvE8j8h4x624NyAseY3GH0DDl2VvQMzeL5Wf1/KAuhCqqaYLWfoFV
	 o+9kOVz0I575VgLxOYa6q5Y7/X0pEIjAxk/uJWFuR3gBMk1AMSyCpmx4UxEOiclFLnJ8b
	 rKMkDUGhen1rIs62cKSyFQHDlJYP5OuK1qv962MkD8NWul0MkefwXqMWtz+Gb4FTFSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794469573;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Subject:
	 From:To:Cc:Date:In-Reply-To:References:Organization:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=U/4tUzC3TLD4FqI4xdC5pvsxvjza6A9soJUP+9C2920=;
	b=wouxu9ESNGhk6tIqSrPsRDi0Zw2uZq8IrwmxHB4DQyHM9B+BXYrK4fcbGQRIcyAZfBv0
	 wCtjjPl4+kf5UMT/DXvVuja8mVeJCjo8Mb8dpDmfICzmwTqvFjHrmE82yUbTm0db4OtjI
	 IzCtKzq29oYNhO9e6H5BRa5x/gsG5wvvb4XnW7uQC9teHi4kKJKYNgD9EjtjNsY8BAwYP
	 /o4ytzsTDCit6wd9e1AhMr2OQBp0VFRci0YcE3vGjsBGCEqF48+KDV1a3rdgHxULjq+Io
	 MFbhuxr3RobzS1RTQSdcPCr7c7qWJSIQzmrYGrWi4D2E7Ahyih8yDczYKnEVHzJ7vQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=fogQ1fr0;
	arc=none smtp.remote-ip=192.198.163.13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20086606A31C;
	Thu, 12 Nov 2026 07:46:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20086606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=fogQ1fr0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794469573; x=1826005573;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=B8DZ8ac/lvdCsHwLYiCV00yrDKWFEEEp87wCEsDsqUc=;
  b=fogQ1fr0O47koKlo7t3/U1PYYgrJGevdWYT7W5BHP26SBsf8M3jT1AdM
   kh3wwHY092bAE5/I41vfw4uSxMtE1Lq8uQ3fsLf0TkUiqTN9qCK9kwzrJ
   TuGopMNWhznMo9LUs2YG6qqmopKZ5Qxe4SkmG1M7alCNJD84/lcAKk7iO
   Mkc+giTk0lphFEfzWhOJourp6SfdW4YuD4cVAa7ExY4uoVaxlcPfplXYE
   C0WzD5kY0myqVG9iriCsXd/yz+eSP7ob3dXgzO9kGhkKnwfDDbcLciOJ1
   7Pqugw40Vq+GR/yMSNQ3KaqgXcXTokyM9BMnvGYd5BiddQcekko8b2PzT
   w==;
X-CSE-ConnectionGUID: GQJcIa4DSdOk3rx9QCmbQg==
X-CSE-MsgGUID: nE0oYHMQT+ap/49GEztx4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11963"; a="3243957"
X-IronPort-AV: E=Sophos;i="6.27,209,1787036400"; 
   d="scan'208";a="3243957"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 23:46:12 -0800
X-CSE-ConnectionGUID: Vp69MBqRQdu2Arofn2sCCw==
X-CSE-MsgGUID: tgWbJ6xUQFC8hBm4R0ZRfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,209,1787036400"; 
   d="scan'208";a="9027153"
Received: from carterle-desk.ger.corp.intel.com (HELO [10.245.244.5]) ([10.245.244.5])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 23:46:05 -0800
Message-ID: <b77aecccce2dcf9bc42b1a6fccc62d06ccad4741.camel@linux.intel.com>
Subject: Re: [Linaro-mm-sig] [PATCH v4 3/8] dma-buf: transfer memcg charges
 via DMA_BUF_IOCTL_XFER_CHARGE
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Albert Esteve <aesteve@redhat.com>, Tejun Heo <tj@kernel.org>, Johannes
 Weiner <hannes@cmpxchg.org>, Michal =?ISO-8859-1?Q?Koutn=FD?=
 <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>, Sumit Semwal	 <sumit.semwal@linaro.org>,
 Christian =?ISO-8859-1?Q?K=F6nig?=	 <christian.koenig@amd.com>, Michal
 Hocko <mhocko@kernel.org>, Roman Gushchin	 <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song	
 <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey
 <Brian.Starkey@arm.com>, John Stultz	 <jstultz@google.com>, "T.J. Mercier"
 <tjmercier@google.com>, Christian Brauner	 <brauner@kernel.org>, Paul Moore
 <paul@paul-moore.com>, James Morris	 <jmorris@namei.org>, "Serge E. Hallyn"
 <serge@hallyn.com>, Stephen Smalley	 <stephen.smalley.work@gmail.com>,
 Shuah Khan <shuah@kernel.org>, Randy Dunlap	 <rdunlap@infradead.org>,
 Ondrej =?UTF-8?Q?Mosn=C3=A1=C4=8Dek?=	 <omosnacek@gmail.com>, Jens
 Wiklander <jenswi@kernel.org>, Sumit Garg	 <sumit.garg@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	op-tee@lists.trustedfirmware.org
Date: Thu, 12 Nov 2026 08:46:02 +0100
In-Reply-To: <20261104-v2_20230123_tjmercier_google_com-v4-3-1819a017000b@redhat.com>
References: 
	<20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
	 <20261104-v2_20230123_tjmercier_google_com-v4-3-1819a017000b@redhat.com>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-2.fc43) 
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Wed, 2026-11-04 at 12:09 +0100, Albert Esteve wrote:
> dma-heap already supports charging a specific cgroup at allocation
> time via charge_fd in DMA_HEAP_IOCTL_ALLOC. However, dma-bufs can
> originate from any exporter (DRM, V4L2, etc.), and the allocator may
> not know the final owner at allocation time.
>=20
> Add DMA_BUF_IOCTL_XFER_CHARGE to transfer a dma-buf's memcg charge
> to a different cgroup after allocation. The target is identified by
> charge_fd, which may be a cgroupfd or a pidfd.
>=20
> The transfer charges the new cgroup before uncharging the old one,
> preserving the original charge on failure. Concurrent transfers are
> serialized by the dma-buf reservation lock, so lockdep covers the
> locking order of the charge path early. The transfer implementation
> is generic (mem_cgroup_transfer_charge) and not dma-buf specific, so
> it can be reused by other subsystems.
>=20
> Not all dma-buf exporters back their buffers with reclaimable system
> memory. Some represent device registers, VRAM, or carved-out pools
> where size is not a meaningful memory cost. The xfer ioctl returns
> -EOPNOTSUPP for buffers whose memcg is not set. Exporters opt in by
> passing a memcg through dma_buf_export_info at export time. Currently
> only the system heap sets it, other exporters can opt in as needed.
>=20
> Usage example:
> =C2=A0 int cg_fd =3D open("/sys/fs/cgroup/clients/app1", O_RDONLY |
> O_DIRECTORY);
>=20
> =C2=A0 struct dma_buf_transfer_charge xfer =3D {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .charge_fd =3D cg_fd,
> =C2=A0 };
> =C2=A0 ioctl(dmabuf_fd, DMA_BUF_IOCTL_XFER_CHARGE, &xfer);
> =C2=A0 /* charge now on app1's cgroup */
> =C2=A0 close(cg_fd);
>=20
> Signed-off-by: Albert Esteve <aesteve@redhat.com>
> ---
> =C2=A0drivers/dma-buf/dma-buf.c=C2=A0=C2=A0=C2=A0 | 42
> ++++++++++++++++++++++++++++++++++++++++++
> =C2=A0include/linux/dma-buf.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 3 ++-
> =C2=A0include/linux/memcontrol.h=C2=A0=C2=A0 | 13 +++++++++++++
> =C2=A0include/uapi/linux/dma-buf.h | 26 ++++++++++++++++++++++++++
> =C2=A0mm/memcontrol.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 42
> ++++++++++++++++++++++++++++++++++++++++++
> =C2=A05 files changed, 125 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 837666273550..3bd26fbb1109 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -540,6 +540,45 @@ static long dma_buf_import_sync_file(struct
> dma_buf *dmabuf,
> =C2=A0}
> =C2=A0#endif
> =C2=A0
> +/* Transfer a dma-buf's memcg charge; see struct
> dma_buf_transfer_charge */
> +static long dma_buf_xfer_charge(struct dma_buf *dmabuf,
> +				const void __user *user_data)
> +{
> +	struct dma_buf_transfer_charge arg;
> +	struct mem_cgroup *memcg;
> +	unsigned int nr_pages =3D PAGE_ALIGN(dmabuf->size) >>
> PAGE_SHIFT;
> +	int ret =3D 0;
> +
> +	if (copy_from_user(&arg, user_data, sizeof(arg)))
> +		return -EFAULT;
> +
> +	if (!IS_ENABLED(CONFIG_MEMCG))
> +		return 0;
> +
> +	if (arg.flags !=3D 0)
> +		return -EINVAL;
> +
> +	memcg =3D mem_cgroup_get_from_fd(arg.charge_fd);
> +	if (IS_ERR(memcg))
> +		return PTR_ERR(memcg);
> +
> +	dma_resv_lock(dmabuf->resv, NULL);
> +
> +	if (!dmabuf->memcg) {
> +		ret =3D -EOPNOTSUPP;
> +		goto out;
> +	}
> +
> +	if (dmabuf->memcg !=3D memcg &&
> +	=C2=A0=C2=A0=C2=A0 !mem_cgroup_transfer_charge(&dmabuf->memcg, memcg,
> MEMCG_DMABUF, nr_pages))
> +		ret =3D -ENOMEM;
> +
> +out:
> +	dma_resv_unlock(dmabuf->resv);
> +	mem_cgroup_put(memcg);
> +	return ret;
> +}
> +
> =C2=A0static long dma_buf_ioctl(struct file *file,
> =C2=A0			=C2=A0 unsigned int cmd, unsigned long arg)
> =C2=A0{
> @@ -590,6 +629,9 @@ static long dma_buf_ioctl(struct file *file,
> =C2=A0		return dma_buf_import_sync_file(dmabuf, (const void
> __user *)arg);
> =C2=A0#endif
> =C2=A0
> +	case DMA_BUF_IOCTL_XFER_CHARGE:
> +		return dma_buf_xfer_charge(dmabuf, (const void
> __user *)arg);
> +
> =C2=A0	default:
> =C2=A0		return -ENOTTY;
> =C2=A0	}
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index 85dd747c9b36..b01149d26b44 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -507,7 +507,8 @@ struct dma_buf_attachment {
> =C2=A0 * @priv:	Attach private data of allocator to this buffer
> =C2=A0 * @memcg:	memcg to charge for this buffer's memory. Set only
> for
> =C2=A0 *		buffers backed by system memory where @size reflects
> the
> - *		actual allocation in bytes.
> + *		actual allocation in bytes. Enables charge transfer
> via
> + *		DMA_BUF_IOCTL_XFER_CHARGE.
> =C2=A0 *
> =C2=A0 * This structure holds the information required to export the
> buffer. Used
> =C2=A0 * with dma_buf_export() only.
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index f8ec751b7d7b..af02d9777fe9 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -676,6 +676,11 @@ struct mem_cgroup *mem_cgroup_get_from_fd(int
> fd);
> =C2=A0bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg, gfp_t gfp,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int nr_pages);
> =C2=A0
> +bool mem_cgroup_transfer_charge(struct mem_cgroup **ptr_memcg,
> +				struct mem_cgroup *new_memcg,
> +				enum memcg_stat_item item,
> +				unsigned int nr_pages);
> +
> =C2=A0void __mem_cgroup_uncharge(struct folio *folio);
> =C2=A0
> =C2=A0/**
> @@ -1197,6 +1202,14 @@ static inline void
> mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg,
> =C2=A0{
> =C2=A0}
> =C2=A0
> +static inline bool mem_cgroup_transfer_charge(struct mem_cgroup
> **ptr_memcg,
> +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct mem_cgroup
> *new_memcg,
> +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 enum memcg_stat_item
> item,
> +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int nr_pages)
> +{
> +	return true;
> +}
> +
> =C2=A0static inline void mem_cgroup_uncharge(struct folio *folio)
> =C2=A0{
> =C2=A0}
> diff --git a/include/uapi/linux/dma-buf.h b/include/uapi/linux/dma-
> buf.h
> index e827c9d20c5d..0aaf2e7d593b 100644
> --- a/include/uapi/linux/dma-buf.h
> +++ b/include/uapi/linux/dma-buf.h
> @@ -168,6 +168,31 @@ struct dma_buf_import_sync_file {
> =C2=A0	__s32 fd;
> =C2=A0};
> =C2=A0
> +/**
> + * struct dma_buf_transfer_charge - Transfer a dma-buf's memcg
> charge
> + *
> + * Any holder of a dma-buf file descriptor can perform a
> + * DMA_BUF_IOCTL_XFER_CHARGE to attribute the buffer's memory
> + * cost to a specific cgroup, or move it from one cgroup to
> + * another.=C2=A0 The ioctl charges the new cgroup before uncharging
> + * the old one atomically.=C2=A0 On failure the original charge is
> + * preserved.=C2=A0 If the buffer has no existing memcg charge, the
> + * ioctl returns -EOPNOTSUPP.
> + */
> +struct dma_buf_transfer_charge {
> +	/** @flags: Reserved, must be zero */
> +	__u32 flags; /* unused for now */
> +	/**
> +	 * @charge_fd: File descriptor identifying the target
> cgroup.
> +	 *
> +	 * May be either a pidfd, in which case the charge moves to
> the
> +	 * memory cgroup of the referenced process, or a cgroupfd
> obtained
> +	 * by opening a cgroup v2 directory, in which case the
> charge moves
> +	 * directly to that cgroup's memory controller.
> +	 */
> +	__u32 charge_fd;
> +};
> +
> =C2=A0#define DMA_BUF_BASE		'b'
> =C2=A0#define DMA_BUF_IOCTL_SYNC	_IOW(DMA_BUF_BASE, 0, struct
> dma_buf_sync)
> =C2=A0
> @@ -179,5 +204,6 @@ struct dma_buf_import_sync_file {
> =C2=A0#define DMA_BUF_SET_NAME_B	_IOW(DMA_BUF_BASE, 1, __u64)
> =C2=A0#define DMA_BUF_IOCTL_EXPORT_SYNC_FILE	_IOWR(DMA_BUF_BASE, 2,
> struct dma_buf_export_sync_file)
> =C2=A0#define DMA_BUF_IOCTL_IMPORT_SYNC_FILE	_IOW(DMA_BUF_BASE, 3, struct
> dma_buf_import_sync_file)
> +#define DMA_BUF_IOCTL_XFER_CHARGE	_IOW(DMA_BUF_BASE, 4, struct
> dma_buf_transfer_charge)
> =C2=A0
> =C2=A0#endif
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 17fdefc56b97..3e717b5663c8 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5752,6 +5752,48 @@ void mem_cgroup_cancel_dmabuf(struct
> mem_cgroup *memcg, unsigned int nr_pages)
> =C2=A0}
> =C2=A0EXPORT_SYMBOL_GPL(mem_cgroup_cancel_dmabuf);
> =C2=A0
> +/**
> + * mem_cgroup_transfer_charge - move a charge between memcgs
> + * @ptr_memcg: pointer to the memcg to transfer from
> + * @new_memcg: target memcg; caller must hold a reference
> + * @item: stat counter to adjust
> + * @nr_pages: number of pages to transfer
> + *
> + * Transfers @nr_pages of charge from *@ptr_memcg to @new_memcg and,
> on
> + * success, stores @new_memcg in *@ptr_memcg.
> + *
> + * Updates to *@ptr_memcg must be serialized by the caller.
> + * Returns %true on success, %false if the charge against @new_memcg
> + * failed.
> + */
> +bool mem_cgroup_transfer_charge(struct mem_cgroup **ptr_memcg,
> +				struct mem_cgroup *new_memcg,
> +				enum memcg_stat_item item,
> +				unsigned int nr_pages)
> +{
> +	struct mem_cgroup *old_memcg =3D *ptr_memcg;
> +
> +	if (!new_memcg || mem_cgroup_disabled())
> +		return true;
> +
> +	if (try_charge(new_memcg, GFP_KERNEL, nr_pages))
> +		return false;
> +
> +	mod_memcg_state(new_memcg, item, nr_pages);
> +	css_get(&new_memcg->css);
> +	*ptr_memcg =3D new_memcg;
> +
> +	if (old_memcg) {
> +		/* Uncharge old cgroup */
> +		mod_memcg_state(old_memcg, item, -nr_pages);
> +		if (!mem_cgroup_is_root(old_memcg))
> +			refill_stock(old_memcg, nr_pages);
> +		mem_cgroup_put(old_memcg);
> +	}
> +
> +	return true;
> +}

=20
This has the same lifetime issue as patch 1. After a transfer, the
buffer pins new_memcg until it is released, and with cross-process
transfers the target may be removed before the
buffer is. Since this helper is meant to be reused by other subsystems,
would it be better to have it take and store an obj_cgroup from the
start?

Thanks,
Thomas


> +
> =C2=A0/**
> =C2=A0 * mem_cgroup_uncharge_dmabuf - uncharge a dma-buf from its memcg
> =C2=A0 * @dmabuf: buffer to uncharge
