From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: memcg missing charge when setting BPF
Date: Tue, 23 Jun 2020 21:30:21 -0700
Message-ID: <20200624043021.GA3669@carbon.dhcp.thefacebook.com>
References: <1139555701.2821292.1592970418462.ref@mail.yahoo.com>
 <1139555701.2821292.1592970418462@mail.yahoo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=j2101CErjOndZGUm/ygjJbsPSBU032t3FbmOjMUxhoE=;
 b=IyQta9mmaCNVA1OGp4EwEYPwsT3AitDcr9Wxj17xhEgSKcCzenO56hG33MtDKa/+rKfd
 4htzNBkOdUEynwXKkNflD5QlD2dwL3WNvrLZe4Hi/8QxrDyN402zFDBABbcthQvuhzIv
 6Rw20rpI5qpoF2MICAeW3emttMmYccFlaOE= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YI9ymdRiiHa+FT15ilKXN+zNYt3IVbTfgLFinUxjeZI=;
 b=WC997DORN03qqIliFGIVILO0nHiQq/A8Au7Ab4F/rlZVFlf8/xdzpIDbkCfYNfiSQjWkkSXLxTVdvhd0gr2avAOdXjl8QIhqE3/VhmL8O2Q+tKpYjmnM53o2uzoH98ywBbaQ9ivgLQeQ7Cj5X6sH5zKAQFR5yrE0UNaHboWywLk=
Content-Disposition: inline
In-Reply-To: <1139555701.2821292.1592970418462-sAHhhX/85wgbqTNvkayDYw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Xie Xun <xiexun162534-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "shenwenbosmile-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <shenwenbosmile-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hello Xie!

It's actually not a surprise, it's a known limitation/exception.
Partially it was so because historically there was no way to account
percpu memory, and some bpf maps can are using it quite extensively.

Fortunately, it changed recently, and 5.9 will likely get an ability
to account percpu memory. The latest version of the patchset I've actually
sent today:
https://lore.kernel.org/linux-mm/20200623184515.4132564-1-guro-b10kYP2dOMg@=
public.gmane.org/T/#m0be45dd71e6a238985181c213d9934731949c089

I also have a patchset in work which adds a memcg accounting of bpf memory
(programs and maps). I plan to send it upstream on the next week. If everyt=
hing
will go smoothly it might appear in 5.9 as well.

Unfortunately the magnitude of required changes does not allow to backport
these changes to older kernels.

Thanks!

PS I'll be completely offline till the end of the week. I'll respond all e-=
mail
on Monday, Jun 29th. Thanks!


On Wed, Jun 24, 2020 at 03:46:58AM +0000, Xie Xun wrote:
> Hello,
>=20
> I found that programs can consume much more memory than memcg limit by se=
tting BPF for many times. It's because that allocations during setting BPF =
are not charged by memcg.
>=20
>=20
> Below is how I did it:
>=20
> 1. Run Linux kernel in a QEMU virtual machine (x86_64) with 1GB physical =
memory.
> =A0=A0 The kernel is built with memcg and memcg kmem accounting enabled.
>=20
> 2. Create a docker (runC) container, with memory limit 100MB.
>=20
> =A0=A0 docker run --name debian --memory 100000000 --kernel-memory 500000=
00 \
> =A0=A0 debian:slim /bin/bash
>=20
> 3. In the container, run a program to set BPF for many times. I use prctl=
 to set BPF.
