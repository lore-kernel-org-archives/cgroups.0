From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: __blkg_lookup oops with 4.2-rcX
Date: Fri, 4 Sep 2015 11:46:02 +0100
Message-ID: <20150904104602.GN29283@redhat.com>
References: <CA+5PVA5rzQ0s4723n5rHBcxQa9t0cW8BPPBekr_9aMRoWt2aYg@mail.gmail.com>
 <20150902145307.GG22326@mtj.duckdns.org>
 <20150902153255.GH22326@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150902153255.GH22326@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Jeff Moyer <jmoyer@redhat.com>, msnitzer@redhat.com, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>


On Wed, Sep 02, 2015 at 11:32:55AM -0400, Tejun Heo wrote:
> Hello,
> 
> On Wed, Sep 02, 2015 at 10:53:07AM -0400, Tejun Heo wrote:
> > On Sun, Aug 30, 2015 at 08:30:41AM -0400, Josh Boyer wrote:
> > I think the offending commit is 776687bce42b ("block, blk-mq: draining
> > can't be skipped even if bypass_depth was non-zero").  It looks like
> > the patch makes shutdown path travel data structure which is already
> > destroyed.  Will post the fix soon.
> 
> Hmm... I can't reproduce it here or see how such oops would happen.
> 
> * Is the problem reproducible on v4.2?  If so, can you please describe
>   the steps to reproduce?  How is cgroup set up?

We have a test suite which does a lot of filesystem and device
operations, and this triggers it randomly (not reliably nor in the
same place every time, but still pretty frequently).

So .. I don't have steps that can reproduce it reliably unfortunately.

However I'm going to work on that now to see if I can create a
sequence of operations that triggers it some or all of the time.

> * Can you please run gdb or addr2line on it and report which line is
>   causing the oops?

Below is another stack trace that I just collected.  It came from a
test that does some hotplugging of a virtual machine.  The kernel this
time is 4.2.0-0.rc3.git4.1.fc24.x86_64 (which is a bit old - am also
going to upgrade to the newest kernel soon).

The addr2line output from this one is:

$ addr2line -e /usr/lib/debug/lib/modules/4.2.0-0.rc3.git4.1.fc24.x86_64/vmlinux ffffffff814107a0
/usr/src/debug/kernel-4.1.fc24/linux-4.2.0-0.rc3.git4.1.fc24.x86_64/block/blk-throttle.c:1642

   1636         /*
   1637          * Drain each tg while doing post-order walk on the blkg tree, s   1637 o
   1638          * that all bios are propagated to td->service_queue.  It'd be
   1639          * better to walk service_queue tree directly but blkg walk is
   1640          * easier.
   1641          */
   1642         blkg_for_each_descendant_post(blkg, pos_css, td->queue->root_blkg)
   1643                 tg_drain_bios(&blkg_to_tg(blkg)->service_queue);
   1644 

Rich.

[    6.784689] BUG: unable to handle kernel NULL pointer dereference at 0000000000000bb8
[    6.787605] IP: [<ffffffff814107a0>] blk_throtl_drain+0x80/0x220
[    6.789797] PGD 0 
[    6.790598] Oops: 0000 [#1] SMP 
[    6.791848] Modules linked in: kvm_intel kvm snd_pcsp snd_pcm snd_timer snd ghash_clmulni_intel soundcore joydev ata_generic serio_raw pata_acpi libcrc32c crc8 crc_itu_t crc_ccitt virtio_pci virtio_mmio virtio_input virtio_balloon virtio_scsi sym53c8xx scsi_transport_spi megaraid_sas megaraid_mbox megaraid_mm megaraid ideapad_laptop rfkill sparse_keymap video virtio_net virtio_gpu ttm drm_kms_helper drm virtio_console virtio_rng virtio_blk virtio_ring virtio crc32 crct10dif_pclmul crc32c_intel crc32_pclmul
[    6.809710] CPU: 0 PID: 27 Comm: kworker/0:1 Not tainted 4.2.0-0.rc3.git4.1.fc24.x86_64 #1
[    6.812650] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.8.2-20150714_191134- 04/01/2014
[    6.816068] Workqueue: events_freezable virtscsi_handle_event [virtio_scsi]
[    6.818588] task: ffff88001dfb3a00 ti: ffff88001d090000 task.ti: ffff88001d090000
[    6.821252] RIP: 0010:[<ffffffff814107a0>]  [<ffffffff814107a0>] blk_throtl_drain+0x80/0x220
[    6.824302] RSP: 0000:ffff88001d0939d8  EFLAGS: 00010046
[    6.826213] RAX: 0000000000000000 RBX: ffff88001b8f6698 RCX: 00000000000000e0
[    6.828743] RDX: 31e18f88fc458000 RSI: 0000000000000000 RDI: 0000000000000000
[    6.831292] RBP: ffff88001d093a08 R08: 0000000000000000 R09: 0000000000000000
[    6.833835] R10: ffff88001dfb3a00 R11: ffffffff81e58200 R12: ffff88001ba67200
[    6.836380] R13: ffff88001b8f6698 R14: ffff88001b9ee1f0 R15: ffff88001b9ee0d0
[    6.838920] FS:  0000000000000000(0000) GS:ffff88001ee00000(0000) knlGS:0000000000000000
[    6.841781] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    6.843838] CR2: 0000000000000bb8 CR3: 00000000180c4000 CR4: 00000000000006f0
[    6.846383] Stack:
[    6.847132]  ffffffff81410756 ffff88001b9ee1f0 ffff88001d093a08 ffff88001b8f6698
[    6.849950]  ffffffff81ef5320 0000000000000000 ffff88001d093a28 ffffffff8140d5fd
[    6.852746]  ffff88001b8f6698 ffff88001b8f6698 ffff88001d093a58 ffffffff813e7839
[    6.855562] Call Trace:
[    6.856473]  [<ffffffff81410756>] ? blk_throtl_drain+0x36/0x220
[    6.858581]  [<ffffffff8140d5fd>] blkcg_drain_queue+0x2d/0x60
[    6.860639]  [<ffffffff813e7839>] __blk_drain_queue+0xc9/0x1a0
[    6.862741]  [<ffffffff813e9218>] ? blk_queue_bypass_start+0x68/0xb0
[    6.865029]  [<ffffffff813e9222>] blk_queue_bypass_start+0x72/0xb0
[    6.867236]  [<ffffffff8140b539>] blkcg_deactivate_policy+0x39/0x100
[    6.869513]  [<ffffffff814173e0>] cfq_exit_queue+0xd0/0xf0
[    6.871481]  [<ffffffff813e5081>] elevator_exit+0x31/0x50
[    6.873423]  [<ffffffff813ef91e>] blk_release_queue+0x4e/0xc0
[    6.875495]  [<ffffffff814204aa>] kobject_release+0x7a/0x190
[    6.877524]  [<ffffffff8142035f>] kobject_put+0x2f/0x60
[    6.879413]  [<ffffffff813e7765>] blk_put_queue+0x15/0x20
[    6.881351]  [<ffffffff815bf324>] scsi_device_dev_release_usercontext+0xc4/0x120
[    6.884010]  [<ffffffff815bf260>] ? scsi_device_dev_release+0x20/0x20
[    6.886297]  [<ffffffff810cad3c>] execute_in_process_context+0x9c/0xb0
[    6.888636]  [<ffffffff815bf25c>] scsi_device_dev_release+0x1c/0x20
[    6.890897]  [<ffffffff81573706>] device_release+0x36/0xa0
[    6.892867]  [<ffffffff814204aa>] kobject_release+0x7a/0x190
[    6.894901]  [<ffffffff8142035f>] kobject_put+0x2f/0x60
[    6.896772]  [<ffffffff81573a47>] put_device+0x17/0x20
[    6.898617]  [<ffffffff815b050f>] scsi_device_put+0x2f/0x40
[    6.900614]  [<ffffffffa0155f61>] virtscsi_handle_event+0x101/0x1a0 [virtio_scsi]
[    6.903284]  [<ffffffff810cb3b2>] process_one_work+0x232/0x840
[    6.905380]  [<ffffffff810cb31b>] ? process_one_work+0x19b/0x840
[    6.907522]  [<ffffffff8112553d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[    6.909893]  [<ffffffff810cba95>] ? worker_thread+0xd5/0x450
[    6.911921]  [<ffffffff810cba0e>] worker_thread+0x4e/0x450
[    6.913902]  [<ffffffff810cb9c0>] ? process_one_work+0x840/0x840
[    6.916066]  [<ffffffff810cb9c0>] ? process_one_work+0x840/0x840
[    6.918232]  [<ffffffff810d2594>] kthread+0x104/0x120
[    6.920059]  [<ffffffff810d2490>] ? kthread_create_on_node+0x250/0x250
[    6.922396]  [<ffffffff8187105f>] ret_from_fork+0x3f/0x70
[    6.924339]  [<ffffffff810d2490>] ? kthread_create_on_node+0x250/0x250
[    6.926663] Code: 04 24 56 07 41 81 e8 20 72 cf ff e8 9b 4d d1 ff 85 c0 74 0d 80 3d 64 04 b5 00 00 0f 84 19 01 00 00 49 8b 84 24 d0 00 00 00 31 ff <48> 8b 80 b8 0b 00 00 48 8b 70 28 e8 60 04 d5 ff 48 85 c0 48 89 
[    6.936207] RIP  [<ffffffff814107a0>] blk_throtl_drain+0x80/0x220
[    6.938432]  RSP <ffff88001d0939d8>
[    6.939692] CR2: 0000000000000bb8
[    6.940915] ---[ end trace f1acb54c2a225dd4 ]---

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-p2v converts physical machines to virtual machines.  Boot with a
live CD or over the network (PXE) and turn machines into KVM guests.
http://libguestfs.org/virt-v2v
