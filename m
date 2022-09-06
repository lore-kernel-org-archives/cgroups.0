From: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH v4 00/10] sched/psi: some optimizations and extensions
Date: Tue, 6 Sep 2022 21:13:27 +0800
Message-ID: <be071d5a-ff2d-d06e-2f89-f2ca247dd19e@bytedance.com>
References: <20220825164111.29534-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=z0xoCgZ6OB1X6I9K+Q5ULkuyhW887KdUWlCNKEVd8bw=;
        b=w4ajL+gQDWI7cKBhAtKnr5qiDWAGO/We8uLJbQKU9jAQnQUOLx2qHZbOX1l7S4G5vh
         FTv/eIZt6wZzqvcB84yAV4NpuX6QTsIKU7iaREKywsVq5rv3CoX7ve7fE1emDVz8Wsm1
         CpFQY3aXhwzLmE/6c5T+vB4eaQmq7GzcLBit1y2HOBkyyT2cib4/TYiGZM75X83eooWc
         3q5VLPpsM6sdGE5mNxACCk/J7RvSfk9HVtQeGEAyga1gZMPAWkgI3qVa1+hPcM5yOeJe
         ++tbjev/riu9AwiHLXMbADkvtn/E8Y1wHQZZNCuZ7tCnq1rV3W+rNPALMR5xkExUIWCa
         jDCw==
Content-Language: en-US
In-Reply-To: <20220825164111.29534-1-zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

Hello,

Could this series be merged into the linux-next?

Thanks.


