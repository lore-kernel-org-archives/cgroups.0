Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794469349;
	b=OYEFiq8qTUtzJOb/kvbnJ8ppDrXSOmCugiXIiJV91yb8xwh/JCcT2R70NP+i/Yckxq/P
	 5oE19zRXNY9lixk+3CX41OMYn5yK4pbRfpcrozNIMrracX2rtfhf8831KCNSadnKNfjGP
	 /oGFdCHezxlcbLKJQXEgC2odMWpIjuL3FRaxE5wI2qPyfcGbWM8BjDEAgjzw4jLorGj/1
	 FRvs8N4U2q4nRdWI7Uv8zGHP4yEuyeepRBAQOUxdjKQybPekwh1oMDtqlzGmZxXaorwdo
	 63Wsg9XIDa/Hx7p9QJPtB91xAhnDq/QCI7QKpKatUyUujJ6N7W3zKN3tJd52nMveNQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794469349;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Subject:
	 From:To:Cc:Date:In-Reply-To:References:Organization:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=Rs2hBZxIechWP3+xKvaf/kEVNc+3c4DOuwLz0FXAnSE=;
	b=bi7AHlzjNE+urgqKeFgSChlwO/4VDxKmuCFJx4lz8+UQs5l816GoK+UKVEWxKQBtygE4
	 pIJrrGzeYzjaZRJ/QyjFlHTBnEBr8RJ8hVOECkYliyfRqNq5m4Wgo28OZ7yJ2y6VH08WT
	 3HFOO9W3495QV3dZuLVSx2lCvrwGHU2XeLMpPR1IXKwC671mdha9ReKLFjFlLbnngfqRb
	 eN3h+Cp6C01r8PFsgE1BGebI/OUQ2xJKD8GFK9OHGrpAyfq5e0od4yk4xo45wk9PECUzA
	 s+1x1cH3vhPgaWIVTkzL4O0Q2yP+xLxWyjkz22CEv/ddazmp8fei9VPYFeYjrbc2dOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=cfsg1+bw;
	arc=none smtp.remote-ip=192.198.163.9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CF8606A32D;
	Thu, 12 Nov 2026 07:42:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54CF8606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=cfsg1+bw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794469348; x=1826005348;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=hGndxzbseBzywUGDccqYsx3L7yMNZ6Jqs6R1bU7uG2c=;
  b=cfsg1+bwwxPuTKYuiaorr1LHUt+TcbvaCxpmHAQJZOAoG8uzkSqUHuRf
   ++9GyK2LQw6KiOs3Wkkb2eMKBwtgoLqWBlqG4whrapq/iTbaCjqe4/Tz0
   jZrbMkZI+rdHYKebFrrP0BdS8R/z+uHBBdQWJRcqA9iB0Jeqot9PY8BW2
   wx9XvKBhySQi7B+XdIiIVunwKr5XZZ9dmyYC+QK9w3d3nxmk8ENajDPdM
   SrqUT3Ig6P+3FYzswBmW7eo5Pe6CGkZKH38er56zzzhn2kvB8XTrPAwNe
   QfSIZxdbGcfa6VNbm8SQohgFUe0xNEyif1rvxDWPKHxww4tQ2s1snFU2E
   w==;
X-CSE-ConnectionGUID: rdE8kiIjTKSiECEdF5ipfw==
X-CSE-MsgGUID: ueeDw42pQGGCY3dHYRu+SQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11963"; a="3127967"
X-IronPort-AV: E=Sophos;i="6.27,209,1787036400"; 
   d="scan'208";a="3127967"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 23:42:27 -0800
X-CSE-ConnectionGUID: h3by7uVORvqywSV7hmpQLA==
X-CSE-MsgGUID: QFIxVnq6RkCK6YG12kZ61Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,209,1787036400"; 
   d="scan'208";a="8549938"
