From: Fengguang Wu <fengguang.wu@intel.com>
Subject: [cgroup/task_lock] INFO: suspicious RCU usage.
Date: Fri, 21 Feb 2014 10:16:22 +0800
Message-ID: <20140221021622.GB13515@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="sdtB3X0nJg68CQEu"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-migration-update-v2

commit fb47fea7a59cf3d6387c566084a6684b5005af83
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Thu Feb 13 15:16:35 2014 -0500
Commit:     Tejun Heo <tj@kernel.org>
CommitDate: Thu Feb 13 15:16:35 2014 -0500

    cgroup: drop task_lock() protection around task->cgroups
    
    For optimization, task_lock() is additionally used to protect
    task->cgroups.  The optimization is pretty dubious as either
    css_set_rwsem is grabbed anyway or PF_EXITING already protects
    task->cgroups.  It adds only overhead and confusion at this point.
    Let's drop task_[un]lock() and update comments accordingly.
    
    Signed-off-by: Tejun Heo <tj@kernel.org>

[main] Setsockopt(1 2b 80d1000 4) on fd 223 [17:2:768]
[   27.030764] 
[   27.031119] ===============================
[   27.031833] [ INFO: suspicious RCU usage. ]
[   27.032536] 3.14.0-rc3-02458-g837caba #2 Not tainted
[   27.033378] -------------------------------
[   27.044237] include/linux/cgroup.h:697 suspicious rcu_dereference_check() usage!
[   27.045795] 
[   27.045795] other info that might help us debug this:
[   27.045795] 
[   27.047114] 
[   27.047114] rcu_scheduler_active = 1, debug_locks = 0
[main] Setsockopt(1 c 80d1000 4) on fd 225 [39:5:0]
[   27.048751] 2 locks held by trinity-c0/4479:
[   27.049478]  #0:  (callback_mutex){+.+...}, at: [<81118395>] cpuset_cpus_allowed+0x1e/0x123
[   27.051132]  #1:  (&(&p->alloc_lock)->rlock){+.+...}, at: [<8111839c>] cpuset_cpus_allowed+0x25/0x123
[   27.052788] 
[   27.052788] stack backtrace:
[   27.053528] CPU: 0 PID: 4479 Comm: trinity-c0 Not tainted 3.14.0-rc3-02458-g837caba #2
[   27.064971]  00000000 00000000
 919eff28 81877cc3[main] Setsockopt(1 7 80d1000 4) on fd 226 [1:5:1]

git bisect start 837caba6587ab563ef3779429ddc9f49adb6b6fc 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2 --
git bisect good a2769d08037fdbb3533d916a65e64d55e027e99c  # 06:00     20+      0  Merge 'sparc/master' into devel-hourly-2014022015
git bisect good 1b2a1643a39d52dfd8cea79be9202bfe00852166  # 06:07     20+      1  Merge 'arm-tegra/for-next' into devel-hourly-2014022015
git bisect good 3e8c6ac2fc26d1976164ef0ed588ddf319ea1ae4  # 06:14     20+      5  Merge 'shawnguo/imx6/dt' into devel-hourly-2014022015
git bisect good c8a798fbd56e7dec9cea66a55c9644d1cee51cce  # 06:19     20+      2  Merge 'nmenon/push/voltdm-notifier-v1' into devel-hourly-2014022015
git bisect  bad d753bad21612f2e1ee7e7fa16753aac483f8036f  # 06:25      0-      4  Merge 'cgroup/review-migration-update-v2' into devel-hourly-2014022015
git bisect good 80b13586997d8e584caa772bd99e2a3e55ac6abe  # 06:35     20+      3  cgroup: relocate cgroup_rm_cftypes()
git bisect good 889ed9ceaa97bb02bf5d7349e24639f7fc5f4fa0  # 06:49     20+      2  cgroup: remove css_scan_tasks()
git bisect good 49ef68ad82efeb60f283ef56527ab8969c7e927b  # 07:05     20+      3  cgroup: update cgroup_enable_task_cg_lists() to grab siglock
git bisect good fb6efb01d880e9dcbd19861abd28f55bf061116d  # 07:20     20+      2  cgroup: split process / task migration into four steps
git bisect  bad fb47fea7a59cf3d6387c566084a6684b5005af83  # 07:23      0-     15  cgroup: drop task_lock() protection around task->cgroups
git bisect good d536dafdfb3fe88b2c9e35284ca62d4739589f87  # 07:37     20+      2  cgroup: update how a newly forked task gets associated with css_set
# first bad commit: [fb47fea7a59cf3d6387c566084a6684b5005af83] cgroup: drop task_lock() protection around task->cgroups
git bisect good d536dafdfb3fe88b2c9e35284ca62d4739589f87  # 07:48     60+     16  cgroup: update how a newly forked task gets associated with css_set
git bisect  bad 837caba6587ab563ef3779429ddc9f49adb6b6fc  # 07:49      0-     19  0day head guard for 'devel-hourly-2014022015'
git bisect good 373f7d6eec9fc4ac34f1cca58430d038e0cab88a  # 08:02     60+     11  Revert "cgroup: drop task_lock() protection around task->cgroups"
git bisect good d158fc7f36a25e19791d25a55da5623399a2644f  # 08:16     60+      5  Merge tag 'pci-v3.14-fixes-1' of git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci
git bisect good 12f1d94f0c8b256c04cb9b6b5dd989c32e44f11b  # 08:32     60+     17  Add linux-next specific files for 20140220

Thanks,
Fengguang

--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-bens-4:20140220161732:i386-randconfig-c5-02201550:3.14.0-rc3-02458-g837caba:2"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... No relocation needed... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 3.14.0-rc3-02458-g837caba (kbuild@cairo) (gcc =
version 4.8.1 (Debian 4.8.1-8) ) #2 SMP PREEMPT Thu Feb 20 16:14:03 CST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[800fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x02ffffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x027ea000, 0x027eafff] PGTABLE
[    0.000000] BRK [0x027eb000, 0x027edfff] PGTABLE
[    0.000000] BRK [0x027ee000, 0x027eefff] PGTABLE
[    0.000000] BRK [0x027ef000, 0x027effff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] ACPI: RSDP 0x000FD930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x13FFFF40 000040
[    0.000000] ACPI: SSDT 0x13FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13ffdfff]
[    0.000000]   NODE_DATA [mem 0x13ffc000-0x13ffdfff]
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000] max_low_pfn =3D 13ffe, highstart_pfn =3D 13ffe
[    0.000000] Low memory ends at vaddr 93ffe000
[    0.000000] High memory starts at vaddr 93ffe000
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffb001, boot clock
[    0.000000] Node: 0, start_pfn: 1, end_pfn: 9f
[    0.000000]   Setting physnode_map array to node 0 for pfns:
[    0.000000]   0=20
[    0.000000] Node: 0, start_pfn: 100, end_pfn: 13ffe
[    0.000000]   Setting physnode_map array to node 0 for pfns:
[    0.000000]   0 4000 8000 c000 10000=20
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat 93ffc000, node_mem_map 93=
99d028
[    0.000000]   DMA zone: 40 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 760 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 333 pages/cpu @93703000 s1343104 r0 d20864 =
u1363968
[    0.000000] pcpu-alloc: s1343104 r0 d20864 u1363968 alloc=3D333*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:13ffb001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 137057c0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81020
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-c5-02201550/linux-devel:devel-hourly-2014022015/.vmlinuz=
-837caba6587ab563ef3779429ddc9f49adb6b6fc-20140220161431-7-bens branch=3Dli=
nux-devel/devel-hourly-2014022015 BOOT_IMAGE=3D/kernel/i386-randconfig-c5-0=
2201550/837caba6587ab563ef3779429ddc9f49adb6b6fc/vmlinuz-3.14.0-rc3-02458-g=
837caba
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 655336 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 292472K/327280K available (8743K kernel code, 2730K =
rwdata, 4544K rodata, 1932K init, 6412K bss, 34808K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffa95000 - 0xfffff000   (5544 kB)
[    0.000000]     pkmap   : 0xff600000 - 0xff800000   (2048 kB)
[    0.000000]     vmalloc : 0x947fe000 - 0xff5fe000   (1710 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x93ffe000   ( 319 MB)
[    0.000000]       .init : 0x81fa6000 - 0x82189000   (1932 kB)
[    0.000000]       .data : 0x81889fc7 - 0x81fa5b00   (7278 kB)
[    0.000000]       .text : 0x81000000 - 0x81889fc7   (8743 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D2, =
Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3D93008000 soft=3D9300a000
[    0.000000] ACPI: Core revision 20140114
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 3.14.0-rc3-02458-g837caba (kbuild@cairo) (gcc =
version 4.8.1 (Debian 4.8.1-8) ) #2 SMP PREEMPT Thu Feb 20 16:14:03 CST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[800fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x02ffffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x027ea000, 0x027eafff] PGTABLE
[    0.000000] BRK [0x027eb000, 0x027edfff] PGTABLE
[    0.000000] BRK [0x027ee000, 0x027eefff] PGTABLE
[    0.000000] BRK [0x027ef000, 0x027effff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] ACPI: RSDP 0x000FD930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x13FFFF40 000040
[    0.000000] ACPI: SSDT 0x13FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13ffdfff]
[    0.000000]   NODE_DATA [mem 0x13ffc000-0x13ffdfff]
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000] max_low_pfn =3D 13ffe, highstart_pfn =3D 13ffe
[    0.000000] Low memory ends at vaddr 93ffe000
[    0.000000] High memory starts at vaddr 93ffe000
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffb001, boot clock
[    0.000000] Node: 0, start_pfn: 1, end_pfn: 9f
[    0.000000]   Setting physnode_map array to node 0 for pfns:
[    0.000000]   0=20
[    0.000000] Node: 0, start_pfn: 100, end_pfn: 13ffe
[    0.000000]   Setting physnode_map array to node 0 for pfns:
[    0.000000]   0 4000 8000 c000 10000=20
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat 93ffc000, node_mem_map 93=
99d028
[    0.000000]   DMA zone: 40 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 760 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 333 pages/cpu @93703000 s1343104 r0 d20864 =
u1363968
[    0.000000] pcpu-alloc: s1343104 r0 d20864 u1363968 alloc=3D333*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:13ffb001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 137057c0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81020
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-c5-02201550/linux-devel:devel-hourly-2014022015/.vmlinuz=
-837caba6587ab563ef3779429ddc9f49adb6b6fc-20140220161431-7-bens branch=3Dli=
nux-devel/devel-hourly-2014022015 BOOT_IMAGE=3D/kernel/i386-randconfig-c5-0=
2201550/837caba6587ab563ef3779429ddc9f49adb6b6fc/vmlinuz-3.14.0-rc3-02458-g=
837caba
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 655336 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 292472K/327280K available (8743K kernel code, 2730K =
rwdata, 4544K rodata, 1932K init, 6412K bss, 34808K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffa95000 - 0xfffff000   (5544 kB)
[    0.000000]     pkmap   : 0xff600000 - 0xff800000   (2048 kB)
[    0.000000]     vmalloc : 0x947fe000 - 0xff5fe000   (1710 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x93ffe000   ( 319 MB)
[    0.000000]       .init : 0x81fa6000 - 0x82189000   (1932 kB)
[    0.000000]       .data : 0x81889fc7 - 0x81fa5b00   (7278 kB)
[    0.000000]       .text : 0x81000000 - 0x81889fc7   (8743 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D2, =
Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3D93008000 soft=3D9300a000
[    0.000000] ACPI: Core revision 20140114
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ------------------------
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  A-B-B-A deadlock:
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-B-C-C-A deadlock:
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-C-A-B-C deadlock:
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-B-C-C-D-D-A deadlock:
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-D-D-A deadlock:
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-C-D-A deadlock:
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                     double unlock:
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                   initialize held:
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  bad unlock order:
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:
[    0.000000]               recursive read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]            recursive read-lock #2:
[    0.000000]            recursive read-lock #2:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed read-write-lock:
[    0.000000]             mixed read-write-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed write-read-lock:
[    0.000000]             mixed write-read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/12:
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      hard-irqs-on + irq-safe-A/21:
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/21:
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/12:
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/21:
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/12:
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/12:
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/21:
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/21:
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/123:
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/123:
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/132:
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/132:
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/213:
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/213:
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/231:
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/231:
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/312:
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/312:
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/321:
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/321:
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/123:
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/123:
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/132:
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/132:
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/213:
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/213:
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/231:
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/231:
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/312:
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/312:
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/321:
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/321:
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/123:
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/123:
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/132:
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/132:
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/213:
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/213:
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/231:
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/231:
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/312:
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/312:
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/321:
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/321:
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/123:
[    0.000000]       hard-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/123:
[    0.000000]       soft-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/132:
[    0.000000]       hard-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/132:
[    0.000000]       soft-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/213:
[    0.000000]       hard-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/213:
[    0.000000]       soft-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/231:
[    0.000000]       hard-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/231:
[    0.000000]       soft-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/312:
[    0.000000]       hard-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/312:
[    0.000000]       soft-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/321:
[    0.000000]       hard-irq read-recursion/321:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/321:
[    0.000000]       soft-irq read-recursion/321:  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                ww contexts mixing:
[    0.000000]                ww contexts mixing:  ok  |  ok  |  ok  |  ok =
 |

[    0.000000]              finishing ww context:
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                locking mismatches:
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                  EDEADLK handling:
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]            spinlock nest unlocked:
[    0.000000]            spinlock nest unlocked:  ok  |  ok  |

[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:
[    0.000000]                           context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                               try:
[    0.000000]                               try:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                             block:
[    0.000000]                             block:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                          spinlock:
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000] -------------------------------------------------------
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ---------------------------------
[    0.000000] ODEBUG: 12 of 12 active objects replaced
[    0.000000] ODEBUG: 12 of 12 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2666.476 MHz processor
[    0.000000] tsc: Detected 2666.476 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value..=20
[    0.020000] Calibrating delay loop (skipped) preset value.. 5332.95 Bogo=
MIPS (lpj=3D26664760)
5332.95 BogoMIPS (lpj=3D26664760)
[    0.021902] pid_max: default: 32768 minimum: 301
[    0.021902] pid_max: default: 32768 minimum: 301
[    0.023848] Security Framework initialized
[    0.023848] Security Framework initialized
[    0.030214] Mount-cache hash table entries: 512
[    0.030214] Mount-cache hash table entries: 512
[    0.033757] Initializing cgroup subsys debug
[    0.033757] Initializing cgroup subsys debug
[    0.035368] Initializing cgroup subsys memory
[    0.035368] Initializing cgroup subsys memory
[    0.036890] Initializing cgroup subsys net_cls
[    0.036890] Initializing cgroup subsys net_cls
[    0.038666] mce: CPU supports 10 MCE banks
[    0.038666] mce: CPU supports 10 MCE banks
[    0.050043] numa_add_cpu cpu 0 node 0: mask now 0
[    0.050043] numa_add_cpu cpu 0 node 0: mask now 0
[    0.051744] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.051744] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.051744] tlb_flushall_shift: 6
[    0.051744] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.051744] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.051744] tlb_flushall_shift: 6
[    0.061151] Freeing SMP alternatives memory: 24K (82189000 - 8218f000)
[    0.061151] Freeing SMP alternatives memory: 24K (82189000 - 8218f000)
[    0.090925] Getting VERSION: 50014
[    0.090925] Getting VERSION: 50014
[    0.092142] Getting VERSION: 50014
[    0.092142] Getting VERSION: 50014
[    0.093295] Getting ID: 0
[    0.093295] Getting ID: 0
[    0.094200] Getting ID: f000000
[    0.094200] Getting ID: f000000
[    0.100081] Getting LVT0: 8700
[    0.100081] Getting LVT0: 8700
[    0.110053] Getting LVT1: 8400
[    0.110053] Getting LVT1: 8400
[    0.111116] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.111116] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.113204] enabled ExtINT on CPU#0
[    0.113204] enabled ExtINT on CPU#0
[    0.121671] ENABLING IO-APIC IRQs
[    0.121671] ENABLING IO-APIC IRQs
[    0.122832] init IO_APIC IRQs
[    0.122832] init IO_APIC IRQs
[    0.123848]  apic 0 pin 0 not connected
[    0.123848]  apic 0 pin 0 not connected
[    0.130125] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.130125] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.140086] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.140086] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.142780] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.142780] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.150094] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.150094] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.152774] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.152774] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.160059] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.160059] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.164923] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.164923] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.170105] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.170105] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.172793] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.172793] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.180108] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.180108] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.182827] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.182827] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.190098] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.190098] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.192825] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.192825] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.200107] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.200107] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.210064] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.210064] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.212768]  apic 0 pin 16 not connected
[    0.212768]  apic 0 pin 16 not connected
[    0.214064]  apic 0 pin 17 not connected
[    0.214064]  apic 0 pin 17 not connected
[    0.217620]  apic 0 pin 18 not connected
[    0.217620]  apic 0 pin 18 not connected
[    0.218932]  apic 0 pin 19 not connected
[    0.218932]  apic 0 pin 19 not connected
[    0.220040]  apic 0 pin 20 not connected
[    0.220040]  apic 0 pin 20 not connected
[    0.221356]  apic 0 pin 21 not connected
[    0.221356]  apic 0 pin 21 not connected
[    0.222641]  apic 0 pin 22 not connected
[    0.222641]  apic 0 pin 22 not connected
[    0.230037]  apic 0 pin 23 not connected
[    0.230037]  apic 0 pin 23 not connected
[    0.231554] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.231554] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.233923] smpboot: CPU0:=20
[    0.233923] smpboot: CPU0: Intel Intel Common KVM processorCommon KVM pr=
ocessor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.242999] Using local APIC timer interrupts.
[    0.242999] calibrating APIC timer ...
[    0.242999] Using local APIC timer interrupts.
[    0.242999] calibrating APIC timer ...
[    0.260000] ... lapic delta =3D 6875748
[    0.260000] ... lapic delta =3D 6875748
[    0.260000] ... PM-Timer delta =3D 393820
[    0.260000] ... PM-Timer delta =3D 393820
[    0.260000] APIC calibration not consistent with PM-Timer: 110ms instead=
 of 100ms
[    0.260000] APIC calibration not consistent with PM-Timer: 110ms instead=
 of 100ms
[    0.260000] APIC delta adjusted to PM-Timer: 6249559 (6875748)
[    0.260000] APIC delta adjusted to PM-Timer: 6249559 (6875748)
[    0.260000] TSC delta adjusted to PM-Timer: 266659300 (293377824)
[    0.260000] TSC delta adjusted to PM-Timer: 266659300 (293377824)
[    0.260000] ..... delta 6249559
[    0.260000] ..... delta 6249559
[    0.260000] ..... mult: 268416515
[    0.260000] ..... mult: 268416515
[    0.260000] ..... calibration result: 9999294
[    0.260000] ..... calibration result: 9999294
[    0.260000] ..... CPU clock speed is 2666.5930 MHz.
[    0.260000] ..... CPU clock speed is 2666.5930 MHz.
[    0.260000] ..... host bus clock speed is 999.9294 MHz.
[    0.260000] ..... host bus clock speed is 999.9294 MHz.
[    0.260293] Performance Events:=20
[    0.260293] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.350543] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.350543] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.371247] CPU 1 irqstacks, hard=3D930c8000 soft=3D930ca000
[    0.371247] CPU 1 irqstacks, hard=3D930c8000 soft=3D930ca000
[    0.373412] x86: Booting SMP configuration:
[    0.373412] x86: Booting SMP configuration:
[    0.380068] .... node  #0, CPUs: =20
[    0.380068] .... node  #0, CPUs:         #1 #1
[    0.010000] Initializing CPU#1
[    0.020000] kvm-clock: cpu 1, msr 0:13ffb081, secondary cpu clock
[    0.020000] masked ExtINT on CPU#1
[    0.020000] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.420709] x86: Booted up 1 node, 2 CPUs
[    0.420709] x86: Booted up 1 node, 2 CPUs
[    0.420455] KVM setup async PF for cpu 1
[    0.420455] KVM setup async PF for cpu 1
[    0.420455] kvm-stealtime: cpu 1, msr 138527c0
[    0.420455] kvm-stealtime: cpu 1, msr 138527c0
[    0.430059] ----------------
[    0.430059] ----------------
[    0.440006] | NMI testsuite:
[    0.440006] | NMI testsuite:
[    0.440943] --------------------
[    0.440943] --------------------
[    0.442002]   remote IPI:
[    0.442002]   remote IPI:  ok  |  ok  |

[    0.450748]    local IPI:
[    0.450748]    local IPI:  ok  |  ok  |

[    0.470214] --------------------
[    0.470214] --------------------
[    0.471335] Good, all   2 testcases passed! |
[    0.471335] Good, all   2 testcases passed! |
[    0.472759] ---------------------------------
[    0.472759] ---------------------------------
[    0.474193] smpboot: Total of 2 processors activated (10665.90 BogoMIPS)
[    0.474193] smpboot: Total of 2 processors activated (10665.90 BogoMIPS)
[    0.501203] xor: measuring software checksum speed
[    0.501203] xor: measuring software checksum speed
[    0.600033]    pIII_sse  :  4484.400 MB/sec
[    0.600033]    pIII_sse  :  4484.400 MB/sec
[    0.700025]    prefetch64-sse:  2671.200 MB/sec
[    0.700025]    prefetch64-sse:  2671.200 MB/sec
[    0.701572] xor: using function: pIII_sse (4484.400 MB/sec)
[    0.701572] xor: using function: pIII_sse (4484.400 MB/sec)
[    0.703436] prandom: seed boundary self test passed
[    0.703436] prandom: seed boundary self test passed
[    0.710297] prandom: 100 self tests passed
[    0.710297] prandom: 100 self tests passed
[    0.712212] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.712212] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.722571] regulator-dummy: no parameters
[    0.722571] regulator-dummy: no parameters
[    0.724401] RTC time: 16:16:07, date: 02/20/14
[    0.724401] RTC time: 16:16:07, date: 02/20/14
[    0.731189] NET: Registered protocol family 16
[    0.731189] NET: Registered protocol family 16
[    0.740227] cpuidle: using governor ladder
[    0.740227] cpuidle: using governor ladder
[    0.742360] ACPI: bus type PCI registered
[    0.742360] ACPI: bus type PCI registered
[    0.744682] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.744682] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.750035] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.750035] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.752121] PCI: Using configuration type 1 for base access
[    0.752121] PCI: Using configuration type 1 for base access
[    0.970074] raid6: mmxx1     1510 MB/s
[    0.970074] raid6: mmxx1     1510 MB/s
[    1.140095] raid6: mmxx2     1685 MB/s
[    1.140095] raid6: mmxx2     1685 MB/s
[    1.310053] raid6: sse1x1     635 MB/s
[    1.310053] raid6: sse1x1     635 MB/s
[    1.480149] raid6: sse1x2    1517 MB/s
[    1.480149] raid6: sse1x2    1517 MB/s
[    1.650046] raid6: sse2x1    1120 MB/s
[    1.650046] raid6: sse2x1    1120 MB/s
[    1.830035] raid6: sse2x2    2821 MB/s
[    1.830035] raid6: sse2x2    2821 MB/s
[    1.831328] raid6: using algorithm sse2x2 (2821 MB/s)
[    1.831328] raid6: using algorithm sse2x2 (2821 MB/s)
[    1.837345] raid6: using intx1 recovery algorithm
[    1.837345] raid6: using intx1 recovery algorithm
[    1.839003] gpio-f7188x: Not a Fintek device at 0x0000002e
[    1.839003] gpio-f7188x: Not a Fintek device at 0x0000002e
[    1.840136] gpio-f7188x: Not a Fintek device at 0x0000004e
[    1.840136] gpio-f7188x: Not a Fintek device at 0x0000004e
[    1.850964] ACPI: Added _OSI(Module Device)
[    1.850964] ACPI: Added _OSI(Module Device)
[    1.852358] ACPI: Added _OSI(Processor Device)
[    1.852358] ACPI: Added _OSI(Processor Device)
[    1.857485] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.857485] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.859003] ACPI: Added _OSI(Processor Aggregator Device)
[    1.859003] ACPI: Added _OSI(Processor Aggregator Device)
[    1.887651] ACPI: Interpreter enabled
[    1.887651] ACPI: Interpreter enabled
[    1.888946] ACPI Exception: AE_NOT_FOUND,=20
[    1.888946] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_]While evaluating Sleep State [\_S1_] (20140114/hwxface-580)
 (20140114/hwxface-580)
