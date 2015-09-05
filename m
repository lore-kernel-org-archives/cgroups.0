From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: __blkg_lookup oops with 4.2-rcX
Date: Sat, 5 Sep 2015 16:34:39 +0100
Message-ID: <20150905153439.GA18461@redhat.com>
References: <CA+5PVA5rzQ0s4723n5rHBcxQa9t0cW8BPPBekr_9aMRoWt2aYg@mail.gmail.com>
 <20150902145307.GG22326@mtj.duckdns.org>
 <20150902153255.GH22326@mtj.duckdns.org>
 <20150904104602.GN29283@redhat.com>
 <20150904171302.GE25329@mtj.duckdns.org>
 <20150904204244.GQ29283@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="/9DWx/yDrRhgMJTb"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150904204244.GQ29283@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Jeff Moyer <jmoyer@redhat.com>, msnitzer@redhat.com, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 04, 2015 at 09:42:44PM +0100, Richard W.M. Jones wrote:
> On Fri, Sep 04, 2015 at 01:13:02PM -0400, Tejun Heo wrote:
> > The only struct which is large enough for 0xbb8 offset is
> > request_queue.  Hmm.... can you please try the brute force debug patch
> > below and report the kernel log after the crash?
> 
> So the good(?) news is this bug is not reproducible with the Fedora
> kernel 4.3.0-0.rc0.git7.1.fc24.x86_64 (tested both with and without
> your patch).
> 
> I'll keep it running overnight just in case ..

In fact the bug does happen with 4.3.0-0.rc0.git7.1.fc24.x86_64, but
it's a bit rarer than before.

I'm now using your patch, and the output from the patch is attached.
I hope that helps - let me know if there's anything else you'd want me
to try.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-p2v converts physical machines to virtual machines.  Boot with a
live CD or over the network (PXE) and turn machines into KVM guests.
http://libguestfs.org/virt-v2v

--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=log
Content-Transfer-Encoding: quoted-printable

libguestfs: trace: disk_create "test1.img" "raw" 524288000
libguestfs: trace: disk_create =3D 0
libguestfs: trace: add_drive "test1.img" "format:raw" "cachemode:unsafe"
libguestfs: trace: add_drive =3D 0
libguestfs: trace: launch
libguestfs: trace: get_tmpdir
libguestfs: trace: get_tmpdir =3D "/tmp"
libguestfs: trace: version
libguestfs: trace: version =3D <struct guestfs_version *>
libguestfs: trace: get_backend
libguestfs: trace: get_backend =3D "libvirt"
libguestfs: launch: program=3Dguestfish
libguestfs: launch: version=3D1.31.3fedora=3D24,release=3D1.fc24,libvirt
libguestfs: launch: backend registered: unix
libguestfs: launch: backend registered: uml
libguestfs: launch: backend registered: libvirt
libguestfs: launch: backend registered: direct
libguestfs: launch: backend=3Dlibvirt
libguestfs: launch: tmpdir=3D/tmp/libguestfsXVD2Sq
libguestfs: launch: umask=3D0002
libguestfs: launch: euid=3D1000
libguestfs: libvirt version =3D 1002019 (1.2.19)
libguestfs: guest random name =3D guestfs-dnsycku3ayrd2wns
libguestfs: [00000ms] connect to libvirt
libguestfs: opening libvirt handle: URI =3D qemu:///session, auth =3D defau=
lt+wrapper, flags =3D 0
libguestfs: successfully opened libvirt handle: conn =3D 0x5637883f0fc0
libguestfs: qemu version (reported by libvirt) =3D 2004000 (2.4.0)
libguestfs: [00003ms] get libvirt capabilities
libguestfs: [00851ms] parsing capabilities XML
libguestfs: trace: get_backend_setting "force_tcg"
libguestfs: trace: get_backend_setting =3D NULL (error)
libguestfs: trace: get_backend_setting "internal_libvirt_label"
libguestfs: trace: get_backend_setting =3D NULL (error)
libguestfs: trace: get_backend_setting "internal_libvirt_imagelabel"
libguestfs: trace: get_backend_setting =3D NULL (error)
libguestfs: trace: get_backend_setting "internal_libvirt_norelabel_disks"
libguestfs: trace: get_backend_setting =3D NULL (error)
libguestfs: [00853ms] build appliance
libguestfs: trace: get_cachedir
libguestfs: trace: get_cachedir =3D "/var/tmp"
libguestfs: [00853ms] begin building supermin appliance
libguestfs: [00853ms] run supermin
libguestfs: command: run: /usr/bin/supermin
libguestfs: command: run: \ --build
libguestfs: command: run: \ --verbose
libguestfs: command: run: \ --if-newer
libguestfs: command: run: \ --lock /var/tmp/.guestfs-1000/lock
libguestfs: command: run: \ --copy-kernel
libguestfs: command: run: \ -f ext2
libguestfs: command: run: \ --host-cpu x86_64
libguestfs: command: run: \ /usr/lib64/guestfs/supermin.d
libguestfs: command: run: \ -o /var/tmp/.guestfs-1000/appliance.d
supermin: version: 5.1.13
supermin: rpm: detected RPM version 4.13
supermin: package handler: fedora/rpm
supermin: acquiring lock on /var/tmp/.guestfs-1000/lock
supermin: if-newer: output does not need rebuilding
libguestfs: [00886ms] finished building supermin appliance
libguestfs: trace: disk_create "/tmp/libguestfsXVD2Sq/overlay1" "qcow2" -1 =
"backingfile:/var/tmp/.guestfs-1000/appliance.d/root" "backingformat:raw"
libguestfs: command: run: qemu-img
libguestfs: command: run: \ create
libguestfs: command: run: \ -f qcow2
libguestfs: command: run: \ -o backing_file=3D/var/tmp/.guestfs-1000/applia=
nce.d/root,backing_fmt=3Draw
libguestfs: command: run: \ /tmp/libguestfsXVD2Sq/overlay1
Formatting '/tmp/libguestfsXVD2Sq/overlay1', fmt=3Dqcow2 size=3D4294967296 =
backing_file=3D'/var/tmp/.guestfs-1000/appliance.d/root' backing_fmt=3D'raw=
' encryption=3Doff cluster_size=3D65536 lazy_refcounts=3Doff refcount_bits=
=3D16
libguestfs: trace: disk_create =3D 0
libguestfs: [01025ms] create libvirt XML
libguestfs: command: run: dmesg | grep -Eoh 'lpj=3D[[:digit:]]+'
libguestfs: read_lpj_from_dmesg: calculated lpj=3D3515548
libguestfs: trace: get_cachedir
libguestfs: trace: get_cachedir =3D "/var/tmp"
libguestfs: libvirt XML:\n<?xml version=3D"1.0"?>\n<domain type=3D"qemu" xm=
lns:qemu=3D"http://libvirt.org/schemas/domain/qemu/1.0">\n  <name>guestfs-d=
nsycku3ayrd2wns</name>\n  <memory unit=3D"MiB">500</memory>\n  <currentMemo=
ry unit=3D"MiB">500</currentMemory>\n  <vcpu>1</vcpu>\n  <clock offset=3D"u=
tc">\n    <timer name=3D"rtc" tickpolicy=3D"catchup"/>\n    <timer name=3D"=
pit" tickpolicy=3D"delay"/>\n    <timer name=3D"hpet" present=3D"no"/>\n  <=
/clock>\n  <os>\n    <type>hvm</type>\n    <kernel>/var/tmp/.guestfs-1000/a=
ppliance.d/kernel</kernel>\n    <initrd>/var/tmp/.guestfs-1000/appliance.d/=
initrd</initrd>\n    <cmdline>panic=3D1 console=3DttyS0 udevtimeout=3D6000 =
udev.event-timeout=3D6000 no_timer_check lpj=3D3515548 acpi=3Doff printk.ti=
me=3D1 cgroup_disable=3Dmemory root=3D/dev/sdb selinux=3D0 guestfs_verbose=
=3D1 TERM=3Dxterm-256color</cmdline>\n    <bios useserial=3D"yes"/>\n  </os=
>\n  <on_reboot>destroy</on_reboot>\n  <devices>\n    <controller type=3D"s=
csi" index=3D"0" model=3D"virtio-scsi"/>\n    <disk device=3D"disk" type=3D=
"file">\n      <source file=3D"/tmp/test1.img"/>\n      <target dev=3D"sda"=
 bus=3D"scsi"/>\n      <driver name=3D"qemu" type=3D"raw" cache=3D"unsafe"/=
>\n      <address type=3D"drive" controller=3D"0" bus=3D"0" target=3D"0" un=
it=3D"0"/>\n    </disk>\n    <disk type=3D"file" device=3D"disk">\n      <s=
ource file=3D"/tmp/libguestfsXVD2Sq/overlay1"/>\n      <target dev=3D"sdb" =
bus=3D"scsi"/>\n      <driver name=3D"qemu" type=3D"qcow2" cache=3D"unsafe"=
/>\n      <address type=3D"drive" controller=3D"0" bus=3D"0" target=3D"1" u=
nit=3D"0"/>\n      <shareable/>\n    </disk>\n    <serial type=3D"unix">\n =
     <source mode=3D"connect" path=3D"/tmp/libguestfsXVD2Sq/console.sock"/>=
\n      <target port=3D"0"/>\n    </serial>\n    <channel type=3D"unix">\n =
     <source mode=3D"connect" path=3D"/tmp/libguestfsXVD2Sq/guestfsd.sock"/=
>\n      <target type=3D"virtio" name=3D"org.libguestfs.channel.0"/>\n    <=
/channel>\n  </devices>\n  <qemu:commandline>\n    <qemu:env name=3D"TMPDIR=
" value=3D"/var/tmp"/>\n  </qemu:commandline>\n</domain>\n
libguestfs: trace: get_cachedir
libguestfs: trace: get_cachedir =3D "/var/tmp"
libguestfs: command: run: ls
libguestfs: command: run: \ -a
libguestfs: command: run: \ -l
libguestfs: command: run: \ -R
libguestfs: command: run: \ -Z /var/tmp/.guestfs-1000
libguestfs: /var/tmp/.guestfs-1000:
libguestfs: total 4
libguestfs: drwxr-xr-x. 3 rjones rjones unconfined_u:object_r:user_tmp_t:s0=
   35 Sep  4 18:30 .
libguestfs: drwxrwxrwt. 5 root   root   system_u:object_r:tmp_t:s0         =
 4096 Sep  4 16:29 ..
libguestfs: drwxr-xr-x. 2 rjones rjones unconfined_u:object_r:user_tmp_t:s0=
   43 Sep  4 16:30 appliance.d
libguestfs: -rw-r--r--. 1 rjones rjones unconfined_u:object_r:user_tmp_t:s0=
    0 Sep  4 12:41 lock
libguestfs:=20
libguestfs: /var/tmp/.guestfs-1000/appliance.d:
libguestfs: total 341868
libguestfs: drwxr-xr-x. 2 rjones rjones unconfined_u:object_r:user_tmp_t:s0=
         43 Sep  4 16:30 .
libguestfs: drwxr-xr-x. 3 rjones rjones unconfined_u:object_r:user_tmp_t:s0=
         35 Sep  4 18:30 ..
libguestfs: -rw-r--r--. 1 rjones rjones system_u:object_r:virt_content_t:s0=
    1479168 Sep  4 18:30 initrd
libguestfs: -rwxr-xr-x. 1 rjones rjones system_u:object_r:virt_content_t:s0=
    6555504 Sep  4 18:30 kernel
libguestfs: -rw-r--r--. 1 rjones rjones system_u:object_r:virt_content_t:s0=
 4294967296 Sep  4 18:30 root
libguestfs: command: run: ls
libguestfs: command: run: \ -a
libguestfs: command: run: \ -l
libguestfs: command: run: \ -Z /tmp/libguestfsXVD2Sq
libguestfs: total 200
libguestfs: drwxr-xr-x.  2 rjones rjones unconfined_u:object_r:user_tmp_t:s=
0     78 Sep  4 18:30 .
libguestfs: drwxrwxrwt. 16 root   root   system_u:object_r:tmp_t:s0        =
    4096 Sep  4 18:30 ..
