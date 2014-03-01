From: Fengguang Wu <fengguang.wu@intel.com>
Subject: [cgroup/task_lock] include/linux/cgroup.h:705 suspicious
 rcu_dereference_check() usage!
Date: Sat, 1 Mar 2014 23:55:30 +0800
Message-ID: <20140301155530.GA11882@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="IJpNTDwzlM2Ie8A6"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.15
commit 0e1d768f1b1873272ec4e8dc1482bb5281855017
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue Feb 25 10:04:03 2014 -0500
Commit:     Tejun Heo <tj@kernel.org>
CommitDate: Tue Feb 25 10:04:03 2014 -0500

    cgroup: drop task_lock() protection around task->cgroups
    
    For optimization, task_lock() is additionally used to protect
    task->cgroups.  The optimization is pretty dubious as either
    css_set_rwsem is grabbed anyway or PF_EXITING already protects
    task->cgroups.  It adds only overhead and confusion at this point.
    Let's drop task_[un]lock() and update comments accordingly.
    
    Signed-off-by: Tejun Heo <tj@kernel.org>
    Acked-by: Li Zefan <lizefan@huawei.com>

+---------------------------------+----+
|                                 |    |
+---------------------------------+----+
| boot_successes                  | 0  |
| boot_failures                   | 19 |
| INFO:suspicious_RCU_usage       | 19 |
| backtrace:sched_setaffinity     | 19 |
| backtrace:SyS_sched_setaffinity | 19 |
+---------------------------------+----+

[    6.669173] mountall (89) used greatest stack depth: 6192 bytes left
[   18.371545] 
[   18.372365] ===============================
[   18.373961] [ INFO: suspicious RCU usage. ]
[   18.375319] 3.14.0-rc4-next-20140228-05738-gb148a42 #1 Not tainted
[   18.377213] -------------------------------
[   18.378541] include/linux/cgroup.h:705 suspicious rcu_dereference_check() usage!
[   18.381461] 
[   18.381461] other info that might help us debug this:
[   18.381461] 
[   18.384337] 
[   18.384337] rcu_scheduler_active = 1, debug_locks = 0
[   18.386486] 2 locks held by trinity-c0/3933:
[   18.387921]  #0:  (callback_mutex){+.+...}, at: [<c1174f22>] cpuset_cpus_allowed+0x2f/0xc1
[   18.391127]  #1:  (&(&p->alloc_lock)->rlock){+.+...}, at: [<c1174f37>] cpuset_cpus_allowed+0x44/0xc1
[   18.394605] 
[   18.394605] stack backtrace:
[   18.396302] CPU: 0 PID: 3933 Comm: trinity-c0 Not tainted 3.14.0-rc4-next-20140228-05738-gb148a42 #1
[   18.399067] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   18.400836]  00000001 00000001 c748bf38 c1eca7bd c748bf54 c1103fe2 c259fd3c c7f98590
[   18.404411]  c7f98590 c31d5850 c748bf84 c748bf64 c1171471 c7f98590 c7f989c4 c748bf78
[   18.407986]  c1174f4c c7f98590 c748bf84 c748bfa0 c748bf98 c10e3fdc 00000f5d c748bf98
[   18.411635] Call Trace:
[   18.412643]  [<c1eca7bd>] dump_stack+0x40/0x5e
[   18.414239]  [<c1103fe2>] lockdep_rcu_suspicious+0x1c0/0x1d7
[   18.415926]  [<c1171471>] task_cs+0x1e3/0x218
[   18.417502]  [<c1174f4c>] cpuset_cpus_allowed+0x59/0xc1
[   18.419083]  [<c10e3fdc>] sched_setaffinity+0x2c9/0x4c5
[   18.420772]  [<c10da19b>] ? copy_from_user+0x44/0x54
[   18.422306]  [<c10e434e>] SyS_sched_setaffinity+0x176/0x1a5
[   18.424083]  [<c1f106ea>] sysenter_do_call+0x12/0x3c
[   18.441975] rds_remove_bound(): rs c8ad5c00 unbinding from 127.0.0.1:4085
[   18.446612] rds_remove_bound(): rs cde8d100 unbinding from 127.172.176.165:42924
[   18.449784] rds_remove_bound(): rs cde93880 unbinding from 127.0.0.1:46584

git bisect start 0dbed0f2678036188d33c11bc4237026715f1a27 v3.13 --
git bisect good 1ccfe6f982674e4b7bd832b904bafcb3db890252  # 06:57     20+      0  watchdog: dw_wdt: Add dependency on HAS_IOMEM
git bisect good 21f1e2055bd55895d19f41d1b45594e1b7087d79  # 07:05     20+      0  Merge remote-tracking branch 'net/master'
git bisect good 5bc0c24c4dd821c5d6306b30c64cbb90f02a8b07  # 07:16     20+      0  Merge remote-tracking branch 'bluetooth/master'
git bisect good 49cba80449a365a063552f2048b1c715c4a997e0  # 07:25     20+      0  Merge remote-tracking branch 'edac-amd/for-next'
git bisect good 41e35f90e31db0ae1e6a9fae52b73cb6af8909af  # 07:38     20+      0  Merge remote-tracking branch 'staging/staging-next'
git bisect  bad 1c0951895878b4634316d448717119904ee6c53c  # 07:46      0-      2  Merge remote-tracking branch 'gpio/for-next'
git bisect  bad dea48a6cb5c45509a77f5ef3b13fa97d1bb0f389  # 07:51      0-      9  Merge remote-tracking branch 'target-updates/for-next'
git bisect good 91e268c5c1ff5106e5e33627eea6411e00400c81  # 07:59     20+      0  Merge remote-tracking branch 'char-misc/char-misc-next'
git bisect  bad bf90690a616351d514a75eefadeea6cf427b0ce3  # 08:05      0-      7  Merge remote-tracking branch 'cgroup/for-next'
git bisect good 96d365e0b86ee7ec6366c99669687e54c9f145e3  # 08:13     20+      0  cgroup: make css_set_lock a rwsem and rename it to css_set_rwsem
git bisect good 2220f5edf5f452480135b57b345e783ffc5c752d  # 08:19     20+      0  Merge branch 'for-3.15' into for-next
git bisect  bad 952aaa125428fae883670a2c2e40ea8044ca1eaa  # 08:24      0-     13  cgroup: update cgroup_transfer_tasks() to either succeed or fail
git bisect good b3dc094e93905ae9c1bc0815402ad8e5b203d068  # 08:30     20+      0  cgroup: use css_set->mg_tasks to track target tasks during migration
git bisect good 1958d2d53dadbb1c9aaf0b37741f13a60098b243  # 08:35     20+      0  cgroup: split process / task migration into four steps
git bisect  bad 0e1d768f1b1873272ec4e8dc1482bb5281855017  # 08:40      0-     11  cgroup: drop task_lock() protection around task->cgroups
git bisect good eaf797abc53b0ab3f0a02d4ef873a565fcce6daa  # 08:47     20+      0  cgroup: update how a newly forked task gets associated with css_set
# first bad commit: [0e1d768f1b1873272ec4e8dc1482bb5281855017] cgroup: drop task_lock() protection around task->cgroups
git bisect good eaf797abc53b0ab3f0a02d4ef873a565fcce6daa  # 08:50     60+      0  cgroup: update how a newly forked task gets associated with css_set
git bisect  bad b148a42ba7823e34971cd4e5b05a5c74fa3311ed  # 08:50      0-     19  Add linux-next specific files for 20140228
git bisect good 8f6eaa4b28ded2c03943a33d9b23325fd8f20841  # 08:59     60+      3  Revert "cgroup: drop task_lock() protection around task->cgroups"
git bisect good 8427defd087ae6c5eaea9d609dfe7f165568accd  # 09:08     60+      0  MAINTAINERS: add maintainer entry for Armada DRM driver
git bisect  bad b148a42ba7823e34971cd4e5b05a5c74fa3311ed  # 09:08      0-     19  Add linux-next specific files for 20140228

Thanks,
Fengguang

--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-cairo-11:20140301061810:i386-randconfig-c5-03010320:3.14.0-rc4-next-20140228-05738-gb148a42:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc4-next-20140228-05738-gb148a42 (kbuil=
d@cairo) (gcc version 4.8.1 (Debian 4.8.1-8) ) #1 Sat Mar 1 06:12:54 CST 20=
14
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] initial memory mapped: [mem 0x00000000-0x03bfffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 4k
[    0.000000] BRK [0x036da000, 0x036dafff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 4k
[    0.000000] BRK [0x036db000, 0x036dbfff] PGTABLE
[    0.000000] BRK [0x036dc000, 0x036dcfff] PGTABLE
[    0.000000] BRK [0x036dd000, 0x036ddfff] PGTABLE
[    0.000000] BRK [0x036de000, 0x036defff] PGTABLE
[    0.000000] BRK [0x036df000, 0x036dffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x07ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x0e7ab000-0x0ffeffff]
[    0.000000] ACPI: RSDP 0x000FD930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0FFFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x0FFFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x0FFFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x0FFFFF40 000040
[    0.000000] ACPI: SSDT 0x0FFFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x0FFFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x0FFFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 540 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 26ca580
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64860
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-c5-03010320/next:master/.vmlinuz-b148a42ba7823e34971cd4e=
5b05a5c74fa3311ed-20140301061624-9-cairo branch=3Dnext/master BOOT_IMAGE=3D=
/kernel/i386-randconfig-c5-03010320/b148a42ba7823e34971cd4e5b05a5c74fa3311e=
d/vmlinuz-3.14.0-rc4-next-20140228-05738-gb148a42
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 194276K/261744K available (15428K kernel code, 4761K=
 rwdata, 7724K rodata, 1004K init, 10764K bss, 67468K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe2000 - 0xfffff000   ( 116 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc2b4c000 - 0xc2c47000   (1004 kB)
[    0.000000]       .data : 0xc1f116f6 - 0xc2b4b440   (12519 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1f116f6   (15429 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3Dcdc0a000 soft=3Dcdc0c000
[    0.000000] ACPI: Core revision 20140114
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] ACPI: setting ELCR to 0200 (from 0c00)
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc4-next-20140228-05738-gb148a42 (kbuil=
d@cairo) (gcc version 4.8.1 (Debian 4.8.1-8) ) #1 Sat Mar 1 06:12:54 CST 20=
14
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] initial memory mapped: [mem 0x00000000-0x03bfffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 4k
[    0.000000] BRK [0x036da000, 0x036dafff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 4k
[    0.000000] BRK [0x036db000, 0x036dbfff] PGTABLE
[    0.000000] BRK [0x036dc000, 0x036dcfff] PGTABLE
[    0.000000] BRK [0x036dd000, 0x036ddfff] PGTABLE
[    0.000000] BRK [0x036de000, 0x036defff] PGTABLE
[    0.000000] BRK [0x036df000, 0x036dffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x07ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x0e7ab000-0x0ffeffff]
[    0.000000] ACPI: RSDP 0x000FD930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0FFFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x0FFFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x0FFFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x0FFFFF40 000040
[    0.000000] ACPI: SSDT 0x0FFFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x0FFFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x0FFFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 540 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 26ca580
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64860
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-c5-03010320/next:master/.vmlinuz-b148a42ba7823e34971cd4e=
5b05a5c74fa3311ed-20140301061624-9-cairo branch=3Dnext/master BOOT_IMAGE=3D=
/kernel/i386-randconfig-c5-03010320/b148a42ba7823e34971cd4e5b05a5c74fa3311e=
d/vmlinuz-3.14.0-rc4-next-20140228-05738-gb148a42
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 194276K/261744K available (15428K kernel code, 4761K=
 rwdata, 7724K rodata, 1004K init, 10764K bss, 67468K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe2000 - 0xfffff000   ( 116 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc2b4c000 - 0xc2c47000   (1004 kB)
[    0.000000]       .data : 0xc1f116f6 - 0xc2b4b440   (12519 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1f116f6   (15429 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3Dcdc0a000 soft=3Dcdc0c000
[    0.000000] ACPI: Core revision 20140114
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] ACPI: setting ELCR to 0200 (from 0c00)
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:  ok  |  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:  ok  |  ok  |  ok  |
[    0.000000]                               try:  ok  |  ok  |  ok  |
[    0.000000]                             block:  ok  |  ok  |  ok  |
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] allocated 524288 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2893.002 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 5788.08 Bogo=
MIPS (lpj=3D9643340)
[    0.007990] pid_max: default: 32768 minimum: 301
[    0.010527] Mount-cache hash table entries: 512
[    0.014922] Initializing cgroup subsys memory
[    0.016464] Initializing cgroup subsys freezer
[    0.016777] Initializing cgroup subsys net_cls
[    0.018076] Initializing cgroup subsys blkio
[    0.020033] Initializing cgroup subsys perf_event
[    0.021407] Initializing cgroup subsys net_prio
[    0.023603] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.023603] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.023603] tlb_flushall_shift: 6
[    0.026703] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.032090] ftrace: allocating 28680 entries in 57 pages
[    0.061504] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.070222] devtmpfs: initialized
[    0.072924] gcov: version magic: 0x3430382a
[    0.080995] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.085627] regulator-dummy: no parameters
[    0.088077] NET: Registered protocol family 16
[    0.092300] EISA bus registered
[    0.093424] cpuidle: using governor ladder
[    0.094795] cpuidle: using governor menu
[    0.097353] ACPI: bus type PCI registered
[    0.099598] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.100031] PCI: Using configuration type 1 for base access
[    0.136117] ACPI: Added _OSI(Module Device)
[    0.136696] ACPI: Added _OSI(Processor Device)
[    0.137929] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.140033] ACPI: Added _OSI(Processor Aggregator Device)
[    0.167044] ACPI: Interpreter enabled
[    0.168325] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140114/hwxface-580)
[    0.170873] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140114/hwxface-580)
[    0.173529] ACPI: (supports S0 S3 S5)
[    0.174643] ACPI: Using PIC for interrupt routing
[    0.176724] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.219867] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.220057] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.223509] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.227106] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.231198] PCI host bridge to bus 0000:00
[    0.232583] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.233374] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.235076] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.236703] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.238494] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.240393] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.245329] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.250155] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.256480] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.261411] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.263734] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.265763] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.268182] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.276779] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.280917] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.290893] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.294229] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.296513] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.297888] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.305733] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.308154] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.311839] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.315024] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.327600] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.330903] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.334235] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.346847] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.349999] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.351748] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.365750] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.368541] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.371739] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.384525] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.387536] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.390882] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.403550] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.406666] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.408411] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.422460] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.424299] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.434205] pci_bus 0000:00: on NUMA node 0
[    0.439097] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.441934] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.445039] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.448214] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.450383] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.455321] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.461737] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.463385] vgaarb: loaded
[    0.464417] vgaarb: bridge control possible 0000:00:02.0
[    0.469723] SCSI subsystem initialized
[    0.470130] ACPI: bus type USB registered
[    0.471760] usbcore: registered new interface driver usbfs
[    0.473538] usbcore: registered new interface driver hub
[    0.476760] usbcore: registered new device driver usb
[    0.478616] media: Linux media interface: v0.10
[    0.480272] Linux video capture interface: v2.00
[    0.481817] pps_core: LinuxPPS API ver. 1 registered
[    0.483261] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.483454] PTP clock support registered
[    0.486945] PCI: Using ACPI for IRQ routing
[    0.488218] PCI: pci_cache_line_size set to 64 bytes
[    0.490457] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.492227] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.497439] Bluetooth: Core ver 2.19
[    0.498765] NET: Registered protocol family 31
[    0.500028] Bluetooth: HCI device and connection manager initialized
[    0.501861] Bluetooth: HCI socket layer initialized
[    0.503400] Bluetooth: L2CAP socket layer initialized
[    0.505047] Bluetooth: SCO socket layer initialized
[    0.506755] NET: Registered protocol family 8
[    0.508117] NET: Registered protocol family 20
[    0.509654] nfc: nfc_init: NFC Core ver 0.1
[    0.510335] NET: Registered protocol family 39
[    0.513831] Switched to clocksource kvm-clock
[    0.515820] Could not create debugfs 'set_ftrace_filter' entry
[    0.517270] Could not create debugfs 'set_ftrace_notrace' entry
[    0.520311] Warning: could not register all branches stats
[    0.520311] Warning: could not register annotated branches stats
[    0.583894] FS-Cache: Loaded
[    0.585161] pnp: PnP ACPI init
[    0.586531] ACPI: bus type PNP registered
[    0.588517] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.590790] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.593075] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.595236] pnp 00:03: [dma 2]
[    0.596605] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.598981] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.601514] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.605096] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.607924] pnp: PnP ACPI: found 7 devices
[    0.609142] ACPI: bus type PNP unregistered
[    0.671068] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.672565] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.674205] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.675905] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.678330] NET: Registered protocol family 2
[    0.682150] TCP established hash table entries: 2048 (order: 1, 8192 byt=
es)
[    0.684384] TCP bind hash table entries: 2048 (order: 4, 73728 bytes)
[    0.686623] TCP: Hash tables configured (established 2048 bind 2048)
[    0.689264] TCP: reno registered
[    0.690579] UDP hash table entries: 256 (order: 2, 20480 bytes)
[    0.692462] UDP-Lite hash table entries: 256 (order: 2, 20480 bytes)
[    0.695476] NET: Registered protocol family 1
[    0.697006] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.698578] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.700322] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.701989] pci 0000:00:02.0: Boot video device
[    0.703574] PCI: CLS 0 bytes, default 64
[    0.705958] Unpacking initramfs...
[    3.411662] debug: unmapping init [mem 0xce7ab000-0xcffeffff]
[    3.543921] DMA-API: preallocated 65536 debug entries
[    3.545404] DMA-API: debugging enabled by kernel config
[    3.550195] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    3.552899] NatSemi SCx200 Driver
[    3.554447] cryptomgr_test (15) used greatest stack depth: 7076 bytes le=
ft
[    3.557327] spin_lock-torture:--- Start of test: nwriters_stress=3D2 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    3.561776] spin_lock-torture: Creating torture_shuffle task
[    3.564074] spin_lock-torture: Creating torture_stutter task
[    3.565922] spin_lock-torture: torture_shuffle task started
[    3.567792] spin_lock-torture: Creating lock_torture_writer task
[    3.569721] spin_lock-torture: torture_stutter task started
[    3.571502] spin_lock-torture: Creating lock_torture_writer task
[    3.573555] spin_lock-torture: lock_torture_writer task started
[    3.575386] spin_lock-torture: Creating lock_torture_stats task
[    3.577496] spin_lock-torture: lock_torture_writer task started
[    3.581247] futex hash table entries: 256 (order: 1, 10240 bytes)
[    3.583682] spin_lock-torture: lock_torture_stats task started
[    4.287983] Kprobe smoke test started
[    4.307610] Kprobe smoke test passed successfully
[    4.312396] VFS: Disk quotas dquot_6.5.2
[    4.314018] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    4.317198] fuse init (API version 7.22)
[    4.319368] NILFS version 2 loaded
[    4.323827] cryptomgr_test (28) used greatest stack depth: 6568 bytes le=
ft
[    4.329711] cryptomgr_test (33) used greatest stack depth: 6484 bytes le=
ft
[    4.332589] cryptomgr_test (34) used greatest stack depth: 6396 bytes le=
ft
[    4.344816] cryptomgr_test (47) used greatest stack depth: 6340 bytes le=
ft
[    4.349683] alg: No test for stdrng (krng)
[    4.352104] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    4.354717] io scheduler noop registered
[    4.356469] io scheduler cfq registered (default)
[    4.360744] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    4.363280] ACPI: Power Button [PWRF]
[    4.519976] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.545323] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    4.550391] tsc: Refined TSC clocksource calibration: 2892.986 MHz
[    4.581710] serial: Freescale lpuart driver
[    4.583043] Cyclades driver 2.6
[    4.604587] MOXA Smartio/Industio family driver version 2.0.5
[    4.606516] toshiba: not a supported Toshiba laptop
[    4.607685] scx200_gpio: no SCx200 gpio present
[    4.608503] nsc_gpio initializing
[    4.609268] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    4.610389] smapi::smapi_init, ERROR invalid usSmapiID
[    4.611317] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    4.612971] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    4.614417] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    4.615525] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    4.618203] Hangcheck: Using getrawmonotonic().
[    4.619884] [drm] Initialized drm 1.1.0 20060810
[    4.621856] dummy-irq: no IRQ given.  Use irq=3DN
[    4.623811] lkdtm: No crash points registered, enable through debugfs
[    4.627133] Loading iSCSI transport class v2.0-870.
[    4.631235] scsi: <fdomain> Detection failed (no card)
[    4.636090] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    4.637832] PCI: setting IRQ 11 as level-triggered
[    4.642434] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    4.644218] PCI: setting IRQ 10 as level-triggered
[    4.648718] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    4.653831] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    6.005760] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    6.008062] osst :I: Tape driver with OnStream support version 0.99.4
[    6.008062] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    6.026312] SCSI Media Changer driver v0.25=20
[    6.028697] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    6.030515] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    6.032580] usbcore: registered new interface driver usb-storage
[    6.034521] usbcore: registered new interface driver ums-alauda
[    6.036222] usbcore: registered new interface driver ums-karma
[    6.037805] usbcore: registered new interface driver ums-onetouch
[    6.039154] usbcore: registered new interface driver ums-realtek
[    6.040526] usbcore: registered new interface driver ums-sddr55
[    6.041744] usbcore: registered new interface driver ums-usbat
[    6.042976] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    6.044403] usbcore: registered new interface driver idmouse
[    6.045544] usbcore: registered new interface driver usbled
[    6.046666] usbcore: registered new interface driver legousbtower
[    6.048002] usbcore: registered new interface driver usb_ehset_test
[    6.049410] usbcore: registered new interface driver trancevibrator
[    6.050716] usbcore: registered new interface driver yurex
[    6.051891] usbcore: registered new interface driver sisusb
[    6.053313] usbcore: registered new interface driver cxacru
[    6.054573] usbcore: registered new interface driver speedtch
[    6.055907] usbcore: registered new interface driver ueagle-atm
[    6.057175] xusbatm: malformed module parameters
[    6.058411] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    6.061395] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.062481] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.066806] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    6.070506] usbcore: registered new interface driver usb_acecad
[    6.071678] usbcore: registered new interface driver gtco
[    6.072943] usbcore: registered new interface driver hanwang
[    6.076118] usbcore: registered new interface driver kbtab
[    6.077597] usbcore: registered new interface driver ati_remote2
[    6.079143] usbcore: registered new interface driver ims_pcu
[    6.080382] usbcore: registered new interface driver keyspan_remote
[    6.082033] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    6.083587] usbcore: registered new interface driver powermate
[    6.085137] wistron_btns: System unknown
[    6.086058] i2c /dev entries driver
[    6.086981] scx200_i2c: no SCx200 gpio pins available
[    6.089230] pps pps0: new PPS source ktimer
[    6.090210] pps pps0: ktimer PPS source registered
[    6.093074] Bluetooth: Virtual HCI driver ver 1.4
[    6.094558] usbcore: registered new interface driver bcm203x
[    6.096165] ledtrig-cpu: registered to indicate activity on CPUs
[    6.097953] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    6.099876] pktgen: Packet Generator for packet performance testing. Ver=
sion: 2.74
[    6.102068] drop_monitor: Initializing network drop monitor service
[    6.103697] Netfilter messages via NETLINK v0.30.
[    6.104971] nf_conntrack version 0.5.0 (3035 buckets, 12140 max)
[    6.106510] nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>
[    6.108179] ip_set: protocol 6
[    6.109171] IPVS: Registered protocols (TCP, UDP, SCTP, AH)
[    6.110408] IPVS: Connection hash table configured (size=3D4096, memory=
=3D32Kbytes)
[    6.112216] IPVS: Creating netns size=3D1488 id=3D0
[    6.113485] IPVS: ipvs loaded.
[    6.114249] IPVS: [wrr] scheduler registered.
[    6.115230] IPVS: [lblcr] scheduler registered.
[    6.116174] IPVS: [sh] scheduler registered.
[    6.117459] ip_tables: (C) 2000-2006 Netfilter Core Team
[    6.118584] TCP: bic registered
[    6.119382] TCP: cubic registered
[    6.120246] TCP: westwood registered
[    6.121161] TCP: highspeed registered
[    6.121907] TCP: hybla registered
[    6.122669] TCP: veno registered
[    6.123538] TCP: scalable registered
[    6.124307] TCP: illinois registered
[    6.125209] Initializing XFRM netlink socket
[    6.126629] Bluetooth: RFCOMM TTY layer initialized
[    6.127805] Bluetooth: RFCOMM socket layer initialized
[    6.128868] Bluetooth: RFCOMM ver 1.11
[    6.129735] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    6.130814] Bluetooth: BNEP filters: protocol multicast
[    6.132280] Bluetooth: BNEP socket layer initialized
[    6.133658] NET: Registered protocol family 33
[    6.134603] Key type rxrpc registered
[    6.135395] Key type rxrpc_s registered
[    6.136350] lec:lane_module_init: lec.c: initialized
[    6.137581] 8021q: 802.1Q VLAN Support v1.8
[    6.139098] NET: Registered protocol family 21
[    6.140318] Registered RDS/tcp transport
[    6.141922] Key type ceph registered
[    6.142928] libceph: loaded (mon/osd proto 15/24)
[    6.144271] batman_adv: B.A.T.M.A.N. advanced 2014.1.0 (compatibility ve=
rsion 15) loaded
[    6.146000] openvswitch: Open vSwitch switching datapath
[    6.151949] Key type encrypted registered
[    6.155718] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    6.158274] ### dt-test ### No testcase data in device tree; not running=
 tests
