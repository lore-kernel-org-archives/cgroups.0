From: Ma Shimiao <mashimiao.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: question about cgroupv2
Date: Tue, 21 Jun 2016 11:10:16 +0800
Message-ID: <5768B018.70707@cn.fujitsu.com>
References: <5764ADC5.20205@cn.fujitsu.com>
 <20160620181929.GN3262@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160620181929.GN3262-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On 06/21/2016 02:19 AM, Tejun Heo wrote:
> Hello,
> 
> On Sat, Jun 18, 2016 at 10:11:17AM +0800, Ma Shimiao wrote:
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
> 
> It should work.  Can you post the outputs of "dmesg" and "cat /proc/cgroups"?

sure.

# dmesg
[    0.000000] Linux version 4.6.2 (root-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org) (gcc version 4.8.2 20131017 (Red Hat 4.8.2-1) (GCC) ) #1 SMP Thu Jun 16 18:27:24 CST 2016
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-4.6.2 root=UUID=54e321d7-eb1c-4c8c-9f15-a383759ed99b ro vconsole.font=latarcyrheb-sun16 cgroup_no_v1=1 rhgb quiet LANG=en_US.UTF-8
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
[    0.000000] kvm-clock: using sched offset of 187830759002 cycles
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
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-4.6.2 root=UUID=54e321d7-eb1c-4c8c-9f15-a383759ed99b ro vconsole.font=latarcyrheb-sun16 cgroup_no_v1=1 rhgb quiet LANG=en_US.UTF-8
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
[    0.045792] Calibrating delay loop (skipped) preset value.. 6585.04 BogoMIPS (lpj=3292520)
[    0.045794] pid_max: default: 32768 minimum: 301
[    0.045809] ACPI: Core revision 20160108
[    0.046656] ACPI: 2 ACPI AML tables successfully acquired and loaded