Received: from carterle-desk.ger.corp.intel.com (HELO [10.245.244.5]) ([10.245.244.5])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 23:42:21 -0800
Message-ID: <3fdad4e17008cd59bc528ab22e34c0c913a6d50f.camel@linux.intel.com>
Subject: Re: [Linaro-mm-sig] [PATCH v4 2/8] dma-heap: charge dma-buf memory
 via explicit memcg
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
Date: Thu, 12 Nov 2026 08:42:18 +0100
In-Reply-To: <20261104-v2_20230123_tjmercier_google_com-v4-2-1819a017000b@redhat.com>
References: 
	<20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
	 <20261104-v2_20230123_tjmercier_google_com-v4-2-1819a017000b@redhat.com>
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
> On embedded platforms a central process often allocates dma-buf
> memory on behalf of client applications. Without a way to
> attribute the charge to the requesting client's cgroup, the
> cost lands on the allocator, making per-cgroup memory limits
> ineffective for the actual consumers.
>=20
> Add charge_fd to struct dma_heap_allocation_data. When set to
> a valid pidfd or cgroupfd, DMA_HEAP_IOCTL_ALLOC resolves the target
> task's or cgroup's memcg and charges the buffer there via
> mem_cgroup_reserve_dmabuf() inside dma_heap_ioctl_allocate(). The
> resolved memcg is passed through dma_buf_export_info so that
> dma_buf_export() stores it and updates the MEMCG_DMABUF stat.
> Without charge_fd, and with the mem_accounting module parameter
> enabled, the buffer is charged to the allocator's own cgroup.
> The __GPF_ACCOUNT flag is removed from system heap allocations
> to avoid double counting.
>=20
> Usage examples:
>=20
> =C2=A0 1. Central allocator charging to a client at allocation time.
> =C2=A0=C2=A0=C2=A0=C2=A0 The allocator knows the client's PID (e.g., from=
 binder's
> =C2=A0=C2=A0=C2=A0=C2=A0 sender_pid) and uses pidfd to attribute the char=
ge:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pid_t client_pid =3D txn->sender_pid=
;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int pidfd =3D pidfd_open(client_pid,=
 0);
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct dma_heap_allocation_data allo=
c =3D {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .len=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D buffer_size,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .fd_flags=C2=
=A0=C2=A0=C2=A0 =3D O_RDWR | O_CLOEXEC,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .charge_fd=
=C2=A0=C2=A0 =3D pidfd,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 };
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC,=
 &alloc);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 close(pidfd);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* alloc.fd is now charged to client=
's cgroup */
>=20
> =C2=A0 2. Default allocation (no pidfd, mem_accounting=3D1).
> =C2=A0=C2=A0=C2=A0=C2=A0 When charge_fd is not set and the mem_accounting=
 module
> =C2=A0=C2=A0=C2=A0=C2=A0 parameter is enabled, the buffer is charged to t=
he allocator's
> =C2=A0=C2=A0=C2=A0=C2=A0 own cgroup:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct dma_heap_allocation_data allo=
c =3D {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .len=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 =3D buffer_size,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .fd_flags =
=3D O_RDWR | O_CLOEXEC,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 };
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC,=
 &alloc);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* charged to current process's cgro=
