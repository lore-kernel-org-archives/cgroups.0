From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] blk-iocost: initialize rqos before accessing it
Date: Fri, 24 Feb 2023 19:51:26 +0100
Message-ID: <20230224185126.bxkreilofbp2t4on@blackpad>
References: <20230224160714.172884-1-leitao@debian.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6m3yodbwxciinozt"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1677264693; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gXQvhEuj9SoWq4xHpYapHJn0TS7BQOaz7ZvYAaP4S+A=;
        b=dEYBd4cfzxjGTUmflHKaPPcrCa5DIXUW5PXOlZp25Ohjug6EGBHiNxCC4c2PxqyS/2Ey4z
        mhwRMO46LgnpEdxuUAGUYrz8/3/ZV12IG2ECnZBLqPvbjZV4TozoHBZaimvafQ/+J2k4U7
        SSFL+6vupQbD8c5MFDRjWifxKXfR0+0=
Content-Disposition: inline
In-Reply-To: <20230224160714.172884-1-leitao-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Breno Leitao <leitao-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, aherrmann-l3A5Bk7waGM@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, leit-b10kYP2dOMg@public.gmane.org


--6m3yodbwxciinozt
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 24, 2023 at 08:07:14AM -0800, Breno Leitao <leitao-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org> =
wrote:
> ---
>  block/blk-iocost.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Well done.

Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>


[...]
> 	blk_iocost_init (include/asm-generic/qspinlock.h:128
> 			 include/linux/spinlock.h:203
> 			 include/linux/spinlock_api_smp.h:158
> 			 include/linux/spinlock.h:400
> 			 block/blk-iocost.c:2884)
> 	ioc_qos_write (block/blk-iocost.c:3198)
> 	? kretprobe_perf_func (kernel/trace/trace_kprobe.c:1566)
> 	? kernfs_fop_write_iter (include/linux/slab.h:584 fs/kernfs/file.c:311)
> 	? __kmem_cache_alloc_node (mm/slab.h:? mm/slub.c:3452 mm/slub.c:3491)
> 	? _copy_from_iter (arch/x86/include/asm/uaccess_64.h:46
> 			   arch/x86/include/asm/uaccess_64.h:52
> 			   lib/iov_iter.c:183 lib/iov_iter.c:628)
> 	? kretprobe_dispatcher (kernel/trace/trace_kprobe.c:1693)
> 	cgroup_file_write (kernel/cgroup/cgroup.c:4061)
> 	kernfs_fop_write_iter (fs/kernfs/file.c:334)
> 	vfs_write (include/linux/fs.h:1849 fs/read_write.c:491
> 		   fs/read_write.c:584)
> 	ksys_write (fs/read_write.c:637)
> 	do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
> 	entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)

BTW, out of curiosity what tool did you use to list stack with line
numbers?

Thanks,
Michal

--6m3yodbwxciinozt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY/kHFAAKCRAkDQmsBEOq
uZA8APwKEgRDcDxvVYqITHL+eSPHCCTuTseSO6af4mz3xtDDPAD9F5C04O0o8i2A
Cy6l5UzdFQQ+hamXG1WXrD52wGyWbQI=
=Ko1G
-----END PGP SIGNATURE-----

--6m3yodbwxciinozt--