On 2022/8/26 00:41, Chengming Zhou wrote:
> Hi all,
>=20
> This patch series are some optimizations and extensions for PSI.
>=20
> patch 1/10 fix periodic aggregation shut off problem introduced by earlier
> commit 4117cebf1a9f ("psi: Optimize task switch inside shared cgroups").
>=20
> patch 2-4 are some misc optimizations, so put them in front of this serie=
s.
>=20
> patch 5/10 optimize task switch inside shared cgroups when in_memstall st=
atus
> of prev task and next task are different.
>=20
> patch 6/10 remove NR_ONCPU task accounting to save 4 bytes in the first
> cacheline to be used by the following patch 7/10, which introduce new
> PSI resource PSI_IRQ to track IRQ/SOFTIRQ pressure stall information.
>=20
> patch 8-9 cache parent psi_group in struct psi_group to speed up the
> hot iteration path.
>=20
> patch 10/10 introduce a per-cgroup interface "cgroup.pressure" to disable
> or re-enable PSI in the cgroup level, and we implement hiding and unhiding
> the pressure files per Tejun's suggestion[1], which depends on his work[2=
].
>=20
> [1] https://lore.kernel.org/all/YvqjhqJQi2J8RG3X-NiLfg/pYEd1N0TnZuCh8vA@p=
ublic.gmane.org/
> [2] https://lore.kernel.org/all/20220820000550.367085-1-tj-DgEjT+Ai2ygdnm=
+yROfE0A@public.gmane.org/
>=20
> Performance test using mmtests/config-scheduler-perfpipe in
> /user.slice/user-0.slice/session-4.scope:
>=20
>                                  next                patched       patche=
d/only-leaf
> Min       Time        8.82 (   0.00%)        8.49 (   3.74%)        8.00 =
(   9.32%)
> 1st-qrtle Time        8.90 (   0.00%)        8.58 (   3.63%)        8.05 =
(   9.58%)
> 2nd-qrtle Time        8.94 (   0.00%)        8.61 (   3.65%)        8.09 =
(   9.50%)
> 3rd-qrtle Time        8.99 (   0.00%)        8.65 (   3.75%)        8.15 =
(   9.35%)
> Max-1     Time        8.82 (   0.00%)        8.49 (   3.74%)        8.00 =
(   9.32%)
> Max-5     Time        8.82 (   0.00%)        8.49 (   3.74%)        8.00 =
(   9.32%)
> Max-10    Time        8.84 (   0.00%)        8.55 (   3.20%)        8.04 =
(   9.05%)
> Max-90    Time        9.04 (   0.00%)        8.67 (   4.10%)        8.18 =
(   9.51%)
> Max-95    Time        9.04 (   0.00%)        8.68 (   4.03%)        8.20 =
(   9.26%)
> Max-99    Time        9.07 (   0.00%)        8.73 (   3.82%)        8.25 =
(   9.11%)
> Max       Time        9.12 (   0.00%)        8.89 (   2.54%)        8.27 =
(   9.29%)
> Amean     Time        8.95 (   0.00%)        8.62 *   3.67%*        8.11 =
*   9.43%*
>=20
> Big thanks to Johannes Weiner, Tejun Heo and Michal Koutn=C3=BD for your
> suggestions and review!
>=20
>=20
> Changes in v4:
>  - Collect Acked-by tags from Johannes Weiner.
>  - Add many clear comments and changelogs per Johannes Weiner.
>  - Replace for_each_psi_group() with better open-code.
>  - Change to use better names cgroup_pressure_show() and
>    cgroup_pressure_write().
>  - Change to use better name psi_cgroup_restart() and only
>    call it on enabling.
>=20
> Changes in v3:
>  - Rebase on linux-next and reorder patches to put misc optimizations
>    patches in the front of this series.
>  - Drop patch "sched/psi: don't change task psi_flags when migrate CPU/gr=
oup"
>    since it caused a little performance regression and it's just
>    code refactoring, so drop it.
>  - Don't define PSI_IRQ and PSI_IRQ_FULL when !CONFIG_IRQ_TIME_ACCOUNTING,
>    in which case they are not used.
>  - Add patch 8/10 "sched/psi: consolidate cgroup_psi()" make cgroup_psi()
>    can handle all cgroups including root cgroup, make patch 9/10 simpler.
>  - Rename interface to "cgroup.pressure" and add some explanation
>    per Michal's suggestion.
>  - Hide and unhide pressure files when disable/re-enable cgroup PSI,
>    depends on Tejun's work.
>=20
> Changes in v2:
>  - Add Acked-by tags from Johannes Weiner. Thanks for review!
>  - Fix periodic aggregation wakeup for common ancestors in
>    psi_task_switch().
>  - Add patch 7/10 from Johannes Weiner, which remove NR_ONCPU
>    task accounting to save 4 bytes in the first cacheline.
>  - Remove "psi_irq=3D" kernel cmdline parameter in last version.
>  - Add per-cgroup interface "cgroup.psi" to disable/re-enable
>    PSI stats accounting in the cgroup level.
>=20
>=20
> Chengming Zhou (9):
>   sched/psi: fix periodic aggregation shut off
>   sched/psi: don't create cgroup PSI files when psi_disabled
>   sched/psi: save percpu memory when !psi_cgroups_enabled
>   sched/psi: move private helpers to sched/stats.h
>   sched/psi: optimize task switch inside shared cgroups again
>   sched/psi: add PSI_IRQ to track IRQ/SOFTIRQ pressure
>   sched/psi: consolidate cgroup_psi()
>   sched/psi: cache parent psi_group to speed up groups iterate
>   sched/psi: per-cgroup PSI accounting disable/re-enable interface
>=20
> Johannes Weiner (1):
>   sched/psi: remove NR_ONCPU task accounting
>=20
>  Documentation/admin-guide/cgroup-v2.rst |  23 ++
>  include/linux/cgroup-defs.h             |   3 +
>  include/linux/cgroup.h                  |   5 -
>  include/linux/psi.h                     |  12 +-
>  include/linux/psi_types.h               |  29 ++-
>  kernel/cgroup/cgroup.c                  | 106 ++++++++-
>  kernel/sched/core.c                     |   1 +
>  kernel/sched/psi.c                      | 280 +++++++++++++++++-------
>  kernel/sched/stats.h                    |   6 +
>  9 files changed, 362 insertions(+), 103 deletions(-)
>=20
