From: Li Zefan <lizf.kern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference
 at 0000003c
Date: Sun, 16 Feb 2014 04:17:52 +0800
Message-ID: <52FFCB70.3090600@gmail.com>
References: <20140215124212.GA8782@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=/PsnpYTemdUjCaXVjpNYBBBswTUDjoBDEass7vH7jUw=;
        b=BDvXi8HmWYPEvES4WDApFPNtxyteovcVO757kiDagU8ur+vH8PI8NO50a9XPckeDJF
         Ql2i3a0HHnSbSlaDNL54VEwEMf7CV88KAmYGVCBkY8WQD1MyWvyeT1wljdj0u/+iBGA7
         cj4ZcLdR/ZE+fYon84gaLbHYRPuhKyiW1s5vy/CHBPcZsw3bZ/0APqtZoK+6mlGCte7+
         OlZO6a0cuUImNNriiyIgCHaOOZNb77dQFfsrypEr4O/Wd7DuNWOubTOiFp85J24+UWxg
         HO3hCGzBsZkgW+0MFI1YZGeJhoqMLCIu5QiUyFsmiuXvzxrqzcVkFGbDYCEthJbe1guW
         lf3A==
In-Reply-To: <20140215124212.GA8782@localhost>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

=E4=BA=8E 2014=E5=B9=B402=E6=9C=8815=E6=97=A5 20:42, Fengguang Wu =E5=86=
=99=E9=81=93:
> Greetings,
>=20
> I got the below dmesg and the first bad commit is
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
> commit de00ffa56ea3132c6013fc8f07133b8a1014cf53
> Author:     Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> AuthorDate: Tue Feb 11 11:52:48 2014 -0500
> Commit:     Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> CommitDate: Tue Feb 11 11:52:48 2014 -0500
>=20
>     cgroup: make cgroup_subsys->base_cftypes use cgroup_add_cftypes()
>    =20
>     Currently, cgroup_subsys->base_cftypes registration is different =
from
>     dynamic cftypes registartion.  Instead of going through
>     cgroup_add_cftypes(), cgroup_init_subsys() invokes
>     cgroup_init_cftsets() which makes use of cgroup_subsys->base_cfts=
et
>     which doesn't involve dynamic allocation.
>    =20
>     While avoiding dynamic allocation is somewhat nice, having two
>     separate paths for cftypes registration is nasty, especially as w=
e're
>     planning to add more operations during cftypes registration.
>    =20
>     This patch drops cgroup_init_cftsets() and cgroup_subsys->base_cf=
tset
>     and registers base_cftypes using cgroup_add_cftypes().  This is d=
one
>     as a separate step in cgroup_init() instead of a part of
>     cgroup_init_subsys().  This is because cgroup_init_subsys() can b=
e
>     called very early during boot when kmalloc() isn't available yet.
>    =20
>     Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>     Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>=20
> [    0.020000] Calibrating delay loop (skipped) preset value.. 5786.0=
0 BogoMIPS (lpj=3D28930000)
> [    0.020000] pid_max: default: 32768 minimum: 301
> [    0.020000] Mount-cache hash table entries: 512
> [    0.020000] BUG: unable to handle kernel NULL pointer dereference =
at 0000003c
> [    0.020000] IP: [<cc90b4ad>] cgroup_cfts_commit+0x27/0x1c1
> [    0.020000] *pdpt =3D 0000000000000000 *pde =3D f000ff53f000ff53=20
> [    0.020000] Oops: 0000 [#1] SMP=20
> [    0.020000] Modules linked in:
> [    0.020000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc2-n=
ext-20140212-02521-g4602175 #1
> [    0.020000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    0.020000] task: cd497910 ti: cd492000 task.ti: cd492000
> [    0.020000] EIP: 0060:[<cc90b4ad>] EFLAGS: 00210282 CPU: 0
> [    0.020000] EIP is at cgroup_cfts_commit+0x27/0x1c1
> [    0.020000] EAX: cd4b1d0c EBX: cf004fa0 ECX: 00000001 EDX: 0000000=
1
> [    0.020000] ESI: 00000000 EDI: cd9820d4 EBP: cd493fa4 ESP: cd493f7=
0
> [    0.020000]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [    0.020000] CR0: 8005003b CR2: 0000003c CR3: 0d96e000 CR4: 000006b=
0
> [    0.020000] Stack:
> [    0.020000]  cf004fa0 cd4b1d4c 00200246 cd9820d4 cc9d1129 0190c691=
 0000000c 000080d0
> [    0.020000]  cd493f90 cd493f90 cf004fa0 cd9820d4 cd4accc4 cd493fbc=
 cc90c6fc 00000000
> [    0.020000]  00000000 00000000 cd970800 cd493fcc cd78b646 00000000=
 00020800 cd493fe8
> [    0.020000] Call Trace:
> [    0.020000]  [<cc9d1129>] ? kmem_cache_alloc_trace+0x33f/0x3b7
> [    0.020000]  [<cc90c6fc>] cgroup_add_cftypes+0x8f/0xca
> [    0.020000]  [<cd78b646>] cgroup_init+0x6a/0x26a
> [    0.020000]  [<cd764d7d>] start_kernel+0x4d7/0x57a
> [    0.020000]  [<cd7642ef>] i386_start_kernel+0x92/0x96
> [    0.020000] Code: 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 28 e8 94 ab =
71 00 89 c7 8b 77 50 89 45 d8 8d 45 ec 89 45 ec 89 45 f0 b8 0c 1d 4b cd=
 88 55 e3 <8b> 5e 3c e8 c9 4d 71 00 85 ff 74 0e 31 c0 81 7e 3c c8 43 ec=
 cd
> [    0.020000] EIP: [<cc90b4ad>] cgroup_cfts_commit+0x27/0x1c1 SS:ESP=
 0068:cd493f70
> [    0.020000] CR2: 000000000000003c
> [    0.020000] ---[ end trace fd4743fe17bdbf8e ]---
> [    0.020000] Kernel panic - not syncing: Fatal exception
>=20

This is a corner case. If CGROUP_SCHED=3Dy but FAIR_GROUP_SCHED=3Dn && =
CFS_BANDWIDTH=3Dn &&
RT_GROUP_SCHED=3Dn:

static struct cftype cpu_files[] =3D {
        { }     /* terminate */
};

Should be fixed by the following change. Will test it and send out a fo=
rmal
patch on Monday.

It's 4 a.m on Sunday, and I lose sleep. :(

---
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 851251b..fa393d84 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2348,6 +2348,9 @@ int cgroup_add_cftypes(struct cgroup_subsys *ss, =
struct cftype *cfts)
 {
 	int ret;
=20
+	if (!cfts || cfts[0].name[0] =3D=3D '\0')
+		return 0;
+
 	ret =3D cgroup_init_cftypes(ss, cfts);
 	if (ret)
 		return ret;