[    1.891808] ACPI Exception: AE_NOT_FOUND,=20
[    1.891808] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_]While evaluating Sleep State [\_S2_] (20140114/hwxface-580)
 (20140114/hwxface-580)
[    1.894997] ACPI: (supports S0 S3 S5)
[    1.894997] ACPI: (supports S0 S3 S5)
[    1.896486] ACPI: Using IOAPIC for interrupt routing
[    1.896486] ACPI: Using IOAPIC for interrupt routing
[    1.898238] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.898238] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.927777] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.927777] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.929927] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    1.929927] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    1.930205] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.930205] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.933439] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    1.933439] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    1.938213] PCI host bridge to bus 0000:00
[    1.938213] PCI host bridge to bus 0000:00
[    1.940031] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.940031] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.941878] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.941878] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.943881] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.943881] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.945919] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.945919] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.948196] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    1.948196] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    1.950266] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.950266] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.954057] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.954057] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.960053] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.960053] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.965660] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    1.965660] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    1.970342] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.970342] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.973134] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    1.973134] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    1.975490] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    1.975490] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    1.978926] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.978926] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.986234] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.986234] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.990956] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.990956] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    2.003444] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    2.003444] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    2.007369] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    2.007369] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    2.011494] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    2.011494] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    2.015569] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    2.015569] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    2.023467] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    2.023467] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    2.026815] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    2.026815] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    2.030568] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    2.030568] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    2.033507] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    2.033507] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    2.042313] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    2.042313] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    2.045800] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    2.045800] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    2.048951] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    2.048951] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    2.070188] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    2.070188] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    2.077598] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    2.077598] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    2.080655] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    2.080655] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    2.101275] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    2.101275] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    2.108635] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    2.108635] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    2.111395] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    2.111395] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    2.140578] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    2.140578] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    2.147772] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    2.147772] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    2.150671] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    2.150671] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    2.171335] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    2.171335] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    2.181510] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    2.181510] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    2.188527] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    2.188527] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    2.209233] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    2.209233] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    2.210898] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    2.210898] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    2.234661] pci_bus 0000:00: on NUMA node 0
[    2.234661] pci_bus 0000:00: on NUMA node 0
[    2.241626] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    2.241626] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    2.247625] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    2.247625] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    2.254716] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    2.254716] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    2.260475] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    2.260475] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    2.262679] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    2.262679] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    2.270000] ACPI:=20
[    2.270000] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    2.280782] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    2.280782] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    2.286934] vgaarb: loaded
[    2.286934] vgaarb: loaded
[    2.287821] vgaarb: bridge control possible 0000:00:02.0
[    2.287821] vgaarb: bridge control possible 0000:00:02.0
[    2.294721] pps_core: LinuxPPS API ver. 1 registered
[    2.294721] pps_core: LinuxPPS API ver. 1 registered
[    2.296405] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    2.296405] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    2.300113] PTP clock support registered
[    2.300113] PTP clock support registered
[    2.310604] Advanced Linux Sound Architecture Driver Initialized.
[    2.310604] Advanced Linux Sound Architecture Driver Initialized.
[    2.312615] PCI: Using ACPI for IRQ routing
[    2.312615] PCI: Using ACPI for IRQ routing
[    2.317449] PCI: pci_cache_line_size set to 64 bytes
[    2.317449] PCI: pci_cache_line_size set to 64 bytes
[    2.319503] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    2.319503] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    2.320076] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    2.320076] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    2.333943] NET: Registered protocol family 23
[    2.333943] NET: Registered protocol family 23
[    2.335511] Bluetooth: Core ver 2.18
[    2.335511] Bluetooth: Core ver 2.18
[    2.340145] NET: Registered protocol family 31
[    2.340145] NET: Registered protocol family 31
[    2.341580] Bluetooth: HCI device and connection manager initialized
[    2.341580] Bluetooth: HCI device and connection manager initialized
[    2.347465] Bluetooth: HCI socket layer initialized
[    2.347465] Bluetooth: HCI socket layer initialized
[    2.350053] Bluetooth: L2CAP socket layer initialized
[    2.350053] Bluetooth: L2CAP socket layer initialized
[    2.351915] Bluetooth: SCO socket layer initialized
[    2.351915] Bluetooth: SCO socket layer initialized
[    2.360477] nfc: nfc_init: NFC Core ver 0.1
[    2.360477] nfc: nfc_init: NFC Core ver 0.1
[    2.362009] NET: Registered protocol family 39
[    2.362009] NET: Registered protocol family 39
[    2.367806] Switched to clocksource kvm-clock
[    2.367806] Switched to clocksource kvm-clock
[    2.369260] Warning: could not register all branches stats
[    2.369260] Warning: could not register all branches stats
[    2.369260] Warning: could not register annotated branches stats
[    2.369260] Warning: could not register annotated branches stats
[    2.429348] pnp: PnP ACPI init
[    2.429348] pnp: PnP ACPI init
[    2.430535] ACPI: bus type PNP registered
[    2.430535] ACPI: bus type PNP registered
[    2.432098] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    2.432098] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    2.435446] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.435446] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.437773] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    2.437773] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    2.440584] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.440584] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.443253] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    2.443253] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    2.446121] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    2.446121] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    2.448410] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    2.448410] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    2.451029] pnp 00:03: [dma 2]
[    2.451029] pnp 00:03: [dma 2]
[    2.452620] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    2.452620] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    2.454964] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    2.454964] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    2.457820] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    2.457820] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    2.460158] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    2.460158] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    2.462987] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.462987] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.466112] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    2.466112] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    2.468787] pnp: PnP ACPI: found 7 devices
[    2.468787] pnp: PnP ACPI: found 7 devices
[    2.470479] ACPI: bus type PNP unregistered
[    2.470479] ACPI: bus type PNP unregistered
[    2.508493] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.508493] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.510348] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.510348] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.512164] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.512164] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.514172] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    2.514172] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    2.516530] NET: Registered protocol family 1
[    2.516530] NET: Registered protocol family 1
[    2.517979] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.517979] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.519953] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.519953] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.521888] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.521888] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.523940] pci 0000:00:02.0: Boot video device
[    2.523940] pci 0000:00:02.0: Boot video device
[    2.525540] PCI: CLS 0 bytes, default 64
[    2.525540] PCI: CLS 0 bytes, default 64
[    2.528006] Unpacking initramfs...
[    2.528006] Unpacking initramfs...
[    2.762234] Freeing initrd memory: 3276K (93cbd000 - 93ff0000)
[    2.762234] Freeing initrd memory: 3276K (93cbd000 - 93ff0000)
[    2.765815] Machine check injector initialized
[    2.765815] Machine check injector initialized
[    2.767766] apm: BIOS not found.
[    2.767766] apm: BIOS not found.
[    2.769091] PCLMULQDQ-NI instructions are not detected.
[    2.769091] PCLMULQDQ-NI instructions are not detected.
[    2.771146] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    2.771146] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    2.777178] NatSemi SCx200 Driver
[    2.777178] NatSemi SCx200 Driver
[    2.794679] Initializing RT-Tester: OK
[    2.794679] Initializing RT-Tester: OK
[    2.796031] spin_lock-torture:--- Start of test: nwriters_stress=3D4 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    2.796031] spin_lock-torture:--- Start of test: nwriters_stress=3D4 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    2.804138] spin_lock-torture: Creating torture_shuffle task
[    2.804138] spin_lock-torture: Creating torture_shuffle task
[    2.817374] spin_lock-torture: Creating torture_stutter task
[    2.817374] spin_lock-torture: Creating torture_stutter task
[    2.824114] spin_lock-torture: torture_shuffle task started
[    2.824114] spin_lock-torture: torture_shuffle task started
[    2.826600] spin_lock-torture: Creating lock_torture_writer task
[    2.826600] spin_lock-torture: Creating lock_torture_writer task
[    2.828708] spin_lock-torture: torture_stutter task started
[    2.828708] spin_lock-torture: torture_stutter task started
[    2.831513] spin_lock-torture: Creating lock_torture_writer task
[    2.831513] spin_lock-torture: Creating lock_torture_writer task
[    2.833764] spin_lock-torture: lock_torture_writer task started
[    2.833764] spin_lock-torture: lock_torture_writer task started
[    2.836040] spin_lock-torture: lock_torture_writer task started
[    2.836040] spin_lock-torture: lock_torture_writer task started
[    2.842981] spin_lock-torture: Creating lock_torture_writer task
[    2.842981] spin_lock-torture: Creating lock_torture_writer task
[    2.845180] spin_lock-torture: Creating lock_torture_writer task
[    2.845180] spin_lock-torture: Creating lock_torture_writer task
[    2.847313] spin_lock-torture: lock_torture_writer task started
[    2.847313] spin_lock-torture: lock_torture_writer task started
[    2.852744] spin_lock-torture: lock_torture_writer task started
[    2.852744] spin_lock-torture: lock_torture_writer task started
[    2.854935] spin_lock-torture: Creating lock_torture_stats task
[    2.854935] spin_lock-torture: Creating lock_torture_stats task
[    2.858997] futex hash table entries: 512 (order: 4, 65536 bytes)
[    2.858997] futex hash table entries: 512 (order: 4, 65536 bytes)
[    2.861759] spin_lock-torture: lock_torture_stats task started
[    2.861759] spin_lock-torture: lock_torture_stats task started
[    2.874069] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.874069] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.928127] jffs2: version 2.2.=20
[    2.928127] jffs2: version 2.2.=20
[    2.932448] ROMFS MTD (C) 2007 Red Hat, Inc.
[    2.932448] ROMFS MTD (C) 2007 Red Hat, Inc.
[    2.934577] QNX4 filesystem 0.2.3 registered.
[    2.934577] QNX4 filesystem 0.2.3 registered.
[    2.936374] QNX6 filesystem 1.0.0 registered.
[    2.936374] QNX6 filesystem 1.0.0 registered.
[    2.937817] fuse init (API version 7.22)
[    2.937817] fuse init (API version 7.22)
[    2.941183] NILFS version 2 loaded
[    2.941183] NILFS version 2 loaded
[    2.942409] msgmni has been set to 577
[    2.942409] msgmni has been set to 577
[    2.975020] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    2.975020] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    2.977515] io scheduler noop registered (default)
[    2.977515] io scheduler noop registered (default)
[    2.979067] test_string_helpers: Running tests...
[    2.979067] test_string_helpers: Running tests...
[    2.982304] crc32: CRC_LE_BITS =3D 8, CRC_BE BITS =3D 8
[    2.982304] crc32: CRC_LE_BITS =3D 8, CRC_BE BITS =3D 8
[    2.983889] crc32: self tests passed, processed 225944 bytes in 634035 n=
sec
[    2.983889] crc32: self tests passed, processed 225944 bytes in 634035 n=
sec
[    2.996495] crc32c: CRC_LE_BITS =3D 8
[    2.996495] crc32c: CRC_LE_BITS =3D 8
[    2.997639] crc32c: self tests passed, processed 225944 bytes in 275155 =
nsec
[    2.997639] crc32c: self tests passed, processed 225944 bytes in 275155 =
nsec
[    3.529968] crc32_combine: 8373 self tests passed
[    3.529968] crc32_combine: 8373 self tests passed
[    3.782229] tsc: Refined TSC clocksource calibration: 2666.599 MHz
[    3.782229] tsc: Refined TSC clocksource calibration: 2666.599 MHz
[    4.289962] crc32c_combine: 8373 self tests passed
[    4.289962] crc32c_combine: 8373 self tests passed
[    4.292526] xz_dec_test: module loaded
[    4.292526] xz_dec_test: module loaded
[    4.293763] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
250 0' and write .xz files to it.
[    4.293763] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
250 0' and write .xz files to it.
[    4.297241] rbtree testing
[    4.297241] rbtree testing -> 53941 cycles
 -> 53941 cycles
[    6.527063] augmented rbtree testing
[    6.527063] augmented rbtree testing -> 81245 cycles
 -> 81245 cycles
[    9.840004] no IO addresses supplied
[    9.840004] no IO addresses supplied
[    9.852713] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    9.852713] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    9.855306] ACPI: Power Button [PWRF]
[    9.855306] ACPI: Power Button [PWRF]
[    9.970836] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    9.970836] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   10.025676] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   10.025676] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   10.031082] DoubleTalk PC - not found
[   10.031082] DoubleTalk PC - not found
[   10.032972] scx200_gpio: no SCx200 gpio present
[   10.032972] scx200_gpio: no SCx200 gpio present
[   10.034594] nsc_gpio initializing
[   10.034594] nsc_gpio initializing
[   10.045877] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[   10.045877] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[   10.048834] Hangcheck: Using getrawmonotonic().
[   10.048834] Hangcheck: Using getrawmonotonic().
[   10.050847] dummy-irq: no IRQ given.  Use irq=3DN
[   10.050847] dummy-irq: no IRQ given.  Use irq=3DN
[   10.052536] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[   10.052536] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[   10.066946] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[   10.066946] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[   10.069208] scx200_docflash: NatSemi SCx200 DOCCS Flash Driver
[   10.069208] scx200_docflash: NatSemi SCx200 DOCCS Flash Driver
[   10.071539] slram: not enough parameters.
[   10.071539] slram: not enough parameters.
[   10.089890] ftl_cs: FTL header not found.
[   10.089890] ftl_cs: FTL header not found.
[   10.113678] No valid DiskOnChip devices found
[   10.113678] No valid DiskOnChip devices found
[   10.126996] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   10.126996] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   10.131202] serio: i8042 KBD port at 0x60,0x64 irq 1
[   10.131202] serio: i8042 KBD port at 0x60,0x64 irq 1
[   10.133779] serio: i8042 AUX port at 0x60,0x64 irq 12
[   10.133779] serio: i8042 AUX port at 0x60,0x64 irq 12
[   10.146631] mousedev: PS/2 mouse device common for all mice
[   10.146631] mousedev: PS/2 mouse device common for all mice
[   10.150467] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   10.150467] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   10.164448] i2c /dev entries driver
[   10.164448] i2c /dev entries driver
[   10.165987] scx200_i2c: no SCx200 gpio pins available
[   10.165987] scx200_i2c: no SCx200 gpio pins available
[   10.167926] Driver for 1-wire Dallas network protocol.
[   10.167926] Driver for 1-wire Dallas network protocol.
[   10.173276] mixcomwd: No card detected, or port not available
[   10.173276] mixcomwd: No card detected, or port not available
[   10.195595] it87_wdt: no device
[   10.195595] it87_wdt: no device
[   10.196859] pc87413_wdt: Version 1.1 at io 0x2E
[   10.196859] pc87413_wdt: Version 1.1 at io 0x2E
[   10.199693] pc87413_wdt: initialized. timeout=3D1 min
[   10.199693] pc87413_wdt: initialized. timeout=3D1 min
[   10.208803] pc87413_wdt: cannot request SWC region at 0xffff
[   10.208803] pc87413_wdt: cannot request SWC region at 0xffff
[   10.211598] sbc60xxwdt: WDT driver for 60XX single board computer initia=
lised. timeout=3D30 sec (nowayout=3D1)
[   10.211598] sbc60xxwdt: WDT driver for 60XX single board computer initia=
lised. timeout=3D30 sec (nowayout=3D1)
[   10.215008] sbc7240_wdt: I/O address 0x0443 already in use
[   10.215008] sbc7240_wdt: I/O address 0x0443 already in use
[   10.216845] cpu5wdt: misc_register failed
[   10.216845] cpu5wdt: misc_register failed
[   10.218279] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[   10.218279] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[   10.230696] w83697ug_wdt: No W83697UG/UF could be found
[   10.230696] w83697ug_wdt: No W83697UG/UF could be found
[   10.232443] machzwd: MachZ ZF-Logic Watchdog driver initializing
[   10.232443] machzwd: MachZ ZF-Logic Watchdog driver initializing
[   10.234477] machzwd: no ZF-Logic found
[   10.234477] machzwd: no ZF-Logic found
[   10.235737] sbc_epx_c3: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[   10.235737] sbc_epx_c3: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[   10.238097] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[   10.238097] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[   10.250897] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[   10.250897] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[   10.254005] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[   10.254005] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[   10.257682] md: raid1 personality registered for level 1
[   10.257682] md: raid1 personality registered for level 1
[   10.259416] md: raid10 personality registered for level 10
[   10.259416] md: raid10 personality registered for level 10
[   10.272042] md: raid6 personality registered for level 6
[   10.272042] md: raid6 personality registered for level 6
[   10.274123] md: raid5 personality registered for level 5
[   10.274123] md: raid5 personality registered for level 5
[   10.275866] md: raid4 personality registered for level 4
[   10.275866] md: raid4 personality registered for level 4
[   10.289149] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[   10.289149] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[   10.291965] device-mapper: raid: Loading target version 1.5.2
[   10.291965] device-mapper: raid: Loading target version 1.5.2
[   10.295114] intel_rapl: driver does not support CPU family 15 model 6
[   10.295114] intel_rapl: driver does not support CPU family 15 model 6
[   10.327774] NET: Registered protocol family 17
[   10.327774] NET: Registered protocol family 17
[   10.351622] NET: Registered protocol family 15
[   10.351622] NET: Registered protocol family 15
[   10.353131] NET: Registered protocol family 5
[   10.353131] NET: Registered protocol family 5
[   10.354682] can: controller area network core (rev 20120528 abi 9)
[   10.354682] can: controller area network core (rev 20120528 abi 9)
[   10.356777] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
[   10.356777] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
[   10.358970] NET: Registered protocol family 29
[   10.358970] NET: Registered protocol family 29
[   10.360433] can: netlink gateway (rev 20130117) max_hops=3D1
[   10.360433] can: netlink gateway (rev 20130117) max_hops=3D1
[   10.382214] NET: Registered protocol family 36
[   10.382214] NET: Registered protocol family 36
[   10.384187] batman_adv: B.A.T.M.A.N. advanced 2014.1.0 (compatibility ve=
rsion 15) loaded
[   10.384187] batman_adv: B.A.T.M.A.N. advanced 2014.1.0 (compatibility ve=
rsion 15) loaded
[   10.388046]=20
[   10.388046] printing PIC contents
[   10.388046]=20
[   10.388046] printing PIC contents
[   10.389621] ... PIC  IMR: ffff
[   10.389621] ... PIC  IMR: ffff
[   10.390625] ... PIC  IRR: 1013
[   10.390625] ... PIC  IRR: 1013
[   10.391637] ... PIC  ISR: 0000
[   10.391637] ... PIC  ISR: 0000
[   10.392641] ... PIC ELCR: 0c00
[   10.392641] ... PIC ELCR: 0c00
[   10.393678] printing local APIC contents on CPU#0/0:
[   10.393678] printing local APIC contents on CPU#0/0:
[   10.395313] ... APIC ID:      00000000 (0)
[   10.395313] ... APIC ID:      00000000 (0)
[   10.396672] ... APIC VERSION: 00050014
[   10.396672] ... APIC VERSION: 00050014
[   10.398928] ... APIC TASKPRI: 00000000 (00)
[   10.398928] ... APIC TASKPRI: 00000000 (00)
[   10.400337] ... APIC PROCPRI: 00000000
[   10.400337] ... APIC PROCPRI: 00000000
[   10.401237] ... APIC LDR: 01000000
[   10.401237] ... APIC LDR: 01000000
[   10.401237] ... APIC DFR: ffffffff
[   10.401237] ... APIC DFR: ffffffff
[   10.401237] ... APIC SPIV: 000001ff
[   10.401237] ... APIC SPIV: 000001ff
[   10.401237] ... APIC ISR field:
[   10.401237] ... APIC ISR field:
[   10.401237] 00000000
[   10.401237] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[   10.401237] ... APIC TMR field:
[   10.401237] ... APIC TMR field:
[   10.401237] 00000000
[   10.401237] 000000000200000002000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[   10.401237] ... APIC IRR field:
[   10.401237] ... APIC IRR field:
[   10.401237] 00000000
[   10.401237] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000800000008000

[   10.401237] ... APIC ESR: 00000000
[   10.401237] ... APIC ESR: 00000000
[   10.401237] ... APIC ICR: 000008fd
[   10.401237] ... APIC ICR: 000008fd
[   10.401237] ... APIC ICR2: 02000000
[   10.401237] ... APIC ICR2: 02000000
[   10.401237] ... APIC LVTT: 000200ef
[   10.401237] ... APIC LVTT: 000200ef
[   10.401237] ... APIC LVTPC: 00010000
[   10.401237] ... APIC LVTPC: 00010000
[   10.401237] ... APIC LVT0: 00010700
[   10.401237] ... APIC LVT0: 00010700
[   10.401237] ... APIC LVT1: 00000400
[   10.401237] ... APIC LVT1: 00000400
[   10.401237] ... APIC LVTERR: 000000fe
[   10.401237] ... APIC LVTERR: 000000fe
[   10.401237] ... APIC TMICT: 0009893b
[   10.401237] ... APIC TMICT: 0009893b
[   10.401237] ... APIC TMCCT: 0008101a
[   10.401237] ... APIC TMCCT: 0008101a
[   10.401237] ... APIC TDCR: 00000003
[   10.401237] ... APIC TDCR: 00000003
[   10.401237]=20
[   10.401237]=20
[   10.464605] number of MP IRQ sources: 15.
[   10.464605] number of MP IRQ sources: 15.
[   10.466107] number of IO-APIC #0 registers: 24.
[   10.466107] number of IO-APIC #0 registers: 24.
[   10.467759] testing the IO APIC.......................
[   10.467759] testing the IO APIC.......................
[   10.469643] IO APIC #0......
[   10.469643] IO APIC #0......
[   10.470691] .... register #00: 00000000
[   10.470691] .... register #00: 00000000
[   10.472089] .......    : physical APIC id: 00
[   10.472089] .......    : physical APIC id: 00
[   10.473667] .......    : Delivery Type: 0
[   10.473667] .......    : Delivery Type: 0
[   10.485463] .......    : LTS          : 0
[   10.485463] .......    : LTS          : 0
[   10.486804] .... register #01: 00170011
[   10.486804] .... register #01: 00170011
[   10.488062] .......     : max redirection entries: 17
[   10.488062] .......     : max redirection entries: 17
[   10.489697] .......     : PRQ implemented: 0
[   10.489697] .......     : PRQ implemented: 0
[   10.491092] .......     : IO APIC version: 11
[   10.491092] .......     : IO APIC version: 11
[   10.492503] .... register #02: 00000000
[   10.492503] .... register #02: 00000000
[   10.493748] .......     : arbitration: 00
[   10.493748] .......     : arbitration: 00
[   10.505402] .... IRQ redirection table:
[   10.505402] .... IRQ redirection table:
[   10.506755] 1    0    0   0   0    0    0    00
[   10.506755] 1    0    0   0   0    0    0    00
[   10.508254] 0    0    0   0   0    1    1    31
[   10.508254] 0    0    0   0   0    1    1    31
[   10.509761] 0    0    0   0   0    1    1    30
[   10.509761] 0    0    0   0   0    1    1    30
[   10.511270] 0    0    0   0   0    1    1    33
[   10.511270] 0    0    0   0   0    1    1    33
[   10.512761] 1    0    0   0   0    1    1    34
[   10.512761] 1    0    0   0   0    1    1    34
[   10.524431] 1    1    0   0   0    1    1    35
[   10.524431] 1    1    0   0   0    1    1    35
[   10.525934] 0    0    0   0   0    1    1    36
[   10.525934] 0    0    0   0   0    1    1    36
[   10.527416] 0    0    0   0   0    1    1    37
[   10.527416] 0    0    0   0   0    1    1    37
[   10.528885] 0    0    0   0   0    1    1    38
[   10.528885] 0    0    0   0   0    1    1    38
[   10.530361] 0    1    0   0   0    1    1    39
[   10.530361] 0    1    0   0   0    1    1    39
[   10.531830] 1    1    0   0   0    1    1    3A
[   10.531830] 1    1    0   0   0    1    1    3A
[   10.533310] 1    1    0   0   0    1    1    3B
[   10.533310] 1    1    0   0   0    1    1    3B
[   10.544915] 0    0    0   0   0    1    1    3C
[   10.544915] 0    0    0   0   0    1    1    3C
[   10.546419] 0    0    0   0   0    1    1    3D
[   10.546419] 0    0    0   0   0    1    1    3D
[   10.547921] 0    0    0   0   0    1    1    3E
[   10.547921] 0    0    0   0   0    1    1    3E
[   10.549405] 0    0    0   0   0    1    1    3F
[   10.549405] 0    0    0   0   0    1    1    3F
[   10.550882] 1    0    0   0   0    0    0    00
[   10.550882] 1    0    0   0   0    0    0    00
[   10.552372] 1    0    0   0   0    0    0    00
[   10.552372] 1    0    0   0   0    0    0    00
[   10.554051] 1    0    0   0   0    0    0    00
[   10.554051] 1    0    0   0   0    0    0    00
[   10.565677] 1    0    0   0   0    0    0    00
[   10.565677] 1    0    0   0   0    0    0    00
[   10.567174] 1    0    0   0   0    0    0    00
[   10.567174] 1    0    0   0   0    0    0    00
[   10.568642] 1    0    0   0   0    0    0    00
[   10.568642] 1    0    0   0   0    0    0    00
[   10.570135] 1    0    0   0   0    0    0    00
[   10.570135] 1    0    0   0   0    0    0    00
[   10.571625] 1    0    0   0   0    0    0    00
[   10.571625] 1    0    0   0   0    0    0    00
[   10.573095] IRQ to pin mappings:
[   10.573095] IRQ to pin mappings:
[   10.584252] IRQ0=20
[   10.584252] IRQ0 -> 0:2-> 0:2

