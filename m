From: gaoqiang <gaoqiangscut@gmail.com>
Subject: process hangs on do_exit when oom happens
Date: Wed, 17 Oct 2012 18:23:34 +0800
Message-ID: <op.wmbi5kbrn27o5l@gaoqiang-d1.corp.qihoo.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-mmc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=content-type:to:date:cc:subject:mime-version
         :content-transfer-encoding:from:organization:message-id:user-agent;
        bh=Af6FM+bwrbZVRNKt4PYdKE1Id/SXeXTQ9LKF8wsalw0=;
        b=O3xZfRv56zSQaV2JVa0OjZ2K+GOtnzeCxgVPgdbnwMFjRT1GPTe412XStlSJ6OelLL
         yG2zf6SoEgIKcmOIa7wfgaK6c6NJHgTUVkrf2C6azBXjjFrcLt0TMXEMfXq4QFDAdZZN
         zS30nokeTvZrt6spaKr7STI6lDd9M0ggOt/xV83AzirZOu9amVxlNWV+f6fwBdqmMjEv
         pmqFtPGc9hCzM7KWHu9+vReO4OV2EN/5zplkQp7KSIOOlxJTohOEmHPawrerm9cFL4Po
         kAt52WDlbBCu8sjVBRBolLEejuDAKJwPQd4wHjbDNF0iMwUln51VFEFll/eHv0zUfEIv
         VrEw==
Sender: linux-mmc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="gb2312"; format="flowed	delsp=yes"
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>

I looked up nothing useful with google,so I'm here for help..

when this happens:  I use memcg to limit the memory use of a process,an=
d =20
when the memcg cgroup was out of memory,
the process was oom-killed   however,it cannot really complete the =20
exiting. here is the some information


OS version:  centos6.2    2.6.32.220.7.1

/proc/pid/stack
---------------------------------------------------------------

[<ffffffff810597ca>] __cond_resched+0x2a/0x40
[<ffffffff81121569>] unmap_vmas+0xb49/0xb70
[<ffffffff8112822e>] exit_mmap+0x7e/0x140
[<ffffffff8105b078>] mmput+0x58/0x110
[<ffffffff81061aad>] exit_mm+0x11d/0x160
[<ffffffff81061c9d>] do_exit+0x1ad/0x860
[<ffffffff81062391>] do_group_exit+0x41/0xb0
[<ffffffff81077cd8>] get_signal_to_deliver+0x1e8/0x430
[<ffffffff8100a4c4>] do_notify_resume+0xf4/0x8b0
[<ffffffff8100b281>] int_signal+0x12/0x17
[<ffffffffffffffff>] 0xffffffffffffffff

/proc/pid/stat
---------------------------------------------------------------

11337 (CF_user_based) R 1 11314 11314 0 -1 4203524 7753602 0 0 0 622 18=
06 =20
0 0 -2 0 1 0 324381340 0 0 18446744073709551615 0 0 0 0 0 0 0 0 66784 0=
 0 =20
0 17 3 1 1 0 0 0

/proc/pid/status

Name:	CF_user_based
State:	R (running)
Tgid:	11337
Pid:	11337
PPid:	1
TracerPid:	0
Uid:	32114	32114	32114	32114
Gid:	32114	32114	32114	32114
Utrace:	0
=46DSize:	128
Groups:	32114
Threads:	1
SigQ:	2/2325005
SigPnd:	0000000000000000
ShdPnd:	0000000000004100
SigBlk:	0000000000000000
SigIgn:	0000000000000000
SigCgt:	00000001800104e0
CapInh:	0000000000000000
CapPrm:	0000000000000000
CapEff:	0000000000000000
CapBnd:	ffffffffffffffff
Cpus_allowed:	ffffffff
Cpus_allowed_list:	0-31
Mems_allowed:	00000000,00000003
Mems_allowed_list:	0-1
voluntary_ctxt_switches:	4300
nonvoluntary_ctxt_switches:	77

/var/log/messages
---------------------------------------------------------------

