From: Naresh Kamboju <naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: mm: mkfs.ext4 invoked oom-killer on i386 - pagecache_get_page
Date: Thu, 21 May 2020 14:28:59 +0530
Message-ID: <CA+G9fYsCaxJ5WyN8y=gCMvrZHCCYYkbzyCpHKspkqrEVwpgNoQ@mail.gmail.com>
References: <CA+G9fYu2ruH-8uxBHE0pdE6RgRTSx4QuQPAN=Nv3BCdRd2ouYA@mail.gmail.com>
 <20200501135806.4eebf0b92f84ab60bba3e1e7@linux-foundation.org>
 <CA+G9fYsiZ81pmawUY62K30B6ue+RXYod854RS91R2+F8ZO7Xvw@mail.gmail.com>
 <20200519075213.GF32497@dhcp22.suse.cz> <CAK8P3a2T_j-Ynvhsqe_FCqS2-ZdLbo0oMbHhHChzMbryE0izAQ@mail.gmail.com>
 <20200519084535.GG32497@dhcp22.suse.cz> <CA+G9fYvzLm7n1BE7AJXd8_49fOgPgWWTiQ7sXkVre_zoERjQKg@mail.gmail.com>
 <CA+G9fYsXnwyGetj-vztAKPt8=jXrkY8QWe74u5EEA3XPW7aikQ@mail.gmail.com> <CALOAHbDMrHkNHTxeBWP22iTjJd+HfqfFhAfmC_m0jsVkhu5vEA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ebjb/EkTXvuLGqJe8ycqzM228+EB5pV3TJ94q2+hFBE=;
        b=uIDE4B/jSErBGZ7dOnzEgDAhyBWnmBaQsrZKtTpAwa6Z91lQRziNBWcH3VmFbPbprV
         N6eQawm+AiXWqGuqukU2cinrgbpkwYYYszcRIIAVxAh3+Ke9laz31qkoKL3DVZtzrxhb
         UKGZb4UBaKcYmskNL/BVgb1R547rsgu6RJV3DBNyPIA/WMXkG73zz5UtqtOsotMRzOcX
         PlsvuWvdZmqjEKtVG5XKpkLUFz65+Vhy8omCaVd6UPjKm7tSWi16AGZSh2Jbp3aFNCtw
         B3g6TdZWAJlzVPG/6thsom+ogYAp2Rz3RKbAETWxeZGZtjyErE7tlk5T3Me08V54J3GS
         e/og==
In-Reply-To: <CALOAHbDMrHkNHTxeBWP22iTjJd+HfqfFhAfmC_m0jsVkhu5vEA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Anders Roxell <anders.roxell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Linux F2FS DEV, Mailing List" <linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-block <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Next Mailing List <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Chao Yu <yuchao0-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, 

On Thu, 21 May 2020 at 08:10, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On Thu, May 21, 2020 at 2:00 AM Naresh Kamboju
> <naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Wed, 20 May 2020 at 17:26, Naresh Kamboju <naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> > >
> > >
> > > This issue is specific on 32-bit architectures i386 and arm on linux-next tree.
> > > As per the test results history this problem started happening from
> > > mkfs -t ext4 /dev/disk/by-id/ata-SanDisk_SSD_PLUS_120GB_190804A00BE5
> > >
> > >
> > > Problem:
> > > [   38.802375] dd invoked oom-killer: gfp_mask=0x100cc0(GFP_USER),
> > > order=0, oom_score_adj=0
> >
> My guess is that we made the same mistake in commit "mm, memcg:
> decouple e{low,min} state mutations from protection
> checks" that it read a stale memcg protection in
> mem_cgroup_below_low() and mem_cgroup_below_min().
>
> Bellow is a possble fix,

Sorry. The proposed fix did not work.
I have took your patch and applied on top of linux-next master branch and
tested and mkfs -t ext4 invoked oom-killer.

After patch applied test log link,
https://lkft.validation.linaro.org/scheduler/job/1443936#L1168