[    6.160947] debug: unmapping init [mem 0xc2b4c000-0xc2c46fff]
[    6.180902] random: init urandom read with 24 bits of entropy available
[    6.513230] init: Failed to create pty - disabling logging for job
[    6.515689] init: Temporary process spawn error: No space left on device
[    6.628954] init: mounted-tmp main process (105) terminated with status =
32
[    6.669173] mountall (89) used greatest stack depth: 6192 bytes left
[   18.371545]=20
[   18.372365] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   18.373961] [ INFO: suspicious RCU usage. ]
[   18.375319] 3.14.0-rc4-next-20140228-05738-gb148a42 #1 Not tainted
[   18.377213] -------------------------------
[   18.378541] include/linux/cgroup.h:705 suspicious rcu_dereference_check(=
) usage!
[   18.381461]=20
[   18.381461] other info that might help us debug this:
[   18.381461]=20
[   18.384337]=20
[   18.384337] rcu_scheduler_active =3D 1, debug_locks =3D 0
[   18.386486] 2 locks held by trinity-c0/3933:
[   18.387921]  #0:  (callback_mutex){+.+...}, at: [<c1174f22>] cpuset_cpus=
_allowed+0x2f/0xc1
[   18.391127]  #1:  (&(&p->alloc_lock)->rlock){+.+...}, at: [<c1174f37>] c=
puset_cpus_allowed+0x44/0xc1
[   18.394605]=20
[   18.394605] stack backtrace:
[   18.396302] CPU: 0 PID: 3933 Comm: trinity-c0 Not tainted 3.14.0-rc4-nex=
t-20140228-05738-gb148a42 #1
[   18.399067] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   18.400836]  00000001 00000001 c748bf38 c1eca7bd c748bf54 c1103fe2 c259f=
d3c c7f98590
[   18.404411]  c7f98590 c31d5850 c748bf84 c748bf64 c1171471 c7f98590 c7f98=
9c4 c748bf78
[   18.407986]  c1174f4c c7f98590 c748bf84 c748bfa0 c748bf98 c10e3fdc 00000=
f5d c748bf98
[   18.411635] Call Trace:
[   18.412643]  [<c1eca7bd>] dump_stack+0x40/0x5e
[   18.414239]  [<c1103fe2>] lockdep_rcu_suspicious+0x1c0/0x1d7
[   18.415926]  [<c1171471>] task_cs+0x1e3/0x218
[   18.417502]  [<c1174f4c>] cpuset_cpus_allowed+0x59/0xc1
[   18.419083]  [<c10e3fdc>] sched_setaffinity+0x2c9/0x4c5
[   18.420772]  [<c10da19b>] ? copy_from_user+0x44/0x54
[   18.422306]  [<c10e434e>] SyS_sched_setaffinity+0x176/0x1a5
[   18.424083]  [<c1f106ea>] sysenter_do_call+0x12/0x3c
[   18.441975] rds_remove_bound(): rs c8ad5c00 unbinding from 127.0.0.1:4085
[   18.446612] rds_remove_bound(): rs cde8d100 unbinding from 127.172.176.1=
65:42924
[   18.449784] rds_remove_bound(): rs cde93880 unbinding from 127.0.0.1:465=
84
[   18.453947] rds_remove_bound(): rs c7ff8780 unbinding from 127.97.44.75:=
63244
[   49.976926] random: nonblocking pool is initialized
[   63.583671] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[   66.438629] init: plymouth-upstart-bridge main process (3938) terminated=
 with status 1
[   66.447886] init: hwclock-save main process (3937) terminated with statu=
s 70
[   67.035806] init: Re-executing /init
[   68.159696] Unregister pv shared memory for cpu 0
[   68.161118] spin_lock-torture: Unscheduled system shutdown detected
[   68.163476] torture thread torture_stutter parking due to system shutdown
[   68.165128] torture thread torture_shuffle parking due to system shutdown
[   68.170303] reboot: Restarting system
[   68.171627] reboot: machine restart
Elapsed time: 75
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-c=
5-03010320/b148a42ba7823e34971cd4e5b05a5c74fa3311ed/vmlinuz-3.14.0-rc4-next=
-20140228-05738-gb148a42 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,1=
15200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-c5-03010320/next:master/.vmlinuz-b148a42ba7823e34971cd4e=
5b05a5c74fa3311ed-20140301061624-9-cairo branch=3Dnext/master BOOT_IMAGE=3D=
/kernel/i386-randconfig-c5-03010320/b148a42ba7823e34971cd4e5b05a5c74fa3311e=
d/vmlinuz-3.14.0-rc4-next-20140228-05738-gb148a42'  -initrd /kernel-tests/i=
nitrd/quantal-core-i386.cgz -m 256 -smp 2 -net nic,vlan=3D1,model=3De1000 -=
net user,vlan=3D1,hostfwd=3Dtcp::10854-:22 -boot order=3Dnc -no-reboot -wat=
chdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs/LABEL=3DKVM/disk0-qu=
antal-cairo-11,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1=
-quantal-cairo-11,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/di=
sk2-quantal-cairo-11,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM=
/disk3-quantal-cairo-11,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3D=
KVM/disk4-quantal-cairo-11,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=
=3DKVM/disk5-quantal-cairo-11,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kb=
oot/pid-quantal-cairo-11 -serial file:/dev/shm/kboot/serial-quantal-cairo-1=
1 -daemonize -display none -monitor null=20

