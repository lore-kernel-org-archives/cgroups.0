From: "Richard W.M. Jones" <rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: __blkg_lookup oops with 4.2-rcX
Date: Fri, 4 Sep 2015 19:17:01 +0100
Message-ID: <20150904181700.GO29283@redhat.com>
References: <CA+5PVA5rzQ0s4723n5rHBcxQa9t0cW8BPPBekr_9aMRoWt2aYg@mail.gmail.com>
 <20150902145307.GG22326@mtj.duckdns.org>
 <20150902153255.GH22326@mtj.duckdns.org>
 <20150904104602.GN29283@redhat.com>
 <20150904171302.GE25329@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="xP4xvRzdEG0QZ+Pj"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150904171302.GE25329-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, msnitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


--xP4xvRzdEG0QZ+Pj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 04, 2015 at 01:13:02PM -0400, Tejun Heo wrote:
> > [    6.784689] BUG: unable to handle kernel NULL pointer dereference at 0000000000000bb8
> > [    6.787605] IP: [<ffffffff814107a0>] blk_throtl_drain+0x80/0x220
> 
> The only struct which is large enough for 0xbb8 offset is
> request_queue.  Hmm.... can you please try the brute force debug patch
> below and report the kernel log after the crash?

I'll test your patch very soon, after I've recompiled the kernel with it.

I just wanted to say that I was working on a better reproducer using a
newer kernel, and now I have got one.  It is this:

  guestfish -v -x <<EOF
    disk-create test1.img raw 500M
    add-drive test1.img format:raw cachemode:unsafe
    run
    part-disk /dev/sda mbr
    pvcreate /dev/sda1
    vgcreate VG /dev/sda1
    lvcreate LV1 VG 50
    lvcreate LV2 VG 50
    lvremove /dev/VG/LV1
  EOF

The output of this command (when it fails, which is not 100% reliably,
but is probably > 50%) is attached.

To explain what the command above does:

(1) It creates a 500 MB sparse file called 'test1.img'.

(2) It creates a small, short-lived VM, using qemu, adding 'test1.img'
to the qemu command line.  Setting 'cachemode:unsafe' seems to be
either important, or makes the bug reproduce much more often.  This
corresponds to the qemu option '-drive file=test1.img,cache=unsafe'
and should be below the level that the kernel sees, so should make no
difference.

(3) It boots the VM.

(4) It runs some parted and LVM commands -- see the attached log file
for precisely what commands are run.

(5) The final command (lvremove) fails, with the stacktrace seen in
the attachment.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-df lists disk usage of guests without needing to install any
software inside the virtual machine.  Supports Linux and Windows.
http://people.redhat.com/~rjones/virt-df/

--xP4xvRzdEG0QZ+Pj
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
libguestfs: launch: tmpdir=3D/tmp/libguestfsEfp5po
libguestfs: launch: umask=3D0002
libguestfs: launch: euid=3D1000
libguestfs: libvirt version =3D 1002019 (1.2.19)
libguestfs: guest random name =3D guestfs-zlr3zvogh5lilmw3
libguestfs: [00000ms] connect to libvirt
libguestfs: opening libvirt handle: URI =3D qemu:///session, auth =3D defau=
lt+wrapper, flags =3D 0
libguestfs: successfully opened libvirt handle: conn =3D 0x557415049ec0
libguestfs: qemu version (reported by libvirt) =3D 2004000 (2.4.0)
libguestfs: [00003ms] get libvirt capabilities
libguestfs: [00670ms] parsing capabilities XML
libguestfs: trace: get_backend_setting "force_tcg"
libguestfs: trace: get_backend_setting =3D NULL (error)
libguestfs: trace: get_backend_setting "internal_libvirt_label"
libguestfs: trace: get_backend_setting =3D NULL (error)
libguestfs: trace: get_backend_setting "internal_libvirt_imagelabel"
libguestfs: trace: get_backend_setting =3D NULL (error)
libguestfs: trace: get_backend_setting "internal_libvirt_norelabel_disks"
libguestfs: trace: get_backend_setting =3D NULL (error)
libguestfs: [00672ms] build appliance
libguestfs: trace: get_cachedir
libguestfs: trace: get_cachedir =3D "/var/tmp"
libguestfs: [00672ms] begin building supermin appliance
libguestfs: [00672ms] run supermin
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
libguestfs: [00692ms] finished building supermin appliance
libguestfs: trace: disk_create "/tmp/libguestfsEfp5po/overlay1" "qcow2" -1 =
"backingfile:/var/tmp/.guestfs-1000/appliance.d/root" "backingformat:raw"
libguestfs: command: run: qemu-img
libguestfs: command: run: \ create
libguestfs: command: run: \ -f qcow2
libguestfs: command: run: \ -o backing_file=3D/var/tmp/.guestfs-1000/applia=
nce.d/root,backing_fmt=3Draw
libguestfs: command: run: \ /tmp/libguestfsEfp5po/overlay1
Formatting '/tmp/libguestfsEfp5po/overlay1', fmt=3Dqcow2 size=3D4294967296 =
backing_file=3D'/var/tmp/.guestfs-1000/appliance.d/root' backing_fmt=3D'raw=
' encryption=3Doff cluster_size=3D65536 lazy_refcounts=3Doff refcount_bits=
=3D16
libguestfs: trace: disk_create =3D 0
libguestfs: [00812ms] create libvirt XML
libguestfs: command: run: dmesg | grep -Eoh 'lpj=3D[[:digit:]]+'
libguestfs: read_lpj_from_dmesg: calculated lpj=3D3515548
libguestfs: trace: get_cachedir
libguestfs: trace: get_cachedir =3D "/var/tmp"
libguestfs: libvirt XML:\n<?xml version=3D"1.0"?>\n<domain type=3D"qemu" xm=
lns:qemu=3D"http://libvirt.org/schemas/domain/qemu/1.0">\n  <name>guestfs-z=
lr3zvogh5lilmw3</name>\n  <memory unit=3D"MiB">500</memory>\n  <currentMemo=
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
ource file=3D"/tmp/libguestfsEfp5po/overlay1"/>\n      <target dev=3D"sdb" =
bus=3D"scsi"/>\n      <driver name=3D"qemu" type=3D"qcow2" cache=3D"unsafe"=
/>\n      <address type=3D"drive" controller=3D"0" bus=3D"0" target=3D"1" u=
nit=3D"0"/>\n      <shareable/>\n    </disk>\n    <serial type=3D"unix">\n =
     <source mode=3D"connect" path=3D"/tmp/libguestfsEfp5po/console.sock"/>=
\n      <target port=3D"0"/>\n    </serial>\n    <channel type=3D"unix">\n =
     <source mode=3D"connect" path=3D"/tmp/libguestfsEfp5po/guestfsd.sock"/=
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
libguestfs: total 0
libguestfs: drwxr-xr-x. 3 rjones rjones unconfined_u:object_r:user_tmp_t:s0=
  35 Sep  4 13:35 .
libguestfs: drwxrwxrwt. 4 root   root   system_u:object_r:tmp_t:s0         =
 101 Sep  4 12:41 ..
libguestfs: drwxr-xr-x. 2 rjones rjones unconfined_u:object_r:user_tmp_t:s0=
  43 Sep  4 12:41 appliance.d
libguestfs: -rw-r--r--. 1 rjones rjones unconfined_u:object_r:user_tmp_t:s0=
   0 Sep  4 12:41 lock
libguestfs:=20
libguestfs: /var/tmp/.guestfs-1000/appliance.d:
libguestfs: total 341960
libguestfs: drwxr-xr-x. 2 rjones rjones unconfined_u:object_r:user_tmp_t:s0=
         43 Sep  4 12:41 .
libguestfs: drwxr-xr-x. 3 rjones rjones unconfined_u:object_r:user_tmp_t:s0=
         35 Sep  4 13:35 ..
libguestfs: -rw-r--r--. 1 rjones rjones system_u:object_r:virt_content_t:s0=
    1478144 Sep  4 13:35 initrd
libguestfs: -rwxr-xr-x. 1 rjones rjones system_u:object_r:virt_content_t:s0=
    6576376 Sep  4 13:35 kernel
libguestfs: -rw-r--r--. 1 rjones rjones system_u:object_r:virt_content_t:s0=
 4294967296 Sep  4 13:35 root
libguestfs: command: run: ls
libguestfs: command: run: \ -a
libguestfs: command: run: \ -l
libguestfs: command: run: \ -Z /tmp/libguestfsEfp5po
libguestfs: total 200
libguestfs: drwxr-xr-x.  2 rjones rjones unconfined_u:object_r:user_tmp_t:s=
0     78 Sep  4 13:35 .
libguestfs: drwxrwxrwt. 13 root   root   system_u:object_r:tmp_t:s0        =
    4096 Sep  4 13:35 ..
