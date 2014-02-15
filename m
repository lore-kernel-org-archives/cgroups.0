From: Fengguang Wu <fengguang.wu@intel.com>
Subject: [cgroups] BUG: unable to handle kernel NULL pointer dereference at
 0000003c
Date: Sat, 15 Feb 2014 20:42:12 +0800
Message-ID: <20140215124212.GA8782@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="YiEDa0DAkWCtVeE4"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
commit de00ffa56ea3132c6013fc8f07133b8a1014cf53
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue Feb 11 11:52:48 2014 -0500
Commit:     Tejun Heo <tj@kernel.org>
CommitDate: Tue Feb 11 11:52:48 2014 -0500

    cgroup: make cgroup_subsys->base_cftypes use cgroup_add_cftypes()
    
    Currently, cgroup_subsys->base_cftypes registration is different from
    dynamic cftypes registartion.  Instead of going through
    cgroup_add_cftypes(), cgroup_init_subsys() invokes
    cgroup_init_cftsets() which makes use of cgroup_subsys->base_cftset
    which doesn't involve dynamic allocation.
    
    While avoiding dynamic allocation is somewhat nice, having two
    separate paths for cftypes registration is nasty, especially as we're
    planning to add more operations during cftypes registration.
    
    This patch drops cgroup_init_cftsets() and cgroup_subsys->base_cftset
    and registers base_cftypes using cgroup_add_cftypes().  This is done
    as a separate step in cgroup_init() instead of a part of
    cgroup_init_subsys().  This is because cgroup_init_subsys() can be
    called very early during boot when kmalloc() isn't available yet.
    
    Signed-off-by: Tejun Heo <tj@kernel.org>
    Acked-by: Li Zefan <lizefan@huawei.com>