>=20
> =A0=A0 while(1)
> =A0=A0=A0=A0 {
> =A0=A0=A0=A0=A0=A0 prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &bpf);
> =A0=A0=A0=A0 }
>=20
> 4. Physical memory usage(the one by `free` or `top`) is increased by arou=
nd 40MB,
> =A0=A0 but memory usage of the container's memcg doesn't increase a lot (=
around 100KB).
>=20
> 5. Run several processes to set BPF, and almost all physical memory is co=
nsumed.
> =A0=A0 Sometimes some processes not in the container are also killed due =
to OOM.
>=20
> I also try this with user namespace on, and I can still kill host process=
es inside container in this way. So this problem may be dangerous for conta=
iners that based on cgroups.
>=20
>=20
> kernel version: 5.3.6
> kernel configuration: in attachment (CONFIG_MEMCG_KMEM is on)
>=20
>=20
> This blog also shows this problem: https://urldefense.proofpoint.com/v2/u=
rl?u=3Dhttps-3A__blog.xiexun.tech_break-2Dmemcg.html&d=3DDwIFaQ&c=3D5VD0RTt=
NlTh3ycd41b3MUw&r=3DjJYgtDM7QT-W-Fz_d29HYQ&m=3DIBhsN9u88bNDFoDHNutIMKB-YrCv=
COIvw-8z9RpB8RI&s=3DO1b3udJv7obq8vZ88-YPEDzs7hhGov3o_Txskn4IeyA&e=3D=20
>=20
>=20
> Cause of this problem:
>=20
> Memory allocations during setting BPF are not charged by memcg. For examp=
le,
> in kernel/bpf/core.c:bpf_prog_alloc, bpf_prog_alloc_no_stats and alloc_pe=
rcpu_gfp
> are called to allocate memory. However, neither of them are charged by me=
mcg.
> So if we trigger this path for many times, we can consume lots of memory,=
 without
> increasing our memcg usage.
>=20
> /* ------------ */
> struct bpf_prog *bpf_prog_alloc(unsigned int size, gfp_t gfp_extra_flags)
> {
> =A0=A0 =A0gfp_t gfp_flags =3D GFP_KERNEL | __GFP_ZERO | gfp_extra_flags;
> =A0=A0 =A0struct bpf_prog *prog;
> =A0=A0 =A0int cpu;
>=20
> =A0=A0 =A0prog =3D bpf_prog_alloc_no_stats(size, gfp_extra_flags);
> =A0=A0 =A0if (!prog)
> =A0=A0 =A0=A0=A0 =A0return NULL;
>=20
> =A0=A0 =A0prog->aux->stats =3D alloc_percpu_gfp(struct bpf_prog_stats, gf=
p_flags);
>=20
> =A0=A0 =A0/* ... */
>=20
> }
> /* ------------ */
>=20
>=20
> My program that sets BPF:
>=20
> /* ------------ */
> #include <unistd.h>
> #include <sys/prctl.h>
> #include <linux/prctl.h>
> #include <linux/seccomp.h>
> #include <linux/filter.h>
> #include <linux/audit.h>
> #include <linux/signal.h>
> #include <sys/ptrace.h>
> #include <stdio.h>
> #include <errno.h>
>=20
> int main()
> {
> =A0 struct sock_filter insns[] =3D
> =A0=A0=A0 {
> =A0=A0=A0=A0 {
> =A0=A0=A0=A0=A0 .code =3D 0x6,
> =A0=A0=A0=A0=A0 .jt =3D 0,
> =A0=A0=A0=A0=A0 .jf =3D 0,
> =A0=A0=A0=A0=A0 .k =3D SECCOMP_RET_ALLOW
> =A0=A0=A0=A0 }
> =A0=A0=A0 };
> =A0 struct sock_fprog bpf =3D
> =A0 {
> =A0=A0 .len =3D 1,
> =A0=A0 .filter =3D insns
> =A0 };
> =A0 int ret;
> =A0
> =A0 ret =3D prctl(PR_SET_NO_NEW_PRIVS, 1, NULL, 0, 0);
> =A0 if (ret)
> =A0=A0=A0 {
> =A0=A0=A0=A0=A0 printf("error1 %d\n", errno);
> =A0=A0=A0=A0=A0 return 1;
> =A0=A0=A0 }
> =A0 int count =3D 0;
> =A0 while (1)
> =A0=A0=A0 {
> =A0=A0=A0=A0=A0 ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &bpf);
> =A0=A0=A0=A0=A0 if (ret)
> =A0=A0=A0=A0=A0=A0=A0 {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 sleep(1);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 printf("error %d\n", errno);
> =A0=A0=A0=A0=A0=A0=A0 }
> =A0=A0=A0=A0=A0 else
> =A0=A0=A0=A0=A0=A0=A0 {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 count++;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 printf("ok %d\n", count);
> =A0=A0=A0=A0=A0=A0=A0 }
> =A0=A0=A0 }
> =A0 return 0;
> }
> /* ------------ */
>=20
>=20
> Thanks,
> Xie Xun