libguestfs: srwxrwxr-x.  1 rjones rjones unconfined_u:object_r:user_tmp_t:s=
0      0 Sep  4 13:35 console.sock
libguestfs: srwxrwxr-x.  1 rjones rjones unconfined_u:object_r:user_tmp_t:s=
0      0 Sep  4 13:35 guestfsd.sock
libguestfs: -rw-r--r--.  1 rjones rjones unconfined_u:object_r:user_tmp_t:s=
0 197120 Sep  4 13:35 overlay1
libguestfs: -rwxrwxr-x.  1 rjones rjones unconfined_u:object_r:user_tmp_t:s=
0      0 Sep  4 13:35 umask-check
libguestfs: [00832ms] launch libvirt guest
\x1b[1;256r\x1b[256;256H\x1b[6n=0D
Google, Inc.=0D
Serial Graphics Adapter 06/19/15=0D
SGABIOS $Id: sgabios.S 8 2010-04-22 00:03:40Z nlaredo $ (mockbuild@) Fri Ju=
n 19 00:52:18 UTC 2015=0D
Term: 80x24=0D
4 0=0D
\x1b[2J=0DSeaBIOS (version 1.8.2-20150714_191134-)=0D=0D
=0DMachine UUID 4803075c-aaef-b14e-8acb-b4d47bf7dc84=0D=0D
=0DBooting from ROM...=0D=0D
=0DProbing EDD (edd=3Doff to disable)... ok=0D=0D
\x1b[2J[    0.000000] Initializing cgroup subsys cpuset=0D
[    0.000000] Initializing cgroup subsys cpu=0D
[    0.000000] Initializing cgroup subsys cpuacct=0D
[    0.000000] Linux version 4.2.0-1.fc24.x86_64+debug (mockbuild@bkernel01=
=2Ephx2.fedoraproject.org) (gcc version 5.1.1 20150618 (Red Hat 5.1.1-4) (G=
CC) ) #1 SMP Mon Aug 31 15:39:13 UTC 2015=0D
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
[    0.000000] RAMDISK: [mem 0x1f297000-0x1f3fffff]=0D
[    0.000000] No NUMA configuration found=0D
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000001f3fffff]=
=0D
[    0.000000] NODE_DATA(0) allocated [mem 0x1f282000-0x1f296fff]=0D
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
[    0.000000] setup_percpu: NR_CPUS:1024 nr_cpumask_bits:1 nr_cpu_ids:1 nr=
_node_ids:1=0D
[    0.000000] PERCPU: Embedded 482 pages/cpu @ffff88001ec00000 s1936536 r8=
192 d29544 u2097152=0D
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 125881=0D
[    0.000000] Policy zone: DMA32=0D
[    0.000000] Kernel command line: panic=3D1 console=3DttyS0 udevtimeout=
=3D6000 udev.event-timeout=3D6000 no_timer_check lpj=3D3515548 acpi=3Doff p=
rintk.time=3D1 cgroup_disable=3Dmemory root=3D/dev/sdb selinux=3D0 guestfs_=
verbose=3D1 TERM=3Dxterm-256color=0D
[    0.000000] Disabling memory control group subsystem=0D
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)=0D
[    0.000000] Memory: 463172K/511608K available (8667K kernel code, 1440K =
rwdata, 3548K rodata, 3536K init, 16576K bss, 48436K reserved, 0K cma-reser=
ved)=0D
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1=0D
[    0.000000] Running RCU self tests=0D
[    0.000000] Hierarchical RCU implementation.=0D
[    0.000000] \tRCU lockdep checking is enabled.=0D
[    0.000000] \tBuild-time adjustment of leaf fanout to 64.=0D
[    0.000000] \tRCU restricting CPUs from NR_CPUS=3D1024 to nr_cpu_ids=3D1=
=2E=0D
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D64, nr_cpu_ids=
=3D1=0D
[    0.000000] kmemleak: Kernel memory leak detector disabled=0D
[    0.000000] NR_IRQS:65792 nr_irqs:256 16=0D
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
[    0.010000] pid_max: default: 32768 minimum: 301=0D
[    0.015000] Security Framework initialized=0D
[    0.015000] SELinux:  Disabled at boot.=0D
[    0.015000] Yama: becoming mindful.=0D
[    0.026000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)=0D
[    0.030000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)=0D
[    0.032000] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)=
=0D
[    0.032000] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)=0D
[    0.072000] Initializing cgroup subsys blkio=0D
[    0.074000] Initializing cgroup subsys memory=0D
[    0.075000] Initializing cgroup subsys devices=0D
[    0.076000] Initializing cgroup subsys freezer=0D
[    0.077000] Initializing cgroup subsys net_cls=0D
[    0.077000] Initializing cgroup subsys perf_event=0D
[    0.078000] Initializing cgroup subsys net_prio=0D
[    0.078000] Initializing cgroup subsys hugetlb=0D
[    0.082000] mce: CPU supports 10 MCE banks=0D
[    0.084000] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0=0D
[    0.084000] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0=0D
[    0.550000] Freeing SMP alternatives memory: 28K (ffffffff822de000 - fff=
fffff822e5000)=0D
[    0.571000] ftrace: allocating 28939 entries in 114 pages=0D
[    0.695000] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1=0D
[    0.798000] smpboot: CPU0: AMD QEMU Virtual CPU version 2.4.0 (fam: 06, =
model: 06, stepping: 03)=0D
[    0.800000] Performance Events: Broken PMU hardware detected, using soft=
ware events only.=0D
[    0.801000] Failed to access perfctr msr (MSR c0010007 is 0)=0D
[    0.844000] x86: Booted up 1 node, 1 CPUs=0D
[    0.844000] smpboot: Total of 1 processors activated (7031.09 BogoMIPS)=
=0D
[    0.847000] NMI watchdog: disabled (cpu0): hardware events not enabled=0D
[    0.847000] NMI watchdog: Shutting down hard lockup detector on all cpus=
=0D
[    0.894000] devtmpfs: initialized=0D
[    0.955000] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xfffffff=
f, max_idle_ns: 1911260446275000 ns=0D
[    0.962000] atomic64_test: passed for x86-64 platform with CX8 and with =
SSE=0D
[    0.962000] pinctrl core: initialized pinctrl subsystem=0D
[    0.969000] RTC time: 17:35:54, date: 09/04/15=0D
[    0.985000] NET: Registered protocol family 16=0D
[    1.009000] cpuidle: using governor menu=0D
[    1.021000] PCI: Using configuration type 1 for base access=0D
[    1.233000] ACPI: Interpreter disabled.=0D
[    1.249000] vgaarb: loaded=0D
[    1.258000] SCSI subsystem initialized=0D
[    1.266000] usbcore: registered new interface driver usbfs=0D
[    1.267000] usbcore: registered new interface driver hub=0D
[    1.269000] usbcore: registered new device driver usb=0D
[    1.277000] PCI: Probing PCI hardware=0D
[    1.282000] PCI host bridge to bus 0000:00=0D
[    1.283000] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]=0D
[    1.284000] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffff=
fff]=0D
[    1.284000] pci_bus 0000:00: No busn resource found for root bus, will u=
se [bus 00-ff]=0D
[    1.308000] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]=0D
[    1.308000] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]=0D
[    1.308000] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]=0D
[    1.309000] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]=0D
[    1.381000] pci 0000:00:01.0: PIIX/ICH IRQ router [8086:7000]=0D
[    1.410000] NetLabel: Initializing=0D
[    1.410000] NetLabel:  domain hash size =3D 128=0D
[    1.411000] NetLabel:  protocols =3D UNLABELED CIPSOv4=0D
[    1.413000] NetLabel:  unlabeled traffic allowed by default=0D
[    1.418000] clocksource: Switched to clocksource refined-jiffies=0D
[    2.391851] pnp: PnP ACPI: disabled=0D
[    2.582822] NET: Registered protocol family 2=0D
[    2.608818] TCP established hash table entries: 4096 (order: 3, 32768 by=
tes)=0D
[    2.610818] TCP bind hash table entries: 4096 (order: 6, 327680 bytes)=0D
[    2.614818] TCP: Hash tables configured (established 4096 bind 4096)=0D
[    2.616817] UDP hash table entries: 256 (order: 3, 49152 bytes)=0D
[    2.617817] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)=0D
[    2.622816] NET: Registered protocol family 1=0D
[    2.623816] pci 0000:00:00.0: Limiting direct PCI/PCI transfers=0D
[    2.624816] pci 0000:00:01.0: PIIX3: Enabling Passive Release=0D
[    2.624816] pci 0000:00:01.0: Activating ISA DMA hang workarounds=0D
[    2.626816] pci 0000:00:01.2: PCI->APIC IRQ transform: INT D -> IRQ 11=0D
[    2.643813] Unpacking initramfs...=0D
[    2.787791] Freeing initrd memory: 1444K (ffff88001f297000 - ffff88001f4=
00000)=0D
[    3.149736] DMA-API: preallocated 65536 debug entries=0D
[    3.150736] DMA-API: debugging enabled by kernel config=0D
[    3.154735] platform rtc_cmos: registered platform RTC device (no PNP de=
vice found)=0D
[    3.155735] microcode: AMD CPU family 0x6 not supported=0D
[    3.178732] Scanning for low memory corruption every 60 seconds=0D
[    3.204728] cryptomgr_test (28) used greatest stack depth: 14040 bytes l=
eft=0D
[    3.227724] futex hash table entries: 256 (order: 3, 32768 bytes)=0D
[    3.229724] Initialise system trusted keyring=0D
[    3.233723] audit: initializing netlink subsys (disabled)=0D
[    3.235723] audit: type=3D2000 audit(1441388156.235:1): initialized=0D
[    3.257720] HugeTLB registered 2 MB page size, pre-allocated 0 pages=0D
[    3.547676] zpool: loaded=0D
[    3.547676] zbud: loaded=0D
[    3.564673] VFS: Disk quotas dquot_6.6.0=0D
[    3.569672] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 byte=
s)=0D
[    3.629663] Key type big_key registered=0D
[    3.651660] cryptomgr_test (35) used greatest stack depth: 13480 bytes l=
eft=0D
[    3.780640] cryptomgr_test (53) used greatest stack depth: 12984 bytes l=
eft=0D
[    3.819634] NET: Registered protocol family 38=0D
[    3.822634] Key type asymmetric registered=0D
[    3.823634] Asymmetric key parser 'x509' registered=0D
[    3.824634] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)=0D
[    3.834632] io scheduler noop registered=0D
[    3.834632] io scheduler deadline registered=0D
[    3.839631] io scheduler cfq registered (default)=0D
[    3.867627] pci_hotplug: PCI Hot Plug PCI Core version: 0.5=0D
[    3.868627] pciehp: PCI Express Hot Plug Controller Driver version: 0.4=
=0D
[    3.883625] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled=0D
[    3.890624] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115=
200) is a 16550A=0D
[    3.946615] Non-volatile memory driver v1.3=0D
[    3.949615] Linux agpgart interface v0.103=0D
[    4.025603] scsi host0: ata_piix=0D
[    4.037601] scsi host1: ata_piix=0D
[    4.042601] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc0a0 irq 1=
4=0D
[    4.042601] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc0a8 irq 1=
5=0D
[    4.065597] libphy: Fixed MDIO Bus: probed=0D
[    4.072596] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver=0D
[    4.072596] ehci-pci: EHCI PCI platform driver=0D
[    4.074596] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver=0D
[    4.074596] ohci-pci: OHCI PCI platform driver=0D
[    4.075595] uhci_hcd: USB Universal Host Controller Interface driver=0D
[    4.077595] uhci_hcd 0000:00:01.2: PCI->APIC IRQ transform: INT D -> IRQ=
 11=0D