libguestfs: srwxrwxr-x.  1 rjones rjones unconfined_u:object_r:user_tmp_t:s=
0      0 Sep  4 18:30 console.sock
libguestfs: srwxrwxr-x.  1 rjones rjones unconfined_u:object_r:user_tmp_t:s=
0      0 Sep  4 18:30 guestfsd.sock
libguestfs: -rw-r--r--.  1 rjones rjones unconfined_u:object_r:user_tmp_t:s=
0 197120 Sep  4 18:30 overlay1
libguestfs: -rwxrwxr-x.  1 rjones rjones unconfined_u:object_r:user_tmp_t:s=
0      0 Sep  4 18:30 umask-check
libguestfs: [01074ms] launch libvirt guest
\x1b[1;256r\x1b[256;256H\x1b[6n=0D
Google, Inc.=0D
Serial Graphics Adapter 06/19/15=0D
SGABIOS $Id: sgabios.S 8 2010-04-22 00:03:40Z nlaredo $ (mockbuild@) Fri Ju=
n 19 00:52:18 UTC 2015=0D
Term: 80x24=0D
4 0=0D
\x1b[2J=0DSeaBIOS (version 1.8.2-20150714_191134-)=0D=0D
=0DMachine UUID 16f3a5e3-8bda-4248-9d94-bf0cfdc13f0c=0D=0D
=0DBooting from ROM...=0D=0D
=0DProbing EDD (edd=3Doff to disable)... ok=0D=0D
\x1b[2J[    0.000000] Initializing cgroup subsys cpuset=0D
[    0.000000] Initializing cgroup subsys cpu=0D
[    0.000000] Initializing cgroup subsys cpuacct=0D
[    0.000000] Linux version 4.3.0-0.rc0.git7.1.rwmj3.fc24.x86_64 (mockbuil=
d@buildvm-10.phx2.fedoraproject.org) (gcc version 5.1.1 20150618 (Red Hat 5=
=2E1.1-4) (GCC) ) #1 SMP Fri Sep 4 18:30:37 UTC 2015=0D
[    0.000000] Command line: panic=3D1 console=3DttyS0 udevtimeout=3D6000 u=
dev.event-timeout=3D6000 no_timer_check lpj=3D3515548 acpi=3Doff printk.tim=
e=3D1 cgroup_disable=3Dmemory root=3D/dev/sdb selinux=3D0 guestfs_verbose=
=3D1 TERM=3Dxterm-256color=0D
[    0.000000] x86/fpu: Legacy x87 FPU detected.=0D
[    0.000000] x86/fpu: Using 'lazy' FPU context switches.=0D
[    0.000000] e820: BIOS-provided physical RAM map:=0D
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f7ff] usabl=
e=0D
[    0.000000] BIOS-e820: [mem 0x000000000009f800-0x000000000009ffff] reser=
ved=0D
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved=0D
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001f3fffff] usabl=
e=0D
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved=0D
[    0.000000] NX (Execute Disable) protection: active=0D
[    0.000000] SMBIOS 2.8 present.=0D
[    0.000000] e820: last_pfn =3D 0x1f400 max_arch_pfn =3D 0x400000000=0D
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT=
  =0D
[    0.000000] found SMP MP-table at [mem 0x000f64d0-0x000f64df] mapped at =
[ffff8800000f64d0]=0D
[    0.000000] Scanning 1 areas for low memory corruption=0D
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]=0D
[    0.000000] init_memory_mapping: [mem 0x1f000000-0x1f1fffff]=0D
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1effffff]=0D
[    0.000000] init_memory_mapping: [mem 0x1f200000-0x1f3fffff]=0D
[    0.000000] RAMDISK: [mem 0x1f296000-0x1f3fffff]=0D
[    0.000000] No NUMA configuration found=0D
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000001f3fffff]=
=0D
[    0.000000] NODE_DATA(0) allocated [mem 0x1f26f000-0x1f295fff]=0D
[    0.000000] Zone ranges:=0D
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]=0D
[    0.000000]   DMA32    [mem 0x0000000001000000-0x000000001f3fffff]=0D
[    0.000000]   Normal   empty=0D
[    0.000000] Movable zone start for each node=0D
[    0.000000] Early memory node ranges=0D
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009efff]=0D
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000001f3fffff]=0D
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000001f3ff=
fff]=0D
[    0.000000] SFI: Simple Firmware Interface v0.81 http://simplefirmware.o=
rg=0D
[    0.000000] Intel MultiProcessor Specification v1.4=0D
[    0.000000] MPTABLE: OEM ID: BOCHSCPU=0D
[    0.000000] MPTABLE: Product ID: 0.1         =0D
[    0.000000] MPTABLE: APIC at: 0xFEE00000=0D
[    0.000000] Processor #0 (Bootup-CPU)=0D
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23=0D
[    0.000000] Processors: 1=0D
[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs=0D
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]=0D
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]=0D
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]=0D
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]=0D
[    0.000000] e820: [mem 0x1f400000-0xfffbffff] available for PCI devices=
=0D
[    0.000000] Booting paravirtualized kernel on bare hardware=0D
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0=
xffffffff, max_idle_ns: 1910969940391419 ns=0D
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:1 nr_cpu_ids:1 nr=
_node_ids:1=0D
[    0.000000] PERCPU: Embedded 483 pages/cpu @ffff88001ec00000 s1937688 r8=
192 d32488 u2097152=0D
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 125881=0D
[    0.000000] Policy zone: DMA32=0D
[    0.000000] Kernel command line: panic=3D1 console=3DttyS0 udevtimeout=
=3D6000 udev.event-timeout=3D6000 no_timer_check lpj=3D3515548 acpi=3Doff p=
rintk.time=3D1 cgroup_disable=3Dmemory root=3D/dev/sdb selinux=3D0 guestfs_=
verbose=3D1 TERM=3Dxterm-256color=0D
[    0.000000] Disabling memory control group subsystem=0D
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)=0D
[    0.000000] Memory: 461640K/511608K available (8539K kernel code, 1754K =
rwdata, 3624K rodata, 3756K init, 17496K bss, 49968K reserved, 0K cma-reser=
ved)=0D
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1=0D
[    0.000000] Running RCU self tests=0D
[    0.000000] Hierarchical RCU implementation.=0D
[    0.000000] \tRCU lockdep checking is enabled.=0D
[    0.000000] \tBuild-time adjustment of leaf fanout to 64.=0D
[    0.000000] \tRCU restricting CPUs from NR_CPUS=3D8192 to nr_cpu_ids=3D1=
=2E=0D
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D64, nr_cpu_ids=
=3D1=0D
[    0.000000] kmemleak: Kernel memory leak detector disabled=0D
[    0.000000] NR_IRQS:524544 nr_irqs:256 16=0D
[    0.000000] \tOffload RCU callbacks from all CPUs=0D
[    0.000000] \tOffload RCU callbacks from CPUs: 0.=0D
[    0.000000] Console: colour *CGA 80x25=0D
[    0.000000] console [ttyS0] enabled=0D
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar=0D
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8=0D
[    0.000000] ... MAX_LOCK_DEPTH:          48=0D
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191=0D
[    0.000000] ... CLASSHASH_SIZE:          4096=0D
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768=0D
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536=0D
[    0.000000] ... CHAINHASH_SIZE:          32768=0D
[    0.000000]  memory used by lock dependency info: 8671 kB=0D
[    0.000000]  per task-struct memory footprint: 2688 bytes=0D
[    0.000000] tsc: Unable to calibrate against PIT=0D
[    0.000000] tsc: No reference (HPET/PMTIMER) available=0D
[    0.000000] tsc: Marking TSC unstable due to could not calculate TSC khz=
=0D
[    0.010000] Calibrating delay loop (skipped) preset value.. 7031.09 Bogo=
MIPS (lpj=3D3515548)=0D
[    0.011000] pid_max: default: 32768 minimum: 301=0D
[    0.016000] Security Framework initialized=0D
[    0.016000] SELinux:  Disabled at boot.=0D
[    0.017000] Yama: becoming mindful.=0D
[    0.027000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)=0D
[    0.032000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)=0D
[    0.034000] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)=
=0D
[    0.035000] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)=0D
[    0.071000] Initializing cgroup subsys blkio=0D
[    0.073000] Initializing cgroup subsys memory=0D
[    0.074000] Initializing cgroup subsys devices=0D
[    0.075000] Initializing cgroup subsys freezer=0D
[    0.076000] Initializing cgroup subsys net_cls=0D
[    0.077000] Initializing cgroup subsys perf_event=0D
[    0.078000] Initializing cgroup subsys net_prio=0D
[    0.078000] Initializing cgroup subsys hugetlb=0D
[    0.079000] Initializing cgroup subsys pids=0D
[    0.083000] mce: CPU supports 10 MCE banks=0D
[    0.086000] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0=0D
[    0.087000] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0=0D
[    0.536000] Freeing SMP alternatives memory: 28K (ffffffff82363000 - fff=
fffff8236a000)=0D
[    0.553000] ftrace: allocating 29110 entries in 114 pages=0D
[    0.680000] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1=0D
[    0.782000] smpboot: CPU0: AMD QEMU Virtual CPU version 2.4.0 (fam: 06, =
model: 06, stepping: 03)=0D
[    0.787000] Performance Events: Broken PMU hardware detected, using soft=
ware events only.=0D
[    0.790000] Failed to access perfctr msr (MSR c0010007 is 0)=0D
[    0.832000] x86: Booted up 1 node, 1 CPUs=0D
[    0.832000] smpboot: Total of 1 processors activated (7031.09 BogoMIPS)=
=0D
[    0.835000] NMI watchdog: disabled (cpu0): hardware events not enabled=0D
[    0.836000] NMI watchdog: Shutting down hard lockup detector on all cpus=
=0D
[    0.880000] devtmpfs: initialized=0D
[    0.937000] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xfffffff=
f, max_idle_ns: 1911260446275000 ns=0D
[    0.945000] atomic64_test: passed for x86-64 platform with CX8 and with =
SSE=0D
[    0.946000] pinctrl core: initialized pinctrl subsystem=0D
[    0.953000] RTC time: 22:30:33, date: 09/04/15=0D
[    0.975000] NET: Registered protocol family 16=0D
[    0.996000] cpuidle: using governor menu=0D
[    1.007000] PCI: Using configuration type 1 for base access=0D
[    1.193000] ACPI: Interpreter disabled.=0D
[    1.209000] vgaarb: loaded=0D
[    1.217000] SCSI subsystem initialized=0D
[    1.225000] usbcore: registered new interface driver usbfs=0D
[    1.227000] usbcore: registered new interface driver hub=0D
[    1.228000] usbcore: registered new device driver usb=0D
[    1.237000] PCI: Probing PCI hardware=0D
[    1.242000] PCI host bridge to bus 0000:00=0D
[    1.243000] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]=0D
[    1.244000] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffff=
fff]=0D
[    1.245000] pci_bus 0000:00: No busn resource found for root bus, will u=
se [bus 00-ff]=0D
[    1.271000] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]=0D
[    1.272000] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]=0D
[    1.274000] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]=0D
[    1.275000] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]=0D
[    1.368000] pci 0000:00:01.0: PIIX/ICH IRQ router [8086:7000]=0D
[    1.397000] NetLabel: Initializing=0D
[    1.398000] NetLabel:  domain hash size =3D 128=0D
[    1.398000] NetLabel:  protocols =3D UNLABELED CIPSOv4=0D
[    1.401000] NetLabel:  unlabeled traffic allowed by default=0D
[    1.406000] clocksource: Switched to clocksource refined-jiffies=0D
[    2.360854] pnp: PnP ACPI: disabled=0D
[    2.535828] NET: Registered protocol family 2=0D
[    2.561824] TCP established hash table entries: 4096 (order: 3, 32768 by=
tes)=0D
[    2.564823] TCP bind hash table entries: 4096 (order: 6, 327680 bytes)=0D
[    2.568823] TCP: Hash tables configured (established 4096 bind 4096)=0D
[    2.570823] UDP hash table entries: 256 (order: 3, 49152 bytes)=0D
[    2.572822] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)=0D
[    2.578821] NET: Registered protocol family 1=0D
[    2.579821] pci 0000:00:00.0: Limiting direct PCI/PCI transfers=0D
[    2.580821] pci 0000:00:01.0: PIIX3: Enabling Passive Release=0D
[    2.581821] pci 0000:00:01.0: Activating ISA DMA hang workarounds=0D
[    2.600818] Unpacking initramfs...=0D
[    2.741797] Freeing initrd memory: 1448K (ffff88001f296000 - ffff88001f4=
00000)=0D
[    3.081745] DMA-API: preallocated 65536 debug entries=0D
[    3.082745] DMA-API: debugging enabled by kernel config=0D
[    3.086744] platform rtc_cmos: registered platform RTC device (no PNP de=
vice found)=0D
[    3.088744] microcode: AMD CPU family 0x6 not supported=0D
[    3.111740] Scanning for low memory corruption every 60 seconds=0D
[    3.142736] cryptomgr_test (28) used greatest stack depth: 14232 bytes l=
eft=0D
[    3.163732] futex hash table entries: 256 (order: 3, 32768 bytes)=0D
[    3.164732] Initialise system trusted keyring=0D
[    3.168732] audit: initializing netlink subsys (disabled)=0D
[    3.172731] audit: type=3D2000 audit(1441405835.171:1): initialized=0D
[    3.199727] HugeTLB registered 2 MB page size, pre-allocated 0 pages=0D
[    3.467686] zpool: loaded=0D
[    3.467686] zbud: loaded=0D
[    3.481684] VFS: Disk quotas dquot_6.6.0=0D
[    3.485683] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 byte=
s)=0D
[    3.545674] Key type big_key registered=0D
[    3.567671] cryptomgr_test (35) used greatest stack depth: 13672 bytes l=
eft=0D
[    3.700651] cryptomgr_test (53) used greatest stack depth: 13240 bytes l=
eft=0D
[    3.743644] NET: Registered protocol family 38=0D
[    3.747644] Key type asymmetric registered=0D
[    3.748643] Asymmetric key parser 'x509' registered=0D
[    3.750643] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)=0D
[    3.753643] io scheduler noop registered=0D
[    3.754643] io scheduler deadline registered=0D
[    3.759642] io scheduler cfq registered (default)=0D
[    3.785638] pci_hotplug: PCI Hot Plug PCI Core version: 0.5=0D
[    3.787638] pciehp: PCI Express Hot Plug Controller Driver version: 0.4=
=0D
[    3.802635] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled=0D
[    3.810634] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115=
200) is a 16550A=0D
[    3.869625] Non-volatile memory driver v1.3=0D
[    3.872625] Linux agpgart interface v0.103=0D
[    3.948613] scsi host0: ata_piix=0D
[    3.959611] scsi host1: ata_piix=0D
[    3.964611] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc0a0 irq 1=
4=0D
[    3.965610] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc0a8 irq 1=
5=0D
[    3.988607] libphy: Fixed MDIO Bus: probed=0D
[    3.995606] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver=0D
[    3.996606] ehci-pci: EHCI PCI platform driver=0D
[    3.997606] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver=0D
[    3.998605] ohci-pci: OHCI PCI platform driver=0D
[    4.000605] uhci_hcd: USB Universal Host Controller Interface driver=0D
[    4.002605] uhci_hcd 0000:00:01.2: PCI->APIC IRQ transform: INT D -> IRQ=
 11=0D