--IJpNTDwzlM2Ie8A6
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-c5-03010320-b148a42ba7823e34971cd4e5b05a5c74fa3311ed-INFO:-suspicious-RCU-usage--52439.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDBkYmVkMGYyNjc4MDM2MTg4ZDMzYzExYmM0MjM3MDI2NzE1ZjFhMjcK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jNS0w
MzAxMDMyMC9uZXh0Om1hc3RlcjowZGJlZDBmMjY3ODAzNjE4OGQzM2MxMWJjNDIzNzAyNjcx
NWYxYTI3OmJpc2VjdC1saW51eDYKCjIwMTQtMDMtMDEtMDY6MzU6MTcgMGRiZWQwZjI2Nzgw
MzYxODhkMzNjMTFiYzQyMzcwMjY3MTVmMWEyNyBjb21waWxpbmcKMzYyIHJlYWwgIDM0MjMg
dXNlciAgMjI0IHN5cyAgMTAwNy43MSUgY3B1IAlpMzg2LXJhbmRjb25maWctYzUtMDMwMTAz
MjAKCjIwMTQtMDMtMDEtMDY6NDE6NDkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJj
NC0wNTQwMy1nMGRiZWQwZi4uLiBURVNUIEZBSUxVUkUKWyAgICA3LjIxODU5NF0gaW5pdDog
cGx5bW91dGgtbG9nIG1haW4gcHJvY2VzcyAoMTE2KSB0ZXJtaW5hdGVkIHdpdGggc3RhdHVz
IDEKWyAgIDE5LjgyMjMzNF0gClsgICAxOS44MjMyOTBdID09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT0KWyAgIDE5LjgyNDk1OV0gWyBJTkZPOiBzdXNwaWNpb3VzIFJDVSB1c2Fn
ZS4gXQpbICAgMTkuODI2NjQ4XSAzLjE0LjAtcmM0LTA1NDAzLWcwZGJlZDBmICM4NSBOb3Qg
dGFpbnRlZApbICAgMTkuODI4NTk4XSAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
ClsgICAxOS44MzAzMzhdIC9rZXJuZWwtdGVzdHMvbGludXg2L2luY2x1ZGUvbGludXgvY2dy
b3VwLmg6NzA1IHN1c3BpY2lvdXMgcmN1X2RlcmVmZXJlbmNlX2NoZWNrKCkgdXNhZ2UhClsg
ICAxOS44MzM1NTldIApbICAgMTkuODMzNTU5XSBvdGhlciBpbmZvIHRoYXQgbWlnaHQgaGVs
cCB1cyBkZWJ1ZyB0aGlzOgpbICAgMTkuODMzNTU5XSAKWyAgIDE5LjgzNjg0NV0gClsgICAx
OS44MzY4NDVdIHJjdV9zY2hlZHVsZXJfYWN0aXZlID0gMSwgZGVidWdfbG9ja3MgPSAwClsg
ICAxOS44MzkzMThdIDIgbG9ja3MgaGVsZCBieSB0cmluaXR5LWMwLzM5NTU6ClsgICAxOS44
NDA5MDhdICAjMDogIChjYWxsYmFja19tdXRleCl7Ky4rLi4ufSwgYXQ6IFs8YzExNzUzMzM+
XSBjcHVzZXRfY3B1c19hbGxvd2VkKzB4MmYvMHhjMQpbICAgMTkuODQ0Njg1XSAgIzE6ICAo
JigmcC0+YWxsb2NfbG9jayktPnJsb2NrKXsrLisuLi59LCBhdDogWzxjMTE3NTM0OD5dIGNw
dXNldF9jcHVzX2FsbG93ZWQrMHg0NC8weGMxClsgICAxOS44NDg4NDJdIApbICAgMTkuODQ4
ODQyXSBzdGFjayBiYWNrdHJhY2U6ClsgICAxOS44NTA4ODldIENQVTogMCBQSUQ6IDM5NTUg
Q29tbTogdHJpbml0eS1jMCBOb3QgdGFpbnRlZCAzLjE0LjAtcmM0LTA1NDAzLWcwZGJlZDBm
ICM4NQpbICAgMTkuODUzODQzXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBC
b2NocyAwMS8wMS8yMDExClsgICAxOS44NTU5MjRdICAwMDAwMDAwMSAwMDAwMDAwMSBjN2Q1
MWYzOCBjMWVjNzA4NCBjN2Q1MWY1NCBjMTEwNDNmOSBjMjU5YTljZCBjMDI2ZTMxMApbICAg
MTkuODYwNDU1XSAgYzAyNmUzMTAgYzMxYmY5NTggYzdkNTFmODQgYzdkNTFmNjQgYzExNzE4
ODIgYzAyNmUzMTAgYzAyNmU3NDQgYzdkNTFmNzgKWyAgIDE5Ljg2NDg0N10gIGMxMTc1MzVk
IGMwMjZlMzEwIGM3ZDUxZjg0IGM3ZDUxZmEwIGM3ZDUxZjk4IGMxMGU0MGQ3IDAwMDAwZjcz
IGM3ZDUxZjk4ClsgICAxOS44NjkyMzBdIENhbGwgVHJhY2U6ClsgICAxOS44NzA1NTZdICBb
PGMxZWM3MDg0Pl0gZHVtcF9zdGFjaysweDQwLzB4NWUKWyAgIDE5Ljg3MjIzNV0gIFs8YzEx
MDQzZjk+XSBsb2NrZGVwX3JjdV9zdXNwaWNpb3VzKzB4MWMwLzB4MWQ3ClsgICAxOS44NzQy
NDJdICBbPGMxMTcxODgyPl0gdGFza19jcysweDFlMy8weDIxOApbICAgMTkuODc1Njg5XSAg
WzxjMTE3NTM1ZD5dIGNwdXNldF9jcHVzX2FsbG93ZWQrMHg1OS8weGMxClsgICAxOS44Nzc2
MzZdICBbPGMxMGU0MGQ3Pl0gc2NoZWRfc2V0YWZmaW5pdHkrMHgyYzkvMHg0YzUKWyAgIDE5
Ljg3OTU2NV0gIFs8YzEwZGEyOTY+XSA/IGNvcHlfZnJvbV91c2VyKzB4NDQvMHg1NApbICAg
MTkuODgxNDk0XSAgWzxjMTBlNDQ0OT5dIFN5U19zY2hlZF9zZXRhZmZpbml0eSsweDE3Ni8w
eDFhNQpbICAgMTkuODgzNjI5XSAgWzxjMWYwY2ZjYT5dIHN5c2VudGVyX2RvX2NhbGwrMHgx
Mi8weDNjClsgICAxOS44OTUzNzhdIFZGUzogV2FybmluZzogdHJpbml0eS1jMCB1c2luZyBv
bGQgc3RhdCgpIGNhbGwuIFJlY29tcGlsZSB5b3VyIGJpbmFyeS4KWyAgIDE5LjkwMjYzMV0g
dHJpbml0eS1jMCAoMzk1NikgdXNlZCBncmVhdGVzdCBzdGFjayBkZXB0aDogNjE2MCBieXRl
cyBsZWZ0ClsgICAxOS45MTQ5NjNdIHJkc19yZW1vdmVfYm91bmQoKTogcnMgYzAzMmUxMDAg
dW5iaW5kaW5nIGZyb20gMTI3LjEyLjE1Ny42OToxMDk0Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWM1LTAzMDEwMzIwLzBkYmVkMGYyNjc4MDM2MTg4ZDMzYzExYmM0MjM3MDI2NzE1ZjFh
MjcvZG1lc2ctcXVhbnRhbC1hdGhlbnMtMzk6MjAxNDAzMDEwNjQzMDM6aTM4Ni1yYW5kY29u
ZmlnLWM1LTAzMDEwMzIwOjMuMTQuMC1yYzQtMDU0MDMtZzBkYmVkMGY6ODUKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjAvMGRiZWQwZjI2NzgwMzYxODhkMzNjMTFiYzQy
MzcwMjY3MTVmMWEyNy9kbWVzZy1xdWFudGFsLWNhaXJvLTQwOjIwMTQwMzAxMDY0MzAyOmkz
ODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMDozLjE0LjAtcmM0LTA1NDAzLWcwZGJlZDBmOjg1
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwLzBkYmVkMGYyNjc4MDM2MTg4
ZDMzYzExYmM0MjM3MDI2NzE1ZjFhMjcvZG1lc2ctcXVhbnRhbC1pbm4tMjoyMDE0MDMwMTA2
NDMwMzppMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjA6Ogova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1jNS0wMzAxMDMyMC8wZGJlZDBmMjY3ODAzNjE4OGQzM2MxMWJjNDIzNzAyNjcxNWYx
YTI3L2RtZXNnLXF1YW50YWwtcm9hbS0xOjIwMTQwMzAxMDY0MzAxOmkzODYtcmFuZGNvbmZp
Zy1jNS0wMzAxMDMyMDozLjE0LjAtcmM0LTA1NDAzLWcwZGJlZDBmOjg1Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwLzBkYmVkMGYyNjc4MDM2MTg4ZDMzYzExYmM0MjM3
MDI2NzE1ZjFhMjcvZG1lc2ctcXVhbnRhbC1zbmItMjM6MjAxNDAzMDEwNjQzMTA6aTM4Ni1y
YW5kY29uZmlnLWM1LTAzMDEwMzIwOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzUtMDMw
MTAzMjAvMGRiZWQwZjI2NzgwMzYxODhkMzNjMTFiYzQyMzcwMjY3MTVmMWEyNy9kbWVzZy15
b2N0by1pbm4tOToyMDE0MDMwMTA2NDMwOTppMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjA6
Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMC8wZGJlZDBmMjY3ODAzNjE4
OGQzM2MxMWJjNDIzNzAyNjcxNWYxYTI3L2RtZXNnLXF1YW50YWwtcm9hbS0yODoyMDE0MDMw
MTA2NDMxNTppMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjA6My4xNC4wLXJjNC0wNTQwMy1n
MGRiZWQwZjo4NQowOjc6NyBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAx
NC0wMy0wMSAwNjo0MzoyMCBSRVBFQVQgQ09VTlQ6IDIwICAjIC9rZXJuZWwtdGVzdHMvbGlu
dXg2L29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCmJpc2VjdDogYmFkIGNvbW1pdCAwZGJlZDBm
MjY3ODAzNjE4OGQzM2MxMWJjNDIzNzAyNjcxNWYxYTI3CmdpdCBjaGVja291dCB2My4xMwps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWM1LTAz
MDEwMzIwL25leHQ6bWFzdGVyOmQ4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYw
ZTY0YmU6YmlzZWN0LWxpbnV4NgoKMjAxNC0wMy0wMS0wNjo0MzoyMyBkOGVjMjZkN2Y4Mjg3
ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlIGNvbXBpbGluZwoyNTYgcmVhbCAgMzI4NyB1
c2VyICAyMDggc3lzICAxMzY0LjUxJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMy
MAoKMjAxNC0wMy0wMS0wNjo0Nzo1OCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEzLjAuLgk1
CTE4CTIwIFNVQ0NFU1MKCmJpc2VjdDogZ29vZCBjb21taXQgdjMuMTMKZ2l0IGJpc2VjdCBz
dGFydCAwZGJlZDBmMjY3ODAzNjE4OGQzM2MxMWJjNDIzNzAyNjcxNWYxYTI3IHYzLjEzIC0t
Ci9jL2tlcm5lbC10ZXN0cy9saW5lYXItYmlzZWN0OiBbIi1iIiwgIjBkYmVkMGYyNjc4MDM2
MTg4ZDMzYzExYmM0MjM3MDI2NzE1ZjFhMjciLCAiLWciLCAidjMuMTMiLCAiL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCIsICIva2VybmVsLXRlc3RzL2xp
bnV4Ni9vYmotYmlzZWN0Il0KQmlzZWN0aW5nOiAxNzkyMiByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTUgc3RlcHMpClsxY2NmZTZmOTgyNjc0ZTRiN2Jk
ODMyYjkwNGJhZmNiM2RiODkwMjUyXSB3YXRjaGRvZzogZHdfd2R0OiBBZGQgZGVwZW5kZW5j
eSBvbiBIQVNfSU9NRU0KcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg2L29iai1iaXNlY3QKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMC9u
ZXh0Om1hc3RlcjoxY2NmZTZmOTgyNjc0ZTRiN2JkODMyYjkwNGJhZmNiM2RiODkwMjUyOmJp
c2VjdC1saW51eDYKCjIwMTQtMDMtMDEtMDY6NTA6MzMgMWNjZmU2Zjk4MjY3NGU0YjdiZDgz
MmI5MDRiYWZjYjNkYjg5MDI1MiBjb21waWxpbmcKMjU2IHJlYWwgIDMzNjEgdXNlciAgMjEz
IHN5cyAgMTM5NS42MiUgY3B1IAlpMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjAKCjIwMTQt
MDMtMDEtMDY6NTU6MTAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjMS0wMDE1MS1n
MWNjZmU2Zi4uCTUJMTcJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA2NDA0IHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMyBzdGVwcykKWzIxZjFlMjA1NWJk
NTU4OTVkMTlmNDFkMWI0NTU5NGUxYjcwODdkNzldIE1lcmdlIHJlbW90ZS10cmFja2luZyBi
cmFuY2ggJ25ldC9tYXN0ZXInCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4Ni9vYmotYmlzZWN0CmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzUtMDMwMTAz
MjAvbmV4dDptYXN0ZXI6MjFmMWUyMDU1YmQ1NTg5NWQxOWY0MWQxYjQ1NTk0ZTFiNzA4N2Q3
OTpiaXNlY3QtbGludXg2CgoyMDE0LTAzLTAxLTA2OjU3OjQ0IDIxZjFlMjA1NWJkNTU4OTVk
MTlmNDFkMWI0NTU5NGUxYjcwODdkNzkgY29tcGlsaW5nCjI1MSByZWFsICAzMzY1IHVzZXIg
IDIxOSBzeXMgIDE0MjguNTElIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwCgoy
MDE0LTAzLTAxLTA3OjAyOjE0IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzQtMDAx
NDYtZzIxZjFlMjAuLgkxCTkJMTkJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA1MjU3IHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMyBzdGVwcykKWzViYzBj
MjRjNGRkODIxYzVkNjMwNmIzMGM2NGNiYjkwZjAyYThiMDddIE1lcmdlIHJlbW90ZS10cmFj
a2luZyBicmFuY2ggJ2JsdWV0b290aC9tYXN0ZXInCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4Ni9vYmot
YmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctYzUtMDMwMTAzMjAvbmV4dDptYXN0ZXI6NWJjMGMyNGM0ZGQ4MjFjNWQ2MzA2YjMwYzY0
Y2JiOTBmMDJhOGIwNzpiaXNlY3QtbGludXg2CgoyMDE0LTAzLTAxLTA3OjA1OjE5IDViYzBj
MjRjNGRkODIxYzVkNjMwNmIzMGM2NGNiYjkwZjAyYThiMDcgY29tcGlsaW5nCjQwNSByZWFs
ICAzMzYwIHVzZXIgIDIxOCBzeXMgIDg4My4wMiUgY3B1IAlpMzg2LXJhbmRjb25maWctYzUt
MDMwMTAzMjAKCjIwMTQtMDMtMDEtMDc6MTI6MzMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4x
NC4wLXJjNC0wMjY4NS1nNWJjMGMyNC4uLgk0CTEzCTE4CTIwIFNVQ0NFU1MKCkJpc2VjdGlu
ZzogMjcxOCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTIg
c3RlcHMpCls0OWNiYTgwNDQ5YTM2NWEwNjM1NTJmMjA0OGIxYzcxNWM0YTk5N2UwXSBNZXJn
ZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdlZGFjLWFtZC9mb3ItbmV4dCcKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVz
dHMvbGludXg2L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3Zt
L2kzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMC9uZXh0Om1hc3Rlcjo0OWNiYTgwNDQ5YTM2
NWEwNjM1NTJmMjA0OGIxYzcxNWM0YTk5N2UwOmJpc2VjdC1saW51eDYKCjIwMTQtMDMtMDEt
MDc6MTY6MjIgNDljYmE4MDQ0OWEzNjVhMDYzNTUyZjIwNDhiMWM3MTVjNGE5OTdlMCBjb21w
aWxpbmcKMjU0IHJlYWwgIDMzOTUgdXNlciAgMjIyIHN5cyAgMTQyMy4yNSUgY3B1IAlpMzg2
LXJhbmRjb25maWctYzUtMDMwMTAzMjAKCjIwMTQtMDMtMDEtMDc6MjI6MDIgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgMy4xNC4wLXJjNC0wNDIzMC1nNDljYmE4MC4uLgk2CTE4CTIwIFNVQ0NF
U1MKCkJpc2VjdGluZzogMTE3MyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgMTEgc3RlcHMpCls0MWUzNWY5MGUzMWRiMGFlMWU2YTlmYWU1MmI3M2NiNmFm
ODkwOWFmXSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdzdGFnaW5nL3N0YWdpbmct
bmV4dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9rZXJuZWwtdGVzdHMvbGludXg2L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMC9uZXh0Om1hc3Rl
cjo0MWUzNWY5MGUzMWRiMGFlMWU2YTlmYWU1MmI3M2NiNmFmODkwOWFmOmJpc2VjdC1saW51
eDYKCjIwMTQtMDMtMDEtMDc6MjU6MDUgNDFlMzVmOTBlMzFkYjBhZTFlNmE5ZmFlNTJiNzNj
YjZhZjg5MDlhZiBjb21waWxpbmcKNjE0IHJlYWwgIDM0MTkgdXNlciAgMjI2IHN5cyAgNTkz
LjU1JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMAoKMjAxNC0wMy0wMS0wNzoz
NTo0NyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmM0LTA1MTA1LWc0MWUzNWY5Li4J
MQk1CTE5CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMjk4IHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBzKQpbMWMwOTUxODk1ODc4YjQ2MzQzMTZk
NDQ4NzE3MTE5OTA0ZWU2YzUzY10gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnZ3Bp
by9mb3ItbmV4dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg2L29iai1iaXNlY3QKbHMgLWEgL2tlcm5l
bC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMC9uZXh0
Om1hc3RlcjoxYzA5NTE4OTU4NzhiNDYzNDMxNmQ0NDg3MTcxMTk5MDRlZTZjNTNjOmJpc2Vj
dC1saW51eDYKCjIwMTQtMDMtMDEtMDc6Mzk6MDcgMWMwOTUxODk1ODc4YjQ2MzQzMTZkNDQ4
NzE3MTE5OTA0ZWU2YzUzYyBjb21waWxpbmcKMjkxIHJlYWwgIDI0MTUgdXNlciAgMTU3IHN5
cyAgODgxLjQ2JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMAoKMjAxNC0wMy0w
MS0wNzo0NDozOCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmM0LTA1MzI1LWcxYzA5
NTE4Li4uIFRFU1QgRkFJTFVSRQpbICAgIDcuMDk4NjAwXSBpbml0OiBwbHltb3V0aC1sb2cg
bWFpbiBwcm9jZXNzICgxMTkpIHRlcm1pbmF0ZWQgd2l0aCBzdGF0dXMgMQpbICAgMjAuMTgy
NTQ0XSAKWyAgIDIwLjE4MzMzNF0gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQpb
ICAgMjAuMTg0NzA1XSBbIElORk86IHN1c3BpY2lvdXMgUkNVIHVzYWdlLiBdClsgICAyMC4x
ODU5OTNdIDMuMTQuMC1yYzQtMDUzMjUtZzFjMDk1MTggIzkyIE5vdCB0YWludGVkClsgICAy
MC4xODc1NDZdIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KWyAgIDIwLjE4ODgx
NV0gL2tlcm5lbC10ZXN0cy9saW51eDYvaW5jbHVkZS9saW51eC9jZ3JvdXAuaDo3MDUgc3Vz
cGljaW91cyByY3VfZGVyZWZlcmVuY2VfY2hlY2soKSB1c2FnZSEKWyAgIDIwLjE5MTQ4N10g
ClsgICAyMC4xOTE0ODddIG90aGVyIGluZm8gdGhhdCBtaWdodCBoZWxwIHVzIGRlYnVnIHRo
aXM6ClsgICAyMC4xOTE0ODddIApbICAgMjAuMTk0MjY3XSAKWyAgIDIwLjE5NDI2N10gcmN1
X3NjaGVkdWxlcl9hY3RpdmUgPSAxLCBkZWJ1Z19sb2NrcyA9IDAKWyAgIDIwLjE5NjMzN10g
MiBsb2NrcyBoZWxkIGJ5IHRyaW5pdHktYzAvMzk0OToKWyAgIDIwLjE5NzczMl0gICMwOiAg
KGNhbGxiYWNrX211dGV4KXsrLisuLi59LCBhdDogWzxjMTE3NTMzMz5dIGNwdXNldF9jcHVz
X2FsbG93ZWQrMHgyZi8weGMxClsgICAyMC4yMDEwNTRdICAjMTogICgmKCZwLT5hbGxvY19s
b2NrKS0+cmxvY2speysuKy4uLn0sIGF0OiBbPGMxMTc1MzQ4Pl0gY3B1c2V0X2NwdXNfYWxs
b3dlZCsweDQ0LzB4YzEKWyAgIDIwLjIwNDM3OV0gClsgICAyMC4yMDQzNzldIHN0YWNrIGJh
Y2t0cmFjZToKWyAgIDIwLjIwNjAyMV0gQ1BVOiAwIFBJRDogMzk0OSBDb21tOiB0cmluaXR5
LWMwIE5vdCB0YWludGVkIDMuMTQuMC1yYzQtMDUzMjUtZzFjMDk1MTggIzkyClsgICAyMC4y
MDg0NjhdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIw
MTEKWyAgIDIwLjIxMDE4MF0gIDAwMDAwMDAxIDAwMDAwMDAxIGM3ZDU5ZjM4IGMxZWM2OWU4
IGM3ZDU5ZjU0IGMxMTA0M2Y5IGMyNTk5M2E5IGMwMmQ4NjEwClsgICAyMC4yMTM2MjFdICBj
MDJkODYxMCBjMzFiZjk1OCBjN2Q1OWY4NCBjN2Q1OWY2NCBjMTE3MTg4MiBjMDJkODYxMCBj
MDJkOGE0NCBjN2Q1OWY3OApbICAgMjAuMjE3MDY4XSAgYzExNzUzNWQgYzAyZDg2MTAgYzdk
NTlmODQgYzdkNTlmYTAgYzdkNTlmOTggYzEwZTQwZDcgMDAwMDBmNmQgYzdkNTlmOTgKWyAg
IDIwLjIyMDgzOV0gQ2FsbCBUcmFjZToKWyAgIDIwLjIyMTgwNF0gIFs8YzFlYzY5ZTg+XSBk
dW1wX3N0YWNrKzB4NDAvMHg1ZQpbICAgMjAuMjIzMTQ3XSAgWzxjMTEwNDNmOT5dIGxvY2tk
ZXBfcmN1X3N1c3BpY2lvdXMrMHgxYzAvMHgxZDcKWyAgIDIwLjIyNDgxOF0gIFs8YzExNzE4
ODI+XSB0YXNrX2NzKzB4MWUzLzB4MjE4ClsgICAyMC4yMjYxNDddICBbPGMxMTc1MzVkPl0g
Y3B1c2V0X2NwdXNfYWxsb3dlZCsweDU5LzB4YzEKWyAgIDIwLjIyNzcyMl0gIFs8YzEwZTQw
ZDc+XSBzY2hlZF9zZXRhZmZpbml0eSsweDJjOS8weDRjNQpbICAgMjAuMjI5MjEyXSAgWzxj
MTBkYTI5Nj5dID8gY29weV9mcm9tX3VzZXIrMHg0NC8weDU0ClsgICAyMC4yMzA3ODNdICBb
PGMxMGU0NDQ5Pl0gU3lTX3NjaGVkX3NldGFmZmluaXR5KzB4MTc2LzB4MWE1ClsgICAyMC4y
MzIzNjJdICBbPGMxZjBjOTJhPl0gc3lzZW50ZXJfZG9fY2FsbCsweDEyLzB4M2MKWyAgIDQ4
LjM2NDI2MF0gcmFuZG9tOiBub25ibG9ja2luZyBwb29sIGlzIGluaXRpYWxpemVkClsgICA2
My42MzY5OTNdIHNwaW5fbG9jay10b3J0dXJlOiBXcml0ZXM6ICBUb3RhbDogMiAgTWF4L01p
bjogMC8wICAgRmFpbDogMCAKWyAgIDY2Ljc2MTE4NF0gaW5pdDogaHdjbG9jay1zYXZlIG1h
aW4gcHJvY2VzcyAoMzk1MykgdGVybWluYXRlZCB3aXRoIHN0YXR1cyA3MAova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMC8xYzA5NTE4OTU4NzhiNDYzNDMxNmQ0NDg3MTcx
MTk5MDRlZTZjNTNjL2RtZXNnLXlvY3RvLXhpYW4tMTg6MjAxNDAzMDEwNzQ1NTY6aTM4Ni1y
YW5kY29uZmlnLWM1LTAzMDEwMzIwOjMuMTQuMC1yYzQtMDUzMjUtZzFjMDk1MTg6OTIKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjAvMWMwOTUxODk1ODc4YjQ2MzQzMTZk
NDQ4NzE3MTE5OTA0ZWU2YzUzYy9kbWVzZy1xdWFudGFsLXJvYW0tMzI6MjAxNDAzMDEwNzQ2
MDQ6aTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwOjMuMTQuMC1yYzQtMDUzMjUtZzFjMDk1
MTg6OTIKMDoyOjIgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDMt
MDEgMDc6NDY6MTAgUkVQRUFUIENPVU5UOiAyMCAgIyAva2VybmVsLXRlc3RzL2xpbnV4Ni9v
YmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDIyMCByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOCBzdGVwcykKW2RlYTQ4YTZjYjVjNDU1MDlh
NzdmNWVmM2IxM2ZhOTdkMWJiMGYzODldIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2gg
J3RhcmdldC11cGRhdGVzL2Zvci1uZXh0JwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDYvb2JqLWJpc2Vj
dApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWM1
LTAzMDEwMzIwL25leHQ6bWFzdGVyOmRlYTQ4YTZjYjVjNDU1MDlhNzdmNWVmM2IxM2ZhOTdk
MWJiMGYzODk6YmlzZWN0LWxpbnV4NgoKMjAxNC0wMy0wMS0wNzo0NjoxMSBkZWE0OGE2Y2I1
YzQ1NTA5YTc3ZjVlZjNiMTNmYTk3ZDFiYjBmMzg5IGNvbXBpbGluZwoxOTggcmVhbCAgMzY5
IHVzZXIgIDM1IHN5cyAgMjA0LjczJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMy
MAoKMjAxNC0wMy0wMS0wNzo0OTo1MyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmM0
LTA1MjU1LWdkZWE0OGE2Li4uLiBURVNUIEZBSUxVUkUKWyAgIDIwLjcxODAwN10gaW5pdDog
cGx5bW91dGgtbG9nIG1haW4gcHJvY2VzcyAoMTE2KSB0ZXJtaW5hdGVkIHdpdGggc3RhdHVz
IDEKWyAgIDM3LjA3Mjk0M10gClsgICAzNy4wNzk3NzddID09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT0KWyAgIDM3LjA4MTI1MV0gWyBJTkZPOiBzdXNwaWNpb3VzIFJDVSB1c2Fn
ZS4gXQpbICAgMzcuMDgyNjA5XSAzLjE0LjAtcmM0LTA1MjU1LWdkZWE0OGE2ICM5MyBOb3Qg
dGFpbnRlZApbICAgMzcuMDg0MjEzXSAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
ClsgICAzNy4wODU1NTVdIC9rZXJuZWwtdGVzdHMvbGludXg2L2luY2x1ZGUvbGludXgvY2dy
b3VwLmg6NzA1IHN1c3BpY2lvdXMgcmN1X2RlcmVmZXJlbmNlX2NoZWNrKCkgdXNhZ2UhClsg
ICAzNy4wOTc5MDJdIApbICAgMzcuMDk3OTAyXSBvdGhlciBpbmZvIHRoYXQgbWlnaHQgaGVs
cCB1cyBkZWJ1ZyB0aGlzOgpbICAgMzcuMDk3OTAyXSAKWyAgIDM3LjEwMDgxN10gClsgICAz
Ny4xMDA4MTddIHJjdV9zY2hlZHVsZXJfYWN0aXZlID0gMSwgZGVidWdfbG9ja3MgPSAwClsg
ICAzNy4xMDI5ODRdIDIgbG9ja3MgaGVsZCBieSB0cmluaXR5LWMwLzM4ODM6ClsgICAzNy4x
MDQ0MzhdICAjMDogIChjYWxsYmFja19tdXRleCl7Ky4rLi4ufSwgYXQ6IFs8YzExNzUzMzM+
XSBjcHVzZXRfY3B1c19hbGxvd2VkKzB4MmYvMHhjMQpbICAgMzcuMTE3MzI0XSAgIzE6ICAo
JigmcC0+YWxsb2NfbG9jayktPnJsb2NrKXsrLisuLi59LCBhdDogWzxjMTE3NTM0OD5dIGNw
dXNldF9jcHVzX2FsbG93ZWQrMHg0NC8weGMxClsgICAzNy4xMjA4NjNdIApbICAgMzcuMTIw
ODYzXSBzdGFjayBiYWNrdHJhY2U6ClsgICAzNy4xMjI1NjddIENQVTogMCBQSUQ6IDM4ODMg
Q29tbTogdHJpbml0eS1jMCBOb3QgdGFpbnRlZCAzLjE0LjAtcmM0LTA1MjU1LWdkZWE0OGE2
ICM5MwpbICAgMzcuMTM1MDIwXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBC
b2NocyAwMS8wMS8yMDExClsgICAzNy4xMzY4NTBdICAwMDAwMDAwMSAwMDAwMDAwMSBjYmY0
MWYzOCBjMWVjNjhlYyBjYmY0MWY1NCBjMTEwNDNmOSBjMjU5OTIyNSBjMDIxMmExMApbICAg
MzcuMTQwNDY1XSAgYzAyMTJhMTAgYzMxYmQ5NTggY2JmNDFmODQgY2JmNDFmNjQgYzExNzE4
ODIgYzAyMTJhMTAgYzAyMTJlNDQgY2JmNDFmNzgKWyAgIDM3LjE1Mzk1NV0gIGMxMTc1MzVk
IGMwMjEyYTEwIGNiZjQxZjg0IGNiZjQxZmEwIGNiZjQxZjk4IGMxMGU0MGQ3IDAwMDAwZjJi
IGNiZjQxZjk4ClsgICAzNy4xNTc1OTNdIENhbGwgVHJhY2U6ClsgICAzNy4xNTg1NzldICBb
PGMxZWM2OGVjPl0gZHVtcF9zdGFjaysweDQwLzB4NWUKWyAgIDM3LjE1OTk4OV0gIFs8YzEx
MDQzZjk+XSBsb2NrZGVwX3JjdV9zdXNwaWNpb3VzKzB4MWMwLzB4MWQ3ClsgICAzNy4xNjE3
NDddICBbPGMxMTcxODgyPl0gdGFza19jcysweDFlMy8weDIxOApbICAgMzcuMTYzMTM5XSAg
WzxjMTE3NTM1ZD5dIGNwdXNldF9jcHVzX2FsbG93ZWQrMHg1OS8weGMxClsgICAzNy4xNjg0
OTJdICBbPGMxMGU0MGQ3Pl0gc2NoZWRfc2V0YWZmaW5pdHkrMHgyYzkvMHg0YzUKWyAgIDM3
LjE3OTM3NV0gIFs8YzEwZGEyOTY+XSA/IGNvcHlfZnJvbV91c2VyKzB4NDQvMHg1NApbICAg
MzcuMTgwOTk0XSAgWzxjMTBlNDQ0OT5dIFN5U19zY2hlZF9zZXRhZmZpbml0eSsweDE3Ni8w
eDFhNQpbICAgMzcuMTgyNjU5XSAgWzxjMWYwYzgyYT5dIHN5c2VudGVyX2RvX2NhbGwrMHgx
Mi8weDNjClsgICAzNy4zODg5NzBdIHJkc19yZW1vdmVfYm91bmQoKTogcnMgYzAyMDkxODAg
dW5iaW5kaW5nIGZyb20gMTI3LjUuMTI2LjEyNzoxMDQ4NwpbICAgMzcuNDA4NzY2XSByZHNf
cmVtb3ZlX2JvdW5kKCk6IHJzIGMwMzNhYjAwIHVuYmluZGluZyBmcm9tIDEyNy4wLjAuMToy
ODEwMQpbICAgNTIuMzkwMTU3XSByYW5kb206IG5vbmJsb2NraW5nIHBvb2wgaXMgaW5pdGlh
bGl6ZWQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjAvZGVhNDhhNmNiNWM0
NTUwOWE3N2Y1ZWYzYjEzZmE5N2QxYmIwZjM4OS9kbWVzZy1xdWFudGFsLWNhaXJvLTE3OjIw
MTQwMzAxMDc1MTI0OmkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMDozLjE0LjAtcmM0LTA1
MjU1LWdkZWE0OGE2OjkzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwL2Rl
YTQ4YTZjYjVjNDU1MDlhNzdmNWVmM2IxM2ZhOTdkMWJiMGYzODkvZG1lc2ctcXVhbnRhbC1p
bm4tMzk6MjAxNDAzMDEwNzUxMjk6aTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwOjoKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjAvZGVhNDhhNmNiNWM0NTUwOWE3N2Y1
ZWYzYjEzZmE5N2QxYmIwZjM4OS9kbWVzZy1xdWFudGFsLWlubi00MjoyMDE0MDMwMTA3NTEy
NzppMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjA6Ogova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1jNS0wMzAxMDMyMC9kZWE0OGE2Y2I1YzQ1NTA5YTc3ZjVlZjNiMTNmYTk3ZDFiYjBmMzg5
L2RtZXNnLXlvY3RvLWJlbnMtMToyMDE0MDMwMTA3NTEzNDppMzg2LXJhbmRjb25maWctYzUt
MDMwMTAzMjA6My4xNC4wLXJjNC0wNTI1NS1nZGVhNDhhNjo5Mwova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1jNS0wMzAxMDMyMC9kZWE0OGE2Y2I1YzQ1NTA5YTc3ZjVlZjNiMTNmYTk3ZDFi
YjBmMzg5L2RtZXNnLXlvY3RvLWlubi00NzoyMDE0MDMwMTA3NTEzNjppMzg2LXJhbmRjb25m
aWctYzUtMDMwMTAzMjA6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMC9k
ZWE0OGE2Y2I1YzQ1NTA5YTc3ZjVlZjNiMTNmYTk3ZDFiYjBmMzg5L2RtZXNnLXF1YW50YWwt
YmVucy02OjIwMTQwMzAxMDc1MTM4OmkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMDozLjE0
LjAtcmM0LTA1MjU1LWdkZWE0OGE2OjkzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAz
MDEwMzIwL2RlYTQ4YTZjYjVjNDU1MDlhNzdmNWVmM2IxM2ZhOTdkMWJiMGYzODkvZG1lc2ct
cXVhbnRhbC1jYWlyby0yMzoyMDE0MDMwMTA3NTEzODppMzg2LXJhbmRjb25maWctYzUtMDMw
MTAzMjA6My4xNC4wLXJjNC0wNTI1NS1nZGVhNDhhNjo5Mwova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1jNS0wMzAxMDMyMC9kZWE0OGE2Y2I1YzQ1NTA5YTc3ZjVlZjNiMTNmYTk3ZDFiYjBm
Mzg5L2RtZXNnLXlvY3RvLWlubi0yNToyMDE0MDMwMTA3NTE0MzppMzg2LXJhbmRjb25maWct
YzUtMDMwMTAzMjA6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMC9kZWE0
OGE2Y2I1YzQ1NTA5YTc3ZjVlZjNiMTNmYTk3ZDFiYjBmMzg5L2RtZXNnLXlvY3RvLXNuYi01
OjIwMTQwMzAxMDc1MTQyOmkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMDo6CjA6OTo5IGFs
bF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTAzLTAxIDA3OjUxOjU0IFJF
UEVBVCBDT1VOVDogMjAgICMgL2tlcm5lbC10ZXN0cy9saW51eDYvb2JqLWJpc2VjdC8ucmVw
ZWF0G1swbQoKQmlzZWN0aW5nOiAxNTAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0
aGlzIChyb3VnaGx5IDggc3RlcHMpCls5MWUyNjhjNWMxZmY1MTA2ZTVlMzM2MjdlZWE2NDEx
ZTAwNDAwYzgxXSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdjaGFyLW1pc2MvY2hh
ci1taXNjLW5leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4Ni9vYmotYmlzZWN0CmxzIC1hIC9rZXJu
ZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjAvbmV4
dDptYXN0ZXI6OTFlMjY4YzVjMWZmNTEwNmU1ZTMzNjI3ZWVhNjQxMWUwMDQwMGM4MTpiaXNl
Y3QtbGludXg2CgoyMDE0LTAzLTAxLTA3OjUxOjU0IDkxZTI2OGM1YzFmZjUxMDZlNWUzMzYy
N2VlYTY0MTFlMDA0MDBjODEgY29tcGlsaW5nCjIyNyByZWFsICAxNTQxIHVzZXIgIDEwMCBz
eXMgIDcyMy4zNiUgY3B1IAlpMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjAKCjIwMTQtMDMt
MDEtMDc6NTY6MDYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjNC0wNTE3Ny1nOTFl
MjY4Yy4uLgk2CTE5CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogNzggcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDcgc3RlcHMpCltiZjkwNjkwYTYxNjM1MWQ1
MTRhNzVlZWZhZGVlYTZjZjQyN2IwY2UzXSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNo
ICdjZ3JvdXAvZm9yLW5leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4Ni9vYmotYmlzZWN0CmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzUtMDMwMTAz
MjAvbmV4dDptYXN0ZXI6YmY5MDY5MGE2MTYzNTFkNTE0YTc1ZWVmYWRlZWE2Y2Y0MjdiMGNl
MzpiaXNlY3QtbGludXg2CgoyMDE0LTAzLTAxLTA3OjU5OjA2IGJmOTA2OTBhNjE2MzUxZDUx
NGE3NWVlZmFkZWVhNmNmNDI3YjBjZTMgY29tcGlsaW5nCjI0NCByZWFsICAxNTQ0IHVzZXIg
IDEwNiBzeXMgIDY3NS41NSUgY3B1IAlpMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjAKCjIw
MTQtMDMtMDEtMDg6MDM6MzcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjNC0wNTI1
My1nYmY5MDY5MC4uLi4gVEVTVCBGQUlMVVJFClsgICAgNy4xODI5NThdIGluaXQ6IHBseW1v
dXRoLWxvZyBtYWluIHByb2Nlc3MgKDExNykgdGVybWluYXRlZCB3aXRoIHN0YXR1cyAxClsg
ICAxOS42NzU0NjddIApbICAgMTkuNjc2MjI5XSA9PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09ClsgICAxOS42Nzc1NzddIFsgSU5GTzogc3VzcGljaW91cyBSQ1UgdXNhZ2UuIF0K
WyAgIDE5LjY3ODgyMV0gMy4xNC4wLXJjNC0wNTI1My1nYmY5MDY5MCAjOTUgTm90IHRhaW50
ZWQKWyAgIDE5LjY4MDM5Nl0gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpbICAg
MTkuNjgxNjIzXSAva2VybmVsLXRlc3RzL2xpbnV4Ni9pbmNsdWRlL2xpbnV4L2Nncm91cC5o
OjcwNSBzdXNwaWNpb3VzIHJjdV9kZXJlZmVyZW5jZV9jaGVjaygpIHVzYWdlIQpbICAgMTku
NjgzOTk4XSAKWyAgIDE5LjY4Mzk5OF0gb3RoZXIgaW5mbyB0aGF0IG1pZ2h0IGhlbHAgdXMg
ZGVidWcgdGhpczoKWyAgIDE5LjY4Mzk5OF0gClsgICAxOS42ODYzOThdIApbICAgMTkuNjg2
Mzk4XSByY3Vfc2NoZWR1bGVyX2FjdGl2ZSA9IDEsIGRlYnVnX2xvY2tzID0gMApbICAgMTku
Njg4NTI2XSAyIGxvY2tzIGhlbGQgYnkgdHJpbml0eS1jMC8zODQxOgpbICAgMTkuNjg5NzI2
XSAgIzA6ICAoY2FsbGJhY2tfbXV0ZXgpeysuKy4uLn0sIGF0OiBbPGMxMTc1MzMzPl0gY3B1
c2V0X2NwdXNfYWxsb3dlZCsweDJmLzB4YzEKWyAgIDE5LjY5MjcxMl0gICMxOiAgKCYoJnAt
PmFsbG9jX2xvY2spLT5ybG9jayl7Ky4rLi4ufSwgYXQ6IFs8YzExNzUzNDg+XSBjcHVzZXRf
Y3B1c19hbGxvd2VkKzB4NDQvMHhjMQpbICAgMTkuNjk1OTg0XSAKWyAgIDE5LjY5NTk4NF0g
c3RhY2sgYmFja3RyYWNlOgpbICAgMTkuNjk3NzE0XSBDUFU6IDAgUElEOiAzODQxIENvbW06
IHRyaW5pdHktYzAgTm90IHRhaW50ZWQgMy4xNC4wLXJjNC0wNTI1My1nYmY5MDY5MCAjOTUK
WyAgIDE5LjY5OTk4MF0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMg
MDEvMDEvMjAxMQpbICAgMTkuNzAxNjMxXSAgMDAwMDAwMDEgMDAwMDAwMDEgYzdkNjlmMzgg
YzFlYzY4ZWMgYzdkNjlmNTQgYzExMDQzZjkgYzI1OTkyMjUgYzAzMGE5MTAKWyAgIDE5Ljcw
NTc3M10gIGMwMzBhOTEwIGMzMWJkOTU4IGM3ZDY5Zjg0IGM3ZDY5ZjY0IGMxMTcxODgyIGMw
MzBhOTEwIGMwMzBhZDQ0IGM3ZDY5Zjc4ClsgICAxOS43MDkwNDldICBjMTE3NTM1ZCBjMDMw
YTkxMCBjN2Q2OWY4NCBjN2Q2OWZhMCBjN2Q2OWY5OCBjMTBlNDBkNyAwMDAwMGYwMSBjN2Q2
OWY5OApbICAgMTkuNzEyMzQ0XSBDYWxsIFRyYWNlOgpbICAgMTkuNzEzMjUwXSAgWzxjMWVj
NjhlYz5dIGR1bXBfc3RhY2srMHg0MC8weDVlClsgICAxOS43MTQ2MzNdICBbPGMxMTA0M2Y5
Pl0gbG9ja2RlcF9yY3Vfc3VzcGljaW91cysweDFjMC8weDFkNwpbICAgMTkuNzE2MDc2XSAg
WzxjMTE3MTg4Mj5dIHRhc2tfY3MrMHgxZTMvMHgyMTgKWyAgIDE5LjcxNzQ3MV0gIFs8YzEx
NzUzNWQ+XSBjcHVzZXRfY3B1c19hbGxvd2VkKzB4NTkvMHhjMQpbICAgMTkuNzE4OTY0XSAg
WzxjMTBlNDBkNz5dIHNjaGVkX3NldGFmZmluaXR5KzB4MmM5LzB4NGM1ClsgICAxOS43MjA1
MDldICBbPGMxMGRhMjk2Pl0gPyBjb3B5X2Zyb21fdXNlcisweDQ0LzB4NTQKWyAgIDE5Ljcy
MTg5NV0gIFs8YzEwZTQ0NDk+XSBTeVNfc2NoZWRfc2V0YWZmaW5pdHkrMHgxNzYvMHgxYTUK
WyAgIDE5LjcyMzM1OV0gIFs8YzFmMGM4MmE+XSBzeXNlbnRlcl9kb19jYWxsKzB4MTIvMHgz
YwpbICAgMTkuNzI2NjAyXSBWRlM6IFdhcm5pbmc6IHRyaW5pdHktYzAgdXNpbmcgb2xkIHN0
YXQoKSBjYWxsLiBSZWNvbXBpbGUgeW91ciBiaW5hcnkuClsgICAxOS43MzY1MDBdIHJkc19y
ZW1vdmVfYm91bmQoKTogcnMgYzAyZmE0MDAgdW5iaW5kaW5nIGZyb20gMTI3LjEzOS4xOTAu
OTE6NDAyMTUKWyAgIDE5LjczOTY3MF0gcmRzX3JlbW92ZV9ib3VuZCgpOiBycyBjMDMwZjQw
MCB1bmJpbmRpbmcgZnJvbSAxMjcuMC4wLjE6Mjk4MTgKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctYzUtMDMwMTAzMjAvYmY5MDY5MGE2MTYzNTFkNTE0YTc1ZWVmYWRlZWE2Y2Y0MjdiMGNl
My9kbWVzZy1xdWFudGFsLWF0aGVucy0zNToyMDE0MDMwMTA4MDUwMjppMzg2LXJhbmRjb25m
aWctYzUtMDMwMTAzMjA6My4xNC4wLXJjNC0wNTI1My1nYmY5MDY5MDo5NQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMC9iZjkwNjkwYTYxNjM1MWQ1MTRhNzVlZWZhZGVl
YTZjZjQyN2IwY2UzL2RtZXNnLXlvY3RvLXhpYW4tMTE6MjAxNDAzMDEwODA1MDg6aTM4Ni1y
YW5kY29uZmlnLWM1LTAzMDEwMzIwOjMuMTQuMC1yYzQtMDUyNTMtZ2JmOTA2OTA6OTUKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjAvYmY5MDY5MGE2MTYzNTFkNTE0YTc1
ZWVmYWRlZWE2Y2Y0MjdiMGNlMy9kbWVzZy15b2N0by14aWFuLTM5OjIwMTQwMzAxMDgwNTEx
OmkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMDozLjE0LjAtcmM0LTA1MjUzLWdiZjkwNjkw
Ojk1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwL2JmOTA2OTBhNjE2MzUx
ZDUxNGE3NWVlZmFkZWVhNmNmNDI3YjBjZTMvZG1lc2ctcXVhbnRhbC1hdGhlbnMtMToyMDE0
MDMwMTA4MDUxODppMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjA6My4xNC4wLXJjNC0wNTI1
My1nYmY5MDY5MDo5NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMC9iZjkw
NjkwYTYxNjM1MWQ1MTRhNzVlZWZhZGVlYTZjZjQyN2IwY2UzL2RtZXNnLXF1YW50YWwtamFr
ZXRvd24tMTA6MjAxNDAzMDEwODA1MjM6aTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwOjoK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjAvYmY5MDY5MGE2MTYzNTFkNTE0
YTc1ZWVmYWRlZWE2Y2Y0MjdiMGNlMy9kbWVzZy1xdWFudGFsLWpha2V0b3duLTMyOjIwMTQw
MzAxMDgwNTI1OmkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMDo6Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWM1LTAzMDEwMzIwL2JmOTA2OTBhNjE2MzUxZDUxNGE3NWVlZmFkZWVhNmNm
NDI3YjBjZTMvZG1lc2cteW9jdG8tYXRoZW5zLTM1OjIwMTQwMzAxMDgwNTI4OmkzODYtcmFu
ZGNvbmZpZy1jNS0wMzAxMDMyMDozLjE0LjAtcmM0LTA1MjUzLWdiZjkwNjkwOjk1Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwL2JmOTA2OTBhNjE2MzUxZDUxNGE3NWVl
ZmFkZWVhNmNmNDI3YjBjZTMvZG1lc2cteW9jdG8tamFrZXRvd24tMjk6MjAxNDAzMDEwODA1
MTk6aTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwOjoKMDo4OjcgYWxsX2dvb2Q6YmFkOmFs
bF9iYWQgYm9vdHMKCmxpbmVhci1iaXNlY3Q6IGJhZCBicmFuY2ggbWF5IGJlIHJlbW90ZS10
cmFja2luZyBicmFuY2ggJ2Nncm91cC9mb3ItbmV4dCcKbGluZWFyLWJpc2VjdDogaGFuZGxl
IG92ZXIgdG8gZ2l0IGJpc2VjdApsaW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0IHN0YXJ0IGJm
OTA2OTBhNjE2MzUxZDUxNGE3NWVlZmFkZWVhNmNmNDI3YjBjZTMgOTFlMjY4YzVjMWZmNTEw
NmU1ZTMzNjI3ZWVhNjQxMWUwMDQwMGM4MSAtLQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdh
cyBiZjkwNjkwLi4uIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ2Nncm91cC9mb3It
bmV4dCcKSEVBRCBpcyBub3cgYXQgZTc2NTFiOC4uLiBNZXJnZSBicmFuY2ggJ2Zvci1saW51
cycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L21h
c29uL2xpbnV4LWJ0cmZzCkJpc2VjdGluZzogMzcgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDUgc3RlcHMpCls5NmQzNjVlMGI4NmVlN2VjNjM2NmM5OTY2
OTY4N2U1NGM5ZjE0NWUzXSBjZ3JvdXA6IG1ha2UgY3NzX3NldF9sb2NrIGEgcndzZW0gYW5k
IHJlbmFtZSBpdCB0byBjc3Nfc2V0X3J3c2VtCmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3Qg
cnVuIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5l
bC10ZXN0cy9saW51eDYvb2JqLWJpc2VjdApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDYvb2JqLWJpc2Vj
dApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWM1
LTAzMDEwMzIwL25leHQ6bWFzdGVyOjk2ZDM2NWUwYjg2ZWU3ZWM2MzY2Yzk5NjY5Njg3ZTU0
YzlmMTQ1ZTM6YmlzZWN0LWxpbnV4NgoKMjAxNC0wMy0wMS0wODowNTo0MiA5NmQzNjVlMGI4
NmVlN2VjNjM2NmM5OTY2OTY4N2U1NGM5ZjE0NWUzIGNvbXBpbGluZwoyNDEgcmVhbCAgMzM4
MCB1c2VyICAyMjIgc3lzICAxNDkwLjY0JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1jNS0wMzAx
MDMyMAoKMjAxNC0wMy0wMS0wODoxMDowNSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAt
cmMxLTAwMDcwLWc5NmQzNjVlLi4uCTEwCTE4CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMTgg
cmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDQgc3RlcHMpClsy
MjIwZjVlZGY1ZjQ1MjQ4MDEzNWI1N2IzNDVlNzgzZmZjNWM3NTJkXSBNZXJnZSBicmFuY2gg
J2Zvci0zLjE1JyBpbnRvIGZvci1uZXh0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2Vj
dC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4Ni9vYmotYmlzZWN0
CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzUt
MDMwMTAzMjAvbmV4dDptYXN0ZXI6MjIyMGY1ZWRmNWY0NTI0ODAxMzViNTdiMzQ1ZTc4M2Zm
YzVjNzUyZDpiaXNlY3QtbGludXg2CgoyMDE0LTAzLTAxLTA4OjEzOjA2IDIyMjBmNWVkZjVm
NDUyNDgwMTM1YjU3YjM0NWU3ODNmZmM1Yzc1MmQgY29tcGlsaW5nCjI0NCByZWFsICAxNTE4
IHVzZXIgIDEwMSBzeXMgIDY2My4zNiUgY3B1IAlpMzg2LXJhbmRjb25maWctYzUtMDMwMTAz
MjAKCjIwMTQtMDMtMDEtMDg6MTc6MjkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJj
MS0wMDA5MC1nMjIyMGY1ZS4uCTIJMTYJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA5IHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbOTUyYWFh
MTI1NDI4ZmFlODgzNjcwYTJjMmU0MGVhODA0NGNhMWVhYV0gY2dyb3VwOiB1cGRhdGUgY2dy
b3VwX3RyYW5zZmVyX3Rhc2tzKCkgdG8gZWl0aGVyIHN1Y2NlZWQgb3IgZmFpbApydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10
ZXN0cy9saW51eDYvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0vaTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwL25leHQ6bWFzdGVyOjk1MmFhYTEyNTQy
OGZhZTg4MzY3MGEyYzJlNDBlYTgwNDRjYTFlYWE6YmlzZWN0LWxpbnV4NgoKMjAxNC0wMy0w
MS0wODoyMDowMCA5NTJhYWExMjU0MjhmYWU4ODM2NzBhMmMyZTQwZWE4MDQ0Y2ExZWFhIGNv
bXBpbGluZwoxNTUgcmVhbCAgMTUxNSB1c2VyICA5NyBzeXMgIDEwMzQuNzklIGNwdSAJaTM4
Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwCgoyMDE0LTAzLTAxLTA4OjIyOjU2IGRldGVjdGlu
ZyBib290IHN0YXRlIDMuMTQuMC1yYzEtMDAwOTUtZzk1MmFhYTEuLi4uIFRFU1QgRkFJTFVS
RQpbICAgIDcuODI1ODQ2XSBpbml0OiBwbHltb3V0aC1sb2cgbWFpbiBwcm9jZXNzICgxMTQp
IHRlcm1pbmF0ZWQgd2l0aCBzdGF0dXMgMQpbICAgMjAuMTE1MTU5XSAKWyAgIDIwLjExNTgx
NF0gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQpbICAgMjAuMTE3MTQ5XSBbIElO
Rk86IHN1c3BpY2lvdXMgUkNVIHVzYWdlLiBdClsgICAyMC4xMTgyNjZdIDMuMTQuMC1yYzEt
MDAwOTUtZzk1MmFhYTEgIzk4IE5vdCB0YWludGVkClsgICAyMC4xMTk1NjBdIC0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KWyAgIDIwLjEyMDc2MF0gL2tlcm5lbC10ZXN0cy9s
aW51eDYvaW5jbHVkZS9saW51eC9jZ3JvdXAuaDo3MDUgc3VzcGljaW91cyByY3VfZGVyZWZl
cmVuY2VfY2hlY2soKSB1c2FnZSEKWyAgIDIwLjEyMzAyOV0gClsgICAyMC4xMjMwMjldIG90
aGVyIGluZm8gdGhhdCBtaWdodCBoZWxwIHVzIGRlYnVnIHRoaXM6ClsgICAyMC4xMjMwMjld
IApbICAgMjAuMTI1MzQ4XSAKWyAgIDIwLjEyNTM0OF0gcmN1X3NjaGVkdWxlcl9hY3RpdmUg
PSAxLCBkZWJ1Z19sb2NrcyA9IDAKWyAgIDIwLjEyNzM2N10gMiBsb2NrcyBoZWxkIGJ5IHRy
aW5pdHktYzAvMzg5NzoKWyAgIDIwLjEyODUwNV0gICMwOiAgKGNhbGxiYWNrX211dGV4KXsr
LisuLi59LCBhdDogWzxjMTE3MmQ0MD5dIGNwdXNldF9jcHVzX2FsbG93ZWQrMHgyZi8weGMx
ClsgICAyMC4xMzcwODddICAjMTogICgmKCZwLT5hbGxvY19sb2NrKS0+cmxvY2speysuKy4u
Ln0sIGF0OiBbPGMxMTcyZDU1Pl0gY3B1c2V0X2NwdXNfYWxsb3dlZCsweDQ0LzB4YzEKWyAg
IDIwLjE0MjkzMF0gClsgICAyMC4xNDI5MzBdIHN0YWNrIGJhY2t0cmFjZToKWyAgIDIwLjE0
NzM5MF0gQ1BVOiAwIFBJRDogMzg5NyBDb21tOiB0cmluaXR5LWMwIE5vdCB0YWludGVkIDMu
MTQuMC1yYzEtMDAwOTUtZzk1MmFhYTEgIzk4ClsgICAyMC4xNTEyMzFdIEhhcmR3YXJlIG5h
bWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgIDIwLjE1MjY3OF0g
IDAwMDAwMDAxIDAwMDAwMDAxIGM3ZTZiZjM4IGMxZWIwMzljIGM3ZTZiZjU0IGMxMTAyNDNk
IGMyNTc5ZDAxIGMwMWE4NDEwClsgICAyMC4xNTk1NzZdICBjMDFhODQxMCBjMzE5NTNlOCBj
N2U2YmY4NCBjN2U2YmY2NCBjMTE2ZjJiNSBjMDFhODQxMCBjMDFhODg0MCBjN2U2YmY3OApb
ICAgMjAuMTY5NzQwXSAgYzExNzJkNmEgYzAxYTg0MTAgYzdlNmJmODQgYzdlNmJmYTAgYzdl
NmJmOTggYzEwZTMzYzQgMDAwMDBmMzkgYzdlNmJmOTgKWyAgIDIwLjE3ODQ2M10gQ2FsbCBU
cmFjZToKWyAgIDIwLjE3OTM0MF0gIFs8YzFlYjAzOWM+XSBkdW1wX3N0YWNrKzB4NDAvMHg1
ZQpbICAgMjAuMTgwNjUxXSAgWzxjMTEwMjQzZD5dIGxvY2tkZXBfcmN1X3N1c3BpY2lvdXMr
MHgxYzAvMHgxZDcKWyAgIDIwLjE4MjE4OF0gIFs8YzExNmYyYjU+XSB0YXNrX2NzKzB4MWUz
LzB4MjE4ClsgICAyMC4xODM2NDJdICBbPGMxMTcyZDZhPl0gY3B1c2V0X2NwdXNfYWxsb3dl
ZCsweDU5LzB4YzEKWyAgIDIwLjE4NTAwMl0gIFs8YzEwZTMzYzQ+XSBzY2hlZF9zZXRhZmZp
bml0eSsweDJjOS8weDRjNQpbICAgMjAuMTg2Mzg1XSAgWzxjMTBkOTcxZD5dID8gY29weV9m
cm9tX3VzZXIrMHg0NC8weDU0ClsgICAyMC4xOTEyMzVdICBbPGMxMGUzNzM2Pl0gU3lTX3Nj
aGVkX3NldGFmZmluaXR5KzB4MTc2LzB4MWE1ClsgICAyMC4xOTI1ODVdICBbPGMxZWY2MzRh
Pl0gc3lzZW50ZXJfZG9fY2FsbCsweDEyLzB4M2MKWyAgIDIwLjI0MTIzNl0gcmRzX3JlbW92
ZV9ib3VuZCgpOiBycyBjMGYxODUwMCB1bmJpbmRpbmcgZnJvbSAxMjcuMC4wLjE6MjU4NTIK
WyAgIDIwLjI0NDEzMl0gcmRzX3JlbW92ZV9ib3VuZCgpOiBycyBjMDMxMWMwMCB1bmJpbmRp
bmcgZnJvbSAxMjcuMjExLjM3Ljg5OjIxNzYxClsgICAyMC4yNDgxNTZdIHJkc19yZW1vdmVf
Ym91bmQoKTogcnMgYzBkNDc0MDAgdW5iaW5kaW5nIGZyb20gMTI3LjAuMC4xOjE5MjkyCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwLzk1MmFhYTEyNTQyOGZhZTg4MzY3
MGEyYzJlNDBlYTgwNDRjYTFlYWEvZG1lc2ctcXVhbnRhbC1jYWlyby0yNDoyMDE0MDMwMTA4
MjQyODppMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjA6My4xNC4wLXJjMS0wMDA5NS1nOTUy
YWFhMTo5OAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMC85NTJhYWExMjU0
MjhmYWU4ODM2NzBhMmMyZTQwZWE4MDQ0Y2ExZWFhL2RtZXNnLXF1YW50YWwtaW5uLTEzOjIw
MTQwMzAxMDgyNDI2OmkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMDo6Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwLzk1MmFhYTEyNTQyOGZhZTg4MzY3MGEyYzJlNDBl
YTgwNDRjYTFlYWEvZG1lc2ctcXVhbnRhbC1pbm4tMjoyMDE0MDMwMTA4MjQyNDppMzg2LXJh
bmRjb25maWctYzUtMDMwMTAzMjA6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0wMzAx
MDMyMC85NTJhYWExMjU0MjhmYWU4ODM2NzBhMmMyZTQwZWE4MDQ0Y2ExZWFhL2RtZXNnLXF1
YW50YWwtc25iLTIxOjIwMTQwMzAxMDgyNDM1OmkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMy
MDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwLzk1MmFhYTEyNTQyOGZh
ZTg4MzY3MGEyYzJlNDBlYTgwNDRjYTFlYWEvZG1lc2ctcXVhbnRhbC14aWFuLTIyOjIwMTQw
MzAxMDgyNDM3OmkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMDozLjE0LjAtcmMxLTAwMDk1
LWc5NTJhYWExOjk4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwLzk1MmFh
YTEyNTQyOGZhZTg4MzY3MGEyYzJlNDBlYTgwNDRjYTFlYWEvZG1lc2ctcXVhbnRhbC14aWFu
LTI5OjIwMTQwMzAxMDgyNDMxOmkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMDozLjE0LjAt
cmMxLTAwMDk1LWc5NTJhYWExOjk4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEw
MzIwLzk1MmFhYTEyNTQyOGZhZTg4MzY3MGEyYzJlNDBlYTgwNDRjYTFlYWEvZG1lc2cteW9j
dG8taW5uLTIyOjIwMTQwMzAxMDgyNDM2OmkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMDo6
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwLzk1MmFhYTEyNTQyOGZhZTg4
MzY3MGEyYzJlNDBlYTgwNDRjYTFlYWEvZG1lc2cteW9jdG8taW5uLTI0OjIwMTQwMzAxMDgy
NDMxOmkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWM1LTAzMDEwMzIwLzk1MmFhYTEyNTQyOGZhZTg4MzY3MGEyYzJlNDBlYTgwNDRjYTFl
YWEvZG1lc2ctcXVhbnRhbC1hdGhlbnMtMTI6MjAxNDAzMDEwODI0NDE6aTM4Ni1yYW5kY29u
ZmlnLWM1LTAzMDEwMzIwOjMuMTQuMC1yYzEtMDAwOTUtZzk1MmFhYTE6OTgKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjAvOTUyYWFhMTI1NDI4ZmFlODgzNjcwYTJjMmU0
MGVhODA0NGNhMWVhYS9kbWVzZy1xdWFudGFsLWlubi0zNToyMDE0MDMwMTA4MjQ0MTppMzg2
LXJhbmRjb25maWctYzUtMDMwMTAzMjA6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0w
MzAxMDMyMC85NTJhYWExMjU0MjhmYWU4ODM2NzBhMmMyZTQwZWE4MDQ0Y2ExZWFhL2RtZXNn
LXF1YW50YWwtamFrZXRvd24tNDg6MjAxNDAzMDEwODI0NDA6aTM4Ni1yYW5kY29uZmlnLWM1
LTAzMDEwMzIwOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjAvOTUyYWFh
MTI1NDI4ZmFlODgzNjcwYTJjMmU0MGVhODA0NGNhMWVhYS9kbWVzZy1xdWFudGFsLXNuYi0z
MToyMDE0MDMwMTA4MjQzOTppMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjA6Ogova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMC85NTJhYWExMjU0MjhmYWU4ODM2NzBhMmMy
ZTQwZWE4MDQ0Y2ExZWFhL2RtZXNnLXF1YW50YWwtc25iLTQ3OjIwMTQwMzAxMDgyNDQ4Omkz
ODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMDo6CjA6MTM6MTMgYWxsX2dvb2Q6YmFkOmFsbF9i
YWQgYm9vdHMKG1sxOzM1bTIwMTQtMDMtMDEgMDg6MjQ6NTcgUkVQRUFUIENPVU5UOiAyMCAg
IyAva2VybmVsLXRlc3RzL2xpbnV4Ni9vYmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rp
bmc6IDQgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDIgc3Rl
cHMpCltiM2RjMDk0ZTkzOTA1YWU5YzFiYzA4MTU0MDJhZDhlNWIyMDNkMDY4XSBjZ3JvdXA6
IHVzZSBjc3Nfc2V0LT5tZ190YXNrcyB0byB0cmFjayB0YXJnZXQgdGFza3MgZHVyaW5nIG1p
Z3JhdGlvbgpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1
cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDYvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwL25leHQ6bWFz
dGVyOmIzZGMwOTRlOTM5MDVhZTljMWJjMDgxNTQwMmFkOGU1YjIwM2QwNjg6YmlzZWN0LWxp
bnV4NgoKMjAxNC0wMy0wMS0wODoyNDo1OCBiM2RjMDk0ZTkzOTA1YWU5YzFiYzA4MTU0MDJh
ZDhlNWIyMDNkMDY4IGNvbXBpbGluZwoxNTAgcmVhbCAgMTQ5NiB1c2VyICAxMDAgc3lzICAx
MDYzLjY4JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMAoKMjAxNC0wMy0wMS0w
ODoyODoxNCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmMxLTAwMDkwLWdiM2RjMDk0
Li4JMTAJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3Qg
YWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0ZXApClsxOTU4ZDJkNTNkYWRiYjFjOWFhZjBiMzc3
NDFmMTNhNjAwOThiMjQzXSBjZ3JvdXA6IHNwbGl0IHByb2Nlc3MgLyB0YXNrIG1pZ3JhdGlv
biBpbnRvIGZvdXIgc3RlcHMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg2L29iai1iaXNlY3QKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMy
MC9uZXh0Om1hc3RlcjoxOTU4ZDJkNTNkYWRiYjFjOWFhZjBiMzc3NDFmMTNhNjAwOThiMjQz
OmJpc2VjdC1saW51eDYKCjIwMTQtMDMtMDEtMDg6MzA6MTUgMTk1OGQyZDUzZGFkYmIxYzlh
YWYwYjM3NzQxZjEzYTYwMDk4YjI0MyBjb21waWxpbmcKMTU1IHJlYWwgIDE1MjYgdXNlciAg
MTAxIHN5cyAgMTA0OC43OCUgY3B1IAlpMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjAKCjIw
MTQtMDMtMDEtMDg6MzM6MTAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjMS0wMDA5
Mi1nMTk1OGQyZC4uCTEJMTMJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0ZXApClswZTFkNzY4ZjFiMTg3
MzI3MmVjNGU4ZGMxNDgyYmI1MjgxODU1MDE3XSBjZ3JvdXA6IGRyb3AgdGFza19sb2NrKCkg
cHJvdGVjdGlvbiBhcm91bmQgdGFzay0+Y2dyb3VwcwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0
cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDYvb2Jq
LWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLWM1LTAzMDEwMzIwL25leHQ6bWFzdGVyOjBlMWQ3NjhmMWIxODczMjcyZWM0ZThkYzE0
ODJiYjUyODE4NTUwMTc6YmlzZWN0LWxpbnV4NgoKMjAxNC0wMy0wMS0wODozNTo0MCAwZTFk
NzY4ZjFiMTg3MzI3MmVjNGU4ZGMxNDgyYmI1MjgxODU1MDE3IGNvbXBpbGluZwoxNjAgcmVh
bCAgMTUyMyB1c2VyICAxMDMgc3lzICAxMDE1LjU1JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1j
NS0wMzAxMDMyMAoKMjAxNC0wMy0wMS0wODozODo0MCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAz
LjE0LjAtcmMxLTAwMDk0LWcwZTFkNzY4Li4uLiBURVNUIEZBSUxVUkUKWyAgICA2LjkwNTE0
NF0gbW91bnRhbGwgKDg0KSB1c2VkIGdyZWF0ZXN0IHN0YWNrIGRlcHRoOiA2MTI4IGJ5dGVz
IGxlZnQKWyAgIDE5LjE3NzQ0Ml0gClsgICAxOS4xNzgxODddID09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT0KWyAgIDE5LjE3OTMxMl0gWyBJTkZPOiBzdXNwaWNpb3VzIFJDVSB1
c2FnZS4gXQpbICAgMTkuMTgxNDY1XSAzLjE0LjAtcmMxLTAwMDk0LWcwZTFkNzY4ICMxMDEg
Tm90IHRhaW50ZWQKWyAgIDE5LjE4Mjc5N10gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLQpbICAgMTkuMTg0MDY5XSAva2VybmVsLXRlc3RzL2xpbnV4Ni9pbmNsdWRlL2xpbnV4
L2Nncm91cC5oOjcwNSBzdXNwaWNpb3VzIHJjdV9kZXJlZmVyZW5jZV9jaGVjaygpIHVzYWdl
IQpbICAgMTkuMTg2NDAxXSAKWyAgIDE5LjE4NjQwMV0gb3RoZXIgaW5mbyB0aGF0IG1pZ2h0
IGhlbHAgdXMgZGVidWcgdGhpczoKWyAgIDE5LjE4NjQwMV0gClsgICAxOS4xODg5MDBdIApb
ICAgMTkuMTg4OTAwXSByY3Vfc2NoZWR1bGVyX2FjdGl2ZSA9IDEsIGRlYnVnX2xvY2tzID0g
MApbICAgMTkuMTkxOTQ5XSAyIGxvY2tzIGhlbGQgYnkgdHJpbml0eS1jMC8zODU4OgpbICAg
MTkuMTkzMDg3XSAgIzA6ICAoY2FsbGJhY2tfbXV0ZXgpeysuKy4uLn0sIGF0OiBbPGMxMTcy
YzJiPl0gY3B1c2V0X2NwdXNfYWxsb3dlZCsweDJmLzB4YzEKWyAgIDE5LjE5NTkyMF0gICMx
OiAgKCYoJnAtPmFsbG9jX2xvY2spLT5ybG9jayl7Ky4rLi4ufSwgYXQ6IFs8YzExNzJjNDA+
XSBjcHVzZXRfY3B1c19hbGxvd2VkKzB4NDQvMHhjMQpbICAgMTkuMTk5MTc3XSAKWyAgIDE5
LjE5OTE3N10gc3RhY2sgYmFja3RyYWNlOgpbICAgMTkuMjAwNzkwXSBDUFU6IDAgUElEOiAz
ODU4IENvbW06IHRyaW5pdHktYzAgTm90IHRhaW50ZWQgMy4xNC4wLXJjMS0wMDA5NC1nMGUx
ZDc2OCAjMTAxClsgICAxOS4yMDMwMDNdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBC
SU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgIDE5LjIwNDgxMF0gIDAwMDAwMDAxIDAwMDAwMDAx
IGM3ZTY1ZjM4IGMxZWIwMjhjIGM3ZTY1ZjU0IGMxMTAyNDNkIGMyNTc5Y2UxIGMwMTMyNTkw
ClsgICAxOS4yMDgwMDRdICBjMDEzMjU5MCBjMzE5NTNhOCBjN2U2NWY4NCBjN2U2NWY2NCBj
MTE2ZjFhMCBjMDEzMjU5MCBjMDEzMjljMCBjN2U2NWY3OApbICAgMTkuMjEyMDgyXSAgYzEx
NzJjNTUgYzAxMzI1OTAgYzdlNjVmODQgYzdlNjVmYTAgYzdlNjVmOTggYzEwZTMzYzQgMDAw
MDBmMTIgYzdlNjVmOTgKWyAgIDE5LjIxNTI3Ml0gQ2FsbCBUcmFjZToKWyAgIDE5LjIxNjE3
Ml0gIFs8YzFlYjAyOGM+XSBkdW1wX3N0YWNrKzB4NDAvMHg1ZQpbICAgMTkuMjE3NjQ4XSAg
WzxjMTEwMjQzZD5dIGxvY2tkZXBfcmN1X3N1c3BpY2lvdXMrMHgxYzAvMHgxZDcKWyAgIDE5
LjIxOTA4M10gIFs8YzExNmYxYTA+XSB0YXNrX2NzKzB4MWUzLzB4MjE4ClsgICAxOS4yMjA1
MDhdICBbPGMxMTcyYzU1Pl0gY3B1c2V0X2NwdXNfYWxsb3dlZCsweDU5LzB4YzEKWyAgIDE5
LjIyMTk3MV0gIFs8YzEwZTMzYzQ+XSBzY2hlZF9zZXRhZmZpbml0eSsweDJjOS8weDRjNQpb
ICAgMTkuMjIzNTQxXSAgWzxjMTBkOTcxZD5dID8gY29weV9mcm9tX3VzZXIrMHg0NC8weDU0
ClsgICAxOS4yMjQ5MTNdICBbPGMxMGUzNzM2Pl0gU3lTX3NjaGVkX3NldGFmZmluaXR5KzB4
MTc2LzB4MWE1ClsgICAxOS4yMjYzNzZdICBbPGMxZWY2MjRhPl0gc3lzZW50ZXJfZG9fY2Fs
bCsweDEyLzB4M2MKWyAgIDE5LjIzMjc1N10gd2FpdGluZyBtb2R1bGUgcmVtb3ZhbCBub3Qg
c3VwcG9ydGVkOiBwbGVhc2UgdXBncmFkZQpbICAgMTkuMjQzNzkwXSByZHNfcmVtb3ZlX2Jv
dW5kKCk6IHJzIGMwMzIwNDgwIHVuYmluZGluZyBmcm9tIDEyNy4wLjAuMTo0ODA4MQpbICAg
MTkuMjUwMDczXSByZHNfcmVtb3ZlX2JvdW5kKCk6IHJzIGMwM2JjYzAwIHVuYmluZGluZyBm
cm9tIDEyNy4wLjAuMToyODkzMwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMy
MC8wZTFkNzY4ZjFiMTg3MzI3MmVjNGU4ZGMxNDgyYmI1MjgxODU1MDE3L2RtZXNnLXF1YW50
YWwtaW5uLTI0OjIwMTQwMzAxMDg0MDEyOmkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMDo6
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwLzBlMWQ3NjhmMWIxODczMjcy
ZWM0ZThkYzE0ODJiYjUyODE4NTUwMTcvZG1lc2ctcXVhbnRhbC1pbm4tMjc6MjAxNDAzMDEw
ODQwMDg6aTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwOjoKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYzUtMDMwMTAzMjAvMGUxZDc2OGYxYjE4NzMyNzJlYzRlOGRjMTQ4MmJiNTI4MTg1
NTAxNy9kbWVzZy1xdWFudGFsLWJlbnMtMToyMDE0MDMwMTA4NDAxNzppMzg2LXJhbmRjb25m
aWctYzUtMDMwMTAzMjA6My4xNC4wLXJjMS0wMDA5NC1nMGUxZDc2ODoxMDEKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjAvMGUxZDc2OGYxYjE4NzMyNzJlYzRlOGRjMTQ4
MmJiNTI4MTg1NTAxNy9kbWVzZy15b2N0by1iZW5zLTI6MjAxNDAzMDEwODQwMjQ6aTM4Ni1y
YW5kY29uZmlnLWM1LTAzMDEwMzIwOjMuMTQuMC1yYzEtMDAwOTQtZzBlMWQ3Njg6MTAxCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwLzBlMWQ3NjhmMWIxODczMjcyZWM0
ZThkYzE0ODJiYjUyODE4NTUwMTcvZG1lc2cteW9jdG8tYmVucy02OjIwMTQwMzAxMDg0MDE4
OmkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMDozLjE0LjAtcmMxLTAwMDk0LWcwZTFkNzY4
OjEwMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMC8wZTFkNzY4ZjFiMTg3
MzI3MmVjNGU4ZGMxNDgyYmI1MjgxODU1MDE3L2RtZXNnLXlvY3RvLWNhaXJvLTMxOjIwMTQw
MzAxMDg0MDE4OmkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMDozLjE0LjAtcmMxLTAwMDk0
LWcwZTFkNzY4OjEwMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMC8wZTFk
NzY4ZjFiMTg3MzI3MmVjNGU4ZGMxNDgyYmI1MjgxODU1MDE3L2RtZXNnLXlvY3RvLXNuYi0z
MDoyMDE0MDMwMTA4NDAxNzppMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjA6Ogova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMC8wZTFkNzY4ZjFiMTg3MzI3MmVjNGU4ZGMx
NDgyYmI1MjgxODU1MDE3L2RtZXNnLXF1YW50YWwtYXRoZW5zLTMyOjIwMTQwMzAxMDg0MDI1
OmkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMDozLjE0LjAtcmMxLTAwMDk0LWcwZTFkNzY4
OjEwMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMC8wZTFkNzY4ZjFiMTg3
MzI3MmVjNGU4ZGMxNDgyYmI1MjgxODU1MDE3L2RtZXNnLXF1YW50YWwtamFrZXRvd24tNzoy
MDE0MDMwMTA4NDAyMzppMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjA6Ogova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMC8wZTFkNzY4ZjFiMTg3MzI3MmVjNGU4ZGMxNDgy
YmI1MjgxODU1MDE3L2RtZXNnLXF1YW50YWwtc25iLTMwOjIwMTQwMzAxMDg0MDI2OmkzODYt
cmFuZGNvbmZpZy1jNS0wMzAxMDMyMDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAz
MDEwMzIwLzBlMWQ3NjhmMWIxODczMjcyZWM0ZThkYzE0ODJiYjUyODE4NTUwMTcvZG1lc2ct
eW9jdG8taW5uLTI2OjIwMTQwMzAxMDg0MDMzOmkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMy
MDo6CjA6MTE6MTEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDMt
MDEgMDg6NDA6NDIgUkVQRUFUIENPVU5UOiAyMCAgIyAva2VybmVsLXRlc3RzL2xpbnV4Ni9v
YmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMpCltlYWY3OTdhYmM1M2IwYWIzZjBh
MDJkNGVmODczYTU2NWZjY2U2ZGFhXSBjZ3JvdXA6IHVwZGF0ZSBob3cgYSBuZXdseSBmb3Jr
ZWQgdGFzayBnZXRzIGFzc29jaWF0ZWQgd2l0aCBjc3Nfc2V0CnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4
Ni9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJh
bmRjb25maWctYzUtMDMwMTAzMjAvbmV4dDptYXN0ZXI6ZWFmNzk3YWJjNTNiMGFiM2YwYTAy
ZDRlZjg3M2E1NjVmY2NlNmRhYTpiaXNlY3QtbGludXg2CgoyMDE0LTAzLTAxLTA4OjQwOjQz
IGVhZjc5N2FiYzUzYjBhYjNmMGEwMmQ0ZWY4NzNhNTY1ZmNjZTZkYWEgY29tcGlsaW5nCjE1
MiByZWFsICAxNTE0IHVzZXIgIDk4IHN5cyAgMTA1Ni4zOSUgY3B1IAlpMzg2LXJhbmRjb25m
aWctYzUtMDMwMTAzMjAKCjIwMTQtMDMtMDEtMDg6NDM6MzMgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgMy4xNC4wLXJjMS0wMDA5My1nZWFmNzk3YS4uCTMJMTIJMTQJMTkJMjAgU1VDQ0VTUwoK
MGUxZDc2OGYxYjE4NzMyNzJlYzRlOGRjMTQ4MmJiNTI4MTg1NTAxNyBpcyB0aGUgZmlyc3Qg
YmFkIGNvbW1pdApjb21taXQgMGUxZDc2OGYxYjE4NzMyNzJlYzRlOGRjMTQ4MmJiNTI4MTg1
NTAxNwpBdXRob3I6IFRlanVuIEhlbyA8dGpAa2VybmVsLm9yZz4KRGF0ZTogICBUdWUgRmVi
IDI1IDEwOjA0OjAzIDIwMTQgLTA1MDAKCiAgICBjZ3JvdXA6IGRyb3AgdGFza19sb2NrKCkg
cHJvdGVjdGlvbiBhcm91bmQgdGFzay0+Y2dyb3VwcwogICAgCiAgICBGb3Igb3B0aW1pemF0
aW9uLCB0YXNrX2xvY2soKSBpcyBhZGRpdGlvbmFsbHkgdXNlZCB0byBwcm90ZWN0CiAgICB0
YXNrLT5jZ3JvdXBzLiAgVGhlIG9wdGltaXphdGlvbiBpcyBwcmV0dHkgZHViaW91cyBhcyBl
aXRoZXIKICAgIGNzc19zZXRfcndzZW0gaXMgZ3JhYmJlZCBhbnl3YXkgb3IgUEZfRVhJVElO
RyBhbHJlYWR5IHByb3RlY3RzCiAgICB0YXNrLT5jZ3JvdXBzLiAgSXQgYWRkcyBvbmx5IG92
ZXJoZWFkIGFuZCBjb25mdXNpb24gYXQgdGhpcyBwb2ludC4KICAgIExldCdzIGRyb3AgdGFz
a19bdW5dbG9jaygpIGFuZCB1cGRhdGUgY29tbWVudHMgYWNjb3JkaW5nbHkuCiAgICAKICAg
IFNpZ25lZC1vZmYtYnk6IFRlanVuIEhlbyA8dGpAa2VybmVsLm9yZz4KICAgIEFja2VkLWJ5
OiBMaSBaZWZhbiA8bGl6ZWZhbkBodWF3ZWkuY29tPgoKOjA0MDAwMCAwNDAwMDAgMTNkMmZm
ZDE3Y2QxZWU3YzdjZmYyNDZlOTk1M2QyNzY3NDEwMjAzNCAyYjc4MDA1MGU5NGU0N2EyZDQy
ZWNmZDg2YmQwMTAxNGVlMmRiNTk2IE0JaW5jbHVkZQo6MDQwMDAwIDA0MDAwMCA0OTM0NjUy
MmI5NjBmOWViMzkwMGE0ZjQ5MjYwZTI5NWI0OWMyMTY3IDk0NTVmY2JjNzdmNWExMTM3ODc5
OTEzYzk0NjhlMWRiNzg2OTNlMzUgTQlrZXJuZWwKYmlzZWN0IHJ1biBzdWNjZXNzCmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzUtMDMwMTAz
MjAvbmV4dDptYXN0ZXI6ZWFmNzk3YWJjNTNiMGFiM2YwYTAyZDRlZjg3M2E1NjVmY2NlNmRh
YTpiaXNlY3QtbGludXg2CgoyMDE0LTAzLTAxLTA4OjQ3OjA0IGVhZjc5N2FiYzUzYjBhYjNm
MGEwMmQ0ZWY4NzNhNTY1ZmNjZTZkYWEgcmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YzUtMDMwMTAzMjAvZWFmNzk3YWJjNTNiMGFiM2YwYTAyZDRlZjg3M2E1NjVmY2NlNmRhYS92
bWxpbnV6LTMuMTQuMC1yYzEtMDAwOTMtZ2VhZjc5N2EKCjIwMTQtMDMtMDEtMDg6NDc6MDQg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uCTMyCTQzCTU1CTYwIFNVQ0NFU1MKCmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjAv
bmV4dDptYXN0ZXI6YjE0OGE0MmJhNzgyM2UzNDk3MWNkNGU1YjA1YTVjNzRmYTMzMTFlZDpi
aXNlY3QtbGludXg2CiBURVNUIEZBSUxVUkUKWyAgICA1LjQ5MTgyNV0gbW91bnRhbGwgKDg5
KSB1c2VkIGdyZWF0ZXN0IHN0YWNrIGRlcHRoOiA2MTkyIGJ5dGVzIGxlZnQKWyAgIDE2LjYx
ODc4Ml0gClsgICAxNi42MTkyNDFdID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0K
WyAgIDE2LjYxOTk2NF0gWyBJTkZPOiBzdXNwaWNpb3VzIFJDVSB1c2FnZS4gXQpbICAgMTYu
NjIwNzM3XSAzLjE0LjAtcmM0LW5leHQtMjAxNDAyMjgtMDU3MzgtZ2IxNDhhNDIgIzEgTm90
IHRhaW50ZWQKWyAgIDE2LjYyMTg0OV0gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LQpbICAgMTYuNjIyNTgwXSBpbmNsdWRlL2xpbnV4L2Nncm91cC5oOjcwNSBzdXNwaWNpb3Vz
IHJjdV9kZXJlZmVyZW5jZV9jaGVjaygpIHVzYWdlIQpbICAgMTYuNjI0MTg2XSAKWyAgIDE2
LjYyNDE4Nl0gb3RoZXIgaW5mbyB0aGF0IG1pZ2h0IGhlbHAgdXMgZGVidWcgdGhpczoKWyAg
IDE2LjYyNDE4Nl0gClsgICAxNi42MjU3MjRdIApbICAgMTYuNjI1NzI0XSByY3Vfc2NoZWR1
bGVyX2FjdGl2ZSA9IDEsIGRlYnVnX2xvY2tzID0gMApbICAgMTYuNjI2OTkyXSAyIGxvY2tz
IGhlbGQgYnkgdHJpbml0eS1jMC8zOTA5OgpbICAgMTYuNjI3NzQzXSAgIzA6ICAoY2FsbGJh
Y2tfbXV0ZXgpeysuKy4uLn0sIGF0OiBbPGMxMTc0ZjIyPl0gY3B1c2V0X2NwdXNfYWxsb3dl
ZCsweDJmLzB4YzEKWyAgIDE2LjYyOTQ4OF0gICMxOiAgKCYoJnAtPmFsbG9jX2xvY2spLT5y
bG9jayl7Ky4rLi4ufSwgYXQ6IFs8YzExNzRmMzc+XSBjcHVzZXRfY3B1c19hbGxvd2VkKzB4
NDQvMHhjMQpbICAgMTYuNjMxNDE3XSAKWyAgIDE2LjYzMTQxN10gc3RhY2sgYmFja3RyYWNl
OgpbICAgMTYuNjMyMzQ4XSBDUFU6IDAgUElEOiAzOTA5IENvbW06IHRyaW5pdHktYzAgTm90
IHRhaW50ZWQgMy4xNC4wLXJjNC1uZXh0LTIwMTQwMjI4LTA1NzM4LWdiMTQ4YTQyICMxClsg
ICAxNi42MzM5MDJdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAx
LzAxLzIwMTEKWyAgIDE2LjYzNDgyMF0gIDAwMDAwMDAxIDAwMDAwMDAxIGNkZThkZjM4IGMx
ZWNhN2JkIGNkZThkZjU0IGMxMTAzZmUyIGMyNTlmZDNjIGM3ZjkyNTkwClsgICAxNi42MzY3
NzRdICBjN2Y5MjU5MCBjMzFkNTg1MCBjZGU4ZGY4NCBjZGU4ZGY2NCBjMTE3MTQ3MSBjN2Y5
MjU5MCBjN2Y5MjljNCBjZGU4ZGY3OApbICAgMTYuNjM4NjU2XSAgYzExNzRmNGMgYzdmOTI1
OTAgY2RlOGRmODQgY2RlOGRmYTAgY2RlOGRmOTggYzEwZTNmZGMgMDAwMDBmNDUgY2RlOGRm
OTgKWyAgIDE2LjY0MDU5Ml0gQ2FsbCBUcmFjZToKWyAgIDE2LjY0MTE0N10gIFs8YzFlY2E3
YmQ+XSBkdW1wX3N0YWNrKzB4NDAvMHg1ZQpbICAgMTYuNjQxOTM1XSAgWzxjMTEwM2ZlMj5d
IGxvY2tkZXBfcmN1X3N1c3BpY2lvdXMrMHgxYzAvMHgxZDcKWyAgIDE2LjY0Mjg0MF0gIFs8
YzExNzE0NzE+XSB0YXNrX2NzKzB4MWUzLzB4MjE4ClsgICAxNi42NDM2ODNdICBbPGMxMTc0
ZjRjPl0gY3B1c2V0X2NwdXNfYWxsb3dlZCsweDU5LzB4YzEKWyAgIDE2LjY0NDUzOF0gIFs8
YzEwZTNmZGM+XSBzY2hlZF9zZXRhZmZpbml0eSsweDJjOS8weDRjNQpbICAgMTYuNjQ1Mzk0
XSAgWzxjMTBkYTE5Yj5dID8gY29weV9mcm9tX3VzZXIrMHg0NC8weDU0ClsgICAxNi42NDYy
MjhdICBbPGMxMGU0MzRlPl0gU3lTX3NjaGVkX3NldGFmZmluaXR5KzB4MTc2LzB4MWE1Clsg
ICAxNi42NDcyMDFdICBbPGMxZjEwNmVhPl0gc3lzZW50ZXJfZG9fY2FsbCsweDEyLzB4M2MK
WyAgIDE2LjY1MzMzN10gcmRzX3JlbW92ZV9ib3VuZCgpOiBycyBjMDIwOGI4MCB1bmJpbmRp
bmcgZnJvbSAxMjcuMTE2LjYyLjE0MTo0NjYxOApbICAgMTYuNjU2ODg3XSByZHNfcmVtb3Zl
X2JvdW5kKCk6IHJzIGMwYzQzNzgwIHVuYmluZGluZyBmcm9tIDEyNy4wLjAuMTo1MzQ4NQpb
ICAgNTAuNzQ2OTIyXSByYW5kb206IG5vbmJsb2NraW5nIHBvb2wgaXMgaW5pdGlhbGl6ZWQK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjAvYjE0OGE0MmJhNzgyM2UzNDk3
MWNkNGU1YjA1YTVjNzRmYTMzMTFlZC9kbWVzZy1xdWFudGFsLWNhaXJvLTExOjIwMTQwMzAx
MDYxODEwOmkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMDozLjE0LjAtcmM0LW5leHQtMjAx
NDAyMjgtMDU3MzgtZ2IxNDhhNDI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0wMzAx
MDMyMC9iMTQ4YTQyYmE3ODIzZTM0OTcxY2Q0ZTViMDVhNWM3NGZhMzMxMWVkL2RtZXNnLXlv
Y3RvLWF0aGVucy05OjIwMTQwMzAxMDYzNDUxOmkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMy
MDozLjE0LjAtcmM0LW5leHQtMjAxNDAyMjgtMDU3MzgtZ2IxNDhhNDI6MQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMC9iMTQ4YTQyYmE3ODIzZTM0OTcxY2Q0ZTViMDVh
NWM3NGZhMzMxMWVkL2RtZXNnLXF1YW50YWwtY2Fpcm8tNjoyMDE0MDMwMTA2MTc1MjppMzg2
LXJhbmRjb25maWctYzUtMDMwMTAzMjA6My4xNC4wLXJjNC1uZXh0LTIwMTQwMjI4LTA1NzM4
LWdiMTQ4YTQyOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjAvYjE0OGE0
MmJhNzgyM2UzNDk3MWNkNGU1YjA1YTVjNzRmYTMzMTFlZC9kbWVzZy1xdWFudGFsLWJlbnMt
NzoyMDE0MDMwMTA2MTgyNjppMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjA6My4xNC4wLXJj
NC1uZXh0LTIwMTQwMjI4LTA1NzM4LWdiMTQ4YTQyOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctYzUtMDMwMTAzMjAvYjE0OGE0MmJhNzgyM2UzNDk3MWNkNGU1YjA1YTVjNzRmYTMzMTFl
ZC9kbWVzZy1xdWFudGFsLXhpYW4tMzoyMDE0MDMwMTA2MTc1MDppMzg2LXJhbmRjb25maWct
YzUtMDMwMTAzMjA6My4xNC4wLXJjNC1uZXh0LTIwMTQwMjI4LTA1NzM4LWdiMTQ4YTQyOjEK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjAvYjE0OGE0MmJhNzgyM2UzNDk3
MWNkNGU1YjA1YTVjNzRmYTMzMTFlZC9kbWVzZy15b2N0by1yb2FtLTE2OjIwMTQwMzAxMDYz
NDM3OmkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMDozLjE0LjAtcmM0LW5leHQtMjAxNDAy
MjgtMDU3MzgtZ2IxNDhhNDI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMy
MC9iMTQ4YTQyYmE3ODIzZTM0OTcxY2Q0ZTViMDVhNWM3NGZhMzMxMWVkL2RtZXNnLXF1YW50
YWwtY2Fpcm8tMzQ6MjAxNDAzMDEwNjM0NTY6aTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIw
OjMuMTQuMC1yYzQtbmV4dC0yMDE0MDIyOC0wNTczOC1nYjE0OGE0MjoxCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwL2IxNDhhNDJiYTc4MjNlMzQ5NzFjZDRlNWIwNWE1
Yzc0ZmEzMzExZWQvZG1lc2cteW9jdG8tc25iLTI1OjIwMTQwMzAxMDYzNDQ1OmkzODYtcmFu
ZGNvbmZpZy1jNS0wMzAxMDMyMDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEw
MzIwL2IxNDhhNDJiYTc4MjNlMzQ5NzFjZDRlNWIwNWE1Yzc0ZmEzMzExZWQvZG1lc2cteW9j
dG8teGlhbi04OjIwMTQwMzAxMDYzNDM2OmkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMDoz
LjE0LjAtcmM0LW5leHQtMjAxNDAyMjgtMDU3MzgtZ2IxNDhhNDI6MQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1jNS0wMzAxMDMyMC9iMTQ4YTQyYmE3ODIzZTM0OTcxY2Q0ZTViMDVhNWM3
NGZhMzMxMWVkL2RtZXNnLXF1YW50YWwteGlhbi0zMjoyMDE0MDMwMTA2MTgwMjppMzg2LXJh
bmRjb25maWctYzUtMDMwMTAzMjA6My4xNC4wLXJjNC1uZXh0LTIwMTQwMjI4LTA1NzM4LWdi
MTQ4YTQyOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjAvYjE0OGE0MmJh
NzgyM2UzNDk3MWNkNGU1YjA1YTVjNzRmYTMzMTFlZC9kbWVzZy15b2N0by14aWFuLTM5OjIw
MTQwMzAxMDYzNDU5OmkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMDozLjE0LjAtcmM0LW5l
eHQtMjAxNDAyMjgtMDU3MzgtZ2IxNDhhNDI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1j
NS0wMzAxMDMyMC9iMTQ4YTQyYmE3ODIzZTM0OTcxY2Q0ZTViMDVhNWM3NGZhMzMxMWVkL2Rt
ZXNnLXlvY3RvLWpha2V0b3duLTMwOjIwMTQwMzAxMDYzNDU4OmkzODYtcmFuZGNvbmZpZy1j
NS0wMzAxMDMyMDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwL2IxNDhh
NDJiYTc4MjNlMzQ5NzFjZDRlNWIwNWE1Yzc0ZmEzMzExZWQvZG1lc2cteW9jdG8taW5uLTIw
OjIwMTQwMzAxMDYxNzUwOmkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMDo6Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwL2IxNDhhNDJiYTc4MjNlMzQ5NzFjZDRlNWIw
NWE1Yzc0ZmEzMzExZWQvZG1lc2ctcXVhbnRhbC1pbm4tMTc6MjAxNDAzMDEwNjE4MDc6aTM4
Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzUt
MDMwMTAzMjAvYjE0OGE0MmJhNzgyM2UzNDk3MWNkNGU1YjA1YTVjNzRmYTMzMTFlZC9kbWVz
Zy15b2N0by1jYWlyby02OjIwMTQwMzAxMDYzNDQ2OmkzODYtcmFuZGNvbmZpZy1jNS0wMzAx
MDMyMDozLjE0LjAtcmM0LW5leHQtMjAxNDAyMjgtMDU3MzgtZ2IxNDhhNDI6MQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMC9iMTQ4YTQyYmE3ODIzZTM0OTcxY2Q0ZTVi
MDVhNWM3NGZhMzMxMWVkL2RtZXNnLXlvY3RvLWlubi0zODoyMDE0MDMwMTA2MzUwMjppMzg2
LXJhbmRjb25maWctYzUtMDMwMTAzMjA6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0w
MzAxMDMyMC9iMTQ4YTQyYmE3ODIzZTM0OTcxY2Q0ZTViMDVhNWM3NGZhMzMxMWVkL2RtZXNn
LXF1YW50YWwtbGtwLXN0MDEtMTU6MjAxNDAzMDEwNjE4MDc6aTM4Ni1yYW5kY29uZmlnLWM1
LTAzMDEwMzIwOjMuMTQuMC1yYzQtbmV4dC0yMDE0MDIyOC0wNTczOC1nYjE0OGE0MjoxCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwL2IxNDhhNDJiYTc4MjNlMzQ5NzFj
ZDRlNWIwNWE1Yzc0ZmEzMzExZWQvZG1lc2ctcXVhbnRhbC1qYWtldG93bi05OjIwMTQwMzAx
MDYxODIxOmkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMDo6Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWM1LTAzMDEwMzIwL2IxNDhhNDJiYTc4MjNlMzQ5NzFjZDRlNWIwNWE1Yzc0ZmEz
MzExZWQvZG1lc2ctcXVhbnRhbC1hdGhlbnMtNToyMDE0MDMwMTA2MzQ1MjppMzg2LXJhbmRj
b25maWctYzUtMDMwMTAzMjA6My4xNC4wLXJjNC1uZXh0LTIwMTQwMjI4LTA1NzM4LWdiMTQ4
YTQyOjEKMDoxOToxOSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKW2RldGFjaGVkIEhF
QUQgOGY2ZWFhNF0gUmV2ZXJ0ICJjZ3JvdXA6IGRyb3AgdGFza19sb2NrKCkgcHJvdGVjdGlv
biBhcm91bmQgdGFzay0+Y2dyb3VwcyIKIENvbW1pdHRlcjogV3UgRmVuZ2d1YW5nIDxrYnVp
bGRAYmVlPgpZb3VyIG5hbWUgYW5kIGVtYWlsIGFkZHJlc3Mgd2VyZSBjb25maWd1cmVkIGF1
dG9tYXRpY2FsbHkgYmFzZWQKb24geW91ciB1c2VybmFtZSBhbmQgaG9zdG5hbWUuIFBsZWFz
ZSBjaGVjayB0aGF0IHRoZXkgYXJlIGFjY3VyYXRlLgpZb3UgY2FuIHN1cHByZXNzIHRoaXMg
bWVzc2FnZSBieSBzZXR0aW5nIHRoZW0gZXhwbGljaXRseToKCiAgICBnaXQgY29uZmlnIC0t
Z2xvYmFsIHVzZXIubmFtZSAiWW91ciBOYW1lIgogICAgZ2l0IGNvbmZpZyAtLWdsb2JhbCB1
c2VyLmVtYWlsIHlvdUBleGFtcGxlLmNvbQoKQWZ0ZXIgZG9pbmcgdGhpcywgeW91IG1heSBm
aXggdGhlIGlkZW50aXR5IHVzZWQgZm9yIHRoaXMgY29tbWl0IHdpdGg6CgogICAgZ2l0IGNv
bW1pdCAtLWFtZW5kIC0tcmVzZXQtYXV0aG9yCgogMiBmaWxlcyBjaGFuZ2VkLCA3NSBpbnNl
cnRpb25zKCspLCAyOCBkZWxldGlvbnMoLSkKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMC9uZXh0Om1hc3Rlcjo4ZjZlYWE0
YjI4ZGVkMmMwMzk0M2EzM2Q5YjIzMzI1ZmQ4ZjIwODQxOmJpc2VjdC1saW51eDYKCjIwMTQt
MDMtMDEtMDg6NTA6MzkgOGY2ZWFhNGIyOGRlZDJjMDM5NDNhMzNkOWIyMzMyNWZkOGYyMDg0
MSBjb21waWxpbmcKCjIwMTQtMDMtMDEtMDg6NTU6MjEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
My4xNC4wLXJjNC1uZXh0LTIwMTQwMjI4LTA1NzM5LWc4ZjZlYWE0Li4uCTE2CTMwCTQ4CTU4
CTYwIFNVQ0NFU1MKCgo9PT09PT09PT0gdXBzdHJlYW0gPT09PT09PT09CkZldGNoaW5nIGxp
bnVzCkZyb20gZ2l0Oi8vZ2l0bWlycm9yL2xpbnVzCiAgIGQ4ZWZjZjMuLjg0MjdkZWYgIG1h
c3RlciAgICAgLT4gbGludXMvbWFzdGVyCldhcm5pbmc6IHlvdSBhcmUgbGVhdmluZyAxIGNv
bW1pdCBiZWhpbmQsIG5vdCBjb25uZWN0ZWQgdG8KYW55IG9mIHlvdXIgYnJhbmNoZXM6Cgog
IDhmNmVhYTQgUmV2ZXJ0ICJjZ3JvdXA6IGRyb3AgdGFza19sb2NrKCkgcHJvdGVjdGlvbiBh
cm91bmQgdGFzay0+Y2dyb3VwcyIKCklmIHlvdSB3YW50IHRvIGtlZXAgdGhlbSBieSBjcmVh
dGluZyBhIG5ldyBicmFuY2gsIHRoaXMgbWF5IGJlIGEgZ29vZCB0aW1lCnRvIGRvIHNvIHdp
dGg6CgogZ2l0IGJyYW5jaCBuZXdfYnJhbmNoX25hbWUgOGY2ZWFhNAoKSEVBRCBpcyBub3cg
YXQgODQyN2RlZi4uLiBNQUlOVEFJTkVSUzogYWRkIG1haW50YWluZXIgZW50cnkgZm9yIEFy
bWFkYSBEUk0gZHJpdmVyCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWctYzUtMDMwMTAzMjAvbmV4dDptYXN0ZXI6ODQyN2RlZmQwODdhZTZjNWVh
ZWE5ZDYwOWRmZTdmMTY1NTY4YWNjZDpiaXNlY3QtbGludXg2CgoyMDE0LTAzLTAxLTA4OjU5
OjI1IDg0MjdkZWZkMDg3YWU2YzVlYWVhOWQ2MDlkZmU3ZjE2NTU2OGFjY2QgY29tcGlsaW5n
CgoyMDE0LTAzLTAxLTA5OjA0OjA0IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzQt
MDAxMjAtZzg0MjdkZWYuLgkyCTExCTMwCTQ4CTUwCTYwIFNVQ0NFU1MKCgo9PT09PT09PT0g
bGludXgtbmV4dCA9PT09PT09PT0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgODQyN2Rl
Zi4uLiBNQUlOVEFJTkVSUzogYWRkIG1haW50YWluZXIgZW50cnkgZm9yIEFybWFkYSBEUk0g
ZHJpdmVyCkhFQUQgaXMgbm93IGF0IGIxNDhhNDIuLi4gQWRkIGxpbnV4LW5leHQgc3BlY2lm
aWMgZmlsZXMgZm9yIDIwMTQwMjI4CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2
bS9pMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjAvbmV4dDptYXN0ZXI6YjE0OGE0MmJhNzgy
M2UzNDk3MWNkNGU1YjA1YTVjNzRmYTMzMTFlZDpiaXNlY3QtbGludXg2CiBURVNUIEZBSUxV
UkUKWyAgICA1LjQ5MTgyNV0gbW91bnRhbGwgKDg5KSB1c2VkIGdyZWF0ZXN0IHN0YWNrIGRl
cHRoOiA2MTkyIGJ5dGVzIGxlZnQKWyAgIDE2LjYxODc4Ml0gClsgICAxNi42MTkyNDFdID09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KWyAgIDE2LjYxOTk2NF0gWyBJTkZPOiBz
dXNwaWNpb3VzIFJDVSB1c2FnZS4gXQpbICAgMTYuNjIwNzM3XSAzLjE0LjAtcmM0LW5leHQt
MjAxNDAyMjgtMDU3MzgtZ2IxNDhhNDIgIzEgTm90IHRhaW50ZWQKWyAgIDE2LjYyMTg0OV0g
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpbICAgMTYuNjIyNTgwXSBpbmNsdWRl
L2xpbnV4L2Nncm91cC5oOjcwNSBzdXNwaWNpb3VzIHJjdV9kZXJlZmVyZW5jZV9jaGVjaygp
IHVzYWdlIQpbICAgMTYuNjI0MTg2XSAKWyAgIDE2LjYyNDE4Nl0gb3RoZXIgaW5mbyB0aGF0
IG1pZ2h0IGhlbHAgdXMgZGVidWcgdGhpczoKWyAgIDE2LjYyNDE4Nl0gClsgICAxNi42MjU3
MjRdIApbICAgMTYuNjI1NzI0XSByY3Vfc2NoZWR1bGVyX2FjdGl2ZSA9IDEsIGRlYnVnX2xv
Y2tzID0gMApbICAgMTYuNjI2OTkyXSAyIGxvY2tzIGhlbGQgYnkgdHJpbml0eS1jMC8zOTA5
OgpbICAgMTYuNjI3NzQzXSAgIzA6ICAoY2FsbGJhY2tfbXV0ZXgpeysuKy4uLn0sIGF0OiBb
PGMxMTc0ZjIyPl0gY3B1c2V0X2NwdXNfYWxsb3dlZCsweDJmLzB4YzEKWyAgIDE2LjYyOTQ4
OF0gICMxOiAgKCYoJnAtPmFsbG9jX2xvY2spLT5ybG9jayl7Ky4rLi4ufSwgYXQ6IFs8YzEx
NzRmMzc+XSBjcHVzZXRfY3B1c19hbGxvd2VkKzB4NDQvMHhjMQpbICAgMTYuNjMxNDE3XSAK
WyAgIDE2LjYzMTQxN10gc3RhY2sgYmFja3RyYWNlOgpbICAgMTYuNjMyMzQ4XSBDUFU6IDAg
UElEOiAzOTA5IENvbW06IHRyaW5pdHktYzAgTm90IHRhaW50ZWQgMy4xNC4wLXJjNC1uZXh0
LTIwMTQwMjI4LTA1NzM4LWdiMTQ4YTQyICMxClsgICAxNi42MzM5MDJdIEhhcmR3YXJlIG5h
bWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgIDE2LjYzNDgyMF0g
IDAwMDAwMDAxIDAwMDAwMDAxIGNkZThkZjM4IGMxZWNhN2JkIGNkZThkZjU0IGMxMTAzZmUy
IGMyNTlmZDNjIGM3ZjkyNTkwClsgICAxNi42MzY3NzRdICBjN2Y5MjU5MCBjMzFkNTg1MCBj
ZGU4ZGY4NCBjZGU4ZGY2NCBjMTE3MTQ3MSBjN2Y5MjU5MCBjN2Y5MjljNCBjZGU4ZGY3OApb
ICAgMTYuNjM4NjU2XSAgYzExNzRmNGMgYzdmOTI1OTAgY2RlOGRmODQgY2RlOGRmYTAgY2Rl
OGRmOTggYzEwZTNmZGMgMDAwMDBmNDUgY2RlOGRmOTgKWyAgIDE2LjY0MDU5Ml0gQ2FsbCBU
cmFjZToKWyAgIDE2LjY0MTE0N10gIFs8YzFlY2E3YmQ+XSBkdW1wX3N0YWNrKzB4NDAvMHg1
ZQpbICAgMTYuNjQxOTM1XSAgWzxjMTEwM2ZlMj5dIGxvY2tkZXBfcmN1X3N1c3BpY2lvdXMr
MHgxYzAvMHgxZDcKWyAgIDE2LjY0Mjg0MF0gIFs8YzExNzE0NzE+XSB0YXNrX2NzKzB4MWUz
LzB4MjE4ClsgICAxNi42NDM2ODNdICBbPGMxMTc0ZjRjPl0gY3B1c2V0X2NwdXNfYWxsb3dl
ZCsweDU5LzB4YzEKWyAgIDE2LjY0NDUzOF0gIFs8YzEwZTNmZGM+XSBzY2hlZF9zZXRhZmZp
bml0eSsweDJjOS8weDRjNQpbICAgMTYuNjQ1Mzk0XSAgWzxjMTBkYTE5Yj5dID8gY29weV9m
cm9tX3VzZXIrMHg0NC8weDU0ClsgICAxNi42NDYyMjhdICBbPGMxMGU0MzRlPl0gU3lTX3Nj
aGVkX3NldGFmZmluaXR5KzB4MTc2LzB4MWE1ClsgICAxNi42NDcyMDFdICBbPGMxZjEwNmVh
Pl0gc3lzZW50ZXJfZG9fY2FsbCsweDEyLzB4M2MKWyAgIDE2LjY1MzMzN10gcmRzX3JlbW92
ZV9ib3VuZCgpOiBycyBjMDIwOGI4MCB1bmJpbmRpbmcgZnJvbSAxMjcuMTE2LjYyLjE0MTo0
NjYxOApbICAgMTYuNjU2ODg3XSByZHNfcmVtb3ZlX2JvdW5kKCk6IHJzIGMwYzQzNzgwIHVu
YmluZGluZyBmcm9tIDEyNy4wLjAuMTo1MzQ4NQpbICAgNTAuNzQ2OTIyXSByYW5kb206IG5v
bmJsb2NraW5nIHBvb2wgaXMgaW5pdGlhbGl6ZWQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YzUtMDMwMTAzMjAvYjE0OGE0MmJhNzgyM2UzNDk3MWNkNGU1YjA1YTVjNzRmYTMzMTFlZC9k
bWVzZy1xdWFudGFsLWNhaXJvLTExOjIwMTQwMzAxMDYxODEwOmkzODYtcmFuZGNvbmZpZy1j
NS0wMzAxMDMyMDozLjE0LjAtcmM0LW5leHQtMjAxNDAyMjgtMDU3MzgtZ2IxNDhhNDI6MQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMC9iMTQ4YTQyYmE3ODIzZTM0OTcx
Y2Q0ZTViMDVhNWM3NGZhMzMxMWVkL2RtZXNnLXlvY3RvLWF0aGVucy05OjIwMTQwMzAxMDYz
NDUxOmkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMDozLjE0LjAtcmM0LW5leHQtMjAxNDAy
MjgtMDU3MzgtZ2IxNDhhNDI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMy
MC9iMTQ4YTQyYmE3ODIzZTM0OTcxY2Q0ZTViMDVhNWM3NGZhMzMxMWVkL2RtZXNnLXF1YW50
YWwtY2Fpcm8tNjoyMDE0MDMwMTA2MTc1MjppMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjA6
My4xNC4wLXJjNC1uZXh0LTIwMTQwMjI4LTA1NzM4LWdiMTQ4YTQyOjEKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYzUtMDMwMTAzMjAvYjE0OGE0MmJhNzgyM2UzNDk3MWNkNGU1YjA1YTVj
NzRmYTMzMTFlZC9kbWVzZy1xdWFudGFsLWJlbnMtNzoyMDE0MDMwMTA2MTgyNjppMzg2LXJh
bmRjb25maWctYzUtMDMwMTAzMjA6My4xNC4wLXJjNC1uZXh0LTIwMTQwMjI4LTA1NzM4LWdi
MTQ4YTQyOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjAvYjE0OGE0MmJh
NzgyM2UzNDk3MWNkNGU1YjA1YTVjNzRmYTMzMTFlZC9kbWVzZy1xdWFudGFsLXhpYW4tMzoy
MDE0MDMwMTA2MTc1MDppMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjA6My4xNC4wLXJjNC1u
ZXh0LTIwMTQwMjI4LTA1NzM4LWdiMTQ4YTQyOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YzUtMDMwMTAzMjAvYjE0OGE0MmJhNzgyM2UzNDk3MWNkNGU1YjA1YTVjNzRmYTMzMTFlZC9k
bWVzZy15b2N0by1yb2FtLTE2OjIwMTQwMzAxMDYzNDM3OmkzODYtcmFuZGNvbmZpZy1jNS0w
MzAxMDMyMDozLjE0LjAtcmM0LW5leHQtMjAxNDAyMjgtMDU3MzgtZ2IxNDhhNDI6MQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMC9iMTQ4YTQyYmE3ODIzZTM0OTcxY2Q0
ZTViMDVhNWM3NGZhMzMxMWVkL2RtZXNnLXF1YW50YWwtY2Fpcm8tMzQ6MjAxNDAzMDEwNjM0
NTY6aTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwOjMuMTQuMC1yYzQtbmV4dC0yMDE0MDIy
OC0wNTczOC1nYjE0OGE0MjoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIw
L2IxNDhhNDJiYTc4MjNlMzQ5NzFjZDRlNWIwNWE1Yzc0ZmEzMzExZWQvZG1lc2cteW9jdG8t
c25iLTI1OjIwMTQwMzAxMDYzNDQ1OmkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMDo6Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwL2IxNDhhNDJiYTc4MjNlMzQ5NzFj
ZDRlNWIwNWE1Yzc0ZmEzMzExZWQvZG1lc2cteW9jdG8teGlhbi04OjIwMTQwMzAxMDYzNDM2
OmkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMDozLjE0LjAtcmM0LW5leHQtMjAxNDAyMjgt
MDU3MzgtZ2IxNDhhNDI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMC9i
MTQ4YTQyYmE3ODIzZTM0OTcxY2Q0ZTViMDVhNWM3NGZhMzMxMWVkL2RtZXNnLXF1YW50YWwt
eGlhbi0zMjoyMDE0MDMwMTA2MTgwMjppMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjA6My4x
NC4wLXJjNC1uZXh0LTIwMTQwMjI4LTA1NzM4LWdiMTQ4YTQyOjEKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctYzUtMDMwMTAzMjAvYjE0OGE0MmJhNzgyM2UzNDk3MWNkNGU1YjA1YTVjNzRm
YTMzMTFlZC9kbWVzZy15b2N0by14aWFuLTM5OjIwMTQwMzAxMDYzNDU5OmkzODYtcmFuZGNv
bmZpZy1jNS0wMzAxMDMyMDozLjE0LjAtcmM0LW5leHQtMjAxNDAyMjgtMDU3MzgtZ2IxNDhh
NDI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMC9iMTQ4YTQyYmE3ODIz
ZTM0OTcxY2Q0ZTViMDVhNWM3NGZhMzMxMWVkL2RtZXNnLXlvY3RvLWpha2V0b3duLTMwOjIw
MTQwMzAxMDYzNDU4OmkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMDo6Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwL2IxNDhhNDJiYTc4MjNlMzQ5NzFjZDRlNWIwNWE1
Yzc0ZmEzMzExZWQvZG1lc2cteW9jdG8taW5uLTIwOjIwMTQwMzAxMDYxNzUwOmkzODYtcmFu
ZGNvbmZpZy1jNS0wMzAxMDMyMDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEw
MzIwL2IxNDhhNDJiYTc4MjNlMzQ5NzFjZDRlNWIwNWE1Yzc0ZmEzMzExZWQvZG1lc2ctcXVh
bnRhbC1pbm4tMTc6MjAxNDAzMDEwNjE4MDc6aTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIw
OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjAvYjE0OGE0MmJhNzgyM2Uz
NDk3MWNkNGU1YjA1YTVjNzRmYTMzMTFlZC9kbWVzZy15b2N0by1jYWlyby02OjIwMTQwMzAx
MDYzNDQ2OmkzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMDozLjE0LjAtcmM0LW5leHQtMjAx
NDAyMjgtMDU3MzgtZ2IxNDhhNDI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0wMzAx
MDMyMC9iMTQ4YTQyYmE3ODIzZTM0OTcxY2Q0ZTViMDVhNWM3NGZhMzMxMWVkL2RtZXNnLXlv
Y3RvLWlubi0zODoyMDE0MDMwMTA2MzUwMjppMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjA6
Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0wMzAxMDMyMC9iMTQ4YTQyYmE3ODIzZTM0
OTcxY2Q0ZTViMDVhNWM3NGZhMzMxMWVkL2RtZXNnLXF1YW50YWwtbGtwLXN0MDEtMTU6MjAx
NDAzMDEwNjE4MDc6aTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwOjMuMTQuMC1yYzQtbmV4
dC0yMDE0MDIyOC0wNTczOC1nYjE0OGE0MjoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1
LTAzMDEwMzIwL2IxNDhhNDJiYTc4MjNlMzQ5NzFjZDRlNWIwNWE1Yzc0ZmEzMzExZWQvZG1l
c2ctcXVhbnRhbC1qYWtldG93bi05OjIwMTQwMzAxMDYxODIxOmkzODYtcmFuZGNvbmZpZy1j
NS0wMzAxMDMyMDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAzMDEwMzIwL2IxNDhh
NDJiYTc4MjNlMzQ5NzFjZDRlNWIwNWE1Yzc0ZmEzMzExZWQvZG1lc2ctcXVhbnRhbC1hdGhl
bnMtNToyMDE0MDMwMTA2MzQ1MjppMzg2LXJhbmRjb25maWctYzUtMDMwMTAzMjA6My4xNC4w
LXJjNC1uZXh0LTIwMTQwMjI4LTA1NzM4LWdiMTQ4YTQyOjEKMDoxOToxOSBhbGxfZ29vZDpi
YWQ6YWxsX2JhZCBib290cwoK