[    4.081595] uhci_hcd 0000:00:01.2: UHCI Host Controller=0D
[    4.095592] uhci_hcd 0000:00:01.2: new USB bus registered, assigned bus =
number 1=0D
[    4.097592] uhci_hcd 0000:00:01.2: detected 2 ports=0D
[    4.099592] uhci_hcd 0000:00:01.2: irq 11, io base 0x0000c040=0D
[    4.114590] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001=0D
[    4.115589] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1=0D
[    4.115589] usb usb1: Product: UHCI Host Controller=0D
[    4.115589] usb usb1: Manufacturer: Linux 4.2.0-1.fc24.x86_64+debug uhci=
_hcd=0D
[    4.116589] usb usb1: SerialNumber: 0000:00:01.2=0D
[    4.144585] hub 1-0:1.0: USB hub found=0D
[    4.146585] hub 1-0:1.0: 2 ports detected=0D
[    4.176580] usbcore: registered new interface driver usbserial=0D
[    4.177580] usbcore: registered new interface driver usbserial_generic=0D
[    4.179580] usbserial: USB Serial support registered for generic=0D
[    4.182579] i8042: PNP: No PS/2 controller found. Probing ports directly=
=2E=0D
[    4.194577] serio: i8042 KBD port at 0x60,0x64 irq 1=0D
[    4.195577] serio: i8042 AUX port at 0x60,0x64 irq 12=0D
[    4.218574] mousedev: PS/2 mouse device common for all mice=0D
[    4.243570] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0=0D
[    4.245570] rtc_cmos rtc_cmos: alarms up to one day, 114 bytes nvram=0D
[    4.254568] device-mapper: uevent: version 1.0.3=0D
[    4.275565] device-mapper: ioctl: 4.32.0-ioctl (2015-6-26) initialised: =
dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org=0D
[    4.304561] hidraw: raw HID events driver (C) Jiri Kosina=0D
[    4.309560] usbcore: registered new interface driver usbhid=0D
[    4.309560] usbhid: USB HID core driver=0D
[    4.311560] drop_monitor: Initializing network drop monitor service=0D
[    4.316559] ip_tables: (C) 2000-2006 Netfilter Core Team=0D
[    4.323558] Initializing XFRM netlink socket=0D
[    4.341555] NET: Registered protocol family 10=0D
[    4.371550] mip6: Mobile IPv6=0D
[    4.372550] NET: Registered protocol family 17=0D
[    4.395547] Loading compiled-in X.509 certificates=0D
[    4.411544] Loaded X.509 cert 'Fedora kernel signing key: b81f089d1552da=
190bef4260abd6c8a0b37a4a9a'=0D
[    4.414544] registered taskstats version 1=0D
[    4.417544] zswap: loading zswap=0D
[    4.418543] zswap: using zbud pool=0D
[    4.418543] zswap: using lzo compressor=0D
[    4.452538]   Magic number: 15:151:592=0D
[    4.453538] rtc_cmos rtc_cmos: setting system clock to 2015-09-04 17:35:=
58 UTC (1441388158)=0D
[    4.558522] Freeing unused kernel memory: 3536K (ffffffff81f6a000 - ffff=
ffff822de000)=0D
[    4.558522] Write protecting the kernel read-only data: 14336k=0D
[    4.583518] Freeing unused kernel memory: 1560K (ffff88000187a000 - ffff=
880001a00000)=0D
[    4.591517] Freeing unused kernel memory: 548K (ffff880001d77000 - ffff8=
80001e00000)=0D
supermin: mounting /proc=0D
supermin: uptime: 4.68 0.67=0D
supermin: ext2 mini initrd starting up: 5.1.13 zlib xz=0D
supermin: cmdline: panic=3D1 console=3DttyS0 udevtimeout=3D6000 udev.event-=
timeout=3D6000 no_timer_check lpj=3D3515548 acpi=3Doff printk.time=3D1 cgro=
up_disable=3Dmemory root=3D/dev/sdb selinux=3D0 guestfs_verbose=3D1 TERM=3D=
xterm-256color=0D
supermin: mounting /sys=0D
supermin: internal insmod crc32-pclmul.ko.xz=0D
supermin: running xz=0D
done with xz 8487 read=0D
[    4.813483] PCLMULQDQ-NI instructions are not detected.=0D
insmod: init_module: crc32-pclmul.ko.xz: No such device=0D
supermin: internal insmod crc32c-intel.ko.xz=0D
supermin: running xz=0D
done with xz 19951 read=0D
insmod: init_module: crc32c-intel.ko.xz: No such device=0D
supermin: internal insmod crct10dif-pclmul.ko.xz=0D
supermin: running xz=0D
done with xz 11031 read=0D
insmod: init_module: crct10dif-pclmul.ko.xz: No such device=0D
supermin: internal insmod crc32.ko.xz=0D
supermin: running xz=0D
done with xz 6303 read=0D
supermin: internal insmod virtio.ko.xz=0D
supermin: running xz=0D
done with xz 15215 read=0D
supermin: internal insmod virtio_ring.ko.xz=0D
supermin: running xz=0D
done with xz 19823 read=0D
supermin: internal insmod virtio_blk.ko.xz=0D
supermin: running xz=0D
done with xz 23919 read=0D
supermin: internal insmod virtio-rng.ko.xz=0D
supermin: running xz=0D
done with xz 8959 read=0D
supermin: internal insmod virtio_console.ko.xz=0D
supermin: running xz=0D
done with xz 45839 read=0D
supermin: internal insmod drm.ko.xz=0D
supermin: running xz=0D
[    5.142433] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input1=0D
[    5.193426] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input2=0D
done with xz 547063 read=0D
[    5.426390] [drm] Initialized drm 1.1.0 20060810=0D
supermin: internal insmod drm_kms_helper.ko.xz=0D
supermin: running xz=0D
done with xz 172615 read=0D
supermin: internal insmod ttm.ko.xz=0D
supermin: running xz=0D
done with xz 144711 read=0D
supermin: internal insmod virtio-gpu.ko.xz=0D
supermin: running xz=0D
done with xz 66847 read=0D
supermin: internal insmod ideapad_slidebar.ko.xz=0D
supermin: running xz=0D
done with xz 13359 read=0D
[    5.681351] ideapad_slidebar: DMI does not match=0D
insmod: init_module: ideapad_slidebar.ko.xz: No such device=0D
supermin: internal insmod virtio_net.ko.xz=0D
supermin: running xz=0D
done with xz 49367 read=0D
supermin: internal insmod video.ko.xz=0D
supermin: running xz=0D
done with xz 50159 read=0D
supermin: internal insmod sparse-keymap.ko.xz=0D
supermin: running xz=0D
done with xz 8951 read=0D
supermin: internal insmod rfkill.ko.xz=0D
supermin: running xz=0D
done with xz 43967 read=0D
supermin: internal insmod ideapad-laptop.ko.xz=0D
supermin: running xz=0D
done with xz 26527 read=0D
supermin: internal insmod megaraid.ko.xz=0D
supermin: running xz=0D
done with xz 64279 read=0D
supermin: internal insmod megaraid_mm.ko.xz=0D
supermin: running xz=0D
done with xz 22327 read=0D
[    5.930314] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)=0D
supermin: internal insmod megaraid_mbox.ko.xz=0D
supermin: running xz=0D
done with xz 55687 read=0D
[    5.975307] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 20=
06)=0D
supermin: internal insmod megaraid_sas.ko.xz=0D
supermin: running xz=0D
done with xz 160327 read=0D
[    6.065293] megasas: 06.807.10.00-rc1=0D
supermin: internal insmod scsi_transport_spi.ko.xz=0D
supermin: running xz=0D
done with xz 46695 read=0D
supermin: internal insmod sym53c8xx.ko.xz=0D
supermin: running xz=0D
done with xz 119215 read=0D
supermin: internal insmod virtio_scsi.ko.xz=0D
supermin: running xz=0D
done with xz 27871 read=0D
supermin: internal insmod virtio_balloon.ko.xz=0D
supermin: running xz=0D
done with xz 18519 read=0D
supermin: internal insmod virtio_input.ko.xz=0D
supermin: running xz=0D
done with xz 13143 read=0D
supermin: internal insmod virtio_mmio.ko.xz=0D
supermin: running xz=0D
done with xz 13751 read=0D
supermin: internal insmod virtio_pci.ko.xz=0D
supermin: running xz=0D
done with xz 32183 read=0D
[    6.315255] virtio-pci 0000:00:02.0: PCI->APIC IRQ transform: INT A -> I=
RQ 10=0D
[    6.316255] virtio-pci 0000:00:02.0: virtio_pci: leaving for legacy driv=
er=0D
[    6.339251] scsi host2: Virtio SCSI HBA=0D
[    6.360248] virtio-pci 0000:00:03.0: PCI->APIC IRQ transform: INT A -> I=
RQ 11=0D
[    6.361248] virtio-pci 0000:00:03.0: virtio_pci: leaving for legacy driv=
er=0D
[    6.398242] scsi 2:0:0:0: Direct-Access     QEMU     QEMU HARDDISK    2.=
4. PQ: 0 ANSI: 5=0D
[    6.416240] virtio-pci 0000:00:04.0: PCI->APIC IRQ transform: INT A -> I=
RQ 11=0D
[    6.416240] virtio-pci 0000:00:04.0: virtio_pci: leaving for legacy driv=
er=0D
[    6.420239] scsi 2:0:1:0: Direct-Access     QEMU     QEMU HARDDISK    2.=
4. PQ: 0 ANSI: 5=0D
[    7.619057] sd 2:0:0:0: [sda] 1024000 512-byte logical blocks: (524 MB/5=
00 MiB)=0D
[    7.628055] sd 2:0:0:0: [sda] Write Protect is off=0D
[    7.634055] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA=0D
[    7.639054] sd 2:0:0:0: Attached scsi generic sg0 type 0=0D
[    7.680048] sd 2:0:1:0: [sdb] 8388608 512-byte logical blocks: (4.29 GB/=
4.00 GiB)=0D
[    7.684047] sd 2:0:1:0: [sdb] Write Protect is off=0D
[    7.690046] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA=0D
[    7.701044] sd 2:0:1:0: Attached scsi generic sg1 type 0=0D
[    7.780032] sd 2:0:1:0: [sdb] Attached SCSI disk=0D
[    7.782032] sd 2:0:0:0: [sda] Attached SCSI disk=0D
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
[    7.939008] EXT4-fs (sdb): mounting ext2 file system using the ext4 subs=
ystem=0D
[    8.029994] EXT4-fs (sdb): mounted filesystem without journal. Opts: =0D
supermin: chroot=0D
[    8.463928] random: nonblocking pool is initialized=0D
Starting /init script ...=0D
[   11.770426] ldconfig (93) used greatest stack depth: 11528 bytes left=0D
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
[   23.084706] input: PC Speaker as /devices/platform/pcspkr/input/input3=0D
[   23.269678] PCSP: Timer resolution is not sufficient (1000000nS)=0D
[   23.270677] PCSP: Make sure you have HPET and ACPI enabled.=0D
[   23.270677] PCSP: Turned into nopcm mode.=0D
[   25.258375] kvm: Nested Virtualization enabled=0D
/init: line 86: /sys/block/hd*/queue/scheduler: No such file or directory=0D
/init: line 86: /sys/block/ubd*/queue/scheduler: No such file or directory=
=0D
/init: line 86: /sys/block/vd*/queue/scheduler: No such file or directory=0D
[   26.943119] ip (136) used greatest stack depth: 11416 bytes left=0D
mdadm: No arrays found in config file or automatically=0D
  lvmetad is not active yet, using direct activation during sysinit=0D