Oct 17 15:22:19 hpc16 kernel: CF_user_based invoked oom-killer: =20
gfp_mask=3D0x280da, order=3D0, oom_adj=3D0, oom_score_adj=3D0
Oct 17 15:22:19 hpc16 kernel: CF_user_based cpuset=3D/ mems_allowed=3D0=
-1
Oct 17 15:22:19 hpc16 kernel: Pid: 3909, comm: CF_user_based Not tainte=
d =20
2.6.32-2.0.0.1 #4
Oct 17 15:22:19 hpc16 kernel: Call Trace:
Oct 17 15:22:19 hpc16 kernel: [<ffffffff810fd915>] ? dump_header+0x85/0=
x1a0
Oct 17 15:22:19 hpc16 kernel: [<ffffffff810fde4e>] ? =20
oom_kill_process+0x25e/0x2a0
Oct 17 15:22:19 hpc16 kernel: [<ffffffff810fdf5e>] ? =20
select_bad_process+0xce/0x110
Oct 17 15:22:19 hpc16 kernel: [<ffffffff810fe448>] ? =20
out_of_memory+0x1a8/0x390
Oct 17 15:22:19 hpc16 kernel: [<ffffffff8110cb0a>] ? =20
__alloc_pages_nodemask+0x73a/0x750
Oct 17 15:22:19 hpc16 kernel: [<ffffffff8114d4f5>] ? =20
__mem_cgroup_commit_charge+0x45/0x90
Oct 17 15:22:19 hpc16 kernel: [<ffffffff8113d7fa>] ? =20
alloc_pages_vma+0x9a/0x190
Oct 17 15:22:19 hpc16 kernel: [<ffffffff8112443c>] ? =20
handle_pte_fault+0x4cc/0xa90
Oct 17 15:22:19 hpc16 kernel: [<ffffffff8113cefb>] ? =20
alloc_pages_current+0xab/0x110
Oct 17 15:22:19 hpc16 kernel: [<ffffffff8100bbae>] ? =20
invalidate_interrupt5+0xe/0x20
Oct 17 15:22:19 hpc16 kernel: [<ffffffff81124b2a>] ? =20
handle_mm_fault+0x12a/0x1b0
Oct 17 15:22:19 hpc16 kernel: [<ffffffff814a6789>] ? =20
do_page_fault+0x199/0x550
Oct 17 15:22:19 hpc16 kernel: [<ffffffff812500a8>] ? =20
call_rwsem_wake+0x18/0x30
Oct 17 15:22:19 hpc16 kernel: [<ffffffff8100bbae>] ? =20
invalidate_interrupt5+0xe/0x20
Oct 17 15:22:19 hpc16 kernel: [<ffffffff814a3965>] ? page_fault+0x25/0x=
30
Oct 17 15:22:19 hpc16 kernel: Mem-Info:
Oct 17 15:22:19 hpc16 kernel: Node 0 Normal per-cpu:
Oct 17 15:22:19 hpc16 kernel: CPU    0: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    1: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    2: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    3: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    4: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    5: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    6: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    7: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    8: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    9: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   10: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   11: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   12: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   13: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   14: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   15: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   16: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   17: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   18: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   19: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   20: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   21: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   22: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   23: hi:  186, btch:  31 usd:  18
Oct 17 15:22:19 hpc16 kernel: Node 1 DMA per-cpu:
Oct 17 15:22:19 hpc16 kernel: CPU    0: hi:    0, btch:   1 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    1: hi:    0, btch:   1 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    2: hi:    0, btch:   1 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    3: hi:    0, btch:   1 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    4: hi:    0, btch:   1 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    5: hi:    0, btch:   1 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    6: hi:    0, btch:   1 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    7: hi:    0, btch:   1 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    8: hi:    0, btch:   1 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    9: hi:    0, btch:   1 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   10: hi:    0, btch:   1 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   11: hi:    0, btch:   1 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   12: hi:    0, btch:   1 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   13: hi:    0, btch:   1 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   14: hi:    0, btch:   1 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   15: hi:    0, btch:   1 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   16: hi:    0, btch:   1 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   17: hi:    0, btch:   1 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   18: hi:    0, btch:   1 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   19: hi:    0, btch:   1 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   20: hi:    0, btch:   1 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   21: hi:    0, btch:   1 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   22: hi:    0, btch:   1 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   23: hi:    0, btch:   1 usd:   0
Oct 17 15:22:19 hpc16 kernel: Node 1 DMA32 per-cpu:
Oct 17 15:22:19 hpc16 kernel: CPU    0: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    1: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    2: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    3: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    4: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    5: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    6: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    7: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    8: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    9: hi:  186, btch:  31 usd:  55
Oct 17 15:22:19 hpc16 kernel: CPU   10: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   11: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   12: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   13: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   14: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   15: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   16: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   17: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   18: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   19: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   20: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   21: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   22: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   23: hi:  186, btch:  31 usd:   2
Oct 17 15:22:19 hpc16 kernel: Node 1 Normal per-cpu:
Oct 17 15:22:19 hpc16 kernel: CPU    0: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    1: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    2: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    3: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    4: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    5: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    6: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    7: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    8: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU    9: hi:  186, btch:  31 usd:  55
Oct 17 15:22:19 hpc16 kernel: CPU   10: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   11: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   12: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   13: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   14: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   15: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   16: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   17: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   18: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   19: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   20: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   21: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   22: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: CPU   23: hi:  186, btch:  31 usd:   0
Oct 17 15:22:19 hpc16 kernel: active_anon:71580973 inactive_anon:228137=
 =20
