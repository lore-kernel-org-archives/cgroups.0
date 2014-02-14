From: Li Zefan <lizf.kern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix top cgroup refcnt leak
Date: Fri, 14 Feb 2014 19:15:18 +0800
Message-ID: <52FDFAC6.1080802@gmail.com>
References: <52FDE393.6050607@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=C7f4crSumvJFd6HXZVYWwbtJzQNu3CrAmw1GHFhp/Dk=;
        b=s5FLDV/6ApmRIJHNOTNzrE4jk1+0rhgvTJOkNZUo7o0lIAVc6uhGLwlK8wswKtyC77
         oRQXygC3wdvw6LbaviMurbTERiirLZzSWVPmAtba31+B76pXCVXT17JLHt7NwPx3yi75
         UZXaz6n1etp7R0doG6TPLxIPxMuP8MMNx+YLSj5eyUCg9vzAaUF2jujdPvs1F7UZiPL4
         qX5eVKOCIku5DoGMQAuGpBHMpeIrXjdfertH1OHHMg28UK03cintVl5DG0VOVLB3Of/C
         GjgtQPX2RqBxztRpkeNSZD2wLSRvX6fAXW1zSQ+IVMhFvGs7YfOtNg3qcUMLyCF4Lhol
         rqbg==
In-Reply-To: <52FDE393.6050607-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="gb2312"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

=D3=DA 2014=C4=EA02=D4=C214=C8=D5 17:36, Li Zefan =D0=B4=B5=C0:
> If we mount the same cgroupfs in serveral mount points, and then
> umount all of them, kill_sb() will be called only once.
>=20
> Therefore it's wrong to increment top_cgroup's refcnt when we find
> an existing cgroup_root.
>=20
> Try:
> 	# mount -t cgroup -o cpuacct xxx /cgroup
> 	# mount -t cgroup -o cpuacct xxx /cgroup2
> 	# cat /proc/cgroups | grep cpuacct
> 	cpuacct 2       1       1
> 	# umount /cgroup
> 	# umount /cgroup2
> 	# cat /proc/cgroups | grep cpuacct
> 	cpuacct 2       1       1
>=20
> You'll see cgroupfs will never be freed.
>=20
> Also move this chunk of code upwards.
>=20
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  kernel/cgroup.c | 32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
>=20
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 37d94a2..5bfe738 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1498,6 +1498,22 @@ retry:
>  		bool name_match =3D false;
> =20
>  		/*
> +		 * A root's lifetime is governed by its top cgroup.  Zero
> +		 * ref indicate that the root is being destroyed.  Wait for
> +		 * destruction to complete so that the subsystems are free.
> +		 * We can use wait_queue for the wait but this path is
> +		 * super cold.  Let's just sleep for a bit and retry.
> +		 */
> +		if (!atomic_read(&root->top_cgroup.refcnt)) {

oops, this fix is wrong. We call kernfs_mount() without cgroup locks an=
d it
drops cgroup refcnt if failed.

I guess we need to bump the refcnt and then drop it after kernfs_mount(=
).