[   10.585120] IRQ1=20
[   10.585120] IRQ1 -> 0:1-> 0:1

[   10.585988] IRQ3=20
[   10.585988] IRQ3 -> 0:3-> 0:3

[   10.586860] IRQ4=20
[   10.586860] IRQ4 -> 0:4-> 0:4

[   10.587729] IRQ5=20
[   10.587729] IRQ5 -> 0:5-> 0:5

[   10.588592] IRQ6=20
[   10.588592] IRQ6 -> 0:6-> 0:6

[   10.589456] IRQ7=20
[   10.589456] IRQ7 -> 0:7-> 0:7

[   10.590325] IRQ8=20
[   10.590325] IRQ8 -> 0:8-> 0:8

[   10.591191] IRQ9=20
[   10.591191] IRQ9 -> 0:9-> 0:9

[   10.592050] IRQ10=20
[   10.592050] IRQ10 -> 0:10-> 0:10

[   10.592970] IRQ11=20
[   10.592970] IRQ11 -> 0:11-> 0:11

[   10.593925] IRQ12=20
[   10.593925] IRQ12 -> 0:12-> 0:12

[   10.605026] IRQ13=20
[   10.605026] IRQ13 -> 0:13-> 0:13

[   10.605965] IRQ14=20
[   10.605965] IRQ14 -> 0:14-> 0:14

[   10.606890] IRQ15=20
[   10.606890] IRQ15 -> 0:15-> 0:15

[   10.607818] .................................... done.
[   10.607818] .................................... done.
[   10.609495] Using IPI No-Shortcut mode
[   10.609495] Using IPI No-Shortcut mode
[   10.611716] bootconsole [earlyser0] disabled
[   10.611716] bootconsole [earlyser0] disabled
[   10.613310] registered taskstats version 1
[   10.629339] Btrfs loaded, debug=3Don, assert=3Don, integrity-checker=3Don
[   10.642779]   Magic number: 2:893:287
[   10.643534] tty ttyz1: hash matches
[   10.644245] acpi PNP0400:00: hash matches
[   10.644922] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[   10.647610] ALSA device list:
[   10.648137]   #0: Dummy 1
[   10.648580]   #1: Loopback 1
[   10.649062]   #2: Virtual MIDI Card 1
[   10.662260] Freeing unused kernel memory: 1932K (81fa6000 - 82189000)
[   10.668330] Write protecting the kernel text: 8744k
[   10.674870] Write protecting the kernel read-only data: 4548k
[   10.675907] NX-protecting the kernel data: 9688k

mount: mounting proc on /proc failed: No such device
/etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: No such file or directory

Please wait: booting...
mount: mounting proc on /proc failed: No such device
grep: /proc/filesystems: No such file or directory
[   10.922853] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
Starting Bootlog daemon: bootlogd: cannot allocate pseudo tty: No such file=
 or directory
bootlogd.
mount: can't read '/proc/mounts': No such file or directory
/etc/rcS.d/S37populate-volatile.sh: line 172: /proc/cmdline: No such file o=
r directory
grep: /proc/filesystems: No such file or directory
Configuring network interfaces... ifconfig: socket: Address family not supp=
orted by protocol
ifup: can't open '/var/run/ifstate': No such file or directory
done.
hwclock: can't open '/dev/misc/rtc': No such file or directory
Running postinst /etc/rpm-postinsts/100...

mount: no /proc/mounts
wfg: skip syslogd
Kernel tests: Boot OK!
Kernel tests: Boot OK!
mount: mounting proc on /proc failed: No such device
/etc/rc5.d/S99-rc.local: line 19: /proc/187/oom_score_adj: No such file or =
directory
sed: /lib/modules/3.14.0-rc3-02458-g837caba/modules.dep: No such file or di=
rectory
xargs: modprobe: No such file or directory
run-parts: /etc/kernel-tests/01-modprobe exited with code 127
grep: /proc/cmdline: No such file or directory
grep: /proc/cmdline: No such file or directory
Trinity v1.4pre  Dave Jones <davej@redhat.com>
[   12.149658] random: trinity urandom read with 4 bits of entropy available
Trinity v1.4pre  Dave Jones <davej@redhat.com>
Done parsing arguments.
Marking all syscalls as enabled.
[init] Enabled 351 syscalls. Disabled 0 syscalls.
DANGER: RUNNING AS ROOT.
Unless you are running in a virtual machine, this could cause serious probl=
ems such as overwriting CMOS
or similar which could potentially make this machine unbootable without a f=
irmware reset.

ctrl-c now unless you really know what you are doing.
Continuing in 10 seconds.
[init] Marking syscall get_robust_list (312) as to be disabled.
Done parsing arguments.
Trinity v1.4pre  Dave Jones <davej@redhat.com>
[init] Marking syscall get_robust_list (312) as to be disabled.
Done parsing arguments.
## couldn't open logfile trinity.log
Marking all syscalls as enabled.
[init] Disabling syscalls marked as disabled by command line options
[init] Marked syscall get_robust_list (312) as deactivated.
[init] Enabled 350 syscalls. Disabled 1 syscalls.
DANGER: RUNNING AS ROOT.
Unless you are running in a virtual machine, this could cause serious probl=
ems such as overwriting CMOS
or similar which could potentially make this machine unbootable without a f=
irmware reset.