--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc4-next-20140228-05738-gb148a42"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.14.0-rc4 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_KERNEL_XZ=y
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_FHANDLE is not set
# CONFIG_USELIB is not set
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
# CONFIG_MEMCG_KMEM is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
CONFIG_SYSFS_SYSCALL=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=m
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
CONFIG_GCOV_FORMAT_3_4=y
# CONFIG_GCOV_FORMAT_4_7 is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_MODULE_SIG is not set
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set
# CONFIG_BLK_DEV_THROTTLING is not set
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
# CONFIG_ACORN_PARTITION_EESOX is not set
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
# CONFIG_ACORN_PARTITION_POWERTEC is not set
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_AIX_PARTITION=y
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
# CONFIG_CMDLINE_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=5
CONFIG_X86_L1_CACHE_SHIFT=5
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
# CONFIG_X86_UP_APIC is not set
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=y
CONFIG_I8K=m
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=m
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K7_ACPI=y
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=m
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
# CONFIG_X86_SPEEDSTEP_ICH is not set
CONFIG_X86_SPEEDSTEP_SMI=y
CONFIG_X86_P4_CLOCKMOD=m
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
CONFIG_X86_LONGRUN=y
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_OLPC=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
CONFIG_EISA_VLB_PRIMING=y
CONFIG_EISA_PCI_EISA=y
# CONFIG_EISA_VIRTUAL_ROOT is not set
# CONFIG_EISA_NAMES is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_OLPC=y
# CONFIG_OLPC_XO15_SCI is not set
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
# CONFIG_GEOS is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PCMCIA_PROBE=y
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=m
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
# CONFIG_IP_ROUTE_MULTIPATH is not set
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_ROUTE_CLASSID=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=m
CONFIG_NET_IPGRE=m
# CONFIG_NET_IPGRE_BROADCAST is not set
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
# CONFIG_IP_PIMSM_V2 is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_NET_IPVTI is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
CONFIG_INET_XFRM_MODE_TUNNEL=m
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
# CONFIG_INET_UDP_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=y
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=y
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=y
# CONFIG_TCP_CONG_LP is not set
CONFIG_TCP_CONG_VENO=y
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=y
CONFIG_DEFAULT_BIC=y
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HYBLA is not set
# CONFIG_DEFAULT_VENO is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="bic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=m
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=m
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_GRE=m
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
# CONFIG_NF_CONNTRACK_SECMARK is not set
CONFIG_NF_CONNTRACK_PROCFS=y
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
CONFIG_NF_CONNTRACK_SIP=m
# CONFIG_NF_CT_NETLINK is not set
CONFIG_NF_TABLES=y
CONFIG_NF_TABLES_INET=m
CONFIG_NFT_EXTHDR=m
# CONFIG_NFT_META is not set
# CONFIG_NFT_CT is not set
# CONFIG_NFT_RBTREE is not set
# CONFIG_NFT_HASH is not set
# CONFIG_NFT_COUNTER is not set
# CONFIG_NFT_LOG is not set
# CONFIG_NFT_LIMIT is not set
CONFIG_NFT_REJECT=y
CONFIG_NFT_REJECT_INET=m
# CONFIG_NFT_COMPAT is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=y

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_LOG=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_SECMARK=y
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_IP_SET=y
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=y
CONFIG_IP_SET_BITMAP_IPMAC=y
CONFIG_IP_SET_BITMAP_PORT=m
# CONFIG_IP_SET_HASH_IP is not set
# CONFIG_IP_SET_HASH_IPPORT is not set
CONFIG_IP_SET_HASH_IPPORTIP=m
# CONFIG_IP_SET_HASH_IPPORTNET is not set
# CONFIG_IP_SET_HASH_NETPORTNET is not set
# CONFIG_IP_SET_HASH_NET is not set
CONFIG_IP_SET_HASH_NETNET=m
# CONFIG_IP_SET_HASH_NETPORT is not set
CONFIG_IP_SET_HASH_NETIFACE=m
# CONFIG_IP_SET_LIST_SET is not set
CONFIG_IP_VS=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
# CONFIG_IP_VS_PROTO_ESP is not set
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
# CONFIG_IP_VS_RR is not set
CONFIG_IP_VS_WRR=y
CONFIG_IP_VS_LC=m
# CONFIG_IP_VS_WLC is not set
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=y
# CONFIG_IP_VS_DH is not set
CONFIG_IP_VS_SH=y
# CONFIG_IP_VS_SED is not set
# CONFIG_IP_VS_NQ is not set

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
# CONFIG_NF_CONNTRACK_IPV4 is not set
CONFIG_NF_TABLES_IPV4=m
# CONFIG_NFT_CHAIN_ROUTE_IPV4 is not set
CONFIG_NFT_REJECT_IPV4=m
# CONFIG_NF_TABLES_ARP is not set
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_FILTER=y
# CONFIG_IP_NF_TARGET_REJECT is not set
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_IP_NF_MANGLE=m
# CONFIG_IP_NF_RAW is not set

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_NF_TABLES_IPV6=m
# CONFIG_NFT_CHAIN_ROUTE_IPV6 is not set
CONFIG_NFT_REJECT_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
# CONFIG_NF_TABLES_BRIDGE is not set
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
# CONFIG_BRIDGE_EBT_IP6 is not set
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
# CONFIG_BRIDGE_EBT_PKTTYPE is not set
CONFIG_BRIDGE_EBT_STP=m
# CONFIG_BRIDGE_EBT_VLAN is not set
# CONFIG_BRIDGE_EBT_ARPREPLY is not set
CONFIG_BRIDGE_EBT_DNAT=m
# CONFIG_BRIDGE_EBT_MARK_T is not set
CONFIG_BRIDGE_EBT_REDIRECT=m
# CONFIG_BRIDGE_EBT_SNAT is not set
# CONFIG_BRIDGE_EBT_LOG is not set
# CONFIG_BRIDGE_EBT_ULOG is not set
CONFIG_BRIDGE_EBT_NFLOG=m
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
CONFIG_IP_DCCP_CCID3_DEBUG=y
CONFIG_IP_DCCP_TFRC_LIB=y
CONFIG_IP_DCCP_TFRC_DEBUG=y

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
CONFIG_NET_DCCPPROBE=m
CONFIG_IP_SCTP=m
# CONFIG_NET_SCTPPROBE is not set
CONFIG_SCTP_DBG_OBJCNT=y
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_RDS=y
CONFIG_RDS_TCP=y
CONFIG_RDS_DEBUG=y
CONFIG_TIPC=m
CONFIG_TIPC_PORTS=8191
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
CONFIG_ATM_CLIP_NO_ICMP=y
CONFIG_ATM_LANE=y
# CONFIG_ATM_MPOA is not set
# CONFIG_ATM_BR2684 is not set
CONFIG_L2TP=m
# CONFIG_L2TP_DEBUGFS is not set
CONFIG_L2TP_V3=y
# CONFIG_L2TP_IP is not set
CONFIG_L2TP_ETH=m
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_MRP=y
CONFIG_BRIDGE=m
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_DECNET=m
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=m
CONFIG_IPX=m
# CONFIG_IPX_INTERN is not set
# CONFIG_ATALK is not set
CONFIG_X25=m
# CONFIG_LAPB is not set
CONFIG_PHONET=m
# CONFIG_IEEE802154 is not set
CONFIG_6LOWPAN_IPHC=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=y
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_MQPRIO=y
CONFIG_NET_SCH_CHOKE=m
# CONFIG_NET_SCH_QFQ is not set
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_FQ=m
# CONFIG_NET_SCH_HHF is not set
CONFIG_NET_SCH_PIE=y
CONFIG_NET_SCH_INGRESS=m
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
CONFIG_NET_CLS_ROUTE4=m
# CONFIG_NET_CLS_FW is not set
CONFIG_NET_CLS_U32=m
# CONFIG_CLS_U32_PERF is not set
# CONFIG_CLS_U32_MARK is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=y
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
# CONFIG_NET_ACT_GACT is not set
CONFIG_NET_ACT_MIRRED=m
# CONFIG_NET_ACT_IPT is not set
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=y
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=m
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_BLA=y
CONFIG_BATMAN_ADV_DAT=y
# CONFIG_BATMAN_ADV_NC is not set
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=m
CONFIG_NET_MPLS_GSO=m
# CONFIG_HSR is not set
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
# CONFIG_NET_TCPPROBE is not set
CONFIG_NET_DROP_MONITOR=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=y
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIBCM203X=y
# CONFIG_BT_HCIBPA10X is not set
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=m
CONFIG_BT_WILINK=y
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
# CONFIG_RXKAD is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
CONFIG_CFG80211_REG_DEBUG=y
# CONFIG_CFG80211_DEFAULT_PS is not set
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
CONFIG_RFKILL_REGULATOR=y
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
CONFIG_NFC=y
# CONFIG_NFC_DIGITAL is not set
# CONFIG_NFC_NCI is not set
CONFIG_NFC_HCI=m
# CONFIG_NFC_SHDLC is not set

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_PN533 is not set
# CONFIG_NFC_SIM is not set
CONFIG_NFC_PN544=m
CONFIG_NFC_MICROREAD=m

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_CMA is not set