[    0.020000] Calibrating delay loop (skipped) preset value.. 5786.00 BogoMIPS (lpj=28930000)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] Mount-cache hash table entries: 512
[    0.020000] BUG: unable to handle kernel NULL pointer dereference at 0000003c
[    0.020000] IP: [<cc90b4ad>] cgroup_cfts_commit+0x27/0x1c1
[    0.020000] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.020000] Oops: 0000 [#1] SMP 
[    0.020000] Modules linked in:
[    0.020000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc2-next-20140212-02521-g4602175 #1
[    0.020000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.020000] task: cd497910 ti: cd492000 task.ti: cd492000
[    0.020000] EIP: 0060:[<cc90b4ad>] EFLAGS: 00210282 CPU: 0
[    0.020000] EIP is at cgroup_cfts_commit+0x27/0x1c1
[    0.020000] EAX: cd4b1d0c EBX: cf004fa0 ECX: 00000001 EDX: 00000001
[    0.020000] ESI: 00000000 EDI: cd9820d4 EBP: cd493fa4 ESP: cd493f70
[    0.020000]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    0.020000] CR0: 8005003b CR2: 0000003c CR3: 0d96e000 CR4: 000006b0
[    0.020000] Stack:
[    0.020000]  cf004fa0 cd4b1d4c 00200246 cd9820d4 cc9d1129 0190c691 0000000c 000080d0
[    0.020000]  cd493f90 cd493f90 cf004fa0 cd9820d4 cd4accc4 cd493fbc cc90c6fc 00000000
[    0.020000]  00000000 00000000 cd970800 cd493fcc cd78b646 00000000 00020800 cd493fe8
[    0.020000] Call Trace:
[    0.020000]  [<cc9d1129>] ? kmem_cache_alloc_trace+0x33f/0x3b7
[    0.020000]  [<cc90c6fc>] cgroup_add_cftypes+0x8f/0xca
[    0.020000]  [<cd78b646>] cgroup_init+0x6a/0x26a
[    0.020000]  [<cd764d7d>] start_kernel+0x4d7/0x57a
[    0.020000]  [<cd7642ef>] i386_start_kernel+0x92/0x96
[    0.020000] Code: 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 28 e8 94 ab 71 00 89 c7 8b 77 50 89 45 d8 8d 45 ec 89 45 ec 89 45 f0 b8 0c 1d 4b cd 88 55 e3 <8b> 5e 3c e8 c9 4d 71 00 85 ff 74 0e 31 c0 81 7e 3c c8 43 ec cd
[    0.020000] EIP: [<cc90b4ad>] cgroup_cfts_commit+0x27/0x1c1 SS:ESP 0068:cd493f70
[    0.020000] CR2: 000000000000003c
[    0.020000] ---[ end trace fd4743fe17bdbf8e ]---
[    0.020000] Kernel panic - not syncing: Fatal exception

git bisect start d80813ed6679ea0be2d054f2e2085699d1493978 v3.13 --
git bisect good aa2e7100e38880db7907cb2b7ec6267b2b243771  # 01:41     20+      3  Merge branch 'akpm' (patches from Andrew Morton)
git bisect good dd178a56e226296988cd5a6f3499f07f259b4631  # 02:16     20+     11  Merge remote-tracking branch 'char-misc.current/char-misc-linus'
git bisect good b19abf9906eda1d49591a117d2315b02a8a58fa8  # 05:25     20+     11  Merge remote-tracking branch 'slave-dma/next'
git bisect good 9341660bd894be14c9dd67cbd36588aa25dd377e  # 05:49     20+      1  Merge remote-tracking branch 'devicetree/devicetree/next'
git bisect good 522e2050f3a977119a1865b18052351c224bf171  # 06:30     20+      4  Merge remote-tracking branch 'leds/for-next'
git bisect  bad 9a06744bd5a4baeaa86ab1b9ce5eaec23b799100  # 06:30      0-     20  Merge remote-tracking branch 'cgroup/for-next'
git bisect good a7204faea47fcea987a189bd2817913a7a4eb254  # 07:20     20+      9  Merge remote-tracking branch 'usb/usb-next'
git bisect good 70d6c976107c8cca03d038eb7b7849f81e2c60d1  # 08:24     20+      1  Merge remote-tracking branch 'staging/staging-next'
git bisect good d6f156c8bc35e7e7542e39b6855fe5b73fb79b46  # 09:18     20+      4  Merge remote-tracking branch 'char-misc/char-misc-next'
git bisect good f7cef064aa01a1ac682c1945cc168b878cb118ff  # 09:43     20+      1  Merge branch 'driver-core-next' into cgroup/for-3.15
git bisect good 8d7e6fb0a1db970ac3589f87af0f2a20ef46654b  # 10:01     20+      7  cgroup: update cgroup name handling
git bisect  bad b1664924062393bb048203bd4622e0b1c9e1d328  # 10:07      0-      1  cgroup: introduce cgroup_ino()
git bisect  bad 5f46990787e2721b4db190ddc8af6fdbe8f010d7  # 10:11      0-      1  cgroup: update the meaning of cftype->max_write_len
git bisect  bad de00ffa56ea3132c6013fc8f07133b8a1014cf53  # 10:15      0-      1  cgroup: make cgroup_subsys->base_cftypes use cgroup_add_cftypes()
# first bad commit: [de00ffa56ea3132c6013fc8f07133b8a1014cf53] cgroup: make cgroup_subsys->base_cftypes use cgroup_add_cftypes()
git bisect good 8d7e6fb0a1db970ac3589f87af0f2a20ef46654b  # 10:54     60+     22  cgroup: update cgroup name handling
git bisect  bad 460217583c934110865a2f5dce5e1b5c98835a46  # 10:54      0-     59  Add linux-next specific files for 20140212
git bisect good ca033390a537dacdc2127c66d62e7862ad15ffdb  # 11:30     60+      8  Merge tag 'usb-3.14-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb
git bisect good da8d308fbdb8360078786b3e125238122c4fc611  # 12:09     60+     60  Add linux-next specific files for 20140214

Thanks,
Fengguang

--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-cairo-3:20140213074936:i386-randconfig-an1-02121352:3.14.0-rc2-next-20140212-02521-g4602175:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel
KASLR using RDTSC...

Decompressing Linux... Parsing ELF... Performing relocations... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc2-next-20140212-02521-g4602175 (kbuil=
d@ant) (gcc version 4.8.1 (Debian 4.8.1-8) ) #1 SMP Wed Feb 12 14:12:50 CST=
 2014
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x1000000
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
[    0.000000] initial memory mapped: [mem 0x00000000-0x0e3fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0fa00000-0x0fbfffff]
[    0.000000]  [mem 0x0fa00000-0x0fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0f9fffff]
[    0.000000]  [mem 0x0c000000-0x0f9fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x0df91000, 0x0df91fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x0fcbd000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACP 0fffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXP=
C 00000001)
[    0.000000] ACPI: DSDT 0fffe490 0011A9 (v01   BXPC   BXDSDT 00000001 INT=
L 20100528)
[    0.000000] ACPI: FACS 0fffff40 000040
[    0.000000] ACPI: SSDT 0ffff7a0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: APIC 0ffff680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXP=
C 00000001)
[    0.000000] ACPI: HPET 0ffff640 000038 (v01 BOCHS  BXPCHPET 00000001 BXP=
C 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000] free_area_init_node: node 0, pgdat cd514420, node_mem_map cf=
abd020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 480 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
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
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 334 pages/cpu @cf821000 s1345120 r0 d22944 =
u1368064
[    0.000000] pcpu-alloc: s1345120 r0 d22944 u1368064 alloc=3D334*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr f823ec0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64924
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-an1-02121352/next:master:460217583c934110865a2f5dce5e1b5=
c98835a46:bisect-stable/.vmlinuz-460217583c934110865a2f5dce5e1b5c98835a46-2=
0140213074639-7-cairo branch=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randco=
nfig-an1-02121352/460217583c934110865a2f5dce5e1b5c98835a46/vmlinuz-3.14.0-r=
c2-next-20140212-02521-g4602175
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 524264 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] Memory: 228784K/261744K available (8346K kernel code, 2886K =
rwdata, 4520K rodata, 2056K init, 5836K bss, 32960K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff15000 - 0xfffff000   ( 936 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xfff13000   ( 759 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xcd764000 - 0xcd966000   (2056 kB)
[    0.000000]       .data : 0xcd026c79 - 0xcd763a20   (7411 kB)
[    0.000000]       .text : 0xcc800000 - 0xcd026c79   (8347 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3Dcf00c000 soft=3Dcf00e000
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc2-next-20140212-02521-g4602175 (kbuil=
d@ant) (gcc version 4.8.1 (Debian 4.8.1-8) ) #1 SMP Wed Feb 12 14:12:50 CST=
 2014
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x1000000
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
[    0.000000] initial memory mapped: [mem 0x00000000-0x0e3fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0fa00000-0x0fbfffff]
[    0.000000]  [mem 0x0fa00000-0x0fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0f9fffff]
[    0.000000]  [mem 0x0c000000-0x0f9fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x0df91000, 0x0df91fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x0fcbd000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACP 0fffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXP=
C 00000001)
[    0.000000] ACPI: DSDT 0fffe490 0011A9 (v01   BXPC   BXDSDT 00000001 INT=
L 20100528)
[    0.000000] ACPI: FACS 0fffff40 000040
[    0.000000] ACPI: SSDT 0ffff7a0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: APIC 0ffff680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXP=
C 00000001)
[    0.000000] ACPI: HPET 0ffff640 000038 (v01 BOCHS  BXPCHPET 00000001 BXP=
C 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000] free_area_init_node: node 0, pgdat cd514420, node_mem_map cf=
abd020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 480 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
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
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 334 pages/cpu @cf821000 s1345120 r0 d22944 =
u1368064
[    0.000000] pcpu-alloc: s1345120 r0 d22944 u1368064 alloc=3D334*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr f823ec0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64924
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-an1-02121352/next:master:460217583c934110865a2f5dce5e1b5=
c98835a46:bisect-stable/.vmlinuz-460217583c934110865a2f5dce5e1b5c98835a46-2=
0140213074639-7-cairo branch=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randco=
nfig-an1-02121352/460217583c934110865a2f5dce5e1b5c98835a46/vmlinuz-3.14.0-r=
c2-next-20140212-02521-g4602175
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 524264 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] Memory: 228784K/261744K available (8346K kernel code, 2886K =
rwdata, 4520K rodata, 2056K init, 5836K bss, 32960K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff15000 - 0xfffff000   ( 936 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xfff13000   ( 759 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xcd764000 - 0xcd966000   (2056 kB)
[    0.000000]       .data : 0xcd026c79 - 0xcd763a20   (7411 kB)
[    0.000000]       .text : 0xcc800000 - 0xcd026c79   (8347 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3Dcf00c000 soft=3Dcf00e000
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
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
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2893.000 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5786.00 Bogo=
MIPS (lpj=3D28930000)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] Mount-cache hash table entries: 512
[    0.020000] BUG: unable to handle kernel NULL pointer dereference at 000=
0003c
[    0.020000] IP: [<cc90b4ad>] cgroup_cfts_commit+0x27/0x1c1
[    0.020000] *pdpt =3D 0000000000000000 *pde =3D f000ff53f000ff53=20
[    0.020000] Oops: 0000 [#1] SMP=20
[    0.020000] Modules linked in:
[    0.020000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc2-next-20=
140212-02521-g4602175 #1
[    0.020000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.020000] task: cd497910 ti: cd492000 task.ti: cd492000
[    0.020000] EIP: 0060:[<cc90b4ad>] EFLAGS: 00210282 CPU: 0
[    0.020000] EIP is at cgroup_cfts_commit+0x27/0x1c1
[    0.020000] EAX: cd4b1d0c EBX: cf004fa0 ECX: 00000001 EDX: 00000001
[    0.020000] ESI: 00000000 EDI: cd9820d4 EBP: cd493fa4 ESP: cd493f70
[    0.020000]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    0.020000] CR0: 8005003b CR2: 0000003c CR3: 0d96e000 CR4: 000006b0
[    0.020000] Stack:
[    0.020000]  cf004fa0 cd4b1d4c 00200246 cd9820d4 cc9d1129 0190c691 00000=
00c 000080d0
[    0.020000]  cd493f90 cd493f90 cf004fa0 cd9820d4 cd4accc4 cd493fbc cc90c=
6fc 00000000
[    0.020000]  00000000 00000000 cd970800 cd493fcc cd78b646 00000000 00020=
800 cd493fe8
[    0.020000] Call Trace:
[    0.020000]  [<cc9d1129>] ? kmem_cache_alloc_trace+0x33f/0x3b7
[    0.020000]  [<cc90c6fc>] cgroup_add_cftypes+0x8f/0xca
[    0.020000]  [<cd78b646>] cgroup_init+0x6a/0x26a
[    0.020000]  [<cd764d7d>] start_kernel+0x4d7/0x57a
[    0.020000]  [<cd7642ef>] i386_start_kernel+0x92/0x96
[    0.020000] Code: 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 28 e8 94 ab 71 00 =
89 c7 8b 77 50 89 45 d8 8d 45 ec 89 45 ec 89 45 f0 b8 0c 1d 4b cd 88 55 e3 =
<8b> 5e 3c e8 c9 4d 71 00 85 ff 74 0e 31 c0 81 7e 3c c8 43 ec cd
[    0.020000] EIP: [<cc90b4ad>] cgroup_cfts_commit+0x27/0x1c1 SS:ESP 0068:=
cd493f70
[    0.020000] CR2: 000000000000003c
[    0.020000] ---[ end trace fd4743fe17bdbf8e ]---
[    0.020000] Kernel panic - not syncing: Fatal exception
[    0.020000] Rebooting in 10 seconds..
Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-a=
n1-02121352/460217583c934110865a2f5dce5e1b5c98835a46/vmlinuz-3.14.0-rc2-nex=
t-20140212-02521-g4602175 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,=
115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-an1-02121352/next:master:460217583c934110865a2f5dce5e1b5=
c98835a46:bisect-stable/.vmlinuz-460217583c934110865a2f5dce5e1b5c98835a46-2=
0140213074639-7-cairo branch=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randco=
nfig-an1-02121352/460217583c934110865a2f5dce5e1b5c98835a46/vmlinuz-3.14.0-r=
c2-next-20140212-02521-g4602175'  -initrd /kernel-tests/initrd/yocto-minima=
l-i386.cgz -m 256M -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D=
1,hostfwd=3Dtcp::19326-:22 -boot order=3Dnc -no-reboot -watchdog i6300esb -=
rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-yocto-cairo-3 -serial file=
:/dev/shm/kboot/serial-yocto-cairo-3 -daemonize -display none -monitor null=
=20

--YiEDa0DAkWCtVeE4
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-an1-02121352-460217583c934110865a2f5dce5e1b5c98835a46-cgroup_cfts_commit+-x-27863.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IGQ4MDgxM2VkNjY3OWVhMGJlMmQwNTRmMmUyMDg1Njk5ZDE0OTM5NzgK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1hbjEt
MDIxMjEzNTIvbmV4dDptYXN0ZXI6ZDgwODEzZWQ2Njc5ZWEwYmUyZDA1NGYyZTIwODU2OTlk
MTQ5Mzk3ODpiaXNlY3QtbW0KIFRFU1QgRkFJTFVSRQpbICAgIDAuMDIwMDAwXSBDYWxpYnJh
dGluZyBkZWxheSBsb29wIChza2lwcGVkKSBwcmVzZXQgdmFsdWUuLiA1Nzg1Ljk4IEJvZ29N
SVBTIChscGo9Mjg5Mjk5MjApClsgICAgMC4wMjAwMDBdIHBpZF9tYXg6IGRlZmF1bHQ6IDMy
NzY4IG1pbmltdW06IDMwMQpbICAgIDAuMDIwMDAwXSBNb3VudC1jYWNoZSBoYXNoIHRhYmxl
IGVudHJpZXM6IDUxMgpbICAgIDAuMDIwMDAwXSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2Vy
bmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAwMDAwMDAzYwpbICAgIDAuMDIwMDAw
XSBJUDogWzxjNzcwYjU5OD5dIGNncm91cF9jZnRzX2NvbW1pdCsweDI3LzB4MWMxClsgICAg
MC4wMjAwMDBdICpwZHB0ID0gMDAwMDAwMDAwMDAwMDAwMCAqcGRlID0gZjAwMGZmNTNmMDAw
ZmY1MyAKWyAgICAwLjAyMDAwMF0gT29wczogMDAwMCBbIzFdIFNNUCAKWyAgICAwLjAyMDAw
MF0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMC4wMjAwMDBdIENQVTogMCBQSUQ6IDAgQ29t
bTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTQuMC1yYzItMDIxODEtZ2Q4MDgxM2UgIzI5
MQpbICAgIDAuMDIwMDAwXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2No
cyAwMS8wMS8yMDExClsgICAgMC4wMjAwMDBdIHRhc2s6IGM4Mjk1OTEwIHRpOiBjODI5MDAw
MCB0YXNrLnRpOiBjODI5MDAwMApbICAgIDAuMDIwMDAwXSBFSVA6IDAwNjA6WzxjNzcwYjU5
OD5dIEVGTEFHUzogMDAyMTAyODIgQ1BVOiAwClsgICAgMC4wMjAwMDBdIEVJUCBpcyBhdCBj
Z3JvdXBfY2Z0c19jb21taXQrMHgyNy8weDFjMQpbICAgIDAuMDIwMDAwXSBFQVg6IGM4MmFm
ZDBjIEVCWDogY2RjMDRmYTAgRUNYOiAwMDAwMDAwMSBFRFg6IDAwMDAwMDAxClsgICAgMC4w
MjAwMDBdIEVTSTogMDAwMDAwMDAgRURJOiBjODc3ZTBkNCBFQlA6IGM4MjkxZmE0IEVTUDog
YzgyOTFmNzAKWyAgICAwLjAyMDAwMF0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdT
OiAwMGUwIFNTOiAwMDY4ClsgICAgMC4wMjAwMDBdIENSMDogODAwNTAwM2IgQ1IyOiAwMDAw
MDAzYyBDUjM6IDA4NzZhMDAwIENSNDogMDAwMDA2YjAKWyAgICAwLjAyMDAwMF0gU3RhY2s6
ClsgICAgMC4wMjAwMDBdICBjZGMwNGZhMCBjODJhZmQ0YyAwMDIwMDI0NiBjODc3ZTBkNCBj
NzdkMDQzZiAwMTcwYzc3YyAwMDAwMDAwYyAwMDAwODBkMApbICAgIDAuMDIwMDAwXSAgYzgy
OTFmOTAgYzgyOTFmOTAgY2RjMDRmYTAgYzg3N2UwZDQgYzgyYWFjYzQgYzgyOTFmYmMgYzc3
MGM3ZTcgMDAwMDAwMDAKWyAgICAwLjAyMDAwMF0gIDAwMDAwMDAwIDAwMDAwMDAwIGM4NzZj
ODAwIGM4MjkxZmNjIGM4NTg3NjRiIDAwMDAwMDAwIDAwMDIwODAwIGM4MjkxZmU4ClsgICAg
MC4wMjAwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4wMjAwMDBdICBbPGM3N2QwNDNmPl0gPyBr
bWVtX2NhY2hlX2FsbG9jX3RyYWNlKzB4MzNmLzB4M2I3ClsgICAgMC4wMjAwMDBdICBbPGM3
NzBjN2U3Pl0gY2dyb3VwX2FkZF9jZnR5cGVzKzB4OGYvMHhjYQpbICAgIDAuMDIwMDAwXSAg
WzxjODU4NzY0Yj5dIGNncm91cF9pbml0KzB4NmEvMHgyNmEKWyAgICAwLjAyMDAwMF0gIFs8
Yzg1NjBkN2Q+XSBzdGFydF9rZXJuZWwrMHg0ZDcvMHg1N2EKWyAgICAwLjAyMDAwMF0gIFs8
Yzg1NjAyZWY+XSBpMzg2X3N0YXJ0X2tlcm5lbCsweDkyLzB4OTYKWyAgICAwLjAyMDAwMF0g
Q29kZTogNWUgNWYgNWQgYzMgNTUgODkgZTUgNTcgNTYgNTMgODMgZWMgMjggZTggNDkgOWYg
NzEgMDAgODkgYzcgOGIgNzcgNTAgODkgNDUgZDggOGQgNDUgZWMgODkgNDUgZWMgODkgNDUg
ZjAgYjggMGMgZmQgMmEgYzggODggNTUgZTMgPDhiPiA1ZSAzYyBlOCA0YiA0MSA3MSAwMCA4
NSBmZiA3NCAwZSAzMSBjMCA4MSA3ZSAzYyBjOCAwMyBjYyBjOApbICAgIDAuMDIwMDAwXSBF
SVA6IFs8Yzc3MGI1OTg+XSBjZ3JvdXBfY2Z0c19jb21taXQrMHgyNy8weDFjMSBTUzpFU1Ag
MDA2ODpjODI5MWY3MApbICAgIDAuMDIwMDAwXSBDUjI6IDAwMDAwMDAwMDAwMDAwM2MKWyAg
ICAwLjAyMDAwMF0gLS0tWyBlbmQgdHJhY2UgZmJmNjNhYzY2ZDdhMThhNiBdLS0tClsgICAg
MC4wMjAwMDBdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRpb24K
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyL2Q4MDgxM2VkNjY3OWVhMGJl
MmQwNTRmMmUyMDg1Njk5ZDE0OTM5NzgvZG1lc2ctcXVhbnRhbC14aWFuLTEyOjIwMTQwMjEz
MDgyNzU3OmkzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTI6My4xNC4wLXJjMi0wMjE4MS1n
ZDgwODEzZToyOTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyL2Q4MDgx
M2VkNjY3OWVhMGJlMmQwNTRmMmUyMDg1Njk5ZDE0OTM5NzgvZG1lc2cteW9jdG8tamFrZXRv
d24tMjoyMDE0MDIxMzA5MzcyODppMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyOjMuMTQu
MC1yYzItMDIxODEtZ2Q4MDgxM2U6MjkxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMS0w
MjEyMTM1Mi9kODA4MTNlZDY2NzllYTBiZTJkMDU0ZjJlMjA4NTY5OWQxNDkzOTc4L2RtZXNn
LXlvY3RvLWJheS0yOjIwMTQwMjEzMDgzNDMzOmkzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEz
NTI6My4xNC4wLXJjMi0wMjE4MS1nZDgwODEzZToyOTEKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctYW4xLTAyMTIxMzUyL2Q4MDgxM2VkNjY3OWVhMGJlMmQwNTRmMmUyMDg1Njk5ZDE0OTM5
NzgvZG1lc2cteW9jdG8teGlhbi01NDoyMDE0MDIxMzA4MzI0NzppMzg2LXJhbmRjb25maWct
YW4xLTAyMTIxMzUyOjMuMTQuMC1yYzItMDIxODEtZ2Q4MDgxM2U6MjkxCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1Mi9kODA4MTNlZDY2NzllYTBiZTJkMDU0ZjJlMjA4
NTY5OWQxNDkzOTc4L2RtZXNnLXF1YW50YWwtYmVucy02OjIwMTQwMjEzMDgzNDEzOmkzODYt
cmFuZGNvbmZpZy1hbjEtMDIxMjEzNTI6My4xNC4wLXJjMi0wMjE4MS1nZDgwODEzZToyOTEK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyL2Q4MDgxM2VkNjY3OWVhMGJl
MmQwNTRmMmUyMDg1Njk5ZDE0OTM5NzgvZG1lc2ctcXVhbnRhbC14Z3dvLTE6MjAxNDAyMTMw
ODIzNTM6aTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1MjozLjE0LjAtcmMyLTAyMTgxLWdk
ODA4MTNlOjI5MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvZDgwODEz
ZWQ2Njc5ZWEwYmUyZDA1NGYyZTIwODU2OTlkMTQ5Mzk3OC9kbWVzZy15b2N0by1pbm4tNDoy
MDE0MDIxMzA4MjY1ODppMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyOjMuMTQuMC1yYzIt
MDIxODEtZ2Q4MDgxM2U6MjkxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1
Mi9kODA4MTNlZDY2NzllYTBiZTJkMDU0ZjJlMjA4NTY5OWQxNDkzOTc4L2RtZXNnLXF1YW50
YWwtYXRoZW5zLTEzOjIwMTQwMjEzMDgyOTUwOmkzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEz
NTI6My4xNC4wLXJjMi0wMjE4MS1nZDgwODEzZToyOTEKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctYW4xLTAyMTIxMzUyL2Q4MDgxM2VkNjY3OWVhMGJlMmQwNTRmMmUyMDg1Njk5ZDE0OTM5
NzgvZG1lc2ctcXVhbnRhbC1hdGhlbnMtMjM6MjAxNDAyMTMwODI5NTA6aTM4Ni1yYW5kY29u
ZmlnLWFuMS0wMjEyMTM1MjozLjE0LjAtcmMyLTAyMTgxLWdkODA4MTNlOjI5MQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvZDgwODEzZWQ2Njc5ZWEwYmUyZDA1NGYy
ZTIwODU2OTlkMTQ5Mzk3OC9kbWVzZy1xdWFudGFsLXJvYW0tMjY6MjAxNDAyMTMwODMwNDQ6
aTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1MjozLjE0LjAtcmMyLTAyMTgxLWdkODA4MTNl
OjI5MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvZDgwODEzZWQ2Njc5
ZWEwYmUyZDA1NGYyZTIwODU2OTlkMTQ5Mzk3OC9kbWVzZy1xdWFudGFsLWpha2V0b3duLTI4
OjIwMTQwMjEzMDkzNzMwOmkzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTI6My4xNC4wLXJj
Mi0wMjE4MS1nZDgwODEzZToyOTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIx
MzUyL2Q4MDgxM2VkNjY3OWVhMGJlMmQwNTRmMmUyMDg1Njk5ZDE0OTM5NzgvZG1lc2cteW9j
dG8teGlhbi0zNToyMDE0MDIxMzA4MzM1NTppMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUy
OjMuMTQuMC1yYzItMDIxODEtZ2Q4MDgxM2U6MjkxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWFuMS0wMjEyMTM1Mi9kODA4MTNlZDY2NzllYTBiZTJkMDU0ZjJlMjA4NTY5OWQxNDkzOTc4
L2RtZXNnLXF1YW50YWwtYmVucy00OjIwMTQwMjEzMDgyNjE2OmkzODYtcmFuZGNvbmZpZy1h
bjEtMDIxMjEzNTI6My4xNC4wLXJjMi0wMjE4MS1nZDgwODEzZToyOTEKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYW4xLTAyMTIxMzUyL2Q4MDgxM2VkNjY3OWVhMGJlMmQwNTRmMmUyMDg1
Njk5ZDE0OTM5NzgvZG1lc2cteW9jdG8tcm9hbS0yMjoyMDE0MDIxMzA4MjkzOTppMzg2LXJh
bmRjb25maWctYW4xLTAyMTIxMzUyOjMuMTQuMC1yYzItMDIxODEtZ2Q4MDgxM2U6MjkxCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1Mi9kODA4MTNlZDY2NzllYTBiZTJk
MDU0ZjJlMjA4NTY5OWQxNDkzOTc4L2RtZXNnLXlvY3RvLXJvYW0tMTA6MjAxNDAyMTMwODMw
MzQ6aTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1MjozLjE0LjAtcmMyLTAyMTgxLWdkODA4
MTNlOjI5MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvZDgwODEzZWQ2
Njc5ZWEwYmUyZDA1NGYyZTIwODU2OTlkMTQ5Mzk3OC9kbWVzZy1xdWFudGFsLWJlbnMtNDoy
MDE0MDIxMzA4MzIzNDppMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyOjMuMTQuMC1yYzIt
MDIxODEtZ2Q4MDgxM2U6MjkxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1
Mi9kODA4MTNlZDY2NzllYTBiZTJkMDU0ZjJlMjA4NTY5OWQxNDkzOTc4L2RtZXNnLXF1YW50
YWwtaW5uLTQzOjIwMTQwMjEzMDgyNDQ3OmkzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTI6
My4xNC4wLXJjMi0wMjE4MS1nZDgwODEzZToyOTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YW4xLTAyMTIxMzUyL2Q4MDgxM2VkNjY3OWVhMGJlMmQwNTRmMmUyMDg1Njk5ZDE0OTM5Nzgv
ZG1lc2ctcXVhbnRhbC14aWFuLTY0OjIwMTQwMjEzMDgyNTI5OmkzODYtcmFuZGNvbmZpZy1h
bjEtMDIxMjEzNTI6My4xNC4wLXJjMi0wMjE4MS1nZDgwODEzZToyOTEKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYW4xLTAyMTIxMzUyL2Q4MDgxM2VkNjY3OWVhMGJlMmQwNTRmMmUyMDg1
Njk5ZDE0OTM5NzgvZG1lc2ctcXVhbnRhbC14aWFuLTI1OjIwMTQwMjEzMDgzNDU4OmkzODYt
cmFuZGNvbmZpZy1hbjEtMDIxMjEzNTI6My4xNC4wLXJjMi0wMjE4MS1nZDgwODEzZToyOTEK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyL2Q4MDgxM2VkNjY3OWVhMGJl
MmQwNTRmMmUyMDg1Njk5ZDE0OTM5NzgvZG1lc2ctcXVhbnRhbC14aWFuLTU1OjIwMTQwMjEz
MDgzMjMzOmkzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTI6My4xNC4wLXJjMi0wMjE4MS1n
ZDgwODEzZToyOTEKMDoyMDoyMCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVt
MjAxNC0wMi0xNCAyMTo1Njo1OSBSRVBFQVQgQ09VTlQ6IDIwICAjIC9jYy93ZmcvbW0tYmlz
ZWN0Ly5yZXBlYXQbWzBtCgpiaXNlY3Q6IGJhZCBjb21taXQgZDgwODEzZWQ2Njc5ZWEwYmUy
ZDA1NGYyZTIwODU2OTlkMTQ5Mzk3OApnaXQgY2hlY2tvdXQgdjMuMTMKbHMgLWEgL2tlcm5l
bC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvbmV4
dDptYXN0ZXI6ZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZTpiaXNl
Y3QtbW0KCjIwMTQtMDItMTQtMjE6NTc6MDEgZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4
ODE0MjEwZjBlNjRiZSByZXVzZSAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEz
NTIvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZS92bWxpbnV6LTMu
MTMuMAoKMjAxNC0wMi0xNC0yMTo1NzowMSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4JMS4u
LgkyLi4uLi4uCTMJNi4uLi4uLi4uCTcuLi4JMTAJMTEJMTIuLgkxNC4uLi4uLgkxNi4uCTE3
Li4JMTgJMTkuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1bTIwMTQtMDIt
MTUgMDA6NTE6MzIgYWRkX3RvX3J1bl9xdWV1ZSAxG1swbQouLi4uLi4uLi4uLi4uLi4JMjAg
U1VDQ0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCB2My4xMwpnaXQgYmlzZWN0IHN0YXJ0IGQ4
MDgxM2VkNjY3OWVhMGJlMmQwNTRmMmUyMDg1Njk5ZDE0OTM5NzggdjMuMTMgLS0KL2Mva2Vy
bmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6IFsiLWIiLCAiZDgwODEzZWQ2Njc5ZWEwYmUyZDA1
NGYyZTIwODU2OTlkMTQ5Mzk3OCIsICItZyIsICJ2My4xMyIsICIvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIiwgIi9ob21lL3dmZy9tbS9vYmotYmlzZWN0
Il0KQmlzZWN0aW5nOiAxMzc2MCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgMTQgc3RlcHMpClthYTJlNzEwMGUzODg4MGRiNzkwN2NiMmI3ZWM2MjY3YjJi
MjQzNzcxXSBNZXJnZSBicmFuY2ggJ2FrcG0nIChwYXRjaGVzIGZyb20gQW5kcmV3IE1vcnRv
bikKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9ob21lL3dmZy9tbS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyL25leHQ6bWFzdGVyOmFhMmU3MTAw
ZTM4ODgwZGI3OTA3Y2IyYjdlYzYyNjdiMmIyNDM3NzE6YmlzZWN0LW1tCgoyMDE0LTAyLTE1
LTAwOjU5OjM3IGFhMmU3MTAwZTM4ODgwZGI3OTA3Y2IyYjdlYzYyNjdiMmIyNDM3NzEgcmV1
c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyL2FhMmU3MTAwZTM4ODgw
ZGI3OTA3Y2IyYjdlYzYyNjdiMmIyNDM3NzEvdm1saW51ei0zLjEzLjAtMTA0ODAtZ2FhMmU3
MTAKCjIwMTQtMDItMTUtMDA6NTk6MzcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uCTIJMwk0Lgk1Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4J
Ni4uLi4JOC4JMTEuCTE3Li4JMTkuLi4uLi4uLi4uLi4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5n
OiAzMjgwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMiBz
dGVwcykKW2RkMTc4YTU2ZTIyNjI5Njk4OGNkNWE2ZjM0OTlmMDdmMjU5YjQ2MzFdIE1lcmdl
IHJlbW90ZS10cmFja2luZyBicmFuY2ggJ2NoYXItbWlzYy5jdXJyZW50L2NoYXItbWlzYy1s
aW51cycKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9ob21lL3dmZy9tbS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyL25leHQ6bWFzdGVyOmRkMTc4
YTU2ZTIyNjI5Njk4OGNkNWE2ZjM0OTlmMDdmMjU5YjQ2MzE6YmlzZWN0LW1tCgoyMDE0LTAy
LTE1LTAxOjQxOjQzIGRkMTc4YTU2ZTIyNjI5Njk4OGNkNWE2ZjM0OTlmMDdmMjU5YjQ2MzEg
cmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyL2RkMTc4YTU2ZTIy
NjI5Njk4OGNkNWE2ZjM0OTlmMDdmMjU5YjQ2MzEvdm1saW51ei0zLjE0LjAtcmMyLTAwMzAw
LWdkZDE3OGE1CgoyMDE0LTAyLTE1LTAxOjQxOjQzIGRldGVjdGluZyBib290IHN0YXRlIC4u
Li4uLi4uLi4uCTIuLi4uLi4uLi4uCTMuCTQJNi4JMTAJMTEuLi4uCTEyCTE1Li4JMTguLi4u
CTE5Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAx
ODgxIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMSBzdGVw
cykKW2IxOWFiZjk5MDZlZGExZDQ5NTkxYTExN2QyMzE1YjAyYThhNThmYThdIE1lcmdlIHJl
bW90ZS10cmFja2luZyBicmFuY2ggJ3NsYXZlLWRtYS9uZXh0JwpydW5uaW5nIC9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tL29iai1i
aXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZp
Zy1hbjEtMDIxMjEzNTIvbmV4dDptYXN0ZXI6YjE5YWJmOTkwNmVkYTFkNDk1OTFhMTE3ZDIz
MTViMDJhOGE1OGZhODpiaXNlY3QtbW0KCjIwMTQtMDItMTUtMDI6MTY6NDYgYjE5YWJmOTkw
NmVkYTFkNDk1OTFhMTE3ZDIzMTViMDJhOGE1OGZhOCByZXVzZSAva2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1hbjEtMDIxMjEzNTIvYjE5YWJmOTkwNmVkYTFkNDk1OTFhMTE3ZDIzMTViMDJh
OGE1OGZhOC92bWxpbnV6LTMuMTQuMC1yYzItMDExMTctZ2IxOWFiZjkKCjIwMTQtMDItMTUt
MDI6MTY6NDYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uCTEuLi4uLi4uLi4uCTIuLgk1
CTYJNwk4Li4JOS4uLi4uLi4uLi4uCTEwCTExCTEyCTEzLgkxNC4JMTUuLi4uLi4uLi4uLi4J
MTYuLi4uLi4uCTE3Li4uCTE4Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLhtbMTsz
NW0yMDE0LTAyLTE1IDA1OjIyOjQ3IGFkZF90b19ydW5fcXVldWUgMhtbMG0KLi4uLgkxOQky
MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDEwNjQgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRl
ciB0aGlzIChyb3VnaGx5IDExIHN0ZXBzKQpbOTM0MTY2MGJkODk0YmUxNGM5ZGQ2N2NiZDM2
NTg4YWEyNWRkMzc3ZV0gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnZGV2aWNldHJl
ZS9kZXZpY2V0cmVlL25leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1Mi9uZXh0
Om1hc3Rlcjo5MzQxNjYwYmQ4OTRiZTE0YzlkZDY3Y2JkMzY1ODhhYTI1ZGQzNzdlOmJpc2Vj
dC1tbQoKMjAxNC0wMi0xNS0wNToyNTo0OSA5MzQxNjYwYmQ4OTRiZTE0YzlkZDY3Y2JkMzY1
ODhhYTI1ZGQzNzdlIHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1
Mi85MzQxNjYwYmQ4OTRiZTE0YzlkZDY3Y2JkMzY1ODhhYTI1ZGQzNzdlL3ZtbGludXotMy4x
NC4wLXJjMi0wMTY4NC1nOTM0MTY2MAoKMjAxNC0wMi0xNS0wNToyNTo0OSBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAuLi4JMi4JMwk0Li4JNS4uLi4uCTYuLi4uLi4uCTguLgkxMwkxNS4uLi4u
Li4uLi4uCTE2CTE4CTE5Li4uLgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDQ5NyByZXZpc2lv
bnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOSBzdGVwcykKWzUyMmUyMDUw
ZjNhOTc3MTE5YTE4NjViMTgwNTIzNTFjMjI0YmYxNzFdIE1lcmdlIHJlbW90ZS10cmFja2lu
ZyBicmFuY2ggJ2xlZHMvZm9yLW5leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2Vj
dC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAv
a2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1
Mi9uZXh0Om1hc3Rlcjo1MjJlMjA1MGYzYTk3NzExOWExODY1YjE4MDUyMzUxYzIyNGJmMTcx
OmJpc2VjdC1tbQoKMjAxNC0wMi0xNS0wNTo0OToyMCA1MjJlMjA1MGYzYTk3NzExOWExODY1
YjE4MDUyMzUxYzIyNGJmMTcxIHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMS0w
MjEyMTM1Mi81MjJlMjA1MGYzYTk3NzExOWExODY1YjE4MDUyMzUxYzIyNGJmMTcxL3ZtbGlu
dXotMy4xNC4wLXJjMi0wMTkxMC1nNTIyZTIwNQoKMjAxNC0wMi0xNS0wNTo0OToyMCBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAuLi4uCTEuLi4uCTIuLi4uCTMuLi4uLi4uLgk0Li4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLgk1Lgk3Li4uCTguLgk5LgkxMC4JMTEuLi4uLi4uLi4JMTMJMTYJ
MTcuCTE4LgkxOS4uCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMjcxIHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBzKQpbOWEwNjc0NGJkNWE0YmFl
YWE4NmFiMWI5Y2U1ZWFlYzIzYjc5OTEwMF0gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5j
aCAnY2dyb3VwL2Zvci1uZXh0JwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVz
dC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tL29iai1iaXNlY3QKbHMgLWEgL2tlcm5l
bC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvbmV4
dDptYXN0ZXI6OWEwNjc0NGJkNWE0YmFlYWE4NmFiMWI5Y2U1ZWFlYzIzYjc5OTEwMDpiaXNl
Y3QtbW0KIFRFU1QgRkFJTFVSRQpbICAgIDAuMDIwMDAwXSBDYWxpYnJhdGluZyBkZWxheSBs
b29wIChza2lwcGVkKSBwcmVzZXQgdmFsdWUuLiA1Nzg1Ljk4IEJvZ29NSVBTIChscGo9Mjg5
Mjk5MjApClsgICAgMC4wMjAwMDBdIHBpZF9tYXg6IGRlZmF1bHQ6IDMyNzY4IG1pbmltdW06
IDMwMQpbICAgIDAuMDIwMDAwXSBNb3VudC1jYWNoZSBoYXNoIHRhYmxlIGVudHJpZXM6IDUx
MgpbICAgIDAuMDIwMDAwXSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9p
bnRlciBkZXJlZmVyZW5jZSBhdCAwMDAwMDAzYwpbICAgIDAuMDIwMDAwXSBJUDogWzxjYjkw
YjU5OD5dIGNncm91cF9jZnRzX2NvbW1pdCsweDI3LzB4MWMxClsgICAgMC4wMjAwMDBdICpw
ZHB0ID0gMDAwMDAwMDAwMDAwMDAwMCAqcGRlID0gZjAwMGZmNTNmMDAwZmY1MyAKWyAgICAw
LjAyMDAwMF0gT29wczogMDAwMCBbIzFdIFNNUCAKWyAgICAwLjAyMDAwMF0gTW9kdWxlcyBs
aW5rZWQgaW46ClsgICAgMC4wMjAwMDBdIENQVTogMCBQSUQ6IDAgQ29tbTogc3dhcHBlci8w
IE5vdCB0YWludGVkIDMuMTQuMC1yYzItMDIxNDMtZzlhMDY3NDQgIzI5OApbICAgIDAuMDIw
MDAwXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDEx
ClsgICAgMC4wMjAwMDBdIHRhc2s6IGNjNDk1OTEwIHRpOiBjYzQ5MDAwMCB0YXNrLnRpOiBj
YzQ5MDAwMApbICAgIDAuMDIwMDAwXSBFSVA6IDAwNjA6WzxjYjkwYjU5OD5dIEVGTEFHUzog
MDAyMTAyODIgQ1BVOiAwClsgICAgMC4wMjAwMDBdIEVJUCBpcyBhdCBjZ3JvdXBfY2Z0c19j
b21taXQrMHgyNy8weDFjMQpbICAgIDAuMDIwMDAwXSBFQVg6IGNjNGFmZDBjIEVCWDogY2Rj
MDRmYTAgRUNYOiAwMDAwMDAwMSBFRFg6IDAwMDAwMDAxClsgICAgMC4wMjAwMDBdIEVTSTog
MDAwMDAwMDAgRURJOiBjYzk3ZTBkNCBFQlA6IGNjNDkxZmE0IEVTUDogY2M0OTFmNzAKWyAg
ICAwLjAyMDAwMF0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAwMGUwIFNTOiAw
MDY4ClsgICAgMC4wMjAwMDBdIENSMDogODAwNTAwM2IgQ1IyOiAwMDAwMDAzYyBDUjM6IDBj
OTZhMDAwIENSNDogMDAwMDA2YjAKWyAgICAwLjAyMDAwMF0gU3RhY2s6ClsgICAgMC4wMjAw
MDBdICBjZGMwNGZhMCBjYzRhZmQ0YyAwMDIwMDI0NiBjYzk3ZTBkNCBjYjlkMDQzZiAwMTkw
Yzc3YyAwMDAwMDAwYyAwMDAwODBkMApbICAgIDAuMDIwMDAwXSAgY2M0OTFmOTAgY2M0OTFm
OTAgY2RjMDRmYTAgY2M5N2UwZDQgY2M0YWFjYzQgY2M0OTFmYmMgY2I5MGM3ZTcgMDAwMDAw
MDAKWyAgICAwLjAyMDAwMF0gIDAwMDAwMDAwIDAwMDAwMDAwIGNjOTZjODAwIGNjNDkxZmNj
IGNjNzg3NjRiIDAwMDAwMDAwIDAwMDIwODAwIGNjNDkxZmU4ClsgICAgMC4wMjAwMDBdIENh
bGwgVHJhY2U6ClsgICAgMC4wMjAwMDBdICBbPGNiOWQwNDNmPl0gPyBrbWVtX2NhY2hlX2Fs
bG9jX3RyYWNlKzB4MzNmLzB4M2I3ClsgICAgMC4wMjAwMDBdICBbPGNiOTBjN2U3Pl0gY2dy
b3VwX2FkZF9jZnR5cGVzKzB4OGYvMHhjYQpbICAgIDAuMDIwMDAwXSAgWzxjYzc4NzY0Yj5d
IGNncm91cF9pbml0KzB4NmEvMHgyNmEKWyAgICAwLjAyMDAwMF0gIFs8Y2M3NjBkN2Q+XSBz
dGFydF9rZXJuZWwrMHg0ZDcvMHg1N2EKWyAgICAwLjAyMDAwMF0gIFs8Y2M3NjAyZWY+XSBp
Mzg2X3N0YXJ0X2tlcm5lbCsweDkyLzB4OTYKWyAgICAwLjAyMDAwMF0gQ29kZTogNWUgNWYg
NWQgYzMgNTUgODkgZTUgNTcgNTYgNTMgODMgZWMgMjggZTggYzkgOWYgNzEgMDAgODkgYzcg
OGIgNzcgNTAgODkgNDUgZDggOGQgNDUgZWMgODkgNDUgZWMgODkgNDUgZjAgYjggMGMgZmQg
NGEgY2MgODggNTUgZTMgPDhiPiA1ZSAzYyBlOCBkMyA0MSA3MSAwMCA4NSBmZiA3NCAwZSAz
MSBjMCA4MSA3ZSAzYyBjOCAwMyBlYyBjYwpbICAgIDAuMDIwMDAwXSBFSVA6IFs8Y2I5MGI1
OTg+XSBjZ3JvdXBfY2Z0c19jb21taXQrMHgyNy8weDFjMSBTUzpFU1AgMDA2ODpjYzQ5MWY3
MApbICAgIDAuMDIwMDAwXSBDUjI6IDAwMDAwMDAwMDAwMDAwM2MKWyAgICAwLjAyMDAwMF0g
LS0tWyBlbmQgdHJhY2UgZmRiNTViMjJmNDk4ZTNiMiBdLS0tClsgICAgMC4wMjAwMDBdIEtl
cm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRpb24KL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYW4xLTAyMTIxMzUyLzlhMDY3NDRiZDVhNGJhZWFhODZhYjFiOWNlNWVh
ZWMyM2I3OTkxMDAvZG1lc2ctcXVhbnRhbC1yb2FtLTQ6MjAxNDAyMTMxOTU0MTk6aTM4Ni1y
YW5kY29uZmlnLWFuMS0wMjEyMTM1MjozLjE0LjAtcmMyLTAyMTQzLWc5YTA2NzQ0OjI5OAov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvOWEwNjc0NGJkNWE0YmFlYWE4
NmFiMWI5Y2U1ZWFlYzIzYjc5OTEwMC9kbWVzZy15b2N0by1hdGhlbnMtMjQ6MjAxNDAyMTMx
OTUxMjc6aTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1MjozLjE0LjAtcmMyLTAyMTQzLWc5
YTA2NzQ0OjI5OAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvOWEwNjc0
NGJkNWE0YmFlYWE4NmFiMWI5Y2U1ZWFlYzIzYjc5OTEwMC9kbWVzZy1xdWFudGFsLXJvYW0t
ODoyMDE0MDIxMzE5NTcwODppMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyOjMuMTQuMC1y
YzItMDIxNDMtZzlhMDY3NDQ6Mjk4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEy
MTM1Mi85YTA2NzQ0YmQ1YTRiYWVhYTg2YWIxYjljZTVlYWVjMjNiNzk5MTAwL2RtZXNnLXF1
YW50YWwtamFrZXRvd24tMjk6MjAxNDAyMTMxOTU3MDI6aTM4Ni1yYW5kY29uZmlnLWFuMS0w
MjEyMTM1MjozLjE0LjAtcmMyLTAyMTQzLWc5YTA2NzQ0OjI5OAova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1hbjEtMDIxMjEzNTIvOWEwNjc0NGJkNWE0YmFlYWE4NmFiMWI5Y2U1ZWFlYzIz
Yjc5OTEwMC9kbWVzZy1xdWFudGFsLXN0b2FrbGV5LTM6MjAxNDAyMTMxOTQ5NTI6aTM4Ni1y
YW5kY29uZmlnLWFuMS0wMjEyMTM1MjozLjE0LjAtcmMyLTAyMTQzLWc5YTA2NzQ0OjI5OAov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvOWEwNjc0NGJkNWE0YmFlYWE4
NmFiMWI5Y2U1ZWFlYzIzYjc5OTEwMC9kbWVzZy15b2N0by14aWFuLTMyOjIwMTQwMjEzMTk1
MTMzOmkzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTI6My4xNC4wLXJjMi0wMjE0My1nOWEw
Njc0NDoyOTgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyLzlhMDY3NDRi
ZDVhNGJhZWFhODZhYjFiOWNlNWVhZWMyM2I3OTkxMDAvZG1lc2cteW9jdG8teGlhbi00OjIw
MTQwMjEzMTk1MzU0OmkzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTI6My4xNC4wLXJjMi0w
MjE0My1nOWEwNjc0NDoyOTgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUy
LzlhMDY3NDRiZDVhNGJhZWFhODZhYjFiOWNlNWVhZWMyM2I3OTkxMDAvZG1lc2cteW9jdG8t
cm9hbS00MDoyMDE0MDIxMzE5NTI0MzppMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyOjMu
MTQuMC1yYzItMDIxNDMtZzlhMDY3NDQ6Mjk4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFu
MS0wMjEyMTM1Mi85YTA2NzQ0YmQ1YTRiYWVhYTg2YWIxYjljZTVlYWVjMjNiNzk5MTAwL2Rt
ZXNnLXF1YW50YWwtYXRoZW5zLTMxOjIwMTQwMjEzMTk1MjUyOmkzODYtcmFuZGNvbmZpZy1h
bjEtMDIxMjEzNTI6My4xNC4wLXJjMi0wMjE0My1nOWEwNjc0NDoyOTgKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYW4xLTAyMTIxMzUyLzlhMDY3NDRiZDVhNGJhZWFhODZhYjFiOWNlNWVh
ZWMyM2I3OTkxMDAvZG1lc2ctcXVhbnRhbC1hdGhlbnMtMTg6MjAxNDAyMTMxOTUyMTA6aTM4
Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1MjozLjE0LjAtcmMyLTAyMTQzLWc5YTA2NzQ0OjI5
OAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvOWEwNjc0NGJkNWE0YmFl
YWE4NmFiMWI5Y2U1ZWFlYzIzYjc5OTEwMC9kbWVzZy1xdWFudGFsLXJvYW0tMzU6MjAxNDAy
MTMxOTUxNTk6aTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1MjozLjE0LjAtcmMyLTAyMTQz
LWc5YTA2NzQ0OjI5OAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvOWEw
Njc0NGJkNWE0YmFlYWE4NmFiMWI5Y2U1ZWFlYzIzYjc5OTEwMC9kbWVzZy1xdWFudGFsLWF0
aGVucy02MzoyMDE0MDIxMzE5NTEyNzppMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyOjMu
MTQuMC1yYzItMDIxNDMtZzlhMDY3NDQ6Mjk4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFu
MS0wMjEyMTM1Mi85YTA2NzQ0YmQ1YTRiYWVhYTg2YWIxYjljZTVlYWVjMjNiNzk5MTAwL2Rt
ZXNnLXF1YW50YWwtYmVucy0yOjIwMTQwMjEzMTk1NTI0OmkzODYtcmFuZGNvbmZpZy1hbjEt
MDIxMjEzNTI6My4xNC4wLXJjMi0wMjE0My1nOWEwNjc0NDoyOTgKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctYW4xLTAyMTIxMzUyLzlhMDY3NDRiZDVhNGJhZWFhODZhYjFiOWNlNWVhZWMy
M2I3OTkxMDAvZG1lc2ctcXVhbnRhbC1hdGhlbnMtNjM6MjAxNDAyMTMxOTUxNTU6aTM4Ni1y
YW5kY29uZmlnLWFuMS0wMjEyMTM1MjozLjE0LjAtcmMyLTAyMTQzLWc5YTA2NzQ0OjI5OAov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvOWEwNjc0NGJkNWE0YmFlYWE4
NmFiMWI5Y2U1ZWFlYzIzYjc5OTEwMC9kbWVzZy1xdWFudGFsLWF0aGVucy02MjoyMDE0MDIx
MzE5NTEyMTppMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyOjMuMTQuMC1yYzItMDIxNDMt
ZzlhMDY3NDQ6Mjk4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1Mi85YTA2
NzQ0YmQ1YTRiYWVhYTg2YWIxYjljZTVlYWVjMjNiNzk5MTAwL2RtZXNnLXF1YW50YWwtaW5u
LTM2OjIwMTQwMjEzMTk1MTU5OmkzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTI6My4xNC4w
LXJjMi0wMjE0My1nOWEwNjc0NDoyOTgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAy
MTIxMzUyLzlhMDY3NDRiZDVhNGJhZWFhODZhYjFiOWNlNWVhZWMyM2I3OTkxMDAvZG1lc2ct
cXVhbnRhbC14cHMtNjoyMDE0MDIxMzE5NTQyNTppMzg2LXJhbmRjb25maWctYW4xLTAyMTIx
MzUyOjMuMTQuMC1yYzItMDIxNDMtZzlhMDY3NDQ6Mjk4Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWFuMS0wMjEyMTM1Mi85YTA2NzQ0YmQ1YTRiYWVhYTg2YWIxYjljZTVlYWVjMjNiNzk5
MTAwL2RtZXNnLXF1YW50YWwtc25iLTIyOjIwMTQwMjEzMTk1NzAwOmkzODYtcmFuZGNvbmZp
Zy1hbjEtMDIxMjEzNTI6My4xNC4wLXJjMi0wMjE0My1nOWEwNjc0NDoyOTgKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyLzlhMDY3NDRiZDVhNGJhZWFhODZhYjFiOWNl
NWVhZWMyM2I3OTkxMDAvZG1lc2cteW9jdG8teGd3by0xOjIwMTQwMjEzMTk1NTA0OmkzODYt
cmFuZGNvbmZpZy1hbjEtMDIxMjEzNTI6My4xNC4wLXJjMi0wMjE0My1nOWEwNjc0NDoyOTgK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyLzlhMDY3NDRiZDVhNGJhZWFh
ODZhYjFiOWNlNWVhZWMyM2I3OTkxMDAvZG1lc2cteW9jdG8td2FpbWVhLTE6MjAxNDAyMTMx
OTU3MDE6aTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1MjozLjE0LjAtcmMyLTAyMTQzLWc5
YTA2NzQ0OjI5OAowOjIwOjIwIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0y
MDE0LTAyLTE1IDA2OjMwOjIzIFJFUEVBVCBDT1VOVDogMjAgICMgL2NjL3dmZy9tbS1iaXNl
Y3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzogMjMzIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3Qg
YWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpbYTcyMDRmYWVhNDdmY2VhOTg3YTE4OWJk
MjgxNzkxM2E3YTRlYjI1NF0gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAndXNiL3Vz
Yi1uZXh0JwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1
cmUuc2ggL2hvbWUvd2ZnL21tL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvbmV4dDptYXN0ZXI6YTcy
MDRmYWVhNDdmY2VhOTg3YTE4OWJkMjgxNzkxM2E3YTRlYjI1NDpiaXNlY3QtbW0KCjIwMTQt
MDItMTUtMDY6MzA6MjMgYTcyMDRmYWVhNDdmY2VhOTg3YTE4OWJkMjgxNzkxM2E3YTRlYjI1
NCByZXVzZSAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvYTcyMDRmYWVh
NDdmY2VhOTg3YTE4OWJkMjgxNzkxM2E3YTRlYjI1NC92bWxpbnV6LTMuMTQuMC1yYzItMDE5
NTMtZ2E3MjA0ZmEKCjIwMTQtMDItMTUtMDY6MzA6MjMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
Li4uLi4uLi4uLi4uLgkxLi4JMi4JNS4uCTYuLi4JOAkxMC4uLi4uLi4uLgkxMQkxMgkxNQkx
OC4uLi4uLi4uLi4uLi4uLi4JMTkuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMTkwIHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpbNzBkNmM5NzYxMDdjOGNjYTAz
ZDAzOGViN2I3ODQ5ZjgxZTJjNjBkMV0gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAn
c3RhZ2luZy9zdGFnaW5nLW5leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1Mi9u
ZXh0Om1hc3Rlcjo3MGQ2Yzk3NjEwN2M4Y2NhMDNkMDM4ZWI3Yjc4NDlmODFlMmM2MGQxOmJp
c2VjdC1tbQoyMDE0LTAyLTE1IDA3OjIwOjU0OiBjbWRfZmFpbDogJy9iaW4vZ3JlcCcgJy1y
JyAnLS1pbmNsdWRlPWRtZXNnLSonICctcycgJy1sJyAnY2dyb3VwX2NmdHNfY29tbWl0KzB4
JyAnL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyLzcwZDZjOTc2MTA3Yzhj
Y2EwM2QwMzhlYjdiNzg0OWY4MWUyYzYwZDEnICwgcmV0PTIsIHJlZjogL2tlcm5lbC10ZXN0
cy9mYWlsZWQtY21kL2JlZS1ncmVwLXdmZy5sb2cKCjIwMTQtMDItMTUtMDc6MjA6NTQgNzBk
NmM5NzYxMDdjOGNjYTAzZDAzOGViN2I3ODQ5ZjgxZTJjNjBkMSBjb21waWxpbmcKNDYyIHJl
YWwgIDI4MjAgdXNlciAgMTY5IHN5cyAgNjQ3LjA4JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1h
bjEtMDIxMjEzNTIKCjIwMTQtMDItMTUtMDc6Mjk6MTMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
My4xNC4wLXJjMi0wMjA4MS1nNzBkNmM5Ny4uLi4uLi4JMi4JMy4uLi4uCTQuLi4JNS4uLgk2
CTEwLi4uLi4JMTEuLgkxMgkxNAkxNgkxNy4uLi4uLgkxOC4uLi4uLi4uLi4uLi4uLgkxOS4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTIwIFNV
Q0NFU1MKCkJpc2VjdGluZzogNjIgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlz
IChyb3VnaGx5IDYgc3RlcHMpCltkNmYxNTZjOGJjMzVlN2U3NTQyZTM5YjY4NTVmZTViNzNm
Yjc5YjQ2XSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdjaGFyLW1pc2MvY2hhci1t
aXNjLW5leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1Mi9uZXh0Om1hc3Rlcjpk
NmYxNTZjOGJjMzVlN2U3NTQyZTM5YjY4NTVmZTViNzNmYjc5YjQ2OmJpc2VjdC1tbQoyMDE0
LTAyLTE1IDA4OjI0OjQ1OiBjbWRfZmFpbDogJy9iaW4vZ3JlcCcgJy1yJyAnLS1pbmNsdWRl
PWRtZXNnLSonICctcycgJy1sJyAnY2dyb3VwX2NmdHNfY29tbWl0KzB4JyAnL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyL2Q2ZjE1NmM4YmMzNWU3ZTc1NDJlMzliNjg1
NWZlNWI3M2ZiNzliNDYnICwgcmV0PTIsIHJlZjogL2tlcm5lbC10ZXN0cy9mYWlsZWQtY21k
L2JlZS1ncmVwLXdmZy5sb2cKCjIwMTQtMDItMTUtMDg6MjQ6NDUgZDZmMTU2YzhiYzM1ZTdl
NzU0MmUzOWI2ODU1ZmU1YjczZmI3OWI0NiBjb21waWxpbmcKNTggcmVhbCAgMzEzIHVzZXIg
IDI2IHN5cyAgNTg1LjQ3JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIKCjIw
MTQtMDItMTUtMDg6MjU6NTggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjMi0wMjEx
Mi1nZDZmMTU2Yy4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uCTEuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMy4uLi4uLi4uCTQJNQk3Lgk4LgkxMC4u
CTEzCTE0CTE1LgkxOS4uLi4uLi4uLgkyMCBTVUNDRVNTCgpsaW5lYXItYmlzZWN0OiBiYWQg
YnJhbmNoIG1heSBiZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdjZ3JvdXAvZm9yLW5leHQn
CmxpbmVhci1iaXNlY3Q6IGhhbmRsZSBvdmVyIHRvIGdpdCBiaXNlY3QKbGluZWFyLWJpc2Vj
dDogZ2l0IGJpc2VjdCBzdGFydCA5YTA2NzQ0YmQ1YTRiYWVhYTg2YWIxYjljZTVlYWVjMjNi
Nzk5MTAwIGQ2ZjE1NmM4YmMzNWU3ZTc1NDJlMzliNjg1NWZlNWI3M2ZiNzliNDYgLS0KUHJl
dmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgZDZmMTU2Yy4uLiBNZXJnZSByZW1vdGUtdHJhY2tp
bmcgYnJhbmNoICdjaGFyLW1pc2MvY2hhci1taXNjLW5leHQnCkhFQUQgaXMgbm93IGF0IDNj
MGVlZTMuLi4gTGludXggMi42LjM3CkJpc2VjdGluZzogMTUgcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDQgc3RlcHMpCltmN2NlZjA2NGFhMDFhMWFjNjgy
YzE5NDVjYzE2OGI4NzhjYjExOGZmXSBNZXJnZSBicmFuY2ggJ2RyaXZlci1jb3JlLW5leHQn
IGludG8gY2dyb3VwL2Zvci0zLjE1CmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3QgcnVuIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21t
L29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9ob21lL3dmZy9tbS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyL25leHQ6bWFzdGVy
OmY3Y2VmMDY0YWEwMWExYWM2ODJjMTk0NWNjMTY4Yjg3OGNiMTE4ZmY6YmlzZWN0LW1tCjIw
MTQtMDItMTUgMDk6MTg6NTU6IGNtZF9mYWlsOiAnL2Jpbi9ncmVwJyAnLXInICctLWluY2x1
ZGU9ZG1lc2ctKicgJy1zJyAnLWwnICdjZ3JvdXBfY2Z0c19jb21taXQrMHgnICcva2VybmVs
L2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvZjdjZWYwNjRhYTAxYTFhYzY4MmMxOTQ1
Y2MxNjhiODc4Y2IxMThmZicgLCByZXQ9MiwgcmVmOiAva2VybmVsLXRlc3RzL2ZhaWxlZC1j
bWQvYmVlLWdyZXAtd2ZnLmxvZwoKMjAxNC0wMi0xNS0wOToxODo1NSBmN2NlZjA2NGFhMDFh
MWFjNjgyYzE5NDVjYzE2OGI4NzhjYjExOGZmIGNvbXBpbGluZwozMTMgcmVhbCAgMjg3NyB1
c2VyICAxNzAgc3lzICA5NzMuMjIlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1
MgoKMjAxNC0wMi0xNS0wOToyNDoyNSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmMx
LTAwMDM5LWdmN2NlZjA2Li4uLgkxLi4uLgk1CTYJNy4uCTguLi4uLi4uCTkuCTEwLgkxMy4J
MTQuLgkxNgkxNwkxOC4uCTE5CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogNyByZXZpc2lvbnMg
bGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMyBzdGVwcykKWzhkN2U2ZmIwYTFk
Yjk3MGFjMzU4OWY4N2FmMGYyYTIwZWY0NjY1NGJdIGNncm91cDogdXBkYXRlIGNncm91cCBu
YW1lIGhhbmRsaW5nCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1Mi9uZXh0Om1hc3Rl
cjo4ZDdlNmZiMGExZGI5NzBhYzM1ODlmODdhZjBmMmEyMGVmNDY2NTRiOmJpc2VjdC1tbQoy
MDE0LTAyLTE1IDA5OjQzOjI2OiBjbWRfZmFpbDogJy9iaW4vZ3JlcCcgJy1yJyAnLS1pbmNs
dWRlPWRtZXNnLSonICctcycgJy1sJyAnY2dyb3VwX2NmdHNfY29tbWl0KzB4JyAnL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyLzhkN2U2ZmIwYTFkYjk3MGFjMzU4OWY4
N2FmMGYyYTIwZWY0NjY1NGInICwgcmV0PTIsIHJlZjogL2tlcm5lbC10ZXN0cy9mYWlsZWQt
Y21kL2JlZS1ncmVwLXdmZy5sb2cKCjIwMTQtMDItMTUtMDk6NDM6MjYgOGQ3ZTZmYjBhMWRi
OTcwYWMzNTg5Zjg3YWYwZjJhMjBlZjQ2NjU0YiBjb21waWxpbmcKMTQyIHJlYWwgIDE1MTIg
dXNlciAgODYgc3lzICAxMTI1LjMyJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEz
NTIKCjIwMTQtMDItMTUtMDk6NDY6MDQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJj
MS0wMDA0Ny1nOGQ3ZTZmYi4uLi4uLi4JMi4uCTUuCTYJNy4uCTkJMTAJMTEuCTEzCTE0CTE1
LgkxNi4uLi4JMTkJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAzIHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAyIHN0ZXBzKQpbYjE2NjQ5MjQwNjIzOTNiYjA0
ODIwM2JkNDYyMmUwYjFjOWUxZDMyOF0gY2dyb3VwOiBpbnRyb2R1Y2UgY2dyb3VwX2lubygp
CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAv
aG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0vaTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1Mi9uZXh0Om1hc3RlcjpiMTY2NDkyNDA2
MjM5M2JiMDQ4MjAzYmQ0NjIyZTBiMWM5ZTFkMzI4OmJpc2VjdC1tbQoyMDE0LTAyLTE1IDEw
OjAxOjM1OiBjbWRfZmFpbDogJy9iaW4vZ3JlcCcgJy1yJyAnLS1pbmNsdWRlPWRtZXNnLSon
ICctcycgJy1sJyAnY2dyb3VwX2NmdHNfY29tbWl0KzB4JyAnL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYW4xLTAyMTIxMzUyL2IxNjY0OTI0MDYyMzkzYmIwNDgyMDNiZDQ2MjJlMGIxYzll
MWQzMjgnICwgcmV0PTIsIHJlZjogL2tlcm5lbC10ZXN0cy9mYWlsZWQtY21kL2JlZS1ncmVw
LXdmZy5sb2cKCjIwMTQtMDItMTUtMTA6MDE6MzUgYjE2NjQ5MjQwNjIzOTNiYjA0ODIwM2Jk
NDYyMmUwYjFjOWUxZDMyOCBjb21waWxpbmcKMTQ2IHJlYWwgIDE1MzEgdXNlciAgODYgc3lz
ICAxMTAxLjU0JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIKCjIwMTQtMDIt
MTUtMTA6MDQ6MTIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjMS0wMDA1MS1nYjE2
NjQ5Mi4uLi4uLiBURVNUIEZBSUxVUkUKWyAgICAwLjA3NjcyMl0gQ2FsaWJyYXRpbmcgZGVs
YXkgbG9vcCAoc2tpcHBlZCksIHZhbHVlIGNhbGN1bGF0ZWQgdXNpbmcgdGltZXIgZnJlcXVl
bmN5Li4gNTc4NS44OCBCb2dvTUlQUyAobHBqPTI4OTI5NDAwKQpbICAgIDAuMDc4NTM5XSBw
aWRfbWF4OiBkZWZhdWx0OiAzMjc2OCBtaW5pbXVtOiAzMDEKWyAgICAwLjEwMjYzN10gTW91
bnQtY2FjaGUgaGFzaCB0YWJsZSBlbnRyaWVzOiA1MTIKWyAgICAwLjE3MTkxN10gQlVHOiB1
bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgMDAw
MDAwM2MKWyAgICAwLjE3MzA0N10gSVA6IFs8ZDA1MGI0MDE+XSBjZ3JvdXBfY2Z0c19jb21t
aXQrMHgyMi8weDI1NApbICAgIDAuMTc1NDc1XSAqcGRwdCA9IDAwMDAwMDAwMDAwMDAwMDAg
KnBkZSA9IGYwMDBmZjUzZjAwMGZmNTMgClsgICAgMC4xNzY4OTldIE9vcHM6IDAwMDAgWyMx
XSBTTVAgClsgICAgMC4xNzc5NDBdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDAuMTc5MTEw
XSBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE0LjAtcmMx
LTAwMDUxLWdiMTY2NDkyICM3MjMKWyAgICAwLjE3OTkwMl0gSGFyZHdhcmUgbmFtZTogQm9j
aHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDAuMTgwMDAwXSB0YXNrOiBk
MTA5NzkxMCB0aTogZDEwOTIwMDAgdGFzay50aTogZDEwOTIwMDAKWyAgICAwLjE4MDAwMF0g
RUlQOiAwMDYwOls8ZDA1MGI0MDE+XSBFRkxBR1M6IDAwMjAwMjgyIENQVTogMApbICAgIDAu
MTgwMDAwXSBFSVAgaXMgYXQgY2dyb3VwX2NmdHNfY29tbWl0KzB4MjIvMHgyNTQKWyAgICAw
LjE4MDAwMF0gRUFYOiAwMDAwMDAwMCBFQlg6IGQzMDAzZmEwIEVDWDogMDAwMDAwMDEgRURY
OiAwMDAwMDAwMQpbICAgIDAuMTgwMDAwXSBFU0k6IGQxNTgyMGQ0IEVESTogZDEwYWNjYzQg
RUJQOiBkMTA5M2ZhOCBFU1A6IGQxMDkzZjcwClsgICAgMC4xODAwMDBdICBEUzogMDA3YiBF
UzogMDA3YiBGUzogMDBkOCBHUzogMDBlMCBTUzogMDA2OApbICAgIDAuMTgwMDAwXSBDUjA6
IDgwMDUwMDNiIENSMjogMDAwMDAwM2MgQ1IzOiAxMTU2ZTAwMCBDUjQ6IDAwMDAwNmIwClsg
ICAgMC4xODAwMDBdIERSMDogMDAwMDAwMDAgRFIxOiAwMDAwMDAwMCBEUjI6IDAwMDAwMDAw
IERSMzogMDAwMDAwMDAKWyAgICAwLjE4MDAwMF0gRFI2OiAwMDAwMDAwMCBEUjc6IDAwMDAw
MDAwClsgICAgMC4xODAwMDBdIFN0YWNrOgpbICAgIDAuMTgwMDAwXSAgZDMwMDNmYTAgZDMw
MDNmYTAgZDEwYjFmOWMgZDE1ODIwZDQgZDEwYjFmMDEgZDA1ZDAwMGUgZDA1MGQ3MWQgMDAw
MDAwMGMKWyAgICAwLjE4MDAwMF0gIDAwMDA4MGQwIGQxMDkzZjk0IGQxMDkzZjk0IGQzMDAz
ZmEwIGQxNTgyMGQ0IGQxMGFjY2M0IGQxMDkzZmJjIGQwNTBkNzZkClsgICAgMC4xODAwMDBd
ICAwMDAwMDAwMCAwMDAwMDAwMCBkMTU3MDgwMCBkMTA5M2ZjYyBkMTM4YjViZCAwMDAwMDAw
MCAwMDAyMDgwMCBkMTA5M2ZlOApbICAgIDAuMTgwMDAwXSBDYWxsIFRyYWNlOgpbICAgIDAu
MTgwMDAwXSAgWzxkMDVkMDAwZT5dID8ga21lbV9jYWNoZV9hbGxvY190cmFjZSsweDMzZi8w
eDNiNwpbICAgIDAuMTgwMDAwXSAgWzxkMDUwZDcxZD5dID8gY2dyb3VwX2FkZF9jZnR5cGVz
KzB4MjMvMHhhNwpbICAgIDAuMTgwMDAwXSAgWzxkMDUwZDc2ZD5dIGNncm91cF9hZGRfY2Z0
eXBlcysweDczLzB4YTcKWyAgICAwLjE4MDAwMF0gIFs8ZDEzOGI1YmQ+XSBjZ3JvdXBfaW5p
dCsweDc4LzB4MjliClsgICAgMC4xODAwMDBdICBbPGQxMzY0ZDdkPl0gc3RhcnRfa2VybmVs
KzB4NGQ3LzB4NTdhClsgICAgMC4xODAwMDBdICBbPGQxMzY0MmVmPl0gaTM4Nl9zdGFydF9r
ZXJuZWwrMHg5Mi8weDk2ClsgICAgMC4xODAwMDBdIENvZGU6IGZmIDhkIDY1IGY0IDViIDVl
IDVmIDVkIGMzIDU1IDg5IGU1IDU3IDU2IDUzIDgzIGVjIDJjIGU4IGRiIDIwIDcyIDAwIDg5
IGM2IDg5IDQ1IGQ0IDhkIDQ1IGVjIDg5IDQ1IGVjIDg5IDQ1IGYwIDhiIDQ2IDUwIDg4IDU1
IGQ4IDw4Yj4gNzggM2MgODkgYzMgODkgNDUgZTAgOGIgMDcgODkgNDUgZTQgYjggNWMgMWYg
MGIgZDEgZTggZTMgYzIKWyAgICAwLjE4MDAwMF0gRUlQOiBbPGQwNTBiNDAxPl0gY2dyb3Vw
X2NmdHNfY29tbWl0KzB4MjIvMHgyNTQgU1M6RVNQIDAwNjg6ZDEwOTNmNzAKWyAgICAwLjE4
MDAwMF0gQ1IyOiAwMDAwMDAwMDAwMDAwMDNjClsgICAgMC4xODAwMDBdIC0tLVsgZW5kIHRy
YWNlIGQwZTg3YzIzNTI0ZWMyODUgXS0tLQpbICAgIDAuMTgwMDAwXSBLZXJuZWwgcGFuaWMg
LSBub3Qgc3luY2luZzogRmF0YWwgZXhjZXB0aW9uCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWFuMS0wMjEyMTM1Mi9iMTY2NDkyNDA2MjM5M2JiMDQ4MjAzYmQ0NjIyZTBiMWM5ZTFkMzI4
L2RtZXNnLXlvY3RvLXJvYW0tNDI6MjAxNDAyMTUxMDA2NDI6aTM4Ni1yYW5kY29uZmlnLWFu
MS0wMjEyMTM1MjozLjE0LjAtcmMxLTAwMDUxLWdiMTY2NDkyOjcyMwowOjE6MSBhbGxfZ29v
ZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wMi0xNSAxMDowNzoxMyBSRVBFQVQg
Q09VTlQ6IDIwICAjIC9jYy93ZmcvbW0tYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6
IDEgcmV2aXNpb24gbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMSBzdGVwKQpb
NWY0Njk5MDc4N2UyNzIxYjRkYjE5MGRkYzhhZjZmZGJlOGYwMTBkN10gY2dyb3VwOiB1cGRh
dGUgdGhlIG1lYW5pbmcgb2YgY2Z0eXBlLT5tYXhfd3JpdGVfbGVuCnJ1bm5pbmcgL2Mva2Vy
bmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2Jq
LWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLWFuMS0wMjEyMTM1Mi9uZXh0Om1hc3Rlcjo1ZjQ2OTkwNzg3ZTI3MjFiNGRiMTkwZGRj
OGFmNmZkYmU4ZjAxMGQ3OmJpc2VjdC1tbQoyMDE0LTAyLTE1IDEwOjA3OjEzOiBjbWRfZmFp
bDogJy9iaW4vZ3JlcCcgJy1yJyAnLS1pbmNsdWRlPWRtZXNnLSonICctcycgJy1sJyAnY2dy
b3VwX2NmdHNfY29tbWl0KzB4JyAnL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIx
MzUyLzVmNDY5OTA3ODdlMjcyMWI0ZGIxOTBkZGM4YWY2ZmRiZThmMDEwZDcnICwgcmV0PTIs
IHJlZjogL2tlcm5lbC10ZXN0cy9mYWlsZWQtY21kL2JlZS1ncmVwLXdmZy5sb2cKCjIwMTQt
MDItMTUtMTA6MDc6MTMgNWY0Njk5MDc4N2UyNzIxYjRkYjE5MGRkYzhhZjZmZGJlOGYwMTBk
NyBjb21waWxpbmcKMTM0IHJlYWwgIDE1NTcgdXNlciAgODcgc3lzICAxMjIwLjUzJSBjcHUg
CWkzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIKCjIwMTQtMDItMTUtMTA6MDk6MzggZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjMS0wMDA0OS1nNWY0Njk5MC4uLi4gVEVTVCBG
QUlMVVJFClsgICAgMC4wODIzMjRdIENhbGlicmF0aW5nIGRlbGF5IGxvb3AgKHNraXBwZWQp
LCB2YWx1ZSBjYWxjdWxhdGVkIHVzaW5nIHRpbWVyIGZyZXF1ZW5jeS4uIDU3ODUuODYgQm9n
b01JUFMgKGxwaj0yODkyOTMzMCkKWyAgICAwLjA4MzcwNF0gcGlkX21heDogZGVmYXVsdDog
MzI3NjggbWluaW11bTogMzAxClsgICAgMC4xMDc3MTVdIE1vdW50LWNhY2hlIGhhc2ggdGFi
bGUgZW50cmllczogNTEyClsgICAgMC4yMzMzMDZdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBr
ZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0IDAwMDAwMDNjClsgICAgMC4yMzQy
MDhdIElQOiBbPGNjOTBiM2ZkPl0gY2dyb3VwX2NmdHNfY29tbWl0KzB4MjIvMHgyNTQKWyAg
ICAwLjIzNjEwMF0gKnBkcHQgPSAwMDAwMDAwMDAwMDAwMDAwICpwZGUgPSBmMDAwZmY1M2Yw
MDBmZjUzIApbICAgIDAuMjM3MjE5XSBPb3BzOiAwMDAwIFsjMV0gU01QIApbICAgIDAuMjQw
MDAwXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAwLjI0MDAwMF0gQ1BVOiAwIFBJRDogMCBD
b21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xNC4wLXJjMS0wMDA0OS1nNWY0Njk5MCAj
NzI0ClsgICAgMC4yNDAwMDBdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJv
Y2hzIDAxLzAxLzIwMTEKWyAgICAwLjI0MDAwMF0gdGFzazogY2Q0OTc5MTAgdGk6IGNkNDky
MDAwIHRhc2sudGk6IGNkNDkyMDAwClsgICAgMC4yNDAwMDBdIEVJUDogMDA2MDpbPGNjOTBi
M2ZkPl0gRUZMQUdTOiAwMDIwMDI4MiBDUFU6IDAKWyAgICAwLjI0MDAwMF0gRUlQIGlzIGF0
IGNncm91cF9jZnRzX2NvbW1pdCsweDIyLzB4MjU0ClsgICAgMC4yNDAwMDBdIEVBWDogMDAw
MDAwMDAgRUJYOiBkMzAwM2ZhMCBFQ1g6IDAwMDAwMDAxIEVEWDogMDAwMDAwMDEKWyAgICAw
LjI0MDAwMF0gRVNJOiBjZDk4MjBkNCBFREk6IGNkNGFjY2M0IEVCUDogY2Q0OTNmYTggRVNQ
OiBjZDQ5M2Y3MApbICAgIDAuMjQwMDAwXSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDgg
R1M6IDAwZTAgU1M6IDAwNjgKWyAgICAwLjI0MDAwMF0gQ1IwOiA4MDA1MDAzYiBDUjI6IDAw
MDAwMDNjIENSMzogMGQ5NmUwMDAgQ1I0OiAwMDAwMDZiMApbICAgIDAuMjQwMDAwXSBEUjA6
IDAwMDAwMDAwIERSMTogMDAwMDAwMDAgRFIyOiAwMDAwMDAwMCBEUjM6IDAwMDAwMDAwClsg
ICAgMC4yNDAwMDBdIERSNjogMDAwMDAwMDAgRFI3OiAwMDAwMDAwMApbICAgIDAuMjQwMDAw
XSBTdGFjazoKWyAgICAwLjI0MDAwMF0gIGQzMDAzZmEwIGQzMDAzZmEwIGNkNGIxZjljIGNk
OTgyMGQ0IGNkNGIxZjAxIGNjOWNmZmY4IGNjOTBkNzA3IDAwMDAwMDBjClsgICAgMC4yNDAw
MDBdICAwMDAwODBkMCBjZDQ5M2Y5NCBjZDQ5M2Y5NCBkMzAwM2ZhMCBjZDk4MjBkNCBjZDRh
Y2NjNCBjZDQ5M2ZiYyBjYzkwZDc1NwpbICAgIDAuMjQwMDAwXSAgMDAwMDAwMDAgMDAwMDAw
MDAgY2Q5NzA4MDAgY2Q0OTNmY2MgY2Q3OGI1YTUgMDAwMDAwMDAgMDAwMjA4MDAgY2Q0OTNm
ZTgKWyAgICAwLjI0MDAwMF0gQ2FsbCBUcmFjZToKWyAgICAwLjI0MDAwMF0gIFs8Y2M5Y2Zm
Zjg+XSA/IGttZW1fY2FjaGVfYWxsb2NfdHJhY2UrMHgzM2YvMHgzYjcKWyAgICAwLjI0MDAw
MF0gIFs8Y2M5MGQ3MDc+XSA/IGNncm91cF9hZGRfY2Z0eXBlcysweDIzLzB4YTcKWyAgICAw
LjI0MDAwMF0gIFs8Y2M5MGQ3NTc+XSBjZ3JvdXBfYWRkX2NmdHlwZXMrMHg3My8weGE3Clsg
ICAgMC4yNDAwMDBdICBbPGNkNzhiNWE1Pl0gY2dyb3VwX2luaXQrMHg2MC8weDI4NwpbICAg
IDAuMjQwMDAwXSAgWzxjZDc2NGQ3ZD5dIHN0YXJ0X2tlcm5lbCsweDRkNy8weDU3YQpbICAg
IDAuMjQwMDAwXSAgWzxjZDc2NDJlZj5dIGkzODZfc3RhcnRfa2VybmVsKzB4OTIvMHg5Ngpb
ICAgIDAuMjQwMDAwXSBDb2RlOiBmZiA4ZCA2NSBmNCA1YiA1ZSA1ZiA1ZCBjMyA1NSA4OSBl
NSA1NyA1NiA1MyA4MyBlYyAyYyBlOCBkZiAyMCA3MiAwMCA4OSBjNiA4OSA0NSBkNCA4ZCA0
NSBlYyA4OSA0NSBlYyA4OSA0NSBmMCA4YiA0NiA1MCA4OCA1NSBkOCA8OGI+IDc4IDNjIDg5
IGMzIDg5IDQ1IGUwIDhiIDA3IDg5IDQ1IGU0IGI4IDVjIDFmIDRiIGNkIGU4IGQ3IGMyClsg
ICAgMC4yNDAwMDBdIEVJUDogWzxjYzkwYjNmZD5dIGNncm91cF9jZnRzX2NvbW1pdCsweDIy
LzB4MjU0IFNTOkVTUCAwMDY4OmNkNDkzZjcwClsgICAgMC4yNDAwMDBdIENSMjogMDAwMDAw
MDAwMDAwMDAzYwpbICAgIDAuMjQwMDAwXSAtLS1bIGVuZCB0cmFjZSAyYzZhOTkzZGZlYzgy
YTgxIF0tLS0KWyAgICAwLjI0MDAwMF0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEZh
dGFsIGV4Y2VwdGlvbgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvNWY0
Njk5MDc4N2UyNzIxYjRkYjE5MGRkYzhhZjZmZGJlOGYwMTBkNy9kbWVzZy15b2N0by1yb2Ft
LTU3OjIwMTQwMjE1MTAxMTI2OmkzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTI6My4xNC4w
LXJjMS0wMDA0OS1nNWY0Njk5MDo3MjQKMDoxOjEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9v
dHMKG1sxOzM1bTIwMTQtMDItMTUgMTA6MTE6MzggUkVQRUFUIENPVU5UOiAyMCAgIyAvY2Mv
d2ZnL21tLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAwIHN0ZXBzKQpbZGUwMGZmYTU2ZWEzMTMy
YzYwMTNmYzhmMDcxMzNiOGExMDE0Y2Y1M10gY2dyb3VwOiBtYWtlIGNncm91cF9zdWJzeXMt
PmJhc2VfY2Z0eXBlcyB1c2UgY2dyb3VwX2FkZF9jZnR5cGVzKCkKcnVubmluZyAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9tbS9vYmot
YmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctYW4xLTAyMTIxMzUyL25leHQ6bWFzdGVyOmRlMDBmZmE1NmVhMzEzMmM2MDEzZmM4ZjA3
MTMzYjhhMTAxNGNmNTM6YmlzZWN0LW1tCjIwMTQtMDItMTUgMTA6MTE6Mzk6IGNtZF9mYWls
OiAnL2Jpbi9ncmVwJyAnLXInICctLWluY2x1ZGU9ZG1lc2ctKicgJy1zJyAnLWwnICdjZ3Jv
dXBfY2Z0c19jb21taXQrMHgnICcva2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEz
NTIvZGUwMGZmYTU2ZWEzMTMyYzYwMTNmYzhmMDcxMzNiOGExMDE0Y2Y1MycgLCByZXQ9Miwg
cmVmOiAva2VybmVsLXRlc3RzL2ZhaWxlZC1jbWQvYmVlLWdyZXAtd2ZnLmxvZwoKMjAxNC0w
Mi0xNS0xMDoxMTozOSBkZTAwZmZhNTZlYTMxMzJjNjAxM2ZjOGYwNzEzM2I4YTEwMTRjZjUz
IGNvbXBpbGluZwoxNDIgcmVhbCAgMTUzMiB1c2VyICA4NiBzeXMgIDExMzcuMjglIGNwdSAJ
aTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1MgoKMjAxNC0wMi0xNS0xMDoxNDoxMiBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmMxLTAwMDQ4LWdkZTAwZmZhLi4uIFRFU1QgRkFJ
TFVSRQpbICAgIDAuMDIwMDAwXSBDYWxpYnJhdGluZyBkZWxheSBsb29wIChza2lwcGVkKSBw
cmVzZXQgdmFsdWUuLiA1Nzg1Ljk0IEJvZ29NSVBTIChscGo9Mjg5Mjk3MjApClsgICAgMC4w
MjAwMDBdIHBpZF9tYXg6IGRlZmF1bHQ6IDMyNzY4IG1pbmltdW06IDMwMQpbICAgIDAuMDIw
MDAwXSBNb3VudC1jYWNoZSBoYXNoIHRhYmxlIGVudHJpZXM6IDUxMgpbICAgIDAuMDIwMDAw
XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5j
ZSBhdCAwMDAwMDAzYwpbICAgIDAuMDIwMDAwXSBJUDogWzxjOWIwYjQyNj5dIGNncm91cF9j
ZnRzX2NvbW1pdCsweDIyLzB4MjU0ClsgICAgMC4wMjAwMDBdICpwZHB0ID0gMDAwMDAwMDAw
MDAwMDAwMCAqcGRlID0gZjAwMGZmNTNmMDAwZmY1MyAKWyAgICAwLjAyMDAwMF0gT29wczog
MDAwMCBbIzFdIFNNUCAKWyAgICAwLjAyMDAwMF0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAg
MC4wMjAwMDBdIENQVTogMCBQSUQ6IDAgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMu
MTQuMC1yYzEtMDAwNDgtZ2RlMDBmZmEgIzcyNQpbICAgIDAuMDIwMDAwXSBIYXJkd2FyZSBu
YW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMC4wMjAwMDBd
IHRhc2s6IGNhNjk3OTEwIHRpOiBjYTY5MjAwMCB0YXNrLnRpOiBjYTY5MjAwMApbICAgIDAu
MDIwMDAwXSBFSVA6IDAwNjA6WzxjOWIwYjQyNj5dIEVGTEFHUzogMDAyMTAyODIgQ1BVOiAw
ClsgICAgMC4wMjAwMDBdIEVJUCBpcyBhdCBjZ3JvdXBfY2Z0c19jb21taXQrMHgyMi8weDI1
NApbICAgIDAuMDIwMDAwXSBFQVg6IDAwMDAwMDAwIEVCWDogZDMwMDRmYTAgRUNYOiAwMDAw
MDAwMSBFRFg6IDAwMDAwMDAxClsgICAgMC4wMjAwMDBdIEVTSTogY2FiODIwZDQgRURJOiBj
YTZhY2NjNCBFQlA6IGNhNjkzZmE4IEVTUDogY2E2OTNmNzAKWyAgICAwLjAyMDAwMF0gIERT
OiAwMDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAwMGUwIFNTOiAwMDY4ClsgICAgMC4wMjAw
MDBdIENSMDogODAwNTAwM2IgQ1IyOiAwMDAwMDAzYyBDUjM6IDBhYjZlMDAwIENSNDogMDAw
MDA2YjAKWyAgICAwLjAyMDAwMF0gU3RhY2s6ClsgICAgMC4wMjAwMDBdICBkMzAwNGZhMCBk
MzAwNGZhMCBjYTZiMWY5YyBjYWI4MjBkNCBjYTZiMWYwMSBjOWJkMDAyMSBjOWIwZDczMCAw
MDAwMDAwYwpbICAgIDAuMDIwMDAwXSAgMDAwMDgwZDAgY2E2OTNmOTQgY2E2OTNmOTQgZDMw
MDRmYTAgY2FiODIwZDQgY2E2YWNjYzQgY2E2OTNmYmMgYzliMGQ3ODAKWyAgICAwLjAyMDAw
MF0gIDAwMDAwMDAwIDAwMDAwMDAwIGNhYjcwODAwIGNhNjkzZmNjIGNhOThiNWE1IDAwMDAw
MDAwIDAwMDIwODAwIGNhNjkzZmU4ClsgICAgMC4wMjAwMDBdIENhbGwgVHJhY2U6ClsgICAg
MC4wMjAwMDBdICBbPGM5YmQwMDIxPl0gPyBrbWVtX2NhY2hlX2FsbG9jX3RyYWNlKzB4MzNm
LzB4M2I3ClsgICAgMC4wMjAwMDBdICBbPGM5YjBkNzMwPl0gPyBjZ3JvdXBfYWRkX2NmdHlw
ZXMrMHgyMy8weGE3ClsgICAgMC4wMjAwMDBdICBbPGM5YjBkNzgwPl0gY2dyb3VwX2FkZF9j
ZnR5cGVzKzB4NzMvMHhhNwpbICAgIDAuMDIwMDAwXSAgWzxjYTk4YjVhNT5dIGNncm91cF9p
bml0KzB4NjAvMHgyODcKWyAgICAwLjAyMDAwMF0gIFs8Y2E5NjRkN2Q+XSBzdGFydF9rZXJu
ZWwrMHg0ZDcvMHg1N2EKWyAgICAwLjAyMDAwMF0gIFs8Y2E5NjQyZWY+XSBpMzg2X3N0YXJ0
X2tlcm5lbCsweDkyLzB4OTYKWyAgICAwLjAyMDAwMF0gQ29kZTogZmYgOGQgNjUgZjQgNWIg
NWUgNWYgNWQgYzMgNTUgODkgZTUgNTcgNTYgNTMgODMgZWMgMmMgZTggZDYgMjAgNzIgMDAg
ODkgYzYgODkgNDUgZDQgOGQgNDUgZWMgODkgNDUgZWMgODkgNDUgZjAgOGIgNDYgNTAgODgg
NTUgZDggPDhiPiA3OCAzYyA4OSBjMyA4OSA0NSBlMCA4YiAwNyA4OSA0NSBlNCBiOCA1YyAx
ZiA2YiBjYSBlOCBjZSBjMgpbICAgIDAuMDIwMDAwXSBFSVA6IFs8YzliMGI0MjY+XSBjZ3Jv
dXBfY2Z0c19jb21taXQrMHgyMi8weDI1NCBTUzpFU1AgMDA2ODpjYTY5M2Y3MApbICAgIDAu
MDIwMDAwXSBDUjI6IDAwMDAwMDAwMDAwMDAwM2MKWyAgICAwLjAyMDAwMF0gLS0tWyBlbmQg
dHJhY2UgNzA0MzYyOGZjZDMxN2E3OSBdLS0tClsgICAgMC4wMjAwMDBdIEtlcm5lbCBwYW5p
YyAtIG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRpb24KL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctYW4xLTAyMTIxMzUyL2RlMDBmZmE1NmVhMzEzMmM2MDEzZmM4ZjA3MTMzYjhhMTAxNGNm
NTMvZG1lc2cteW9jdG8teGlhbi0yMToyMDE0MDIxNTEwMTUzMjppMzg2LXJhbmRjb25maWct
YW4xLTAyMTIxMzUyOjMuMTQuMC1yYzEtMDAwNDgtZ2RlMDBmZmE6NzI1CjA6MToxIGFsbF9n
b29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTAyLTE1IDEwOjE1OjQyIFJFUEVB
VCBDT1VOVDogMjAgICMgL2NjL3dmZy9tbS1iaXNlY3QvLnJlcGVhdBtbMG0KCmRlMDBmZmE1
NmVhMzEzMmM2MDEzZmM4ZjA3MTMzYjhhMTAxNGNmNTMgaXMgdGhlIGZpcnN0IGJhZCBjb21t
aXQKY29tbWl0IGRlMDBmZmE1NmVhMzEzMmM2MDEzZmM4ZjA3MTMzYjhhMTAxNGNmNTMKQXV0
aG9yOiBUZWp1biBIZW8gPHRqQGtlcm5lbC5vcmc+CkRhdGU6ICAgVHVlIEZlYiAxMSAxMTo1
Mjo0OCAyMDE0IC0wNTAwCgogICAgY2dyb3VwOiBtYWtlIGNncm91cF9zdWJzeXMtPmJhc2Vf
Y2Z0eXBlcyB1c2UgY2dyb3VwX2FkZF9jZnR5cGVzKCkKICAgIAogICAgQ3VycmVudGx5LCBj
Z3JvdXBfc3Vic3lzLT5iYXNlX2NmdHlwZXMgcmVnaXN0cmF0aW9uIGlzIGRpZmZlcmVudCBm
cm9tCiAgICBkeW5hbWljIGNmdHlwZXMgcmVnaXN0YXJ0aW9uLiAgSW5zdGVhZCBvZiBnb2lu
ZyB0aHJvdWdoCiAgICBjZ3JvdXBfYWRkX2NmdHlwZXMoKSwgY2dyb3VwX2luaXRfc3Vic3lz
KCkgaW52b2tlcwogICAgY2dyb3VwX2luaXRfY2Z0c2V0cygpIHdoaWNoIG1ha2VzIHVzZSBv
ZiBjZ3JvdXBfc3Vic3lzLT5iYXNlX2NmdHNldAogICAgd2hpY2ggZG9lc24ndCBpbnZvbHZl
IGR5bmFtaWMgYWxsb2NhdGlvbi4KICAgIAogICAgV2hpbGUgYXZvaWRpbmcgZHluYW1pYyBh
bGxvY2F0aW9uIGlzIHNvbWV3aGF0IG5pY2UsIGhhdmluZyB0d28KICAgIHNlcGFyYXRlIHBh
dGhzIGZvciBjZnR5cGVzIHJlZ2lzdHJhdGlvbiBpcyBuYXN0eSwgZXNwZWNpYWxseSBhcyB3
ZSdyZQogICAgcGxhbm5pbmcgdG8gYWRkIG1vcmUgb3BlcmF0aW9ucyBkdXJpbmcgY2Z0eXBl
cyByZWdpc3RyYXRpb24uCiAgICAKICAgIFRoaXMgcGF0Y2ggZHJvcHMgY2dyb3VwX2luaXRf
Y2Z0c2V0cygpIGFuZCBjZ3JvdXBfc3Vic3lzLT5iYXNlX2NmdHNldAogICAgYW5kIHJlZ2lz
dGVycyBiYXNlX2NmdHlwZXMgdXNpbmcgY2dyb3VwX2FkZF9jZnR5cGVzKCkuICBUaGlzIGlz
IGRvbmUKICAgIGFzIGEgc2VwYXJhdGUgc3RlcCBpbiBjZ3JvdXBfaW5pdCgpIGluc3RlYWQg
b2YgYSBwYXJ0IG9mCiAgICBjZ3JvdXBfaW5pdF9zdWJzeXMoKS4gIFRoaXMgaXMgYmVjYXVz
ZSBjZ3JvdXBfaW5pdF9zdWJzeXMoKSBjYW4gYmUKICAgIGNhbGxlZCB2ZXJ5IGVhcmx5IGR1
cmluZyBib290IHdoZW4ga21hbGxvYygpIGlzbid0IGF2YWlsYWJsZSB5ZXQuCiAgICAKICAg
IFNpZ25lZC1vZmYtYnk6IFRlanVuIEhlbyA8dGpAa2VybmVsLm9yZz4KICAgIEFja2VkLWJ5
OiBMaSBaZWZhbiA8bGl6ZWZhbkBodWF3ZWkuY29tPgoKOjA0MDAwMCAwNDAwMDAgYzVjOTky
YTg5OGZmMWRlZGJlMzFkYTJmMzIzM2U0NDc2MjA3YWY3NiA1NzUzOTJkYTgzMWU4MWVmZDRi
MjBjNzNjMTQ3YmY4MGQ2MzBiN2YxIE0JaW5jbHVkZQo6MDQwMDAwIDA0MDAwMCBjZmYxMDFm
MTc0ZTUyNmQzOTU4ZjlkMmMyNGFkZTY3YjBhMWQyZmRiIDM0NTY5ODZlNDBhOWE3M2JiYmVm
Y2YxOWNkYjZjZjVkYjVmYTZkMjEgTQlrZXJuZWwKYmlzZWN0IHJ1biBzdWNjZXNzCmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIx
MzUyL25leHQ6bWFzdGVyOjhkN2U2ZmIwYTFkYjk3MGFjMzU4OWY4N2FmMGYyYTIwZWY0NjY1
NGI6YmlzZWN0LW1tCgoyMDE0LTAyLTE1LTEwOjE1OjQzIDhkN2U2ZmIwYTFkYjk3MGFjMzU4
OWY4N2FmMGYyYTIwZWY0NjY1NGIgcmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4x
LTAyMTIxMzUyLzhkN2U2ZmIwYTFkYjk3MGFjMzU4OWY4N2FmMGYyYTIwZWY0NjY1NGIvdm1s
aW51ei0zLjE0LjAtcmMxLTAwMDQ3LWc4ZDdlNmZiCgoyMDE0LTAyLTE1LTEwOjE1OjQzIGRl
dGVjdGluZyBib290IHN0YXRlIC4uLi4JMS4uLi4uLgkyLi4uCTYJOC4uLi4uLi4JOQkxMC4u
Li4uLgkxMS4JMTIuLi4uCTEzCTE1Li4JMTcJMjAJMjEJMjMJMjQuLi4JMjUuCTI3CTMwCTMx
CTMyCTM0LgkzNS4JMzcJMzgJNDIJNTAJNTMJNTYuLi4uLgk1OS4uLi4JNjAgU1VDQ0VTUwoK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1hbjEt
MDIxMjEzNTIvbmV4dDptYXN0ZXI6NDYwMjE3NTgzYzkzNDExMDg2NWEyZjVkY2U1ZTFiNWM5
ODgzNWE0NjpiaXNlY3QtbW0KIFRFU1QgRkFJTFVSRQpCVUc6IGtlcm5lbCBlYXJseSBoYW5n
IHdpdGhvdXQgYW55IHByaW50ayBvdXRwdXQKQ29tbWFuZCBsaW5lOiBodW5nX3Rhc2tfcGFu
aWM9MSBlYXJseXByaW50az10dHlTMCwxMTUyMDAgZGVidWcgYXBpYz1kZWJ1ZyBzeXNycV9h
bHdheXNfZW5hYmxlZCBwYW5pYz0xMCBzb2Z0bG9ja3VwX3BhbmljPTEgbm1pX3dhdGNoZG9n
PXBhbmljICBwcm9tcHRfcmFtZGlzaz0wIGNvbnNvbGU9dHR5UzAsMTE1MjAwIGNvbnNvbGU9
dHR5MCB2Z2E9bm9ybWFsICByb290PS9kZXYvcmFtMCBydyBsaW5rPS9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyL25leHQ6bWFzdGVy
OjQ2MDIxNzU4M2M5MzQxMTA4NjVhMmY1ZGNlNWUxYjVjOTg4MzVhNDY6YmlzZWN0LW1tLy52
bWxpbnV6LTQ2MDIxNzU4M2M5MzQxMTA4NjVhMmY1ZGNlNWUxYjVjOTg4MzVhNDYtMjAxNDAy
MTQxNDIyNTMtMi1zbmItcmV0cnktYXRoZW5zIGJyYW5jaD1uZXh0L21hc3RlciBCT09UX0lN
QUdFPS9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1Mi80NjAyMTc1ODNjOTM0
MTEwODY1YTJmNWRjZTVlMWI1Yzk4ODM1YTQ2L3ZtbGludXotMy4xNC4wLXJjMi1uZXh0LTIw
MTQwMjEyLTAyNTIxLWc0NjAyMTc1CkVhcmx5IGhhbmcga2VybmVsOiB2bWxpbnV6LTMuMTQu
MC1yYzItbmV4dC0yMDE0MDIxMi0wMjUyMS1nNDYwMjE3NSAzLjE0LjAtcmMyLW5leHQtMjAx
NDAyMTItMDI1MjEtZzQ2MDIxNzUgIzEKRWxhcHNlZCB0aW1lOiAzNQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvNDYwMjE3NTgzYzkzNDExMDg2NWEyZjVkY2U1ZTFi
NWM5ODgzNWE0Ni9kbWVzZy15b2N0by1yb2FtLTEwOjIwMTQwMjE0MjE1NzIwOmkzODYtcmFu
ZGNvbmZpZy1hbjEtMDIxMjEzNTI6My4xNC4wLXJjMi1uZXh0LTIwMTQwMjEyLTAyNTIxLWc0
NjAyMTc1OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyLzQ2MDIxNzU4
M2M5MzQxMTA4NjVhMmY1ZGNlNWUxYjVjOTg4MzVhNDYvZG1lc2cteW9jdG8tc25iLTY6MjAx
NDAyMTUwMTQwMzA6aTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1MjozLjE0LjAtcmMyLW5l
eHQtMjAxNDAyMTItMDI1MjEtZzQ2MDIxNzU6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1h
bjEtMDIxMjEzNTIvNDYwMjE3NTgzYzkzNDExMDg2NWEyZjVkY2U1ZTFiNWM5ODgzNWE0Ni9k
bWVzZy1xdWFudGFsLXJvYW0tNTU6MjAxNDAyMTUwMzE5MzY6aTM4Ni1yYW5kY29uZmlnLWFu
MS0wMjEyMTM1MjozLjE0LjAtcmMyLW5leHQtMjAxNDAyMTItMDI1MjEtZzQ2MDIxNzU6MQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvNDYwMjE3NTgzYzkzNDExMDg2
NWEyZjVkY2U1ZTFiNWM5ODgzNWE0Ni9kbWVzZy15b2N0by1jYWlyby0zOjIwMTQwMjEzMDc0
OTM2OmkzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTI6My4xNC4wLXJjMi1uZXh0LTIwMTQw
MjEyLTAyNTIxLWc0NjAyMTc1OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIx
MzUyLzQ2MDIxNzU4M2M5MzQxMTA4NjVhMmY1ZGNlNWUxYjVjOTg4MzVhNDYvZG1lc2ctcXVh
bnRhbC1yb2FtLTk6MjAxNDAyMTUwMzE5MzY6aTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1
MjozLjE0LjAtcmMyLW5leHQtMjAxNDAyMTItMDI1MjEtZzQ2MDIxNzU6MQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvNDYwMjE3NTgzYzkzNDExMDg2NWEyZjVkY2U1
ZTFiNWM5ODgzNWE0Ni9kbWVzZy15b2N0by1qYWtldG93bi0yOjIwMTQwMjEyMTQzNzE2Omkz
ODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTI6My4xNC4wLXJjMi1uZXh0LTIwMTQwMjEyLTAy
NTIxLWc0NjAyMTc1OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyLzQ2
MDIxNzU4M2M5MzQxMTA4NjVhMmY1ZGNlNWUxYjVjOTg4MzVhNDYvZG1lc2cteW9jdG8tcm9h
bS0xMDoyMDE0MDIxNDIxNTY0MDppMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyOjMuMTQu
MC1yYzItbmV4dC0yMDE0MDIxMi0wMjUyMS1nNDYwMjE3NToxCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWFuMS0wMjEyMTM1Mi80NjAyMTc1ODNjOTM0MTEwODY1YTJmNWRjZTVlMWI1Yzk4
ODM1YTQ2L2RtZXNnLXlvY3RvLWF0aGVucy0yMjoyMDE0MDIxNTAxMzEwMjppMzg2LXJhbmRj
b25maWctYW4xLTAyMTIxMzUyOjMuMTQuMC1yYzItbmV4dC0yMDE0MDIxMi0wMjUyMS1nNDYw
MjE3NToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1Mi80NjAyMTc1ODNj
OTM0MTEwODY1YTJmNWRjZTVlMWI1Yzk4ODM1YTQ2L2RtZXNnLXF1YW50YWwteGlhbi00Mjoy
MDE0MDIxNTAzMTQwOTppMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyOjMuMTQuMC1yYzIt
bmV4dC0yMDE0MDIxMi0wMjUyMS1nNDYwMjE3NToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWFuMS0wMjEyMTM1Mi80NjAyMTc1ODNjOTM0MTEwODY1YTJmNWRjZTVlMWI1Yzk4ODM1YTQ2
L2RtZXNnLXlvY3RvLWlubi0zNzoyMDE0MDIxNTAxMjgxMjppMzg2LXJhbmRjb25maWctYW4x
LTAyMTIxMzUyOjMuMTQuMC1yYzItbmV4dC0yMDE0MDIxMi0wMjUyMS1nNDYwMjE3NToxCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1Mi80NjAyMTc1ODNjOTM0MTEwODY1
YTJmNWRjZTVlMWI1Yzk4ODM1YTQ2L2RtZXNnLXlvY3RvLWJlbnMtNToyMDE0MDIxNTAxMTEy
NjppMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyOjMuMTQuMC1yYzItbmV4dC0yMDE0MDIx
Mi0wMjUyMS1nNDYwMjE3NToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1
Mi80NjAyMTc1ODNjOTM0MTEwODY1YTJmNWRjZTVlMWI1Yzk4ODM1YTQ2L2RtZXNnLXF1YW50
YWwtYXRoZW5zLTQ3OjIwMTQwMjE1MDYxNDE0OmkzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEz
NTI6My4xNC4wLXJjMi1uZXh0LTIwMTQwMjEyLTAyNTIxLWc0NjAyMTc1OjEKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyLzQ2MDIxNzU4M2M5MzQxMTA4NjVhMmY1ZGNl
NWUxYjVjOTg4MzVhNDYvZG1lc2ctcXVhbnRhbC1jYWlyby0zODoyMDE0MDIxMzA3NDcxNDpp
Mzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyOjMuMTQuMC1yYzItbmV4dC0yMDE0MDIxMi0w
MjUyMS1nNDYwMjE3NToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1Mi80
NjAyMTc1ODNjOTM0MTEwODY1YTJmNWRjZTVlMWI1Yzk4ODM1YTQ2L2RtZXNnLXlvY3RvLXhp
YW4tMTk6MjAxNDAyMTMwNzQ4NDI6aTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1MjozLjE0
LjAtcmMyLW5leHQtMjAxNDAyMTItMDI1MjEtZzQ2MDIxNzU6MQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1hbjEtMDIxMjEzNTIvNDYwMjE3NTgzYzkzNDExMDg2NWEyZjVkY2U1ZTFiNWM5
ODgzNWE0Ni9kbWVzZy15b2N0by1yb2FtLTIyOjIwMTQwMjE0MjE1ODA2OmkzODYtcmFuZGNv
bmZpZy1hbjEtMDIxMjEzNTI6My4xNC4wLXJjMi1uZXh0LTIwMTQwMjEyLTAyNTIxLWc0NjAy
MTc1OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyLzQ2MDIxNzU4M2M5
MzQxMTA4NjVhMmY1ZGNlNWUxYjVjOTg4MzVhNDYvZG1lc2ctcXVhbnRhbC1pbm4tNjoyMDE0
MDIxNTA2MTU0NjppMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyOjMuMTQuMC1yYzItbmV4
dC0yMDE0MDIxMi0wMjUyMS1nNDYwMjE3NToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFu
MS0wMjEyMTM1Mi80NjAyMTc1ODNjOTM0MTEwODY1YTJmNWRjZTVlMWI1Yzk4ODM1YTQ2L2Rt
ZXNnLXlvY3RvLXhpYW4tNDg6MjAxNDAyMTUwNjE2NDI6aTM4Ni1yYW5kY29uZmlnLWFuMS0w
MjEyMTM1MjozLjE0LjAtcmMyLW5leHQtMjAxNDAyMTItMDI1MjEtZzQ2MDIxNzU6MQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvNDYwMjE3NTgzYzkzNDExMDg2NWEy
ZjVkY2U1ZTFiNWM5ODgzNWE0Ni9kbWVzZy15b2N0by1yb2FtLTIwOjIwMTQwMjE0MjE1OTUz
OmkzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTI6My4xNC4wLXJjMi1uZXh0LTIwMTQwMjEy
LTAyNTIxLWc0NjAyMTc1OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUy
LzQ2MDIxNzU4M2M5MzQxMTA4NjVhMmY1ZGNlNWUxYjVjOTg4MzVhNDYvZG1lc2cteW9jdG8t
amFrZXRvd24tOToyMDE0MDIxMjE0MzcxNjppMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUy
OjMuMTQuMC1yYzItbmV4dC0yMDE0MDIxMi0wMjUyMS1nNDYwMjE3NToxCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1Mi80NjAyMTc1ODNjOTM0MTEwODY1YTJmNWRjZTVl
MWI1Yzk4ODM1YTQ2L2RtZXNnLXlvY3RvLXhpYW4tMTA6MjAxNDAyMTUwNjEzMjU6aTM4Ni1y
YW5kY29uZmlnLWFuMS0wMjEyMTM1MjozLjE0LjAtcmMyLW5leHQtMjAxNDAyMTItMDI1MjEt
ZzQ2MDIxNzU6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvNDYwMjE3
NTgzYzkzNDExMDg2NWEyZjVkY2U1ZTFiNWM5ODgzNWE0Ni9kbWVzZy15b2N0by1zbmItMjQ6
MjAxNDAyMTUwMzE3NDM6aTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1MjozLjE0LjAtcmMy
LW5leHQtMjAxNDAyMTItMDI1MjEtZzQ2MDIxNzU6MQova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1hbjEtMDIxMjEzNTIvNDYwMjE3NTgzYzkzNDExMDg2NWEyZjVkY2U1ZTFiNWM5ODgzNWE0
Ni9kbWVzZy1xdWFudGFsLXhpYW4tNTU6MjAxNDAyMTIxNDM0MTk6aTM4Ni1yYW5kY29uZmln
LWFuMS0wMjEyMTM1MjozLjE0LjAtcmMyLW5leHQtMjAxNDAyMTItMDI1MjEtZzQ2MDIxNzU6
MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvNDYwMjE3NTgzYzkzNDEx
MDg2NWEyZjVkY2U1ZTFiNWM5ODgzNWE0Ni9kbWVzZy15b2N0by1pbm4tMzE6MjAxNDAyMTUw
MzEzMjY6aTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1MjozLjE0LjAtcmMyLW5leHQtMjAx
NDAyMTItMDI1MjEtZzQ2MDIxNzU6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDIx
MjEzNTIvNDYwMjE3NTgzYzkzNDExMDg2NWEyZjVkY2U1ZTFiNWM5ODgzNWE0Ni9kbWVzZy1x
dWFudGFsLXJvYW0tMjU6MjAxNDAyMTQyMjAwMDM6aTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEy
MTM1MjozLjE0LjAtcmMyLW5leHQtMjAxNDAyMTItMDI1MjEtZzQ2MDIxNzU6MQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvNDYwMjE3NTgzYzkzNDExMDg2NWEyZjVk
Y2U1ZTFiNWM5ODgzNWE0Ni9kbWVzZy15b2N0by1hdGhlbnMtNDk6MjAxNDAyMTUwMTExNDI6
aTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1MjozLjE0LjAtcmMyLW5leHQtMjAxNDAyMTIt
MDI1MjEtZzQ2MDIxNzU6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIv
NDYwMjE3NTgzYzkzNDExMDg2NWEyZjVkY2U1ZTFiNWM5ODgzNWE0Ni9kbWVzZy1xdWFudGFs
LWF0aGVucy01NToyMDE0MDIxNTA2MTYwNjppMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUy
OjMuMTQuMC1yYzItbmV4dC0yMDE0MDIxMi0wMjUyMS1nNDYwMjE3NToxCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1Mi80NjAyMTc1ODNjOTM0MTEwODY1YTJmNWRjZTVl
MWI1Yzk4ODM1YTQ2L2RtZXNnLXF1YW50YWwteGlhbi0xMDoyMDE0MDIxMjE0MzQxOTppMzg2
LXJhbmRjb25maWctYW4xLTAyMTIxMzUyOjMuMTQuMC1yYzItbmV4dC0yMDE0MDIxMi0wMjUy
MS1nNDYwMjE3NToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1Mi80NjAy
MTc1ODNjOTM0MTEwODY1YTJmNWRjZTVlMWI1Yzk4ODM1YTQ2L2RtZXNnLXlvY3RvLWlubi00
NzoyMDE0MDIxNDIxNTU0NzppMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyOjMuMTQuMC1y
YzItbmV4dC0yMDE0MDIxMi0wMjUyMS1nNDYwMjE3NToxCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWFuMS0wMjEyMTM1Mi80NjAyMTc1ODNjOTM0MTEwODY1YTJmNWRjZTVlMWI1Yzk4ODM1
YTQ2L2RtZXNnLXF1YW50YWwtamFrZXRvd24tNToyMDE0MDIxNTAxMTI1ODppMzg2LXJhbmRj
b25maWctYW4xLTAyMTIxMzUyOjMuMTQuMC1yYzItbmV4dC0yMDE0MDIxMi0wMjUyMS1nNDYw
MjE3NToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1Mi80NjAyMTc1ODNj
OTM0MTEwODY1YTJmNWRjZTVlMWI1Yzk4ODM1YTQ2L2RtZXNnLXlvY3RvLXhpYW4tNTc6MjAx
NDAyMTUwMzExNDI6aTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1MjozLjE0LjAtcmMyLW5l
eHQtMjAxNDAyMTItMDI1MjEtZzQ2MDIxNzU6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1h
bjEtMDIxMjEzNTIvNDYwMjE3NTgzYzkzNDExMDg2NWEyZjVkY2U1ZTFiNWM5ODgzNWE0Ni9k
bWVzZy1xdWFudGFsLXJvYW0tMjI6MjAxNDAyMTUwMzE5MzY6aTM4Ni1yYW5kY29uZmlnLWFu
MS0wMjEyMTM1MjozLjE0LjAtcmMyLW5leHQtMjAxNDAyMTItMDI1MjEtZzQ2MDIxNzU6MQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvNDYwMjE3NTgzYzkzNDExMDg2
NWEyZjVkY2U1ZTFiNWM5ODgzNWE0Ni9kbWVzZy15b2N0by14aWFuLTE5OjIwMTQwMjE0MjE1
NTIxOmkzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTI6My4xNC4wLXJjMi1uZXh0LTIwMTQw
MjEyLTAyNTIxLWc0NjAyMTc1OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIx
MzUyLzQ2MDIxNzU4M2M5MzQxMTA4NjVhMmY1ZGNlNWUxYjVjOTg4MzVhNDYvZG1lc2cteW9j
dG8teGlhbi02NDoyMDE0MDIxMjE0MzQxOTppMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUy
OjMuMTQuMC1yYzItbmV4dC0yMDE0MDIxMi0wMjUyMS1nNDYwMjE3NToxCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1Mi80NjAyMTc1ODNjOTM0MTEwODY1YTJmNWRjZTVl
MWI1Yzk4ODM1YTQ2L2RtZXNnLXF1YW50YWwtYXRoZW5zLTI3OjIwMTQwMjE1MDYxNTQxOmkz
ODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTI6My4xNC4wLXJjMi1uZXh0LTIwMTQwMjEyLTAy
NTIxLWc0NjAyMTc1OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyLzQ2
MDIxNzU4M2M5MzQxMTA4NjVhMmY1ZGNlNWUxYjVjOTg4MzVhNDYvZG1lc2ctcXVhbnRhbC1j
YWlyby02MToyMDE0MDIxMjE0MzMzMjppMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyOjMu
MTQuMC1yYzItbmV4dC0yMDE0MDIxMi0wMjUyMS1nNDYwMjE3NToxCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWFuMS0wMjEyMTM1Mi80NjAyMTc1ODNjOTM0MTEwODY1YTJmNWRjZTVlMWI1
Yzk4ODM1YTQ2L2RtZXNnLXF1YW50YWwtcm9hbS0zMjoyMDE0MDIxMzA3NDk0MzppMzg2LXJh
bmRjb25maWctYW4xLTAyMTIxMzUyOjMuMTQuMC1yYzItbmV4dC0yMDE0MDIxMi0wMjUyMS1n
NDYwMjE3NToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1Mi80NjAyMTc1
ODNjOTM0MTEwODY1YTJmNWRjZTVlMWI1Yzk4ODM1YTQ2L2RtZXNnLXF1YW50YWwtY2Fpcm8t
NDk6MjAxNDAyMTIxNDMzMzI6aTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1MjozLjE0LjAt
cmMyLW5leHQtMjAxNDAyMTItMDI1MjEtZzQ2MDIxNzU6MQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1hbjEtMDIxMjEzNTIvNDYwMjE3NTgzYzkzNDExMDg2NWEyZjVkY2U1ZTFiNWM5ODgz
NWE0Ni9kbWVzZy1xdWFudGFsLXJvYW0tMjc6MjAxNDAyMTUwNjE0NTk6aTM4Ni1yYW5kY29u
ZmlnLWFuMS0wMjEyMTM1MjozLjE0LjAtcmMyLW5leHQtMjAxNDAyMTItMDI1MjEtZzQ2MDIx
NzU6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvNDYwMjE3NTgzYzkz
NDExMDg2NWEyZjVkY2U1ZTFiNWM5ODgzNWE0Ni9kbWVzZy15b2N0by1pbm4tOToyMDE0MDIx
NTAxMzAyNDppMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyOjMuMTQuMC1yYzItbmV4dC0y
MDE0MDIxMi0wMjUyMS1nNDYwMjE3NToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMS0w
MjEyMTM1Mi80NjAyMTc1ODNjOTM0MTEwODY1YTJmNWRjZTVlMWI1Yzk4ODM1YTQ2L2RtZXNn
LXlvY3RvLXhpYW4tNDk6MjAxNDAyMTMwNzQ3MDg6aTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEy
MTM1MjozLjE0LjAtcmMyLW5leHQtMjAxNDAyMTItMDI1MjEtZzQ2MDIxNzU6MQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvNDYwMjE3NTgzYzkzNDExMDg2NWEyZjVk
Y2U1ZTFiNWM5ODgzNWE0Ni9kbWVzZy15b2N0by1pbm4tMTM6MjAxNDAyMTUwMzE0MTA6aTM4
Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1MjozLjE0LjAtcmMyLW5leHQtMjAxNDAyMTItMDI1
MjEtZzQ2MDIxNzU6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvNDYw
MjE3NTgzYzkzNDExMDg2NWEyZjVkY2U1ZTFiNWM5ODgzNWE0Ni9kbWVzZy1xdWFudGFsLWNh
aXJvLTI3OjIwMTQwMjEyMTQzMzMyOmkzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTI6My4x
NC4wLXJjMi1uZXh0LTIwMTQwMjEyLTAyNTIxLWc0NjAyMTc1OjEKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctYW4xLTAyMTIxMzUyLzQ2MDIxNzU4M2M5MzQxMTA4NjVhMmY1ZGNlNWUxYjVj
OTg4MzVhNDYvZG1lc2cteW9jdG8taW5uLTExOjIwMTQwMjE1MDEyODQyOmkzODYtcmFuZGNv
bmZpZy1hbjEtMDIxMjEzNTI6My4xNC4wLXJjMi1uZXh0LTIwMTQwMjEyLTAyNTIxLWc0NjAy
MTc1OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyLzQ2MDIxNzU4M2M5
MzQxMTA4NjVhMmY1ZGNlNWUxYjVjOTg4MzVhNDYvZG1lc2ctcXVhbnRhbC14aWFuLTUwOjIw
MTQwMjEzMDc1MDAzOmkzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTI6My4xNC4wLXJjMi1u
ZXh0LTIwMTQwMjEyLTAyNTIxLWc0NjAyMTc1OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YW4xLTAyMTIxMzUyLzQ2MDIxNzU4M2M5MzQxMTA4NjVhMmY1ZGNlNWUxYjVjOTg4MzVhNDYv
ZG1lc2ctcXVhbnRhbC14Z3dvLTI6MjAxNDAyMTIxNDMyMzI6aTM4Ni1yYW5kY29uZmlnLWFu
MS0wMjEyMTM1MjozLjE0LjAtcmMyLW5leHQtMjAxNDAyMTItMDI1MjEtZzQ2MDIxNzU6MQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvNDYwMjE3NTgzYzkzNDExMDg2
NWEyZjVkY2U1ZTFiNWM5ODgzNWE0Ni9kbWVzZy1xdWFudGFsLWF0aGVucy0yNzoyMDE0MDIx
NTA2MTMzNjppMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyOjMuMTQuMC1yYzItbmV4dC0y
MDE0MDIxMi0wMjUyMS1nNDYwMjE3NToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMS0w
MjEyMTM1Mi80NjAyMTc1ODNjOTM0MTEwODY1YTJmNWRjZTVlMWI1Yzk4ODM1YTQ2L2RtZXNn
LXlvY3RvLXhpYW4tMTU6MjAxNDAyMTMwNzQ4NDI6aTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEy
MTM1MjozLjE0LjAtcmMyLW5leHQtMjAxNDAyMTItMDI1MjEtZzQ2MDIxNzU6MQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvNDYwMjE3NTgzYzkzNDExMDg2NWEyZjVk
Y2U1ZTFiNWM5ODgzNWE0Ni9kbWVzZy1xdWFudGFsLWNhaXJvLTYwOjIwMTQwMjEzMDc0NjU5
OmkzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTI6My4xNC4wLXJjMi1uZXh0LTIwMTQwMjEy
LTAyNTIxLWc0NjAyMTc1OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUy
LzQ2MDIxNzU4M2M5MzQxMTA4NjVhMmY1ZGNlNWUxYjVjOTg4MzVhNDYvZG1lc2cteW9jdG8t
eGlhbi00MzoyMDE0MDIxMzA3NTAwMzppMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyOjMu
MTQuMC1yYzItbmV4dC0yMDE0MDIxMi0wMjUyMS1nNDYwMjE3NToxCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWFuMS0wMjEyMTM1Mi80NjAyMTc1ODNjOTM0MTEwODY1YTJmNWRjZTVlMWI1
Yzk4ODM1YTQ2L2RtZXNnLXlvY3RvLWF0aGVucy00MjoyMDE0MDIxNTA4NDg1NzppMzg2LXJh
bmRjb25maWctYW4xLTAyMTIxMzUyOjMuMTQuMC1yYzItbmV4dC0yMDE0MDIxMi0wMjUyMS1n
NDYwMjE3NToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1Mi80NjAyMTc1
ODNjOTM0MTEwODY1YTJmNWRjZTVlMWI1Yzk4ODM1YTQ2L2RtZXNnLXlvY3RvLXhpYW4tNTk6
MjAxNDAyMTQyMTU1NDI6aTM4Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1MjozLjE0LjAtcmMy
LW5leHQtMjAxNDAyMTItMDI1MjEtZzQ2MDIxNzU6MQova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1hbjEtMDIxMjEzNTIvNDYwMjE3NTgzYzkzNDExMDg2NWEyZjVkY2U1ZTFiNWM5ODgzNWE0
Ni9kbWVzZy15b2N0by14aWFuLTUzOjIwMTQwMjE1MDMxMTE3OmkzODYtcmFuZGNvbmZpZy1h
bjEtMDIxMjEzNTI6My4xNC4wLXJjMi1uZXh0LTIwMTQwMjEyLTAyNTIxLWc0NjAyMTc1OjEK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyLzQ2MDIxNzU4M2M5MzQxMTA4
NjVhMmY1ZGNlNWUxYjVjOTg4MzVhNDYvZG1lc2cteW9jdG8tYXRoZW5zLTI0OjIwMTQwMjE1
MDEzMDI0OmkzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTI6My4xNC4wLXJjMi1uZXh0LTIw
MTQwMjEyLTAyNTIxLWc0NjAyMTc1OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAy
MTIxMzUyLzQ2MDIxNzU4M2M5MzQxMTA4NjVhMmY1ZGNlNWUxYjVjOTg4MzVhNDYvZG1lc2ct
eW9jdG8tYmVucy01OjIwMTQwMjEzMDc0NzAwOmkzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEz
NTI6My4xNC4wLXJjMi1uZXh0LTIwMTQwMjEyLTAyNTIxLWc0NjAyMTc1OjEKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyLzQ2MDIxNzU4M2M5MzQxMTA4NjVhMmY1ZGNl
NWUxYjVjOTg4MzVhNDYvZG1lc2ctcXVhbnRhbC1zdG9ha2xleS02OjIwMTQwMjE1MDMxNDIy
OmkzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTI6My4xNC4wLXJjMi1uZXh0LTIwMTQwMjEy
LTAyNTIxLWc0NjAyMTc1OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUy
LzQ2MDIxNzU4M2M5MzQxMTA4NjVhMmY1ZGNlNWUxYjVjOTg4MzVhNDYvZG1lc2ctcXVhbnRh
bC1zdG9ha2xleS0xOjIwMTQwMjE1MDYxNzQzOmkzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEz
NTI6My4xNC4wLXJjMi1uZXh0LTIwMTQwMjEyLTAyNTIxLWc0NjAyMTc1OjEKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYW4xLTAyMTIxMzUyLzQ2MDIxNzU4M2M5MzQxMTA4NjVhMmY1ZGNl
NWUxYjVjOTg4MzVhNDYvZG1lc2ctcXVhbnRhbC1pbm4tMjg6MjAxNDAyMTUwNjE2NDA6aTM4
Ni1yYW5kY29uZmlnLWFuMS0wMjEyMTM1MjozLjE0LjAtcmMyLW5leHQtMjAxNDAyMTItMDI1
MjEtZzQ2MDIxNzU6MQowOjU3OjU5IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpIRUFE
IGlzIG5vdyBhdCA0NjAyMTc1IEFkZCBsaW51eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZvciAy
MDE0MDIxMgoKPT09PT09PT09IHVwc3RyZWFtID09PT09PT09PQpGZXRjaGluZyBsaW51cwps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWFuMS0w
MjEyMTM1Mi9uZXh0Om1hc3RlcjpjYTAzMzM5MGE1MzdkYWNkYzIxMjdjNjZkNjJlNzg2MmFk
MTVmZmRiOmJpc2VjdC1tbQoKMjAxNC0wMi0xNS0xMDo1NToyMiBjYTAzMzM5MGE1MzdkYWNk
YzIxMjdjNjZkNjJlNzg2MmFkMTVmZmRiIGNvbXBpbGluZwoKMjAxNC0wMi0xNS0xMTowMDoz
NyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmMyLTAwNDg4LWdjYTAzMzM5Li4uCTEu
Lgk3CTkJMTIJMTQuLi4JMTUuCTE3Li4uLi4uLi4uLi4uCTE4Li4JMTkJMjAuLgkyMgkyNgkz
Ngk0Mgk0NAk0Nwk0OS4JNTAJNTEuLgk1My4uLgk1OC4uCTU5Li4uCTYwIFNVQ0NFU1MKCgo9
PT09PT09PT0gbGludXgtbmV4dCA9PT09PT09PT0KbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1hbjEtMDIxMjEzNTIvbmV4dDptYXN0ZXI6ZGE4
ZDMwOGZiZGI4MzYwMDc4Nzg2YjNlMTI1MjM4MTIyYzRmYzYxMTpiaXNlY3QtbW0KCjIwMTQt
MDItMTUtMTE6MzA6MDkgZGE4ZDMwOGZiZGI4MzYwMDc4Nzg2YjNlMTI1MjM4MTIyYzRmYzYx
MSBjb21waWxpbmcKCjIwMTQtMDItMTUtMTE6MzU6MjUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
My4xNC4wLXJjMi1uZXh0LTIwMTQwMjE0LgkxCTIJNi4JOAk5CTEyLgkxMwkxNS4JMTgJMTkJ
MjIJMjQJMjcJMjgJMjkuLi4JMzAJMzMJMzQuCTM4CTM5Lgk0MS4uLi4JNDIJNDMuLi4uCTQ0
Li4uCTQ1Lgk0Ny4uLi4uLi4uLi4uLi4uLi4JNDkJNTIJNTgJNTkJNjAgU1VDQ0VTUwoK

--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc2-next-20140212-02521-g4602175"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.14.0-rc2 Kernel Configuration
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
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
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
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

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
CONFIG_TICK_ONESHOT=y
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
# CONFIG_MEMCG_SWAP is not set
# CONFIG_MEMCG_KMEM is not set
# CONFIG_CGROUP_HUGETLB is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
# CONFIG_FAIR_GROUP_SCHED is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
# CONFIG_SCHED_AUTOGROUP is not set
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
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

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
# CONFIG_JUMP_LABEL is not set
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
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_NONE is not set
CONFIG_CC_STACKPROTECTOR_REGULAR=y
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
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
# CONFIG_GCOV_FORMAT_3_4 is not set
CONFIG_GCOV_FORMAT_4_7=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_THROTTLING=y
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
CONFIG_IOSCHED_CFQ=y
# CONFIG_CFQ_GROUP_IOSCHED is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PADATA=y
CONFIG_ASN1=m
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_BIGSMP is not set
CONFIG_GOLDFISH=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_GOLDFISH=y
# CONFIG_X86_INTEL_MID is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_32_NON_STANDARD is not set
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_DEBUG=y
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PRIVILEGED_GUEST=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=64
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
CONFIG_LGUEST_GUEST=y
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
CONFIG_MCRUSOE=y
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
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=m
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
# CONFIG_FRONTSWAP is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_RANDOMIZE_BASE_MAX_OFFSET=0x20000000
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
# CONFIG_HIBERNATION is not set
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_DPM_WATCHDOG is not set
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
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
CONFIG_SFI=y
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_STAT=m
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=m
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K6=y
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K7_ACPI=y
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
# CONFIG_X86_SPEEDSTEP_SMI is not set
CONFIG_X86_P4_CLOCKMOD=y
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
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
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_XEN_PCIDEV_FRONTEND=y
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
# CONFIG_ISA is not set
CONFIG_SCx200=m
CONFIG_SCx200HR_TIMER=m
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
CONFIG_GEOS=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
CONFIG_PCMCIA=m
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
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
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_ATM=m
CONFIG_ATM_LANE=m
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_MRP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_DECNET=m
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=m
# CONFIG_IPX_INTERN is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
CONFIG_PHONET=y
CONFIG_IEEE802154=m
CONFIG_6LOWPAN_IPHC=y
CONFIG_MAC802154=m
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=m
CONFIG_BATMAN_ADV=m
# CONFIG_BATMAN_ADV_NC is not set
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=m
CONFIG_VSOCKETS=m
CONFIG_NETLINK_MMAP=y
# CONFIG_NETLINK_DIAG is not set
CONFIG_NET_MPLS_GSO=y
CONFIG_HSR=y
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
# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=m
# CONFIG_CAN_CALC_BITTIMING is not set
# CONFIG_CAN_LEDS is not set
# CONFIG_PCH_CAN is not set
CONFIG_CAN_SJA1000=m
CONFIG_CAN_SJA1000_ISA=m
# CONFIG_CAN_SJA1000_PLATFORM is not set
# CONFIG_CAN_EMS_PCMCIA is not set
# CONFIG_CAN_EMS_PCI is not set
# CONFIG_CAN_PEAK_PCMCIA is not set
# CONFIG_CAN_PEAK_PCI is not set
# CONFIG_CAN_KVASER_PCI is not set
# CONFIG_CAN_PLX_PCI is not set
# CONFIG_CAN_C_CAN is not set
CONFIG_CAN_CC770=m
CONFIG_CAN_CC770_ISA=m
# CONFIG_CAN_CC770_PLATFORM is not set

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=m
CONFIG_CAN_ESD_USB2=m
CONFIG_CAN_KVASER_USB=m
CONFIG_CAN_PEAK_USB=m
CONFIG_CAN_8DEV_USB=m
# CONFIG_CAN_SOFTING is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
CONFIG_BT=y
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=y
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
# CONFIG_BT_HCIBTSDIO is not set
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIBCM203X=y
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=y
# CONFIG_BT_HCIDTL1 is not set
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
# CONFIG_BT_HCIBTUART is not set
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=y
CONFIG_BT_MRVL_SDIO=m
# CONFIG_BT_ATH3K is not set
CONFIG_BT_WILINK=m
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=m
CONFIG_NL80211_TESTMODE=y
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REG_DEBUG=y
# CONFIG_CFG80211_DEFAULT_PS is not set
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
CONFIG_LIB80211=m
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
CONFIG_MAC80211_MESSAGE_TRACING=y
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_REGULATOR=y
CONFIG_RFKILL_GPIO=m
# CONFIG_NET_9P is not set
CONFIG_CAIF=m
# CONFIG_CAIF_DEBUG is not set
# CONFIG_CAIF_NETDEV is not set
CONFIG_CAIF_USB=m
CONFIG_NFC=y
CONFIG_NFC_DIGITAL=m
# CONFIG_NFC_NCI is not set
CONFIG_NFC_HCI=y
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN533=y
CONFIG_NFC_SIM=m
CONFIG_NFC_PORT100=m
CONFIG_NFC_PN544=y
CONFIG_NFC_PN544_I2C=m
CONFIG_NFC_MICROREAD=y
CONFIG_NFC_MICROREAD_I2C=m

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
CONFIG_SYS_HYPERVISOR=y
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_MMIO=m
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
CONFIG_PARPORT=m
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=m
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_PC_PCMCIA=m
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_ZRAM is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_OSD is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
CONFIG_ATA_OVER_ETH=y
CONFIG_XEN_BLKDEV_FRONTEND=y
# CONFIG_XEN_BLKDEV_BACKEND is not set
# CONFIG_VIRTIO_BLK is not set
CONFIG_BLK_DEV_HD=y
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
CONFIG_ICS932S401=m
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1780=m
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_SRAM=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=m
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI_TXE is not set
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
CONFIG_SCSI_MOD=m
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
# CONFIG_BLK_DEV_SR_VENDOR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_ENCLOSURE is not set
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPT3SAS is not set
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_LIBFC=m
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_PPA=m
CONFIG_SCSI_IMM=m
# CONFIG_SCSI_IZIP_EPP16 is not set
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_NSP32 is not set
CONFIG_SCSI_DEBUG=m
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_VIRTIO is not set
# CONFIG_SCSI_CHELSIO_FCOE is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
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
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
# CONFIG_NET_CORE is not set
CONFIG_ARCNET=m
CONFIG_ARCNET_1201=m
CONFIG_ARCNET_1051=m
CONFIG_ARCNET_RAW=m
CONFIG_ARCNET_CAP=m
# CONFIG_ARCNET_COM90xx is not set
CONFIG_ARCNET_COM90xxIO=m
# CONFIG_ARCNET_RIM_I is not set
# CONFIG_ARCNET_COM20020 is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_FIRESTREAM is not set
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set

#
# CAIF transport drivers
#
# CONFIG_CAIF_TTY is not set
CONFIG_CAIF_SPI_SLAVE=m
# CONFIG_CAIF_SPI_SYNC is not set
CONFIG_CAIF_HSI=m
CONFIG_CAIF_VIRTIO=m
# CONFIG_VHOST_NET is not set
CONFIG_VHOST_RING=m

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
# CONFIG_NET_DSA_MV88E6060 is not set
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
# CONFIG_ETHERNET is not set
# CONFIG_FDDI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
# CONFIG_AMD_PHY is not set
# CONFIG_MARVELL_PHY is not set
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=y
# CONFIG_BROADCOM_PHY is not set
CONFIG_BCM87XX_PHY=y
CONFIG_ICPLUS_PHY=y
# CONFIG_REALTEK_PHY is not set
CONFIG_NATIONAL_PHY=y
# CONFIG_STE10XP is not set
CONFIG_LSI_ET1011C_PHY=y
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=m
# CONFIG_MDIO_GPIO is not set
# CONFIG_PLIP is not set
CONFIG_PPP=m
# CONFIG_PPP_BSDCOMP is not set
# CONFIG_PPP_DEFLATE is not set
# CONFIG_PPP_FILTER is not set
# CONFIG_PPP_MPPE is not set
CONFIG_PPP_MULTILINK=y
# CONFIG_PPPOATM is not set
# CONFIG_PPPOE is not set
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
# CONFIG_SLIP is not set
CONFIG_SLHC=m

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=m
CONFIG_USB_RTL8152=y
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_AX88179_178A=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_CDC_EEM=m
CONFIG_USB_NET_CDC_NCM=m
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
CONFIG_USB_NET_CDC_MBIM=m
CONFIG_USB_NET_DM9601=m
CONFIG_USB_NET_SR9700=m
CONFIG_USB_NET_SR9800=m
CONFIG_USB_NET_SMSC75XX=m
CONFIG_USB_NET_SMSC95XX=m
# CONFIG_USB_NET_GL620A is not set
CONFIG_USB_NET_NET1080=m
# CONFIG_USB_NET_PLUSB is not set
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
# CONFIG_USB_BELKIN is not set
CONFIG_USB_ARMLINUX=y
# CONFIG_USB_EPSON2888 is not set
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
CONFIG_USB_NET_QMI_WWAN=m
# CONFIG_USB_HSO is not set
CONFIG_USB_NET_INT51X1=m
# CONFIG_USB_CDC_PHONET is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_USB_SIERRA_NET is not set
CONFIG_USB_VL600=m
CONFIG_WLAN=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
CONFIG_ATMEL=m
# CONFIG_PCI_ATMEL is not set
CONFIG_PCMCIA_ATMEL=m
CONFIG_AT76C50X_USB=m
CONFIG_AIRO_CS=m
CONFIG_PCMCIA_WL3501=m
# CONFIG_PRISM54 is not set
CONFIG_USB_ZD1201=y
CONFIG_USB_NET_RNDIS_WLAN=m
# CONFIG_RTL8180 is not set
CONFIG_RTL8187=m
CONFIG_RTL8187_LEDS=y
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
CONFIG_ATH_COMMON=m
CONFIG_ATH_CARDS=m
CONFIG_ATH_DEBUG=y
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
CONFIG_ATH9K_HW=m
CONFIG_ATH9K_COMMON=m
CONFIG_ATH9K_BTCOEX_SUPPORT=y
CONFIG_ATH9K=m
CONFIG_ATH9K_PCI=y
# CONFIG_ATH9K_AHB is not set
CONFIG_ATH9K_DEBUGFS=y
CONFIG_ATH9K_STATION_STATISTICS=y
CONFIG_ATH9K_WOW=y
CONFIG_ATH9K_LEGACY_RATE_CONTROL=y
CONFIG_ATH9K_RFKILL=y
CONFIG_ATH9K_HTC=m
CONFIG_ATH9K_HTC_DEBUGFS=y
CONFIG_CARL9170=m
# CONFIG_CARL9170_LEDS is not set
CONFIG_CARL9170_DEBUGFS=y
CONFIG_CARL9170_WPC=y
CONFIG_CARL9170_HWRNG=y
CONFIG_ATH6KL=m
CONFIG_ATH6KL_SDIO=m
CONFIG_ATH6KL_USB=m
CONFIG_ATH6KL_DEBUG=y
CONFIG_ATH6KL_TRACING=y
# CONFIG_AR5523 is not set
# CONFIG_WIL6210 is not set
# CONFIG_ATH10K is not set
CONFIG_WCN36XX=m
CONFIG_WCN36XX_DEBUGFS=y
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
CONFIG_BRCMUTIL=m
CONFIG_BRCMSMAC=m
CONFIG_BRCMFMAC=m
# CONFIG_BRCMFMAC_SDIO is not set
# CONFIG_BRCMFMAC_USB is not set
# CONFIG_BRCM_TRACING is not set
# CONFIG_BRCMDBG is not set
CONFIG_HOSTAP=m
CONFIG_HOSTAP_FIRMWARE=y
# CONFIG_HOSTAP_FIRMWARE_NVRAM is not set
# CONFIG_HOSTAP_PLX is not set
# CONFIG_HOSTAP_PCI is not set
CONFIG_HOSTAP_CS=m
# CONFIG_IPW2100 is not set
# CONFIG_IWLWIFI is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
CONFIG_LIBERTAS=m
CONFIG_LIBERTAS_USB=m
CONFIG_LIBERTAS_CS=m
# CONFIG_LIBERTAS_SDIO is not set
CONFIG_LIBERTAS_DEBUG=y
# CONFIG_LIBERTAS_MESH is not set
CONFIG_P54_COMMON=m
CONFIG_P54_USB=m
# CONFIG_P54_PCI is not set
CONFIG_P54_LEDS=y
CONFIG_RT2X00=m
# CONFIG_RT2400PCI is not set
# CONFIG_RT2500PCI is not set
# CONFIG_RT61PCI is not set
# CONFIG_RT2800PCI is not set
CONFIG_RT2500USB=m
CONFIG_RT73USB=m
# CONFIG_RT2800USB is not set
CONFIG_RT2X00_LIB_USB=m
CONFIG_RT2X00_LIB=m
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
CONFIG_RT2X00_LIB_DEBUGFS=y
# CONFIG_RT2X00_DEBUG is not set
# CONFIG_RTL_CARDS is not set
CONFIG_WL_TI=y
# CONFIG_WL1251 is not set
# CONFIG_WL12XX is not set
CONFIG_WL18XX=m
CONFIG_WLCORE=m
CONFIG_WLCORE_SDIO=m
# CONFIG_WILINK_PLATFORM_DATA is not set
CONFIG_ZD1211RW=m
CONFIG_ZD1211RW_DEBUG=y
CONFIG_MWIFIEX=m
CONFIG_MWIFIEX_SDIO=m
# CONFIG_MWIFIEX_PCIE is not set
CONFIG_MWIFIEX_USB=m
# CONFIG_CW1200 is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=y
CONFIG_HDLC_RAW=m
CONFIG_HDLC_RAW_ETH=m
# CONFIG_HDLC_CISCO is not set
CONFIG_HDLC_FR=m
# CONFIG_HDLC_PPP is not set
# CONFIG_HDLC_X25 is not set
# CONFIG_PCI200SYN is not set
# CONFIG_WANXL is not set
# CONFIG_PC300TOO is not set
# CONFIG_FARSYNC is not set
# CONFIG_DSCC4 is not set
# CONFIG_DLCI is not set
CONFIG_SBNI=m
# CONFIG_SBNI_MULTILINE is not set
CONFIG_IEEE802154_DRIVERS=m
CONFIG_IEEE802154_FAKEHARD=m
# CONFIG_IEEE802154_FAKELB is not set
CONFIG_XEN_NETDEV_FRONTEND=y
# CONFIG_XEN_NETDEV_BACKEND is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=m
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ADP5589=m
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=m
# CONFIG_KEYBOARD_QT2160 is not set
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_GPIO=y
CONFIG_KEYBOARD_GPIO_POLLED=y
CONFIG_KEYBOARD_TCA6416=m
CONFIG_KEYBOARD_TCA8418=m
CONFIG_KEYBOARD_MATRIX=m
CONFIG_KEYBOARD_LM8323=m
CONFIG_KEYBOARD_LM8333=m
CONFIG_KEYBOARD_MAX7359=m
CONFIG_KEYBOARD_MCS=m
CONFIG_KEYBOARD_MPR121=m
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_GOLDFISH_EVENTS=m
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_SUNKBD=m
CONFIG_KEYBOARD_XTKBD=m
CONFIG_KEYBOARD_CROS_EC=y
CONFIG_INPUT_LEDS=y
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=m
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=y
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
CONFIG_JOYSTICK_GUILLEMOT=m
# CONFIG_JOYSTICK_INTERACT is not set
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=m
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=y
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_DB9 is not set
# CONFIG_JOYSTICK_GAMECON is not set
# CONFIG_JOYSTICK_TURBOGRAFX is not set
# CONFIG_JOYSTICK_AS5011 is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
CONFIG_JOYSTICK_XPAD=y
# CONFIG_JOYSTICK_XPAD_FF is not set
# CONFIG_JOYSTICK_XPAD_LEDS is not set
CONFIG_JOYSTICK_WALKERA0701=m
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=m
CONFIG_TOUCHSCREEN_ATMEL_MXT=m
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
CONFIG_TOUCHSCREEN_BU21013=m
CONFIG_TOUCHSCREEN_CY8CTMG110=m
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=m
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=m
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=m
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=m
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=m
CONFIG_TOUCHSCREEN_MAX11801=m
CONFIG_TOUCHSCREEN_MCS5000=m
CONFIG_TOUCHSCREEN_MMS114=m
CONFIG_TOUCHSCREEN_MTOUCH=m
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=m
CONFIG_TOUCHSCREEN_EDT_FT5X06=m
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=m
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC2007=m
CONFIG_TOUCHSCREEN_ST1232=m
CONFIG_TOUCHSCREEN_SUR40=m
CONFIG_TOUCHSCREEN_TPS6507X=m
CONFIG_TOUCHSCREEN_ZFORCE=m
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=m
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=m
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
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
CONFIG_N_HDLC=y
CONFIG_N_GSM=m
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=y
CONFIG_GOLDFISH_TTY=y
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set
CONFIG_SERIAL_8250_DW=m

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=m
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_PRINTER is not set
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_GEODE=m
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
# CONFIG_IPWIRELESS is not set
CONFIG_MWAVE=y
CONFIG_SCx200_GPIO=m
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=m
CONFIG_I2C_MUX_PCA9541=m
CONFIG_I2C_MUX_PCA954x=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=m

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
CONFIG_I2C_DESIGNWARE_CORE=m
CONFIG_I2C_DESIGNWARE_PLATFORM=m
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=m
CONFIG_I2C_KEMPLD=m
CONFIG_I2C_OCORES=m
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
CONFIG_I2C_TAOS_EVM=m
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_SCx200_I2C=m
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=y

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
CONFIG_PPS_CLIENT_LDISC=m
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
CONFIG_PTP_1588_CLOCK_PCH=m
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=m
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=m
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=m
CONFIG_GPIO_SCH311X=m
CONFIG_GPIO_TS5500=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX7300=m
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=m
CONFIG_GPIO_ADP5588=m

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
# CONFIG_GPIO_KEMPLD is not set

#
# MODULbus GPIO expanders:
#

#
# USB GPIO expanders:
#
CONFIG_W1=m
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=m
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=m
CONFIG_W1_SLAVE_DS2408_READBACK=y
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2423=m
CONFIG_W1_SLAVE_DS2431=m
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=m
CONFIG_W1_SLAVE_DS28E04=m
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=m
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_TEST_POWER=m
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=m
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_SBS=m
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_MAX17040=m
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_CHARGER_ISP1704=m
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_LP8727=m
CONFIG_CHARGER_GPIO=m
CONFIG_CHARGER_BQ2415X=m
# CONFIG_CHARGER_BQ24190 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=m
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_G762=m
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=m
CONFIG_SENSORS_HTU21=m
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=m
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IIO_HWMON=m
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=m
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=m
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=m
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LTC2945=m
CONFIG_SENSORS_LTC4151=m
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4222=m
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_MAX16065=m
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=m
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
CONFIG_SENSORS_MCP3021=m
CONFIG_SENSORS_NCT6775=m
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_APPLESMC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=m
# CONFIG_ACPI_INT3403_THERMAL is not set

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
# CONFIG_SSB_PCMCIAHOST is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_HOST_SOC=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DRIVER_GPIO is not set
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=m
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=m
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=m
# CONFIG_MFD_VIPERBOARD is not set
CONFIG_MFD_RETU=m
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_SI476X_CORE=m
# CONFIG_MFD_SM501 is not set
CONFIG_ABX500_CORE=y
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=m
# CONFIG_MFD_LP3943 is not set
CONFIG_TPS6105X=m
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=m
CONFIG_MFD_TPS65217=m
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=m
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_ACT8865 is not set
CONFIG_REGULATOR_AD5398=m
# CONFIG_REGULATOR_DA9210 is not set
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_GPIO=y
# CONFIG_REGULATOR_ISL6271A is not set
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=m
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=m
CONFIG_REGULATOR_MAX8660=m
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8973=m
CONFIG_REGULATOR_PFUZE100=m
CONFIG_REGULATOR_TPS51632=m
CONFIG_REGULATOR_TPS6105X=m
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=m
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65217=m
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_DVB_CORE=m
CONFIG_TTPCI_EEPROM=m
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y

#
# Media drivers
#
CONFIG_RC_CORE=m
CONFIG_RC_MAP=m
CONFIG_RC_DECODERS=y
CONFIG_LIRC=m
CONFIG_IR_LIRC_CODEC=m
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
# CONFIG_IR_RC6_DECODER is not set
# CONFIG_IR_JVC_DECODER is not set
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_RC5_SZ_DECODER=m
CONFIG_IR_SANYO_DECODER=m
CONFIG_IR_MCE_KBD_DECODER=m
# CONFIG_RC_DEVICES is not set
CONFIG_MEDIA_USB_SUPPORT=y

#
# Analog/digital TV USB devices
#
CONFIG_VIDEO_AU0828=m

#
# Digital TV USB devices
#
CONFIG_DVB_USB=m
# CONFIG_DVB_USB_DEBUG is not set
CONFIG_DVB_USB_A800=m
CONFIG_DVB_USB_DIBUSB_MB=m
CONFIG_DVB_USB_DIBUSB_MB_FAULTY=y
# CONFIG_DVB_USB_DIBUSB_MC is not set
CONFIG_DVB_USB_DIB0700=m
# CONFIG_DVB_USB_UMT_010 is not set
CONFIG_DVB_USB_CXUSB=m
# CONFIG_DVB_USB_M920X is not set
CONFIG_DVB_USB_DIGITV=m
# CONFIG_DVB_USB_VP7045 is not set
# CONFIG_DVB_USB_VP702X is not set
# CONFIG_DVB_USB_GP8PSK is not set
# CONFIG_DVB_USB_NOVA_T_USB2 is not set
CONFIG_DVB_USB_TTUSB2=m
# CONFIG_DVB_USB_DTT200U is not set
CONFIG_DVB_USB_OPERA1=m
# CONFIG_DVB_USB_AF9005 is not set
CONFIG_DVB_USB_PCTV452E=m
CONFIG_DVB_USB_DW2102=m
CONFIG_DVB_USB_CINERGY_T2=m
# CONFIG_DVB_USB_DTV5100 is not set
CONFIG_DVB_USB_FRIIO=m
CONFIG_DVB_USB_AZ6027=m
# CONFIG_DVB_USB_TECHNISAT_USB2 is not set
CONFIG_DVB_USB_V2=m
# CONFIG_DVB_USB_AF9015 is not set
CONFIG_DVB_USB_AF9035=m
CONFIG_DVB_USB_ANYSEE=m
CONFIG_DVB_USB_AU6610=m
CONFIG_DVB_USB_AZ6007=m
CONFIG_DVB_USB_CE6230=m
CONFIG_DVB_USB_EC168=m
CONFIG_DVB_USB_GL861=m
CONFIG_DVB_USB_IT913X=m
# CONFIG_DVB_USB_LME2510 is not set
# CONFIG_DVB_USB_MXL111SF is not set
CONFIG_DVB_USB_RTL28XXU=m
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
# CONFIG_SMS_USB_DRV is not set
# CONFIG_DVB_B2C2_FLEXCOP_USB is not set

#
# Webcam, TV (analog/digital) USB devices
#
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_SMS_SDIO_DRV is not set
CONFIG_VIDEO_TVEEPROM=m
CONFIG_CYPRESS_FIRMWARE=m

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
CONFIG_MEDIA_ATTACH=y

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=m
# CONFIG_MEDIA_TUNER_TDA8290 is not set
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
# CONFIG_MEDIA_TUNER_TEA5767 is not set
# CONFIG_MEDIA_TUNER_MT20XX is not set
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2063=m
# CONFIG_MEDIA_TUNER_MT2266 is not set
# CONFIG_MEDIA_TUNER_MT2131 is not set
# CONFIG_MEDIA_TUNER_QT1010 is not set
# CONFIG_MEDIA_TUNER_XC2028 is not set
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
# CONFIG_MEDIA_TUNER_MC44S803 is not set
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_FC0011=m
# CONFIG_MEDIA_TUNER_FC0012 is not set
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=m
CONFIG_MEDIA_TUNER_E4000=m
CONFIG_MEDIA_TUNER_FC2580=m
# CONFIG_MEDIA_TUNER_M88TS2022 is not set
# CONFIG_MEDIA_TUNER_TUA9001 is not set
CONFIG_MEDIA_TUNER_IT913X=m
# CONFIG_MEDIA_TUNER_R820T is not set

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=m
# CONFIG_DVB_STB6100 is not set
CONFIG_DVB_STV090x=m
# CONFIG_DVB_STV6110x is not set
# CONFIG_DVB_M88DS3103 is not set

#
# Multistandard (cable + terrestrial) frontends
#
# CONFIG_DVB_DRXK is not set
# CONFIG_DVB_TDA18271C2DD is not set

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
# CONFIG_DVB_MT312 is not set
# CONFIG_DVB_ZL10036 is not set
# CONFIG_DVB_ZL10039 is not set
# CONFIG_DVB_S5H1420 is not set
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
# CONFIG_DVB_STV6110 is not set
CONFIG_DVB_STV0900=m
# CONFIG_DVB_TDA8083 is not set
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TUNER_CX24113=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_CX24117=m
CONFIG_DVB_SI21XX=m
CONFIG_DVB_TS2020=m
CONFIG_DVB_DS3000=m
CONFIG_DVB_MB86A16=m
CONFIG_DVB_TDA10071=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
# CONFIG_DVB_CX22702 is not set
CONFIG_DVB_S5H1432=m
CONFIG_DVB_DRXD=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
# CONFIG_DVB_MT352 is not set
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
# CONFIG_DVB_DIB9000 is not set
# CONFIG_DVB_TDA10048 is not set
CONFIG_DVB_AF9013=m
CONFIG_DVB_EC100=m
# CONFIG_DVB_HD29L2 is not set
CONFIG_DVB_STV0367=m
# CONFIG_DVB_CXD2820R is not set
CONFIG_DVB_RTL2830=m
CONFIG_DVB_RTL2832=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
# CONFIG_DVB_TDA10021 is not set
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
# CONFIG_DVB_NXT200X is not set
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
# CONFIG_DVB_LGDT330X is not set
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_LG2160=m
CONFIG_DVB_S5H1409=m
# CONFIG_DVB_AU8522_DTV is not set
CONFIG_DVB_S5H1411=m

#
# ISDB-T (terrestrial) frontends
#
# CONFIG_DVB_S921 is not set
CONFIG_DVB_DIB8000=m
CONFIG_DVB_MB86A20S=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
# CONFIG_DVB_TUNER_DIB0070 is not set
CONFIG_DVB_TUNER_DIB0090=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=m
CONFIG_DVB_LNBP22=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_ISL6423=m
CONFIG_DVB_A8293=m
# CONFIG_DVB_LGS8GL5 is not set
CONFIG_DVB_LGS8GXX=m
CONFIG_DVB_ATBM8830=m
CONFIG_DVB_TDA665x=m
# CONFIG_DVB_IX2505V is not set
CONFIG_DVB_IT913X_FE=m
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
CONFIG_DRM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
# CONFIG_FB is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_BACKLIGHT_LM3533=m
CONFIG_BACKLIGHT_PWM=m
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=m
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=m
# CONFIG_BACKLIGHT_LM3630A is not set
CONFIG_BACKLIGHT_LM3639=m
CONFIG_BACKLIGHT_LP855X=m
CONFIG_BACKLIGHT_TPS65217=m
CONFIG_BACKLIGHT_GPIO=m
CONFIG_BACKLIGHT_LV5207LP=m
CONFIG_BACKLIGHT_BD6107=m

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_COMPRESS_OFFLOAD=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
CONFIG_SND_DEBUG_VERBOSE=y
# CONFIG_SND_PCM_XRUN_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
# CONFIG_SND_DRIVERS is not set
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
# CONFIG_SND_USB is not set
# CONFIG_SND_PCMCIA is not set
CONFIG_SND_SOC=m
CONFIG_SND_ATMEL_SOC=m
CONFIG_SND_SOC_I2C_AND_SPI=m

#
# CODEC drivers
#
# CONFIG_SND_SOC_ADAU1701 is not set
# CONFIG_SND_SOC_AK4554 is not set
CONFIG_SND_SOC_AK4642=m
# CONFIG_SND_SOC_AK5386 is not set
CONFIG_SND_SOC_CS42L52=m
# CONFIG_SND_SOC_CS42L73 is not set
# CONFIG_SND_SOC_CS4270 is not set
# CONFIG_SND_SOC_CS4271 is not set
# CONFIG_SND_SOC_HDMI_CODEC is not set
CONFIG_SND_SOC_PCM1681=m
# CONFIG_SND_SOC_PCM512x is not set
CONFIG_SND_SOC_SGTL5000=m
# CONFIG_SND_SOC_SPDIF is not set
CONFIG_SND_SOC_TAS5086=m
CONFIG_SND_SOC_TLV320AIC3X=m
CONFIG_SND_SOC_WM8510=m
CONFIG_SND_SOC_WM8523=m
CONFIG_SND_SOC_WM8580=m
# CONFIG_SND_SOC_WM8711 is not set
CONFIG_SND_SOC_WM8728=m
CONFIG_SND_SOC_WM8731=m
# CONFIG_SND_SOC_WM8737 is not set
# CONFIG_SND_SOC_WM8741 is not set
CONFIG_SND_SOC_WM8750=m
# CONFIG_SND_SOC_WM8753 is not set
CONFIG_SND_SOC_WM8776=m
# CONFIG_SND_SOC_WM8804 is not set
CONFIG_SND_SOC_WM8903=m
CONFIG_SND_SOC_WM8962=m
CONFIG_SND_SOC_TPA6130A2=m
# CONFIG_SND_SIMPLE_CARD is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
CONFIG_UHID=y
CONFIG_HID_GENERIC=m

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
CONFIG_HID_APPLEIR=m
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_PRODIKEYS=m
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=y
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_HOLTEK=m
# CONFIG_HOLTEK_FF is not set
CONFIG_HID_HUION=m
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_NTRIG=m
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PRIMAX=m
CONFIG_HID_ROCCAT=m
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=m
# CONFIG_SONY_FF is not set
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=m
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=y
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
# CONFIG_HID_ZYDACRON is not set
CONFIG_HID_SENSOR_HUB=m

#
# USB HID support
#
CONFIG_USB_HID=m
CONFIG_HID_PID=y
# CONFIG_USB_HIDDEV is not set

#
# I2C HID support
#
CONFIG_I2C_HID=m
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=m
CONFIG_USB_XHCI_PLATFORM=m
CONFIG_USB_EHCI_HCD=m
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_PCI=m
CONFIG_USB_EHCI_HCD_PLATFORM=m
CONFIG_USB_OXU210HP_HCD=m
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=y
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_FUSBH200_HCD=m
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_OHCI_HCD=m
CONFIG_USB_OHCI_HCD_PCI=m
CONFIG_USB_OHCI_HCD_SSB=y
CONFIG_USB_OHCI_HCD_PLATFORM=m
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_U132_HCD=m
CONFIG_USB_SL811_HCD=m
CONFIG_USB_SL811_HCD_ISO=y
CONFIG_USB_SL811_CS=m
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_HCD_BCMA=m
CONFIG_USB_HCD_SSB=m
CONFIG_USB_HCD_TEST_MODE=y

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=m
# CONFIG_REALTEK_AUTOPM is not set
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
CONFIG_USB_STORAGE_ONETOUCH=m
# CONFIG_USB_STORAGE_KARMA is not set
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
CONFIG_USB_STORAGE_ENE_UB6250=m

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_MUSB_HDRC is not set
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_HOST=y

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_OMAP=m
CONFIG_USB_DWC3_EXYNOS=m
CONFIG_USB_DWC3_PCI=y
CONFIG_USB_DWC3_KEYSTONE=m

#
# Debugging features
#
CONFIG_USB_DWC3_DEBUG=y
CONFIG_USB_DWC3_VERBOSE=y
CONFIG_USB_DWC2=y
CONFIG_USB_DWC2_DEBUG=y
CONFIG_USB_DWC2_VERBOSE=y
CONFIG_USB_DWC2_TRACK_MISSED_SOFS=y
CONFIG_USB_DWC2_DEBUG_PERIODIC=y
CONFIG_USB_CHIPIDEA=m
# CONFIG_USB_CHIPIDEA_HOST is not set
# CONFIG_USB_CHIPIDEA_DEBUG is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_SIMPLE=m
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
# CONFIG_USB_SERIAL_CH341 is not set
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_F81232=m
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_METRO=m
CONFIG_USB_SERIAL_MOS7720=m
# CONFIG_USB_SERIAL_MOS7715_PARPORT is not set
CONFIG_USB_SERIAL_MOS7840=m
# CONFIG_USB_SERIAL_MXUPORT is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
CONFIG_USB_SERIAL_SYMBOL=m
CONFIG_USB_SERIAL_TI=m
# CONFIG_USB_SERIAL_CYBERJACK is not set
CONFIG_USB_SERIAL_XIRCOM=m
# CONFIG_USB_SERIAL_OPTION is not set
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
CONFIG_USB_SERIAL_XSENS_MT=m
# CONFIG_USB_SERIAL_WISHBONE is not set
CONFIG_USB_SERIAL_ZTE=m
# CONFIG_USB_SERIAL_SSU100 is not set
CONFIG_USB_SERIAL_QT2=m
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=m
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=y
# CONFIG_USB_LED is not set
CONFIG_USB_CYPRESS_CY7C63=y
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_SISUSBVGA=m
# CONFIG_USB_SISUSBVGA_CON is not set
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
# CONFIG_USB_TEST is not set
CONFIG_USB_EHSET_TEST_FIXTURE=m
CONFIG_USB_ISIGHTFW=y
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=m
CONFIG_USB_HSIC_USB3503=m
CONFIG_USB_ATM=m
# CONFIG_USB_SPEEDTOUCH is not set
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
# CONFIG_USB_XUSBATM is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
# CONFIG_USB_OTG_FSM is not set
CONFIG_NOP_USB_XCEIV=y
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
CONFIG_SAMSUNG_USB3PHY=m
CONFIG_USB_GPIO_VBUS=m
CONFIG_TAHVO_USB=m
CONFIG_TAHVO_USB_HOST_BY_DEFAULT=y
CONFIG_USB_ISP1301=m
CONFIG_USB_RCAR_PHY=y
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_UNSAFE_RESUME=y
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
# CONFIG_MMC_BLOCK_BOUNCE is not set
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_GOLDFISH=y
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_VUB300=m
CONFIG_MMC_USHC=y
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=m
CONFIG_LEDS_LM3533=m
CONFIG_LEDS_LM3642=m
CONFIG_LEDS_NET48XX=m
# CONFIG_LEDS_WRAP is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=m
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_CLEVO_MAIL=m
CONFIG_LEDS_PCA955X=m
CONFIG_LEDS_PCA963X=m
# CONFIG_LEDS_PCA9685 is not set
CONFIG_LEDS_PWM=m
CONFIG_LEDS_REGULATOR=m
CONFIG_LEDS_BD2802=m
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=m
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_ACCESSIBILITY is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_AMD76X is not set
# CONFIG_EDAC_E7XXX is not set
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82875P is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I82860 is not set
# CONFIG_EDAC_R82600 is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC_CORE=m
# CONFIG_DW_DMAC is not set
# CONFIG_DW_DMAC_PCI is not set
CONFIG_TIMB_DMA=m
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_DMEM_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=m
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set

#
# Xen driver support
#
# CONFIG_XEN_BALLOON is not set
# CONFIG_XEN_DEV_EVTCHN is not set
CONFIG_XEN_BACKEND=y
CONFIG_XENFS=y
# CONFIG_XEN_COMPAT_XENFS is not set
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
CONFIG_XEN_GNTDEV=m
CONFIG_XEN_GRANT_DEV_ALLOC=y
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_TMEM=m
CONFIG_XEN_PCIDEV_BACKEND=m
CONFIG_XEN_PRIVCMD=y
CONFIG_XEN_ACPI_PROCESSOR=m
CONFIG_XEN_HAVE_PVMMU=y
CONFIG_STAGING=y
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
CONFIG_USBIP_CORE=y
# CONFIG_USBIP_VHCI_HCD is not set
CONFIG_USBIP_HOST=y
# CONFIG_USBIP_DEBUG is not set
CONFIG_W35UND=m
CONFIG_PRISM2_USB=m
CONFIG_ECHO=m
# CONFIG_COMEDI is not set
# CONFIG_PANEL is not set
# CONFIG_R8187SE is not set
# CONFIG_RTL8192U is not set
# CONFIG_RTLLIB is not set
CONFIG_R8712U=m
CONFIG_R8188EU=y
# CONFIG_88EU_AP_MODE is not set
CONFIG_88EU_P2P=y
# CONFIG_R8821AE is not set
CONFIG_RTS5139=m
CONFIG_RTS5139_DEBUG=y
# CONFIG_RTS5208 is not set
CONFIG_TRANZPORT=y
# CONFIG_LINE6_USB is not set
# CONFIG_USB_SERIAL_QUATECH2 is not set
# CONFIG_VT6655 is not set
CONFIG_VT6656=m
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#

#
# Accelerometers
#

#
# Analog to digital converters
#
CONFIG_AD7291=m
# CONFIG_AD7606 is not set
CONFIG_AD799X=m
CONFIG_AD799X_RING_BUFFER=y

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=y
CONFIG_ADT7316_I2C=m

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
CONFIG_AD7152=m
CONFIG_AD7746=m

#
# Direct Digital Synthesis
#

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=m

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=m
CONFIG_SENSORS_ISL29028=m
# CONFIG_TSL2583 is not set
CONFIG_TSL2x7x=m

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=m

#
# Active energy metering IC
#
# CONFIG_ADE7854 is not set

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
CONFIG_IIO_DUMMY_EVGEN=m
CONFIG_IIO_SIMPLE_DUMMY=m
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
# CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set
CONFIG_WLAGS49_H2=m
CONFIG_WLAGS49_H25=m
# CONFIG_CRYSTALHD is not set
# CONFIG_CXT1E1 is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_SBE_2T3E3 is not set
# CONFIG_USB_ENESTORAGE is not set
CONFIG_BCM_WIMAX=y
CONFIG_FT1000=y
# CONFIG_FT1000_USB is not set
# CONFIG_FT1000_PCMCIA is not set

#
# Speakup console speech
#
CONFIG_SPEAKUP=m
# CONFIG_SPEAKUP_SYNTH_ACNTSA is not set
# CONFIG_SPEAKUP_SYNTH_APOLLO is not set
CONFIG_SPEAKUP_SYNTH_AUDPTR=m
CONFIG_SPEAKUP_SYNTH_BNS=m
CONFIG_SPEAKUP_SYNTH_DECTLK=m
CONFIG_SPEAKUP_SYNTH_DECEXT=m
CONFIG_SPEAKUP_SYNTH_LTLK=m
# CONFIG_SPEAKUP_SYNTH_SOFT is not set
CONFIG_SPEAKUP_SYNTH_SPKOUT=m
CONFIG_SPEAKUP_SYNTH_TXPRT=m
# CONFIG_SPEAKUP_SYNTH_DUMMY is not set
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=m
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
CONFIG_STAGING_MEDIA=y
# CONFIG_DVB_AS102 is not set
# CONFIG_DVB_CXD2099 is not set
# CONFIG_LIRC_STAGING is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_USB_WPAN_HCD is not set
CONFIG_WIMAX_GDM72XX=y
CONFIG_WIMAX_GDM72XX_QOS=y
CONFIG_WIMAX_GDM72XX_K_MODE=y
CONFIG_WIMAX_GDM72XX_WIMAX2=y
# CONFIG_WIMAX_GDM72XX_USB is not set
CONFIG_WIMAX_GDM72XX_SDIO=y
CONFIG_LTE_GDM724X=m
# CONFIG_NET_VENDOR_SILICOM is not set
CONFIG_CED1401=m
CONFIG_DGRP=m
CONFIG_GOLDFISH_AUDIO=m
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
CONFIG_DGAP=y
# CONFIG_GS_FPGABOOT is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
CONFIG_DELL_LAPTOP=y
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
CONFIG_AMILO_RFKILL=y
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=m
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
CONFIG_GOLDFISH_PIPE=y
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_LAPTOP=m
# CONFIG_CHROMEOS_PSTORE is not set

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
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=m

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
# CONFIG_EXTCON_ADC_JACK is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=y
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

#
# Analog to digital converters
#
# CONFIG_MAX1363 is not set
CONFIG_MCP3422=m
CONFIG_NAU7802=m
CONFIG_TI_ADC081C=m
# CONFIG_TI_AM335X_ADC is not set

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Digital to analog converters
#
CONFIG_AD5064=m
# CONFIG_AD5380 is not set
# CONFIG_AD5446 is not set
CONFIG_MAX517=m
# CONFIG_MCP4725 is not set

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
CONFIG_HID_SENSOR_GYRO_3D=m
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
# CONFIG_ADJD_S311 is not set
CONFIG_APDS9300=m
# CONFIG_CM32181 is not set
CONFIG_CM36651=m
CONFIG_GP2AP020A00F=m
CONFIG_HID_SENSOR_ALS=m
CONFIG_SENSORS_LM3533=m
# CONFIG_LTR501 is not set
CONFIG_TCS3472=m
CONFIG_SENSORS_TSL2563=m
# CONFIG_TSL4531 is not set
CONFIG_VCNL4000=m

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
CONFIG_MAG3110=m
CONFIG_HID_SENSOR_MAGNETOMETER_3D=m
CONFIG_IIO_ST_MAGN_3AXIS=m
CONFIG_IIO_ST_MAGN_I2C_3AXIS=m

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=m

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=m
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure sensors
#
# CONFIG_MPL3115 is not set
CONFIG_IIO_ST_PRESS=m
CONFIG_IIO_ST_PRESS_I2C=m

#
# Temperature sensors
#
CONFIG_TMP006=m
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_IPACK_BUS=m
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=m
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=m
CONFIG_FMC_FAKEDEV=m
CONFIG_FMC_TRIVIAL=m
CONFIG_FMC_WRITE_EEPROM=m
# CONFIG_FMC_CHARDEV is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
CONFIG_PHY_EXYNOS_MIPI_VIDEO=y
# CONFIG_POWERCAP is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
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
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=m
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=m
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=m
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
# CONFIG_REISERFS_FS_POSIX_ACL is not set
# CONFIG_REISERFS_FS_SECURITY is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
CONFIG_XFS_DEBUG=y
CONFIG_GFS2_FS=m
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=m
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_STATS is not set
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
CONFIG_ADFS_FS_RW=y
CONFIG_AFFS_FS=m
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=y
# CONFIG_HFSPLUS_FS_POSIX_ACL is not set
CONFIG_BEFS_FS=y
CONFIG_BEFS_DEBUG=y
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_LOGFS=y
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=m
CONFIG_SQUASHFS_FILE_CACHE=y
# CONFIG_SQUASHFS_FILE_DIRECT is not set
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZO is not set
# CONFIG_SQUASHFS_XZ is not set
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=m
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=m
CONFIG_QNX4FS_FS=y
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=m
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=y
CONFIG_UFS_FS_WRITE=y
# CONFIG_UFS_DEBUG is not set
CONFIG_EXOFS_FS=m
# CONFIG_EXOFS_DEBUG is not set
# CONFIG_F2FS_FS is not set
CONFIG_ORE=m
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NCP_FS=m
# CONFIG_NCPFS_PACKET_SIGNING is not set
# CONFIG_NCPFS_IOCTL_LOCKING is not set
# CONFIG_NCPFS_STRONG is not set
CONFIG_NCPFS_NFS_NS=y
# CONFIG_NCPFS_OS2_NS is not set
# CONFIG_NCPFS_SMALLDOS is not set
CONFIG_NCPFS_NLS=y
# CONFIG_NCPFS_EXTRAS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=m
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=m
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=m
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=m
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=m
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
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
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_DEBUG_SLAB=y
CONFIG_DEBUG_SLAB_LEAK=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y

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
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=m
CONFIG_CPU_NOTIFIER_ERROR_INJECT=m
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
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
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
# CONFIG_BRANCH_TRACER is not set
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=m
CONFIG_INTERVAL_TREE_TEST=m
CONFIG_PERCPU_TEST=m
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=m
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
CONFIG_DMA_API_DEBUG=y
CONFIG_TEST_MODULE=m
CONFIG_TEST_USER_COPY=m
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_SET_MODULE_RONX is not set
CONFIG_DEBUG_NX_TEST=m
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
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
CONFIG_BIG_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_XOR=m
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
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=m
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=m
# CONFIG_CRYPTO_SHA1 is not set
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=m
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_586=m
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=m
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_LZ4=m
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_ASYMMETRIC_KEY_TYPE=m
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=m
CONFIG_PUBLIC_KEY_ALGO_RSA=m
CONFIG_X509_CERTIFICATE_PARSER=m
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_LGUEST is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
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
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
# CONFIG_CRC64_ECMA is not set
CONFIG_AUDIT_GENERIC=y
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=m
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_BTREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=m
CONFIG_OID_REGISTRY=m

--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--YiEDa0DAkWCtVeE4--