[    4.009604] uhci_hcd 0000:00:01.2: UHCI Host Controller=0D
[    4.025601] uhci_hcd 0000:00:01.2: new USB bus registered, assigned bus =
number 1=0D
[    4.028601] uhci_hcd 0000:00:01.2: detected 2 ports=0D
[    4.030601] uhci_hcd 0000:00:01.2: irq 11, io base 0x0000c040=0D
[    4.044599] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001=0D
[    4.045598] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1=0D
[    4.046598] usb usb1: Product: UHCI Host Controller=0D
[    4.046598] usb usb1: Manufacturer: Linux 4.3.0-0.rc0.git7.1.rwmj3.fc24.=
x86_64 uhci_hcd=0D
[    4.047598] usb usb1: SerialNumber: 0000:00:01.2=0D
[    4.072594] hub 1-0:1.0: USB hub found=0D
[    4.074594] hub 1-0:1.0: 2 ports detected=0D
[    4.101590] usbcore: registered new interface driver usbserial=0D
[    4.103590] usbcore: registered new interface driver usbserial_generic=0D
[    4.106589] usbserial: USB Serial support registered for generic=0D
[    4.109589] i8042: PNP: No PS/2 controller found. Probing ports directly=
=2E=0D
[    4.119587] serio: i8042 KBD port at 0x60,0x64 irq 1=0D
[    4.121587] serio: i8042 AUX port at 0x60,0x64 irq 12=0D
[    4.143583] mousedev: PS/2 mouse device common for all mice=0D
[    4.165580] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0=0D
[    4.166580] rtc_cmos rtc_cmos: alarms up to one day, 114 bytes nvram=0D
[    4.180578] device-mapper: uevent: version 1.0.3=0D
[    4.202575] device-mapper: ioctl: 4.33.0-ioctl (2015-8-18) initialised: =
dm-devel@redhat.com=0D
[    4.221572] hidraw: raw HID events driver (C) Jiri Kosina=0D
[    4.225571] usbcore: registered new interface driver usbhid=0D
[    4.226571] usbhid: USB HID core driver=0D
[    4.229570] drop_monitor: Initializing network drop monitor service=0D
[    4.234570] ip_tables: (C) 2000-2006 Netfilter Core Team=0D
[    4.241569] Initializing XFRM netlink socket=0D
[    4.256566] NET: Registered protocol family 10=0D
[    4.284562] mip6: Mobile IPv6=0D
[    4.285562] NET: Registered protocol family 17=0D
[    4.307559] Loading compiled-in X.509 certificates=0D
[    4.323556] Loaded X.509 cert 'Fedora kernel signing key: 8367135ad153d1=
3c8bd36adc755c51a3bc5940e6'=0D
[    4.326556] registered taskstats version 1=0D
[    4.329555] zswap: loading zswap=0D
[    4.330555] zswap: using zbud pool=0D
[    4.331555] zswap: using lzo compressor=0D
[    4.361550]   Magic number: 15:131:552=0D
[    4.363550] rtc_cmos rtc_cmos: setting system clock to 2015-09-04 22:30:=
37 UTC (1441405837)=0D
[    4.468534] Freeing unused kernel memory: 3756K (ffffffff81fb8000 - ffff=
ffff82363000)=0D
[    4.469534] Write protecting the kernel read-only data: 14336k=0D
[    4.499529] Freeing unused kernel memory: 1688K (ffff88000185a000 - ffff=
880001a00000)=0D
[    4.506528] Freeing unused kernel memory: 472K (ffff880001d8a000 - ffff8=
80001e00000)=0D
supermin: mounting /proc=0D
supermin: uptime: 4.60 0.66=0D
supermin: ext2 mini initrd starting up: 5.1.13 zlib xz=0D
supermin: cmdline: panic=3D1 console=3DttyS0 udevtimeout=3D6000 udev.event-=
timeout=3D6000 no_timer_check lpj=3D3515548 acpi=3Doff printk.time=3D1 cgro=
up_disable=3Dmemory root=3D/dev/sdb selinux=3D0 guestfs_verbose=3D1 TERM=3D=
xterm-256color=0D
supermin: mounting /sys=0D
supermin: internal insmod crc32-pclmul.ko.xz=0D
supermin: running xz=0D
done with xz 8423 read=0D
[    4.730494] PCLMULQDQ-NI instructions are not detected.=0D
insmod: init_module: crc32-pclmul.ko.xz: No such device=0D
supermin: internal insmod crc32c-intel.ko.xz=0D
supermin: running xz=0D
done with xz 19951 read=0D
insmod: init_module: crc32c-intel.ko.xz: No such device=0D
supermin: internal insmod crct10dif-pclmul.ko.xz=0D
supermin: running xz=0D
done with xz 10967 read=0D
insmod: init_module: crct10dif-pclmul.ko.xz: No such device=0D
supermin: internal insmod crc32.ko.xz=0D
supermin: running xz=0D
done with xz 6239 read=0D
supermin: internal insmod virtio.ko.xz=0D
supermin: running xz=0D
done with xz 15215 read=0D
supermin: internal insmod virtio_ring.ko.xz=0D
supermin: running xz=0D
done with xz 19823 read=0D
supermin: internal insmod virtio_blk.ko.xz=0D
supermin: running xz=0D
done with xz 23855 read=0D
supermin: internal insmod virtio-rng.ko.xz=0D
supermin: running xz=0D
done with xz 8959 read=0D
supermin: internal insmod virtio_console.ko.xz=0D
supermin: running xz=0D
done with xz 45711 read=0D
supermin: internal insmod drm.ko.xz=0D
supermin: running xz=0D
[    5.140432] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input1=0D
[    5.184425] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input2=0D
done with xz 543831 read=0D
[    5.327404] [drm] Initialized drm 1.1.0 20060810=0D
supermin: internal insmod drm_kms_helper.ko.xz=0D
supermin: running xz=0D
done with xz 171975 read=0D
supermin: internal insmod ttm.ko.xz=0D
supermin: running xz=0D
done with xz 144199 read=0D
supermin: internal insmod virtio-gpu.ko.xz=0D
supermin: running xz=0D
done with xz 66719 read=0D
supermin: internal insmod ideapad_slidebar.ko.xz=0D
supermin: running xz=0D
done with xz 13359 read=0D
[    5.607361] ideapad_slidebar: DMI does not match=0D
insmod: init_module: ideapad_slidebar.ko.xz: No such device=0D
supermin: internal insmod virtio_net.ko.xz=0D
supermin: running xz=0D
done with xz 48831 read=0D
supermin: internal insmod video.ko.xz=0D
supermin: running xz=0D
done with xz 50159 read=0D
supermin: internal insmod sparse-keymap.ko.xz=0D
supermin: running xz=0D
done with xz 8887 read=0D
supermin: internal insmod rfkill.ko.xz=0D
supermin: running xz=0D
done with xz 43903 read=0D
supermin: internal insmod ideapad-laptop.ko.xz=0D
supermin: running xz=0D
done with xz 26527 read=0D
supermin: internal insmod megaraid.ko.xz=0D
supermin: running xz=0D
done with xz 64095 read=0D
supermin: internal insmod megaraid_mm.ko.xz=0D
supermin: running xz=0D
done with xz 22263 read=0D
[    5.861322] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)=0D
supermin: internal insmod megaraid_mbox.ko.xz=0D
supermin: running xz=0D
done with xz 55623 read=0D
[    5.908315] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 20=
06)=0D
supermin: internal insmod megaraid_sas.ko.xz=0D
supermin: running xz=0D
done with xz 163199 read=0D
[    6.000301] megasas: 06.807.10.00-rc1=0D
supermin: internal insmod scsi_transport_spi.ko.xz=0D
supermin: running xz=0D
done with xz 46567 read=0D
supermin: internal insmod sym53c8xx.ko.xz=0D
supermin: running xz=0D
done with xz 118959 read=0D
supermin: internal insmod virtio_scsi.ko.xz=0D
supermin: running xz=0D
done with xz 27807 read=0D
supermin: internal insmod virtio_balloon.ko.xz=0D
supermin: running xz=0D
done with xz 18455 read=0D
supermin: internal insmod virtio_input.ko.xz=0D
supermin: running xz=0D
done with xz 13143 read=0D
supermin: internal insmod virtio_mmio.ko.xz=0D
supermin: running xz=0D
done with xz 13751 read=0D
supermin: internal insmod virtio_pci.ko.xz=0D
supermin: running xz=0D
done with xz 32055 read=0D
[    6.265261] virtio-pci 0000:00:02.0: PCI->APIC IRQ transform: INT A -> I=
RQ 10=0D
[    6.266261] virtio-pci 0000:00:02.0: virtio_pci: leaving for legacy driv=
er=0D
[    6.290257] scsi host2: Virtio SCSI HBA=0D
[    6.316253] virtio-pci 0000:00:03.0: PCI->APIC IRQ transform: INT A -> I=
RQ 11=0D
[    6.316253] virtio-pci 0000:00:03.0: virtio_pci: leaving for legacy driv=
er=0D
[    6.366246] scsi 2:0:0:0: Direct-Access     QEMU     QEMU HARDDISK    2.=
4. PQ: 0 ANSI: 5=0D
[    6.375244] virtio-pci 0000:00:04.0: PCI->APIC IRQ transform: INT A -> I=
RQ 11=0D
[    6.376244] virtio-pci 0000:00:04.0: virtio_pci: leaving for legacy driv=
er=0D
[    6.391242] scsi 2:0:1:0: Direct-Access     QEMU     QEMU HARDDISK    2.=
4. PQ: 0 ANSI: 5=0D
[    6.408239] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.408239] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    6.434235] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.434235] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    6.443234] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.443234] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    6.452233] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.452233] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    6.461231] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.461231] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    6.469230] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.469230] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    6.478229] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.478229] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    6.487227] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.487227] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    6.496226] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.496226] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    6.504225] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.504225] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    6.512223] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.512223] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    6.521222] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.521222] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    6.531221] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.531221] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    6.540219] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.540219] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    6.549218] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.549218] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    6.558216] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.558216] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    6.567215] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.567215] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    6.576214] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.576214] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    6.584212] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.584212] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    6.592211] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.592211] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    6.601210] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.601210] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    6.610208] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.610208] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    6.619207] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.619207] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    6.628206] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.628206] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    6.636205] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.636205] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    6.645203] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.645203] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    6.653202] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.653202] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    6.662201] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.662201] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    6.671199] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.671199] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    6.681198] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.681198] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    6.690196] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.690196] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    6.699195] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.699195] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    6.708194] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.708194] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    6.718192] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.718192] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    6.726191] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.726191] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    6.734190] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.734190] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    6.742188] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.742188] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    6.750187] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.750187] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    6.758186] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.758186] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    6.766185] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.766185] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    6.775183] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.775183] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    6.784182] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.784182] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    6.793181] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.793181] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    6.802179] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.802179] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    6.811178] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.811178] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    6.819177] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.819177] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    6.827176] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.827176] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    6.835174] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.835174] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    6.843173] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.843173] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    6.852172] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.852172] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    6.860170] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.860170] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    6.868169] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.868169] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    6.876168] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.876168] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    6.884167] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.884167] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    6.893165] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.893165] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    6.901164] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.901164] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    6.910163] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.910163] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    6.918162] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.918162] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    6.926160] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.926160] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    6.934159] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.934159] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    6.942158] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.942158] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    6.950157] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.950157] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    6.959155] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.959155] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    6.967154] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.967154] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    6.976153] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    6.976153] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    6.985151] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.985151] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    6.994150] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    6.994150] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.003149] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.003149] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.012147] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.012147] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.021146] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.021146] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.029145] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.029145] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.037144] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.037144] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.045142] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.045142] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.053141] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.053141] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.061140] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.061140] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.069139] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.069139] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.077138] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.077138] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.085136] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.085136] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.094135] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.094135] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.103134] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.103134] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.112132] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.112132] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.121131] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.121131] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.130129] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.130129] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.138128] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.138128] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.146127] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.146127] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.154126] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.154126] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.162125] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.162125] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.171123] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.171123] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.180122] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.180122] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.189120] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.189120] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.198119] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.198119] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.207118] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.207118] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.215117] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.215117] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.223115] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.223115] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.231114] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.231114] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.240113] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.240113] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.250111] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.250111] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.259110] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.259110] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.267109] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.267109] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.277107] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.277107] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.285106] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.285106] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.294105] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.294105] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.303103] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.303103] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.312102] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.312102] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.321100] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.321100] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.329099] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.329099] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.337098] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.337098] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.345097] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.345097] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.353096] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.353096] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.361094] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.361094] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.370093] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.370093] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.379092] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.379092] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.388090] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.388090] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.397089] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.397089] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.406088] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.406088] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.415086] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.415086] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.424085] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.424085] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.433083] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.433083] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.442082] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.442082] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.451081] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.451081] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.460079] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.460079] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.468078] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.468078] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.477077] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.477077] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.485075] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.485075] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.494074] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.494074] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.503073] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.503073] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.511072] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.511072] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.520070] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.520070] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.529069] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.529069] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.537068] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.537068] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.546066] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.546066] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.555065] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.555065] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.564063] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.564063] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.572062] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.572062] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.580061] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.580061] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.588060] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.588060] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.597058] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.597058] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.605057] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.605057] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.613056] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.613056] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.622055] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.622055] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.631053] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.631053] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.640052] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.640052] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.649051] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.649051] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.658049] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.658049] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.666048] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.666048] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.675047] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.675047] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.684045] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.684045] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.693044] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.693044] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.702043] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.702043] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.711041] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.711041] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.720040] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.720040] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.729038] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.729038] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.738037] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.738037] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.746036] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.746036] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.754035] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.754035] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.762033] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.762033] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.770032] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.770032] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.779031] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.779031] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.788029] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.788029] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.797028] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.797028] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.806027] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.806027] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.815025] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.815025] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.824024] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.824024] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.833023] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.833023] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.842021] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.842021] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.851020] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.851020] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.859019] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.859019] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.868017] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.868017] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.877016] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.877016] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.885015] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.885015] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.894013] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.894013] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.903012] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.903012] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.912011] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.912011] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.921009] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.921009] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.930008] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.930008] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.939006] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.939006] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.948005] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.948005] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.956004] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.956004] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.964003] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.964003] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.973001] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.973001] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    7.982000] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.982000] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    7.990999] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    7.990999] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    7.999997] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    7.999997] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    8.007996] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.007996] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.015995] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.015995] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    8.024993] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.024993] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    8.032992] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.032992] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    8.040991] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.040991] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.049990] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.049990] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    8.058988] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.058988] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    8.066987] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.066987] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    8.075986] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.075986] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.083984] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.083984] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    8.091983] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.091983] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    8.099982] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.099982] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    8.107981] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.107981] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.115980] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.115980] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    8.123978] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.123978] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    8.132977] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.132977] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    8.140976] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.140976] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.149974] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.149974] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    8.157973] XXX blk_throtl_drain: td=3Dffff88001bf52000 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.157973] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    8.165972] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.165972] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    8.174971] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.174971] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.182969] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.182969] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.190968] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.190968] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    8.199967] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.199967] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.207966] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.207966] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    8.216964] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.216964] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.225963] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.225963] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    8.233962] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.233962] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.242960] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.242960] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    8.251959] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.251959] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.259958] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.259958] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    8.268956] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.268956] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.276955] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.276955] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    8.285954] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.285954] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.295952] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.295952] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    8.304951] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.304951] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.313949] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.313949] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    8.321948] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.321948] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.330947] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.330947] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    8.338946] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.338946] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.346944] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.346944] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    8.355943] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.355943] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.364942] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.364942] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    8.373940] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.373940] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.382939] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.382939] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    8.390938] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.390938] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.399936] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.399936] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    8.407935] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.407935] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.415934] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.415934] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    8.423933] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.423933] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.431932] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.431932] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    8.440930] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.440930] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.448929] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.448929] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    8.456928] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.456928] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.464927] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.464927] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    8.472925] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.472925] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.480924] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.480924] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    8.488923] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.488923] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.496922] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.496922] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    8.504920] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.504920] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.512919] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.512919] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    8.520918] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.520918] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.528917] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.528917] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    8.536916] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.536916] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.545914] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.545914] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    8.553913] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.553913] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.562912] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.562912] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    8.570910] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.570910] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.578909] XXX blk_throtl_drain: td=3Dffff88001bf52400 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52200 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.578909] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52200=0D
[    8.587908] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf5ac10 ->root_blkg=3Dffff88001bf52000 ->q/blkcg=3Dffff88001bf5ac10/ffff=
ffff832d79a0=0D
[    8.587908] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52000=0D
[    8.595907] XXX blk_throtl_drain: td=3Dffff88001bf52200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001bf52400 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[    8.595907] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf52400=0D
[    8.621903] sd 2:0:0:0: [sda] 1024000 512-byte logical blocks: (524 MB/5=
00 MiB)=0D
[    8.635901] sd 2:0:0:0: [sda] Write Protect is off=0D
[    8.637900] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA=0D
[    8.646899] sd 2:0:0:0: Attached scsi generic sg0 type 0=0D
[    8.682893] sd 2:0:1:0: [sdb] 8388608 512-byte logical blocks: (4.29 GB/=
4.00 GiB)=0D
[    8.685893] sd 2:0:1:0: [sdb] Write Protect is off=0D
[    8.696891] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA=0D
[    8.699891] sd 2:0:1:0: Attached scsi generic sg1 type 0=0D
[    8.770880] sd 2:0:1:0: [sdb] Attached SCSI disk=0D
[    8.772880] sd 2:0:0:0: [sda] Attached SCSI disk=0D
supermin: internal insmod crc-ccitt.ko.xz=0D
supermin: running xz=0D
done with xz 4679 read=0D
supermin: internal insmod crc-itu-t.ko.xz=0D
supermin: running xz=0D
done with xz 4679 read=0D
supermin: internal insmod crc8.ko.xz=0D
supermin: running xz=0D
done with xz 4487 read=0D
supermin: internal insmod libcrc32c.ko.xz=0D
supermin: running xz=0D
done with xz 5359 read=0D
supermin: picked /sys/block/sdb/dev as root device=0D
supermin: creating /dev/root as block special 8:16=0D
supermin: mounting new root on /root=0D
[    8.940854] EXT4-fs (sdb): mounting ext2 file system using the ext4 subs=
ystem=0D
[    9.036840] EXT4-fs (sdb): mounted filesystem without journal. Opts: =0D
supermin: chroot=0D
[    9.331795] random: nonblocking pool is initialized=0D
Starting /init script ...=0D
[   12.823264] ldconfig (349) used greatest stack depth: 11944 bytes left=0D
[/usr/lib/tmpfiles.d/journal-nocow.conf:26] Failed to replace specifiers: /=
var/log/journal/%m=0D
[/usr/lib/tmpfiles.d/systemd.conf:26] Failed to replace specifiers: /run/lo=
g/journal/%m=0D
[/usr/lib/tmpfiles.d/systemd.conf:28] Failed to replace specifiers: /run/lo=
g/journal/%m=0D
[/usr/lib/tmpfiles.d/systemd.conf:29] Failed to replace specifiers: /run/lo=
g/journal/%m=0D
[/usr/lib/tmpfiles.d/systemd.conf:32] Failed to replace specifiers: /var/lo=
g/journal/%m=0D
[/usr/lib/tmpfiles.d/systemd.conf:34] Failed to replace specifiers: /var/lo=
g/journal/%m=0D
[/usr/lib/tmpfiles.d/systemd.conf:35] Failed to replace specifiers: /var/lo=
g/journal/%m=0D
starting version 225=0D
[   26.270220] input: PC Speaker as /devices/platform/pcspkr/input/input3=0D
[   26.448193] PCSP: Timer resolution is not sufficient (1000000nS)=0D
[   26.449193] PCSP: Make sure you have HPET and ACPI enabled.=0D
[   26.450192] PCSP: Turned into nopcm mode.=0D
[   29.031800] kvm: Nested Virtualization enabled=0D
/init: line 86: /sys/block/hd*/queue/scheduler: No such file or directory=0D
[   29.610712] XXX blk_throtl_drain: td=3Dffff88001bd58e00 ->queue=3Dffff88=
001bf58000 ->root_blkg=3Dffff88001bed1e00 ->q/blkcg=3Dffff88001bf58000/ffff=
ffff832d79a0=0D
[   29.610712] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bed1e00=0D
[   29.627709] XXX blk_throtl_drain: td=3Dffff88001bd58e00 ->queue=3Dffff88=
001bf58000 ->root_blkg=3Dffff88001bed1e00 ->q/blkcg=3Dffff88001bf58000/ffff=
ffff832d79a0=0D
[   29.627709] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bed1e00=0D
[   29.633708] XXX blk_throtl_drain: td=3Dffff88001bf66a00 ->queue=3Dffff88=
001bf58eb0 ->root_blkg=3Dffff88001bf66800 ->q/blkcg=3Dffff88001bf58eb0/ffff=
ffff832d79a0=0D
[   29.633708] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf66800=0D
[   29.636708] XXX blk_throtl_drain: td=3Dffff88001bf66a00 ->queue=3Dffff88=
001bf58eb0 ->root_blkg=3Dffff88001bf66800 ->q/blkcg=3Dffff88001bf58eb0/ffff=
ffff832d79a0=0D
[   29.636708] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001bf66800=0D
/init: line 86: /sys/block/ubd*/queue/scheduler: No such file or directory=
=0D
/init: line 86: /sys/block/vd*/queue/scheduler: No such file or directory=0D
[   30.767536] ip (392) used greatest stack depth: 11832 bytes left=0D
mdadm: No arrays found in config file or automatically=0D
  lvmetad is not active yet, using direct activation during sysinit=0D