[=0D
]=0D
Linux (none) 4.2.0-1.fc24.x86_64+debug #1 SMP Mon Aug 31 15:39:13 UTC 2015 =
x86_64 x86_64 x86_64 GNU/Linux=0D
/dev:=0D
total 0=0D
crw------- 1 root root  10, 235 Sep  4 17:36 autofs=0D
drwxr-xr-x 2 root root       80 Sep  4 17:36 block=0D
drwxr-xr-x 2 root root       80 Sep  4 17:36 bsg=0D
crw------- 1 root root  10, 234 Sep  4 17:36 btrfs-control=0D
drwxr-xr-x 3 root root       60 Sep  4 17:35 bus=0D
drwxr-xr-x 2 root root     2380 Sep  4 17:36 char=0D
crw------- 1 root root   5,   1 Sep  4 17:36 console=0D
lrwxrwxrwx 1 root root       11 Sep  4 17:36 core -> /proc/kcore=0D
drwxr-xr-x 3 root root       60 Sep  4 17:35 cpu=0D
crw------- 1 root root  10,  62 Sep  4 17:36 cpu_dma_latency=0D
crw------- 1 root root  10, 203 Sep  4 17:36 cuse=0D
drwxr-xr-x 5 root root      100 Sep  4 17:36 disk=0D
lrwxrwxrwx 1 root root       13 Sep  4 17:36 fd -> /proc/self/fd=0D
crw-rw-rw- 1 root root   1,   7 Sep  4 17:36 full=0D
crw-rw-rw- 1 root root  10, 229 Sep  4 17:36 fuse=0D
crw------- 1 root root  10, 183 Sep  4 17:36 hwrng=0D
drwxr-xr-x 3 root root      160 Sep  4 17:36 input=0D
crw-r--r-- 1 root root   1,  11 Sep  4 17:36 kmsg=0D
crw------- 1 root root  10, 232 Sep  4 17:36 kvm=0D
crw-rw---- 1 root disk  10, 237 Sep  4 17:36 loop-control=0D
drwxr-xr-x 2 root root       60 Sep  4 17:35 mapper=0D
crw------- 1 root root  10, 227 Sep  4 17:36 mcelog=0D
crw------- 1 root root  10,  57 Sep  4 17:36 megadev0=0D
crw------- 1 root root   1,   1 Sep  4 17:36 mem=0D
crw------- 1 root root  10,  59 Sep  4 17:36 memory_bandwidth=0D
crw------- 1 root root 254,   0 Sep  4 17:36 ndctl0=0D
drwxr-xr-x 2 root root       60 Sep  4 17:36 net=0D
crw------- 1 root root  10,  61 Sep  4 17:36 network_latency=0D
crw------- 1 root root  10,  60 Sep  4 17:36 network_throughput=0D
crw-rw-rw- 1 root root   1,   3 Sep  4 17:36 null=0D
crw------- 1 root root  10, 144 Sep  4 17:36 nvram=0D
crw------- 1 root root   1,   4 Sep  4 17:36 port=0D
crw------- 1 root root 108,   0 Sep  4 17:36 ppp=0D
crw-rw-rw- 1 root root   5,   2 Sep  4 17:36 ptmx=0D
crw-rw-rw- 1 root root   1,   8 Sep  4 17:36 random=0D
drwxr-xr-x 2 root root       60 Sep  4 17:35 raw=0D
crw------- 1 root root  10,  58 Sep  4 17:36 rfkill=0D
lrwxrwxrwx 1 root root        4 Sep  4 17:36 rtc -> rtc0=0D
crw------- 1 root root 252,   0 Sep  4 17:36 rtc0=0D
brw------- 1 root root   8,   0 Sep  4 17:36 sda=0D
brw------- 1 root root   8,  16 Sep  4 17:36 sdb=0D
crw------- 1 root root  21,   0 Sep  4 17:36 sg0=0D
crw------- 1 root root  21,   1 Sep  4 17:36 sg1=0D
crw------- 1 root root  10, 231 Sep  4 17:36 snapshot=0D
drwxr-xr-x 3 root root      120 Sep  4 17:36 snd=0D
lrwxrwxrwx 1 root root       15 Sep  4 17:36 stderr -> /proc/self/fd/2=0D
lrwxrwxrwx 1 root root       15 Sep  4 17:36 stdin -> /proc/self/fd/0=0D
lrwxrwxrwx 1 root root       15 Sep  4 17:36 stdout -> /proc/self/fd/1=0D
crw-rw-rw- 1 root root   5,   0 Sep  4 17:36 tty=0D
crw------- 1 root root   4,   0 Sep  4 17:36 tty0=0D
crw------- 1 root root   4,   1 Sep  4 17:36 tty1=0D
crw------- 1 root root   4,  10 Sep  4 17:36 tty10=0D
crw------- 1 root root   4,  11 Sep  4 17:36 tty11=0D
crw------- 1 root root   4,  12 Sep  4 17:36 tty12=0D
crw------- 1 root root   4,  13 Sep  4 17:36 tty13=0D
crw------- 1 root root   4,  14 Sep  4 17:36 tty14=0D
crw------- 1 root root   4,  15 Sep  4 17:36 tty15=0D
crw------- 1 root root   4,  16 Sep  4 17:36 tty16=0D
crw------- 1 root root   4,  17 Sep  4 17:36 tty17=0D
crw------- 1 root root   4,  18 Sep  4 17:36 tty18=0D
crw------- 1 root root   4,  19 Sep  4 17:36 tty19=0D
crw------- 1 root root   4,   2 Sep  4 17:36 tty2=0D
crw------- 1 root root   4,  20 Sep  4 17:36 tty20=0D
crw------- 1 root root   4,  21 Sep  4 17:36 tty21=0D
crw------- 1 root root   4,  22 Sep  4 17:36 tty22=0D
crw------- 1 root root   4,  23 Sep  4 17:36 tty23=0D
crw------- 1 root root   4,  24 Sep  4 17:36 tty24=0D
crw------- 1 root root   4,  25 Sep  4 17:36 tty25=0D
crw------- 1 root root   4,  26 Sep  4 17:36 tty26=0D
crw------- 1 root root   4,  27 Sep  4 17:36 tty27=0D
crw------- 1 root root   4,  28 Sep  4 17:36 tty28=0D
crw------- 1 root root   4,  29 Sep  4 17:36 tty29=0D
crw------- 1 root root   4,   3 Sep  4 17:36 tty3=0D
crw------- 1 root root   4,  30 Sep  4 17:36 tty30=0D
crw------- 1 root root   4,  31 Sep  4 17:36 tty31=0D
crw------- 1 root root   4,  32 Sep  4 17:36 tty32=0D
crw------- 1 root root   4,  33 Sep  4 17:36 tty33=0D
crw------- 1 root root   4,  34 Sep  4 17:36 tty34=0D
crw------- 1 root root   4,  35 Sep  4 17:36 tty35=0D
crw------- 1 root root   4,  36 Sep  4 17:36 tty36=0D
crw------- 1 root root   4,  37 Sep  4 17:36 tty37=0D
crw------- 1 root root   4,  38 Sep  4 17:36 tty38=0D
crw------- 1 root root   4,  39 Sep  4 17:36 tty39=0D
crw------- 1 root root   4,   4 Sep  4 17:36 tty4=0D
crw------- 1 root root   4,  40 Sep  4 17:36 tty40=0D
crw------- 1 root root   4,  41 Sep  4 17:36 tty41=0D
crw------- 1 root root   4,  42 Sep  4 17:36 tty42=0D
crw------- 1 root root   4,  43 Sep  4 17:36 tty43=0D
crw------- 1 root root   4,  44 Sep  4 17:36 tty44=0D
crw------- 1 root root   4,  45 Sep  4 17:36 tty45=0D
crw------- 1 root root   4,  46 Sep  4 17:36 tty46=0D
crw------- 1 root root   4,  47 Sep  4 17:36 tty47=0D
crw------- 1 root root   4,  48 Sep  4 17:36 tty48=0D
crw------- 1 root root   4,  49 Sep  4 17:36 tty49=0D
crw------- 1 root root   4,   5 Sep  4 17:36 tty5=0D
crw------- 1 root root   4,  50 Sep  4 17:36 tty50=0D
crw------- 1 root root   4,  51 Sep  4 17:36 tty51=0D
crw------- 1 root root   4,  52 Sep  4 17:36 tty52=0D
crw------- 1 root root   4,  53 Sep  4 17:36 tty53=0D
crw------- 1 root root   4,  54 Sep  4 17:36 tty54=0D
crw------- 1 root root   4,  55 Sep  4 17:36 tty55=0D
crw------- 1 root root   4,  56 Sep  4 17:36 tty56=0D
crw------- 1 root root   4,  57 Sep  4 17:36 tty57=0D
crw------- 1 root root   4,  58 Sep  4 17:36 tty58=0D
crw------- 1 root root   4,  59 Sep  4 17:36 tty59=0D
crw------- 1 root root   4,   6 Sep  4 17:36 tty6=0D
crw------- 1 root root   4,  60 Sep  4 17:36 tty60=0D
crw------- 1 root root   4,  61 Sep  4 17:36 tty61=0D
crw------- 1 root root   4,  62 Sep  4 17:36 tty62=0D
crw------- 1 root root   4,  63 Sep  4 17:36 tty63=0D
crw------- 1 root root   4,   7 Sep  4 17:36 tty7=0D
crw------- 1 root root   4,   8 Sep  4 17:36 tty8=0D
crw------- 1 root root   4,   9 Sep  4 17:36 tty9=0D
crw------- 1 root root   4,  64 Sep  4 17:36 ttyS0=0D
crw------- 1 root root   4,  65 Sep  4 17:36 ttyS1=0D
crw------- 1 root root   4,  66 Sep  4 17:36 ttyS2=0D
crw------- 1 root root   4,  67 Sep  4 17:36 ttyS3=0D
crw------- 1 root root  10, 239 Sep  4 17:36 uhid=0D
crw------- 1 root root  10, 223 Sep  4 17:36 uinput=0D
crw-rw-rw- 1 root root   1,   9 Sep  4 17:36 urandom=0D
crw------- 1 root root 249,   0 Sep  4 17:36 usbmon0=0D
crw------- 1 root root 249,   1 Sep  4 17:36 usbmon1=0D
crw------- 1 root root   7,   0 Sep  4 17:36 vcs=0D
crw------- 1 root root   7,   1 Sep  4 17:36 vcs1=0D
crw------- 1 root root   7, 128 Sep  4 17:36 vcsa=0D
crw------- 1 root root   7, 129 Sep  4 17:36 vcsa1=0D
drwxr-xr-x 2 root root       60 Sep  4 17:36 vfio=0D
crw------- 1 root root  10,  63 Sep  4 17:36 vga_arbiter=0D
crw------- 1 root root  10, 137 Sep  4 17:36 vhci=0D
crw------- 1 root root  10, 238 Sep  4 17:36 vhost-net=0D
drwxr-xr-x 2 root root       60 Sep  4 17:36 virtio-ports=0D
crw------- 1 root root 245,   1 Sep  4 17:36 vport1p1=0D
crw-rw-rw- 1 root root   1,   5 Sep  4 17:36 zero=0D
=0D
/dev/block:=0D
total 0=0D
lrwxrwxrwx 1 root root 6 Sep  4 17:36 8:0 -> ../sda=0D
lrwxrwxrwx 1 root root 6 Sep  4 17:36 8:16 -> ../sdb=0D
=0D
/dev/bsg:=0D
total 0=0D
crw------- 1 root root 250, 0 Sep  4 17:36 2:0:0:0=0D
crw------- 1 root root 250, 1 Sep  4 17:36 2:0:1:0=0D
=0D
/dev/bus:=0D
total 0=0D
drwxr-xr-x 3 root root 60 Sep  4 17:35 usb=0D
=0D
/dev/bus/usb:=0D
total 0=0D
drwxr-xr-x 2 root root 60 Sep  4 17:35 001=0D
=0D
/dev/bus/usb/001:=0D
total 0=0D
crw------- 1 root root 189, 0 Sep  4 17:36 001=0D
=0D
/dev/char:=0D
total 0=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 10:144 -> ../nvram=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 10:183 -> ../hwrng=0D
lrwxrwxrwx 1 root root  9 Sep  4 17:36 10:227 -> ../mcelog=0D
lrwxrwxrwx 1 root root 11 Sep  4 17:36 10:231 -> ../snapshot=0D
lrwxrwxrwx 1 root root  6 Sep  4 17:36 10:232 -> ../kvm=0D
lrwxrwxrwx 1 root root  9 Sep  4 17:36 10:235 -> ../autofs=0D
lrwxrwxrwx 1 root root 17 Sep  4 17:36 10:236 -> ../mapper/control=0D
lrwxrwxrwx 1 root root 11 Sep  4 17:36 10:57 -> ../megadev0=0D
lrwxrwxrwx 1 root root  9 Sep  4 17:36 10:58 -> ../rfkill=0D
lrwxrwxrwx 1 root root 19 Sep  4 17:36 10:59 -> ../memory_bandwidth=0D
lrwxrwxrwx 1 root root 21 Sep  4 17:36 10:60 -> ../network_throughput=0D
lrwxrwxrwx 1 root root 18 Sep  4 17:36 10:61 -> ../network_latency=0D
lrwxrwxrwx 1 root root 18 Sep  4 17:36 10:62 -> ../cpu_dma_latency=0D
lrwxrwxrwx 1 root root 14 Sep  4 17:36 10:63 -> ../vga_arbiter=0D
lrwxrwxrwx 1 root root 16 Sep  4 17:36 116:2 -> ../snd/controlC0=0D
lrwxrwxrwx 1 root root 12 Sep  4 17:36 116:33 -> ../snd/timer=0D
lrwxrwxrwx 1 root root 15 Sep  4 17:36 13:32 -> ../input/mouse0=0D
lrwxrwxrwx 1 root root 13 Sep  4 17:36 13:63 -> ../input/mice=0D
lrwxrwxrwx 1 root root 15 Sep  4 17:36 13:64 -> ../input/event0=0D
lrwxrwxrwx 1 root root 15 Sep  4 17:36 13:65 -> ../input/event1=0D
lrwxrwxrwx 1 root root 15 Sep  4 17:36 13:66 -> ../input/event2=0D
lrwxrwxrwx 1 root root 13 Sep  4 17:36 162:0 -> ../raw/rawctl=0D
lrwxrwxrwx 1 root root 18 Sep  4 17:36 189:0 -> ../bus/usb/001/001=0D
lrwxrwxrwx 1 root root  6 Sep  4 17:36 1:1 -> ../mem=0D
lrwxrwxrwx 1 root root  7 Sep  4 17:36 1:11 -> ../kmsg=0D
lrwxrwxrwx 1 root root  7 Sep  4 17:36 1:3 -> ../null=0D
lrwxrwxrwx 1 root root  7 Sep  4 17:36 1:4 -> ../port=0D
lrwxrwxrwx 1 root root  7 Sep  4 17:36 1:5 -> ../zero=0D
lrwxrwxrwx 1 root root  7 Sep  4 17:36 1:7 -> ../full=0D
lrwxrwxrwx 1 root root  9 Sep  4 17:36 1:8 -> ../random=0D
lrwxrwxrwx 1 root root 10 Sep  4 17:36 1:9 -> ../urandom=0D
lrwxrwxrwx 1 root root 12 Sep  4 17:36 202:0 -> ../cpu/0/msr=0D
lrwxrwxrwx 1 root root 14 Sep  4 17:36 203:0 -> ../cpu/0/cpuid=0D
lrwxrwxrwx 1 root root  6 Sep  4 17:36 21:0 -> ../sg0=0D
lrwxrwxrwx 1 root root  6 Sep  4 17:36 21:1 -> ../sg1=0D
lrwxrwxrwx 1 root root 11 Sep  4 17:36 245:1 -> ../vport1p1=0D
lrwxrwxrwx 1 root root 10 Sep  4 17:36 249:0 -> ../usbmon0=0D
lrwxrwxrwx 1 root root 10 Sep  4 17:36 249:1 -> ../usbmon1=0D
lrwxrwxrwx 1 root root 14 Sep  4 17:36 250:0 -> ../bsg/2:0:0:0=0D
lrwxrwxrwx 1 root root 14 Sep  4 17:36 250:1 -> ../bsg/2:0:1:0=0D
lrwxrwxrwx 1 root root  7 Sep  4 17:36 252:0 -> ../rtc0=0D
lrwxrwxrwx 1 root root  9 Sep  4 17:36 254:0 -> ../ndctl0=0D
lrwxrwxrwx 1 root root  7 Sep  4 17:36 4:0 -> ../tty0=0D
lrwxrwxrwx 1 root root  7 Sep  4 17:36 4:1 -> ../tty1=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:10 -> ../tty10=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:11 -> ../tty11=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:12 -> ../tty12=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:13 -> ../tty13=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:14 -> ../tty14=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:15 -> ../tty15=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:16 -> ../tty16=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:17 -> ../tty17=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:18 -> ../tty18=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:19 -> ../tty19=0D
lrwxrwxrwx 1 root root  7 Sep  4 17:36 4:2 -> ../tty2=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:20 -> ../tty20=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:21 -> ../tty21=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:22 -> ../tty22=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:23 -> ../tty23=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:24 -> ../tty24=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:25 -> ../tty25=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:26 -> ../tty26=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:27 -> ../tty27=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:28 -> ../tty28=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:29 -> ../tty29=0D
lrwxrwxrwx 1 root root  7 Sep  4 17:36 4:3 -> ../tty3=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:30 -> ../tty30=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:31 -> ../tty31=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:32 -> ../tty32=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:33 -> ../tty33=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:34 -> ../tty34=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:35 -> ../tty35=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:36 -> ../tty36=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:37 -> ../tty37=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:38 -> ../tty38=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:39 -> ../tty39=0D
lrwxrwxrwx 1 root root  7 Sep  4 17:36 4:4 -> ../tty4=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:40 -> ../tty40=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:41 -> ../tty41=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:42 -> ../tty42=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:43 -> ../tty43=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:44 -> ../tty44=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:45 -> ../tty45=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:46 -> ../tty46=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:47 -> ../tty47=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:48 -> ../tty48=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:49 -> ../tty49=0D
lrwxrwxrwx 1 root root  7 Sep  4 17:36 4:5 -> ../tty5=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:50 -> ../tty50=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:51 -> ../tty51=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:52 -> ../tty52=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:53 -> ../tty53=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:54 -> ../tty54=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:55 -> ../tty55=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:56 -> ../tty56=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:57 -> ../tty57=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:58 -> ../tty58=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:59 -> ../tty59=0D
lrwxrwxrwx 1 root root  7 Sep  4 17:36 4:6 -> ../tty6=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:60 -> ../tty60=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:61 -> ../tty61=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:62 -> ../tty62=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:63 -> ../tty63=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:64 -> ../ttyS0=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:65 -> ../ttyS1=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:66 -> ../ttyS2=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 4:67 -> ../ttyS3=0D
lrwxrwxrwx 1 root root  7 Sep  4 17:36 4:7 -> ../tty7=0D
lrwxrwxrwx 1 root root  7 Sep  4 17:36 4:8 -> ../tty8=0D
lrwxrwxrwx 1 root root  7 Sep  4 17:36 4:9 -> ../tty9=0D
lrwxrwxrwx 1 root root  6 Sep  4 17:36 5:0 -> ../tty=0D
lrwxrwxrwx 1 root root 10 Sep  4 17:36 5:1 -> ../console=0D
lrwxrwxrwx 1 root root  7 Sep  4 17:36 5:2 -> ../ptmx=0D
lrwxrwxrwx 1 root root  6 Sep  4 17:36 7:0 -> ../vcs=0D
lrwxrwxrwx 1 root root  7 Sep  4 17:36 7:1 -> ../vcs1=0D
lrwxrwxrwx 1 root root  7 Sep  4 17:36 7:128 -> ../vcsa=0D
lrwxrwxrwx 1 root root  8 Sep  4 17:36 7:129 -> ../vcsa1=0D
=0D
/dev/cpu:=0D
total 0=0D
drwxr-xr-x 2 root root 80 Sep  4 17:35 0=0D
=0D
/dev/cpu/0:=0D
total 0=0D
crw------- 1 root root 203, 0 Sep  4 17:36 cpuid=0D
crw------- 1 root root 202, 0 Sep  4 17:36 msr=0D
=0D
/dev/disk:=0D
total 0=0D
drwxr-xr-x 2 root root 80 Sep  4 17:36 by-id=0D
drwxr-xr-x 2 root root 80 Sep  4 17:36 by-path=0D
drwxr-xr-x 2 root root 60 Sep  4 17:36 by-uuid=0D
=0D
/dev/disk/by-id:=0D
total 0=0D
lrwxrwxrwx 1 root root 9 Sep  4 17:36 scsi-0QEMU_QEMU_HARDDISK_drive-scsi0-=
0-0-0 -> ../../sda=0D
lrwxrwxrwx 1 root root 9 Sep  4 17:36 scsi-0QEMU_QEMU_HARDDISK_drive-scsi0-=
0-1-0 -> ../../sdb=0D
=0D
/dev/disk/by-path:=0D
total 0=0D
lrwxrwxrwx 1 root root 9 Sep  4 17:36 pci-0000:00:02.0-scsi-0:0:0:0 -> ../.=
=2E/sda=0D
lrwxrwxrwx 1 root root 9 Sep  4 17:36 pci-0000:00:02.0-scsi-0:0:1:0 -> ../.=
=2E/sdb=0D
=0D
/dev/disk/by-uuid:=0D
total 0=0D
lrwxrwxrwx 1 root root 9 Sep  4 17:36 15861cf1-098c-4f60-ac48-b84466e458e8 =
-> ../../sdb=0D
=0D
/dev/input:=0D
total 0=0D
drwxr-xr-x 2 root root    120 Sep  4 17:36 by-path=0D
crw------- 1 root root 13, 64 Sep  4 17:36 event0=0D
crw------- 1 root root 13, 65 Sep  4 17:36 event1=0D
crw------- 1 root root 13, 66 Sep  4 17:36 event2=0D
crw------- 1 root root 13, 63 Sep  4 17:36 mice=0D
crw------- 1 root root 13, 32 Sep  4 17:36 mouse0=0D
=0D
/dev/input/by-path:=0D
total 0=0D
lrwxrwxrwx 1 root root 9 Sep  4 17:36 platform-i8042-serio-0-event-kbd -> .=
=2E/event1=0D
lrwxrwxrwx 1 root root 9 Sep  4 17:36 platform-i8042-serio-1-event-mouse ->=
 ../event0=0D