isolated_anon:0
Oct 17 15:22:19 hpc16 kernel: active_file:509 inactive_file:805 =20
isolated_file:0
Oct 17 15:22:19 hpc16 kernel: unevictable:1882 dirty:0 writeback:0 =20
unstable:0
Oct 17 15:22:19 hpc16 kernel: free:162389 slab_reclaimable:8722 =20
slab_unreclaimable:10370
Oct 17 15:22:19 hpc16 kernel: mapped:681 shmem:48 pagetables:1612154 =20
bounce:0
Oct 17 15:22:19 hpc16 kernel: Node 0 Normal free:32512kB min:32768kB =20
low:40960kB high:49152kB active_anon:146614460kB inactive_anon:353888kB=
 =20
active_file:2036kB inactive_file:2380kB unevictable:3348kB =20
isolated(anon):0kB isolated(file):0kB present:148930560kB mlocked:3348k=
B =20
dirty:0kB writeback:0kB mapped:504kB shmem:116kB slab_reclaimable:14076=
kB =20
slab_unreclaimable:23092kB kernel_stack:3728kB pagetables:292144kB =20
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 =20
all_unreclaimable? no
Oct 17 15:22:19 hpc16 kernel: lowmem_reserve[]: 0 0 0 0
Oct 17 15:22:19 hpc16 kernel: Node 1 DMA free:15916kB min:0kB low:0kB =20
high:0kB active_anon:0kB inactive_anon:0kB active_file:0kB =20
inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB=
 =20
present:15360kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0k=
B =20
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB =20
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:=
0 =20
all_unreclaimable? yes
Oct 17 15:22:19 hpc16 kernel: lowmem_reserve[]: 0 3243 145401 145401
Oct 17 15:22:19 hpc16 kernel: Node 1 DMA32 free:569668kB min:728kB =20
low:908kB high:1092kB active_anon:503032kB inactive_anon:2804kB =20
active_file:0kB inactive_file:124kB unevictable:0kB isolated(anon):0kB =
=20
isolated(file):0kB present:3321540kB mlocked:0kB dirty:0kB writeback:0k=
B =20
mapped:0kB shmem:0kB slab_reclaimable:4388kB slab_unreclaimable:528kB =20
kernel_stack:0kB pagetables:724kB unstable:0kB bounce:0kB =20
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Oct 17 15:22:19 hpc16 kernel: lowmem_reserve[]: 0 0 142157 142157
Oct 17 15:22:19 hpc16 kernel: Node 1 Normal free:31460kB min:32028kB =20
low:40032kB high:48040kB active_anon:139206456kB inactive_anon:555856kB=
 =20