[=0D
]=0D
Linux (none) 4.3.0-0.rc0.git7.1.rwmj3.fc24.x86_64 #1 SMP Fri Sep 4 18:30:37=
 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux=0D
/dev:=0D
total 0=0D
crw------- 1 root root  10, 235 Sep  4 22:30 autofs=0D
drwxr-xr-x 2 root root       80 Sep  4 22:30 block=0D
drwxr-xr-x 2 root root       80 Sep  4 22:30 bsg=0D
crw------- 1 root root  10, 234 Sep  4 22:30 btrfs-control=0D
drwxr-xr-x 3 root root       60 Sep  4 22:30 bus=0D
drwxr-xr-x 2 root root     2380 Sep  4 22:31 char=0D
crw------- 1 root root   5,   1 Sep  4 22:30 console=0D
lrwxrwxrwx 1 root root       11 Sep  4 22:30 core -> /proc/kcore=0D
drwxr-xr-x 3 root root       60 Sep  4 22:30 cpu=0D
crw------- 1 root root  10,  62 Sep  4 22:30 cpu_dma_latency=0D
crw------- 1 root root  10, 203 Sep  4 22:30 cuse=0D
drwxr-xr-x 5 root root      100 Sep  4 22:30 disk=0D
lrwxrwxrwx 1 root root       13 Sep  4 22:30 fd -> /proc/self/fd=0D
crw-rw-rw- 1 root root   1,   7 Sep  4 22:30 full=0D
crw-rw-rw- 1 root root  10, 229 Sep  4 22:30 fuse=0D
crw------- 1 root root  10, 183 Sep  4 22:30 hwrng=0D
drwxr-xr-x 3 root root      160 Sep  4 22:30 input=0D
crw-r--r-- 1 root root   1,  11 Sep  4 22:30 kmsg=0D
crw------- 1 root root  10, 232 Sep  4 22:31 kvm=0D
crw-rw---- 1 root disk  10, 237 Sep  4 22:30 loop-control=0D
drwxr-xr-x 2 root root       60 Sep  4 22:30 mapper=0D
crw------- 1 root root  10, 227 Sep  4 22:30 mcelog=0D
crw------- 1 root root  10,  57 Sep  4 22:30 megadev0=0D
crw------- 1 root root   1,   1 Sep  4 22:30 mem=0D
crw------- 1 root root  10,  59 Sep  4 22:30 memory_bandwidth=0D
crw------- 1 root root 254,   0 Sep  4 22:30 ndctl0=0D
drwxr-xr-x 2 root root       60 Sep  4 22:30 net=0D
crw------- 1 root root  10,  61 Sep  4 22:30 network_latency=0D
crw------- 1 root root  10,  60 Sep  4 22:30 network_throughput=0D
crw-rw-rw- 1 root root   1,   3 Sep  4 22:30 null=0D
crw------- 1 root root  10, 144 Sep  4 22:30 nvram=0D
crw------- 1 root root   1,   4 Sep  4 22:30 port=0D
crw------- 1 root root 108,   0 Sep  4 22:30 ppp=0D
crw-rw-rw- 1 root root   5,   2 Sep  4 22:30 ptmx=0D
crw-rw-rw- 1 root root   1,   8 Sep  4 22:30 random=0D
drwxr-xr-x 2 root root       60 Sep  4 22:30 raw=0D
crw------- 1 root root  10,  58 Sep  4 22:30 rfkill=0D
lrwxrwxrwx 1 root root        4 Sep  4 22:30 rtc -> rtc0=0D
crw------- 1 root root 252,   0 Sep  4 22:30 rtc0=0D
brw------- 1 root root   8,   0 Sep  4 22:31 sda=0D
brw------- 1 root root   8,  16 Sep  4 22:31 sdb=0D
crw------- 1 root root  21,   0 Sep  4 22:30 sg0=0D
crw------- 1 root root  21,   1 Sep  4 22:30 sg1=0D
crw------- 1 root root  10, 231 Sep  4 22:30 snapshot=0D
drwxr-xr-x 3 root root      120 Sep  4 22:31 snd=0D
lrwxrwxrwx 1 root root       15 Sep  4 22:30 stderr -> /proc/self/fd/2=0D
lrwxrwxrwx 1 root root       15 Sep  4 22:30 stdin -> /proc/self/fd/0=0D
lrwxrwxrwx 1 root root       15 Sep  4 22:30 stdout -> /proc/self/fd/1=0D
crw-rw-rw- 1 root root   5,   0 Sep  4 22:30 tty=0D
crw------- 1 root root   4,   0 Sep  4 22:30 tty0=0D
crw------- 1 root root   4,   1 Sep  4 22:30 tty1=0D
crw------- 1 root root   4,  10 Sep  4 22:30 tty10=0D
crw------- 1 root root   4,  11 Sep  4 22:30 tty11=0D
crw------- 1 root root   4,  12 Sep  4 22:30 tty12=0D
crw------- 1 root root   4,  13 Sep  4 22:30 tty13=0D
crw------- 1 root root   4,  14 Sep  4 22:30 tty14=0D
crw------- 1 root root   4,  15 Sep  4 22:30 tty15=0D
crw------- 1 root root   4,  16 Sep  4 22:30 tty16=0D
crw------- 1 root root   4,  17 Sep  4 22:30 tty17=0D
crw------- 1 root root   4,  18 Sep  4 22:30 tty18=0D
crw------- 1 root root   4,  19 Sep  4 22:30 tty19=0D
crw------- 1 root root   4,   2 Sep  4 22:30 tty2=0D
crw------- 1 root root   4,  20 Sep  4 22:30 tty20=0D
crw------- 1 root root   4,  21 Sep  4 22:30 tty21=0D
crw------- 1 root root   4,  22 Sep  4 22:30 tty22=0D
crw------- 1 root root   4,  23 Sep  4 22:30 tty23=0D
crw------- 1 root root   4,  24 Sep  4 22:30 tty24=0D
crw------- 1 root root   4,  25 Sep  4 22:30 tty25=0D
crw------- 1 root root   4,  26 Sep  4 22:30 tty26=0D
crw------- 1 root root   4,  27 Sep  4 22:30 tty27=0D
crw------- 1 root root   4,  28 Sep  4 22:30 tty28=0D
crw------- 1 root root   4,  29 Sep  4 22:30 tty29=0D
crw------- 1 root root   4,   3 Sep  4 22:30 tty3=0D
crw------- 1 root root   4,  30 Sep  4 22:30 tty30=0D
crw------- 1 root root   4,  31 Sep  4 22:30 tty31=0D
crw------- 1 root root   4,  32 Sep  4 22:30 tty32=0D
crw------- 1 root root   4,  33 Sep  4 22:30 tty33=0D
crw------- 1 root root   4,  34 Sep  4 22:30 tty34=0D
crw------- 1 root root   4,  35 Sep  4 22:30 tty35=0D
crw------- 1 root root   4,  36 Sep  4 22:30 tty36=0D
crw------- 1 root root   4,  37 Sep  4 22:30 tty37=0D
crw------- 1 root root   4,  38 Sep  4 22:30 tty38=0D
crw------- 1 root root   4,  39 Sep  4 22:30 tty39=0D
crw------- 1 root root   4,   4 Sep  4 22:30 tty4=0D
crw------- 1 root root   4,  40 Sep  4 22:30 tty40=0D
crw------- 1 root root   4,  41 Sep  4 22:30 tty41=0D
crw------- 1 root root   4,  42 Sep  4 22:30 tty42=0D
crw------- 1 root root   4,  43 Sep  4 22:30 tty43=0D
crw------- 1 root root   4,  44 Sep  4 22:30 tty44=0D
crw------- 1 root root   4,  45 Sep  4 22:30 tty45=0D
crw------- 1 root root   4,  46 Sep  4 22:30 tty46=0D
crw------- 1 root root   4,  47 Sep  4 22:30 tty47=0D
crw------- 1 root root   4,  48 Sep  4 22:30 tty48=0D
crw------- 1 root root   4,  49 Sep  4 22:30 tty49=0D
crw------- 1 root root   4,   5 Sep  4 22:30 tty5=0D
crw------- 1 root root   4,  50 Sep  4 22:30 tty50=0D
crw------- 1 root root   4,  51 Sep  4 22:30 tty51=0D
crw------- 1 root root   4,  52 Sep  4 22:30 tty52=0D
crw------- 1 root root   4,  53 Sep  4 22:30 tty53=0D
crw------- 1 root root   4,  54 Sep  4 22:30 tty54=0D
crw------- 1 root root   4,  55 Sep  4 22:30 tty55=0D
crw------- 1 root root   4,  56 Sep  4 22:30 tty56=0D
crw------- 1 root root   4,  57 Sep  4 22:30 tty57=0D
crw------- 1 root root   4,  58 Sep  4 22:30 tty58=0D
crw------- 1 root root   4,  59 Sep  4 22:30 tty59=0D
crw------- 1 root root   4,   6 Sep  4 22:30 tty6=0D
crw------- 1 root root   4,  60 Sep  4 22:30 tty60=0D
crw------- 1 root root   4,  61 Sep  4 22:30 tty61=0D
crw------- 1 root root   4,  62 Sep  4 22:30 tty62=0D
crw------- 1 root root   4,  63 Sep  4 22:31 tty63=0D
crw------- 1 root root   4,   7 Sep  4 22:31 tty7=0D
crw------- 1 root root   4,   8 Sep  4 22:31 tty8=0D
crw------- 1 root root   4,   9 Sep  4 22:31 tty9=0D
crw------- 1 root root   4,  64 Sep  4 22:30 ttyS0=0D
crw------- 1 root root   4,  65 Sep  4 22:30 ttyS1=0D
crw------- 1 root root   4,  66 Sep  4 22:30 ttyS2=0D
crw------- 1 root root   4,  67 Sep  4 22:30 ttyS3=0D
crw------- 1 root root  10, 239 Sep  4 22:30 uhid=0D
crw------- 1 root root  10, 223 Sep  4 22:30 uinput=0D
crw-rw-rw- 1 root root   1,   9 Sep  4 22:30 urandom=0D
crw------- 1 root root 249,   0 Sep  4 22:31 usbmon0=0D
crw------- 1 root root 249,   1 Sep  4 22:30 usbmon1=0D
crw------- 1 root root   7,   0 Sep  4 22:31 vcs=0D
crw------- 1 root root   7,   1 Sep  4 22:31 vcs1=0D
crw------- 1 root root   7, 128 Sep  4 22:31 vcsa=0D
crw------- 1 root root   7, 129 Sep  4 22:31 vcsa1=0D
drwxr-xr-x 2 root root       60 Sep  4 22:30 vfio=0D
crw------- 1 root root  10,  63 Sep  4 22:30 vga_arbiter=0D
crw------- 1 root root  10, 137 Sep  4 22:30 vhci=0D
crw------- 1 root root  10, 238 Sep  4 22:30 vhost-net=0D
drwxr-xr-x 2 root root       60 Sep  4 22:30 virtio-ports=0D
crw------- 1 root root 245,   1 Sep  4 22:30 vport1p1=0D
crw-rw-rw- 1 root root   1,   5 Sep  4 22:30 zero=0D
=0D
/dev/block:=0D
total 0=0D
lrwxrwxrwx 1 root root 6 Sep  4 22:31 8:0 -> ../sda=0D
lrwxrwxrwx 1 root root 6 Sep  4 22:31 8:16 -> ../sdb=0D
=0D
/dev/bsg:=0D
total 0=0D
crw------- 1 root root 250, 0 Sep  4 22:30 2:0:0:0=0D
crw------- 1 root root 250, 1 Sep  4 22:30 2:0:1:0=0D
=0D
/dev/bus:=0D
total 0=0D
drwxr-xr-x 3 root root 60 Sep  4 22:30 usb=0D
=0D
/dev/bus/usb:=0D
total 0=0D
drwxr-xr-x 2 root root 60 Sep  4 22:30 001=0D
=0D
/dev/bus/usb/001:=0D
total 0=0D
crw------- 1 root root 189, 0 Sep  4 22:30 001=0D
=0D
/dev/char:=0D
total 0=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 10:144 -> ../nvram=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 10:183 -> ../hwrng=0D
lrwxrwxrwx 1 root root  9 Sep  4 22:30 10:227 -> ../mcelog=0D
lrwxrwxrwx 1 root root 11 Sep  4 22:30 10:231 -> ../snapshot=0D
lrwxrwxrwx 1 root root  6 Sep  4 22:31 10:232 -> ../kvm=0D
lrwxrwxrwx 1 root root  9 Sep  4 22:30 10:235 -> ../autofs=0D
lrwxrwxrwx 1 root root 17 Sep  4 22:30 10:236 -> ../mapper/control=0D
lrwxrwxrwx 1 root root 11 Sep  4 22:30 10:57 -> ../megadev0=0D
lrwxrwxrwx 1 root root  9 Sep  4 22:30 10:58 -> ../rfkill=0D
lrwxrwxrwx 1 root root 19 Sep  4 22:30 10:59 -> ../memory_bandwidth=0D
lrwxrwxrwx 1 root root 21 Sep  4 22:30 10:60 -> ../network_throughput=0D
lrwxrwxrwx 1 root root 18 Sep  4 22:30 10:61 -> ../network_latency=0D
lrwxrwxrwx 1 root root 18 Sep  4 22:30 10:62 -> ../cpu_dma_latency=0D
lrwxrwxrwx 1 root root 14 Sep  4 22:30 10:63 -> ../vga_arbiter=0D
lrwxrwxrwx 1 root root 16 Sep  4 22:31 116:2 -> ../snd/controlC0=0D
lrwxrwxrwx 1 root root 12 Sep  4 22:31 116:33 -> ../snd/timer=0D
lrwxrwxrwx 1 root root 15 Sep  4 22:30 13:32 -> ../input/mouse0=0D
lrwxrwxrwx 1 root root 13 Sep  4 22:30 13:63 -> ../input/mice=0D
lrwxrwxrwx 1 root root 15 Sep  4 22:30 13:64 -> ../input/event0=0D
lrwxrwxrwx 1 root root 15 Sep  4 22:30 13:65 -> ../input/event1=0D
lrwxrwxrwx 1 root root 15 Sep  4 22:31 13:66 -> ../input/event2=0D
lrwxrwxrwx 1 root root 13 Sep  4 22:30 162:0 -> ../raw/rawctl=0D
lrwxrwxrwx 1 root root 18 Sep  4 22:30 189:0 -> ../bus/usb/001/001=0D
lrwxrwxrwx 1 root root  6 Sep  4 22:30 1:1 -> ../mem=0D
lrwxrwxrwx 1 root root  7 Sep  4 22:30 1:11 -> ../kmsg=0D
lrwxrwxrwx 1 root root  7 Sep  4 22:30 1:3 -> ../null=0D
lrwxrwxrwx 1 root root  7 Sep  4 22:30 1:4 -> ../port=0D
lrwxrwxrwx 1 root root  7 Sep  4 22:30 1:5 -> ../zero=0D
lrwxrwxrwx 1 root root  7 Sep  4 22:30 1:7 -> ../full=0D
lrwxrwxrwx 1 root root  9 Sep  4 22:30 1:8 -> ../random=0D
lrwxrwxrwx 1 root root 10 Sep  4 22:30 1:9 -> ../urandom=0D
lrwxrwxrwx 1 root root 12 Sep  4 22:30 202:0 -> ../cpu/0/msr=0D
lrwxrwxrwx 1 root root 14 Sep  4 22:30 203:0 -> ../cpu/0/cpuid=0D
lrwxrwxrwx 1 root root  6 Sep  4 22:30 21:0 -> ../sg0=0D
lrwxrwxrwx 1 root root  6 Sep  4 22:30 21:1 -> ../sg1=0D
lrwxrwxrwx 1 root root 11 Sep  4 22:30 245:1 -> ../vport1p1=0D
lrwxrwxrwx 1 root root 10 Sep  4 22:31 249:0 -> ../usbmon0=0D
lrwxrwxrwx 1 root root 10 Sep  4 22:30 249:1 -> ../usbmon1=0D
lrwxrwxrwx 1 root root 14 Sep  4 22:30 250:0 -> ../bsg/2:0:0:0=0D
lrwxrwxrwx 1 root root 14 Sep  4 22:30 250:1 -> ../bsg/2:0:1:0=0D
lrwxrwxrwx 1 root root  7 Sep  4 22:30 252:0 -> ../rtc0=0D
lrwxrwxrwx 1 root root  9 Sep  4 22:30 254:0 -> ../ndctl0=0D
lrwxrwxrwx 1 root root  7 Sep  4 22:30 4:0 -> ../tty0=0D
lrwxrwxrwx 1 root root  7 Sep  4 22:30 4:1 -> ../tty1=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:10 -> ../tty10=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:11 -> ../tty11=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:12 -> ../tty12=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:13 -> ../tty13=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:14 -> ../tty14=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:15 -> ../tty15=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:16 -> ../tty16=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:17 -> ../tty17=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:18 -> ../tty18=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:19 -> ../tty19=0D
lrwxrwxrwx 1 root root  7 Sep  4 22:30 4:2 -> ../tty2=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:20 -> ../tty20=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:21 -> ../tty21=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:22 -> ../tty22=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:23 -> ../tty23=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:24 -> ../tty24=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:25 -> ../tty25=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:26 -> ../tty26=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:27 -> ../tty27=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:28 -> ../tty28=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:29 -> ../tty29=0D
lrwxrwxrwx 1 root root  7 Sep  4 22:30 4:3 -> ../tty3=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:30 -> ../tty30=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:31 -> ../tty31=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:32 -> ../tty32=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:33 -> ../tty33=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:34 -> ../tty34=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:35 -> ../tty35=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:36 -> ../tty36=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:37 -> ../tty37=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:38 -> ../tty38=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:39 -> ../tty39=0D
lrwxrwxrwx 1 root root  7 Sep  4 22:30 4:4 -> ../tty4=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:40 -> ../tty40=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:41 -> ../tty41=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:42 -> ../tty42=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:43 -> ../tty43=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:44 -> ../tty44=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:45 -> ../tty45=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:46 -> ../tty46=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:47 -> ../tty47=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:48 -> ../tty48=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:49 -> ../tty49=0D
lrwxrwxrwx 1 root root  7 Sep  4 22:30 4:5 -> ../tty5=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:50 -> ../tty50=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:51 -> ../tty51=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:52 -> ../tty52=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:53 -> ../tty53=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:54 -> ../tty54=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:55 -> ../tty55=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:56 -> ../tty56=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:57 -> ../tty57=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:58 -> ../tty58=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:59 -> ../tty59=0D
lrwxrwxrwx 1 root root  7 Sep  4 22:30 4:6 -> ../tty6=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:60 -> ../tty60=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:61 -> ../tty61=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:62 -> ../tty62=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:31 4:63 -> ../tty63=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:64 -> ../ttyS0=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:65 -> ../ttyS1=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:66 -> ../ttyS2=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:30 4:67 -> ../ttyS3=0D
lrwxrwxrwx 1 root root  7 Sep  4 22:31 4:7 -> ../tty7=0D
lrwxrwxrwx 1 root root  7 Sep  4 22:31 4:8 -> ../tty8=0D
lrwxrwxrwx 1 root root  7 Sep  4 22:31 4:9 -> ../tty9=0D
lrwxrwxrwx 1 root root  6 Sep  4 22:30 5:0 -> ../tty=0D
lrwxrwxrwx 1 root root 10 Sep  4 22:30 5:1 -> ../console=0D
lrwxrwxrwx 1 root root  7 Sep  4 22:30 5:2 -> ../ptmx=0D
lrwxrwxrwx 1 root root  6 Sep  4 22:31 7:0 -> ../vcs=0D
lrwxrwxrwx 1 root root  7 Sep  4 22:31 7:1 -> ../vcs1=0D
lrwxrwxrwx 1 root root  7 Sep  4 22:31 7:128 -> ../vcsa=0D
lrwxrwxrwx 1 root root  8 Sep  4 22:31 7:129 -> ../vcsa1=0D
=0D
/dev/cpu:=0D
total 0=0D
drwxr-xr-x 2 root root 80 Sep  4 22:30 0=0D
=0D
/dev/cpu/0:=0D
total 0=0D
crw------- 1 root root 203, 0 Sep  4 22:30 cpuid=0D
crw------- 1 root root 202, 0 Sep  4 22:30 msr=0D
=0D
/dev/disk:=0D
total 0=0D
drwxr-xr-x 2 root root 80 Sep  4 22:30 by-id=0D
drwxr-xr-x 2 root root 80 Sep  4 22:30 by-path=0D
drwxr-xr-x 2 root root 60 Sep  4 22:30 by-uuid=0D
=0D
/dev/disk/by-id:=0D
total 0=0D
lrwxrwxrwx 1 root root 9 Sep  4 22:31 scsi-0QEMU_QEMU_HARDDISK_drive-scsi0-=
0-0-0 -> ../../sda=0D
lrwxrwxrwx 1 root root 9 Sep  4 22:31 scsi-0QEMU_QEMU_HARDDISK_drive-scsi0-=
0-1-0 -> ../../sdb=0D
=0D
/dev/disk/by-path:=0D
total 0=0D
lrwxrwxrwx 1 root root 9 Sep  4 22:31 pci-0000:00:02.0-scsi-0:0:0:0 -> ../.=
=2E/sda=0D
lrwxrwxrwx 1 root root 9 Sep  4 22:31 pci-0000:00:02.0-scsi-0:0:1:0 -> ../.=
=2E/sdb=0D
=0D
/dev/disk/by-uuid:=0D
total 0=0D
lrwxrwxrwx 1 root root 9 Sep  4 22:31 93b10d1b-dd5e-494d-ac0f-a281909f1082 =
-> ../../sdb=0D
=0D
/dev/input:=0D
total 0=0D
drwxr-xr-x 2 root root    120 Sep  4 22:31 by-path=0D
crw------- 1 root root 13, 64 Sep  4 22:30 event0=0D
crw------- 1 root root 13, 65 Sep  4 22:30 event1=0D
crw------- 1 root root 13, 66 Sep  4 22:31 event2=0D
crw------- 1 root root 13, 63 Sep  4 22:30 mice=0D
crw------- 1 root root 13, 32 Sep  4 22:30 mouse0=0D
=0D
/dev/input/by-path:=0D
total 0=0D
lrwxrwxrwx 1 root root 9 Sep  4 22:30 platform-i8042-serio-0-event-kbd -> .=
=2E/event1=0D
lrwxrwxrwx 1 root root 9 Sep  4 22:30 platform-i8042-serio-1-event-mouse ->=
 ../event0=0D
