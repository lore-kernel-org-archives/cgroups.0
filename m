From: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>
Subject: Re: [PATCH v12 1/9] hugetlb_cgroup: Add hugetlb_cgroup reservation
 counter
Date: Tue, 18 Feb 2020 09:21:00 -0500
Message-ID: <1582035660.7365.90.camel@lca.pw>
References: <20200211213128.73302-1-almasrymina@google.com>
         <20200211151906.637d1703e4756066583b89da@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oQ5uMvj46YJt8du9hHYIxA2AHiZ2qf4UtK0vshdPA7k=;
        b=pVwRuh4BaTn8YPjr2IxIwRAmmQKxPSCA61udn+YRyUJNFsLAVCbihPsf7i75uhUwbr
         +0fs1RaV4qLf9li0eukOM5+LEaNAwgkcriWirfC0RF6txXF1SBd8esVOjADSEoZO+Wr0
         /X01M29q8Bi1V8jFSz2+vsig87KwPaoILhBOuAUkTvLaO+AZ7yOXfWej+eBeJXiLuyg7
         FJGgckZGhgHDiGaof0+31va7N2CnPPuELXoWnsc1ctExVXUBp9Qbbxngeea1NHJmLFUa
         Fdpjgmod1Ih1wjBMZnE5deA9PivD7MmcRKe6cQoK6wOoF0Pc26hA+6PbHq5IdbLEtNDP
         pXhg==
In-Reply-To: <20200211151906.637d1703e4756066583b89da-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 2020-02-11 at 15:19 -0800, Andrew Morton wrote:
> On Tue, 11 Feb 2020 13:31:20 -0800 Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > These counters will track hugetlb reservations rather than hugetlb
> > memory faulted in. This patch only adds the counter, following patches
> > add the charging and uncharging of the counter.
> 
> We're still pretty thin on review here, but as it's v12 and Mike
> appears to be signed up to look at this work, I'll add them to -next to
> help move things forward.
> 

Reverted the whole series on the top of next-20200217 fixed a crash below (I
don't see anything in next-20200218 would make any differences).

[ 7933.691114][T35046] LTP: starting hugemmap06
[ 7933.806377][T14355] ------------[ cut here ]------------
[ 7933.806541][T14355] kernel BUG at mm/hugetlb.c:490!
VM_BUG_ON(t - f <= 1);
[ 7933.806562][T14355] Oops: Exception in kernel mode, sig: 5 [#1]
[ 7933.806573][T14355] LE PAGE_SIZE=64K MMU=Radix SMP NR_CPUS=256
DEBUG_PAGEALLOC NUMA PowerNV
[ 7933.806594][T14355] Modules linked in: kvm_hv kvm brd ext4 crc16 mbcache jbd2
loop ip_tables x_tables xfs sd_mod bnx2x ahci mdio libahci tg3 libata libphy
firmware_class dm_mirror dm_region_hash dm_log dm_mod [last unloaded:
binfmt_misc]
[ 7933.806651][T14355] CPU: 54 PID: 14355 Comm: hugemmap06 Tainted:
G           O      5.6.0-rc2-next-20200217 #1
[ 7933.806674][T14355] NIP:  c00000000040d22c LR: c00000000040d210 CTR:
0000000000000000
[ 7933.806696][T14355] REGS: c0000014b71ef660 TRAP: 0700   Tainted:
G           O       (5.6.0-rc2-next-20200217)
[ 7933.806727][T14355] MSR:  900000000282b033
<SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 22022228  XER: 00000000
[ 7933.806772][T14355] CFAR: c00000000040cbec IRQMASK: 0 
[ 7933.806772][T14355] GPR00: c00000000040d210 c0000014b71ef8f0 c000000001657000
0000000000000001 
[ 7933.806772][T14355] GPR04: 0000000000000012 0000000000000013 0000000000000000
0000000000000000 
[ 7933.806772][T14355] GPR08: 0000000000000002 0000000000000002 0000000000000001
0000000000000036 
[ 7933.806772][T14355] GPR12: 0000000022022222 c000001ffffd3d00 00007fffad670000
00007fffa4bc0000 
[ 7933.806772][T14355] GPR16: 0000000000000000 c000000001567178 c0000014b71efa50
0000000000000000 
[ 7933.806772][T14355] GPR20: 0000000000000000 0000000000000013 0000000000000012
0000000000000001 
[ 7933.806772][T14355] GPR24: c0000019f74cd270 5deadbeef0000100 5deadbeef0000122
c0000019f74cd2c0 
[ 7933.806772][T14355] GPR28: 0000000000000001 c0000019f74cd268 c0000014b71ef918
0000000000000001 
[ 7933.806961][T14355] NIP [c00000000040d22c] region_add+0x11c/0x3a0
[ 7933.806980][T14355] LR [c00000000040d210] region_add+0x100/0x3a0
[ 7933.807008][T14355] Call Trace:
[ 7933.807024][T14355] [c0000014b71ef8f0] [c00000000040d210]
region_add+0x100/0x3a0 (unreliable)
[ 7933.807056][T14355] [c0000014b71ef9b0] [c00000000040e0c8]
__vma_reservation_common+0x148/0x210
__vma_reservation_common at mm/hugetlb.c:2150
[ 7933.807087][T14355] [c0000014b71efa20] [c0000000004132a0]
alloc_huge_page+0x350/0x830
alloc_huge_page at mm/hugetlb.c:2359
[ 7933.807100][T14355] [c0000014b71efad0] [c0000000004168f8]
hugetlb_no_page+0x158/0xcb0
[ 7933.807113][T14355] [c0000014b71efc20] [c000000000417bc8]
hugetlb_fault+0x678/0xb30
[ 7933.807136][T14355] [c0000014b71efcd0] [c0000000003b1de4]
handle_mm_fault+0x444/0x450
[ 7933.807158][T14355] [c0000014b71efd20] [c000000000070b1c]
__do_page_fault+0x2bc/0xfd0
[ 7933.807181][T14355] [c0000014b71efe20] [c00000000000aa88]
handle_page_fault+0x10/0x30
[ 7933.807201][T14355] Instruction dump:
[ 7933.807209][T14355] 38c00000 7ea5ab78 7ec4b378 7fa3eb78 4bfff80d e9210020
e91d0050 e95d0068 
[ 7933.807232][T14355] 7d3c4850 7d294214 7faa4800 409c0238 <0b170000> 7f03c378
4858c005 60000000 
[ 7933.807267][T14355] ---[ end trace 7560275de5f409f8 ]---
[ 7933.905258][T14355] 
[ 7934.905339][T14355] Kernel panic - not syncing: Fatal exception