#
# Bus devices
#
CONFIG_CONNECTOR=m
CONFIG_MTD=m
CONFIG_MTD_TESTS=m
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=m
CONFIG_MTD_OF_PARTS=m
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=m
# CONFIG_MTD_BLOCK is not set
CONFIG_MTD_BLOCK_RO=m
# CONFIG_FTL is not set
CONFIG_NFTL=m
CONFIG_NFTL_RW=y
# CONFIG_INFTL is not set
CONFIG_RFD_FTL=m
CONFIG_SSFDC=m
CONFIG_SM_FTL=m
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
CONFIG_MTD_CFI_ADV_OPTIONS=y
CONFIG_MTD_CFI_NOSWAP=y
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_GEOMETRY is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_OTP is not set
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=m
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_PHYSMAP_OF=m
CONFIG_MTD_SC520CDP=m
# CONFIG_MTD_NETSC520 is not set
CONFIG_MTD_SCx200_DOCFLASH=m
CONFIG_MTD_AMD76XROM=m
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=m

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=m
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
CONFIG_MTD_DATAFLASH_OTP=y
# CONFIG_MTD_M25P80 is not set
# CONFIG_MTD_SST25L is not set
CONFIG_MTD_SLRAM=m
CONFIG_MTD_PHRAM=m
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=m
CONFIG_MTD_NAND_ECC_SMC=y
# CONFIG_MTD_NAND is not set
CONFIG_MTD_ONENAND=m
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=m
# CONFIG_MTD_ONENAND_OTP is not set
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
CONFIG_MTD_UBI_GLUEBI=m
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
# CONFIG_PROC_DEVICETREE is not set
CONFIG_OF_SELFTEST=y
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_ADDRESS_PCI=y
CONFIG_OF_IRQ=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
CONFIG_OF_MTD=y
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=m
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1780=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=y
CONFIG_VMWARE_BALLOON=y
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_BMP085_SPI is not set
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
CONFIG_C2PORT=m
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=m
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
CONFIG_EEPROM_93XX46=m
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_HAVE_IDE=y
CONFIG_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_IDE_LEGACY=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=m
# CONFIG_IDE_GD_ATA is not set
CONFIG_IDE_GD_ATAPI=y
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
CONFIG_BLK_DEV_PLATFORM=m
CONFIG_BLK_DEV_CMD640=m
CONFIG_BLK_DEV_CMD640_ENHANCED=y
# CONFIG_BLK_DEV_IDEPNP is not set