lrwxrwxrwx 1 root root 9 Sep  4 22:30 platform-i8042-serio-1-mouse -> ../mo=
use0=0D
lrwxrwxrwx 1 root root 9 Sep  4 22:31 platform-pcspkr-event-spkr -> ../even=
t2=0D
=0D
/dev/mapper:=0D
total 0=0D
crw------- 1 root root 10, 236 Sep  4 22:30 control=0D
=0D
/dev/net:=0D
total 0=0D
crw-rw-rw- 1 root root 10, 200 Sep  4 22:30 tun=0D
=0D
/dev/raw:=0D
total 0=0D
crw------- 1 root root 162, 0 Sep  4 22:30 rawctl=0D
=0D
/dev/snd:=0D
total 0=0D
drwxr-xr-x 2 root root       60 Sep  4 22:31 by-path=0D
crw-rw---- 1 root audio 116,  2 Sep  4 22:31 controlC0=0D
crw-rw---- 1 root audio 116,  1 Sep  4 22:30 seq=0D
crw-rw---- 1 root audio 116, 33 Sep  4 22:31 timer=0D
=0D
/dev/snd/by-path:=0D
total 0=0D
lrwxrwxrwx 1 root root 12 Sep  4 22:31 platform-pcspkr -> ../controlC0=0D
=0D
/dev/vfio:=0D
total 0=0D
crw------- 1 root root 10, 196 Sep  4 22:30 vfio=0D
=0D
/dev/virtio-ports:=0D
total 0=0D
lrwxrwxrwx 1 root root 11 Sep  4 22:30 org.libguestfs.channel.0 -> ../vport=
1p1=0D
/dev/root / ext2 rw,noatime 0 0=0D
/proc /proc proc rw,relatime 0 0=0D
/sys /sys sysfs rw,relatime 0 0=0D
tmpfs /run tmpfs rw,nosuid,relatime,size=3D93808k,mode=3D755 0 0=0D
/dev /dev devtmpfs rw,relatime,size=3D230832k,nr_inodes=3D57708,mode=3D755 =
0 0=0D
  /run/lvm/lvmetad.socket: connect failed: No such file or directory=0D
  WARNING: Failed to connect to lvmetad. Falling back to internal scanning.=
