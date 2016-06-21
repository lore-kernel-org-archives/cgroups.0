From: Ma Shimiao <mashimiao.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: question about cgroupv2
Date: Tue, 21 Jun 2016 14:04:37 +0800
Message-ID: <5768D8F5.1060107@cn.fujitsu.com>
References: <5764ADC5.20205@cn.fujitsu.com> <5768D36D.3060606@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5768D36D.3060606-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

Hello,

On 06/21/2016 01:41 PM, Zefan Li wrote:
> On 2016/6/18 10:11, Ma Shimiao wrote:
>> Hello,
>>
>> Sorry for disturbing.
>>
>> I want to test how to use cgroup v2 on kernel 4.6.2.
>> And I have read https://www.kernel.org/doc/Documentation/cgroup-v2.txt
>> According to the above document, I added kernel parameter cgroup_no_v1=1.
>> But, system still automount the v1 cgroup.
>> Then, I executed:
>> # mount -t cgroup2 none /mnt
>>
>> But, cgroup.controllers in /mnt is empty.
>>
>> I'm not sure if I made something wrong or cgroup v2 is not supported on kernel 4.6.2?
>>
> 
> cgroup_no_v1=1 is wrong, try cgroup_no_v1=all. :)

Ah, it seems work, but I'm not sure.

There are not so many cgroup v1 hierarchy mounted. 
But it seems there is still not cgroup v2 hierarchy mounted.

# mount -l | grep cgroup
tmpfs on /sys/fs/cgroup type tmpfs (rw,nosuid,nodev,noexec,seclabel,mode=755)
cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd)

# cat /proc/cgroups 
#subsys_name	hierarchy	num_cgroups	enabled
cpuset	0	1	1
cpu	0	1	1
cpuacct	0	1	1
blkio	0	1	1
memory	0	1	1
devices	0	1	1
freezer	0	1	1
net_cls	0	1	1
perf_event	0	1	1
hugetlb	0	1	1