lrwxrwxrwx 1 root root 9 Sep  4 17:36 platform-i8042-serio-1-mouse -> ../mo=
use0=0D
lrwxrwxrwx 1 root root 9 Sep  4 17:36 platform-pcspkr-event-spkr -> ../even=
t2=0D
=0D
/dev/mapper:=0D
total 0=0D
crw------- 1 root root 10, 236 Sep  4 17:36 control=0D
=0D
/dev/net:=0D
total 0=0D
crw-rw-rw- 1 root root 10, 200 Sep  4 17:36 tun=0D
=0D
/dev/raw:=0D
total 0=0D
crw------- 1 root root 162, 0 Sep  4 17:36 rawctl=0D
=0D
/dev/snd:=0D
total 0=0D
drwxr-xr-x 2 root root       60 Sep  4 17:36 by-path=0D
crw-rw---- 1 root audio 116,  2 Sep  4 17:36 controlC0=0D
crw-rw---- 1 root audio 116,  1 Sep  4 17:36 seq=0D
crw-rw---- 1 root audio 116, 33 Sep  4 17:36 timer=0D
=0D
/dev/snd/by-path:=0D
total 0=0D
lrwxrwxrwx 1 root root 12 Sep  4 17:36 platform-pcspkr -> ../controlC0=0D
=0D
/dev/vfio:=0D
total 0=0D
crw------- 1 root root 10, 196 Sep  4 17:36 vfio=0D
=0D
/dev/virtio-ports:=0D
total 0=0D
lrwxrwxrwx 1 root root 11 Sep  4 17:36 org.libguestfs.channel.0 -> ../vport=
1p1=0D
/dev/root / ext2 rw,noatime 0 0=0D
/proc /proc proc rw,relatime 0 0=0D
/sys /sys sysfs rw,relatime 0 0=0D
tmpfs /run tmpfs rw,nosuid,relatime,size=3D94060k,mode=3D755 0 0=0D
/dev /dev devtmpfs rw,relatime,size=3D231600k,nr_inodes=3D57900,mode=3D755 =
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
kvm                   552960  1 kvm_amd=0D
snd_pcsp               16384  0=0D
snd_pcm               118784  1 snd_pcsp=0D
snd_timer              32768  1 snd_pcm=0D
snd                    86016  3 snd_timer,snd_pcm,snd_pcsp=0D
serio_raw              16384  0=0D
soundcore              16384  1 snd=0D
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
megaraid               40960  0=0D
ideapad_laptop         24576  0=0D
rfkill                 24576  1 ideapad_laptop=0D
sparse_keymap          16384  1 ideapad_laptop=0D
video                  40960  1 ideapad_laptop=0D
virtio_net             28672  0=0D
virtio_gpu             45056  0=0D
ttm                    94208  1 virtio_gpu=0D
drm_kms_helper        118784  1 virtio_gpu=0D
drm                   344064  3 ttm,drm_kms_helper,virtio_gpu=0D
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
Fri Sep  4 17:36:26 UTC 2015=0D
clocksource: refined-jiffies=0D
uptime: 32.43 0.73=0D
guestfsd --verbose=0D
trying to open virtio-serial channel '/dev/virtio-ports/org.libguestfs.chan=
nel.0'=0D
udevadm --debug settle=0D
calling: settle=0D
libguestfs: recv_from_daemon: received GUESTFS_LAUNCH_FLAG
libguestfs: [38006ms] appliance is up
libguestfs: trace: launch =3D 0
libguestfs: trace: part_disk "/dev/sda" "mbr"
guestfsd: main_loop: new request, len 0x3c=0D
udevadm --debug settle=0D
calling: settle=0D
parted -s -- /dev/sda mklabel msdos mkpart primary 128s -128s=0D
Warning: The resulting partition is not properly aligned for best performan=
ce.=0D
udevadm --debug settle=0D
calling: settle=0D
libguestfs: trace: part_disk =3D 0
libguestfs: trace: pvcreate "/dev/sda1"
guestfsd: main_loop: proc 210 (part_disk) took 3.92 seconds=0D
guestfsd: main_loop: new request, len 0x38=0D
lvm pvcreate --force /dev/sda1=0D
  /run/lvm/lvmetad.socket: connect failed: No such file or directory=0D
  WARNING: Failed to connect to lvmetad. Falling back to internal scanning.=