=0D
  /run/lvm/lvmetad.socket: connect failed: No such file or directory=0D
  WARNING: Failed to connect to lvmetad. Falling back to internal scanning.=
=0D
  /run/lvm/lvmetad.socket: connect failed: No such file or directory=0D
  WARNING: Failed to connect to lvmetad. Falling back to internal scanning.=
=0D
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group d=
efault =0D
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00=0D
    inet 127.0.0.1/8 brd 127.255.255.255 scope host lo=0D
       valid_lft forever preferred_lft forever=0D
    inet6 ::1/128 scope host =0D
       valid_lft forever preferred_lft forever=0D
Module                  Size  Used by=0D
kvm_amd                73728  0=0D
kvm                   536576  1 kvm_amd=0D
snd_pcsp               16384  0=0D
snd_pcm               114688  1 snd_pcsp=0D
snd_timer              32768  1 snd_pcm=0D
snd                    86016  3 snd_timer,snd_pcm,snd_pcsp=0D
soundcore              16384  1 snd=0D
serio_raw              16384  0=0D
ata_generic            16384  0=0D
pata_acpi              16384  0=0D
libcrc32c              16384  0=0D
crc8                   16384  0=0D
crc_itu_t              16384  0=0D
crc_ccitt              16384  0=0D
virtio_pci             24576  0=0D
virtio_mmio            16384  0=0D
virtio_input           16384  0=0D
virtio_balloon         16384  0=0D
virtio_scsi            20480  1=0D
sym53c8xx              81920  0=0D
scsi_transport_spi     32768  1 sym53c8xx=0D
megaraid_sas          110592  0=0D
megaraid_mbox          36864  0=0D
megaraid_mm            20480  1 megaraid_mbox=0D
megaraid               45056  0=0D
ideapad_laptop         24576  0=0D
rfkill                 24576  1 ideapad_laptop=0D
sparse_keymap          16384  1 ideapad_laptop=0D
video                  40960  1 ideapad_laptop=0D
virtio_net             28672  0=0D
virtio_gpu             45056  0=0D
ttm                    94208  1 virtio_gpu=0D
drm_kms_helper        118784  1 virtio_gpu=0D
drm                   339968  3 ttm,drm_kms_helper,virtio_gpu=0D
virtio_console         28672  0=0D
virtio_rng             16384  0=0D
virtio_blk             20480  0=0D
virtio_ring            20480  10 virtio_blk,virtio_gpu,virtio_net,virtio_pc=
i,virtio_rng,virtio_balloon,virtio_input,virtio_console,virtio_mmio,virtio_=
scsi=0D
virtio                 16384  10 virtio_blk,virtio_gpu,virtio_net,virtio_pc=
i,virtio_rng,virtio_balloon,virtio_input,virtio_console,virtio_mmio,virtio_=
scsi=0D
crc32                  16384  0=0D
Fri Sep  4 22:31:09 UTC 2015=0D
clocksource: refined-jiffies=0D
uptime: 36.57 0.68=0D
guestfsd --verbose=0D
trying to open virtio-serial channel '/dev/virtio-ports/org.libguestfs.chan=
nel.0'=0D
udevadm --debug settle=0D
calling: settle=0D
libguestfs: recv_from_daemon: received GUESTFS_LAUNCH_FLAG
libguestfs: [42410ms] appliance is up
libguestfs: trace: launch =3D 0
libguestfs: trace: part_disk "/dev/sda" "mbr"
guestfsd: main_loop: new request, len 0x3c=0D
udevadm --debug settle=0D
calling: settle=0D
parted -s -- /dev/sda mklabel msdos mkpart primary 128s -128s=0D
Warning: The resulting partition is not properly aligned for best performan=
ce.=0D
udevadm --debug settle=0D
[   41.087967]  sda: sda1=0D
calling: settle=0D
libguestfs: trace: part_disk =3D 0
libguestfs: trace: pvcreate "/dev/sda1"
guestfsd: main_loop: proc 210 (part_disk) took 4.42 seconds=0D
guestfsd: main_loop: new request, len 0x38=0D
lvm pvcreate --force /dev/sda1=0D
  /run/lvm/lvmetad.socket: connect failed: No such file or directory=0D
  WARNING: Failed to connect to lvmetad. Falling back to internal scanning.=