#
# PCI IDE chipsets support
#
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_CS5536 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
CONFIG_BLK_DEV_4DRIVES=m
CONFIG_BLK_DEV_ALI14XX=m
# CONFIG_BLK_DEV_DTC2278 is not set
CONFIG_BLK_DEV_HT6560B=m
CONFIG_BLK_DEV_QD65XX=m
# CONFIG_BLK_DEV_UMC8672 is not set
# CONFIG_BLK_DEV_IDEDMA is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=y
# CONFIG_SCSI_ENCLOSURE is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=m
# CONFIG_SCSI_SRP_TGT_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_ISCSI_BOOT_SYSFS=m
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
CONFIG_SCSI_7000FASST=m
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AHA152X=m
CONFIG_SCSI_AHA1542=m
CONFIG_SCSI_AHA1740=m
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_IN2000 is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPT3SAS is not set
CONFIG_SCSI_UFSHCD=m
# CONFIG_SCSI_UFSHCD_PCI is not set
CONFIG_SCSI_UFSHCD_PLATFORM=m
# CONFIG_SCSI_HPTIOP is not set
CONFIG_SCSI_BUSLOGIC=y
# CONFIG_SCSI_FLASHPOINT is not set
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_LIBFC=y
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
CONFIG_SCSI_DTC3280=m
CONFIG_SCSI_EATA=y
# CONFIG_SCSI_EATA_TAGGED_QUEUE is not set
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=y
CONFIG_SCSI_GDTH=y
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_GENERIC_NCR5380 is not set
# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_NCR53C406A=m
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_PAS16=m
CONFIG_SCSI_QLOGIC_FAS=m
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_SIM710=y
# CONFIG_SCSI_SYM53C416 is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_T128 is not set
CONFIG_SCSI_U14_34F=y
# CONFIG_SCSI_U14_34F_TAGGED_QUEUE is not set
CONFIG_SCSI_U14_34F_LINKED_COMMANDS=y
CONFIG_SCSI_U14_34F_MAX_TAGS=8
CONFIG_SCSI_ULTRASTOR=y
# CONFIG_SCSI_NSP32 is not set
CONFIG_SCSI_DEBUG=m
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
CONFIG_SCSI_DH_HP_SW=m
# CONFIG_SCSI_DH_EMC is not set
# CONFIG_SCSI_DH_ALUA is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BCACHE=m
# CONFIG_BCACHE_DEBUG is not set
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
# CONFIG_BLK_DEV_DM is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
# CONFIG_NETDEVICES is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=m
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_PS2_OLPC is not set
# CONFIG_MOUSE_SERIAL is not set
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
# CONFIG_MOUSE_CYAPA is not set
CONFIG_MOUSE_INPORT=m
CONFIG_MOUSE_ATIXL=y
# CONFIG_MOUSE_LOGIBM is not set
CONFIG_MOUSE_PC110PAD=m
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=y
CONFIG_MOUSE_SYNAPTICS_I2C=y
CONFIG_MOUSE_SYNAPTICS_USB=m
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=y
CONFIG_TABLET_USB_HANWANG=y
CONFIG_TABLET_USB_KBTAB=y
# CONFIG_TABLET_USB_WACOM is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM80X_ONKEY=m
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_BMA150=y
CONFIG_INPUT_PCSPKR=y
# CONFIG_INPUT_MAX8925_ONKEY is not set
# CONFIG_INPUT_MC13783_PWRBUTTON is not set
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_MPU3050=y
# CONFIG_INPUT_APANEL is not set
CONFIG_INPUT_GP2A=m
CONFIG_INPUT_GPIO_BEEPER=y
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
CONFIG_INPUT_WISTRON_BTNS=y
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=y
CONFIG_INPUT_KEYSPAN_REMOTE=y
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=y
CONFIG_INPUT_YEALINK=m
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_RETU_PWRBUTTON is not set
# CONFIG_INPUT_TWL6040_VIBRA is not set
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF50633_PMU=m
CONFIG_INPUT_PCF8574=m
CONFIG_INPUT_PWM_BEEPER=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
CONFIG_INPUT_DA9052_ONKEY=y
# CONFIG_INPUT_DA9055_ONKEY is not set
CONFIG_INPUT_WM831X_ON=m
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=y
CONFIG_INPUT_ADXL34X_SPI=m
CONFIG_INPUT_IMS_PCU=y
CONFIG_INPUT_CMA3000=m
CONFIG_INPUT_CMA3000_I2C=m
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
CONFIG_SERIO_APBPS2=y
CONFIG_SERIO_OLPC_APSP=m
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=m
CONFIG_CYCLADES=y
# CONFIG_CYZ_INTR is not set
# CONFIG_MOXA_INTELLIO is not set
CONFIG_MOXA_SMARTIO=y
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
CONFIG_N_HDLC=m
CONFIG_N_GSM=y
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_FOURPORT is not set
CONFIG_SERIAL_8250_ACCENT=m
# CONFIG_SERIAL_8250_BOCA is not set
CONFIG_SERIAL_8250_EXAR_ST16C554=y
CONFIG_SERIAL_8250_HUB6=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_OF_PLATFORM=m
CONFIG_SERIAL_SCCNXP=m
CONFIG_SERIAL_TIMBERDALE=m
CONFIG_SERIAL_ALTERA_JTAGUART=m
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
CONFIG_SERIAL_IFX6X60=m
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_XILINX_PS_UART=y
CONFIG_SERIAL_XILINX_PS_UART_CONSOLE=y
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=m
CONFIG_DTLK=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
CONFIG_MWAVE=y
CONFIG_SCx200_GPIO=y
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=m
CONFIG_TCG_TIS_I2C_ATMEL=m
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=m
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=m
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=m
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_ARB_GPIO_CHALLENGE=m
CONFIG_I2C_MUX_GPIO=y
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=m
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_KEMPLD is not set
CONFIG_I2C_OCORES=m
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_ROBOTFUZZ_OSIF=m
CONFIG_I2C_TAOS_EVM=m
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_ELEKTOR is not set
# CONFIG_I2C_PCA_ISA is not set
CONFIG_SCx200_I2C=y
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_BITBANG=y
CONFIG_SPI_GPIO=m
CONFIG_SPI_FSL_LIB=y
CONFIG_SPI_FSL_SPI=y
CONFIG_SPI_OC_TINY=m
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=m
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_XCOMM=y
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=m
CONFIG_SPI_TLE62X0=y
# CONFIG_SPMI is not set
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9052=m
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=m
CONFIG_GPIO_F7188X=m
CONFIG_GPIO_SCH311X=y
CONFIG_GPIO_TS5500=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set
CONFIG_GPIO_GRGPIO=m

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_LP3943=y
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=m
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_TC3589X is not set
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM831X=m
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set
CONFIG_GPIO_ADNP=m

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_SODAVILLE is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
# CONFIG_GPIO_MCP23S08 is not set
CONFIG_GPIO_MC33880=y
CONFIG_GPIO_74X164=y

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=y

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_BCM_KONA=y

