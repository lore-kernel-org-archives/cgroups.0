From: Naresh Kamboju <naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 4/5] mm: memcg: charge memcg percpu memory to the
 parent cgroup
Date: Thu, 13 Aug 2020 14:46:51 +0530
Message-ID: <CA+G9fYuTsjEpDpODGcYf5hnGwzxj__tVdCMpWeC+ojg5pkYCzw@mail.gmail.com>
References: <20200623184515.4132564-1-guro@fb.com> <20200623184515.4132564-5-guro@fb.com>
 <20200811152737.GB650506@cmpxchg.org> <20200811170611.GB1507044@carbon.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AVVK701BmMx0nOUeszXW5DOWYJuKUEBlmJUyUmBXonw=;
        b=KBgg1LChIJzojq8wCoeBtwucYMjlQp1QRp2wmwPAM1zKPNUxxR3/5bSVizhTzk6G44
         npUXrcnyRvP3lRa9ULHZykC+QGgP49O13LGemQfktRZo0AwGCTZxu1Ja45c7yx18xNv1
         muca13rZx62UlS4IYGcPmIkoylmr5XPcDhItlD5VtS/lOEzd/55M7WX/jCSGZlcxiQI+
         xvnTzujx3DLUkky5EGUiKdsM2s3jPLVW09TCdy6GQnvkfys69duwnup2xrOpSZ4dzgrb
         MtdejXgoIja4ZEo0YCTAljx1ZieNdcHRbla7np/JOHNAUDYiXq7g/vRLdZ5Giy7MIEkC
         pJKA==
In-Reply-To: <20200811170611.GB1507044-lLJQVQxiE4uLfgCeKHXN1g2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux-Next Mailing List <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, lkft-triage-cunTk1MwBs8s++Sfvej+rw@public.gmane.org

The kernel warnings  were noticed on linux next 20200813 while booting
on arm64, arm, x86_64 and i386.

metadata:
  git branch: master
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
  git commit: e6d113aca646fb6a92b237340109237fd7a9c770
  git describe: next-20200813
  make_kernelversion: 5.8.0
  kernel-config:
https://builds.tuxbuild.com/YQHc_PpEV-DF8rU7N9tlIQ/kernel.config

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 130093bdf74b..e25f2db7e61c 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5137,6 +5137,9 @@ static int alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
>         if (!pn)
>                 return 1;
>
> +       /* We charge the parent cgroup, never the current task */
> +       WARN_ON_ONCE(!current->active_memcg);
> +
>         pn->lruvec_stat_local = alloc_percpu_gfp(struct lruvec_stat,
>                                                  GFP_KERNEL_ACCOUNT);
>         if (!pn->lruvec_stat_local) {
> @@ -5219,6 +5222,9 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
>                 goto fail;
>         }
>
> +       /* We charge the parent cgroup, never the current task */
> +       WARN_ON_ONCE(!current->active_memcg);

[    0.217404] ------------[ cut here ]------------
[    0.218038] WARNING: CPU: 0 PID: 0 at mm/memcontrol.c:5226
mem_cgroup_css_alloc+0x680/0x740
[    0.219188] Modules linked in:
[    0.219597] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.8.0-next-20200813 #1
[    0.220187] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.12.0-1 04/01/2014
[    0.221190] EIP: mem_cgroup_css_alloc+0x680/0x740
[    0.222190] Code: d6 17 5d ff 8d 65 f4 89 d8 5b 5e 5f 5d c3 8d 74
26 00 b8 58 39 6a d1 e8 fe 94 55 ff 8d 65 f4 89 d8 5b 5e 5f 5d c3 8d
74 26 00 <0f> 0b e9 01 fa ff ff 8d b4 26 00 00 00 00 66 90 bb f4 ff ff
ff ba
[    0.223188] EAX: 00000000 EBX: d13666c0 ECX: 00000cc0 EDX: 0000ffff
[    0.224187] ESI: 00000000 EDI: f4c11000 EBP: d1361f50 ESP: d1361f40
[    0.225188] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00210246
[    0.226190] CR0: 80050033 CR2: ffd19000 CR3: 115f8000 CR4: 00040690
[    0.227195] Call Trace:
[    0.227882]  ? _cond_resched+0x17/0x30
[    0.228195]  cgroup_init_subsys+0x66/0x12a
[    0.229193]  cgroup_init+0x118/0x323
[    0.230194]  start_kernel+0x43c/0x47d
[    0.231193]  i386_start_kernel+0x48/0x4a
[    0.232194]  startup_32_smp+0x164/0x168
[    0.233195] ---[ end trace dfcf9be7b40caf05 ]---
[    0.2342#
08] ------------[ cut here ]------------
[    0.235192] WARNING: CPU: 0 PID: 0 at mm/memcontrol.c:5141
mem_cgroup_css_alloc+0x718/0x740
[    0.236187] Modules linked in:
[    0.236590] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W
  5.8.0-next-20200813 #1
[    0.237190] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.12.0-1 04/01/2014
[    0.238194] EIP: mem_cgroup_css_alloc+0x718/0x740
[    0.239191] Code: 48 ff e9 7c fd ff ff 8d 76 00 a1 b0 14 40 d1 e9
53 fc ff ff 8d b6 00 00 00 00 0f 0b 8d b6 00 00 00 00 0f 0b 8d b6 00
00 00 00 <0f> 0b e9 df f9 ff ff 90 89 f8 e8 29 0c 5c ff 89 f2 b8 10 f4
40 d1
[    0.240190] EAX: 00000000 EBX: f4c0c800 ECX: 00000000 EDX: d0eab660
[    0.241189] ESI: 00000000 EDI: f4c11000 EBP: d1361f50 ESP: d1361f40
[    0.242189] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00210246
[    0.243190] CR0: 80050033 CR2: ffd19000 CR3: 115f8000 CR4: 00040690
[    0.244188] Call Trace:
[    0.245191]  ? _cond_resched+0x17/0x30
[    0.245686]  cgroup_init_subsys+0x66/0x12a
[    0.246189]  cgroup_init+0x118/0x323
[    0.246654]  start_kernel+0x43c/0x47d
[    0.247189]  i386_start_kernel+0x48/0x4a
[    0.247697]  startup_32_smp+0x164/0x168
[    0.248188] ---[ end trace dfcf9be7b40caf06 ]---
[    0.248990] Last level iTLB entries: 4KB 512, 2MB 255, 4MB 127
[    0.249187] Last level dTLB entries: 4KB 512, 2MB 255, 4MB 127, 1GB 0


Full test log,
https://qa-reports.linaro.org/lkft/linux-next-oe/build/next-20200813/testrun/3061112/suite/linux-log-parser/test/check-kernel-warning-1665815/log

-- 
Linaro LKFT
https://lkft.linaro.org