=0D
udevadm --debug settle=0D
calling: settle=0D
libguestfs: trace: pvcreate =3D 0
libguestfs: trace: vgcreate "VG" "/dev/sda1"
guestfsd: main_loop: proc 39 (pvcreate) took 1.27 seconds=0D
guestfsd: main_loop: new request, len 0x44=0D
lvm vgcreate VG /dev/sda1=0D
  /run/lvm/lvmetad.socket: connect failed: No such file or directory=0D
  WARNING: Failed to connect to lvmetad. Falling back to internal scanning.=
=0D
udevadm --debug settle=0D
calling: settle=0D
libguestfs: trace: vgcreate =3D 0
libguestfs: trace: lvcreate "LV1" "VG" 50
guestfsd: main_loop: proc 40 (vgcreate) took 1.36 seconds=0D
guestfsd: main_loop: new request, len 0x3c=0D
lvm lvcreate -L 50 -n LV1 VG=0D
  /run/lvm/lvmetad.socket: connect failed: No such file or directory=0D
  WARNING: Failed to connect to lvmetad. Falling back to internal scanning.=
=0D
udevadm --debug settle=0D
calling: settle=0D
libguestfs: trace: lvcreate =3D 0
libguestfs: trace: lvcreate "LV2" "VG" 50
guestfsd: main_loop: proc 41 (lvcreate) took 3.10 seconds=0D
guestfsd: main_loop: new request, len 0x3c=0D
lvm lvcreate -L 50 -n LV2 VG=0D
  /run/lvm/lvmetad.socket: connect failed: No such file or directory=0D
  WARNING: Failed to connect to lvmetad. Falling back to internal scanning.=
=0D
udevadm --debug settle=0D
calling: settle=0D
libguestfs: trace: lvcreate =3D 0
libguestfs: trace: lvremove "/dev/VG/LV1"
guestfsd: main_loop: proc 41 (lvcreate) took 3.18 seconds=0D
guestfsd: main_loop: new request, len 0x38=0D
lvm lvremove -f /dev/VG/LV1=0D
  /run/lvm/lvmetad.socket: connect failed: No such file or directory=0D
  WARNING: Failed to connect to lvmetad. Falling back to internal scanning.=