ctrl-c now unless you really know what you are doing.
Continuing in 10 seconds.
## couldn't open logfile trinity.log
Continuing in 9 seconds.
Couldn't read pid_max from proc
[init] Using pid_max =3D 32768
[init] Kernel was tainted on startup. Will ignore flags that are already se=
t.
[init] Started watchdog process, PID is 207
[main] Main thread is alive.
[main] Couldn't find socket cachefile. Regenerating.
[main] Setsockopt(1 b 80d1000 a2) on fd 6 [1:1:1]
[main] Setsockopt(1 2f 80d1000 4) on fd 7 [5:3:88]
[main] Setsockopt(1 10 80d1000 8c) on fd 8 [17:3:768]
[   22.385362] can: request_module (can-proto-0) failed.
[main] Setsockopt(10a 7 80d1000 20) on fd 9 [23:1:148]
[main] Setsockopt(1 2b 80d1000 d3) on fd 11 [1:5:1]
[   22.421485] can: request_module (can-proto-5) failed.
[main] Setsockopt(1 f 80d1000 54) on fd 13 [17:2:768]
[main] Setsockopt(1 c 80d1000 4) on fd 14 [23:5:59]
fopen: No such file or directory
Couldn't read pid_max from proc
[init] Using pid_max =3D 32768
[main] Setsockopt(1 2f 80d1000 4) on fd 16 [39:5:0]
[init] Kernel was tainted on startup. Will ignore flags that are already se=
t.
[main] Setsockopt(1 7 80d1000 ce) on fd 17 [1:5:1]
[init] Started watchdog process, PID is 337
[main] Main thread is alive.
[main] Setsockopt(107 f 80d1000 4) on fd 19 [17:3:768]
[   22.477632] can: request_module (can-proto-6) failed.
[main] Setsockopt(1 2b 80d1000 f6) on fd 21 [39:5:0]
[   22.525895] can: request_module (can-proto-0) failed.
[main] Setsockopt(1 29 80d1000 3d) on fd 28 [1:1:1]
[   22.608940] can: request_module (can-proto-6) failed.
[main] Setsockopt(1 2d 80d1000 cd) on fd 33 [1:1:1]
[main] Setsockopt(1 8 80d1000 4) on fd 34 [5:2:0]
[main] Setsockopt(1 5 80d1000 4) on fd 35 [16:2:16]
[main] Setsockopt(107 e 80d1000 4) on fd 36 [17:2:768]
[main] Setsockopt(1 28 80d1000 4) on fd 37 [23:2:1]
[   22.775138] can: request_module (can-proto-1) failed.
[main] Setsockopt(1 2d 80d1000 4) on fd 38 [39:2:1]
[main] Setsockopt(1 12 80d1000 4) on fd 39 [1:1:1]
[main] Setsockopt(1 10 80d1000 4) on fd 42 [17:10:34878]
[main] Setsockopt(1 22 80d1000 71) on fd 43 [23:2:1]
[   22.818716] can: request_module (can-proto-2) failed.
[main] Setsockopt(1 5 80d1000 4) on fd 45 [1:1:1]
[main] Setsockopt(1 8 80d1000 6) on fd 46 [5:3:207]
[   22.878150] can: request_module (can-proto-0) failed.
[main] Setsockopt(1 29 80d1000 ef) on fd 52 [17:10:768]
[main] Setsockopt(10a 7 80d1000 4) on fd 53 [23:1:205]
[   22.905244] can: request_module (can-proto-0) failed.
[main] Setsockopt(1 10 80d1000 3e) on fd 54 [36:3:124]
[main] Setsockopt(1 5 80d1000 69) on fd 56 [1:1:1]
[main] Setsockopt(1 29 80d1000 84) on fd 57 [5:3:253]
[main] Setsockopt(1 29 80d1000 ed) on fd 59 [23:2:1]
[   23.040207] can: request_module (can-proto-6) failed.
[main] Setsockopt(1 2b 80d1000 ee) on fd 62 [5:3:67]
[main] Setsockopt(1 22 80d1000 9c) on fd 63 [17:10:768]
[main] Setsockopt(1 2b 80d1000 4) on fd 64 [23:5:41]
[main] Setsockopt(1 23 80d1000 98) on fd 65 [36:2:173]
[main] Setsockopt(1 c 80d1000 60) on fd 66 [39:5:0]
[main] Setsockopt(1 28 80d1000 ea) on fd 67 [1:5:1]
[main] Setsockopt(1 a 80d1000 7e) on fd 70 [23:2:0]
[main] Setsockopt(1 c 80d1000 4) on fd 72 [39:2:1]
[main] Setsockopt(1 2d 80d1000 4) on fd 74 [5:3:46]
[main] Setsockopt(1 2c 80d1000 4) on fd 75 [17:2:2048]
[main] Setsockopt(10a a 80d1000 a5) on fd 76 [23:5:134]
[main] Setsockopt(1 2b 80d1000 4) on fd 79 [1:1:1]
[main] Setsockopt(1 2e 80d1000 4) on fd 81 [17:3:768]
[main] Setsockopt(1 20 80d1000 4) on fd 82 [23:1:51]
[main] Setsockopt(1 23 80d1000 c1) on fd 83 [36:2:142]
[main] Setsockopt(1 23 80d1000 4) on fd 84 [39:1:1]
[main] Setsockopt(1 b 80d1000 f9) on fd 85 [1:5:1]
[main] Setsockopt(1 1d 80d1000 e3) on fd 87 [17:10:768]
[main] Setsockopt(10a 4 80d1000 4) on fd 88 [23:1:9]
[main] Setsockopt(1 2b 80d1000 4) on fd 89 [39:5:0]
[main] Setsockopt(1 9 80d1000 4) on fd 90 [1:2:1]
[main] Setsockopt(1 2b 80d1000 4) on fd 91 [5:2:0]
[main] Setsockopt(1 6 80d1000 ba) on fd 92 [17:10:768]
[main] Setsockopt(10a a 80d1000 4) on fd 93 [23:2:0]
[main] Setsockopt(1 22 80d1000 21) on fd 95 [39:2:1]
[main] Setsockopt(1 20 80d1000 4) on fd 96 [1:2:1]
[main] Setsockopt(1 21 80d1000 4) on fd 98 [17:2:768]
[main] Setsockopt(10a a 80d1000 4) on fd 99 [23:1:198]
[   23.567637] sock: process `trinity-main' is using obsolete setsockopt SO=
_BSDCOMPAT
[main] Setsockopt(1 e 80d1000 4) on fd 100 [36:3:84]
[main] Setsockopt(1 e 80d1000 4f) on fd 101 [39:1:1]
[main] Setsockopt(1 c 80d1000 91) on fd 102 [1:1:1]
[main] Setsockopt(1 a 80d1000 45) on fd 104 [17:10:768]
[   23.603847] irda_setsockopt: not allowed to set MAXSDUSIZE for this sock=
et type!
[main] Setsockopt(1 1d 80d1000 20) on fd 106 [39:2:1]
[main] Setsockopt(1 7 80d1000 4) on fd 107 [1:2:1]
[main] Setsockopt(1 12 80d1000 4) on fd 111 [23:1:147]
[main] Setsockopt(1 10 80d1000 9f) on fd 112 [39:5:0]
[main] Setsockopt(1 22 80d1000 4) on fd 114 [5:2:0]
[main] Setsockopt(10a a 80d1000 b3) on fd 116 [23:2:1]
[main] Setsockopt(1 d 80d1000 8) on fd 118 [1:5:1]
[main] Setsockopt(1 20 80d1000 4) on fd 120 [16:2:4]
[main] Setsockopt(1 24 80d1000 42) on fd 121 [17:2:768]
[main] Setsockopt(1 28 80d1000 4) on fd 122 [23:1:65]
[main] Setsockopt(1 c 80d1000 5f) on fd 126 [17:3:768]
[main] Setsockopt(1 2c 80d1000 4) on fd 128 [39:5:0]
[main] Setsockopt(1 24 80d1000 4) on fd 130 [5:3:171]
[main] Setsockopt(1 2c 80d1000 4) on fd 131 [16:2:0]
[main] Setsockopt(1 2d 80d1000 d4) on fd 133 [23:2:0]
[main] Setsockopt(1 2 80d1000 4) on fd 134 [39:1:1]
[main] Setsockopt(1 2b 80d1000 66) on fd 135 [1:5:1]
[main] Setsockopt(1 24 80d1000 4) on fd 136 [5:3:255]
[main] Setsockopt(1 2c 80d1000 84) on fd 139 [36:3:93]
[main] Setsockopt(1 2b 80d1000 4) on fd 140 [39:5:0]
[main] Setsockopt(1 2e 80d1000 1f) on fd 142 [5:3:141]
[main] Setsockopt(107 7 80d1000 4) on fd 143 [17:3:768]
[main] Setsockopt(10a 7 80d1000 b8) on fd 144 [23:1:86]
[main] Setsockopt(1 d 80d1000 8) on fd 148 [5:2:0]
[main] Setsockopt(107 11 80d1000 4) on fd 149 [17:2:768]
[main] Setsockopt(1 5 80d1000 67) on fd 150 [23:1:31]
[main] Setsockopt(10a 7 80d1000 c5) on fd 155 [23:1:214]
[main] Setsockopt(1 28 80d1000 50) on fd 159 [17:2:768]
[main] Setsockopt(1 6 80d1000 96) on fd 160 [23:1:100]
[main] Setsockopt(1 20 80d1000 4) on fd 161 [39:5:0]
[main] Setsockopt(1 24 80d1000 4) on fd 163 [5:3:46]
[main] Setsockopt(1 10 80d1000 ca) on fd 166 [39:1:1]
[main] Setsockopt(1 2c 80d1000 4) on fd 168 [5:2:0]
[main] Setsockopt(10a 4 80d1000 74) on fd 170 [23:1:134]
[main] Setsockopt(1 6 80d1000 4) on fd 171 [36:3:216]
[main] Setsockopt(1 1d 80d1000 8d) on fd 172 [39:2:1]
[main] Setsockopt(10a 4 80d1000 7c) on fd 176 [23:2:0]
[main] Setsockopt(1 7 80d1000 4) on fd 177 [36:3:26]
[main] Setsockopt(1 2d 80d1000 4) on fd 179 [1:2:1]
[main] Setsockopt(1 28 80d1000 4) on fd 180 [5:3:30]
[main] Setsockopt(1 a 80d1000 8e) on fd 182 [23:2:1]
[main] Setsockopt(1 c 80d1000 4) on fd 183 [39:2:1]
[main] Setsockopt(1 f 80d1000 4) on fd 184 [1:5:1]
[main] Setsockopt(107 c 80d1000 4) on fd 186 [17:3:768]
[main] Setsockopt(10a 4 80d1000 4) on fd 187 [23:2:1]
[main] Setsockopt(1 2f 80d1000 4) on fd 189 [1:1:1]
[main] Setsockopt(1 2f 80d1000 9a) on fd 191 [17:2:768]
[main] Setsockopt(1 10 80d1000 a2) on fd 192 [23:1:184]
[main] Setsockopt(1 b 80d1000 4) on fd 194 [1:1:1]
[main] Setsockopt(1 29 80d1000 37) on fd 197 [23:5:169]
[main] Setsockopt(1 2b 80d1000 4) on fd 198 [39:1:1]
[main] Setsockopt(1 1d 80d1000 4) on fd 199 [1:2:1]
[main] Setsockopt(1 7 80d1000 4) on fd 200 [5:2:0]
[main] Setsockopt(1 21 80d1000 4) on fd 203 [23:2:0]
[main] Setsockopt(1 6 80d1000 59) on fd 204 [39:1:1]
[main] Setsockopt(1 2e 80d1000 c) on fd 205 [1:2:1]
[main] Setsockopt(1 e 80d1000 99) on fd 208 [23:2:0]
[main] Setsockopt(1 21 80d1000 41) on fd 211 [5:2:0]
[main] Setsockopt(1 1d 80d1000 4) on fd 212 [17:3:768]
[main] Setsockopt(10a 4 80d1000 4) on fd 213 [23:1:238]
[main] Setsockopt(1 2a 80d1000 4) on fd 215 [1:1:1]
[main] Setsockopt(1 2e 80d1000 4) on fd 216 [5:3:133]
[main] Setsockopt(1 24 80d1000 4) on fd 218 [23:1:101]
[main] Setsockopt(1 1 80d1000 37) on fd 219 [36:2:253]
[main] Setsockopt(1 21 80d1000 9) on fd 220 [39:1:1]
[main] Setsockopt(1 28 80d1000 4) on fd 225 [39:5:0]
[main] Setsockopt(1 23 80d1000 4) on fd 226 [1:5:1]
[main] Setsockopt(1 e 80d1000 4) on fd 227 [5:3:80]
[main] Setsockopt(107 c 80d1000 4) on fd 228 [17:3:768]
[main] Setsockopt(1 29 80d1000 4) on fd 231 [1:5:1]
[main] Setsockopt(1 9 80d1000 e3) on fd 233 [17:3:768]
[main] Setsockopt(1 f 80d1000 4) on fd 234 [23:2:1]
[main] Setsockopt(1 b 80d1000 d4) on fd 236 [1:5:1]
[main] Setsockopt(1 2f 80d1000 75) on fd 237 [5:2:0]
[main] Setsockopt(1 1d 80d1000 8e) on fd 240 [39:5:0]
[main] Setsockopt(1 b 80d1000 4) on fd 243 [16:3:0]
[main] Setsockopt(1 24 80d1000 1a) on fd 244 [17:10:768]
[main] Setsockopt(1 2 80d1000 4e) on fd 245 [23:5:19]
[main] Setsockopt(1 2e 80d1000 74) on fd 247 [1:5:1]
[main] Setsockopt(1 9 80d1000 e0) on fd 249 [17:2:768]
[main] Setsockopt(1 2c 80d1000 f5) on fd 251 [39:5:0]
[main] Setsockopt(1 e 80d1000 19) on fd 252 [1:5:1]
[main] Setsockopt(1 a 80d1000 3a) on fd 253 [5:2:0]
[main] Setsockopt(1 5 80d1000 4) on fd 254 [17:2:768]
[main] Setsockopt(1 2c 80d1000 f2) on fd 255 [23:1:44]
[main] Setsockopt(1 29 80d1000 4) on fd 256 [36:3:223]
[main] Setsockopt(1 29 80d1000 4) on fd 257 [39:5:0]
[main] Setsockopt(1 1d 80d1000 4) on fd 258 [1:2:1]
[main] Setsockopt(1 21 80d1000 4) on fd 259 [5:3:66]
[main] Setsockopt(1 10 80d1000 4) on fd 260 [17:2:768]
[main] Setsockopt(1 12 80d1000 78) on fd 263 [1:5:1]
[main] Setsockopt(1 1 80d1000 4) on fd 266 [23:2:1]
[main] Setsockopt(1 b 80d1000 4) on fd 267 [39:5:0]
[main] Setsockopt(1 2d 80d1000 4) on fd 270 [17:3:34924]
[main] Setsockopt(1 1d 80d1000 4) on fd 273 [39:1:1]
[main] Setsockopt(1 e 80d1000 5f) on fd 274 [1:5:1]
[main] Setsockopt(1 21 80d1000 db) on fd 275 [5:2:0]
[main] Setsockopt(1 2c 80d1000 4) on fd 277 [17:2:768]
[main] Setsockopt(10a 4 80d1000 4) on fd 278 [23:1:37]
[main] Setsockopt(1 21 80d1000 77) on fd 280 [39:5:0]
[main] Setsockopt(1 22 80d1000 94) on fd 281 [1:1:1]
[main] Setsockopt(1 1 80d1000 15) on fd 282 [5:2:0]
[main] Setsockopt(10a a 80d1000 63) on fd 284 [23:5:83]
[main] Setsockopt(1 21 80d1000 4) on fd 285 [39:2:1]
[main] Setsockopt(1 1 80d1000 4) on fd 286 [1:1:1]
[main] Setsockopt(107 9 80d1000 4) on fd 288 [17:3:768]
[main] Setsockopt(1 a 80d1000 6c) on fd 291 [1:5:1]
[main] Setsockopt(1 2f 80d1000 4) on fd 292 [5:2:0]
[main] Setsockopt(1 22 80d1000 7b) on fd 293 [17:3:768]
[main] Setsockopt(1 2b 80d1000 66) on fd 294 [23:2:0]
[main] Setsockopt(1 2 80d1000 9e) on fd 299 [17:10:768]
[main] Setsockopt(10a a 80d1000 4) on fd 300 [23:1:135]
[main] Setsockopt(1 2e 80d1000 d9) on fd 301 [36:2:228]
[main] Setsockopt(10e 3 80d1000 4) on fd 305 [16:2:4]
[main] Setsockopt(1 10 80d1000 4) on fd 306 [17:3:768]
[main] Setsockopt(1 7 80d1000 fa) on fd 307 [23:2:1]
[main] Setsockopt(1 1 80d1000 4) on fd 309 [39:2:1]
[main] Setsockopt(1 5 80d1000 20) on fd 310 [1:1:1]
[main] Setsockopt(1 21 80d1000 fc) on fd 313 [23:1:122]
[main] Setsockopt(1 7 80d1000 12) on fd 314 [39:2:1]
[main] Setsockopt(1 24 80d1000 4) on fd 315 [1:1:1]
[main] Setsockopt(107 c 80d1000 4) on fd 317 [17:2:768]
[main] Setsockopt(1 2c 80d1000 4) on fd 319 [36:3:131]
[main] Setsockopt(1 2b 80d1000 73) on fd 320 [39:1:1]
[main] Setsockopt(1 2b 80d1000 4) on fd 322 [5:2:0]
[main] Setsockopt(1 2 80d1000 4) on fd 325 [39:1:1]
[main] Setsockopt(1 23 80d1000 2e) on fd 326 [1:2:1]
[main] Setsockopt(1 2c 80d1000 90) on fd 328 [17:3:768]
[main] Setsockopt(1 21 80d1000 4) on fd 330 [36:2:14]
[main] Setsockopt(1 28 80d1000 4) on fd 333 [5:2:0]
[main] Setsockopt(1 5 80d1000 ef) on fd 335 [23:1:159]
[main] Setsockopt(1 23 80d1000 c8) on fd 336 [39:5:0]
[main] Setsockopt(1 6 80d1000 4) on fd 337 [1:1:1]
[main] Setsockopt(1 24 80d1000 4) on fd 338 [5:2:0]
[main] Setsockopt(10e 3 80d1000 1b) on fd 339 [16:3:0]
[main] Setsockopt(1 f 80d1000 4) on fd 340 [17:3:768]
[main] Setsockopt(10a 7 80d1000 4) on fd 341 [23:2:1]
[main] Setsockopt(1 21 80d1000 4) on fd 343 [1:1:1]
[main] Setsockopt(1 c 80d1000 4e) on fd 344 [5:2:0]
[main] Setsockopt(1 28 80d1000 8d) on fd 345 [16:2:15]
[main] Setsockopt(1 24 80d1000 4) on fd 346 [17:10:768]
[main] Setsockopt(1 2 80d1000 e0) on fd 349 [39:5:0]
[main] Setsockopt(1 22 80d1000 4) on fd 350 [1:5:1]
[main] Setsockopt(1 28 80d1000 4) on fd 351 [5:2:0]
[main] Setsockopt(1 12 80d1000 4) on fd 352 [17:3:768]
[main] Setsockopt(1 2c 80d1000 ec) on fd 353 [23:5:118]
[main] Setsockopt(107 9 80d1000 4) on fd 357 [17:3:768]
[main] Setsockopt(1 6 80d1000 4) on fd 359 [39:1:1]
[main] Setsockopt(1 2c 80d1000 4) on fd 362 [17:10:768]
[main] Setsockopt(1 2c 80d1000 cc) on fd 363 [23:1:249]
[main] Setsockopt(1 6 80d1000 4) on fd 364 [39:1:1]
[main] Setsockopt(1 9 80d1000 8a) on fd 366 [5:2:0]
[main] Setsockopt(1 29 80d1000 c7) on fd 367 [17:2:768]
[main] Setsockopt(1 2 80d1000 e9) on fd 368 [23:2:1]
[main] Setsockopt(1 c 80d1000 4) on fd 370 [1:5:1]
[main] Setsockopt(1 12 80d1000 dc) on fd 371 [5:2:0]
[main] Setsockopt(1 28 80d1000 9c) on fd 373 [23:5:20]
[main] Setsockopt(1 10 80d1000 4) on fd 376 [1:1:1]
[main] Setsockopt(1 10 80d1000 4) on fd 380 [39:1:1]
[main] created 375 sockets
[main] Setsockopt(1 e 80d1000 57) on fd 6 [1:1:1]
[main] Setsockopt(1 a 80d1000 4) on fd 7 [5:3:88]
[main] Setsockopt(1 29 80d1000 4) on fd 8 [17:3:768]
[main] Setsockopt(1 20 80d1000 fa) on fd 9 [23:1:148]
[main] Setsockopt(1 2f 80d1000 4) on fd 10 [39:2:1]
[main] Setsockopt(10a a 80d1000 f) on fd 14 [23:5:59]
[   26.683758] irda_setsockopt: not allowed to set MAXSDUSIZE for this sock=
et type!
[main] Setsockopt(1 7 80d1000 4) on fd 17 [1:5:1]
[main] Setsockopt(107 7 80d1000 4) on fd 19 [17:3:768]
[main] Setsockopt(1 23 80d1000 f5) on fd 20 [23:2:0]
[main] Setsockopt(1 8 80d1000 70) on fd 22 [1:2:1]
[main] Setsockopt(1 6 80d1000 4) on fd 23 [5:3:1]
[main] Setsockopt(1 2d 80d1000 8a) on fd 24 [16:2:4]
[main] Setsockopt(1 1 80d1000 4) on fd 25 [17:3:768]
[main] Setsockopt(1 21 80d1000 9b) on fd 26 [23:5:133]
[main] Setsockopt(1 1d 80d1000 4) on fd 27 [39:5:0]
[main] Setsockopt(1 2b 80d1000 4) on fd 28 [1:1:1]
[main] Setsockopt(1 6 80d1000 1a) on fd 29 [5:2:0]
[main] Setsockopt(1 20 80d1000 4) on fd 32 [39:5:0]
[main] Setsockopt(1 1d 80d1000 be) on fd 33 [1:1:1]
[main] Setsockopt(1 6 80d1000 4) on fd 35 [16:2:16]
[main] Setsockopt(107 e 80d1000 4) on fd 36 [17:2:768]
[main] Setsockopt(1 12 80d1000 4) on fd 37 [23:2:1]
[main] Setsockopt(1 8 80d1000 52) on fd 38 [39:2:1]
[main] Setsockopt(1 c 80d1000 4) on fd 39 [1:1:1]
[main] Setsockopt(1 2c 80d1000 4) on fd 40 [5:2:0]
[main] Setsockopt(1 a 80d1000 4) on fd 42 [17:10:34878]
[main] Setsockopt(1 2b 80d1000 4) on fd 45 [1:1:1]
[main] Setsockopt(1 10 80d1000 d8) on fd 46 [5:3:207]
[main] Setsockopt(107 9 80d1000 4) on fd 47 [17:3:768]
[main] Setsockopt(10a a 80d1000 55) on fd 48 [23:1:76]
[main] Setsockopt(1 12 80d1000 4) on fd 49 [39:2:1]
[main] Setsockopt(1 2a 80d1000 4) on fd 50 [1:5:1]
[main] Setsockopt(1 6 80d1000 49) on fd 51 [5:2:0]
[main] Setsockopt(1 2c 80d1000 4) on fd 52 [17:10:768]
[main] Setsockopt(1 22 80d1000 4) on fd 54 [36:3:124]
[main] Setsockopt(1 23 80d1000 4) on fd 56 [1:1:1]
[main] Setsockopt(1 f 80d1000 4) on fd 57 [5:3:253]
[main] Setsockopt(1 7 80d1000 4) on fd 59 [23:2:1]
[main] Setsockopt(1 f 80d1000 f1) on fd 60 [39:1:1]
[main] Setsockopt(1 24 80d1000 b9) on fd 62 [5:3:67]
[main] Setsockopt(1 10 80d1000 4) on fd 66 [39:5:0]
[main] Setsockopt(1 12 80d1000 4) on fd 67 [1:5:1]
[main] Setsockopt(1 10 80d1000 4) on fd 68 [5:2:0]
[main] Setsockopt(107 8 80d1000 76) on fd 69 [17:2:768]
[main] Setsockopt(1 a 80d1000 27) on fd 70 [23:2:0]
[main] Setsockopt(1 24 80d1000 4) on fd 71 [36:3:254]
[main] Setsockopt(1 21 80d1000 72) on fd 73 [1:1:1]
[main] Setsockopt(1 d 80d1000 8) on fd 74 [5:3:46]
[main] Setsockopt(1 5 80d1000 68) on fd 75 [17:2:2048]
[main] Setsockopt(1 2c 80d1000 4) on fd 76 [23:5:134]
[main] Setsockopt(1 7 80d1000 a5) on fd 77 [36:2:182]
[main] Setsockopt(1 d 80d1000 8) on fd 78 [39:5:0]
[main] Setsockopt(1 f 80d1000 4) on fd 79 [1:1:1]
[main] Setsockopt(107 9 80d1000 4) on fd 81 [17:3:768]
[main] Setsockopt(1 c 80d1000 4) on fd 82 [23:1:51]
[main] Setsockopt(118 0 80d1000 9e) on fd 83 [36:2:142]
[main] Setsockopt(1 6 80d1000 9) on fd 85 [1:5:1]
[main] Setsockopt(1 22 80d1000 67) on fd 86 [5:2:0]
[main] Setsockopt(1 2f 80d1000 4) on fd 87 [17:10:768]
[main] Setsockopt(10a 7 80d1000 4) on fd 88 [23:1:9]
[main] Setsockopt(1 22 80d1000 4) on fd 90 [1:2:1]
[main] Setsockopt(1 7 80d1000 4) on fd 92 [17:10:768]
[main] Setsockopt(1 2b 80d1000 f) on fd 93 [23:2:0]
[main] Setsockopt(1 20 80d1000 4) on fd 96 [1:2:1]
[main] Setsockopt(1 9 80d1000 4) on fd 97 [5:3:51]
[main] Setsockopt(1 2c 80d1000 4) on fd 98 [17:2:768]
[main] Setsockopt(10a a 80d1000 4) on fd 99 [23:1:198]
[main] Setsockopt(1 e 80d1000 4) on fd 103 [5:2:0]
[main] Setsockopt(1 2c 80d1000 b5) on fd 104 [17:10:768]
[main] Setsockopt(10a 4 80d1000 c3) on fd 105 [23:5:84]
[main] Setsockopt(1 c 80d1000 4) on fd 107 [1:2:1]
[main] Setsockopt(1 f 80d1000 75) on fd 108 [5:2:0]
[main] Setsockopt(1 2b 80d1000 4) on fd 109 [16:3:2]
[main] Setsockopt(10a 4 80d1000 4) on fd 111 [23:1:147]
[main] Setsockopt(1 6 80d1000 f3) on fd 112 [39:5:0]
[main] Setsockopt(1 1d 80d1000 8d) on fd 113 [1:1:1]
[main] Setsockopt(1 12 80d1000 4) on fd 114 [5:2:0]
[main] Setsockopt(1 f 80d1000 92) on fd 116 [23:2:1]
[main] Setsockopt(1 10 80d1000 3f) on fd 118 [1:5:1]
[main] Setsockopt(1 1 80d1000 a) on fd 120 [16:2:4]
[main] Setsockopt(1 2c 80d1000 60) on fd 121 [17:2:768]
[main] Setsockopt(1 10 80d1000 5f) on fd 122 [23:1:65]
[main] Setsockopt(1 12 80d1000 4) on fd 126 [17:3:768]
[main] Setsockopt(1 c 80d1000 c2) on fd 127 [23:5:101]
[main] Setsockopt(1 8 80d1000 4) on fd 130 [5:3:171]
[main] Setsockopt(107 f 80d1000 b3) on fd 132 [17:3:768]
[main] Setsockopt(1 e 80d1000 d0) on fd 133 [23:2:0]
[main] Setsockopt(1 21 80d1000 f2) on fd 137 [17:10:768]
[main] Setsockopt(10a a 80d1000 4) on fd 138 [23:5:106]
[main] Setsockopt(1 20 80d1000 4) on fd 140 [39:5:0]
[main] Setsockopt(1 12 80d1000 4) on fd 141 [1:1:1]
[main] Setsockopt(107 12 80d1000 4) on fd 143 [17:3:768]
[main] Setsockopt(84 0 80d1000 be) on fd 145 [36:2:245]
[main] Setsockopt(1 2f 80d1000 67) on fd 146 [39:1:1]
[main] Setsockopt(107 11 80d1000 4) on fd 149 [17:2:768]
[main] Setsockopt(1 2b 80d1000 4) on fd 151 [39:1:1]
[main] Setsockopt(1 20 80d1000 4) on fd 152 [1:2:1]
[main] Setsockopt(1 2b 80d1000 4) on fd 153 [5:3:150]
[main] Setsockopt(1 9 80d1000 4) on fd 156 [39:5:0]
[main] Setsockopt(1 1 80d1000 ae) on fd 157 [1:1:1]
[main] Setsockopt(107 9 80d1000 b4) on fd 159 [17:2:768]
[main] Setsockopt(1 b 80d1000 ab) on fd 160 [23:1:100]
[main] Setsockopt(107 8 80d1000 31) on fd 164 [17:3:24582]
[main] Setsockopt(10a a 80d1000 4) on fd 165 [23:2:1]
[main] Setsockopt(1 d 80d1000 8) on fd 167 [1:1:1]
[main] Setsockopt(1 8 80d1000 27) on fd 168 [5:2:0]
[main] Generating file descriptors
[main] Added 50 filenames from /dev
[main] Added 1 filenames from /proc
[main] Added 1 filenames from /sys
[main] Setsockopt(1 8 80d1000 df) on fd 173 [1:2:1]
[main] Setsockopt(1 9 80d1000 6a) on fd 174 [5:2:0]
[main] Setsockopt(1 1d 80d1000 1f) on fd 175 [17:10:768]
[main] Setsockopt(1 2d 80d1000 4) on fd 177 [36:3:26]
[main] Setsockopt(1 2f 80d1000 4) on fd 179 [1:2:1]
[main] Setsockopt(1 2f 80d1000 4) on fd 181 [17:2:768]
[main] Setsockopt(1 d 80d1000 8) on fd 182 [23:2:1]
[main] Setsockopt(1 24 80d1000 4) on fd 183 [39:2:1]
[main] Setsockopt(1 8 80d1000 4) on fd 184 [1:5:1]
[main] Setsockopt(1 24 80d1000 4) on fd 186 [17:3:768]
[main] Setsockopt(10a 4 80d1000 ae) on fd 187 [23:2:1]
[main] Setsockopt(1 d 80d1000 8) on fd 188 [39:5:0]
[main] Setsockopt(1 1 80d1000 8c) on fd 189 [1:1:1]
[main] Setsockopt(1 2c 80d1000 4) on fd 190 [5:3:250]
[main] Setsockopt(1 5 80d1000 4) on fd 191 [17:2:768]
[main] Setsockopt(1 24 80d1000 b) on fd 193 [39:2:1]
[main] Setsockopt(1 28 80d1000 8f) on fd 195 [5:2:0]
[main] Setsockopt(1 b 80d1000 4) on fd 196 [17:3:768]
[main] Setsockopt(10a 4 80d1000 e6) on fd 197 [23:5:169]
[main] Setsockopt(1 2f 80d1000 bd) on fd 198 [39:1:1]
[main] Setsockopt(1 b 80d1000 dc) on fd 201 [16:3:2]
[main] Setsockopt(1 8 80d1000 4f) on fd 203 [23:2:0]
[main] Setsockopt(1 c 80d1000 4) on fd 204 [39:1:1]
[main] Setsockopt(1 5 80d1000 4) on fd 205 [1:2:1]
[main] Setsockopt(1 c 80d1000 6f) on fd 207 [17:10:768]
[main] Setsockopt(10a 4 80d1000 6e) on fd 208 [23:2:0]
[main] Setsockopt(1 22 80d1000 75) on fd 210 [1:2:1]
[main] Setsockopt(1 8 80d1000 4) on fd 211 [5:2:0]
[main] Setsockopt(1 24 80d1000 4) on fd 213 [23:1:238]
[main] Setsockopt(1 1d 80d1000 4) on fd 215 [1:1:1]
[main] Setsockopt(1 a 80d1000 ed) on fd 216 [5:3:133]
[main] Setsockopt(1 2f 80d1000 61) on fd 217 [17:2:768]
[main] Setsockopt(1 8 80d1000 6) on fd 218 [23:1:101]
[main] Setsockopt(1 5 80d1000 4) on fd 220 [39:1:1]
[main] Setsockopt(1 12 80d1000 4) on fd 221 [1:5:1]
[main] Setsockopt(1 2b 80d1000 4) on fd 223 [17:2:768]
[   27.030764]=20
[   27.031119] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   27.031833] [ INFO: suspicious RCU usage. ]
[   27.032536] 3.14.0-rc3-02458-g837caba #2 Not tainted
[   27.033378] -------------------------------
[   27.044237] include/linux/cgroup.h:697 suspicious rcu_dereference_check(=
) usage!
[   27.045795]=20
[   27.045795] other info that might help us debug this:
[   27.045795]=20
[   27.047114]=20
[   27.047114] rcu_scheduler_active =3D 1, debug_locks =3D 0
[main] Setsockopt(1 c 80d1000 4) on fd 225 [39:5:0]
[   27.048751] 2 locks held by trinity-c0/4479:
[   27.049478]  #0:  (callback_mutex){+.+...}, at: [<81118395>] cpuset_cpus=
_allowed+0x1e/0x123
[   27.051132]  #1:  (&(&p->alloc_lock)->rlock){+.+...}, at: [<8111839c>] c=
puset_cpus_allowed+0x25/0x123
[   27.052788]=20
[   27.052788] stack backtrace:
[   27.053528] CPU: 0 PID: 4479 Comm: trinity-c0 Not tainted 3.14.0-rc3-024=
58-g837caba #2
[   27.064971]  00000000 00000000
 919eff28 81877cc3[main] Setsockopt(1 7 80d1000 4) on fd 226 [1:5:1]
[main] Setso
ckopt(1 f 80d100
[   27.066486] irda_setsockopt: not allowed to set MAXSDUSIZE for this sock=
et type!
0 4) on fd 228 [17:3:768]
[main] Setsockopt(1 2 80d1000 29) on fd 233 [17:3:768]
[main] Setsockopt(1 10 80d1000 be) on fd 236 [1:5:1]
[main] Setsockopt(1 10 80d1000 4) on fd 239 [23:1:11]
[main] Setsockopt(1 2b 80d1000 4) on fd 242 [5:2:0]
[main] Setsockopt(10e 5 80d1000 4) on fd 243 [16:3:0]
[main] Setsockopt(10a 4 80d1000 c7) on fd 245 [23:5:19]
[main] Setsockopt(1 2 80d1000 4) on fd 246 [39:5:0]
[main] Setsockopt(1 7 80d1000 4) on fd 248 [5:3:154]
[main] Setsockopt(10a a 80d1000 83) on fd 250 [23:1:75]
[main] Setsockopt(1 29 80d1000 d3) on fd 251 [39:5:0]
[main] Setsockopt(1 28 80d1000 d7) on fd 254 [17:2:768]
[main] Setsockopt(1 e 80d1000 4c) on fd 256 [36:3:223]
[main] Setsockopt(1 23 80d1000 63) on fd 258 [1:2:1]
[main] Setsockopt(1 e 80d1000 a9) on fd 260 [17:2:768]
[main] Setsockopt(1 28 80d1000 4) on fd 261 [23:1:130]
[main] Setsockopt(1 2d 80d1000 4) on fd 262 [39:5:0]
[main] Setsockopt(1 b 80d1000 4) on fd 265 [17:2:768]
[main] Setsockopt(1 d 80d1000 8) on fd 269 [5:3:230]
[main] Setsockopt(1 2 80d1000 4) on fd 270 [17:3:34924]
[main] Setsockopt(1 d 80d1000 8) on fd 271 [23:2:1]
[main] Setsockopt(1 2c 80d1000 bb) on fd 274 [1:5:1]
[main] Setsockopt(1 c 80d1000 4) on fd 275 [5:2:0]
[main] Setsockopt(1 9 80d1000 25) on fd 276 [16:2:2]
[main] Setsockopt(107 11 80d1000 4) on fd 277 [17:2:768]
[main] Setsockopt(1 10 80d1000 4) on fd 278 [23:1:37]
[main] Setsockopt(84 0 80d1000 bc) on fd 279 [36:2:179]
[main] Setsockopt(1 2a 80d1000 4) on fd 281 [1:1:1]
[main] Setsockopt(1 29 80d1000 d3) on fd 283 [17:10:768]
[main] Setsockopt(1 21 80d1000 4) on fd 285 [39:2:1]
[main] Setsockopt(1 29 80d1000 4) on fd 286 [1:1:1]
[main] Setsockopt(1 12 80d1000 e3) on fd 288 [17:3:768]
[main] Setsockopt(1 c 80d1000 50) on fd 289 [23:5:58]
[main] Setsockopt(1 9 80d1000 4) on fd 290 [39:2:1]
[main] Setsockopt(1 d 80d1000 8) on fd 291 [1:5:1]
[main] Setsockopt(1 2f 80d1000 e6) on fd 292 [5:2:0]
[main] Setsockopt(107 c 80d1000 4) on fd 293 [17:3:768]
[main] Setsockopt(1 9 80d1000 f9) on fd 294 [23:2:0]
[main] Setsockopt(1 2c 80d1000 4) on fd 295 [36:2:110]
[main] Setsockopt(1 7 80d1000 8a) on fd 301 [36:2:228]
[main] Setsockopt(1 7 80d1000 4) on fd 302 [39:2:1]
[main] Setsockopt(1 2d 80d1000 be) on fd 304 [5:3:232]
[   27.113255]  00000001 00000000 919eff50 810cdec4[main] Setsockop
t(10e 3 80d1000=20
[   27.124461]  81c3c6e0 81c4bbfc 00000001 00000000 927fa850 927fa850 927fa=
c08 826d5b80
[   27.126092]  919eff68 81118473 919eff80 927fa850 00000000 919eff9c 919ef=
f94 810b2442
[   27.127577] Call Trace:
[   27.128043]  [<81877cc3>] dump_stack+0x7e/0xf1
[   27.128799]  [<810cdec4>] lockdep_rcu_suspicious+0xf2/0xfa
[   27.129739]  [<81118473>] cpuset_cpus_allowed+0xfc/0x123
[   27.130665]  [<810b2442>] sched_setaffinity+0x3fe/0x502
[   27.131617]  [<810b2044>] ? set_cpus_allowed_ptr+0x1d6/0x1d6
[   27.132589]  [<810b25eb>] SyS_sched_setaffinity+0xa5/0xab
[   27.133513]  [<818887d8>] syscall_call+0x7/0xb
4) on fd 305 [16:2:4]
[   27.144665]  [<81880000>] ? __schedule+0xca1/0x1194
[main] Setsockopt(1 29 80d1000 9a) on fd 306 [17:3:768]
[   27.150682] warning: process `trinity-c0' used the obsolete bdflush syst=
em call
[child0:4479] signalfd4 (327) returned ENOSYS, marking as inactive.
[child0:4479] fanotify_init (338) returned ENOSYS, marking as inactive.
[child0:4479] lookup_dcookie (253) returned ENOSYS, marking as inactive.
[child0:4479] vm86 (166) returned ENOSYS, marking as inactive.
[main] Setsockopt(1 12 80d1000 4) on fd 308 [36:3:53]
[main] Setsockopt(1 22 80d1000 4) on fd 309 [39:2:1]
[main] Setsockopt(1 2f 80d1000 7f) on fd 311 [5:3:24]
[   27.166207] Fix your initscripts?
[   27.166967] warning: process `trinity-c0' used the obsolete bdflush syst=
em call
[   27.168194] Fix your initscripts?
[   27.169212] VFS: Warning: trinity-c0 using old stat() call. Recompile yo=
ur binary.
[child0:4479] kexec_load (283) returned ENOSYS, marking as inactive.
[   27.172956] VFS: Warning: trinity-c0 using old stat() call. Recompile yo=
ur binary.

[child0:4479] delete_module (129) returned ENOSYS, marking as inactive.
[child0:4479] inotify_init1 (332) returned ENOSYS, marking as inactive.
[   27.189209] VFS: Warning: trinity-c0 using old stat() call. Recompile yo=
ur binary.
[main] Setsockopt(1 20 80d1000 4) on fd 314 [39:2:1]
[main] Setsockopt(1 2d 80d1000 7d) on fd 315 [1:1:1]
[main] Setsockopt(107 11 80d1000 4) on fd 317 [17:2:768]
[main] Setsockopt(10a 4 80d1000 4) on fd 318 [23:5:102]
[main] Setsockopt(1 8 80d1000 b3) on fd 322 [5:2:0]
[main] Setsockopt(10a 4 80d1000 f2) on fd 324 [23:1:35]
[main] Setsockopt(1 1 80d1000 2e) on fd 326 [1:2:1]
[main] Setsockopt(1 10 80d1000 4e) on fd 329 [23:2:1]
[main] Setsockopt(1 20 80d1000 e2) on fd 330 [36:2:14]
[main] Setsockopt(1 9 80d1000 4) on fd 332 [1:5:1]
[main] Setsockopt(1 7 80d1000 ec) on fd 335 [23:1:159]
[main] Setsockopt(1 28 80d1000 4) on fd 336 [39:5:0]
[main] Setsockopt(1 2a 80d1000 4) on fd 337 [1:1:1]
[main] Setsockopt(1 1d 80d1000 d8) on fd 340 [17:3:768]
[main] Setsockopt(1 d 80d1000 8) on fd 341 [23:2:1]
[main] Setsockopt(1 7 80d1000 4) on fd 345 [16:2:15]
[main] Setsockopt(1 2c 80d1000 71) on fd 346 [17:10:768]
[main] Setsockopt(1 23 80d1000 4) on fd 347 [23:5:189]
[main] Setsockopt(1 a 80d1000 7b) on fd 349 [39:5:0]
[main] Setsockopt(1 22 80d1000 29) on fd 350 [1:5:1]
[main] Setsockopt(1 12 80d1000 4) on fd 352 [17:3:768]
[main] Setsockopt(10a 4 80d1000 4) on fd 353 [23:5:118]
[main] Setsockopt(1 6 80d1000 4) on fd 354 [39:1:1]
[main] Setsockopt(1 8 80d1000 b6) on fd 355 [1:2:1]
[main] Setsockopt(1 e 80d1000 4) on fd 357 [17:3:768]
[main] Setsockopt(1 10 80d1000 4) on fd 358 [23:1:148]
[main] Setsockopt(1 b 80d1000 4) on fd 359 [39:1:1]
[child0:4479] add_key (286) returned ENOSYS, marking as inactive.
[main] Setsockopt(1 5 80d1000 a7) on fd 365 [1:1:1]
[child0:4479] request_key (287) returned ENOSYS, marking as inactive.
[child0:4479] swapoff (115) returned ENOSYS, marking as inactive.
[child0:4479] timerfd_gettime (326) returned ENOSYS, marking as inactive.
*** glibc detected *** /trinity: free(): invalid pointer: 0x085d0000 ***
[main] Random reseed: 2816957204
[main] Setsockopt(1 f 80d1000 4) on fd 366 [5:2:0]
[main] Setsockopt(1 2b 80d1000 4) on fd 367 [17:2:768]
[main] Setsockopt(1 12 80d1000 2e) on fd 369 [39:5:0]
[main] Setsockopt(107 11 80d1000 4) on fd 372 [17:3:768]
[main] Setsockopt(1 e 80d1000 4) on fd 373 [23:5:20]
[main] Setsockopt(1 b 80d1000 64) on fd 375 [39:2:1]
[main] Setsockopt(1 23 80d1000 75) on fd 376 [1:1:1]
[main] Setsockopt(1 6 80d1000 4) on fd 378 [17:10:768]
[main] Setsockopt(1 1 80d1000 9) on fd 379 [23:5:13]
[main] 375 sockets created based on info from socket cachefile.
[child0:4482] signalfd (321) returned ENOSYS, marking as inactive.
[   27.330403] warning: process `trinity-c0' used the obsolete bdflush syst=
em call
[   27.331721] Fix your initscripts?
[child0:4482] io_getevents (247) returned ENOSYS, marking as inactive.
[   27.333975] VFS: Warning: trinity-c0 using old stat() call. Recompile yo=
ur binary.

