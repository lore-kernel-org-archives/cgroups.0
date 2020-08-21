From: William Kucharski <william.kucharski-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/8] Return head pages from find_get_entry and
 find_lock_entry
Date: Fri, 21 Aug 2020 11:37:49 -0600
Message-ID: <4AEE52BC-76F0-4DB4-BBB1-7E367C12338B@oracle.com>
References: <20200819184850.24779-1-willy@infradead.org>
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.0.3\))
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=JUslshiDaN2dhP+XGrtZjY0EQXD83w9PlaWLQ1ae6vI=;
 b=v1eeqSoFZHVgpxgBCn7rPBUUsxTUxa4ls50fuAPwe9ZXg1ke5BYPwqZntCNgqvG3F55k
 OCUTr+/mXf3F6gdjCbHtO05iTUAAHid/DTL4UdDcVZcHw87g3AM0X/yrhKr2zSQnlGBL
 YpCwFOMY23P9LcP84/hCOoSqG1Xcy0j5d7NoppYcsVerTPajz2PR1V0FedP8sT03ZOdG
 oJYqKuRpeTP3TX/vRHcypi9Bo1ISI5tAbKK1hyBN7DgPjq9Pa15PrwJ1n/G1YMSz1Srx
 oB91CuqryjpyaITXDlUnTEZlsFeI66zSGMi0UWa9SerzCdbwrMgnuppWdeTBTlPArg0f aw== 
In-Reply-To: <20200819184850.24779-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, Matthew Auld <matthew.auld-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



> On Aug 19, 2020, at 12:48 PM, Matthew Wilcox (Oracle) =
<willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>=20
> This patch seris started out as part of the THP patch set, but it has
> some nice effects along the way and it seems worth splitting it out =
and
> submitting separately.
>=20
> Currently find_get_entry() and find_lock_entry() return the page
> corresponding to the requested index, but the first thing most callers =
do
> is find the head page, which we just threw away.  As part of auditing
> all the callers, I found some misuses of the APIs and some plain
> inefficiencies that I've fixed.
>=20
> The diffstat is unflattering, but I added more kernel-doc.
>=20
> Matthew Wilcox (Oracle) (8):
>  mm: Factor find_get_swap_page out of mincore_page
>  mm: Use find_get_swap_page in memcontrol
>  mm: Optimise madvise WILLNEED
>  proc: Optimise smaps for shmem entries
>  i915: Use find_lock_page instead of find_lock_entry
>  mm: Convert find_get_entry to return the head page
>  mm: Return head page from find_lock_entry
>  mm: Hoist find_subpage call further up in pagecache_get_page
>=20
> drivers/gpu/drm/i915/gem/i915_gem_shmem.c |  4 +--
> fs/proc/task_mmu.c                        |  8 +----
> include/linux/pagemap.h                   | 16 +++++++--
> include/linux/swap.h                      |  7 ++++
> mm/filemap.c                              | 41 +++++++++++------------
> mm/madvise.c                              | 21 +++++++-----
> mm/memcontrol.c                           | 25 ++------------
> mm/mincore.c                              | 28 ++--------------
> mm/shmem.c                                | 15 +++++----
> mm/swap_state.c                           | 31 +++++++++++++++++
> 10 files changed, 98 insertions(+), 98 deletions(-)

For the series:

Reviewed-by: William Kucharski <william.kucharski-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>=
