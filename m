From: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.4-fixes] cgroup: make css_set pin its css's
 to avoid use-afer-free
Date: Tue, 24 Nov 2015 15:58:42 +0100
Message-ID: <56547B22.2020802@bmw-carit.de>
References: <20151123195541.GA19072@mtj.duckdns.org>
 <56543C76.2050008@bmw-carit.de> <20151124144418.GB17033@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151124144418.GB17033-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org

Hi Tejun,

On 11/24/2015 03:44 PM, Tejun Heo wrote:
> On Tue, Nov 24, 2015 at 11:31:18AM +0100, Daniel Wagner wrote:
>> [   19.369455] ------------[ cut here ]------------
>> [   19.369851] WARNING: CPU: 1 PID: 1 at kernel/cgroup_pids.c:97 pids_cancel.constprop.6+0x31/0x40()
>> [   19.370596] Modules linked in:
>> [   19.370916] CPU: 1 PID: 1 Comm: systemd Not tainted 4.4.0-rc1+ #29
>> [   19.371418] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.8.2-0-g33fbe13 by qemu-project.org 04/01/2014
>> [   19.372542]  ffffffff81f65382 ffff88007c043b90 ffffffff81551ffc 0000000000000000
>> [   19.373173]  ffff88007c043bc8 ffffffff810de202 ffff88007a752000 ffff88007a29ab00
>> [   19.374144]  ffff88007c043c80 ffff88007a1d8400 0000000000000001 ffff88007c043bd8
>> [   19.375185] Call Trace:
>> [   19.375506]  [<ffffffff81551ffc>] dump_stack+0x4e/0x82
>> [   19.376238]  [<ffffffff810de202>] warn_slowpath_common+0x82/0xc0
>> [   19.376975]  [<ffffffff810de2fa>] warn_slowpath_null+0x1a/0x20
>> [   19.377765]  [<ffffffff8118e031>] pids_cancel.constprop.6+0x31/0x40
>> [   19.378623]  [<ffffffff8118e0fd>] pids_can_attach+0x6d/0xf0
>> [   19.379451]  [<ffffffff81188a4c>] cgroup_taskset_migrate+0x6c/0x330
>> [   19.380142]  [<ffffffff81188e05>] cgroup_migrate+0xf5/0x190
> 
> Can you please describe how to reproduce this one? 

I start a not so updated rawhide image with some funky kernel options.
They are more less some left overs from debugging:

$QEMU -gdb tcp::1235 -enable-kvm -machine accel=kvm \
      -m 2G -cpu Haswell \
      -smp sockets=1,cores=2,threads=2 \
      -hda ~/vm-images/rawhide-big.qcow2\
      -net nic,model=virtio \
      -net user,hostfwd=tcp::7777-:22 \
      -monitor telnet:127.0.0.1:1234,server,nowait \
      -serial stdio -display none \
      -append "root=/dev/sda1 console=ttyS0 audit=0 isolcpus=3 systemd.unified_cgroup_hierarchy=1" \
      -kernel arch/x86_64/boot/bzImage $@

After starting the image I just wait for a few seconds and I'll get it.
No interaction needed.

> If you have a qemu image which reproduces this, I'd be happy to take
> a look at it.

I'll upload it, though it will take a while... the fun of living
with asymmetric connectivity.

cheers,
daniel