[    0.046681] Security Framework initialized
[    0.046683] SELinux:  Initializing.
[    0.046691] SELinux:  Starting in permissive mode
[    0.046863] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.047702] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.048125] Mount-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.048129] Mountpoint-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.048410] mce: CPU supports 10 MCE banks
[    0.048449] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.048450] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.049613] Freeing SMP alternatives memory: 28K (ffffffff81ebe000 - ffffffff81ec5000)
[    0.052615] ftrace: allocating 28265 entries in 111 pages
[    0.080066] smpboot: Max logical packages: 2
[    0.080069] smpboot: APIC(0) Converting physical 0 to logical package 0
[    0.080070] smpboot: APIC(1) Converting physical 1 to logical package 1
[    0.080214] x2apic enabled
[    0.080392] Switched APIC routing to physical x2apic.
[    0.081207] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.182759] smpboot: CPU0: Intel Core i7 9xx (Nehalem Class Core i7) (family: 0x6, model: 0x1a, stepping: 0x3)
[    0.182773] Performance Events: unsupported p6 CPU model 26 no PMU driver, software events only.
[    0.183423] x86: Booting SMP configuration:
[    0.183425] .... node  #0, CPUs:      #1
[    0.183553] kvm-clock: cpu 1, msr 0:7ffcc041, secondary cpu clock
[    0.203738] KVM setup async PF for cpu 1
[    0.203743] kvm-stealtime: cpu 1, msr 7fd0d880
[    0.203763] x86: Booted up 1 node, 2 CPUs
[    0.203765] smpboot: Total of 2 processors activated (13170.08 BogoMIPS)
[    0.204300] devtmpfs: initialized
[    0.204560] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.204619] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.204621] pinctrl core: initialized pinctrl subsystem
[    0.204694] RTC time:  3:04:19, date: 06/21/16
[    0.204830] NET: Registered protocol family 16
[    0.209828] cpuidle: using governor menu
[    0.209971] ACPI: bus type PCI registered
[    0.209973] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.210059] PCI: Using configuration type 1 for base access
[    0.215104] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.215332] ACPI: Added _OSI(Module Device)
[    0.215333] ACPI: Added _OSI(Processor Device)
[    0.215334] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.215335] ACPI: Added _OSI(Processor Aggregator Device)
[    0.215631] ACPI: Executed 1 blocks of module-level executable AML code
[    0.216078] ACPI: Interpreter enabled
[    0.216086] ACPI: (supports S0 S5)
[    0.216087] ACPI: Using IOAPIC for interrupt routing
[    0.216096] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.218072] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.218076] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    0.218080] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.218086] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.218313] acpiphp: Slot [3] registered
[    0.218329] acpiphp: Slot [4] registered
[    0.218348] acpiphp: Slot [5] registered
[    0.218372] acpiphp: Slot [7] registered
[    0.218388] acpiphp: Slot [8] registered
[    0.218403] acpiphp: Slot [9] registered
[    0.218418] acpiphp: Slot [10] registered
[    0.218433] acpiphp: Slot [11] registered
[    0.218448] acpiphp: Slot [12] registered
[    0.218466] acpiphp: Slot [13] registered
[    0.218481] acpiphp: Slot [14] registered
[    0.218496] acpiphp: Slot [15] registered
[    0.218511] acpiphp: Slot [16] registered
[    0.218526] acpiphp: Slot [17] registered
[    0.218541] acpiphp: Slot [18] registered
[    0.218559] acpiphp: Slot [19] registered
[    0.218574] acpiphp: Slot [20] registered
[    0.218589] acpiphp: Slot [21] registered
[    0.218604] acpiphp: Slot [22] registered
[    0.218619] acpiphp: Slot [23] registered
[    0.218633] acpiphp: Slot [24] registered
[    0.218648] acpiphp: Slot [25] registered
[    0.218668] acpiphp: Slot [26] registered
[    0.218683] acpiphp: Slot [27] registered
[    0.218698] acpiphp: Slot [28] registered
[    0.218716] acpiphp: Slot [29] registered
[    0.218732] acpiphp: Slot [30] registered
[    0.218746] acpiphp: Slot [31] registered
[    0.218763] PCI host bridge to bus 0000:00
[    0.218766] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.218767] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.218768] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.218769] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff window]
[    0.218771] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.218805] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.219085] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.219457] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.227330] pci 0000:00:01.1: reg 0x20: [io  0xc120-0xc12f]
[    0.231212] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.231216] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.231217] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.231218] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.231393] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.231666] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX4 ACPI
[    0.231673] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX4 SMB
[    0.231857] pci 0000:00:02.0: [1b36:0100] type 00 class 0x030000
[    0.240599] pci 0000:00:02.0: reg 0x10: [mem 0xf4000000-0xf7ffffff]
[    0.247623] pci 0000:00:02.0: reg 0x14: [mem 0xf8000000-0xfbffffff]
[    0.254785] pci 0000:00:02.0: reg 0x18: [mem 0xfc054000-0xfc055fff]
[    0.261498] pci 0000:00:02.0: reg 0x1c: [io  0xc040-0xc05f]
[    0.280524] pci 0000:00:02.0: reg 0x30: [mem 0xfc040000-0xfc04ffff pref]
[    0.281589] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.284364] pci 0000:00:03.0: reg 0x10: [io  0xc060-0xc07f]
[    0.287053] pci 0000:00:03.0: reg 0x14: [mem 0xfc056000-0xfc056fff]
[    0.301837] pci 0000:00:03.0: reg 0x30: [mem 0xfc000000-0xfc03ffff pref]
[    0.302309] pci 0000:00:04.0: [8086:2668] type 00 class 0x040300
[    0.303849] pci 0000:00:04.0: reg 0x10: [mem 0xfc050000-0xfc053fff]
[    0.313857] pci 0000:00:05.0: [1af4:1003] type 00 class 0x078000
[    0.316826] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc09f]
[    0.320649] pci 0000:00:05.0: reg 0x14: [mem 0xfc057000-0xfc057fff]
[    0.335299] pci 0000:00:06.0: [8086:2934] type 00 class 0x0c0300
[    0.343203] pci 0000:00:06.0: reg 0x20: [io  0xc0a0-0xc0bf]
[    0.346115] pci 0000:00:06.1: [8086:2935] type 00 class 0x0c0300
[    0.354127] pci 0000:00:06.1: reg 0x20: [io  0xc0c0-0xc0df]
[    0.357068] pci 0000:00:06.2: [8086:2936] type 00 class 0x0c0300
[    0.366134] pci 0000:00:06.2: reg 0x20: [io  0xc0e0-0xc0ff]
[    0.371378] pci 0000:00:06.7: [8086:293a] type 00 class 0x0c0320
[    0.373950] pci 0000:00:06.7: reg 0x10: [mem 0xfc058000-0xfc058fff]
[    0.389504] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.393901] pci 0000:00:07.0: reg 0x10: [io  0xc000-0xc03f]
[    0.398382] pci 0000:00:07.0: reg 0x14: [mem 0xfc059000-0xfc059fff]
[    0.420511] pci 0000:00:08.0: [1af4:1002] type 00 class 0x00ff00
[    0.422524] pci 0000:00:08.0: reg 0x10: [io  0xc100-0xc11f]
[    0.435966] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.436075] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.436162] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.436249] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.436295] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.436649] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.437067] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.437070] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.437072] vgaarb: loaded
[    0.437073] vgaarb: bridge control possible 0000:00:02.0
[    0.437238] SCSI subsystem initialized
[    0.437344] libata version 3.00 loaded.
[    0.437379] ACPI: bus type USB registered
[    0.437415] usbcore: registered new interface driver usbfs
[    0.437424] usbcore: registered new interface driver hub
[    0.437439] usbcore: registered new device driver usb
[    0.437579] PCI: Using ACPI for IRQ routing
[    0.437582] PCI: pci_cache_line_size set to 64 bytes
[    0.437832] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.437834] e820: reserve RAM buffer [mem 0x7ffe0000-0x7fffffff]
[    0.438047] NetLabel: Initializing
[    0.438049] NetLabel:  domain hash size = 128
[    0.438050] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.438069] NetLabel:  unlabeled traffic allowed by default
[    0.438243] clocksource: Switched to clocksource kvm-clock
[    0.448769] VFS: Disk quotas dquot_6.6.0
[    0.448807] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.448980] pnp: PnP ACPI init
[    0.449049] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.449092] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.449124] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.449149] pnp 00:03: [dma 2]
[    0.449164] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.449295] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.449488] pnp: PnP ACPI: found 5 devices
[    0.456732] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.456755] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.456756] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.456758] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.456760] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff window]
[    0.456811] NET: Registered protocol family 2
[    0.457095] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.457185] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.457306] TCP: Hash tables configured (established 16384 bind 16384)
[    0.457386] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.457405] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.457482] NET: Registered protocol family 1
[    0.457505] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.457529] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.457548] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.457596] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.478983] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    0.517696] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    0.553855] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    0.589991] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    0.608206] PCI: CLS 0 bytes, default 64
[    0.608298] Unpacking initramfs...
[    0.823873] Freeing initrd memory: 16604K (ffff880035f82000 - ffff880036fb9000)
[    0.824680] futex hash table entries: 512 (order: 3, 32768 bytes)
[    0.824704] audit: initializing netlink subsys (disabled)
[    0.824747] audit: type=2000 audit(1466478260.541:1): initialized
[    0.825034] Initialise system trusted keyring
[    0.825141] workingset: timestamp_bits=35 max_order=19 bucket_order=0
[    0.826504] zbud: loaded
[    0.826982] Key type big_key registered
[    0.826984] SELinux:  Registering netfilter hooks
[    0.864619] NET: Registered protocol family 38
[    0.864631] Key type asymmetric registered
[    0.864641] Asymmetric key parser 'x509' registered
[    0.864716] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.864776] io scheduler noop registered
[    0.864793] io scheduler deadline registered
[    0.864823] io scheduler cfq registered (default)
[    0.864904] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.864909] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.864932] intel_idle: does not run on family 6 model 26
[    0.865022] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.865026] ACPI: Power Button [PWRF]
[    0.865282] GHES: HEST is not enabled!
[    0.865348] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.892327] 00:04: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.893040] Non-volatile memory driver v1.3
[    0.893070] Linux agpgart interface v0.103
[    0.893392] ata_piix 0000:00:01.1: version 2.13
[    0.894443] scsi host0: ata_piix
[    0.894559] scsi host1: ata_piix
[    0.894597] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc120 irq 14
[    0.894598] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc128 irq 15
[    0.894679] libphy: Fixed MDIO Bus: probed
[    0.894889] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.894896] ehci-pci: EHCI PCI platform driver
[    0.917763] ehci-pci 0000:00:06.7: EHCI Host Controller
[    0.917914] ehci-pci 0000:00:06.7: new USB bus registered, assigned bus number 1
[    0.918102] ehci-pci 0000:00:06.7: irq 10, io mem 0xfc058000
[    0.923278] ehci-pci 0000:00:06.7: USB 2.0 started, EHCI 1.00
[    0.923325] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.923327] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.923329] usb usb1: Product: EHCI Host Controller
[    0.923330] usb usb1: Manufacturer: Linux 4.6.2 ehci_hcd
[    0.923331] usb usb1: SerialNumber: 0000:00:06.7
[    0.923535] hub 1-0:1.0: USB hub found
[    0.923541] hub 1-0:1.0: 6 ports detected
[    0.923731] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.923738] ohci-pci: OHCI PCI platform driver
[    0.923751] uhci_hcd: USB Universal Host Controller Interface driver
[    0.944602] uhci_hcd 0000:00:06.0: UHCI Host Controller
[    0.944735] uhci_hcd 0000:00:06.0: new USB bus registered, assigned bus number 2
[    0.944753] uhci_hcd 0000:00:06.0: detected 2 ports
[    0.944811] uhci_hcd 0000:00:06.0: irq 10, io base 0x0000c0a0
[    0.944894] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    0.944896] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.944897] usb usb2: Product: UHCI Host Controller
[    0.944898] usb usb2: Manufacturer: Linux 4.6.2 uhci_hcd
[    0.944899] usb usb2: SerialNumber: 0000:00:06.0
[    0.945067] hub 2-0:1.0: USB hub found
[    0.945072] hub 2-0:1.0: 2 ports detected
[    0.964965] uhci_hcd 0000:00:06.1: UHCI Host Controller
[    0.965089] uhci_hcd 0000:00:06.1: new USB bus registered, assigned bus number 3
[    0.965106] uhci_hcd 0000:00:06.1: detected 2 ports
[    0.965174] uhci_hcd 0000:00:06.1: irq 11, io base 0x0000c0c0
[    0.965235] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.965237] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.965238] usb usb3: Product: UHCI Host Controller
[    0.965239] usb usb3: Manufacturer: Linux 4.6.2 uhci_hcd
[    0.965240] usb usb3: SerialNumber: 0000:00:06.1
[    0.965391] hub 3-0:1.0: USB hub found
[    0.965395] hub 3-0:1.0: 2 ports detected
[    0.984289] uhci_hcd 0000:00:06.2: UHCI Host Controller
[    0.984413] uhci_hcd 0000:00:06.2: new USB bus registered, assigned bus number 4
[    0.984430] uhci_hcd 0000:00:06.2: detected 2 ports
[    0.984469] uhci_hcd 0000:00:06.2: irq 11, io base 0x0000c0e0
[    0.984531] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.984533] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.984534] usb usb4: Product: UHCI Host Controller
[    0.984535] usb usb4: Manufacturer: Linux 4.6.2 uhci_hcd
[    0.984536] usb usb4: SerialNumber: 0000:00:06.2
[    0.984666] hub 4-0:1.0: USB hub found
[    0.984671] hub 4-0:1.0: 2 ports detected
[    0.984817] usbcore: registered new interface driver usbserial
[    0.984823] usbcore: registered new interface driver usbserial_generic
[    0.984830] usbserial: USB Serial support registered for generic
[    0.984855] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.985486] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.985491] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.985628] mousedev: PS/2 mouse device common for all mice
[    0.985911] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    0.987199] rtc_cmos 00:00: RTC can wake from S4
[    0.987439] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    0.987528] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram
[    0.987577] device-mapper: uevent: version 1.0.3
[    0.987662] device-mapper: ioctl: 4.34.0-ioctl (2015-10-28) initialised: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
[    0.987793] hidraw: raw HID events driver (C) Jiri Kosina
[    0.987888] usbcore: registered new interface driver usbhid
[    0.987890] usbhid: USB HID core driver
[    0.987942] drop_monitor: Initializing network drop monitor service
[    0.988007] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.988048] Initializing XFRM netlink socket
[    0.988213] NET: Registered protocol family 10
[    0.988480] mip6: Mobile IPv6
[    0.988483] NET: Registered protocol family 17
[    0.988641] microcode: CPU0 sig=0x106a3, pf=0x1, revision=0x1
[    0.988651] microcode: CPU1 sig=0x106a3, pf=0x1, revision=0x1
[    0.988687] microcode: Microcode Update Driver: v2.01 <tigran-ppwZ4lME3+KI6QP4U9MhSdBc4/FLrbF6@public.gmane.org>, Peter Oruba
[    0.988849] registered taskstats version 1
[    0.988858] Loading compiled-in X.509 certificates
[    0.990129] alg: No test for pkcs1pad(rsa,sha256) (pkcs1pad(rsa-generic,sha256))
[    0.990795] Loaded X.509 cert 'Build time autogenerated kernel key: 85e6396634fa387f42956cf1cf28c26f4eedb0a5'
[    0.990830] zswap: loaded using pool lzo/zbud
[    0.991145]   Magic number: 4:406:58
[    0.991252] rtc_cmos 00:00: setting system clock to 2016-06-21 03:04:20 UTC (1466478260)
[    0.991297] PM: Hibernation image not present or could not be loaded.
[    1.046281] ata1.01: NODEV after polling detection
[    1.046610] ata1.00: ATAPI: QEMU DVD-ROM, 2.3.1, max UDMA/100
[    1.047176] ata1.00: configured for MWDMA2
[    1.048331] scsi 0:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     2.3. PQ: 0 ANSI: 5
[    1.064288] sr 0:0:0:0: [sr0] scsi3-mmc drive: 4x/4x cd/rw xa/form2 tray
[    1.064296] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.064639] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    1.064954] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    1.066438] Freeing unused kernel memory: 1560K (ffffffff81d38000 - ffffffff81ebe000)
[    1.066441] Write protecting the kernel read-only data: 12288k
[    1.067594] Freeing unused kernel memory: 820K (ffff880001733000 - ffff880001800000)
[    1.072507] Freeing unused kernel memory: 1084K (ffff880001af1000 - ffff880001c00000)
[    1.086084] systemd[1]: systemd 208 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    1.086163] systemd[1]: Detected virtualization 'kvm'.
[    1.086167] systemd[1]: Running in initial RAM disk.
[    1.086296] systemd[1]: Set hostname to <localhost.localdomain>.
[    1.087300] random: systemd urandom read with 3 bits of entropy available
[    1.093499] systemd[1]: Expecting device dev-disk-by\x2duuid-54e321d7\x2deb1c\x2d4c8c\x2d9f15\x2da383759ed99b.device...
[    1.093517] systemd[1]: Starting -.slice.
[    1.094042] systemd[1]: Created slice -.slice.
[    1.094054] systemd[1]: Starting System Slice.
[    1.094137] systemd[1]: Created slice System Slice.
[    1.094147] systemd[1]: Starting Slices.
[    1.094157] systemd[1]: Reached target Slices.
[    1.094166] systemd[1]: Starting Timers.
[    1.094175] systemd[1]: Reached target Timers.
[    1.094184] systemd[1]: Starting Journal Socket.
[    1.094286] systemd[1]: Listening on Journal Socket.
[    1.094508] systemd[1]: Starting dracut cmdline hook...
[    1.095211] systemd[1]: Started Load Kernel Modules.
[    1.095232] systemd[1]: Starting Journal Service...
[    1.095837] systemd[1]: Started Journal Service.
[    1.107558] systemd-journald[85]: Vacuuming done, freed 0 bytes
[    1.194826] systemd-udevd[149]: starting version 208
[    1.226654] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    1.301481] virtio-pci 0000:00:03.0: virtio_pci: leaving for legacy driver
[    1.321831] virtio-pci 0000:00:05.0: virtio_pci: leaving for legacy driver
[    1.342179] [drm] Initialized drm 1.1.0 20060810
[    1.345366] usb 1-1: New USB device found, idVendor=0627, idProduct=0001
[    1.345369] usb 1-1: New USB device strings: Mfr=1, Product=3, SerialNumber=5
[    1.345370] usb 1-1: Product: QEMU USB Tablet
[    1.345372] usb 1-1: Manufacturer: QEMU
[    1.345373] usb 1-1: SerialNumber: 42
[    1.349954] virtio-pci 0000:00:07.0: virtio_pci: leaving for legacy driver
[    1.367864] input: QEMU QEMU USB Tablet as /devices/pci0000:00/0000:00:06.7/usb1/1-1/1-1:1.0/0003:0627:0001.0001/input/input4
[    1.370470] virtio-pci 0000:00:08.0: virtio_pci: leaving for legacy driver
[    1.372275] hid-generic 0003:0627:0001.0001: input,hidraw0: USB HID v0.01 Pointer [QEMU QEMU USB Tablet] on usb-0000:00:06.7-1/input0
[    1.388068]  vda: vda1 vda2 < vda5 >
[    1.438981] [drm] Device Version 0.0
[    1.438984] [drm] Compression level 0 log level 0
[    1.438985] [drm] Currently using mode #0, list at 0x488
[    1.438986] [drm] 12286 io pages at offset 0x1000000
[    1.438988] [drm] 16777216 byte draw area at offset 0x0
[    1.438989] [drm] RAM header offset: 0x3ffe000
[    1.438990] [drm] rom modes offset 0x488 for 128 modes
[    1.439045] [TTM] Zone  kernel: Available graphics memory: 1025118 kiB
[    1.439047] [TTM] Initializing pool allocator
[    1.439053] [TTM] Initializing DMA pool allocator
[    1.439059] [drm] qxl: 16M of VRAM memory size
[    1.439060] [drm] qxl: 63M of IO pages memory ready (VRAM domain)
[    1.439061] [drm] qxl: 64M of Surface memory size
[    1.441673] [drm] main mem slot 1 [f4000000,3ffe000]
[    1.441675] [drm] surface mem slot 2 [f8000000,4000000]
[    1.442001] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    1.442002] [drm] No driver support for vblank timestamp query.
[    1.442348] [drm] fb mappable at 0xF4000000, size 3145728
[    1.442349] [drm] fb: depth 24, pitch 4096, width 1024, height 768
[    1.442449] fbcon: qxldrmfb (fb0) is primary device
[    1.452939] Console: switching to colour frame buffer device 128x48
[    1.457676] qxl 0000:00:02.0: fb0: qxldrmfb frame buffer device
[    1.462272] [drm] Initialized qxl 0.1.0 20120117 for 0000:00:02.0 on minor 0
[    1.789659] input: ImExPS/2 BYD TouchPad as /devices/platform/i8042/serio1/input/input3
[    1.791846] PM: Starting manual resume from disk
[    1.791852] PM: Hibernation image partition 252:5 present
[    1.791854] PM: Looking for hibernation image.
[    1.792098] PM: Image not found (code -22)
[    1.792100] PM: Hibernation image not present or could not be loaded.
[    1.807437] EXT4-fs (vda1): mounted filesystem with ordered data mode. Opts: (null)
[    1.825343] tsc: Refined TSC clocksource calibration: 3292.453 MHz
[    1.825349] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x2f75733a8eb, max_idle_ns: 440795268674 ns
[    1.923868] systemd-journald[85]: Received SIGTERM
[    1.993792] audit: type=1404 audit(1466478261.502:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[    2.009221] SELinux: 32768 avtab hash slots, 101316 rules.
[    2.023823] SELinux: 32768 avtab hash slots, 101316 rules.
[    2.042257] SELinux:  8 users, 83 roles, 4634 types, 265 bools, 1 sens, 1024 cats
[    2.042261] SELinux:  83 classes, 101316 rules
[    2.045533] SELinux:  Permission validate_trans in class security not defined in policy.
[    2.045589] SELinux:  Class netlink_iscsi_socket not defined in policy.
[    2.045591] SELinux:  Class netlink_fib_lookup_socket not defined in policy.
[    2.045592] SELinux:  Class netlink_connector_socket not defined in policy.
[    2.045593] SELinux:  Class netlink_netfilter_socket not defined in policy.
[    2.045597] SELinux:  Class netlink_generic_socket not defined in policy.
[    2.045598] SELinux:  Class netlink_scsitransport_socket not defined in policy.
[    2.045599] SELinux:  Class netlink_rdma_socket not defined in policy.
[    2.045599] SELinux:  Class netlink_crypto_socket not defined in policy.
[    2.045606] SELinux:  Permission audit_read in class capability2 not defined in policy.
[    2.045609] SELinux:  Class binder not defined in policy.
[    2.045609] SELinux: the above unknown classes and permissions will be allowed
[    2.045615] SELinux:  Completing initialization.
[    2.045615] SELinux:  Setting up existing superblocks.
[    2.054732] audit: type=1403 audit(1466478261.563:3): policy loaded auid=4294967295 ses=4294967295
[    2.061401] systemd[1]: Successfully loaded SELinux policy in 68.264ms.
[    2.102076] audit: type=1400 audit(1466478261.610:4): avc:  denied  { associate } for  pid=1 comm="systemd" name="/" dev="pstore" ino=1169 scontext=system_u:object_r:sysfs_t:s0 tcontext=system_u:object_r:pstorefs_t:s0 tclass=filesystem permissive=0
[    2.102496] systemd[1]: Unable to fix label of /sys/fs/pstore: Permission denied
[    2.119989] systemd[1]: Relabelled /dev and /run in 17.377ms.
[    2.437099] RPC: Registered named UNIX socket transport module.
[    2.437101] RPC: Registered udp transport module.
[    2.437102] RPC: Registered tcp transport module.
[    2.437103] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.470673] systemd-journald[289]: Vacuuming done, freed 0 bytes
[    2.625852] EXT4-fs (vda1): re-mounted. Opts: (null)
[    2.705103] systemd-udevd[303]: starting version 208
[    2.706629] Installing knfsd (copyright (C) 1996 okir-pn4DOG8n3UYbFoVRYvo4fw@public.gmane.org).
[    2.726854] audit: type=1305 audit(1466478262.235:5): audit_pid=318 old=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:auditd_t:s0 res=1
[    2.739372] systemd-journald[289]: Received request to flush runtime journal from PID 1
[    2.920580] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0x700, revision 0
[    3.596846] systemd-journald[289]: Received request to flush runtime journal from PID 1
[    4.000143] Adding 2094076k swap on /dev/vda5.  Priority:-1 extents:1 across:2094076k FS
[    4.462822] snd_hda_codec_generic hdaudioC0D0: autoconfig for Generic: line_outs=1 (0x3/0x0/0x0/0x0/0x0) type:line
[    4.462826] snd_hda_codec_generic hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    4.462828] snd_hda_codec_generic hdaudioC0D0:    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    4.462830] snd_hda_codec_generic hdaudioC0D0:    mono: mono_out=0x0
[    4.462831] snd_hda_codec_generic hdaudioC0D0:    inputs:
[    4.462833] snd_hda_codec_generic hdaudioC0D0:      Line=0x5
[    5.065130] Bluetooth: Core ver 2.21
[    5.065217] NET: Registered protocol family 31
[    5.065218] Bluetooth: HCI device and connection manager initialized
[    5.065222] Bluetooth: HCI socket layer initialized
[    5.065224] Bluetooth: L2CAP socket layer initialized
[    5.065231] Bluetooth: SCO socket layer initialized
[    5.213909] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    5.213912] Bluetooth: BNEP filters: protocol multicast
[    5.213916] Bluetooth: BNEP socket layer initialized
[    5.993537] Ebtables v2.0 registered
[    6.018978] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   35.194257] random: nonblocking pool is initialized


# cat /proc/cgroups 
#subsys_name	hierarchy	num_cgroups	enabled
cpuset	2	1	1
cpu	3	1	1
cpuacct	3	1	1
blkio	4	1	1
memory	5	1	1
devices	6	1	1
freezer	7	1	1
net_cls	8	1	1
perf_event	9	1	1
hugetlb	10	1	1


> 
> Thanks.
> 


-- 
Ma Shimiao
Development Dept.I
Nanjing Fujitsu Nanda Software Tech. Co., Ltd.(FNST)