=0D
[   52.241272] XXX blk_throtl_drain: td=3Dffff88001b9b0200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001ba1a200 ->q/blkcg=3Dffff88001bf59d60/ffff=
ffff832d79a0=0D
[   52.241272] XXX pos_css=3Dffffffff832d79a0 / blkg=3Dffff88001ba1a200=0D
[   52.259269] XXX blk_throtl_drain: td=3Dffff88001b9b0200 ->queue=3Dffff88=
001bf59d60 ->root_blkg=3Dffff88001ba1a200 ->q/blkcg=3D          (null)/ffff=
ffff832d79a0=0D
[   52.259269] XXX pos_css=3Dffffffff832d79a0 /=0D
[   52.259269] BUG: unable to handle kernel NULL pointer dereference at 000=
00000000009c8=0D
[   52.259269] IP: [<ffffffff813f8b10>] __blkg_lookup+0x40/0xe0=0D
[   52.259269] PGD 0 =0D
[   52.259269] Oops: 0000 [#1] SMP =0D
[   52.259269] Modules linked in: kvm_amd kvm snd_pcsp snd_pcm snd_timer sn=
d soundcore serio_raw ata_generic pata_acpi libcrc32c crc8 crc_itu_t crc_cc=
itt virtio_pci virtio_mmio virtio_input virtio_balloon virtio_scsi sym53c8x=
x scsi_transport_spi megaraid_sas megaraid_mbox megaraid_mm megaraid ideapa=
d_laptop rfkill sparse_keymap video virtio_net virtio_gpu ttm drm_kms_helpe=
r drm virtio_console virtio_rng virtio_blk virtio_ring virtio crc32=0D
[   52.259269] CPU: 0 PID: 452 Comm: lvm Not tainted 4.3.0-0.rc0.git7.1.rwm=
j3.fc24.x86_64 #1=0D
[   52.259269] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.8.2-20150714_191134- 04/01/2014=0D
[   52.259269] task: ffff88001bb74000 ti: ffff88001bb78000 task.ti: ffff880=
01bb78000=0D
[   52.259269] RIP: 0010:[<ffffffff813f8b10>]  [<ffffffff813f8b10>] __blkg_=
lookup+0x40/0xe0=0D
[   52.259269] RSP: 0018:ffff88001bb7ba98  EFLAGS: 00000046=0D
[   52.259269] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 00000000000=
00001=0D
[   52.259269] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00000000000=
00046=0D
[   52.259269] RBP: ffff88001bb7bab8 R08: 0000000000000001 R09: 00000000000=
00001=0D
[   52.259269] R10: 0000000000000000 R11: 0000000000000001 R12: 00000000000=
00000=0D
[   52.259269] R13: ffffffff832d79a0 R14: 0000000000000000 R15: 00000000000=
00000=0D
[   52.259269] FS:  00007f53a9c4b840(0000) GS:ffff88001ec00000(0000) knlGS:=
0000000000000000=0D
[   52.259269] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0D
[   52.259269] CR2: 00000000000009c8 CR3: 000000001bacb000 CR4: 00000000000=
006f0=0D
[   52.259269] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000=0D
[   52.259269] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 00000000000=
00000=0D
[   52.259269] Stack:=0D
[   52.259269]  ffff88001b9b0200 ffff88001bf59d60 ffffffff832d79a0 ffff8800=
1bf5a780=0D
[   52.259269]  ffff88001bb7baf0 ffffffff813fcfe4 ffffffff813fcdb8 ffff8800=
1bf59d60=0D
[   52.259269]  ffffffff81f045c0 0000000000000000 ffff88001bf5a780 ffff8800=
1bb7bb08=0D
[   52.259269] Call Trace:=0D
[   52.259269]  [<ffffffff813fcfe4>] blk_throtl_drain+0x264/0x2d0=0D
[   52.259269]  [<ffffffff813fcdb8>] ? blk_throtl_drain+0x38/0x2d0=0D
[   52.259269]  [<ffffffff813f9c99>] blkcg_drain_queue+0x29/0x60=0D
[   52.259269]  [<ffffffff813d4805>] __blk_drain_queue+0xc5/0x1a0=0D
[   52.259269]  [<ffffffff813d634e>] blk_queue_bypass_start+0x6e/0xb0=0D
[   52.259269]  [<ffffffff813f7c09>] blkcg_deactivate_policy+0x39/0x100=0D
[   52.259269]  [<ffffffff813fd1a4>] blk_throtl_exit+0x34/0x50=0D
[   52.259269]  [<ffffffff813f9d05>] blkcg_exit_queue+0x35/0x40=0D
[   52.259269]  [<ffffffff813dc3de>] blk_release_queue+0x1e/0xd0=0D
[   52.259269]  [<ffffffff8140c98a>] kobject_release+0x7a/0x190=0D
[   52.259269]  [<ffffffff8140c847>] kobject_put+0x27/0x50=0D
[   52.259269]  [<ffffffff813d8177>] blk_cleanup_queue+0x187/0x270=0D
[   52.259269]  [<ffffffff816914fd>] cleanup_mapped_device+0xdd/0x100=0D
[   52.259269]  [<ffffffff816938f8>] __dm_destroy+0x1a8/0x2c0=0D
[   52.259269]  [<ffffffff81694dc3>] dm_destroy+0x13/0x20=0D
[   52.259269]  [<ffffffff8169a54d>] dev_remove+0x10d/0x170=0D
[   52.259269]  [<ffffffff8169a440>] ? dev_suspend+0x280/0x280=0D
[   52.259269]  [<ffffffff8169ac52>] ctl_ioctl+0x282/0x550=0D
[   52.259269]  [<ffffffff8169af33>] dm_ctl_ioctl+0x13/0x20=0D
[   52.259269]  [<ffffffff8127a54e>] do_vfs_ioctl+0x2ee/0x550=0D
[   52.259269]  [<ffffffff8184a15c>] ? __schedule+0x43c/0xdb0=0D
[   52.259269]  [<ffffffff810cbd05>] ? task_work_run+0xa5/0xc0=0D
[   52.259269]  [<ffffffff8112197d>] ? debug_lockdep_rcu_enabled+0x1d/0x20=
=0D
[   52.259269]  [<ffffffff8127a829>] SyS_ioctl+0x79/0x90=0D
[   52.259269]  [<ffffffff818515b2>] entry_SYSCALL_64_fastpath+0x12/0x76=0D
[   52.259269] Code: f4 41 89 d6 48 8b 9f 38 01 00 00 e8 6b 8e d2 ff 85 c0 =
74 09 80 3d af 9d b7 00 00 74 56 48 85 db 74 09 4c 39 23 0f 84 9a 00 00 00 =
<49> 63 b4 24 c8 09 00 00 49 8d bd 28 01 00 00 e8 ec 71 01 00 48 =0D
[   52.259269] RIP  [<ffffffff813f8b10>] __blkg_lookup+0x40/0xe0=0D
[   52.259269]  RSP <ffff88001bb7ba98>=0D
[   52.259269] CR2: 00000000000009c8=0D
[   52.259269] ---[ end trace 4190566fb546234f ]---=0D
[   52.259269] BUG: sleeping function called from invalid context at includ=
e/linux/sched.h:2733=0D
[   52.259269] in_atomic(): 1, irqs_disabled(): 1, pid: 452, name: lvm=0D
[   52.259269] INFO: lockdep is turned off.=0D
[   52.259269] irq event stamp: 91580=0D
[   52.259269] hardirqs last  enabled at (91579): [<ffffffff81850b6c>] _raw=
_spin_unlock_irq+0x2c/0x40=0D
[   52.259269] hardirqs last disabled at (91580): [<ffffffff8185093f>] _raw=
_spin_lock_irq+0x1f/0x80=0D
[   52.259269] softirqs last  enabled at (91574): [<ffffffff810adf80>] __do=
_softirq+0x380/0x490=0D
[   52.259269] softirqs last disabled at (91569): [<ffffffff810ae2d2>] irq_=
exit+0x112/0x120=0D
[   52.259269] CPU: 0 PID: 452 Comm: lvm Tainted: G      D         4.3.0-0.=
rc0.git7.1.rwmj3.fc24.x86_64 #1=0D
[   52.259269] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.8.2-20150714_191134- 04/01/2014=0D
[   52.259269]  0000000000000000 0000000018c37f6d ffff88001bb7b770 ffffffff=
818478f1=0D
[   52.259269]  ffff88001bb74000 ffff88001bb7b798 ffffffff810d5369 ffffffff=
81c83a79=0D
[   52.259269]  0000000000000aad 0000000000000000 ffff88001bb7b7c0 ffffffff=
810d5469=0D
[   52.259269] Call Trace:=0D
[   52.259269]  [<ffffffff818478f1>] dump_stack+0x4b/0x63=0D
[   52.259269]  [<ffffffff810d5369>] ___might_sleep+0x179/0x230=0D
[   52.259269]  [<ffffffff810d5469>] __might_sleep+0x49/0x80=0D
[   52.259269]  [<ffffffff810ba923>] exit_signals+0x33/0x150=0D
[   52.259269]  [<ffffffff810ab559>] do_exit+0xc9/0xc30=0D
[   52.259269]  [<ffffffff81118cc1>] ? kmsg_dump+0x151/0x1a0=0D
[   52.259269]  [<ffffffff81118ba4>] ? kmsg_dump+0x34/0x1a0=0D
[   52.259269]  [<ffffffff8101de5a>] oops_end+0x9a/0xd0=0D
[   52.259269]  [<ffffffff8106cdd5>] no_context+0x135/0x390=0D
[   52.259269]  [<ffffffff8152dbf2>] ? serial8250_console_write+0x252/0x2d0=
=0D
[   52.259269]  [<ffffffff8106d0b8>] __bad_area_nosemaphore+0x88/0x200=0D
[   52.259269]  [<ffffffff8106d243>] bad_area_nosemaphore+0x13/0x20=0D
[   52.259269]  [<ffffffff8106d525>] __do_page_fault+0xd5/0x470=0D
[   52.259269]  [<ffffffff8111790a>] ? console_unlock+0x1da/0x580=0D
[   52.259269]  [<ffffffff8106d8ef>] do_page_fault+0x2f/0x80=0D
[   52.259269]  [<ffffffff81852157>] ? native_iret+0x7/0x7=0D
[   52.259269]  [<ffffffff818539f8>] page_fault+0x28/0x30=0D
[   52.259269]  [<ffffffff813f8b10>] ? __blkg_lookup+0x40/0xe0=0D
[   52.259269]  [<ffffffff813f8b5d>] ? __blkg_lookup+0x8d/0xe0=0D
[   52.259269]  [<ffffffff813fcfe4>] blk_throtl_drain+0x264/0x2d0=0D
[   52.259269]  [<ffffffff813fcdb8>] ? blk_throtl_drain+0x38/0x2d0=0D
[   52.259269]  [<ffffffff813f9c99>] blkcg_drain_queue+0x29/0x60=0D
[   52.259269]  [<ffffffff813d4805>] __blk_drain_queue+0xc5/0x1a0=0D
[   52.259269]  [<ffffffff813d634e>] blk_queue_bypass_start+0x6e/0xb0=0D
[   52.259269]  [<ffffffff813f7c09>] blkcg_deactivate_policy+0x39/0x100=0D
[   52.259269]  [<ffffffff813fd1a4>] blk_throtl_exit+0x34/0x50=0D
[   52.259269]  [<ffffffff813f9d05>] blkcg_exit_queue+0x35/0x40=0D
[   52.259269]  [<ffffffff813dc3de>] blk_release_queue+0x1e/0xd0=0D
[   52.259269]  [<ffffffff8140c98a>] kobject_release+0x7a/0x190=0D
[   52.259269]  [<ffffffff8140c847>] kobject_put+0x27/0x50=0D
[   52.259269]  [<ffffffff813d8177>] blk_cleanup_queue+0x187/0x270=0D
[   52.259269]  [<ffffffff816914fd>] cleanup_mapped_device+0xdd/0x100=0D
[   52.259269]  [<ffffffff816938f8>] __dm_destroy+0x1a8/0x2c0=0D
[   52.259269]  [<ffffffff81694dc3>] dm_destroy+0x13/0x20=0D
[   52.259269]  [<ffffffff8169a54d>] dev_remove+0x10d/0x170=0D
[   52.259269]  [<ffffffff8169a440>] ? dev_suspend+0x280/0x280=0D
[   52.259269]  [<ffffffff8169ac52>] ctl_ioctl+0x282/0x550=0D
[   52.259269]  [<ffffffff8169af33>] dm_ctl_ioctl+0x13/0x20=0D
[   52.259269]  [<ffffffff8127a54e>] do_vfs_ioctl+0x2ee/0x550=0D
[   52.259269]  [<ffffffff8184a15c>] ? __schedule+0x43c/0xdb0=0D
[   52.259269]  [<ffffffff810cbd05>] ? task_work_run+0xa5/0xc0=0D
[   52.259269]  [<ffffffff8112197d>] ? debug_lockdep_rcu_enabled+0x1d/0x20=
=0D
[   52.259269]  [<ffffffff8127a829>] SyS_ioctl+0x79/0x90=0D
[   52.259269]  [<ffffffff818515b2>] entry_SYSCALL_64_fastpath+0x12/0x76=0D
[   52.259269] note: lvm[452] exited with preempt_count 2=0D
guestfsd: error:   /run/lvm/lvmetad.socket: connect failed: No such file or=
 directory=0D
  WARNING: Failed to connect to lvmetad. Falling back to internal scanning.=
=0D
libguestfs: trace: lvremove =3D -1 (error)
*stdin*:9: libguestfs: error: lvremove:   /run/lvm/lvmetad.socket: connect =
failed: No such file or directory
  WARNING: Failed to connect to lvmetad. Falling back to internal scanning.
libguestfs: trace: close
libguestfs: closing guestfs handle 0x5637883ebe60 (state 2)
libguestfs: trace: internal_autosync
guestfsd: main_loop: proc 77 (lvremove) took 1.21 seconds=0D
guestfsd: main_loop: new request, len 0x28=0D
umount-all: /proc/mounts: fsname=3D/dev/root dir=3D/ type=3Dext2 opts=3Drw,=
noatime freq=3D0 passno=3D0=0D
umount-all: /proc/mounts: fsname=3D/proc dir=3D/proc type=3Dproc opts=3Drw,=
relatime freq=3D0 passno=3D0=0D
umount-all: /proc/mounts: fsname=3D/sys dir=3D/sys type=3Dsysfs opts=3Drw,r=
elatime freq=3D0 passno=3D0=0D
umount-all: /proc/mounts: fsname=3Dtmpfs dir=3D/run type=3Dtmpfs opts=3Drw,=
nosuid,relatime,size=3D93808k,mode=3D755 freq=3D0 passno=3D0=0D
umount-all: /proc/mounts: fsname=3D/dev dir=3D/dev type=3Ddevtmpfs opts=3Dr=
w,relatime,size=3D230832k,nr_inodes=3D57708,mode=3D755 freq=3D0 passno=3D0=
=0D
fsync /dev/sda=0D
libguestfs: trace: internal_autosync =3D 0
libguestfs: calling virDomainDestroy "guestfs-dnsycku3ayrd2wns" flags=3D0
libguestfs: command: run: rm
libguestfs: command: run: \ -rf /tmp/libguestfsXVD2Sq

--/9DWx/yDrRhgMJTb--