up */
>=20
> Current limitations:
>=20
> =C2=A0- Single-owner model: a dma-buf carries one memcg charge regardless
> of
> =C2=A0=C2=A0 how many processes share it. Means only the first owner (and
> exporter)
> =C2=A0=C2=A0 of the shared buffer bears the charge.
> =C2=A0- Only memcg accounting supported. While this makes sense for syste=
m
> =C2=A0=C2=A0 heap buffers, other heaps (e.g., CMA heaps) will require
> selectively
> =C2=A0=C2=A0 charging also for the dmem controller.
>=20
> Signed-off-by: Albert Esteve <aesteve@redhat.com>
> ---
> =C2=A0Documentation/admin-guide/cgroup-v2.rst |=C2=A0 5 ++--
> =C2=A0drivers/dma-buf/dma-buf.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 5 ++++
> =C2=A0drivers/dma-buf/dma-heap.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 28 +++++++++++++++++---
> =C2=A0drivers/dma-buf/heaps/cma_heap.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0 3 ++-
> =C2=A0drivers/dma-buf/heaps/system_heap.c=C2=A0=C2=A0=C2=A0=C2=A0 | 21 ++=
+++++++++----
> =C2=A0drivers/tee/tee_heap.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 3 ++-
> =C2=A0include/linux/dma-buf.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 4 +++
> =C2=A0include/linux/dma-heap.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 3 ++-
> =C2=A0include/linux/memcontrol.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 7 +++++
> =C2=A0include/uapi/linux/dma-heap.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 7 +++++
> =C2=A0mm/memcontrol.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 | 47
> +++++++++++++++++++++++++++++++++
> =C2=A011 files changed, 120 insertions(+), 13 deletions(-)
>=20
> diff --git a/Documentation/admin-guide/cgroup-v2.rst
> b/Documentation/admin-guide/cgroup-v2.rst
> index a3265a4a953e..66ddba678784 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1663,8 +1663,9 @@ The following nested keys are defined.
> =C2=A0		structures.
> =C2=A0
> =C2=A0	=C2=A0 dmabuf (npn)
> -		Amount of memory used for exported DMA buffers
> allocated by the cgroup.
> -		Stays with the allocating cgroup regardless of how
> the buffer is shared.
> +		Amount of memory used for exported DMA buffers
> allocated by or on
> +		behalf of the cgroup. Stays with the allocating
> cgroup regardless
> +		of how the buffer is shared.

This doesn't sound right. Graphics buffers exported as DMA buffers are
typically charged elsewhere, like gpu_active, and a transfer of their
charge would likely stay in that key? To be consistent, shouldn't this
be related to dma-heap memory and called dmaheap or something similar.
We should have a tighter definition of exactly what memory is to be
registered here.

Also says "Stays with the allocating cgroup regardless of how the
buffer is shared", which isn't correct after the series? Perhaps that's
changed in a later patch.

Thanks,
Thomas