#
# USB GPIO expanders:
#
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
# CONFIG_GENERIC_ADC_BATTERY is not set
CONFIG_MAX8925_POWER=y
# CONFIG_WM831X_BACKUP is not set
CONFIG_WM831X_POWER=m
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_OLPC=y
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9052=m
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=m
CONFIG_CHARGER_PCF50633=m
CONFIG_CHARGER_ISP1704=m
CONFIG_CHARGER_MAX8903=m
CONFIG_CHARGER_LP8727=m
CONFIG_CHARGER_LP8788=m
CONFIG_CHARGER_GPIO=m
# CONFIG_CHARGER_MAX14577 is not set
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_BQ24190=m
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_SMB347=y
CONFIG_POWER_RESET=y
CONFIG_POWER_RESET_AS3722=y
CONFIG_POWER_RESET_GPIO=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7310=m
CONFIG_SENSORS_ADT7410=m
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_MC13783_ADC=y
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_G762=m
CONFIG_SENSORS_GPIO_FAN=m
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IIO_HWMON=m
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LTC2945 is not set
CONFIG_SENSORS_LTC4151=m
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4222=y
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=m
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_HTU21 is not set
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=m
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=m
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=m
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=m
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_PC87360=m
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_NCT6775=m
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
# CONFIG_SENSORS_PMBUS is not set
# CONFIG_SENSORS_ADM1275 is not set
# CONFIG_SENSORS_LM25066 is not set
# CONFIG_SENSORS_LTC2978 is not set
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX34440 is not set
# CONFIG_SENSORS_MAX8688 is not set
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_SHT15=m
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS1015=m
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_ADS7871=m
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=m
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_WM831X is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_OF=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_CPU_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_ACPI_INT3403_THERMAL is not set

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DRIVER_GPIO is not set
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_AS3711=y
CONFIG_MFD_AS3722=y
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
CONFIG_MFD_CROS_EC_SPI=y
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=m
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=m
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_VIPERBOARD is not set
CONFIG_MFD_RETU=m
CONFIG_MFD_PCF50633=m
# CONFIG_PCF50633_ADC is not set
CONFIG_PCF50633_GPIO=m
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=m
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=m
CONFIG_MFD_LP3943=y
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=m
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=m
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_ARIZONA_SPI=m
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM8997 is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
CONFIG_REGULATOR_88PM800=y
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_ANATOP=y
# CONFIG_REGULATOR_AAT2870 is not set
# CONFIG_REGULATOR_AS3711 is not set
CONFIG_REGULATOR_AS3722=m
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9210=m
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_GPIO is not set
# CONFIG_REGULATOR_ISL6271A is not set
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
# CONFIG_REGULATOR_MAX14577 is not set
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=m
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8907=m
# CONFIG_REGULATOR_MAX8925 is not set
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=m
# CONFIG_REGULATOR_MAX8998 is not set
# CONFIG_REGULATOR_MAX77686 is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
# CONFIG_REGULATOR_MC13892 is not set
# CONFIG_REGULATOR_PCF50633 is not set
# CONFIG_REGULATOR_PFUZE100 is not set
CONFIG_REGULATOR_S2MPS11=m
CONFIG_REGULATOR_S5M8767=m
CONFIG_REGULATOR_TPS51632=m
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65217=m
# CONFIG_REGULATOR_TPS6524X is not set
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8400=m
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=y
# CONFIG_VIDEO_V4L2_SUBDEV_API is not set
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_DVB_CORE=y
CONFIG_DVB_NET=y
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_MEDIA_PARPORT_SUPPORT is not set
# CONFIG_RADIO_ADAPTERS is not set
# CONFIG_CYPRESS_FIRMWARE is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
CONFIG_MEDIA_ATTACH=y

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=y
CONFIG_VIDEO_TDA7432=y
# CONFIG_VIDEO_TDA9840 is not set
CONFIG_VIDEO_TEA6415C=m
CONFIG_VIDEO_TEA6420=m
# CONFIG_VIDEO_MSP3400 is not set
# CONFIG_VIDEO_CS5345 is not set
# CONFIG_VIDEO_CS53L32A is not set
CONFIG_VIDEO_TLV320AIC23B=m
CONFIG_VIDEO_UDA1342=y
CONFIG_VIDEO_WM8775=y
CONFIG_VIDEO_WM8739=m
# CONFIG_VIDEO_VP27SMPX is not set
CONFIG_VIDEO_SONY_BTF_MPX=m

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set