active_file:0kB inactive_file:716kB unevictable:4180kB isolated(anon):0=
kB =20
isolated(file):0kB present:145569280kB mlocked:4180kB dirty:0kB =20
writeback:0kB mapped:2220kB shmem:76kB slab_reclaimable:16424kB =20
slab_unreclaimable:17860kB kernel_stack:1000kB pagetables:6155748kB =20
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 =20
all_unreclaimable? no
Oct 17 15:22:19 hpc16 kernel: lowmem_reserve[]: 0 0 0 0
Oct 17 15:22:19 hpc16 kernel: Node 0 Normal: 7383*4kB 0*8kB 1*16kB 2*32=
kB =20
1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB =3D 33516kB
Oct 17 15:22:19 hpc16 kernel: Node 1 DMA: 1*4kB 1*8kB 2*16kB 2*32kB 1*6=
4kB =20
1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB =3D 15916kB
Oct 17 15:22:19 hpc16 kernel: Node 1 DMA32: 1057*4kB 920*8kB 774*16kB =20
709*32kB 544*64kB 398*128kB 200*256kB 56*512kB 25*1024kB 12*2048kB =20
75*4096kB =3D 569668kB
Oct 17 15:22:19 hpc16 kernel: Node 1 Normal: 6885*4kB 11*8kB 0*16kB 0*3=
2kB =20
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB =3D 31724kB
Oct 17 15:22:19 hpc16 kernel: 1422 total pagecache pages
Oct 17 15:22:19 hpc16 kernel: 0 pages in swap cache
Oct 17 15:22:19 hpc16 kernel: Swap cache stats: add 0, delete 0, find 0=
/0
Oct 17 15:22:19 hpc16 kernel: Free swap  =3D 0kB
Oct 17 15:22:19 hpc16 kernel: Total swap =3D 0kB
Oct 17 15:22:19 hpc16 kernel: 75497471 pages RAM
Oct 17 15:22:19 hpc16 kernel: 1093826 pages reserved
Oct 17 15:22:19 hpc16 kernel: 11054 pages shared
Oct 17 15:22:19 hpc16 kernel: 74234502 pages non-shared
Oct 17 15:22:19 hpc16 kernel: [ pid ]   uid  tgid total_vm      rss cpu=
 =20