> =C2=A0
> =C2=A0	=C2=A0 workingset_refault_anon
> =C2=A0		Number of refaults of previously evicted anonymous
> pages.
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 1c6b9cee7ac2..837666273550 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -714,6 +714,7 @@ struct dma_buf *dma_buf_export(const struct
> dma_buf_export_info *exp_info)
> =C2=A0	struct dma_resv *resv =3D exp_info->resv;
> =C2=A0	struct file *file;
> =C2=A0	size_t alloc_size =3D sizeof(struct dma_buf);
> +	unsigned int nr_pages =3D PAGE_ALIGN(exp_info->size) >>
> PAGE_SHIFT;
> =C2=A0	int ret;
> =C2=A0
> =C2=A0	if (WARN_ON(!exp_info->priv || !exp_info->ops
> @@ -750,6 +751,7 @@ struct dma_buf *dma_buf_export(const struct
> dma_buf_export_info *exp_info)
> =C2=A0	dmabuf->size =3D exp_info->size;
> =C2=A0	dmabuf->exp_name =3D exp_info->exp_name;
> =C2=A0	dmabuf->owner =3D exp_info->owner;
> +	dmabuf->memcg =3D exp_info->memcg;
> =C2=A0	spin_lock_init(&dmabuf->name_lock);
> =C2=A0	init_waitqueue_head(&dmabuf->poll);
> =C2=A0	dmabuf->cb_in.poll =3D dmabuf->cb_out.poll =3D &dmabuf->poll;
> @@ -771,6 +773,9 @@ struct dma_buf *dma_buf_export(const struct
> dma_buf_export_info *exp_info)
> =C2=A0
> =C2=A0	DMA_BUF_TRACE(trace_dma_buf_export, dmabuf);
> =C2=A0
> +	if (dmabuf->memcg)
> +		mod_memcg_state(dmabuf->memcg, MEMCG_DMABUF,
> nr_pages);
> +
> =C2=A0	return dmabuf;
> =C2=A0
> =C2=A0err_file:
> diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-heap.c
> index 8a6c2b6e0cc6..7bd416ae2c23 100644
> --- a/drivers/dma-buf/dma-heap.c
> +++ b/drivers/dma-buf/dma-heap.c
> @@ -10,6 +10,8 @@
> =C2=A0#include <linux/device.h>
> =C2=A0#include <linux/dma-buf.h>
> =C2=A0#include <linux/dma-heap.h>
> +#include <linux/memcontrol.h>
> +#include <linux/sched/mm.h>
> =C2=A0#include <linux/err.h>
> =C2=A0#include <linux/export.h>
> =C2=A0#include <linux/list.h>
> @@ -78,6 +80,7 @@ static struct dma_buf
> *dma_heap_ioctl_allocate(struct file *file, void *data)
> =C2=A0	struct dma_heap_allocation_data *heap_allocation =3D data;
> =C2=A0	struct dma_heap *heap =3D file->private_data;
> =C2=A0	struct dma_buf *dmabuf;
> +	struct mem_cgroup *memcg =3D NULL;
> =C2=A0	int fd;
> =C2=A0	size_t len;
> =C2=A0
> @@ -90,15 +93,34 @@ static struct dma_buf
> *dma_heap_ioctl_allocate(struct file *file, void *data)
> =C2=A0	if (heap_allocation->heap_flags &
> ~DMA_HEAP_VALID_HEAP_FLAGS)
> =C2=A0		return ERR_PTR(-EINVAL);
> =C2=A0
> +	if (heap_allocation->__padding !=3D 0)
> +		return ERR_PTR(-EINVAL);
> +
> +	if (heap_allocation->charge_fd) {
> +		memcg =3D mem_cgroup_get_from_fd(heap_allocation-
> >charge_fd);
> +		if (IS_ERR(memcg))
> +			return ERR_CAST(memcg);
> +	}
> +
> +	if (!memcg && mem_accounting)
> +		memcg =3D get_mem_cgroup_from_mm(current->mm);
> +
> =C2=A0	len =3D PAGE_ALIGN(heap_allocation->len);
> -	if (!len)
> +	if (!len) {
> +		mem_cgroup_put(memcg);
> =C2=A0		return ERR_PTR(-EINVAL);
> +	}
> =C2=A0
> =C2=A0	dmabuf =3D heap->ops->allocate(heap, len, heap_allocation-
> >fd_flags,
> -				=C2=A0=C2=A0=C2=A0=C2=A0 heap_allocation->heap_flags);
> +				=C2=A0=C2=A0=C2=A0=C2=A0 heap_allocation->heap_flags,
> memcg);
> =C2=A0
> -	if (IS_ERR(dmabuf))
> +	if (IS_ERR(dmabuf)) {
> +		mem_cgroup_put(memcg);
> =C2=A0		return dmabuf;
> +	}
> +
> +	if (memcg && !dmabuf->memcg)
> +		mem_cgroup_put(memcg);
> =C2=A0
> =C2=A0	fd =3D get_unused_fd_flags(heap_allocation->fd_flags);
> =C2=A0	if (fd < 0) {
> diff --git a/drivers/dma-buf/heaps/cma_heap.c b/drivers/dma-
> buf/heaps/cma_heap.c
> index 3fb4b946c91a..04de88b468a8 100644
> --- a/drivers/dma-buf/heaps/cma_heap.c
> +++ b/drivers/dma-buf/heaps/cma_heap.c
> @@ -281,7 +281,8 @@ static const struct dma_buf_ops cma_heap_buf_ops
> =3D {
> =C2=A0static struct dma_buf *cma_heap_allocate(struct dma_heap *heap,
> =C2=A0					 unsigned long len,
> =C2=A0					 u32 fd_flags,
> -					 u64 heap_flags)
> +					 u64 heap_flags,
> +					 struct mem_cgroup *memcg)
> =C2=A0{
> =C2=A0	struct cma_heap *cma_heap =3D dma_heap_get_drvdata(heap);
> =C2=A0	struct cma_heap_buffer *buffer;
> diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-
> buf/heaps/system_heap.c
> index c8959eadc71d..2bd245e1eab8 100644
> --- a/drivers/dma-buf/heaps/system_heap.c
> +++ b/drivers/dma-buf/heaps/system_heap.c
> @@ -17,6 +17,7 @@
> =C2=A0#include <linux/err.h>
> =C2=A0#include <linux/highmem.h>
> =C2=A0#include <linux/mem_encrypt.h>
> +#include <linux/memcontrol.h>
> =C2=A0#include <linux/mm.h>
> =C2=A0#include <linux/set_memory.h>
> =C2=A0#include <linux/module.h>
> @@ -388,8 +389,6 @@ static struct page
> *alloc_largest_available(unsigned long size,
> =C2=A0		if (max_order < orders[i])
> =C2=A0			continue;
> =C2=A0		flags =3D order_flags[i];
> -		if (mem_accounting)
> -			flags |=3D __GFP_ACCOUNT;
> =C2=A0		page =3D alloc_pages(flags, orders[i]);
> =C2=A0		if (!page)
> =C2=A0			continue;
> @@ -401,11 +400,13 @@ static struct page
> *alloc_largest_available(unsigned long size,
> =C2=A0static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
> =C2=A0					=C2=A0=C2=A0=C2=A0 unsigned long len,
> =C2=A0					=C2=A0=C2=A0=C2=A0 u32 fd_flags,
> -					=C2=A0=C2=A0=C2=A0 u64 heap_flags)
> +					=C2=A0=C2=A0=C2=A0 u64 heap_flags,
> +					=C2=A0=C2=A0=C2=A0 struct mem_cgroup
> *memcg)
> =C2=A0{
> =C2=A0	struct system_heap_buffer *buffer;
> =C2=A0	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
> =C2=A0	unsigned long size_remaining =3D len;
> +	unsigned int nr_pages =3D PAGE_ALIGN(len) >> PAGE_SHIFT;
> =C2=A0	unsigned int max_order =3D orders[0];
> =C2=A0	struct system_heap_priv *priv =3D dma_heap_get_drvdata(heap);
> =C2=A0	bool cc_shared =3D priv->cc_shared;
> @@ -416,10 +417,15 @@ static struct dma_buf
> *system_heap_allocate(struct dma_heap *heap,
> =C2=A0	struct page *page, *tmp_page;
> =C2=A0	int i, ret =3D -ENOMEM;
> =C2=A0
> -	buffer =3D kzalloc_obj(*buffer);
> -	if (!buffer)
> +	if (!mem_cgroup_reserve_dmabuf(memcg, GFP_KERNEL, nr_pages))
> =C2=A0		return ERR_PTR(-ENOMEM);
> =C2=A0
> +	buffer =3D kzalloc_obj(*buffer);
> +	if (!buffer) {
> +		ret =3D -ENOMEM;
> +		goto cancel_charge;
> +	}
> +
> =C2=A0	INIT_LIST_HEAD(&buffer->attachments);
> =C2=A0	mutex_init(&buffer->lock);
> =C2=A0	buffer->heap =3D heap;
> @@ -473,11 +479,14 @@ static struct dma_buf
> *system_heap_allocate(struct dma_heap *heap,
> =C2=A0	exp_info.size =3D buffer->len;
> =C2=A0	exp_info.flags =3D fd_flags;
> =C2=A0	exp_info.priv =3D buffer;
> +	if (memcg)
> +		exp_info.memcg =3D memcg;
> =C2=A0	dmabuf =3D dma_buf_export(&exp_info);
> =C2=A0	if (IS_ERR(dmabuf)) {
> =C2=A0		ret =3D PTR_ERR(dmabuf);
> =C2=A0		goto free_pages;
> =C2=A0	}
> +
> =C2=A0	return dmabuf;
> =C2=A0
> =C2=A0free_pages:
> @@ -498,6 +507,8 @@ static struct dma_buf
> *system_heap_allocate(struct dma_heap *heap,
> =C2=A0	list_for_each_entry_safe(page, tmp_page, &pages, lru)
> =C2=A0		__free_pages(page, compound_order(page));
> =C2=A0	kfree(buffer);
> +cancel_charge:
> +	mem_cgroup_cancel_dmabuf(memcg, nr_pages);
> =C2=A0
> =C2=A0	return ERR_PTR(ret);
> =C2=A0}
> diff --git a/drivers/tee/tee_heap.c b/drivers/tee/tee_heap.c
> index 007c00156520..83e2fbd6960b 100644
> --- a/drivers/tee/tee_heap.c
> +++ b/drivers/tee/tee_heap.c
> @@ -167,7 +167,8 @@ static const struct dma_buf_ops tee_heap_buf_ops
> =3D {
> =C2=A0
> =C2=A0static struct dma_buf *tee_dma_heap_alloc(struct dma_heap *heap,
> =C2=A0					=C2=A0 unsigned long len, u32
> fd_flags,
> -					=C2=A0 u64 heap_flags)
> +					=C2=A0 u64 heap_flags,
> +					=C2=A0 struct mem_cgroup *memcg)
> =C2=A0{
> =C2=A0	struct tee_dma_heap *h =3D dma_heap_get_drvdata(heap);
> =C2=A0	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index 23ec0ff23fba..85dd747c9b36 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -505,6 +505,9 @@ struct dma_buf_attachment {
> =C2=A0 * @flags:	mode flags for the file
> =C2=A0 * @resv:	reservation-object, NULL to allocate default one
> =C2=A0 * @priv:	Attach private data of allocator to this buffer
> + * @memcg:	memcg to charge for this buffer's memory. Set only
> for
> + *		buffers backed by system memory where @size reflects
> the
> + *		actual allocation in bytes.
> =C2=A0 *
> =C2=A0 * This structure holds the information required to export the
> buffer. Used
> =C2=A0 * with dma_buf_export() only.
> @@ -517,6 +520,7 @@ struct dma_buf_export_info {
> =C2=A0	int flags;
> =C2=A0	struct dma_resv *resv;
> =C2=A0	void *priv;
> +	struct mem_cgroup *memcg;
> =C2=A0};
> =C2=A0
> =C2=A0/**
> diff --git a/include/linux/dma-heap.h b/include/linux/dma-heap.h
> index 648328a64b27..2d69f8432bd2 100644
> --- a/include/linux/dma-heap.h
> +++ b/include/linux/dma-heap.h
> @@ -23,7 +23,8 @@ struct dma_heap_ops {
> =C2=A0	struct dma_buf *(*allocate)(struct dma_heap *heap,
> =C2=A0				=C2=A0=C2=A0=C2=A0 unsigned long len,
> =C2=A0				=C2=A0=C2=A0=C2=A0 u32 fd_flags,
> -				=C2=A0=C2=A0=C2=A0 u64 heap_flags);
> +				=C2=A0=C2=A0=C2=A0 u64 heap_flags,
> +				=C2=A0=C2=A0=C2=A0 struct mem_cgroup *memcg);
> =C2=A0};
> =C2=A0
> =C2=A0/**
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 4d1e82cf0833..f8ec751b7d7b 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -671,6 +671,8 @@ int mem_cgroup_charge_hugetlb(struct folio*
> folio, gfp_t gfp);
> =C2=A0int mem_cgroup_swapin_charge_folio(struct folio *folio, unsigned
> short id,
> =C2=A0				=C2=A0=C2=A0 struct mm_struct *mm, gfp_t gfp);
> =C2=A0
> +struct mem_cgroup *mem_cgroup_get_from_fd(int fd);
> +
> =C2=A0bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg, gfp_t gfp,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int nr_pages);
> =C2=A0
> @@ -1178,6 +1180,11 @@ static inline int
> mem_cgroup_swapin_charge_folio(struct folio *folio,
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0
> +static inline struct mem_cgroup *mem_cgroup_get_from_fd(int fd)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
> +
> =C2=A0static inline bool mem_cgroup_reserve_dmabuf(struct mem_cgroup
> *memcg,
> =C2=A0					=C2=A0=C2=A0=C2=A0=C2=A0 gfp_t gfp,
> =C2=A0					=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int nr_pages)
> diff --git a/include/uapi/linux/dma-heap.h b/include/uapi/linux/dma-
> heap.h
> index a4cf716a49fa..bfcd1c25bc7e 100644
> --- a/include/uapi/linux/dma-heap.h
> +++ b/include/uapi/linux/dma-heap.h
> @@ -29,6 +29,11 @@
> =C2=A0 *			handle to the allocated dma-buf
> =C2=A0 * @fd_flags:		file descriptor flags used when allocating
> =C2=A0 * @heap_flags:		flags passed to heap
> + * @charge_fd:		optional pidfd or cgroupfd whose cgroup
> should be
> + *			charged for this allocation; 0 means charge
> the calling
> + *			process's cgroup when the mem_accounting
> module parameter
> + *			is enabled, or skip charging otherwise
> + * @__padding:		reserved, must be zero
> =C2=A0 *
> =C2=A0 * Provided by userspace as an argument to the ioctl
> =C2=A0 */
> @@ -37,6 +42,8 @@ struct dma_heap_allocation_data {
> =C2=A0	__u32 fd;
> =C2=A0	__u32 fd_flags;
> =C2=A0	__u64 heap_flags;
> +	__u32 charge_fd;
> +	__u32 __padding;
> =C2=A0};
> =C2=A0
> =C2=A0#define DMA_HEAP_IOC_MAGIC		'H'
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e53dd7eebc3b..17fdefc56b97 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5661,6 +5661,53 @@ void mem_cgroup_flush_workqueue(void)
> =C2=A0	flush_workqueue(memcg_wq);
> =C2=A0}
> =C2=A0
> +/**
> + * mem_cgroup_get_from_fd - resolve a memcg from a cgroupfd or pidfd
> + * @fd: file descriptor (cgroupfd or pidfd)
> + *
> + * Tries @fd as a cgroupfd first; if that fails, tries it as a
> pidfd.
> + * On success returns a referenced memcg pointer. On failure returns
> + * an ERR_PTR.
> + */
> +struct mem_cgroup *mem_cgroup_get_from_fd(int fd)
> +{
> +	struct cgroup_subsys_state *css;
> +	struct mem_cgroup *memcg;
> +	struct cgroup *cgrp;
> +	struct task_struct *task;
> +	struct mm_struct *mm;
> +	unsigned int pidfd_flags;
> +
> +	cgrp =3D cgroup_get_from_fd(fd);
> +	if (!IS_ERR(cgrp)) {
> +		rcu_read_lock();
> +		css =3D cgroup_css(cgrp, &memory_cgrp_subsys);
> +		if (!css || !css_tryget_online(css)) {
> +			rcu_read_unlock();
> +			cgroup_put(cgrp);
> +			return ERR_PTR(-ENOENT);
> +		}
> +
> +		memcg =3D mem_cgroup_from_css(css);
> +		rcu_read_unlock();
> +		cgroup_put(cgrp);
> +		return memcg;
> +	}
> +
> +	task =3D pidfd_get_task(fd, &pidfd_flags);
> +	if (IS_ERR(task))
> +		return ERR_CAST(task);
> +
> +	mm =3D get_task_mm(task);
> +	put_task_struct(task);
> +	if (!mm)
> +		return ERR_PTR(-ESRCH);
> +
> +	memcg =3D get_mem_cgroup_from_mm(mm);
> +	mmput(mm);
> +	return memcg ?: ERR_PTR(-ENOENT);
> +}
> +
> =C2=A0/**
> =C2=A0 * mem_cgroup_reserve_dmabuf - charge a memcg for a dma-buf
> allocation
> =C2=A0 * @memcg: memcg to charge (may be %NULL)