#
# Video decoders
#
# CONFIG_VIDEO_ADV7180 is not set
CONFIG_VIDEO_ADV7183=m
# CONFIG_VIDEO_BT819 is not set
CONFIG_VIDEO_BT856=y
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_KS0127 is not set
CONFIG_VIDEO_ML86V7667=y
# CONFIG_VIDEO_SAA7110 is not set
# CONFIG_VIDEO_SAA711X is not set
CONFIG_VIDEO_SAA7191=y
CONFIG_VIDEO_TVP514X=m
CONFIG_VIDEO_TVP5150=y
CONFIG_VIDEO_TVP7002=m
# CONFIG_VIDEO_TW2804 is not set
# CONFIG_VIDEO_TW9903 is not set
# CONFIG_VIDEO_TW9906 is not set
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=y
# CONFIG_VIDEO_CX25840 is not set

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m
# CONFIG_VIDEO_SAA7185 is not set
# CONFIG_VIDEO_ADV7170 is not set
CONFIG_VIDEO_ADV7175=y
CONFIG_VIDEO_ADV7343=m
CONFIG_VIDEO_ADV7393=m
CONFIG_VIDEO_AK881X=m
# CONFIG_VIDEO_THS8200 is not set

#
# Camera sensor devices
#
CONFIG_VIDEO_OV7640=m
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_VS6624=y
# CONFIG_VIDEO_MT9V011 is not set
CONFIG_VIDEO_SR030PC30=m

#
# Flash devices
#
CONFIG_VIDEO_ADP1653=y
# CONFIG_VIDEO_AS3645A is not set
CONFIG_VIDEO_LM3560=m

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
CONFIG_VIDEO_UPD64083=y

#
# Audio/Video compression chips
#
# CONFIG_VIDEO_SAA6752HS is not set

#
# Miscellaneous helper chips
#
# CONFIG_VIDEO_THS7303 is not set
# CONFIG_VIDEO_M52790 is not set

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
# CONFIG_MEDIA_TUNER_SIMPLE is not set
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=m
# CONFIG_MEDIA_TUNER_TDA9887 is not set
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
# CONFIG_MEDIA_TUNER_MT20XX is not set
CONFIG_MEDIA_TUNER_MT2060=y
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT2266=m
# CONFIG_MEDIA_TUNER_MT2131 is not set
# CONFIG_MEDIA_TUNER_QT1010 is not set
# CONFIG_MEDIA_TUNER_XC2028 is not set
# CONFIG_MEDIA_TUNER_XC5000 is not set
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=y
# CONFIG_MEDIA_TUNER_MC44S803 is not set
CONFIG_MEDIA_TUNER_MAX2165=m
# CONFIG_MEDIA_TUNER_TDA18218 is not set
CONFIG_MEDIA_TUNER_FC0011=m
CONFIG_MEDIA_TUNER_FC0012=y
CONFIG_MEDIA_TUNER_FC0013=y
CONFIG_MEDIA_TUNER_TDA18212=y
CONFIG_MEDIA_TUNER_E4000=m
CONFIG_MEDIA_TUNER_FC2580=y
# CONFIG_MEDIA_TUNER_M88TS2022 is not set
# CONFIG_MEDIA_TUNER_TUA9001 is not set
CONFIG_MEDIA_TUNER_IT913X=m
CONFIG_MEDIA_TUNER_R820T=m

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
# CONFIG_DVB_STB0899 is not set
# CONFIG_DVB_STB6100 is not set
CONFIG_DVB_STV090x=y
# CONFIG_DVB_STV6110x is not set
CONFIG_DVB_M88DS3103=y

#
# Multistandard (cable + terrestrial) frontends
#
# CONFIG_DVB_DRXK is not set
# CONFIG_DVB_TDA18271C2DD is not set

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=y
# CONFIG_DVB_MT312 is not set
CONFIG_DVB_ZL10036=y
CONFIG_DVB_ZL10039=y
# CONFIG_DVB_S5H1420 is not set
# CONFIG_DVB_STV0288 is not set
CONFIG_DVB_STB6000=y
# CONFIG_DVB_STV0299 is not set
CONFIG_DVB_STV6110=y
CONFIG_DVB_STV0900=m
CONFIG_DVB_TDA8083=y
# CONFIG_DVB_TDA10086 is not set
# CONFIG_DVB_TDA8261 is not set
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
# CONFIG_DVB_TUNER_CX24113 is not set
# CONFIG_DVB_TDA826X is not set
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_CX24117=y
CONFIG_DVB_SI21XX=y
# CONFIG_DVB_TS2020 is not set
CONFIG_DVB_DS3000=m
CONFIG_DVB_MB86A16=m
# CONFIG_DVB_TDA10071 is not set

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=y
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_S5H1432=y
CONFIG_DVB_DRXD=y
# CONFIG_DVB_L64781 is not set
# CONFIG_DVB_TDA1004X is not set
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=y
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_DIB9000=m
CONFIG_DVB_TDA10048=y
CONFIG_DVB_AF9013=y
# CONFIG_DVB_EC100 is not set
CONFIG_DVB_HD29L2=m
# CONFIG_DVB_STV0367 is not set
CONFIG_DVB_CXD2820R=y
CONFIG_DVB_RTL2830=y
CONFIG_DVB_RTL2832=y

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=y
# CONFIG_DVB_TDA10021 is not set
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=y
# CONFIG_DVB_OR51211 is not set
CONFIG_DVB_OR51132=y
# CONFIG_DVB_BCM3510 is not set
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
# CONFIG_DVB_LG2160 is not set
# CONFIG_DVB_S5H1409 is not set
# CONFIG_DVB_AU8522_DTV is not set
# CONFIG_DVB_AU8522_V4L is not set
# CONFIG_DVB_S5H1411 is not set

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=y
# CONFIG_DVB_DIB8000 is not set
CONFIG_DVB_MB86A20S=y

#
# Digital terrestrial only tuners/PLL
#
# CONFIG_DVB_PLL is not set
CONFIG_DVB_TUNER_DIB0070=y
CONFIG_DVB_TUNER_DIB0090=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=m
CONFIG_DVB_LNBP22=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
# CONFIG_DVB_ISL6423 is not set
CONFIG_DVB_A8293=m
CONFIG_DVB_LGS8GL5=m
CONFIG_DVB_LGS8GXX=y
# CONFIG_DVB_ATBM8830 is not set
CONFIG_DVB_TDA665x=y
# CONFIG_DVB_IX2505V is not set
CONFIG_DVB_IT913X_FE=y
CONFIG_DVB_M88RS2000=m
CONFIG_DVB_AF9033=m

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_HDMI=y
CONFIG_FB=m
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=m
CONFIG_FB_N411=m
# CONFIG_FB_HGA is not set
CONFIG_FB_OPENCORES=m
CONFIG_FB_S1D13XXX=m
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_SM501=m
CONFIG_FB_SMSCUFX=m
CONFIG_FB_UDL=m
CONFIG_FB_GOLDFISH=m
CONFIG_FB_VIRTUAL=m
CONFIG_FB_METRONOME=m
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=m
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
# CONFIG_MDA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=m
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_LOGO is not set
CONFIG_FB_SSD1307=m
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=m
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=m
# CONFIG_HID_APPLEIR is not set
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
# CONFIG_HID_CP2112 is not set
CONFIG_HID_CYPRESS=m
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=m
CONFIG_HID_ELECOM=m
CONFIG_HID_ELO=m
CONFIG_HID_EZKEY=m
CONFIG_HID_HOLTEK=m
# CONFIG_HOLTEK_FF is not set
CONFIG_HID_HUION=m
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
CONFIG_HID_LENOVO_TPKBD=m
CONFIG_HID_LOGITECH=m
# CONFIG_HID_LOGITECH_DJ is not set
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_NTRIG=m
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=m
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PRIMAX=m
CONFIG_HID_ROCCAT=m
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
# CONFIG_HID_SONY is not set
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=m
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=m
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=m
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_HID_SENSOR_HUB=m

#
# USB HID support
#
CONFIG_USB_HID=m
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB_CBAF=m
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
# CONFIG_USB_XHCI_HCD is not set
# CONFIG_USB_EHCI_HCD is not set
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=m
CONFIG_USB_ISP1362_HCD=m
CONFIG_USB_FUSBH200_HCD=y
CONFIG_USB_FOTG210_HCD=y
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_U132_HCD=m
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=m
CONFIG_USB_HCD_BCMA=m
CONFIG_USB_HCD_SSB=y
CONFIG_USB_HCD_TEST_MODE=y

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=y
CONFIG_REALTEK_AUTOPM=y
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_USBAT=y
# CONFIG_USB_STORAGE_SDDR09 is not set
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
# CONFIG_USB_MICROTEK is not set
CONFIG_USB_MUSB_HDRC=y
CONFIG_USB_MUSB_HOST=y
CONFIG_USB_MUSB_TUSB6010=m
CONFIG_USB_MUSB_DSPS=m
CONFIG_USB_MUSB_UX500=m
CONFIG_USB_MUSB_AM335X_CHILD=m
CONFIG_USB_UX500_DMA=y
# CONFIG_MUSB_PIO_ONLY is not set
# CONFIG_USB_DWC3 is not set
CONFIG_USB_DWC2=y
# CONFIG_USB_DWC2_DEBUG is not set
CONFIG_USB_DWC2_TRACK_MISSED_SOFS=y

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=y
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=m
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_SISUSBVGA=y
# CONFIG_USB_SISUSBVGA_CON is not set
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
CONFIG_USB_EHSET_TEST_FIXTURE=y
CONFIG_USB_ISIGHTFW=m
CONFIG_USB_YUREX=y
# CONFIG_USB_EZUSB_FX2 is not set
CONFIG_USB_HSIC_USB3503=m
CONFIG_USB_ATM=y
CONFIG_USB_SPEEDTOUCH=y
CONFIG_USB_CXACRU=y
CONFIG_USB_UEAGLEATM=y
CONFIG_USB_XUSBATM=y

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
# CONFIG_USB_OTG_FSM is not set
CONFIG_NOP_USB_XCEIV=y
CONFIG_SAMSUNG_USBPHY=y
# CONFIG_SAMSUNG_USB2PHY is not set
CONFIG_SAMSUNG_USB3PHY=y
# CONFIG_USB_GPIO_VBUS is not set
CONFIG_USB_ISP1301=m
CONFIG_USB_RCAR_PHY=y
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=m
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=m
CONFIG_MS_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_NET48XX is not set
# CONFIG_LEDS_WRAP is not set
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_PCA9532_GPIO=y
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=m
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_LP8788=m
CONFIG_LEDS_CLEVO_MAIL=m
CONFIG_LEDS_PCA955X=m
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_PCA9685=y
CONFIG_LEDS_WM831X_STATUS=m
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_DAC124S085=y
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_REGULATOR=m
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=m
CONFIG_LEDS_LM355x=m
CONFIG_LEDS_OT200=m
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set
# CONFIG_VIRT_DRIVERS is not set

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_LAPTOP=y
CONFIG_CHROMEOS_PSTORE=m

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_OF_IOMMU=y

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
CONFIG_BMA180=m
# CONFIG_HID_SENSOR_ACCEL_3D is not set
CONFIG_IIO_ST_ACCEL_3AXIS=m
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=m
CONFIG_IIO_ST_ACCEL_SPI_3AXIS=m
CONFIG_KXSD9=m

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=m
CONFIG_AD7266=m
CONFIG_AD7298=m
# CONFIG_AD7476 is not set
CONFIG_AD7791=m
# CONFIG_AD7793 is not set
# CONFIG_AD7887 is not set
# CONFIG_AD7923 is not set
CONFIG_EXYNOS_ADC=y
CONFIG_LP8788_ADC=y
# CONFIG_MAX1363 is not set
# CONFIG_MCP320X is not set
# CONFIG_MCP3422 is not set
# CONFIG_NAU7802 is not set
CONFIG_TI_ADC081C=m
CONFIG_TI_AM335X_ADC=m
CONFIG_VF610_ADC=m

#
# Amplifiers
#
CONFIG_AD8366=m

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_SPI=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Digital to analog converters
#
CONFIG_AD5064=m
CONFIG_AD5360=m
CONFIG_AD5380=m
# CONFIG_AD5421 is not set
CONFIG_AD5446=m
CONFIG_AD5449=m
# CONFIG_AD5504 is not set
# CONFIG_AD5624R_SPI is not set
CONFIG_AD5686=m
CONFIG_AD5755=m
# CONFIG_AD5764 is not set
CONFIG_AD5791=m
CONFIG_AD7303=m
CONFIG_MAX517=m
# CONFIG_MCP4725 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
# CONFIG_AD9523 is not set

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=m

#
# Digital gyroscope sensors
#
CONFIG_ADIS16080=m
CONFIG_ADIS16130=m
CONFIG_ADIS16136=m
# CONFIG_ADIS16260 is not set
CONFIG_ADXRS450=m
CONFIG_HID_SENSOR_GYRO_3D=m
# CONFIG_IIO_ST_GYRO_3AXIS is not set
CONFIG_ITG3200=m

#
# Humidity sensors
#
# CONFIG_DHT11 is not set
# CONFIG_SI7005 is not set

#
# Inertial measurement units
#
CONFIG_ADIS16400=m
CONFIG_ADIS16480=m
CONFIG_INV_MPU6050_IIO=m
CONFIG_IIO_ADIS_LIB=m
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
CONFIG_APDS9300=m
CONFIG_CM32181=m
# CONFIG_CM36651 is not set
CONFIG_GP2AP020A00F=m
CONFIG_HID_SENSOR_ALS=m
# CONFIG_HID_SENSOR_PROX is not set
# CONFIG_SENSORS_LM3533 is not set
CONFIG_LTR501=m
CONFIG_TCS3472=m
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_TSL4531 is not set
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
# CONFIG_MAG3110 is not set
CONFIG_HID_SENSOR_MAGNETOMETER_3D=m
CONFIG_IIO_ST_MAGN_3AXIS=m
CONFIG_IIO_ST_MAGN_I2C_3AXIS=m
CONFIG_IIO_ST_MAGN_SPI_3AXIS=m

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=m

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=m
CONFIG_IIO_SYSFS_TRIGGER=m

#
# Pressure sensors
#
# CONFIG_HID_SENSOR_PRESS is not set
CONFIG_MPL3115=m
CONFIG_IIO_ST_PRESS=m
CONFIG_IIO_ST_PRESS_I2C=m
CONFIG_IIO_ST_PRESS_SPI=m

#
# Temperature sensors
#
# CONFIG_TMP006 is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_LP3943=m
# CONFIG_PWM_PCA9685 is not set
CONFIG_IRQCHIP=y
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=y
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=m
CONFIG_FMC_FAKEDEV=m
CONFIG_FMC_TRIVIAL=m
# CONFIG_FMC_WRITE_EEPROM is not set
# CONFIG_FMC_CHARDEV is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_EXYNOS_MIPI_VIDEO=y
CONFIG_PHY_EXYNOS_DP_VIDEO=y
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=m

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=m
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=m
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
# CONFIG_EXT3_FS_SECURITY is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
# CONFIG_XFS_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
# CONFIG_QFMT_V1 is not set
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
CONFIG_FSCACHE_DEBUG=y
# CONFIG_FSCACHE_OBJECT_LIST is not set
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=m
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=m
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=m
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=m
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=m

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=m
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
# CONFIG_BRANCH_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_KPROBE_EVENT=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=m
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_ASYNC_RAID6_TEST=m
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_TEST_MODULE is not set
CONFIG_TEST_USER_COPY=m
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_TRUSTED_KEYS=m
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_CRCT10DIF=m
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=m
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=m
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=m
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=m
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=m
# CONFIG_CRYPTO_HW is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_PERCPU_RWSEM=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=m
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
# CONFIG_CRC64_ECMA is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_FONT_SUPPORT=m
CONFIG_FONTS=y
# CONFIG_FONT_8x8 is not set
CONFIG_FONT_8x16=y
CONFIG_FONT_6x11=y
CONFIG_FONT_7x14=y
# CONFIG_FONT_PEARL_8x8 is not set
CONFIG_FONT_ACORN_8x8=y
# CONFIG_FONT_MINI_4x6 is not set
# CONFIG_FONT_SUN8x16 is not set
# CONFIG_FONT_SUN12x22 is not set
# CONFIG_FONT_10x18 is not set

--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--IJpNTDwzlM2Ie8A6--
