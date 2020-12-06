From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH v2 00/12] Convert all vmstat counters to pages or bytes
Date: Sun, 6 Dec 2020 18:02:19 +0800
Message-ID: <CAMZfGtXX2k+-RGHx7CtbnoC4QOSHT2afS=9YX5GAjFN38=xkkw@mail.gmail.com>
References: <20201206082318.11532-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yK27iUNadlI9MmI6B+s8BZZCxEUnviUifHj+P5KRXMg=;
        b=ilNSry1fFb2VSxzC6tm0xGYazjZD9Ar0wYnM5PmkQPzKeO6m/8kxm5rNlI7oyTPPbk
         i5xwLJoZlcE+oIS19DTByIbI8S3mWauEFjywj/RhH1PXOGTBSbM16m1Gl+AZFCYm0gyH
         bqu6gclEOOrruiFK87psVFo1l/07z01Iq65RLsp9vxd5+qGAHT97LUR7X2J4zBebULJg
         EbQ6P5WANSdYinm/+Jl5ZApt2ou6i8fmj/P4NnTZeBruaCmWfW2MUQXUTCXnA4EK+O5a
         yyTurylWJoFQxbjQg32Oh61ACS8XIfEJKlqAriWqjT9VSLCtNs7tOFl0UM+mD4P2rW87
         b+1Q==
In-Reply-To: <20201206082318.11532-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

I am very sorry that I have hit 'git send-email *' in a directory
containing both v1 and v2 patchs. Please ignore this. I will
resend this version. Very sorry for the noise. Thanks.

On Sun, Dec 6, 2020 at 4:25 PM Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
>
> Hi,
>
> This patch series is aimed to convert all THP vmstat counters to pages
> and some KiB vmstat counters to bytes.
>
> The unit of some vmstat counters are pages, some are bytes, some are
> HPAGE_PMD_NR, and some are KiB. When we want to expose these vmstat
> counters to the userspace, we have to know the unit of the vmstat counters
> is which one. It makes the code complex. Because there are too many choices,
> the probability of making a mistake will be greater.
>
> For example, the below is some bug fix:
>   - 7de2e9f195b9 ("mm: memcontrol: correct the NR_ANON_THPS counter of hierarchical memcg")
>   - not committed(it is the first commit in this series) ("mm: memcontrol: fix NR_ANON_THPS account")
>
> This patch series can make the code simple (161 insertions(+), 187 deletions(-)).
> And make the unit of the vmstat counters are either pages or bytes. Fewer choices
> means lower probability of making mistakes :).
>
> This was inspired by Johannes and Roman. Thanks to them.
>
> Changes in v1 -> v2:
>   - Change the series subject from "Convert all THP vmstat counters to pages"
>     to "Convert all vmstat counters to pages or bytes".
>   - Convert NR_KERNEL_SCS_KB account to bytes.
>   - Convert vmstat slab counters to bytes.
>   - Remove {global_}node_page_state_pages.
>
> Muchun Song (12):
>   mm: memcontrol: fix NR_ANON_THPS account
>   mm: memcontrol: convert NR_ANON_THPS account to pages
>   mm: memcontrol: convert NR_FILE_THPS account to pages
>   mm: memcontrol: convert NR_SHMEM_THPS account to pages
>   mm: memcontrol: convert NR_SHMEM_PMDMAPPED account to pages
>   mm: memcontrol: convert NR_FILE_PMDMAPPED account to pages
>   mm: memcontrol: convert kernel stack account to bytes
>   mm: memcontrol: convert NR_KERNEL_SCS_KB account to bytes
>   mm: memcontrol: convert vmstat slab counters to bytes
>   mm: memcontrol: scale stat_threshold for byted-sized vmstat
>   mm: memcontrol: make the slab calculation consistent
>   mm: memcontrol: remove {global_}node_page_state_pages
>
>  drivers/base/node.c     |  25 ++++-----
>  fs/proc/meminfo.c       |  22 ++++----
>  include/linux/mmzone.h  |  21 +++-----
>  include/linux/vmstat.h  |  21 ++------
>  kernel/fork.c           |   8 +--
>  kernel/power/snapshot.c |   2 +-
>  kernel/scs.c            |   4 +-
>  mm/filemap.c            |   4 +-
>  mm/huge_memory.c        |   9 ++--
>  mm/khugepaged.c         |   4 +-
>  mm/memcontrol.c         | 131 ++++++++++++++++++++++++------------------------
>  mm/oom_kill.c           |   2 +-
>  mm/page_alloc.c         |  17 +++----
>  mm/rmap.c               |  19 ++++---
>  mm/shmem.c              |   3 +-
>  mm/vmscan.c             |   2 +-
>  mm/vmstat.c             |  54 ++++++++------------
>  17 files changed, 161 insertions(+), 187 deletions(-)
>
> --
> 2.11.0
>


-- 
Yours,
Muchun
