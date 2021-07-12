From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup1: fix leaked context root causing sporadic NULL
 deref in LTP
Date: Mon, 12 Jul 2021 07:34:18 -1000
Message-ID: <YOx9GkxAGwAb3Yyr@slm.duckdns.org>
References: <20210616125157.438837-1-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=dq1jvDdXTK3hPVpaflQY/7pmeNVzVpqqMkyrGDnxofw=;
        b=Xutdy37M5pl0qFk6+hXl+vOgxLdLFCTRAj4GAgtIQr9f/JGHN1SUCqafTq7GC3fJJZ
         jNofrMKljnNlSUTeihaCuJOyvZadgSHtTjrQlPpQj28Ng/YPym5cAin3UkVdsXOPZ0m6
         /9Cf5i/HQ8ODSJBuF1Ka+o+HPyHbzyWqdCjoqAk1jRm/aI0RxO9Ea6maU4L/3GNi69R+
         6c5KyhsMJmudDz+IMyngx2FlVmPHXdE0pEZS0XWe+Wv7FmSAylo+HjUihYJKdttMwid9
         +g8AobcYGNmnq+2LgfD0oTUJo9sAjV2zBGcCXQvo6XDNkjFT+Qa5ZPIRyr2wfyp9/rh+
         9uyA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210616125157.438837-1-paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Purdie <richard.purdie-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>

On Wed, Jun 16, 2021 at 08:51:57AM -0400, Paul Gortmaker wrote:
> Richard reported sporadic (roughly one in 10 or so) null dereferences and
> other strange behaviour for a set of automated LTP tests.  Things like:
>=20
>    BUG: kernel NULL pointer dereference, address: 0000000000000008
>    #PF: supervisor read access in kernel mode
>    #PF: error_code(0x0000) - not-present page
>    PGD 0 P4D 0
>    Oops: 0000 [#1] PREEMPT SMP PTI
>    CPU: 0 PID: 1516 Comm: umount Not tainted 5.10.0-yocto-standard #1
>    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-48=
-gd9c812dda519-prebuilt.qemu.org 04/01/2014
>    RIP: 0010:kernfs_sop_show_path+0x1b/0x60
>=20
> ...or these others:
>=20
>    RIP: 0010:do_mkdirat+0x6a/0xf0
>    RIP: 0010:d_alloc_parallel+0x98/0x510
>    RIP: 0010:do_readlinkat+0x86/0x120
>=20
> There were other less common instances of some kind of a general scribble
> but the common theme was mount and cgroup and a dubious dentry triggering
> the NULL dereference.  I was only able to reproduce it under qemu by
> replicating Richard's setup as closely as possible - I never did get it
> to happen on bare metal, even while keeping everything else the same.
>=20
> In commit 71d883c37e8d ("cgroup_do_mount(): massage calling conventions")
> we see this as a part of the overall change:
>=20
>    --------------
>            struct cgroup_subsys *ss;
>    -       struct dentry *dentry;
>=20
>    [...]
>=20
>    -       dentry =3D cgroup_do_mount(&cgroup_fs_type, fc->sb_flags, root,
>    -                                CGROUP_SUPER_MAGIC, ns);
>=20
>    [...]
>=20
>    -       if (percpu_ref_is_dying(&root->cgrp.self.refcnt)) {
>    -               struct super_block *sb =3D dentry->d_sb;
>    -               dput(dentry);
>    +       ret =3D cgroup_do_mount(fc, CGROUP_SUPER_MAGIC, ns);
>    +       if (!ret && percpu_ref_is_dying(&root->cgrp.self.refcnt)) {
>    +               struct super_block *sb =3D fc->root->d_sb;
>    +               dput(fc->root);
>                    deactivate_locked_super(sb);
>                    msleep(10);
>                    return restart_syscall();
>            }
>    --------------
>=20
> In changing from the local "*dentry" variable to using fc->root, we now
> export/leave that dentry pointer in the file context after doing the dput=
()
> in the unlikely "is_dying" case.   With LTP doing a crazy amount of back =
to
> back mount/unmount [testcases/bin/cgroup_regression_5_1.sh] the unlikely
> becomes slightly likely and then bad things happen.
>=20
> A fix would be to not leave the stale reference in fc->root as follows:
>=20
>    --------------
>   =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dput(fc->root);
>   +               fc->root =3D NULL;
>   =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0deactivate_locked_super=
(sb);
>    --------------
>=20
> ...but then we are just open-coding a duplicate of fc_drop_locked() so we
> simply use that instead.
>=20
> Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org      # v5.1+
> Reported-by: Richard Purdie <richard.purdie-hQyY1W1yCW8ekmWlsbkhG0B+6BGkL=
q7r@public.gmane.org>
> Fixes: 71d883c37e8d ("cgroup_do_mount(): massage calling conventions")
> Signed-off-by: Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@publ=
ic.gmane.org>

I dropped the ball on this and this didn't get pushed. Re-applied to
for-5.14-fixes. Will send out in a few days.

Thanks.

--=20
tejun