=0D
udevadm --debug settle=0D
calling: settle=0D
libguestfs: trace: pvcreate =3D 0
libguestfs: trace: vgcreate "VG" "/dev/sda1"
guestfsd: main_loop: proc 39 (pvcreate) took 1.38 seconds=0D
guestfsd: main_loop: new request, len 0x44=0D
lvm vgcreate VG /dev/sda1=0D
  /run/lvm/lvmetad.socket: connect failed: No such file or directory=0D
  WARNING: Failed to connect to lvmetad. Falling back to internal scanning.=
=0D
udevadm --debug settle=0D
calling: settle=0D
libguestfs: trace: vgcreate =3D 0
libguestfs: trace: lvcreate "LV1" "VG" 50
guestfsd: main_loop: proc 40 (vgcreate) took 1.41 seconds=0D
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
guestfsd: main_loop: proc 41 (lvcreate) took 3.19 seconds=0D
guestfsd: main_loop: new request, len 0x38=0D
lvm lvremove -f /dev/VG/LV1=0D
  /run/lvm/lvmetad.socket: connect failed: No such file or directory=0D
  WARNING: Failed to connect to lvmetad. Falling back to internal scanning.=
=0D
[   47.779951] BUG: unable to handle kernel NULL pointer dereference at 000=
00000000009d0=0D
[   47.779951] IP: [<ffffffff8140e820>] __blkg_lookup+0x40/0xe0=0D
[   47.779951] PGD 0 =0D
[   47.779951] Oops: 0000 [#1] SMP =0D
[   47.779951] Modules linked in: kvm_amd kvm snd_pcsp snd_pcm snd_timer sn=
d serio_raw soundcore ata_generic pata_acpi libcrc32c crc8 crc_itu_t crc_cc=
itt virtio_pci virtio_mmio virtio_input virtio_balloon virtio_scsi sym53c8x=
x scsi_transport_spi megaraid_sas megaraid_mbox megaraid_mm megaraid ideapa=
d_laptop rfkill sparse_keymap video virtio_net virtio_gpu ttm drm_kms_helpe=
r drm virtio_console virtio_rng virtio_blk virtio_ring virtio crc32=0D
[   47.779951] CPU: 0 PID: 194 Comm: lvm Not tainted 4.2.0-1.fc24.x86_64+de=
bug #1=0D
[   47.779951] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.8.2-20150714_191134- 04/01/2014=0D
[   47.779951] task: ffff88001bae8000 ti: ffff88001bafc000 task.ti: ffff880=
01bafc000=0D
[   47.779951] RIP: 0010:[<ffffffff8140e820>]  [<ffffffff8140e820>] __blkg_=
lookup+0x40/0xe0=0D
[   47.779951] RSP: 0018:ffff88001baffa28  EFLAGS: 00000046=0D
[   47.779951] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 00000000000=
00001=0D
[   47.779951] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00000000000=
00046=0D
[   47.779951] RBP: ffff88001baffa48 R08: 0000000000000000 R09: 00000000000=
00000=0D
[   47.779951] R10: ffff88001bae8000 R11: ffffffff81e596c0 R12: 00000000000=
00000=0D
[   47.779951] R13: ffffffff8316dda0 R14: 0000000000000000 R15: 00000000000=
00000=0D
[   47.779951] FS:  00007ff4591b8840(0000) GS:ffff88001ec00000(0000) knlGS:=
0000000000000000=0D
[   47.779951] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0D
[   47.779951] CR2: 00000000000009d0 CR3: 000000001bb1f000 CR4: 00000000000=
006f0=0D
[   47.779951] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000=0D
[   47.779951] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 00000000000=
00000=0D
[   47.779951] Stack:=0D
[   47.779951]  ffffffff8316dda0 ffff88001b9e3a00 ffff88001bf2abf8 ffff8800=
1bf2b620=0D
[   47.779951]  ffff88001baffa88 ffffffff81412b94 ffffffff81412b16 ffff8800=
1bf2b620=0D
[   47.779951]  ffff88001baffa88 ffff88001bf2abf8 ffffffff81ec99e0 00000000=
00000000=0D
[   47.779951] Call Trace:=0D
[   47.779951]  [<ffffffff81412b94>] blk_throtl_drain+0xb4/0x220=0D
[   47.779951]  [<ffffffff81412b16>] ? blk_throtl_drain+0x36/0x220=0D
[   47.779951]  [<ffffffff8140f9bd>] blkcg_drain_queue+0x2d/0x60=0D
[   47.779951]  [<ffffffff813e9bf9>] __blk_drain_queue+0xc9/0x1a0=0D
[   47.779951]  [<ffffffff813eb5d8>] ? blk_queue_bypass_start+0x68/0xb0=0D
[   47.779951]  [<ffffffff813eb5e2>] blk_queue_bypass_start+0x72/0xb0=0D
[   47.779951]  [<ffffffff8140d8f9>] blkcg_deactivate_policy+0x39/0x100=0D
[   47.779951]  [<ffffffff81412e58>] blk_throtl_exit+0x38/0x50=0D
[   47.779951]  [<ffffffff8140fa29>] blkcg_exit_queue+0x39/0x40=0D
[   47.779951]  [<ffffffff813f1cae>] blk_release_queue+0x1e/0xc0=0D
[   47.779951]  [<ffffffff8142286a>] kobject_release+0x7a/0x190=0D
[   47.779951]  [<ffffffff8142271f>] kobject_put+0x2f/0x60=0D
[   47.779951]  [<ffffffff813ed3cb>] blk_cleanup_queue+0x18b/0x280=0D
[   47.779951]  [<ffffffff816b03a1>] cleanup_mapped_device+0xe1/0x110=0D
[   47.779951]  [<ffffffff816b3278>] __dm_destroy+0x1a8/0x2c0=0D
[   47.779951]  [<ffffffff816b47c3>] dm_destroy+0x13/0x20=0D
[   47.779951]  [<ffffffff816ba24d>] dev_remove+0x10d/0x170=0D
[   47.779951]  [<ffffffff816ba140>] ? dev_suspend+0x280/0x280=0D
[   47.779951]  [<ffffffff816ba952>] ctl_ioctl+0x282/0x550=0D
[   47.779951]  [<ffffffff8138370c>] ? SYSC_semtimedop+0x30c/0x1090=0D
[   47.779951]  [<ffffffff811284cd>] ? debug_lockdep_rcu_enabled+0x1d/0x20=
=0D
[   47.779951]  [<ffffffff811090e9>] ? __lock_acquire+0xcb9/0x1d00=0D
[   47.779951]  [<ffffffff810de500>] ? cpu_attach_domain+0x670/0x6d0=0D
[   47.779951]  [<ffffffff816bac33>] dm_ctl_ioctl+0x13/0x20=0D
[   47.779951]  [<ffffffff812857fe>] do_vfs_ioctl+0x2ee/0x550=0D
[   47.779951]  [<ffffffff811284cd>] ? debug_lockdep_rcu_enabled+0x1d/0x20=
=0D
[   47.779951]  [<ffffffff81291eb6>] ? __fget_light+0x66/0x90=0D
[   47.779951]  [<ffffffff81285ad9>] SyS_ioctl+0x79/0x90=0D
[   47.779951]  [<ffffffff8187192e>] entry_SYSCALL_64_fastpath+0x12/0x76=0D
[   47.779951] Code: f4 41 89 d6 48 8b 9f 38 01 00 00 e8 ab 9c d1 ff 85 c0 =
74 09 80 3d e3 64 b2 00 00 74 56 48 85 db 74 09 4c 39 23 0f 84 9a 00 00 00 =
<49> 63 b4 24 d0 09 00 00 49 8d bd 28 01 00 00 e8 0c 74 01 00 48 =0D
[   47.779951] RIP  [<ffffffff8140e820>] __blkg_lookup+0x40/0xe0=0D
[   47.779951]  RSP <ffff88001baffa28>=0D
[   47.779951] CR2: 00000000000009d0=0D
[   47.779951] ---[ end trace c0fe868cef596fc1 ]---=0D
[   47.779951] BUG: sleeping function called from invalid context at includ=
e/linux/sched.h:2739=0D
[   47.779951] in_atomic(): 1, irqs_disabled(): 1, pid: 194, name: lvm=0D
[   47.779951] INFO: lockdep is turned off.=0D
[   47.779951] irq event stamp: 97304=0D
[   47.779951] hardirqs last  enabled at (97303): [<ffffffff81870eb0>] _raw=
_spin_unlock_irq+0x30/0x50=0D
[   47.779951] hardirqs last disabled at (97304): [<ffffffff81870c7f>] _raw=
_spin_lock_irq+0x1f/0x80=0D
[   47.779951] softirqs last  enabled at (97294): [<ffffffff810b286a>] __do=
_softirq+0x39a/0x630=0D
[   47.779951] softirqs last disabled at (97279): [<ffffffff810b2d4a>] irq_=
exit+0x11a/0x120=0D
[   47.779951] CPU: 0 PID: 194 Comm: lvm Tainted: G      D         4.2.0-1.=
fc24.x86_64+debug #1=0D
[   47.779951] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.8.2-20150714_191134- 04/01/2014=0D
[   47.779951]  0000000000000000 0000000093beda74 ffff88001baff6a8 ffffffff=
81867e66=0D
[   47.779951]  0000000000000000 ffff88001bae8000 ffff88001baff6d8 ffffffff=
810db111=0D
[   47.779951]  ffff88001baff738 ffffffff81c71115 0000000000000ab3 00000000=
00000000=0D
[   47.779951] Call Trace:=0D
[   47.779951]  [<ffffffff81867e66>] dump_stack+0x4c/0x65=0D
[   47.779951]  [<ffffffff810db111>] ___might_sleep+0x181/0x240=0D
[   47.779951]  [<ffffffff810db21d>] __might_sleep+0x4d/0x90=0D
[   47.779951]  [<ffffffff810bf983>] exit_signals+0x33/0x150=0D
[   47.779951]  [<ffffffff810af899>] do_exit+0xc9/0xc30=0D
[   47.779951]  [<ffffffff8111f3f1>] ? kmsg_dump+0x151/0x1a0=0D
[   47.779951]  [<ffffffff8111f2d4>] ? kmsg_dump+0x34/0x1a0=0D
[   47.779951]  [<ffffffff810205fe>] oops_end+0x9e/0xd0=0D
[   47.779951]  [<ffffffff810711a5>] no_context+0x135/0x390=0D
[   47.779951]  [<ffffffff81071488>] __bad_area_nosemaphore+0x88/0x200=0D
[   47.779951]  [<ffffffff81026d49>] ? sched_clock+0x9/0x10=0D
[   47.779951]  [<ffffffff81071613>] bad_area_nosemaphore+0x13/0x20=0D
[   47.779951]  [<ffffffff81071915>] __do_page_fault+0xd5/0x470=0D
[   47.779951]  [<ffffffff81108a6d>] ? __lock_acquire+0x63d/0x1d00=0D
[   47.779951]  [<ffffffff81071cdf>] do_page_fault+0x2f/0x80=0D
[   47.779951]  [<ffffffff81872577>] ? native_iret+0x7/0x7=0D
[   47.779951]  [<ffffffff81873b48>] page_fault+0x28/0x30=0D
[   47.779951]  [<ffffffff8140e820>] ? __blkg_lookup+0x40/0xe0=0D
[   47.779951]  [<ffffffff8140e86d>] ? __blkg_lookup+0x8d/0xe0=0D
[   47.779951]  [<ffffffff81412b94>] blk_throtl_drain+0xb4/0x220=0D
[   47.779951]  [<ffffffff81412b16>] ? blk_throtl_drain+0x36/0x220=0D
[   47.779951]  [<ffffffff8140f9bd>] blkcg_drain_queue+0x2d/0x60=0D
[   47.779951]  [<ffffffff813e9bf9>] __blk_drain_queue+0xc9/0x1a0=0D
[   47.779951]  [<ffffffff813eb5d8>] ? blk_queue_bypass_start+0x68/0xb0=0D
[   47.779951]  [<ffffffff813eb5e2>] blk_queue_bypass_start+0x72/0xb0=0D
[   47.779951]  [<ffffffff8140d8f9>] blkcg_deactivate_policy+0x39/0x100=0D
[   47.779951]  [<ffffffff81412e58>] blk_throtl_exit+0x38/0x50=0D
[   47.779951]  [<ffffffff8140fa29>] blkcg_exit_queue+0x39/0x40=0D
[   47.779951]  [<ffffffff813f1cae>] blk_release_queue+0x1e/0xc0=0D
[   47.779951]  [<ffffffff8142286a>] kobject_release+0x7a/0x190=0D
[   47.779951]  [<ffffffff8142271f>] kobject_put+0x2f/0x60=0D
[   47.779951]  [<ffffffff813ed3cb>] blk_cleanup_queue+0x18b/0x280=0D
[   47.779951]  [<ffffffff816b03a1>] cleanup_mapped_device+0xe1/0x110=0D
[   47.779951]  [<ffffffff816b3278>] __dm_destroy+0x1a8/0x2c0=0D
[   47.779951]  [<ffffffff816b47c3>] dm_destroy+0x13/0x20=0D
[   47.779951]  [<ffffffff816ba24d>] dev_remove+0x10d/0x170=0D
[   47.779951]  [<ffffffff816ba140>] ? dev_suspend+0x280/0x280=0D
[   47.779951]  [<ffffffff816ba952>] ctl_ioctl+0x282/0x550=0D
[   47.779951]  [<ffffffff8138370c>] ? SYSC_semtimedop+0x30c/0x1090=0D
[   47.779951]  [<ffffffff811284cd>] ? debug_lockdep_rcu_enabled+0x1d/0x20=
=0D
[   47.779951]  [<ffffffff811090e9>] ? __lock_acquire+0xcb9/0x1d00=0D
[   47.779951]  [<ffffffff810de500>] ? cpu_attach_domain+0x670/0x6d0=0D
[   47.779951]  [<ffffffff816bac33>] dm_ctl_ioctl+0x13/0x20=0D
[   47.779951]  [<ffffffff812857fe>] do_vfs_ioctl+0x2ee/0x550=0D
[   47.779951]  [<ffffffff811284cd>] ? debug_lockdep_rcu_enabled+0x1d/0x20=
=0D
[   47.779951]  [<ffffffff81291eb6>] ? __fget_light+0x66/0x90=0D
[   47.779951]  [<ffffffff81285ad9>] SyS_ioctl+0x79/0x90=0D
[   47.779951]  [<ffffffff8187192e>] entry_SYSCALL_64_fastpath+0x12/0x76=0D
[   47.779951] note: lvm[194] exited with preempt_count 2=0D
guestfsd: error:   /run/lvm/lvmetad.socket: connect failed: No such file or=
 directory=0D
  WARNING: Failed to connect to lvmetad. Falling back to internal scanning.=
=0D
libguestfs: trace: lvremove =3D -1 (error)
*stdin*:9: libguestfs: error: lvremove:   /run/lvm/lvmetad.socket: connect =
failed: No such file or directory
  WARNING: Failed to connect to lvmetad. Falling back to internal scanning.
libguestfs: trace: close
libguestfs: closing guestfs handle 0x557415044d60 (state 2)
libguestfs: trace: internal_autosync
guestfsd: main_loop: proc 77 (lvremove) took 1.13 seconds=0D
guestfsd: main_loop: new request, len 0x28=0D
umount-all: /proc/mounts: fsname=3D/dev/root dir=3D/ type=3Dext2 opts=3Drw,=
noatime freq=3D0 passno=3D0=0D
umount-all: /proc/mounts: fsname=3D/proc dir=3D/proc type=3Dproc opts=3Drw,=
relatime freq=3D0 passno=3D0=0D
umount-all: /proc/mounts: fsname=3D/sys dir=3D/sys type=3Dsysfs opts=3Drw,r=
elatime freq=3D0 passno=3D0=0D
umount-all: /proc/mounts: fsname=3Dtmpfs dir=3D/run type=3Dtmpfs opts=3Drw,=
nosuid,relatime,size=3D94060k,mode=3D755 freq=3D0 passno=3D0=0D
umount-all: /proc/mounts: fsname=3D/dev dir=3D/dev type=3Ddevtmpfs opts=3Dr=
w,relatime,size=3D231600k,nr_inodes=3D57900,mode=3D755 freq=3D0 passno=3D0=
=0D
fsync /dev/sda=0D
libguestfs: trace: internal_autosync =3D 0
libguestfs: calling virDomainDestroy "guestfs-zlr3zvogh5lilmw3" flags=3D0
libguestfs: command: run: rm
libguestfs: command: run: \ -rf /tmp/libguestfsEfp5po

--xP4xvRzdEG0QZ+Pj--
