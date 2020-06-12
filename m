From: Naresh Kamboju <naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: mm: mkfs.ext4 invoked oom-killer on i386 - pagecache_get_page
Date: Fri, 12 Jun 2020 15:13:22 +0530
Message-ID: <CA+G9fYsjH8vOTkSKGa5vgC=0fEXuC5UnGsZOirHxH9nOJSHPdA@mail.gmail.com>
References: <20200521095515.GK6462@dhcp22.suse.cz> <20200521163450.GV6462@dhcp22.suse.cz>
 <CA+G9fYuDWGZx50UpD+WcsDeHX9vi3hpksvBAWbMgRZadb0Pkww@mail.gmail.com>
 <CA+G9fYs2jg-j_5fdb0OW0G-JzDjN7b8d9qnX7uuk9p4c7mVSig@mail.gmail.com>
 <20200528150310.GG27484@dhcp22.suse.cz> <CA+G9fYvDXiZ9E9EfU6h0gsJ+xaXY77mRu9Jg+J7C=X4gJ3qvLg@mail.gmail.com>
 <20200528164121.GA839178@chrisdown.name> <CALOAHbAHGOsAUUM7qn=9L1u8kAf6Gztqt=SyHSmZ9XuYZWcKmg@mail.gmail.com>
 <20200529015644.GA84588@chrisdown.name> <20200529094910.GH4406@dhcp22.suse.cz>
 <20200611095514.GD20450@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aIjum0OdXj+v8gBuVrC8N67GclMwnVqsebwDSnxt9vM=;
        b=B5zzUnrxMZIR1cvpNNJdn3LFoosy6pPU4isLVSWgJ9nP8PUuaqb/X7mACFUtN4Zz0e
         je1pJ6/7L30IUd9miR1oO0pReCGX2bidQmzsxFyBH7tKSWWLqW6VQz10wJTlfMKj9rrB
         WBE/JK4Uw5jGqY0GBMDdgRP4v094YfQNIFITKncq2chQL2ULqFL5HZsbtycVUANMKQ4q
         Ff22Q8bj6f9otWxYKNEcAsUS4YOjCGydg0FG7aELVJHksT7x7qdY2jHFHD/khmaddwqh
         5gNJVS3WCEasOzyYFedHV6DyZL/RyohzMUHwWpOSbVYfzQc6KihVidQjyi/EVoZE4LYe
         XpFw==
In-Reply-To: <20200611095514.GD20450-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Anders Roxell <anders.roxell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Linux F2FS DEV, Mailing List" <linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-block <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Next Mailing List <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Chao Yu <yuchao0-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, lkft-triag

On Thu, 11 Jun 2020 at 15:25, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Fri 29-05-20 11:49:20, Michal Hocko wrote:
> > On Fri 29-05-20 02:56:44, Chris Down wrote:
> > > Yafang Shao writes:
> > Agreed. Even if e{low,min} might still have some rough edges I am
> > completely puzzled how we could end up oom if none of the protection
> > path triggers which the additional debugging should confirm. Maybe my
> > debugging patch is incomplete or used incorrectly (maybe it would be
> > esier to use printk rather than trace_printk?).
>
> It would be really great if we could move forward. While the fix (which
> has been dropped from mmotm) is not super urgent I would really like to
> understand how it could hit the observed behavior. Can we double check
> that the debugging patch really doesn't trigger (e.g.
> s@trace_printk@printk in the first step)?

Please suggest to me the way to get more debug information
by providing kernel debug patches and extra kernel configs.

I have applied your debug patch and tested on top on linux next 20200612
but did not find any printk output while running mkfs -t ext4 /drive test case.


> I have checked it again but
> do not see any potential code path which would be affected by the patch
> yet not trigger any output. But another pair of eyes would be really
> great.


---
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b6d84326bdf2..d13ce7b02de4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2375,6 +2375,8 @@ static void get_scan_count(struct lruvec
*lruvec, struct scan_control *sc,
  * sc->priority further than desirable.
  */
  scan = max(scan, SWAP_CLUSTER_MAX);
+
+ trace_printk("scan:%lu protection:%lu\n", scan, protection);
  } else {
  scan = lruvec_size;
  }
@@ -2618,6 +2620,7 @@ static void shrink_node_memcgs(pg_data_t *pgdat,
struct scan_control *sc)

  switch (mem_cgroup_protected(target_memcg, memcg)) {
  case MEMCG_PROT_MIN:
+ trace_printk("under min:%lu emin:%lu\n", memcg->memory.min,
memcg->memory.emin);
  /*
  * Hard protection.
  * If there is no reclaimable memory, OOM.
@@ -2630,6 +2633,7 @@ static void shrink_node_memcgs(pg_data_t *pgdat,
struct scan_control *sc)
  * there is an unprotected supply
  * of reclaimable memory from other cgroups.
  */
+ trace_printk("under low:%lu elow:%lu\n", memcg->memory.low,
memcg->memory.elow);
  if (!sc->memcg_low_reclaim) {
  sc->memcg_low_skipped = 1;
  continue;
-- 
2.23.0

ref:
test output:
https://lkft.validation.linaro.org/scheduler/job/1489767#L1388

Test artifacts link (kernel / modules):
https://builds.tuxbuild.com/5rRNgQqF_wHsSRptdj4A1A/
- Naresh