[child0:4482] io_submit (248) returned ENOSYS, marking as inactive.
[child0:4482] timerfd_create (322) returned ENOSYS, marking as inactive.
[child0:4482] fanotify_mark (339) returned ENOSYS, marking as inactive.
[child0:4482] uid changed! Was: 0, now 28257
Bailing main loop. Exit reason: UID changed.
[main] Generating file descriptors
[main] Added 49 filenames from /dev
[main] Added 1 filenames from /proc
[main] Added 1 filenames from /sys
[   27.405477] VFS: Warning: trinity-c0 using old stat() call. Recompile yo=
ur binary.
[watchdog] [207] Watchdog exiting
[watchdog] Watchdog is alive. (pid:337)
[   28.411547] warning: process `trinity-c0' used the obsolete bdflush syst=
em call
[   28.412866] Fix your initscripts?
[child0:4559] uid changed! Was: 0, now -189
Bailing main loop. Exit reason: UID changed.
[init]=20
Ran 198 syscalls. Successes: 54  Failures: 144
[watchdog] [337] Watchdog exiting
[init]=20
Ran 31 syscalls. Successes: 11  Failures: 19
[   63.562544] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0=
=20
lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 09:22:10 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 09:22:10 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 09:22:10 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

run-parts: /etc/kernel-tests/99-rmmod exited with code 123
shutdown: warning: cannot open /var/run/shutdown.pid


mount: no /proc/mounts
wfg: skip syslogd
sed: /proc/mounts: No such file or directory
sed: /proc/mounts: No such file or directory
sed: /proc/mounts: No such file or directory
Deconfiguring network interfaces... ifdown: interface lo not configured
done.
Sending all processes the TERM signal...
mount: mounting proc on /proc failed: No such device
killall5[4593]: mount returned non-zero exit status
killall5[4593]: /proc not mounted, failed to mount.
Sending all processes the KILL signal...
mount: mounting proc on /proc failed: No such device
killall5[4598]: mount returned non-zero exit status
killall5[4598]: /proc not mounted, failed to mount.
Unmounting remote filesystems...
Deactivating swap...
Unmounting local filesystems...
grep: /proc/mounts: No such file or directory
mount: can't read '/proc/mounts': No such file or directory
Rebooting...=20
[   81.075816] Unregister pv shared memory for cpu 0
[   81.077610] Unregister pv shared memory for cpu 1
[   81.078501] spin_lock-torture: Unscheduled system shutdown detected
[   81.079619] sbc60xxwdt: Watchdog timer is now disabled...
[   81.089610] reboot: Restarting system
[   81.090235] reboot: machine restart
Elapsed time: 90
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-c=
5-02201550/837caba6587ab563ef3779429ddc9f49adb6b6fc/vmlinuz-3.14.0-rc3-0245=
8-g837caba -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug ap=
ic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=3D1 nmi_watchdo=
g=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/i386-randconf=
ig-c5-02201550/linux-devel:devel-hourly-2014022015/.vmlinuz-837caba6587ab56=
3ef3779429ddc9f49adb6b6fc-20140220161431-7-bens branch=3Dlinux-devel/devel-=
hourly-2014022015 BOOT_IMAGE=3D/kernel/i386-randconfig-c5-02201550/837caba6=
587ab563ef3779429ddc9f49adb6b6fc/vmlinuz-3.14.0-rc3-02458-g837caba'  -initr=
d /kernel-tests/initrd/yocto-minimal-i386.cgz -m 320 -smp 2 -net nic,vlan=
=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::6056-:22 -boot order=
=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs=
/sda7/disk0-yocto-bens-4,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sda7/di=
sk1-yocto-bens-4,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sda7/disk2-yoct=
o-bens-4,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sda7/disk3-yocto-bens-4=
,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sda7/disk4-yocto-bens-4,media=
=3Ddisk,if=3Dvirtio -drive file=3D/fs/sda7/disk5-yocto-bens-4,media=3Ddisk,=
if=3Dvirtio -pidfile /dev/shm/kboot/pid-yocto-bens-4 -serial file:/dev/shm/=
kboot/serial-yocto-bens-4 -daemonize -display none -monitor null=20

--sdtB3X0nJg68CQEu
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-c5-02201550-837caba6587ab563ef3779429ddc9f49adb6b6fc-SyS_sched_setaffinity+-x-23380.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDZkMGFiZWNhMzI0MmE4OGNhYjgyMzJlNGFjZDdlMmJmMDg4ZjNiYzIK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jNS0w
MjIwMTU1MC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAyMjAxNTo2ZDBhYmVjYTMy
NDJhODhjYWI4MjMyZTRhY2Q3ZTJiZjA4OGYzYmMyOmJpc2VjdC1saW51eAoKMjAxNC0wMi0y
MS0wNTo0MDo0NSA2ZDBhYmVjYTMyNDJhODhjYWI4MjMyZTRhY2Q3ZTJiZjA4OGYzYmMyIGNv
bXBpbGluZwoyMDAgcmVhbCAgMjgyMyB1c2VyICAyMTIgc3lzICAxNTE0LjAxJSBjcHUgCWkz
ODYtcmFuZGNvbmZpZy1jNS0wMjIwMTU1MAoKMjAxNC0wMi0yMS0wNTo0NDo1MyBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmMzLi4JMQkxNi4uLi4uLi4uLi4uLi4uCTE5LgkyMCBT
VUNDRVNTCgpiaXNlY3Q6IGdvb2QgY29tbWl0IDZkMGFiZWNhMzI0MmE4OGNhYjgyMzJlNGFj
ZDdlMmJmMDg4ZjNiYzIKZ2l0IGJpc2VjdCBzdGFydCA4MzdjYWJhNjU4N2FiNTYzZWYzNzc5
NDI5ZGRjOWY0OWFkYjZiNmZjIDZkMGFiZWNhMzI0MmE4OGNhYjgyMzJlNGFjZDdlMmJmMDg4
ZjNiYzIgLS0KL2Mva2VybmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6IFsiLWIiLCAiODM3Y2Fi
YTY1ODdhYjU2M2VmMzc3OTQyOWRkYzlmNDlhZGI2YjZmYyIsICItZyIsICI2ZDBhYmVjYTMy
NDJhODhjYWI4MjMyZTRhY2Q3ZTJiZjA4OGYzYmMyIiwgIi9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2giLCAiL2tlcm5lbC10ZXN0cy9saW51eC9vYmotYmlz
ZWN0Il0KQmlzZWN0aW5nOiAyNDU4IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSAxMiBzdGVwcykKW2EyNzY5ZDA4MDM3ZmRiYjM1MzNkOTE2YTY1ZTY0ZDU1
ZTAyN2U5OWNdIE1lcmdlICdzcGFyYy9tYXN0ZXInIGludG8gZGV2ZWwtaG91cmx5LTIwMTQw
MjIwMTUKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9rZXJuZWwtdGVzdHMvbGludXgvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWM1LTAyMjAxNTUwL2xpbnV4LWRldmVs
OmRldmVsLWhvdXJseS0yMDE0MDIyMDE1OmEyNzY5ZDA4MDM3ZmRiYjM1MzNkOTE2YTY1ZTY0
ZDU1ZTAyN2U5OWM6YmlzZWN0LWxpbnV4CgoyMDE0LTAyLTIxLTA1OjU1OjMwIGEyNzY5ZDA4
MDM3ZmRiYjM1MzNkOTE2YTY1ZTY0ZDU1ZTAyN2U5OWMgY29tcGlsaW5nCjE2MCByZWFsICAy
ODAwIHVzZXIgIDIwNCBzeXMgIDE4NzMuMjUlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWM1LTAy
MjAxNTUwCgoyMDE0LTAyLTIxLTA1OjU4OjMzIGRldGVjdGluZyBib290IHN0YXRlIDMuMTQu
MC1yYzMtMDEwNTQtZ2EyNzY5ZDAuLi4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxNDA0IHJl
dmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMSBzdGVwcykKWzFi
MmExNjQzYTM5ZDUyZGZkOGNlYTc5YmU5MjAyYmZlMDA4NTIxNjZdIE1lcmdlICdhcm0tdGVn
cmEvZm9yLW5leHQnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwMjIwMTUKcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMv
bGludXgvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4
Ni1yYW5kY29uZmlnLWM1LTAyMjAxNTUwL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0
MDIyMDE1OjFiMmExNjQzYTM5ZDUyZGZkOGNlYTc5YmU5MjAyYmZlMDA4NTIxNjY6YmlzZWN0
LWxpbnV4CgoyMDE0LTAyLTIxLTA2OjAwOjM1IDFiMmExNjQzYTM5ZDUyZGZkOGNlYTc5YmU5
MjAyYmZlMDA4NTIxNjYgY29tcGlsaW5nCjE1MCByZWFsICAyODM0IHVzZXIgIDIxMyBzeXMg
IDIwMzIuMjAlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWM1LTAyMjAxNTUwCgoyMDE0LTAyLTIx
LTA2OjAzOjI2IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzMtMDE3MzctZzFiMmEx
NjQuLi4JMTkuLi4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA3MjEgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEwIHN0ZXBzKQpbM2U4YzZhYzJmYzI2ZDE5
NzYxNjRlZjBlZDU4OGRkZjMxOWVhMWFlNF0gTWVyZ2UgJ3NoYXduZ3VvL2lteDYvZHQnIGlu
dG8gZGV2ZWwtaG91cmx5LTIwMTQwMjIwMTUKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlz
ZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXgvb2JqLWJpc2Vj
dApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWM1
LTAyMjAxNTUwL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDIyMDE1OjNlOGM2YWMy
ZmMyNmQxOTc2MTY0ZWYwZWQ1ODhkZGYzMTllYTFhZTQ6YmlzZWN0LWxpbnV4CgoyMDE0LTAy
LTIxLTA2OjA3OjMzIDNlOGM2YWMyZmMyNmQxOTc2MTY0ZWYwZWQ1ODhkZGYzMTllYTFhZTQg
Y29tcGlsaW5nCjY2IHJlYWwgIDk3OCB1c2VyICA3MyBzeXMgIDE1ODIuNjUlIGNwdSAJaTM4
Ni1yYW5kY29uZmlnLWM1LTAyMjAxNTUwCgoyMDE0LTAyLTIxLTA2OjA5OjA2IGRldGVjdGlu
ZyBib290IHN0YXRlIDMuMTQuMC1yYzMtMDIzNTEtZzNlOGM2YWMuLgkxCTE2Li4JMTcJMTgu
CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMTA3IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSA3IHN0ZXBzKQpbYzhhNzk4ZmJkNTZlN2RlYzljZWE2NmE1NWM5
NjQ0ZDFjZWU1MWNjZV0gTWVyZ2UgJ25tZW5vbi9wdXNoL3ZvbHRkbS1ub3RpZmllci12MScg
aW50byBkZXZlbC1ob3VybHktMjAxNDAyMjAxNQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eC9vYmotYmlz
ZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
YzUtMDIyMDE1NTAvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMjIwMTU6YzhhNzk4
ZmJkNTZlN2RlYzljZWE2NmE1NWM5NjQ0ZDFjZWU1MWNjZTpiaXNlY3QtbGludXgKCjIwMTQt
MDItMjEtMDY6MTQ6MDcgYzhhNzk4ZmJkNTZlN2RlYzljZWE2NmE1NWM5NjQ0ZDFjZWU1MWNj
ZSBjb21waWxpbmcKMzYgcmVhbCAgMjA0IHVzZXIgIDIyIHN5cyAgNjE0LjA2JSBjcHUgCWkz
ODYtcmFuZGNvbmZpZy1jNS0wMjIwMTU1MAoKMjAxNC0wMi0yMS0wNjoxNTowNiBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmMzLTAyMzY5LWdjOGE3OThmLi4uCTE4Li4uCTE5CTIw
IFNVQ0NFU1MKCkJpc2VjdGluZzogODkgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0
aGlzIChyb3VnaGx5IDcgc3RlcHMpCltkNzUzYmFkMjE2MTJmMmUxZWU3ZTdmYTE2NzUzYWFj
NDgzZjgwMzZmXSBNZXJnZSAnY2dyb3VwL3Jldmlldy1taWdyYXRpb24tdXBkYXRlLXYyJyBp
bnRvIGRldmVsLWhvdXJseS0yMDE0MDIyMDE1CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4L29iai1iaXNl
Y3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1j
NS0wMjIwMTU1MC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAyMjAxNTpkNzUzYmFk
MjE2MTJmMmUxZWU3ZTdmYTE2NzUzYWFjNDgzZjgwMzZmOmJpc2VjdC1saW51eAoKMjAxNC0w
Mi0yMS0wNjoxOTozOSBkNzUzYmFkMjE2MTJmMmUxZWU3ZTdmYTE2NzUzYWFjNDgzZjgwMzZm
IGNvbXBpbGluZwoxNDYgcmVhbCAgMTAxOSB1c2VyICA3MSBzeXMgIDc0My43OSUgY3B1IAlp
Mzg2LXJhbmRjb25maWctYzUtMDIyMDE1NTAKCjIwMTQtMDItMjEtMDY6MjM6MzIgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjMy0wMjQzMy1nZDc1M2JhZC4uLiBURVNUIEZBSUxV
UkUKWyAgIDE4LjQ4OTYzN10gaXJkYV9zZXRzb2Nrb3B0OiBub3QgYWxsb3dlZCB0byBzZXQg
TUFYU0RVU0laRSBmb3IgdGhpcyBzb2NrZXQgdHlwZSEKWyAgIDE5LjYwOTQxOF0gClsgICAx
OS42MDk3MTNdID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KWyAgIDE5LjYxMDMy
M10gWyBJTkZPOiBzdXNwaWNpb3VzIFJDVSB1c2FnZS4gXQpbICAgMTkuNjExMDg0XSAzLjE0
LjAtcmMzLTAyNDMzLWdkNzUzYmFkICMyOCBOb3QgdGFpbnRlZApbICAgMTkuNjExODQzXSAt
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tClsgICAxOS42MTI0ODhdIC9rZXJuZWwt
dGVzdHMvbGludXgvaW5jbHVkZS9saW51eC9jZ3JvdXAuaDo2OTcgc3VzcGljaW91cyByY3Vf
ZGVyZWZlcmVuY2VfY2hlY2soKSB1c2FnZSEKWyAgIDE5LjYxMzg5M10gClsgICAxOS42MTM4
OTNdIG90aGVyIGluZm8gdGhhdCBtaWdodCBoZWxwIHVzIGRlYnVnIHRoaXM6ClsgICAxOS42
MTM4OTNdIApbICAgMTkuNjE1ODExXSAKWyAgIDE5LjYxNTgxMV0gcmN1X3NjaGVkdWxlcl9h
Y3RpdmUgPSAxLCBkZWJ1Z19sb2NrcyA9IDAKWyAgIDE5LjYxNjc4Ml0gMiBsb2NrcyBoZWxk
IGJ5IHRyaW5pdHktYzAvNDM0MDoKWyAgIDE5LjYxNzc2MF0gICMwOiAgKGNhbGxiYWNrX211
dGV4KXsrLisuLi59LCBhdDogWzw4MTExODQ2Nj5dIGNwdXNldF9jcHVzX2FsbG93ZWQrMHgx
ZS8weDEyMwpbICAgMTkuNjE5MzAzXSAgIzE6ICAoJigmcC0+YWxsb2NfbG9jayktPnJsb2Nr
KXsrLisuLi59LCBhdDogWzw4MTExODQ2ZD5dIGNwdXNldF9jcHVzX2FsbG93ZWQrMHgyNS8w
eDEyMwpbICAgMTkuNjIwODQ4XSAKWyAgIDE5LjYyMDg0OF0gc3RhY2sgYmFja3RyYWNlOgpb
ICAgMTkuNjIxNDkwXSBDUFU6IDAgUElEOiA0MzQwIENvbW06IHRyaW5pdHktYzAgTm90IHRh
aW50ZWQgMy4xNC4wLXJjMy0wMjQzMy1nZDc1M2JhZCAjMjgKWyAgIDE5LjYyMjc2M10gIDAw
MDAwMDAwIDAwMDAwMDAwIDkzMWRiZjI4IDgxODc4YzFhIDAwMDAwMDAxIDAwMDAwMDAwIDkz
MWRiZjUwIDgxMGNkZjk0ClsgICAxOS42MjQyOTFdICA4MWMzZDA3OCA4MWM0YzE3NSAwMDAw
MDAwMSAwMDAwMDAwMCA5MzdiOGQ3MCA5MzdiOGQ3MCA5MzdiOTEyOCA4MjZkM2I4MApbICAg
MTkuNjI1NjQ4XSAgOTMxZGJmNjggODExMTg1NDQgOTMxZGJmODAgOTM3YjhkNzAgMDAwMDAw
MDAgOTMxZGJmOWMgOTMxZGJmOTQgODEwYjI0ZDIKWyAgIDE5LjYyNzEyMF0gQ2FsbCBUcmFj
ZToKWyAgIDE5LjYyNzU2MF0gIFs8ODE4NzhjMWE+XSBkdW1wX3N0YWNrKzB4N2UvMHhmMQpb
ICAgMTkuNjI4MjYwXSAgWzw4MTBjZGY5ND5dIGxvY2tkZXBfcmN1X3N1c3BpY2lvdXMrMHhm
Mi8weGZhClsgICAxOS42MjkwOTRdICBbPDgxMTE4NTQ0Pl0gY3B1c2V0X2NwdXNfYWxsb3dl
ZCsweGZjLzB4MTIzClsgICAxOS42Mjk5MDZdICBbPDgxMGIyNGQyPl0gc2NoZWRfc2V0YWZm
aW5pdHkrMHgzZmUvMHg1MDIKWyAgIDE5LjYzMDcxOF0gIFs8ODEwYjIwZDQ+XSA/IHNldF9j
cHVzX2FsbG93ZWRfcHRyKzB4MWQ2LzB4MWQ2ClsgICAxOS42MzE1NDVdICBbPDgxMGIyNjdi
Pl0gU3lTX3NjaGVkX3NldGFmZmluaXR5KzB4YTUvMHhhYgpbICAgMTkuNjMyMzU0XSAgWzw4
MTg4YTE0YT5dIHN5c2VudGVyX2RvX2NhbGwrMHgxMi8weDNjClsgICA2My44NzIwNTldIHNw
aW5fbG9jay10b3J0dXJlOiBXcml0ZXM6ICBUb3RhbDogNCAgTWF4L01pbjogMC8wICAgRmFp
bDogMCAKICogQXNraW5nIGFsbCByZW1haW5pbmcgcHJvY2Vzc2VzIHRvIHRlcm1pbmF0ZS4u
LiAgICAgICAKa2lsbGFsbDVbNDM2M106IG1vdW50IHJldHVybmVkIG5vbi16ZXJvIGV4aXQg
c3RhdHVzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAyMjAxNTUwL2Q3NTNiYWQyMTYx
MmYyZTFlZTdlN2ZhMTY3NTNhYWM0ODNmODAzNmYvZG1lc2ctcXVhbnRhbC14aWFuLTYxOjIw
MTQwMjIxMDYyNDU0OmkzODYtcmFuZGNvbmZpZy1jNS0wMjIwMTU1MDozLjE0LjAtcmMzLTAy
NDMzLWdkNzUzYmFkOjI4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAyMjAxNTUwL2Q3
NTNiYWQyMTYxMmYyZTFlZTdlN2ZhMTY3NTNhYWM0ODNmODAzNmYvZG1lc2ctcXVhbnRhbC14
aWFuLTYyOjIwMTQwMjIxMDYyNDUzOmkzODYtcmFuZGNvbmZpZy1jNS0wMjIwMTU1MDozLjE0
LjAtcmMzLTAyNDMzLWdkNzUzYmFkOjI4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAy
MjAxNTUwL2Q3NTNiYWQyMTYxMmYyZTFlZTdlN2ZhMTY3NTNhYWM0ODNmODAzNmYvZG1lc2ct
cXVhbnRhbC14aWFuLTM6MjAxNDAyMjEwNjI0NTY6aTM4Ni1yYW5kY29uZmlnLWM1LTAyMjAx
NTUwOjMuMTQuMC1yYzMtMDI0MzMtZ2Q3NTNiYWQ6MjgKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctYzUtMDIyMDE1NTAvZDc1M2JhZDIxNjEyZjJlMWVlN2U3ZmExNjc1M2FhYzQ4M2Y4MDM2
Zi9kbWVzZy15b2N0by14aWFuLTExOjIwMTQwMjIxMDYyNDU3OmkzODYtcmFuZGNvbmZpZy1j
NS0wMjIwMTU1MDozLjE0LjAtcmMzLTAyNDMzLWdkNzUzYmFkOjI4CjA6NDo0IGFsbF9nb29k
OmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTAyLTIxIDA2OjI1OjAzIFJFUEVBVCBD
T1VOVDogMjAgICMgL2tlcm5lbC10ZXN0cy9saW51eC9vYmotYmlzZWN0Ly5yZXBlYXQbWzBt
CgpsaW5lYXItYmlzZWN0OiBiYWQgYnJhbmNoIG1heSBiZSBjZ3JvdXAvcmV2aWV3LW1pZ3Jh
dGlvbi11cGRhdGUtdjIKbGluZWFyLWJpc2VjdDogaGFuZGxlIG92ZXIgdG8gZ2l0IGJpc2Vj
dApsaW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0IHN0YXJ0IGQ3NTNiYWQyMTYxMmYyZTFlZTdl
N2ZhMTY3NTNhYWM0ODNmODAzNmYgYzhhNzk4ZmJkNTZlN2RlYzljZWE2NmE1NWM5NjQ0ZDFj
ZWU1MWNjZSAtLQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBkNzUzYmFkLi4uIE1lcmdl
ICdjZ3JvdXAvcmV2aWV3LW1pZ3JhdGlvbi11cGRhdGUtdjInIGludG8gZGV2ZWwtaG91cmx5
LTIwMTQwMjIwMTUKSEVBRCBpcyBub3cgYXQgZjcxMTk0YS4uLiBNZXJnZSBicmFuY2ggJ3g4
Ni91cmdlbnQnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVs
L2dpdC90aXAvdGlwCkJpc2VjdGluZzogMzEgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRl
ciB0aGlzIChyb3VnaGx5IDUgc3RlcHMpCls4MGIxMzU4Njk5N2Q4ZTU4NGNhYTc3MmJkOTll
MmEzZTU1YWM2YWJlXSBjZ3JvdXA6IHJlbG9jYXRlIGNncm91cF9ybV9jZnR5cGVzKCkKbGlu
ZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4L29iai1iaXNlY3QKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwt
dGVzdHMvbGludXgvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0vaTM4Ni1yYW5kY29uZmlnLWM1LTAyMjAxNTUwL2xpbnV4LWRldmVsOmRldmVsLWhvdXJs
eS0yMDE0MDIyMDE1OjgwYjEzNTg2OTk3ZDhlNTg0Y2FhNzcyYmQ5OWUyYTNlNTVhYzZhYmU6
YmlzZWN0LWxpbnV4CgoyMDE0LTAyLTIxLTA2OjI1OjEyIDgwYjEzNTg2OTk3ZDhlNTg0Y2Fh
NzcyYmQ5OWUyYTNlNTVhYzZhYmUgY29tcGlsaW5nCjI0OSByZWFsICAyODIxIHVzZXIgIDIw
OCBzeXMgIDEyMTMuOTIlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWM1LTAyMjAxNTUwCgoyMDE0
LTAyLTIxLTA2OjMwOjQ4IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzEtMDAwNTYt
ZzgwYjEzNTguLi4JMgkxNQkxNy4JMTkJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxNSByZXZp
c2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNCBzdGVwcykKWzg4OWVk
OWNlYWE5N2JiMDJiZjVkNzM0OWUyNDYzOWY3ZmM1ZjRmYTBdIGNncm91cDogcmVtb3ZlIGNz
c19zY2FuX3Rhc2tzKCkKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXgvb2JqLWJpc2VjdApscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWM1LTAyMjAxNTUwL2xp
bnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDIyMDE1Ojg4OWVkOWNlYWE5N2JiMDJiZjVk
NzM0OWUyNDYzOWY3ZmM1ZjRmYTA6YmlzZWN0LWxpbnV4CgoyMDE0LTAyLTIxLTA2OjM1OjIw
IDg4OWVkOWNlYWE5N2JiMDJiZjVkNzM0OWUyNDYzOWY3ZmM1ZjRmYTAgY29tcGlsaW5nCjY4
IHJlYWwgIDEwMTkgdXNlciAgNzMgc3lzICAxNjA1LjA4JSBjcHUgCWkzODYtcmFuZGNvbmZp
Zy1jNS0wMjIwMTU1MAoKMjAxNC0wMi0yMS0wNjozNjo1MCBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAzLjE0LjAtcmMxLTAwMDcyLWc4ODllZDljLi4uCTE4Li4uLi4uLi4uLi4uLi4uLi4uLi4J
MTkJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA3IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbNDllZjY4YWQ4MmVmZWI2MGYyODNlZjU2NTI3
YWI4OTY5YzdlOTI3Yl0gY2dyb3VwOiB1cGRhdGUgY2dyb3VwX2VuYWJsZV90YXNrX2NnX2xp
c3RzKCkgdG8gZ3JhYiBzaWdsb2NrCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4L29iai1iaXNlY3QKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jNS0wMjIw
MTU1MC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAyMjAxNTo0OWVmNjhhZDgyZWZl
YjYwZjI4M2VmNTY1MjdhYjg5NjljN2U5MjdiOmJpc2VjdC1saW51eAoKMjAxNC0wMi0yMS0w
Njo0OTo1MSA0OWVmNjhhZDgyZWZlYjYwZjI4M2VmNTY1MjdhYjg5NjljN2U5MjdiIGNvbXBp
bGluZwo2OSByZWFsICAxMDEyIHVzZXIgIDcyIHN5cyAgMTU2MS4zNSUgY3B1IAlpMzg2LXJh
bmRjb25maWctYzUtMDIyMDE1NTAKCjIwMTQtMDItMjEtMDY6NTE6MTUgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgMy4xNC4wLXJjMS0wMDA4MC1nNDllZjY4YS4uLgkxNy4uLi4uLi4uLi4uLi4u
Li4uLgkxOAkxOS4uLi4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAzIHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAyIHN0ZXBzKQpbZmI2ZWZiMDFkODgwZTlk
Y2JkMTk4NjFhYmQyOGY1NWJmMDYxMTE2ZF0gY2dyb3VwOiBzcGxpdCBwcm9jZXNzIC8gdGFz
ayBtaWdyYXRpb24gaW50byBmb3VyIHN0ZXBzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4L29iai1iaXNl
Y3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1j
NS0wMjIwMTU1MC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAyMjAxNTpmYjZlZmIw
MWQ4ODBlOWRjYmQxOTg2MWFiZDI4ZjU1YmYwNjExMTZkOmJpc2VjdC1saW51eAoKMjAxNC0w
Mi0yMS0wNzowNTo0NiBmYjZlZmIwMWQ4ODBlOWRjYmQxOTg2MWFiZDI4ZjU1YmYwNjExMTZk
IGNvbXBpbGluZwo2NiByZWFsICA5OTUgdXNlciAgNzMgc3lzICAxNjA0LjE0JSBjcHUgCWkz
ODYtcmFuZGNvbmZpZy1jNS0wMjIwMTU1MAoKMjAxNC0wMi0yMS0wNzowNzoxNiBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmMxLTAwMDg0LWdmYjZlZmIwLi4JOAkxOC4uLi4uLi4u
Li4uLi4uLi4uLi4uCTE5CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMSByZXZpc2lvbiBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0ZXApCltmYjQ3ZmVhN2E1OWNmM2Q2
Mzg3YzU2NjA4NGE2Njg0YjUwMDVhZjgzXSBjZ3JvdXA6IGRyb3AgdGFza19sb2NrKCkgcHJv
dGVjdGlvbiBhcm91bmQgdGFzay0+Y2dyb3VwcwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eC9vYmotYmlz
ZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
YzUtMDIyMDE1NTAvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMjIwMTU6ZmI0N2Zl
YTdhNTljZjNkNjM4N2M1NjYwODRhNjY4NGI1MDA1YWY4MzpiaXNlY3QtbGludXgKCjIwMTQt
MDItMjEtMDc6MjA6MTcgZmI0N2ZlYTdhNTljZjNkNjM4N2M1NjYwODRhNjY4NGI1MDA1YWY4
MyBjb21waWxpbmcKNjYgcmVhbCAgMTAwOSB1c2VyICA3MyBzeXMgIDE2MjYuNTYlIGNwdSAJ
aTM4Ni1yYW5kY29uZmlnLWM1LTAyMjAxNTUwCgoyMDE0LTAyLTIxLTA3OjIxOjQ4IGRldGVj
dGluZyBib290IHN0YXRlIDMuMTQuMC1yYzEtMDAwODYtZ2ZiNDdmZWEuLi4uIFRFU1QgRkFJ
TFVSRQpbICAgMjIuMjY1MjMyXSBpcmRhX3NldHNvY2tvcHQ6IG5vdCBhbGxvd2VkIHRvIHNl
dCBNQVhTRFVTSVpFIGZvciB0aGlzIHNvY2tldCB0eXBlIQpbICAgMjQuMjQwMjcyXSAKWyAg
IDI0LjI0MDQ4OV0gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQpbICAgMjQuMjQw
OTQxXSBbIElORk86IHN1c3BpY2lvdXMgUkNVIHVzYWdlLiBdClsgICAyNC4yNDEzNzFdIDMu
MTQuMC1yYzEtMDAwODYtZ2ZiNDdmZWEgIzMzIE5vdCB0YWludGVkClsgICAyNC4yNDE4OThd
IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KWyAgIDI0LjI0MjMzMl0gL2tlcm5l
bC10ZXN0cy9saW51eC9pbmNsdWRlL2xpbnV4L2Nncm91cC5oOjY5NyBzdXNwaWNpb3VzIHJj
dV9kZXJlZmVyZW5jZV9jaGVjaygpIHVzYWdlIQpbICAgMjQuMjQzMjY0XSAKWyAgIDI0LjI0
MzI2NF0gb3RoZXIgaW5mbyB0aGF0IG1pZ2h0IGhlbHAgdXMgZGVidWcgdGhpczoKWyAgIDI0
LjI0MzI2NF0gClsgICAyNC4yNDQwOTJdIApbICAgMjQuMjQ0MDkyXSByY3Vfc2NoZWR1bGVy
X2FjdGl2ZSA9IDEsIGRlYnVnX2xvY2tzID0gMApbICAgMjQuMjQ0NzYwXSAyIGxvY2tzIGhl
bGQgYnkgdHJpbml0eS1jMS80Mjg1OgpbICAgMjQuMjQ1MjEyXSAgIzA6ICAoY2FsbGJhY2tf
bXV0ZXgpeysuKy4uLn0sIGF0OiBbPDgxMTE3YzVjPl0gY3B1c2V0X2NwdXNfYWxsb3dlZCsw
eDFlLzB4MTIzClsgICAyNC4yNDYyMDVdICAjMTogICgmKCZwLT5hbGxvY19sb2NrKS0+cmxv
Y2speysuKy4uLn0sIGF0OiBbPDgxMTE3YzYzPl0gY3B1c2V0X2NwdXNfYWxsb3dlZCsweDI1
LzB4MTIzClsgICAyNC4yNDcyMzhdIApbICAgMjQuMjQ3MjM4XSBzdGFjayBiYWNrdHJhY2U6
ClsgICAyNC4yNDc2NzldIENQVTogMCBQSUQ6IDQyODUgQ29tbTogdHJpbml0eS1jMSBOb3Qg
dGFpbnRlZCAzLjE0LjAtcmMxLTAwMDg2LWdmYjQ3ZmVhICMzMwpbICAgMjQuMjQ4NDk1XSAg
MDAwMDAwMDAgMDAwMDAwMDAgODAwNzVmMjggODE4NzMxYzUgMDAwMDAwMDEgMDAwMDAwMDAg
ODAwNzVmNTAgODEwY2UwZGIKWyAgIDI0LjI0OTQzNF0gIDgxYzMyYzJkIDgxYzQxNDdkIDAw
MDAwMDAxIDAwMDAwMDAwIDkzMGIyODUwIDkzMGIyODUwIDkzMGIyYzA4IDgyNmM2YjAwClsg
ICAyNC4yNTAzMzVdICA4MDA3NWY2OCA4MTExN2QzYSA4MDA3NWY4MCA5MzBiMjg1MCAwMDAw
MDAwMCA4MDA3NWY5YyA4MDA3NWY5NCA4MTBiMjYxOQpbICAgMjQuMjUxMjMxXSBDYWxsIFRy
YWNlOgpbICAgMjQuMjUxNTA4XSAgWzw4MTg3MzFjNT5dIGR1bXBfc3RhY2srMHg3ZS8weGYx
ClsgICAyNC4yNTE5NzhdICBbPDgxMGNlMGRiPl0gbG9ja2RlcF9yY3Vfc3VzcGljaW91cysw
eGYyLzB4ZmEKWyAgIDI0LjI1MjUyMl0gIFs8ODExMTdkM2E+XSBjcHVzZXRfY3B1c19hbGxv
d2VkKzB4ZmMvMHgxMjMKWyAgIDI0LjI1MzA2Ml0gIFs8ODEwYjI2MTk+XSBzY2hlZF9zZXRh
ZmZpbml0eSsweDNmZS8weDUwMgpbICAgMjQuMjUzNTg0XSAgWzw4MTBiMjIxYj5dID8gc2V0
X2NwdXNfYWxsb3dlZF9wdHIrMHgxZDYvMHgxZDYKWyAgIDI0LjI1NDE2Ml0gIFs8ODEwYjI3
YzI+XSBTeVNfc2NoZWRfc2V0YWZmaW5pdHkrMHhhNS8weGFiClsgICAyNC4yNTQ3MDVdICBb
PDgxODg0MGNhPl0gc3lzZW50ZXJfZG9fY2FsbCsweDEyLzB4M2MKICogQXNraW5nIGFsbCBy
ZW1haW5pbmcgcHJvY2Vzc2VzIHRvIHRlcm1pbmF0ZS4uLiAgICAgICAKa2lsbGFsbDVbNDMw
N106IG1vdW50IHJldHVybmVkIG5vbi16ZXJvIGV4aXQgc3RhdHVzCmtpbGxhbGw1WzQzMDdd
OiAvcHJvYyBub3QgbW91bnRlZCwgZmFpbGVkIHRvIG1vdW50Lgova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1jNS0wMjIwMTU1MC9mYjQ3ZmVhN2E1OWNmM2Q2Mzg3YzU2NjA4NGE2Njg0YjUw
MDVhZjgzL2RtZXNnLXF1YW50YWwtYXRoZW5zLTIzOjIwMTQwMjIxMDcyMzIwOmkzODYtcmFu
ZGNvbmZpZy1jNS0wMjIwMTU1MDozLjE0LjAtcmMxLTAwMDg2LWdmYjQ3ZmVhOjMzCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAyMjAxNTUwL2ZiNDdmZWE3YTU5Y2YzZDYzODdjNTY2
MDg0YTY2ODRiNTAwNWFmODMvZG1lc2ctcXVhbnRhbC1jYWlyby0zMDoyMDE0MDIyMTA3MjMx
MjppMzg2LXJhbmRjb25maWctYzUtMDIyMDE1NTA6My4xNC4wLXJjMS0wMDA4Ni1nZmI0N2Zl
YTozMwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0wMjIwMTU1MC9mYjQ3ZmVhN2E1OWNm
M2Q2Mzg3YzU2NjA4NGE2Njg0YjUwMDVhZjgzL2RtZXNnLXF1YW50YWwtc25iLTE2OjIwMTQw
MjIxMDcyMzE2OmkzODYtcmFuZGNvbmZpZy1jNS0wMjIwMTU1MDo6Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWM1LTAyMjAxNTUwL2ZiNDdmZWE3YTU5Y2YzZDYzODdjNTY2MDg0YTY2ODRi
NTAwNWFmODMvZG1lc2ctcXVhbnRhbC14aWFuLTYwOjIwMTQwMjIxMDcyMzIwOmkzODYtcmFu
ZGNvbmZpZy1jNS0wMjIwMTU1MDozLjE0LjAtcmMxLTAwMDg2LWdmYjQ3ZmVhOjMzCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAyMjAxNTUwL2ZiNDdmZWE3YTU5Y2YzZDYzODdjNTY2
MDg0YTY2ODRiNTAwNWFmODMvZG1lc2cteW9jdG8tYXRoZW5zLTE0OjIwMTQwMjIxMDcyMzE0
OmkzODYtcmFuZGNvbmZpZy1jNS0wMjIwMTU1MDozLjE0LjAtcmMxLTAwMDg2LWdmYjQ3ZmVh
OjMzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAyMjAxNTUwL2ZiNDdmZWE3YTU5Y2Yz
ZDYzODdjNTY2MDg0YTY2ODRiNTAwNWFmODMvZG1lc2cteW9jdG8tYXRoZW5zLTM3OjIwMTQw
MjIxMDcyMzE1OmkzODYtcmFuZGNvbmZpZy1jNS0wMjIwMTU1MDozLjE0LjAtcmMxLTAwMDg2
LWdmYjQ3ZmVhOjMzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAyMjAxNTUwL2ZiNDdm
ZWE3YTU5Y2YzZDYzODdjNTY2MDg0YTY2ODRiNTAwNWFmODMvZG1lc2cteW9jdG8tYmVucy0x
OjIwMTQwMjIxMDcyMzE4OmkzODYtcmFuZGNvbmZpZy1jNS0wMjIwMTU1MDozLjE0LjAtcmMx
LTAwMDg2LWdmYjQ3ZmVhOjMzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAyMjAxNTUw
L2ZiNDdmZWE3YTU5Y2YzZDYzODdjNTY2MDg0YTY2ODRiNTAwNWFmODMvZG1lc2cteW9jdG8t
aW5uLTExOjIwMTQwMjIxMDcyMzEzOmkzODYtcmFuZGNvbmZpZy1jNS0wMjIwMTU1MDo6Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAyMjAxNTUwL2ZiNDdmZWE3YTU5Y2YzZDYzODdj
NTY2MDg0YTY2ODRiNTAwNWFmODMvZG1lc2cteW9jdG8taW5uLTE2OjIwMTQwMjIxMDcyMzE0
OmkzODYtcmFuZGNvbmZpZy1jNS0wMjIwMTU1MDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWM1LTAyMjAxNTUwL2ZiNDdmZWE3YTU5Y2YzZDYzODdjNTY2MDg0YTY2ODRiNTAwNWFmODMv
ZG1lc2cteW9jdG8taW5uLTMzOjIwMTQwMjIxMDcyMzE0OmkzODYtcmFuZGNvbmZpZy1jNS0w
MjIwMTU1MDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAyMjAxNTUwL2ZiNDdmZWE3
YTU5Y2YzZDYzODdjNTY2MDg0YTY2ODRiNTAwNWFmODMvZG1lc2cteW9jdG8teGlhbi0yMToy
MDE0MDIyMTA3MjMxMzppMzg2LXJhbmRjb25maWctYzUtMDIyMDE1NTA6My4xNC4wLXJjMS0w
MDA4Ni1nZmI0N2ZlYTozMwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0wMjIwMTU1MC9m
YjQ3ZmVhN2E1OWNmM2Q2Mzg3YzU2NjA4NGE2Njg0YjUwMDVhZjgzL2RtZXNnLXlvY3RvLXhp
YW4tNDc6MjAxNDAyMjEwNzIzMTY6aTM4Ni1yYW5kY29uZmlnLWM1LTAyMjAxNTUwOjMuMTQu
MC1yYzEtMDAwODYtZ2ZiNDdmZWE6MzMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzUtMDIy
MDE1NTAvZmI0N2ZlYTdhNTljZjNkNjM4N2M1NjYwODRhNjY4NGI1MDA1YWY4My9kbWVzZy15
b2N0by14Z3dvLTU6MjAxNDAyMjEwNzIzMjI6aTM4Ni1yYW5kY29uZmlnLWM1LTAyMjAxNTUw
OjMuMTQuMC1yYzEtMDAwODYtZ2ZiNDdmZWE6MzMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YzUtMDIyMDE1NTAvZmI0N2ZlYTdhNTljZjNkNjM4N2M1NjYwODRhNjY4NGI1MDA1YWY4My9k
bWVzZy1xdWFudGFsLWpha2V0b3duLTE6MjAxNDAyMjEwNzIzMzI6aTM4Ni1yYW5kY29uZmln
LWM1LTAyMjAxNTUwOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzUtMDIyMDE1NTAvZmI0
N2ZlYTdhNTljZjNkNjM4N2M1NjYwODRhNjY4NGI1MDA1YWY4My9kbWVzZy15b2N0by1qYWtl
dG93bi0xNjoyMDE0MDIyMTA3MjMyNzppMzg2LXJhbmRjb25maWctYzUtMDIyMDE1NTA6Ogow
OjE1OjE1IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTAyLTIxIDA3
OjIzOjQ5IFJFUEVBVCBDT1VOVDogMjAgICMgL2tlcm5lbC10ZXN0cy9saW51eC9vYmotYmlz
ZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMpCltkNTM2ZGFmZGZiM2ZlODhiMmM5ZTM1Mjg0
Y2E2MmQ0NzM5NTg5Zjg3XSBjZ3JvdXA6IHVwZGF0ZSBob3cgYSBuZXdseSBmb3JrZWQgdGFz
ayBnZXRzIGFzc29jaWF0ZWQgd2l0aCBjc3Nfc2V0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4L29iai1i
aXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZp
Zy1jNS0wMjIwMTU1MC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAyMjAxNTpkNTM2
ZGFmZGZiM2ZlODhiMmM5ZTM1Mjg0Y2E2MmQ0NzM5NTg5Zjg3OmJpc2VjdC1saW51eAoKMjAx
NC0wMi0yMS0wNzoyMzo1MCBkNTM2ZGFmZGZiM2ZlODhiMmM5ZTM1Mjg0Y2E2MmQ0NzM5NTg5
Zjg3IGNvbXBpbGluZwoxMDcgcmVhbCAgMTAwNyB1c2VyICA3MyBzeXMgIDEwMDMuMzAlIGNw
dSAJaTM4Ni1yYW5kY29uZmlnLWM1LTAyMjAxNTUwCgoyMDE0LTAyLTIxLTA3OjI1OjU3IGRl
dGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzEtMDAwODUtZ2Q1MzZkYWYuLi4JNAkxNwkx
OC4uLi4uLi4uLi4uLi4uLi4uCTIwIFNVQ0NFU1MKCmZiNDdmZWE3YTU5Y2YzZDYzODdjNTY2
MDg0YTY2ODRiNTAwNWFmODMgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQKY29tbWl0IGZiNDdm
ZWE3YTU5Y2YzZDYzODdjNTY2MDg0YTY2ODRiNTAwNWFmODMKQXV0aG9yOiBUZWp1biBIZW8g
PHRqQGtlcm5lbC5vcmc+CkRhdGU6ICAgVGh1IEZlYiAxMyAxNToxNjozNSAyMDE0IC0wNTAw
CgogICAgY2dyb3VwOiBkcm9wIHRhc2tfbG9jaygpIHByb3RlY3Rpb24gYXJvdW5kIHRhc2st
PmNncm91cHMKICAgIAogICAgRm9yIG9wdGltaXphdGlvbiwgdGFza19sb2NrKCkgaXMgYWRk
aXRpb25hbGx5IHVzZWQgdG8gcHJvdGVjdAogICAgdGFzay0+Y2dyb3Vwcy4gIFRoZSBvcHRp
bWl6YXRpb24gaXMgcHJldHR5IGR1YmlvdXMgYXMgZWl0aGVyCiAgICBjc3Nfc2V0X3J3c2Vt
IGlzIGdyYWJiZWQgYW55d2F5IG9yIFBGX0VYSVRJTkcgYWxyZWFkeSBwcm90ZWN0cwogICAg
dGFzay0+Y2dyb3Vwcy4gIEl0IGFkZHMgb25seSBvdmVyaGVhZCBhbmQgY29uZnVzaW9uIGF0
IHRoaXMgcG9pbnQuCiAgICBMZXQncyBkcm9wIHRhc2tfW3VuXWxvY2soKSBhbmQgdXBkYXRl
IGNvbW1lbnRzIGFjY29yZGluZ2x5LgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBUZWp1biBI
ZW8gPHRqQGtlcm5lbC5vcmc+Cgo6MDQwMDAwIDA0MDAwMCAwMWM2YzdjNTFhNDk5OWNmOTIy
ZWI4YmY1OGNkN2I0YTc2M2NiYTIzIGM3ZTE1MmRiODdiNWFiNTgyNzkyMjQ3ZTk0NzRlZjJl
MWFhNDQwZGUgTQlpbmNsdWRlCjowNDAwMDAgMDQwMDAwIDQyZTg2M2FkZmM3ZWMyYjAzM2E5
MTNlMzgyMDg3OGY2NTY0YTA2OWEgMTM3NDlkYWY0YzgzNTFhY2JlYzkwM2RkZDljZmZlOTBk
ODMzOTFjNSBNCWtlcm5lbApiaXNlY3QgcnVuIHN1Y2Nlc3MKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jNS0wMjIwMTU1MC9saW51eC1kZXZl
bDpkZXZlbC1ob3VybHktMjAxNDAyMjAxNTpkNTM2ZGFmZGZiM2ZlODhiMmM5ZTM1Mjg0Y2E2
MmQ0NzM5NTg5Zjg3OmJpc2VjdC1saW51eAoKMjAxNC0wMi0yMS0wNzozNzo1OCBkNTM2ZGFm
ZGZiM2ZlODhiMmM5ZTM1Mjg0Y2E2MmQ0NzM5NTg5Zjg3IHJldXNlIC9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWM1LTAyMjAxNTUwL2Q1MzZkYWZkZmIzZmU4OGIyYzllMzUyODRjYTYyZDQ3
Mzk1ODlmODcvdm1saW51ei0zLjE0LjAtcmMxLTAwMDg1LWdkNTM2ZGFmCgoyMDE0LTAyLTIx
LTA3OjM3OjU4IGRldGVjdGluZyBib290IHN0YXRlIC4uCTEJMgkxMAk0NQk0Ni4uLi4uLi4u
Li4JNDgJNDkJNTYJNTgJNjAgU1VDQ0VTUwoKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jNS0wMjIwMTU1MC9saW51eC1kZXZlbDpkZXZlbC1o
b3VybHktMjAxNDAyMjAxNTo4MzdjYWJhNjU4N2FiNTYzZWYzNzc5NDI5ZGRjOWY0OWFkYjZi
NmZjOmJpc2VjdC1saW51eAogVEVTVCBGQUlMVVJFClsgICAyMC45MDMzMzhdIGlyZGFfc2V0
c29ja29wdDogbm90IGFsbG93ZWQgdG8gc2V0IE1BWFNEVVNJWkUgZm9yIHRoaXMgc29ja2V0
IHR5cGUhClsgICAyMy41NjAzMDldIApbICAgMjMuNTYwNTYzXSA9PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09ClsgICAyMy41NjExNDldIFsgSU5GTzogc3VzcGljaW91cyBSQ1Ug
dXNhZ2UuIF0KWyAgIDIzLjU2MTY5MV0gMy4xNC4wLXJjMy0wMjQ1OC1nODM3Y2FiYSAjMiBO
b3QgdGFpbnRlZApbICAgMjMuNTYyMzIyXSAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tClsgICAyMy41NjI4MzhdIGluY2x1ZGUvbGludXgvY2dyb3VwLmg6Njk3IHN1c3BpY2lv
dXMgcmN1X2RlcmVmZXJlbmNlX2NoZWNrKCkgdXNhZ2UhClsgICAyMy41NjQxODhdIApbICAg
MjMuNTY0MTg4XSBvdGhlciBpbmZvIHRoYXQgbWlnaHQgaGVscCB1cyBkZWJ1ZyB0aGlzOgpb
ICAgMjMuNTY0MTg4XSAKWyAgIDIzLjU2NTIxOV0gClsgICAyMy41NjUyMTldIHJjdV9zY2hl
ZHVsZXJfYWN0aXZlID0gMSwgZGVidWdfbG9ja3MgPSAwClsgICAyMy41NjYwNjddIDIgbG9j
a3MgaGVsZCBieSB0cmluaXR5LWMxLzQ0MTc6ClsgICAyMy41NjY2NTVdICAjMDogIChjYWxs
YmFja19tdXRleCl7Ky4rLi4ufSwgYXQ6IFs8ODExMTgzOTU+XSBjcHVzZXRfY3B1c19hbGxv
d2VkKzB4MWUvMHgxMjMKWyAgIDIzLjU2ODA2Ml0gICMxOiAgKCYoJnAtPmFsbG9jX2xvY2sp
LT5ybG9jayl7Ky4rLi4ufSwgYXQ6IFs8ODExMTgzOWM+XSBjcHVzZXRfY3B1c19hbGxvd2Vk
KzB4MjUvMHgxMjMKWyAgIDIzLjU2OTQwNF0gClsgICAyMy41Njk0MDRdIHN0YWNrIGJhY2t0
cmFjZToKWyAgIDIzLjU2OTk3NV0gQ1BVOiAwIFBJRDogNDQxNyBDb21tOiB0cmluaXR5LWMx
IE5vdCB0YWludGVkIDMuMTQuMC1yYzMtMDI0NTgtZzgzN2NhYmEgIzIKWyAgIDIzLjU3MDky
Nl0gIDAwMDAwMDAwIDAwMDAwMDAwIDkzMGFmZjI4IDgxODc3Y2MzIDAwMDAwMDAxIDAwMDAw
MDAwIDkzMGFmZjUwIDgxMGNkZWM0ClsgICAyMy41NzIyMTBdICA4MWMzYzZlMCA4MWM0YmJm
YyAwMDAwMDAwMSAwMDAwMDAwMCA5Mzc5YzMzMCA5Mzc5YzMzMCA5Mzc5YzZlOCA4MjZkNWI4
MApbICAgMjMuNTczNDA0XSAgOTMwYWZmNjggODExMTg0NzMgOTMwYWZmODAgOTM3OWMzMzAg
MDAwMDAwMDAgOTMwYWZmOWMgOTMwYWZmOTQgODEwYjI0NDIKWyAgIDIzLjU3NDU4MF0gQ2Fs
bCBUcmFjZToKWyAgIDIzLjU3NDk0Nl0gIFs8ODE4NzdjYzM+XSBkdW1wX3N0YWNrKzB4N2Uv
MHhmMQpbICAgMjMuNTc1NTY2XSAgWzw4MTBjZGVjND5dIGxvY2tkZXBfcmN1X3N1c3BpY2lv
dXMrMHhmMi8weGZhClsgICAyMy41NzY0MDFdICBbPDgxMTE4NDczPl0gY3B1c2V0X2NwdXNf
YWxsb3dlZCsweGZjLzB4MTIzClsgICAyMy41NzcxNjZdICBbPDgxMGIyNDQyPl0gc2NoZWRf
c2V0YWZmaW5pdHkrMHgzZmUvMHg1MDIKWyAgIDIzLjU3Nzg0MF0gIFs8ODEwYjIwNDQ+XSA/
IHNldF9jcHVzX2FsbG93ZWRfcHRyKzB4MWQ2LzB4MWQ2ClsgICAyMy41Nzg1ODFdICBbPDgx
MGIyNWViPl0gU3lTX3NjaGVkX3NldGFmZmluaXR5KzB4YTUvMHhhYgpbICAgMjMuNTc5MzIz
XSAgWzw4MTg4OTFjYT5dIHN5c2VudGVyX2RvX2NhbGwrMHgxMi8weDNjClsgICAyMy41ODYw
NzNdIFZGUzogV2FybmluZzogdHJpbml0eS1jMCB1c2luZyBvbGQgc3RhdCgpIGNhbGwuIFJl
Y29tcGlsZSB5b3VyIGJpbmFyeS4KWyAgIDIzLjU4NzI4NV0gVkZTOiBXYXJuaW5nOiB0cmlu
aXR5LWMwIHVzaW5nIG9sZCBzdGF0KCkgY2FsbC4gUmVjb21waWxlIHlvdXIgYmluYXJ5Lgpb
ICAgNjQuNTY0NzkyXSBzcGluX2xvY2stdG9ydHVyZTogV3JpdGVzOiAgVG90YWw6IDQgIE1h
eC9NaW46IDAvMCAgIEZhaWw6IDAgCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAyMjAx
NTUwLzgzN2NhYmE2NTg3YWI1NjNlZjM3Nzk0MjlkZGM5ZjQ5YWRiNmI2ZmMvZG1lc2cteW9j
dG8tc25iLTIyOjIwMTQwMjIxMDUzOTI5OmkzODYtcmFuZGNvbmZpZy1jNS0wMjIwMTU1MDo6
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAyMjAxNTUwLzgzN2NhYmE2NTg3YWI1NjNl
ZjM3Nzk0MjlkZGM5ZjQ5YWRiNmI2ZmMvZG1lc2cteW9jdG8tYmVucy00OjIwMTQwMjIwMTYx
NzMyOmkzODYtcmFuZGNvbmZpZy1jNS0wMjIwMTU1MDozLjE0LjAtcmMzLTAyNDU4LWc4Mzdj
YWJhOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzUtMDIyMDE1NTAvODM3Y2FiYTY1ODdh
YjU2M2VmMzc3OTQyOWRkYzlmNDlhZGI2YjZmYy9kbWVzZy15b2N0by1qYWtldG93bi0xMDoy
MDE0MDIyMDE2MTY0OTppMzg2LXJhbmRjb25maWctYzUtMDIyMDE1NTA6Ogova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1jNS0wMjIwMTU1MC84MzdjYWJhNjU4N2FiNTYzZWYzNzc5NDI5ZGRj
OWY0OWFkYjZiNmZjL2RtZXNnLXlvY3RvLXNuYi00NToyMDE0MDIyMDE2MTY0MzppMzg2LXJh
bmRjb25maWctYzUtMDIyMDE1NTA6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0wMjIw
MTU1MC84MzdjYWJhNjU4N2FiNTYzZWYzNzc5NDI5ZGRjOWY0OWFkYjZiNmZjL2RtZXNnLXlv
Y3RvLWNhaXJvLTMwOjIwMTQwMjIwMTYxNjQ1OmkzODYtcmFuZGNvbmZpZy1jNS0wMjIwMTU1
MDozLjE0LjAtcmMzLTAyNDU4LWc4MzdjYWJhOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YzUtMDIyMDE1NTAvODM3Y2FiYTY1ODdhYjU2M2VmMzc3OTQyOWRkYzlmNDlhZGI2YjZmYy9k
bWVzZy15b2N0by1qYWtldG93bi00ODoyMDE0MDIyMDE2MTY1MjppMzg2LXJhbmRjb25maWct
YzUtMDIyMDE1NTA6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0wMjIwMTU1MC84Mzdj
YWJhNjU4N2FiNTYzZWYzNzc5NDI5ZGRjOWY0OWFkYjZiNmZjL2RtZXNnLXlvY3RvLWpha2V0
b3duLTI6MjAxNDAyMjEwNTM5NDE6aTM4Ni1yYW5kY29uZmlnLWM1LTAyMjAxNTUwOjoKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYzUtMDIyMDE1NTAvODM3Y2FiYTY1ODdhYjU2M2VmMzc3
OTQyOWRkYzlmNDlhZGI2YjZmYy9kbWVzZy1xdWFudGFsLWJlbnMtMzoyMDE0MDIyMDE2MTgx
MTppMzg2LXJhbmRjb25maWctYzUtMDIyMDE1NTA6My4xNC4wLXJjMy0wMjQ1OC1nODM3Y2Fi
YToyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWM1LTAyMjAxNTUwLzgzN2NhYmE2NTg3YWI1
NjNlZjM3Nzk0MjlkZGM5ZjQ5YWRiNmI2ZmMvZG1lc2ctcXVhbnRhbC1hdGhlbnMtMzI6MjAx
NDAyMjEwNTM5MzE6aTM4Ni1yYW5kY29uZmlnLWM1LTAyMjAxNTUwOjMuMTQuMC1yYzMtMDI0
NTgtZzgzN2NhYmE6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0wMjIwMTU1MC84Mzdj
YWJhNjU4N2FiNTYzZWYzNzc5NDI5ZGRjOWY0OWFkYjZiNmZjL2RtZXNnLXF1YW50YWwtamFr
ZXRvd24tODoyMDE0MDIyMDE2MTY1MjppMzg2LXJhbmRjb25maWctYzUtMDIyMDE1NTA6Ogov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0wMjIwMTU1MC84MzdjYWJhNjU4N2FiNTYzZWYz
Nzc5NDI5ZGRjOWY0OWFkYjZiNmZjL2RtZXNnLXF1YW50YWwtYXRoZW5zLTE6MjAxNDAyMjEw
NTM5MzY6aTM4Ni1yYW5kY29uZmlnLWM1LTAyMjAxNTUwOjMuMTQuMC1yYzMtMDI0NTgtZzgz
N2NhYmE6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0wMjIwMTU1MC84MzdjYWJhNjU4
N2FiNTYzZWYzNzc5NDI5ZGRjOWY0OWFkYjZiNmZjL2RtZXNnLXF1YW50YWwtamFrZXRvd24t
Mjc6MjAxNDAyMjEwNTM5NDY6aTM4Ni1yYW5kY29uZmlnLWM1LTAyMjAxNTUwOjoKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctYzUtMDIyMDE1NTAvODM3Y2FiYTY1ODdhYjU2M2VmMzc3OTQy
OWRkYzlmNDlhZGI2YjZmYy9kbWVzZy15b2N0by1iZW5zLTM6MjAxNDAyMjAxNjE4MTY6aTM4
Ni1yYW5kY29uZmlnLWM1LTAyMjAxNTUwOjMuMTQuMC1yYzMtMDI0NTgtZzgzN2NhYmE6Mgov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0wMjIwMTU1MC84MzdjYWJhNjU4N2FiNTYzZWYz
Nzc5NDI5ZGRjOWY0OWFkYjZiNmZjL2RtZXNnLXlvY3RvLXhpYW4tNDk6MjAxNDAyMjEwNTM5
MzA6aTM4Ni1yYW5kY29uZmlnLWM1LTAyMjAxNTUwOjMuMTQuMC1yYzMtMDI0NTgtZzgzN2Nh
YmE6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jNS0wMjIwMTU1MC84MzdjYWJhNjU4N2Fi
NTYzZWYzNzc5NDI5ZGRjOWY0OWFkYjZiNmZjL2RtZXNnLXF1YW50YWwtYXRoZW5zLTExOjIw
MTQwMjIxMDUzOTMxOmkzODYtcmFuZGNvbmZpZy1jNS0wMjIwMTU1MDozLjE0LjAtcmMzLTAy
NDU4LWc4MzdjYWJhOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzUtMDIyMDE1NTAvODM3
Y2FiYTY1ODdhYjU2M2VmMzc3OTQyOWRkYzlmNDlhZGI2YjZmYy9kbWVzZy15b2N0by14aWFu
LTIzOjIwMTQwMjIwMTYxNjQwOmkzODYtcmFuZGNvbmZpZy1jNS0wMjIwMTU1MDozLjE0LjAt
cmMzLTAyNDU4LWc4MzdjYWJhOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzUtMDIyMDE1
NTAvODM3Y2FiYTY1ODdhYjU2M2VmMzc3OTQyOWRkYzlmNDlhZGI2YjZmYy9kbWVzZy15b2N0
by14aWFuLTYwOjIwMTQwMjIxMDUzOTI5OmkzODYtcmFuZGNvbmZpZy1jNS0wMjIwMTU1MDoz
LjE0LjAtcmMzLTAyNDU4LWc4MzdjYWJhOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzUt
MDIyMDE1NTAvODM3Y2FiYTY1ODdhYjU2M2VmMzc3OTQyOWRkYzlmNDlhZGI2YjZmYy9kbWVz
Zy1xdWFudGFsLWpha2V0b3duLTM4OjIwMTQwMjIxMDUzOTQ1OmkzODYtcmFuZGNvbmZpZy1j
NS0wMjIwMTU1MDo6CjA6MTg6MTkgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCltkZXRh
Y2hlZCBIRUFEIDM3M2Y3ZDZdIFJldmVydCAiY2dyb3VwOiBkcm9wIHRhc2tfbG9jaygpIHBy
b3RlY3Rpb24gYXJvdW5kIHRhc2stPmNncm91cHMiCiBDb21taXR0ZXI6IFd1IEZlbmdndWFu
ZyA8a2J1aWxkQGJlZT4KWW91ciBuYW1lIGFuZCBlbWFpbCBhZGRyZXNzIHdlcmUgY29uZmln
dXJlZCBhdXRvbWF0aWNhbGx5IGJhc2VkCm9uIHlvdXIgdXNlcm5hbWUgYW5kIGhvc3RuYW1l
LiBQbGVhc2UgY2hlY2sgdGhhdCB0aGV5IGFyZSBhY2N1cmF0ZS4KWW91IGNhbiBzdXBwcmVz
cyB0aGlzIG1lc3NhZ2UgYnkgc2V0dGluZyB0aGVtIGV4cGxpY2l0bHk6CgogICAgZ2l0IGNv
bmZpZyAtLWdsb2JhbCB1c2VyLm5hbWUgIllvdXIgTmFtZSIKICAgIGdpdCBjb25maWcgLS1n
bG9iYWwgdXNlci5lbWFpbCB5b3VAZXhhbXBsZS5jb20KCkFmdGVyIGRvaW5nIHRoaXMsIHlv
dSBtYXkgZml4IHRoZSBpZGVudGl0eSB1c2VkIGZvciB0aGlzIGNvbW1pdCB3aXRoOgoKICAg
IGdpdCBjb21taXQgLS1hbWVuZCAtLXJlc2V0LWF1dGhvcgoKIDIgZmlsZXMgY2hhbmdlZCwg
NzUgaW5zZXJ0aW9ucygrKSwgMjggZGVsZXRpb25zKC0pCmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzUtMDIyMDE1NTAvbGludXgtZGV2ZWw6
ZGV2ZWwtaG91cmx5LTIwMTQwMjIwMTU6MzczZjdkNmVlYzlmYzRhYzM0ZjFjY2E1ODQzMGQw
MzhlMGNhYjg4YTpiaXNlY3QtbGludXgKCjIwMTQtMDItMjEtMDc6NDk6MjcgMzczZjdkNmVl
YzlmYzRhYzM0ZjFjY2E1ODQzMGQwMzhlMGNhYjg4YSBjb21waWxpbmcKCjIwMTQtMDItMjEt
MDc6NTU6NTEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjMy0wMjQ1OS1nMzczZjdk
Ni4uLgkzNQk0OS4JNTAuCTUxLgk1NQk1Nwk1OQk2MCBTVUNDRVNTCgoKPT09PT09PT09IHVw
c3RyZWFtID09PT09PT09PQpXYXJuaW5nOiB5b3UgYXJlIGxlYXZpbmcgMSBjb21taXQgYmVo
aW5kLCBub3QgY29ubmVjdGVkIHRvCmFueSBvZiB5b3VyIGJyYW5jaGVzOgoKICAzNzNmN2Q2
IFJldmVydCAiY2dyb3VwOiBkcm9wIHRhc2tfbG9jaygpIHByb3RlY3Rpb24gYXJvdW5kIHRh
c2stPmNncm91cHMiCgpJZiB5b3Ugd2FudCB0byBrZWVwIHRoZW0gYnkgY3JlYXRpbmcgYSBu
ZXcgYnJhbmNoLCB0aGlzIG1heSBiZSBhIGdvb2QgdGltZQp0byBkbyBzbyB3aXRoOgoKIGdp
dCBicmFuY2ggbmV3X2JyYW5jaF9uYW1lIDM3M2Y3ZDYKCkhFQUQgaXMgbm93IGF0IGQxNThm
YzcuLi4gTWVyZ2UgdGFnICdwY2ktdjMuMTQtZml4ZXMtMScgb2YgZ2l0Oi8vZ2l0Lmtlcm5l
bC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2hlbGdhYXMvcGNpCmxzIC1hIC9rZXJu
ZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzUtMDIyMDE1NTAvbGlu
dXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMjIwMTU6ZDE1OGZjN2YzNmEyNWUxOTc5MWQy
NWE1NWRhNTYyMzM5OWEyNjQ0ZjpiaXNlY3QtbGludXgKCjIwMTQtMDItMjEtMDg6MDI6NTMg
ZDE1OGZjN2YzNmEyNWUxOTc5MWQyNWE1NWRhNTYyMzM5OWEyNjQ0ZiBjb21waWxpbmcKCjIw
MTQtMDItMjEtMDg6MDY6MTIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjMy0wMDIx
OS1nZDE1OGZjNy4uLgkzMAk1NS4uLi4uLi4uLi4uLi4JNTgJNTkJNjAgU1VDQ0VTUwoKCj09
PT09PT09PSBsaW51eC1uZXh0ID09PT09PT09PQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdh
cyBkMTU4ZmM3Li4uIE1lcmdlIHRhZyAncGNpLXYzLjE0LWZpeGVzLTEnIG9mIGdpdDovL2dp
dC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9oZWxnYWFzL3BjaQpIRUFE
IGlzIG5vdyBhdCAxMmYxZDk0Li4uIEFkZCBsaW51eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZv
ciAyMDE0MDIyMApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5k
Y29uZmlnLWM1LTAyMjAxNTUwL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDIyMDE1
OjEyZjFkOTRmMGM4YjI1NmMwNGNiOWI2YjVkZDk4OWMzMmU0NGYxMWI6YmlzZWN0LWxpbnV4
CgoyMDE0LTAyLTIxLTA4OjE2OjQ0IDEyZjFkOTRmMGM4YjI1NmMwNGNiOWI2YjVkZDk4OWMz
MmU0NGYxMWIgcmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzUtMDIyMDE1NTAvMTJm
MWQ5NGYwYzhiMjU2YzA0Y2I5YjZiNWRkOTg5YzMyZTQ0ZjExYi92bWxpbnV6LTMuMTQuMC1y
YzMtbmV4dC0yMDE0MDIyMC0wNDE4My1nMTJmMWQ5NAoKMjAxNC0wMi0yMS0wODoxNjo0NCBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgk1CTQ1Li4uLi4uLi4uLi4uLi4JNDYuLi4uCTQ4CTUw
CTUzCTU0Li4uCTU3CTYwIFNVQ0NFU1MKCg==

--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc3-02458-g837caba"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.14.0-rc3 Kernel Configuration
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
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
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
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_COMPILE_TEST=y
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
CONFIG_FHANDLE=y
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
# CONFIG_RCU_NOCB_CPU_ZERO is not set
CONFIG_RCU_NOCB_CPU_ALL=y
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_ARCH_USES_NUMA_PROT_NONE=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_NUMA_BALANCING=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
# CONFIG_MEMCG_KMEM is not set
# CONFIG_CGROUP_HUGETLB is not set
# CONFIG_CGROUP_PERF is not set
# CONFIG_CGROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
# CONFIG_SCHED_AUTOGROUP is not set
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
# CONFIG_RD_LZO is not set
CONFIG_RD_LZ4=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLUB_CPU_PARTIAL=y
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
CONFIG_JUMP_LABEL=y
CONFIG_UPROBES=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
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
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
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
# CONFIG_GCOV_PROFILE_ALL is not set
CONFIG_GCOV_FORMAT_AUTODETECT=y
# CONFIG_GCOV_FORMAT_3_4 is not set
# CONFIG_GCOV_FORMAT_4_7 is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
# CONFIG_MODULE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=m
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_BIGSMP=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_RDC321X=y
# CONFIG_X86_32_NON_STANDARD is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_DEBUG=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
CONFIG_KVM_DEBUG_FS=y
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
CONFIG_MPENTIUM4=y
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
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=7
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=32
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
CONFIG_X86_ANCIENT_MCE=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
# CONFIG_VM86 is not set
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
# CONFIG_VMSPLIT_3G is not set
CONFIG_VMSPLIT_2G=y
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x80000000
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_NUMA=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=3
CONFIG_ARCH_HAVE_MEMORY_PRESENT=y
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
CONFIG_ARCH_DISCONTIGMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_DISCONTIGMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_DISCONTIGMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
# CONFIG_X86_PAT is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_SLEEP_DEBUG=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
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
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_NUMA is not set
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_EXTLOG is not set
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
CONFIG_APM_DO_ENABLE=y
# CONFIG_APM_CPU_IDLE is not set
CONFIG_APM_DISPLAY_BLANK=y
CONFIG_APM_ALLOW_INTS=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K6=m
CONFIG_X86_POWERNOW_K7=m
CONFIG_X86_POWERNOW_K7_ACPI=y
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=m
CONFIG_X86_SPEEDSTEP_SMI=m
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
CONFIG_X86_LONGRUN=m
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_CPU_IDLE_GOV_MENU is not set
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PCMCIA_PROBE=y
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_SUB_POLICY=y
# CONFIG_XFRM_MIGRATE is not set
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
CONFIG_STP=m
CONFIG_BRIDGE=m
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=m
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=m
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=m
CONFIG_LTPC=m
# CONFIG_COPS is not set
CONFIG_IPDDP=m
CONFIG_IPDDP_ENCAP=y
CONFIG_X25=m
# CONFIG_LAPB is not set
CONFIG_PHONET=y
CONFIG_IEEE802154=y
CONFIG_6LOWPAN_IPHC=y
# CONFIG_MAC802154 is not set
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_NC=y
# CONFIG_BATMAN_ADV_DEBUG is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
# CONFIG_NET_MPLS_GSO is not set
CONFIG_HSR=m
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
# CONFIG_CAN_BCM is not set
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_SLCAN is not set
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=m
# CONFIG_IRCOMM is not set
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#

#
# FIR device drivers
#
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
# CONFIG_TOSHIBA_FIR is not set
# CONFIG_SMC_IRCC_FIR is not set
CONFIG_ALI_FIR=m
# CONFIG_VLSI_FIR is not set
CONFIG_VIA_FIR=m
CONFIG_BT=y
CONFIG_BT_RFCOMM=m
# CONFIG_BT_RFCOMM_TTY is not set
# CONFIG_BT_BNEP is not set
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIVHCI is not set
CONFIG_BT_MRVL=y
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
CONFIG_RFKILL_REGULATOR=y
CONFIG_RFKILL_GPIO=y
CONFIG_NET_9P=m
CONFIG_NET_9P_VIRTIO=m
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=m
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=m
CONFIG_CAIF_USB=m
CONFIG_NFC=y
CONFIG_NFC_DIGITAL=m
CONFIG_NFC_NCI=y
# CONFIG_NFC_HCI is not set

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_SIM is not set
# CONFIG_NFC_MRVL is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set
# CONFIG_DMA_CMA is not set

#
# Bus devices
#
CONFIG_CONNECTOR=m
CONFIG_MTD=y
CONFIG_MTD_TESTS=m
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=m
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=m
CONFIG_MTD_BLOCK_RO=y
CONFIG_FTL=y
# CONFIG_NFTL is not set
CONFIG_INFTL=m
# CONFIG_RFD_FTL is not set
CONFIG_SSFDC=m
# CONFIG_SM_FTL is not set
CONFIG_MTD_OOPS=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_GEN_PROBE=y
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
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
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=m
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_SC520CDP=m
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_SCx200_DOCFLASH=y
# CONFIG_MTD_PCI is not set
CONFIG_MTD_GPIO_ADDR=y
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=m
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
CONFIG_MTD_BLOCK2MTD=m

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
# CONFIG_MTD_SM_COMMON is not set
# CONFIG_MTD_NAND_DENALI is not set
CONFIG_MTD_NAND_GPIO=y
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH=y
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
# CONFIG_MTD_NAND_DOCG4 is not set
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_CS553X=y
CONFIG_MTD_NAND_NANDSIM=m
CONFIG_MTD_NAND_PLATFORM=y
# CONFIG_MTD_NAND_SH_FLCTL is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
# CONFIG_MTD_UBI is not set
CONFIG_PARPORT=m
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
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

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=m
CONFIG_AD525X_DPOT_I2C=m
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1780=m
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=m
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=m
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_ATA is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_AUTODETECT is not set
# CONFIG_MD_LINEAR is not set
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MD_MULTIPATH=m
# CONFIG_MD_FAULTY is not set
CONFIG_BCACHE=y
CONFIG_BCACHE_DEBUG=y
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=m
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
# CONFIG_DM_CRYPT is not set
CONFIG_DM_SNAPSHOT=m
# CONFIG_DM_THIN_PROVISIONING is not set
# CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
CONFIG_DM_CACHE=m
CONFIG_DM_CACHE_MQ=m
# CONFIG_DM_CACHE_CLEANER is not set
# CONFIG_DM_MIRROR is not set
CONFIG_DM_RAID=y
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
CONFIG_DM_DELAY=y
# CONFIG_DM_UEVENT is not set
# CONFIG_DM_FLAKEY is not set
# CONFIG_DM_VERITY is not set
CONFIG_DM_SWITCH=m
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

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
# CONFIG_KEYBOARD_SH_KEYSC is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_INPORT is not set
# CONFIG_MOUSE_LOGIBM is not set
# CONFIG_MOUSE_PC110PAD is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_CLPS711X is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_ST_ASC is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=m
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_HW_RANDOM_TPM=m
# CONFIG_NVRAM is not set
CONFIG_DTLK=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=m
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=m
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=m
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=m
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=m
CONFIG_I2C_MUX_PCA9541=m
CONFIG_I2C_MUX_PCA954x=m
# CONFIG_I2C_HELPER_AUTO is not set
# CONFIG_I2C_SMBUS is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=y

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
CONFIG_I2C_CBUS_GPIO=y
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_OCORES=m
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_RIIC=m
# CONFIG_I2C_SH_MOBILE is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y
# CONFIG_I2C_RCAR is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_ISA is not set
CONFIG_SCx200_I2C=y
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=m

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=y

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
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_CLPS711X=y
CONFIG_GPIO_GENERIC_PLATFORM=m
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=y
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_MAX7300=m
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=m
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_TC3589X is not set
# CONFIG_GPIO_TPS65912 is not set
CONFIG_GPIO_TWL4030=m
CONFIG_GPIO_WM831X=m
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_PALMAS is not set
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=m
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2408=m
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=m
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_MAX8925_POWER is not set
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2780=m
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=m
# CONFIG_BATTERY_BQ27X00_I2C is not set
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
CONFIG_BATTERY_DA9052=m
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_CHARGER_PCF50633=m
CONFIG_CHARGER_MAX8903=m
# CONFIG_CHARGER_TWL4030 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_MAX14577=y
CONFIG_CHARGER_MAX8998=m
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_BQ24190=m
CONFIG_CHARGER_BQ24735=y
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_CHARGER_TPS65090 is not set
# CONFIG_BATTERY_GOLDFISH is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_AD7414=m
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7410=m
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_DA9052_ADC is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=m
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_MC13783_ADC=m
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=m
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=m
CONFIG_SENSORS_LTC2945=m
CONFIG_SENSORS_LTC4151=y
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4222=y
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=y
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=m
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=m
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=y
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
CONFIG_SENSORS_MAX16064=m
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=m
# CONFIG_SENSORS_ZL6100 is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
# CONFIG_SENSORS_SCH5627 is not set
CONFIG_SENSORS_SCH5636=m
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_ADC128D818=y
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_AMC6821=m
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_RCAR_THERMAL is not set
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_ACPI_INT3403_THERMAL is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_DA9052_WATCHDOG=m
CONFIG_WM831X_WATCHDOG=m
CONFIG_DW_WATCHDOG=y
CONFIG_TWL4030_WATCHDOG=m
CONFIG_RETU_WATCHDOG=m
CONFIG_ACQUIRE_WDT=m
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=m
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=y
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=m
# CONFIG_SCx200_WDT is not set
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
# CONFIG_RDC321X_WDT is not set
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=m
CONFIG_SBC7240_WDT=y
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=m
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=m
# CONFIG_W83977F_WDT is not set
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y
# CONFIG_MEN_A21_WDT is not set

#
# ISA-based Watchdog Cards
#
CONFIG_PCWATCHDOG=y
CONFIG_MIXCOMWD=y
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_AS3711=y
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_CROS_EC=m
CONFIG_MFD_CROS_EC_I2C=m
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_I2C=m
CONFIG_HTC_PASIC3=m
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX665X is not set
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
CONFIG_PCF50633_GPIO=m
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65090=y
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS65218 is not set
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=m
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM8997 is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
CONFIG_REGULATOR_88PM800=m
# CONFIG_REGULATOR_ACT8865 is not set
CONFIG_REGULATOR_AD5398=m
CONFIG_REGULATOR_ARIZONA=m
# CONFIG_REGULATOR_AS3711 is not set
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9063=m
# CONFIG_REGULATOR_DA9210 is not set
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_GPIO=y
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_LP3971=y
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
# CONFIG_REGULATOR_MAX14577 is not set
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=m
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=m
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=m
CONFIG_REGULATOR_MAX8973=y
# CONFIG_REGULATOR_MAX8997 is not set
CONFIG_REGULATOR_MAX8998=m
# CONFIG_REGULATOR_MAX77686 is not set
CONFIG_REGULATOR_MC13XXX_CORE=m
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=m
# CONFIG_REGULATOR_PALMAS is not set
CONFIG_REGULATOR_PCF50633=m
# CONFIG_REGULATOR_PFUZE100 is not set
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS6105X=m
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=m
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65090=m
# CONFIG_REGULATOR_TPS65910 is not set
CONFIG_REGULATOR_TPS65912=m
CONFIG_REGULATOR_TPS80031=y
CONFIG_REGULATOR_TWL4030=y
CONFIG_REGULATOR_WM831X=y
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
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
CONFIG_FB_ARC=m
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=m
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
CONFIG_FB_OPENCORES=y
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
CONFIG_FB_TMIO=m
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_SM501=m
CONFIG_FB_GOLDFISH=m
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
CONFIG_LOGO_LINUX_VGA16=y
# CONFIG_LOGO_LINUX_CLUT224 is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_DMAENGINE_PCM=m
CONFIG_SND_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PRINTK=y
# CONFIG_SND_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_DUMMY=y
CONFIG_SND_ALOOP=y
CONFIG_SND_VIRMIDI=y
CONFIG_SND_MTPAV=m
CONFIG_SND_MTS64=m
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=m
# CONFIG_SND_PORTMAN2X4 is not set
# CONFIG_SND_ISA is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_SOC=m
CONFIG_SND_SOC_GENERIC_DMAENGINE_PCM=y
# CONFIG_SND_SOC_ADI is not set
# CONFIG_SND_ATMEL_SOC is not set
CONFIG_SND_BCM2835_SOC_I2S=m
CONFIG_SND_EP93XX_SOC=m
# CONFIG_SND_IMX_SOC is not set
CONFIG_SND_KIRKWOOD_SOC=m
CONFIG_SND_KIRKWOOD_SOC_OPENRD=m
CONFIG_SND_KIRKWOOD_SOC_T5325=m
CONFIG_SND_SOC_I2C_AND_SPI=m
CONFIG_SND_SOC_ALL_CODECS=m
CONFIG_SND_SOC_ARIZONA=m
CONFIG_SND_SOC_WM_HUBS=m
CONFIG_SND_SOC_WM_ADSP=m
CONFIG_SND_SOC_AD193X=m
CONFIG_SND_SOC_AD73311=m
CONFIG_SND_SOC_ADAU1701=m
CONFIG_SND_SOC_ADAU1373=m
CONFIG_SND_SOC_ADAV80X=m
CONFIG_SND_SOC_ADS117X=m
CONFIG_SND_SOC_AK4535=m
CONFIG_SND_SOC_AK4641=m
CONFIG_SND_SOC_AK4642=m
CONFIG_SND_SOC_AK4671=m
CONFIG_SND_SOC_AK5386=m
CONFIG_SND_SOC_ALC5623=m
CONFIG_SND_SOC_ALC5632=m
CONFIG_SND_SOC_CS42L51=m
CONFIG_SND_SOC_CS42L52=m
CONFIG_SND_SOC_CS42L73=m
CONFIG_SND_SOC_CS4270=m
CONFIG_SND_SOC_CS4271=m
CONFIG_SND_SOC_CX20442=m
CONFIG_SND_SOC_JZ4740_CODEC=m
CONFIG_SND_SOC_L3=m
CONFIG_SND_SOC_DA7210=m
CONFIG_SND_SOC_DA7213=m
CONFIG_SND_SOC_DA732X=m
CONFIG_SND_SOC_DA9055=m
CONFIG_SND_SOC_BT_SCO=m
CONFIG_SND_SOC_ISABELLE=m
CONFIG_SND_SOC_LM49453=m
CONFIG_SND_SOC_MAX98088=m
CONFIG_SND_SOC_MAX98090=m
CONFIG_SND_SOC_MAX98095=m
CONFIG_SND_SOC_MAX9850=m
CONFIG_SND_SOC_HDMI_CODEC=m
CONFIG_SND_SOC_PCM1681=m
CONFIG_SND_SOC_PCM3008=m
CONFIG_SND_SOC_RT5631=m
CONFIG_SND_SOC_RT5640=m
CONFIG_SND_SOC_SGTL5000=m
CONFIG_SND_SOC_SI476X=m
CONFIG_SND_SOC_SIGMADSP=m
CONFIG_SND_SOC_SPDIF=m
CONFIG_SND_SOC_SSM2518=m
CONFIG_SND_SOC_SSM2602=m
CONFIG_SND_SOC_STA32X=m
CONFIG_SND_SOC_STA529=m
CONFIG_SND_SOC_TAS5086=m
CONFIG_SND_SOC_TLV320AIC23=m
CONFIG_SND_SOC_TLV320AIC32X4=m
CONFIG_SND_SOC_TLV320AIC3X=m
CONFIG_SND_SOC_TLV320DAC33=m
CONFIG_SND_SOC_TWL4030=m
CONFIG_SND_SOC_UDA134X=m
CONFIG_SND_SOC_UDA1380=m
CONFIG_SND_SOC_WM1250_EV1=m
CONFIG_SND_SOC_WM2000=m
CONFIG_SND_SOC_WM2200=m
CONFIG_SND_SOC_WM5100=m
CONFIG_SND_SOC_WM5102=m
CONFIG_SND_SOC_WM5110=m
CONFIG_SND_SOC_WM8510=m
CONFIG_SND_SOC_WM8523=m
CONFIG_SND_SOC_WM8580=m
CONFIG_SND_SOC_WM8711=m
CONFIG_SND_SOC_WM8727=m
CONFIG_SND_SOC_WM8728=m
CONFIG_SND_SOC_WM8731=m
CONFIG_SND_SOC_WM8737=m
CONFIG_SND_SOC_WM8741=m
CONFIG_SND_SOC_WM8750=m
CONFIG_SND_SOC_WM8753=m
CONFIG_SND_SOC_WM8776=m
CONFIG_SND_SOC_WM8782=m
CONFIG_SND_SOC_WM8804=m
CONFIG_SND_SOC_WM8900=m
CONFIG_SND_SOC_WM8903=m
CONFIG_SND_SOC_WM8904=m
CONFIG_SND_SOC_WM8940=m
CONFIG_SND_SOC_WM8955=m
CONFIG_SND_SOC_WM8960=m
CONFIG_SND_SOC_WM8961=m
CONFIG_SND_SOC_WM8962=m
CONFIG_SND_SOC_WM8971=m
CONFIG_SND_SOC_WM8974=m
CONFIG_SND_SOC_WM8978=m
CONFIG_SND_SOC_WM8983=m
CONFIG_SND_SOC_WM8985=m
CONFIG_SND_SOC_WM8988=m
CONFIG_SND_SOC_WM8990=m
CONFIG_SND_SOC_WM8991=m
CONFIG_SND_SOC_WM8993=m
CONFIG_SND_SOC_WM8995=m
CONFIG_SND_SOC_WM8996=m
CONFIG_SND_SOC_WM9081=m
CONFIG_SND_SOC_WM9090=m
CONFIG_SND_SOC_LM4857=m
CONFIG_SND_SOC_MAX9768=m
CONFIG_SND_SOC_MAX9877=m
CONFIG_SND_SOC_MC13783=m
CONFIG_SND_SOC_ML26124=m
CONFIG_SND_SOC_TPA6130A2=m
# CONFIG_SND_SIMPLE_CARD is not set
CONFIG_SOUND_PRIME=y
# CONFIG_SOUND_MSNDCLAS is not set
# CONFIG_SOUND_MSNDPIN is not set
# CONFIG_SOUND_OSS is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_PRODIKEYS is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_XINMO is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_KEYSTONE_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_OMAP_CONTROL_USB is not set
# CONFIG_OMAP_USB3 is not set
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_RCAR_GEN2_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=m
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
# CONFIG_MSPRO_BLOCK is not set
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
CONFIG_LEDS_LM3530=y
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=m
CONFIG_LEDS_NET48XX=m
# CONFIG_LEDS_WRAP is not set
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=m
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_PCA9685=y
CONFIG_LEDS_WM831X_STATUS=m
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=m
CONFIG_LEDS_LT3593=m
CONFIG_LEDS_MC13783=m
CONFIG_LEDS_TCA6507=m
CONFIG_LEDS_MAX8997=m
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
CONFIG_LEDS_BLINKM=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
# CONFIG_LEDS_TRIGGER_CAMERA is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_DW_DMAC_CORE is not set
# CONFIG_DW_DMAC is not set
# CONFIG_DW_DMAC_PCI is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ACPI=y
CONFIG_AUXDISPLAY=y
CONFIG_UIO=m
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_DMEM_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=m

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=m
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_PSTORE=m

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=m
CONFIG_STE_MODEM_RPROC=m

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
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
CONFIG_IIO_ST_ACCEL_3AXIS=m
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=m

#
# Analog to digital converters
#
CONFIG_MAX1363=m
CONFIG_MCP3422=m
# CONFIG_NAU7802 is not set
# CONFIG_TI_ADC081C is not set
# CONFIG_TI_AM335X_ADC is not set
CONFIG_TWL6030_GPADC=m

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
# CONFIG_AD5380 is not set
# CONFIG_AD5446 is not set
# CONFIG_MAX517 is not set
CONFIG_MCP4725=m

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital gyroscope sensors
#
CONFIG_IIO_ST_GYRO_3AXIS=m
CONFIG_IIO_ST_GYRO_I2C_3AXIS=m
CONFIG_ITG3200=m

#
# Humidity sensors
#
# CONFIG_DHT11 is not set
CONFIG_SI7005=m

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=m

#
# Light sensors
#
CONFIG_ADJD_S311=m
# CONFIG_APDS9300 is not set
# CONFIG_CM32181 is not set
CONFIG_CM36651=m
CONFIG_GP2AP020A00F=m
CONFIG_SENSORS_LM3533=m
CONFIG_LTR501=m
CONFIG_TCS3472=m
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_TSL4531 is not set
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
CONFIG_AK8975=m
CONFIG_MAG3110=m
CONFIG_IIO_ST_MAGN_3AXIS=m
CONFIG_IIO_ST_MAGN_I2C_3AXIS=m

#
# Inclinometer sensors
#

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=m
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure sensors
#
CONFIG_MPL3115=m
CONFIG_IIO_ST_PRESS=m
CONFIG_IIO_ST_PRESS_I2C=m

#
# Temperature sensors
#
CONFIG_TMP006=m
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_EXYNOS_MIPI_VIDEO=m
CONFIG_BCM_KONA_USB2_PHY=m
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=m
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=m
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=m
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
# CONFIG_REISERFS_FS_SECURITY is not set
CONFIG_JFS_FS=m
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
CONFIG_XFS_DEBUG=y
# CONFIG_GFS2_FS is not set
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
CONFIG_BTRFS_DEBUG=y
CONFIG_BTRFS_ASSERT=y
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=m
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=m
# CONFIG_HFSPLUS_FS_POSIX_ACL is not set
CONFIG_BEFS_FS=m
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
# CONFIG_EFS_FS is not set
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
# CONFIG_JFFS2_SUMMARY is not set
CONFIG_JFFS2_FS_XATTR=y
# CONFIG_JFFS2_FS_POSIX_ACL is not set
CONFIG_JFFS2_FS_SECURITY=y
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
CONFIG_LOGFS=m
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
CONFIG_VXFS_FS=m
# CONFIG_MINIX_FS is not set
CONFIG_OMFS_FS=y
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
CONFIG_ROMFS_FS=y
# CONFIG_ROMFS_BACKED_BY_BLOCK is not set
CONFIG_ROMFS_BACKED_BY_MTD=y
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_MTD=y
# CONFIG_PSTORE is not set
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
CONFIG_UFS_DEBUG=y
CONFIG_F2FS_FS=m
# CONFIG_F2FS_STAT_FS is not set
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
# CONFIG_F2FS_FS_SECURITY is not set
# CONFIG_F2FS_CHECK_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=m
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=m
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=m
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=m
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=m
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y

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
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_DEBUG_HIGHMEM=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_DEBUG_PREEMPT=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
# CONFIG_PROVE_RCU_DELAY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_VERBOSE=y
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
# CONFIG_FAULT_INJECTION is not set
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
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_PREEMPT_TRACER=y
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
# CONFIG_BRANCH_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
CONFIG_INTERVAL_TREE_TEST=m
CONFIG_PERCPU_TEST=m
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_ASYNC_RAID6_TEST=m
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=m
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_MODULE=m
CONFIG_TEST_USER_COPY=m
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_SET_MODULE_RONX=y
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
# CONFIG_SECURITY_PATH is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
# CONFIG_IMA is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
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
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER=m
CONFIG_CRYPTO_GLUE_HELPER_X86=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_XCBC=m
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=m
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=m
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_586=m
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=y
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_LZ4=m
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_LGUEST is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_PERCPU_RWSEM=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=y
CONFIG_CRC8=m
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=m
CONFIG_DDR=y

--sdtB3X0nJg68CQEu--