oom_adj oom_score_adj name
Oct 17 15:22:19 hpc16 kernel: [  673]     0   673     2679      187   =20
9     -17         -1000 udevd
Oct 17 15:22:19 hpc16 kernel: [ 1292]     0  1292     2678      174   =20
3     -17         -1000 udevd
Oct 17 15:22:19 hpc16 kernel: [ 1295]     0  1295     2678      169  =20
17     -17         -1000 udevd
Oct 17 15:22:19 hpc16 kernel: [ 1464]     0  1464    16017      357   =20
6       0             0 sshd
Oct 17 15:22:19 hpc16 kernel: [ 1695]     0  1695     1553      142  =20
12       0             0 portreserve
Oct 17 15:22:19 hpc16 kernel: [ 1702]     0  1702    62187      287   =20
0       0             0 rsyslogd
Oct 17 15:22:19 hpc16 kernel: [ 1731]     0  1731     2301      146  =20
15       0             0 irqbalance
Oct 17 15:22:19 hpc16 kernel: [ 1749]    32  1749     4768      206   =20
8       0             0 rpcbind
Oct 17 15:22:19 hpc16 kernel: [ 1769]    29  1769     5800      240   =20
0       0             0 rpc.statd
Oct 17 15:22:19 hpc16 kernel: [ 1828]     0  1828     6859      106  =20
15       0             0 rpc.idmapd
Oct 17 15:22:19 hpc16 kernel: [ 1919]    81  1919     5392      159  =20
13       0             0 dbus-daemon
Oct 17 15:22:19 hpc16 kernel: [ 1943]     0  1943     1033      156  =20
12       0             0 acpid
Oct 17 15:22:19 hpc16 kernel: [ 1952]    68  1952     6343      426  =20
15       0             0 hald
Oct 17 15:22:19 hpc16 kernel: [ 1953]     0  1953     4540      170   =20
0       0             0 hald-runner
Oct 17 15:22:19 hpc16 kernel: [ 1982]     0  1982     5069      152   =20
2       0             0 hald-addon-inpu
Oct 17 15:22:19 hpc16 kernel: [ 1989]    68  1989     4465      190   =20
0       0             0 hald-addon-acpi
Oct 17 15:22:19 hpc16 kernel: [ 2005]     0  2005    49312     1149  =20
13       0             0 snmpd
Oct 17 15:22:19 hpc16 kernel: [ 2013]    38  2013     7552      305  =20
16       0             0 ntpd
Oct 17 15:22:19 hpc16 kernel: [ 2101]     0  2101    19669      422  =20
20       0             0 master
Oct 17 15:22:19 hpc16 kernel: [ 2120]    89  2120    19732      418  =20
16       0             0 qmgr
Oct 17 15:22:19 hpc16 kernel: [ 2133]     0  2133    29710      205   =20
1       0             0 abrtd
Oct 17 15:22:19 hpc16 kernel: [ 2141]     0  2141     2304      145   =20
0       0             0 abrt-dump-oops
Oct 17 15:22:19 hpc16 kernel: [ 2157] 32114  2157   237261     1782   =20
0       0             0 python
Oct 17 15:22:19 hpc16 kernel: [ 2164]     0  2164    29311      291  =20
10       0             0 crond
Oct 17 15:22:19 hpc16 kernel: [ 2185]     0  2185     5373      110  =20
12       0             0 atd
Oct 17 15:22:19 hpc16 kernel: [ 2202]     0  2202    47595     1416   =20
8       0             0 certmaster
Oct 17 15:22:19 hpc16 kernel: [ 2211]     0  2211    82597     4644   =20
9       0             0 funcd
Oct 17 15:22:19 hpc16 kernel: [ 2218]     0  2218      996       89  =20
13       0             0 supervise
Oct 17 15:22:19 hpc16 kernel: [ 2228]     0  2228    27049      203   =20
2       0             0 run
Oct 17 15:22:19 hpc16 kernel: [ 2232]     0  2232    41699     3851   =20
0       0             0 perl
Oct 17 15:22:19 hpc16 kernel: [ 2242]     0  2242     1029      132  =20
19       0             0 mingetty
Oct 17 15:22:19 hpc16 kernel: [ 2244]     0  2244     1029      132   =20
1       0             0 mingetty
Oct 17 15:22:19 hpc16 kernel: [ 2246]     0  2246     1029      132  =20
15       0             0 mingetty
Oct 17 15:22:19 hpc16 kernel: [ 2248]     0  2248     1029      131  =20
16       0             0 mingetty
Oct 17 15:22:19 hpc16 kernel: [ 2250]     0  2250     1029      131  =20
17       0             0 mingetty
Oct 17 15:22:19 hpc16 kernel: [ 2252]     0  2252     1029      132  =20
15       0             0 mingetty
Oct 17 15:22:19 hpc16 kernel: [ 2278]     0  2278    44389     4667   =20
9       0             0 perl
Oct 17 15:22:19 hpc16 kernel: [ 2283]     0  2283    44389     4535   =20
9       0             0 perl
Oct 17 15:22:19 hpc16 kernel: [ 2301]     0  2301    23312      184  =20
15     -17         -1000 auditd
Oct 17 15:22:19 hpc16 kernel: [21038]     0 21038     3976     1883   =20
6       0             0 pbs_mom
Oct 17 15:22:19 hpc16 kernel: [11314] 32114 11314     2704      196  =20
15       0             0 cglimit
Oct 17 15:22:19 hpc16 kernel: [11319] 32114 11319    11089      394  =20
14       0             0 orted
Oct 17 15:22:19 hpc16 kernel: [11337] 32114 11337 842071788 71791393   =
=20
1       0             0 CF_user_based
Oct 17 15:22:19 hpc16 kernel: [24741]    89 24741    19689      414  =20
16       0             0 pickup
Oct 17 15:22:19 hpc16 kernel: Out of memory: Kill process 11337 =20
(CF_user_based) score 986 or sacrifice child
Oct 17 15:22:19 hpc16 kernel: Killed process 11337, UID 32114, =20
(CF_user_based) total-vm:3368287152kB, anon-rss:287164596kB, file-rss:9=
76kB



--=20
=CA=B9=D3=C3 Opera =B8=EF=C3=FC=D0=D4=B5=C4=B5=E7=D7=D3=D3=CA=BC=FE=BF=CD=
=BB=A7=B3=CC=D0=F2: http://www.opera.com/mail/