test  log,
+ mkfs -t ext4 /dev/disk/by-id/ata-TOSHIBA_MG04ACA100N_Y8NRK0BPF6XF
mke2fs 1.43.8 (1-Jan-2018)
Creating filesystem with 244190646 4k blocks and 61054976 inodes
Filesystem UUID: ab107250-bf18-4357-a06a-67f2bfcc1048
Superblock backups stored on blocks:
32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
102400000, 214990848
Allocating group tables:    0/7453                           done
Writing inode tables:    0/7453                           done
Creating journal (262144 blocks): [   34.423940] mkfs.ext4 invoked
oom-killer: gfp_mask=0x101cc0(GFP_USER|__GFP_WRITE), order=0,
oom_score_adj=0
[   34.433694] CPU: 0 PID: 402 Comm: mkfs.ext4 Not tainted
5.7.0-rc6-next-20200519+ #1
[   34.441342] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.2 05/23/2018
[   34.448734] Call Trace:
[   34.451196]  dump_stack+0x54/0x76
[   34.454517]  dump_header+0x40/0x1f0
[   34.458008]  ? oom_badness+0x1f/0x120
[   34.461673]  ? ___ratelimit+0x6c/0xe0
[   34.465332]  oom_kill_process+0xc9/0x110
[   34.469255]  out_of_memory+0xd7/0x2f0
[   34.472916]  __alloc_pages_nodemask+0xdd1/0xe90
[   34.477446]  ? set_bh_page+0x33/0x50
[   34.481016]  ? __xa_set_mark+0x4d/0x70
[   34.484762]  pagecache_get_page+0xbe/0x250
[   34.488859]  grab_cache_page_write_begin+0x1a/0x30
[   34.493645]  block_write_begin+0x25/0x90
[   34.497569]  blkdev_write_begin+0x1e/0x20
[   34.501574]  ? bdev_evict_inode+0xc0/0xc0
[   34.505578]  generic_perform_write+0x95/0x190
[   34.509927]  __generic_file_write_iter+0xe0/0x1a0
[   34.514626]  blkdev_write_iter+0xbf/0x1c0
[   34.518630]  __vfs_write+0x122/0x1e0
[   34.522200]  vfs_write+0x8f/0x1b0
[   34.525510]  ksys_pwrite64+0x60/0x80
[   34.529081]  __ia32_sys_ia32_pwrite64+0x16/0x20
[   34.533604]  do_fast_syscall_32+0x66/0x240
[   34.537697]  entry_SYSENTER_32+0xa5/0xf8
[   34.541613] EIP: 0xb7f3c549
[   34.544403] Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01
10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f
34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90
8d 76
[   34.563140] EAX: ffffffda EBX: 00000003 ECX: b7830010 EDX: 00400000
[   34.569397] ESI: 38400000 EDI: 00000074 EBP: 07438400 ESP: bff1e650
[   34.575654] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000246
[   34.582453] Mem-Info:
[   34.584732] active_anon:5713 inactive_anon:2169 isolated_anon:0
[   34.584732]  active_file:4040 inactive_file:211204 isolated_file:0
[   34.584732]  unevictable:0 dirty:17270 writeback:6240 unstable:0
[   34.584732]  slab_reclaimable:5856 slab_unreclaimable:3439
[   34.584732]  mapped:6192 shmem:2258 pagetables:178 bounce:0
[   34.584732]  free:265105 free_pcp:1330 free_cma:0
[   34.618483] Node 0 active_anon:22852kB inactive_anon:8676kB
active_file:16160kB inactive_file:844816kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB mapped:24768kB dirty:69080kB
writeback:19628kB shmem:9032kB writeback_tmp:0kB unstable:0kB
all_unreclaimable? yes
[   34.642354] DMA free:3588kB min:68kB low:84kB high:100kB
reserved_highatomic:0KB active_anon:0kB inactive_anon:0kB
active_file:0kB inactive_file:11848kB unevictable:0kB
writepending:11856kB present:15964kB managed:15876kB mlocked:0kB
kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB
free_cma:0kB
[   34.670194] lowmem_reserve[]: 0 824 1947 824
[   34.674483] Normal free:4228kB min:3636kB low:4544kB high:5452kB
reserved_highatomic:0KB active_anon:0kB inactive_anon:0kB
active_file:1136kB inactive_file:786456kB unevictable:0kB
writepending:68084kB present:884728kB managed:845324kB mlocked:0kB
kernel_stack:1104kB pagetables:0kB bounce:0kB free_pcp:3056kB
local_pcp:388kB free_cma:0kB
[   34.704243] lowmem_reserve[]: 0 0 8980 0
[   34.708189] HighMem free:1053028kB min:512kB low:1748kB high:2984kB
reserved_highatomic:0KB active_anon:22852kB inactive_anon:8676kB
active_file:15024kB inactive_file:46596kB unevictable:0kB
writepending:0kB present:1149544kB managed:1149544kB mlocked:0kB
kernel_stack:0kB pagetables:712kB bounce:0kB free_pcp:2160kB
local_pcp:736kB free_cma:0kB
[   34.738563] lowmem_reserve[]: 0 0 0 0
[   34.742245] DMA: 23*4kB (U) 2*8kB (U) 3*16kB (U) 2*32kB (UE) 2*64kB
(U) 1*128kB (U) 1*256kB (E) 0*512kB 1*1024kB (E) 1*2048kB (E) 0*4096kB
= 3804kB
[   34.755479] Normal: 25*4kB (UM) 27*8kB (UME) 16*16kB (UME) 14*32kB
(UME) 7*64kB (UME) 2*128kB (UM) 1*256kB (E) 1*512kB (E) 0*1024kB
1*2048kB (M) 0*4096kB = 4540kB
[   34.770004] HighMem: 1*4kB (U) 0*8kB 0*16kB 1*32kB (U) 1*64kB (M)
2*128kB (UM) 2*256kB (UM) 1*512kB (U) 1*1024kB (U) 1*2048kB (U)
256*4096kB (M) = 1053028kB
[   34.784010] Node 0 hugepages_total=0 hugepages_free=0
hugepages_surp=0 hugepages_size=4096kB
[   34.792466] 217507 total pagecache pages
[   34.796387] 0 pages in swap cache
[   34.799704] Swap cache stats: add 0, delete 0, find 0/0
[   34.804923] Free swap  = 0kB
[   34.807834] Total swap = 0kB
[   34.810738] 512559 pages RAM
[   34.813640] 287386 pages HighMem/MovableOnly
[   34.817931] 9873 pages reserved


- Naresh