# dmesg
[    0.000000] Linux version 4.6.2 (root-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org) (gcc version 4.8.2 20131017 (Red Hat 4.8.2-1) (GCC) ) #1 SMP Thu Jun 16 18:27:24 CST 2016
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-4.6.2 root=UUID=54e321d7-eb1c-4c8c-9f15-a383759ed99b ro vconsole.font=latarcyrheb-sun16 cgroup_no_v1=all rhgb quiet LANG=en_US.UTF-8
[    0.000000] x86/fpu: Legacy x87 FPU detected.
[    0.000000] x86/fpu: Using 'eager' FPU context switches.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007ffdffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007ffe0000-0x000000007fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.8.1-20150318_183358- 04/01/2014
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x7ffe0 max_arch_pfn = 0x400000000
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
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT  
[    0.000000] found SMP MP-table at [mem 0x000f6550-0x000f655f] mapped at [ffff8800000f6550]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] BRK [0x0202d000, 0x0202dfff] PGTABLE
[    0.000000] BRK [0x0202e000, 0x0202efff] PGTABLE
[    0.000000] BRK [0x0202f000, 0x0202ffff] PGTABLE
[    0.000000] BRK [0x02030000, 0x02030fff] PGTABLE
[    0.000000] BRK [0x02031000, 0x02031fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x35f82000-0x36fb8fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F6330 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x000000007FFE1707 000030 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x000000007FFE0C67 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x000000007FFE0040 000C27 (v01 BOCHS  BXPCDSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x000000007FFE0000 000040
[    0.000000] ACPI: SSDT 0x000000007FFE0CDB 0009AC (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x000000007FFE1687 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000007ffdffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x7ffce000-0x7ffdffff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:7ffcc001, primary cpu clock
[    0.000000] kvm-clock: using sched offset of 9735714822414 cycles
[    0.000000] clocksource: kvm-clock: mask: 0xffffffffffffffff max_cycles: 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x000000007ffdffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009efff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000007ffdffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000007ffdffff]
[    0.000000] On node 0 totalpages: 524158
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 8128 pages used for memmap
[    0.000000]   DMA32 zone: 520160 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x80000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] percpu: Embedded 33 pages/cpu @ffff88007fc00000 s97112 r8192 d29864 u1048576
[    0.000000] pcpu-alloc: s97112 r8192 d29864 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 7fc0d880
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 515945
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-4.6.2 root=UUID=54e321d7-eb1c-4c8c-9f15-a383759ed99b ro vconsole.font=latarcyrheb-sun16 cgroup_no_v1=all rhgb quiet LANG=en_US.UTF-8
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 2030140K/2096632K available (7355K kernel code, 1241K rwdata, 3012K rodata, 1560K init, 1432K bss, 66492K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Build-time adjustment of leaf fanout to 64.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=128 to nr_cpu_ids=2.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=2
[    0.000000] NR_IRQS:8448 nr_irqs:440 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] tsc: Detected 3292.520 MHz processor
[    0.044626] Calibrating delay loop (skipped) preset value.. 6585.04 BogoMIPS (lpj=3292520)
[    0.044628] pid_max: default: 32768 minimum: 301
[    0.044636] ACPI: Core revision 20160108
[    0.045464] ACPI: 2 ACPI AML tables successfully acquired and loaded

[    0.045484] Security Framework initialized
[    0.045485] SELinux:  Initializing.
[    0.045494] SELinux:  Starting in permissive mode
[    0.045663] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.045994] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.046138] Mount-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.046141] Mountpoint-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.046315] Disabling cpuset control group subsystem in v1 mounts
[    0.046318] Disabling cpu control group subsystem in v1 mounts
[    0.046320] Disabling cpuacct control group subsystem in v1 mounts
[    0.046322] Disabling io control group subsystem in v1 mounts
[    0.046326] Disabling memory control group subsystem in v1 mounts
[    0.046329] Disabling devices control group subsystem in v1 mounts
[    0.046330] Disabling freezer control group subsystem in v1 mounts
[    0.046332] Disabling net_cls control group subsystem in v1 mounts
[    0.046333] Disabling perf_event control group subsystem in v1 mounts
[    0.046335] Disabling hugetlb control group subsystem in v1 mounts
[    0.046382] mce: CPU supports 10 MCE banks
[    0.046425] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.046426] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.047613] Freeing SMP alternatives memory: 28K (ffffffff81ebe000 - ffffffff81ec5000)
[    0.050619] ftrace: allocating 28265 entries in 111 pages
[    0.077724] smpboot: Max logical packages: 2
[    0.077727] smpboot: APIC(0) Converting physical 0 to logical package 0
[    0.077728] smpboot: APIC(1) Converting physical 1 to logical package 1
[    0.077877] x2apic enabled
[    0.078058] Switched APIC routing to physical x2apic.
[    0.078878] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.180597] smpboot: CPU0: Intel Core i7 9xx (Nehalem Class Core i7) (family: 0x6, model: 0x1a, stepping: 0x3)
[    0.180611] Performance Events: unsupported p6 CPU model 26 no PMU driver, software events only.
[    0.181233] x86: Booting SMP configuration:
[    0.181234] .... node  #0, CPUs:      #1
[    0.181370] kvm-clock: cpu 1, msr 0:7ffcc041, secondary cpu clock
[    0.201555] KVM setup async PF for cpu 1
[    0.201560] kvm-stealtime: cpu 1, msr 7fd0d880
[    0.201575] x86: Booted up 1 node, 2 CPUs
[    0.201577] smpboot: Total of 2 processors activated (13170.08 BogoMIPS)
[    0.202107] devtmpfs: initialized
[    0.202338] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.202396] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.202398] pinctrl core: initialized pinctrl subsystem
[    0.202469] RTC time:  5:43:27, date: 06/21/16
[    0.202586] NET: Registered protocol family 16
[    0.207630] cpuidle: using governor menu
[    0.207788] ACPI: bus type PCI registered
[    0.207790] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.207878] PCI: Using configuration type 1 for base access
[    0.212936] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.213172] ACPI: Added _OSI(Module Device)
[    0.213173] ACPI: Added _OSI(Processor Device)
[    0.213174] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.213175] ACPI: Added _OSI(Processor Aggregator Device)
[    0.213466] ACPI: Executed 1 blocks of module-level executable AML code
[    0.213925] ACPI: Interpreter enabled
[    0.213932] ACPI: (supports S0 S5)
[    0.213933] ACPI: Using IOAPIC for interrupt routing
[    0.213942] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.215903] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.215908] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    0.215911] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.215916] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.216140] acpiphp: Slot [3] registered
[    0.216155] acpiphp: Slot [4] registered
[    0.216173] acpiphp: Slot [5] registered
[    0.216197] acpiphp: Slot [7] registered
[    0.216212] acpiphp: Slot [8] registered
[    0.216227] acpiphp: Slot [9] registered
[    0.216242] acpiphp: Slot [10] registered
[    0.216256] acpiphp: Slot [11] registered
[    0.216270] acpiphp: Slot [12] registered
[    0.216287] acpiphp: Slot [13] registered
[    0.216302] acpiphp: Slot [14] registered
[    0.216316] acpiphp: Slot [15] registered
[    0.216330] acpiphp: Slot [16] registered
[    0.216345] acpiphp: Slot [17] registered
[    0.216359] acpiphp: Slot [18] registered
[    0.216376] acpiphp: Slot [19] registered
[    0.216391] acpiphp: Slot [20] registered
[    0.216405] acpiphp: Slot [21] registered
[    0.216420] acpiphp: Slot [22] registered
[    0.216435] acpiphp: Slot [23] registered
[    0.216449] acpiphp: Slot [24] registered
[    0.216464] acpiphp: Slot [25] registered
[    0.216483] acpiphp: Slot [26] registered
[    0.216497] acpiphp: Slot [27] registered
[    0.216512] acpiphp: Slot [28] registered
[    0.216529] acpiphp: Slot [29] registered
[    0.216543] acpiphp: Slot [30] registered
[    0.216558] acpiphp: Slot [31] registered
[    0.216567] PCI host bridge to bus 0000:00
[    0.216570] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.216571] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.216572] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.216573] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff window]
[    0.216575] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.216610] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.216895] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.217264] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.224359] pci 0000:00:01.1: reg 0x20: [io  0xc120-0xc12f]
[    0.227673] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.227677] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.227678] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.227679] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.228732] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.229030] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX4 ACPI
[    0.229037] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX4 SMB
[    0.229205] pci 0000:00:02.0: [1b36:0100] type 00 class 0x030000
[    0.235763] pci 0000:00:02.0: reg 0x10: [mem 0xf4000000-0xf7ffffff]
[    0.242413] pci 0000:00:02.0: reg 0x14: [mem 0xf8000000-0xfbffffff]
[    0.248421] pci 0000:00:02.0: reg 0x18: [mem 0xfc054000-0xfc055fff]
[    0.255763] pci 0000:00:02.0: reg 0x1c: [io  0xc040-0xc05f]
[    0.274488] pci 0000:00:02.0: reg 0x30: [mem 0xfc040000-0xfc04ffff pref]
[    0.274783] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.278951] pci 0000:00:03.0: reg 0x10: [io  0xc060-0xc07f]
[    0.281683] pci 0000:00:03.0: reg 0x14: [mem 0xfc056000-0xfc056fff]
[    0.296091] pci 0000:00:03.0: reg 0x30: [mem 0xfc000000-0xfc03ffff pref]
[    0.296389] pci 0000:00:04.0: [8086:2668] type 00 class 0x040300
[    0.297811] pci 0000:00:04.0: reg 0x10: [mem 0xfc050000-0xfc053fff]
[    0.307828] pci 0000:00:05.0: [1af4:1003] type 00 class 0x078000
[    0.311711] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc09f]
[    0.315002] pci 0000:00:05.0: reg 0x14: [mem 0xfc057000-0xfc057fff]
[    0.329803] pci 0000:00:06.0: [8086:2934] type 00 class 0x0c0300
[    0.337528] pci 0000:00:06.0: reg 0x20: [io  0xc0a0-0xc0bf]
[    0.340480] pci 0000:00:06.1: [8086:2935] type 00 class 0x0c0300
[    0.348518] pci 0000:00:06.1: reg 0x20: [io  0xc0c0-0xc0df]
[    0.351423] pci 0000:00:06.2: [8086:2936] type 00 class 0x0c0300
[    0.359299] pci 0000:00:06.2: reg 0x20: [io  0xc0e0-0xc0ff]
[    0.362383] pci 0000:00:06.7: [8086:293a] type 00 class 0x0c0320
[    0.363847] pci 0000:00:06.7: reg 0x10: [mem 0xfc058000-0xfc058fff]
[    0.372936] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.375759] pci 0000:00:07.0: reg 0x10: [io  0xc000-0xc03f]
[    0.379030] pci 0000:00:07.0: reg 0x14: [mem 0xfc059000-0xfc059fff]
[    0.394338] pci 0000:00:08.0: [1af4:1002] type 00 class 0x00ff00
[    0.395794] pci 0000:00:08.0: reg 0x10: [io  0xc100-0xc11f]
[    0.405742] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.405825] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.405890] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.405957] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.405992] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.406257] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.406451] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.406453] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.406455] vgaarb: loaded
[    0.406456] vgaarb: bridge control possible 0000:00:02.0
[    0.406541] SCSI subsystem initialized
[    0.406637] libata version 3.00 loaded.
[    0.406666] ACPI: bus type USB registered
[    0.406696] usbcore: registered new interface driver usbfs
[    0.406702] usbcore: registered new interface driver hub
[    0.406717] usbcore: registered new device driver usb
[    0.406860] PCI: Using ACPI for IRQ routing
[    0.406863] PCI: pci_cache_line_size set to 64 bytes
[    0.407042] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.407044] e820: reserve RAM buffer [mem 0x7ffe0000-0x7fffffff]
[    0.407154] NetLabel: Initializing
[    0.407155] NetLabel:  domain hash size = 128
[    0.407155] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.407165] NetLabel:  unlabeled traffic allowed by default
[    0.407281] clocksource: Switched to clocksource kvm-clock
[    0.414398] VFS: Disk quotas dquot_6.6.0
[    0.414425] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.414541] pnp: PnP ACPI init
[    0.414596] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.414629] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.414653] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.414674] pnp 00:03: [dma 2]
[    0.414685] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.414776] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.414927] pnp: PnP ACPI: found 5 devices
[    0.422343] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.422356] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.422357] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.422359] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.422360] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff window]
[    0.422389] NET: Registered protocol family 2
[    0.422581] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.422647] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.422740] TCP: Hash tables configured (established 16384 bind 16384)
[    0.422765] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.422772] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.422806] NET: Registered protocol family 1
[    0.422816] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.422836] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.422851] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.422888] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.440939] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    0.477405] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    0.513699] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    0.549918] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    0.568176] PCI: CLS 0 bytes, default 64
[    0.568229] Unpacking initramfs...
[    0.757235] Freeing initrd memory: 16604K (ffff880035f82000 - ffff880036fb9000)
[    0.758037] futex hash table entries: 512 (order: 3, 32768 bytes)
[    0.758058] audit: initializing netlink subsys (disabled)
[    0.758079] audit: type=2000 audit(1466487808.376:1): initialized
[    0.758316] Initialise system trusted keyring
[    0.758379] workingset: timestamp_bits=35 max_order=19 bucket_order=0
[    0.759559] zbud: loaded
[    0.759978] Key type big_key registered
[    0.759980] SELinux:  Registering netfilter hooks
[    0.797140] NET: Registered protocol family 38
[    0.797153] Key type asymmetric registered
[    0.797158] Asymmetric key parser 'x509' registered
[    0.797227] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.797278] io scheduler noop registered
[    0.797301] io scheduler deadline registered
[    0.797327] io scheduler cfq registered (default)
[    0.797398] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.797402] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.797439] intel_idle: does not run on family 6 model 26
[    0.797521] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.797525] ACPI: Power Button [PWRF]
[    0.797760] GHES: HEST is not enabled!
[    0.797842] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.822940] 00:04: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.823466] Non-volatile memory driver v1.3
[    0.823493] Linux agpgart interface v0.103
[    0.823776] ata_piix 0000:00:01.1: version 2.13
[    0.824734] scsi host0: ata_piix
[    0.824832] scsi host1: ata_piix
[    0.824863] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc120 irq 14
[    0.824865] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc128 irq 15
[    0.824928] libphy: Fixed MDIO Bus: probed
[    0.825097] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.825101] ehci-pci: EHCI PCI platform driver
[    0.846618] ehci-pci 0000:00:06.7: EHCI Host Controller
[    0.846737] ehci-pci 0000:00:06.7: new USB bus registered, assigned bus number 1
[    0.846888] ehci-pci 0000:00:06.7: irq 10, io mem 0xfc058000
[    0.852311] ehci-pci 0000:00:06.7: USB 2.0 started, EHCI 1.00
[    0.852348] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.852350] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.852351] usb usb1: Product: EHCI Host Controller
[    0.852353] usb usb1: Manufacturer: Linux 4.6.2 ehci_hcd
[    0.852354] usb usb1: SerialNumber: 0000:00:06.7
[    0.852511] hub 1-0:1.0: USB hub found
[    0.852516] hub 1-0:1.0: 6 ports detected
[    0.852682] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.852687] ohci-pci: OHCI PCI platform driver
[    0.852696] uhci_hcd: USB Universal Host Controller Interface driver
[    0.872380] uhci_hcd 0000:00:06.0: UHCI Host Controller
[    0.872499] uhci_hcd 0000:00:06.0: new USB bus registered, assigned bus number 2
[    0.872516] uhci_hcd 0000:00:06.0: detected 2 ports
[    0.872557] uhci_hcd 0000:00:06.0: irq 10, io base 0x0000c0a0
[    0.872613] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    0.872615] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.872616] usb usb2: Product: UHCI Host Controller
[    0.872617] usb usb2: Manufacturer: Linux 4.6.2 uhci_hcd
[    0.872618] usb usb2: SerialNumber: 0000:00:06.0
[    0.872779] hub 2-0:1.0: USB hub found
[    0.872784] hub 2-0:1.0: 2 ports detected
[    0.891659] uhci_hcd 0000:00:06.1: UHCI Host Controller
[    0.891798] uhci_hcd 0000:00:06.1: new USB bus registered, assigned bus number 3
[    0.891815] uhci_hcd 0000:00:06.1: detected 2 ports
[    0.891886] uhci_hcd 0000:00:06.1: irq 11, io base 0x0000c0c0
[    0.891952] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.891954] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.891955] usb usb3: Product: UHCI Host Controller
[    0.891956] usb usb3: Manufacturer: Linux 4.6.2 uhci_hcd
[    0.891957] usb usb3: SerialNumber: 0000:00:06.1
[    0.892063] hub 3-0:1.0: USB hub found
[    0.892067] hub 3-0:1.0: 2 ports detected
[    0.910911] uhci_hcd 0000:00:06.2: UHCI Host Controller
[    0.911017] uhci_hcd 0000:00:06.2: new USB bus registered, assigned bus number 4
[    0.911033] uhci_hcd 0000:00:06.2: detected 2 ports
[    0.911070] uhci_hcd 0000:00:06.2: irq 11, io base 0x0000c0e0
[    0.911120] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.911121] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.911123] usb usb4: Product: UHCI Host Controller
[    0.911124] usb usb4: Manufacturer: Linux 4.6.2 uhci_hcd
[    0.911125] usb usb4: SerialNumber: 0000:00:06.2
[    0.911256] hub 4-0:1.0: USB hub found
[    0.911260] hub 4-0:1.0: 2 ports detected
[    0.911395] usbcore: registered new interface driver usbserial
[    0.911400] usbcore: registered new interface driver usbserial_generic
[    0.911404] usbserial: USB Serial support registered for generic
[    0.911428] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.911983] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.911987] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.912079] mousedev: PS/2 mouse device common for all mice
[    0.912310] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    0.913635] rtc_cmos 00:00: RTC can wake from S4
[    0.913854] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    0.913916] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram
[    0.913958] device-mapper: uevent: version 1.0.3
[    0.914025] device-mapper: ioctl: 4.34.0-ioctl (2015-10-28) initialised: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
[    0.914129] hidraw: raw HID events driver (C) Jiri Kosina
[    0.914215] usbcore: registered new interface driver usbhid
[    0.914216] usbhid: USB HID core driver
[    0.914253] drop_monitor: Initializing network drop monitor service
[    0.914318] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.914357] Initializing XFRM netlink socket
[    0.914467] NET: Registered protocol family 10
[    0.914628] mip6: Mobile IPv6
[    0.914631] NET: Registered protocol family 17
[    0.914771] microcode: CPU0 sig=0x106a3, pf=0x1, revision=0x1
[    0.914779] microcode: CPU1 sig=0x106a3, pf=0x1, revision=0x1
[    0.914805] microcode: Microcode Update Driver: v2.01 <tigran-ppwZ4lME3+KI6QP4U9MhSdBc4/FLrbF6@public.gmane.org>, Peter Oruba
[    0.914923] registered taskstats version 1
[    0.914931] Loading compiled-in X.509 certificates
[    0.915989] alg: No test for pkcs1pad(rsa,sha256) (pkcs1pad(rsa-generic,sha256))
[    0.916642] Loaded X.509 cert 'Build time autogenerated kernel key: 85e6396634fa387f42956cf1cf28c26f4eedb0a5'
[    0.916666] zswap: loaded using pool lzo/zbud
[    0.916933]   Magic number: 4:789:719
[    0.917041] rtc_cmos 00:00: setting system clock to 2016-06-21 05:43:28 UTC (1466487808)
[    0.917075] PM: Hibernation image not present or could not be loaded.
[    0.976181] ata1.01: NODEV after polling detection
[    0.976505] ata1.00: ATAPI: QEMU DVD-ROM, 2.3.1, max UDMA/100
[    0.977055] ata1.00: configured for MWDMA2
[    0.977651] scsi 0:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     2.3. PQ: 0 ANSI: 5
[    0.993242] sr 0:0:0:0: [sr0] scsi3-mmc drive: 4x/4x cd/rw xa/form2 tray
[    0.993246] cdrom: Uniform CD-ROM driver Revision: 3.20
[    0.993539] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    0.993803] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    0.995105] Freeing unused kernel memory: 1560K (ffffffff81d38000 - ffffffff81ebe000)
[    0.995108] Write protecting the kernel read-only data: 12288k
[    0.995542] Freeing unused kernel memory: 820K (ffff880001733000 - ffff880001800000)
[    0.999081] Freeing unused kernel memory: 1084K (ffff880001af1000 - ffff880001c00000)
[    1.002009] systemd[1]: systemd 208 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    1.002051] systemd[1]: Detected virtualization 'kvm'.
[    1.002054] systemd[1]: Running in initial RAM disk.
[    1.002115] systemd[1]: Set hostname to <localhost.localdomain>.
[    1.012590] random: systemd urandom read with 3 bits of entropy available
[    1.017068] systemd[1]: Expecting device dev-disk-by\x2duuid-54e321d7\x2deb1c\x2d4c8c\x2d9f15\x2da383759ed99b.device...
[    1.017083] systemd[1]: Starting -.slice.
[    1.017146] systemd[1]: Created slice -.slice.
[    1.017155] systemd[1]: Starting System Slice.
[    1.017209] systemd[1]: Created slice System Slice.
[    1.017218] systemd[1]: Starting Slices.
[    1.017226] systemd[1]: Reached target Slices.
[    1.017233] systemd[1]: Starting Timers.
[    1.017241] systemd[1]: Reached target Timers.
[    1.017249] systemd[1]: Starting Journal Socket.
[    1.017315] systemd[1]: Listening on Journal Socket.
[    1.017465] systemd[1]: Starting dracut cmdline hook...
[    1.017897] systemd[1]: Started Load Kernel Modules.
[    1.017911] systemd[1]: Starting Journal Service...
[    1.019559] systemd[1]: Started Journal Service.
[    1.021625] systemd-journald[85]: Vacuuming done, freed 0 bytes
[    1.103953] systemd-udevd[148]: starting version 208
[    1.154296] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    1.219323] virtio-pci 0000:00:03.0: virtio_pci: leaving for legacy driver
[    1.238837] virtio-pci 0000:00:05.0: virtio_pci: leaving for legacy driver
[    1.249068] [drm] Initialized drm 1.1.0 20060810
[    1.261554] virtio-pci 0000:00:07.0: virtio_pci: leaving for legacy driver
[    1.274330] usb 1-1: New USB device found, idVendor=0627, idProduct=0001
[    1.274334] usb 1-1: New USB device strings: Mfr=1, Product=3, SerialNumber=5
[    1.274335] usb 1-1: Product: QEMU USB Tablet
[    1.274336] usb 1-1: Manufacturer: QEMU
[    1.274337] usb 1-1: SerialNumber: 42
[    1.282847] virtio-pci 0000:00:08.0: virtio_pci: leaving for legacy driver
[    1.296418]  vda: vda1 vda2 < vda5 >
[    1.298122] input: QEMU QEMU USB Tablet as /devices/pci0000:00/0000:00:06.7/usb1/1-1/1-1:1.0/0003:0627:0001.0001/input/input4
[    1.298308] hid-generic 0003:0627:0001.0001: input,hidraw0: USB HID v0.01 Pointer [QEMU QEMU USB Tablet] on usb-0000:00:06.7-1/input0
[    1.354455] [drm] Device Version 0.0
[    1.354457] [drm] Compression level 0 log level 0
[    1.354458] [drm] Currently using mode #0, list at 0x488
[    1.354459] [drm] 12286 io pages at offset 0x1000000
[    1.354460] [drm] 16777216 byte draw area at offset 0x0
[    1.354461] [drm] RAM header offset: 0x3ffe000
[    1.354461] [drm] rom modes offset 0x488 for 128 modes
[    1.354578] [TTM] Zone  kernel: Available graphics memory: 1025118 kiB
[    1.354580] [TTM] Initializing pool allocator
[    1.354584] [TTM] Initializing DMA pool allocator
[    1.354592] [drm] qxl: 16M of VRAM memory size
[    1.354593] [drm] qxl: 63M of IO pages memory ready (VRAM domain)
[    1.354593] [drm] qxl: 64M of Surface memory size
[    1.357007] [drm] main mem slot 1 [f4000000,3ffe000]
[    1.357010] [drm] surface mem slot 2 [f8000000,4000000]
[    1.357050] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    1.357051] [drm] No driver support for vblank timestamp query.
[    1.357558] [drm] fb mappable at 0xF4000000, size 3145728
[    1.357560] [drm] fb: depth 24, pitch 4096, width 1024, height 768
[    1.357614] fbcon: qxldrmfb (fb0) is primary device
[    1.368199] Console: switching to colour frame buffer device 128x48
[    1.369856] qxl 0000:00:02.0: fb0: qxldrmfb frame buffer device
[    1.374312] [drm] Initialized qxl 0.1.0 20120117 for 0000:00:02.0 on minor 0
[    1.692345] PM: Starting manual resume from disk
[    1.692351] PM: Hibernation image partition 252:5 present
[    1.692352] PM: Looking for hibernation image.
[    1.692686] PM: Image not found (code -22)
[    1.692689] PM: Hibernation image not present or could not be loaded.
[    1.707858] EXT4-fs (vda1): mounted filesystem with ordered data mode. Opts: (null)
[    1.735583] input: ImExPS/2 BYD TouchPad as /devices/platform/i8042/serio1/input/input3
[    1.760453] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x2f75b1eac7a, max_idle_ns: 440795210882 ns
[    1.818402] systemd-journald[85]: Received SIGTERM
[    1.838550] audit: type=1404 audit(1466487809.421:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[    1.850824] SELinux: 32768 avtab hash slots, 101316 rules.
[    1.863996] SELinux: 32768 avtab hash slots, 101316 rules.
[    1.879104] SELinux:  8 users, 83 roles, 4634 types, 265 bools, 1 sens, 1024 cats
[    1.879108] SELinux:  83 classes, 101316 rules
[    1.882363] SELinux:  Permission validate_trans in class security not defined in policy.
[    1.882419] SELinux:  Class netlink_iscsi_socket not defined in policy.
[    1.882421] SELinux:  Class netlink_fib_lookup_socket not defined in policy.
[    1.882422] SELinux:  Class netlink_connector_socket not defined in policy.
[    1.882423] SELinux:  Class netlink_netfilter_socket not defined in policy.
[    1.882427] SELinux:  Class netlink_generic_socket not defined in policy.
[    1.882428] SELinux:  Class netlink_scsitransport_socket not defined in policy.
[    1.882429] SELinux:  Class netlink_rdma_socket not defined in policy.
[    1.882429] SELinux:  Class netlink_crypto_socket not defined in policy.
[    1.882436] SELinux:  Permission audit_read in class capability2 not defined in policy.
[    1.882439] SELinux:  Class binder not defined in policy.
[    1.882440] SELinux: the above unknown classes and permissions will be allowed
[    1.882444] SELinux:  Completing initialization.
[    1.882445] SELinux:  Setting up existing superblocks.
[    1.889350] audit: type=1403 audit(1466487809.472:3): policy loaded auid=4294967295 ses=4294967295
[    1.893211] systemd[1]: Successfully loaded SELinux policy in 55.154ms.
[    1.907714] audit: type=1400 audit(1466487809.490:4): avc:  denied  { associate } for  pid=1 comm="systemd" name="/" dev="pstore" ino=1169 scontext=system_u:object_r:sysfs_t:s0 tcontext=system_u:object_r:pstorefs_t:s0 tclass=filesystem permissive=0
[    1.907842] systemd[1]: Unable to fix label of /sys/fs/pstore: Permission denied
[    1.922962] systemd[1]: Relabelled /dev and /run in 15.082ms.
[    2.150274] RPC: Registered named UNIX socket transport module.
[    2.150276] RPC: Registered udp transport module.
[    2.150277] RPC: Registered tcp transport module.
[    2.150278] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.174782] systemd-journald[293]: Vacuuming done, freed 0 bytes
[    2.341966] EXT4-fs (vda1): re-mounted. Opts: (null)
[    2.408547] Installing knfsd (copyright (C) 1996 okir-pn4DOG8n3UYbFoVRYvo4fw@public.gmane.org).
[    2.412532] systemd-udevd[300]: starting version 208
[    2.478161] systemd-journald[293]: Received request to flush runtime journal from PID 1
[    2.483988] audit: type=1305 audit(1466487810.066:5): audit_pid=333 old=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:auditd_t:s0 res=1
[    2.689365] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0x700, revision 0
[    3.558183] Adding 2094076k swap on /dev/vda5.  Priority:-1 extents:1 across:2094076k FS
[    3.591921] systemd-journald[293]: Received request to flush runtime journal from PID 1
[    4.005506] snd_hda_codec_generic hdaudioC0D0: autoconfig for Generic: line_outs=1 (0x3/0x0/0x0/0x0/0x0) type:line
[    4.005511] snd_hda_codec_generic hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    4.005513] snd_hda_codec_generic hdaudioC0D0:    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    4.005515] snd_hda_codec_generic hdaudioC0D0:    mono: mono_out=0x0
[    4.005516] snd_hda_codec_generic hdaudioC0D0:    inputs:
[    4.005519] snd_hda_codec_generic hdaudioC0D0:      Line=0x5
[    4.769436] Bluetooth: Core ver 2.21
[    4.769527] NET: Registered protocol family 31
[    4.769529] Bluetooth: HCI device and connection manager initialized
[    4.769532] Bluetooth: HCI socket layer initialized
[    4.769534] Bluetooth: L2CAP socket layer initialized
[    4.769542] Bluetooth: SCO socket layer initialized
[    4.902485] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    4.902489] Bluetooth: BNEP filters: protocol multicast
[    4.902493] Bluetooth: BNEP socket layer initialized
[    5.749828] Ebtables v2.0 registered
[    5.775363] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   28.360789] random: nonblocking pool is initialized


And, is there a document saying cgroup_no_v1 accepts which parameters?

> 
> 
> 
> 


-- 
Ma Shimiao
Development Dept.I
Nanjing Fujitsu Nanda Software Tech. Co., Ltd.(FNST)

