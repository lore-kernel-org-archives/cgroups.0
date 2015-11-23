From: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Subject: WARN in __mark_inode_dirty when mounting a filesystem
Date: Mon, 23 Nov 2015 17:40:36 +0200
Message-ID: <56533374.2090807@kyup.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

Hello Tejun, 

On one of my servers I recently hit the following warn: 

182317.101584] ------------[ cut here ]------------
[182317.101753] WARNING: CPU: 7 PID: 13192 at fs/fs-writeback.c:2080 __mark_inode_dirty+0x20a/0x350()
[182317.102032] bdi-block not registered
[182317.102192] Kernel panic - not syncing: panic_on_warn set ...
                
[182317.102474] CPU: 7 PID: 13192 Comm: mount Not tainted 4.2.5-vanilla1 #1
[182317.102647] Hardware name: Supermicro X9DRi-LN4+/X9DR3-LN4+/X9DRi-LN4+/X9DR3-LN4+, BIOS 3.0 07/05/2013
[182317.102942]  0000000000000820 ffff88026440f968 ffffffff8158d43e 0000000000000000
[182317.103307]  ffffffff817cb826 ffff88026440f9e8 ffffffff8158d1b8 ffff880200000008
[182317.103673]  ffff88026440f9f8 ffff88026440f998 0000000000000246 0000000000000030
[182317.104036] Call Trace:
[182317.104207]  [<ffffffff8158d43e>] dump_stack+0x48/0x5a
[182317.104380]  [<ffffffff8158d1b8>] panic+0xc1/0x20d
[182317.104556]  [<ffffffff81054292>] warn_slowpath_common+0xd2/0xe0
[182317.104730]  [<ffffffff81054356>] warn_slowpath_fmt+0x46/0x50
[182317.104903]  [<ffffffff811bdfea>] __mark_inode_dirty+0x20a/0x350
[182317.105076]  [<ffffffff811c777d>] ? __set_page_dirty+0x7d/0xd0
[182317.105248]  [<ffffffff811c8157>] mark_buffer_dirty+0x97/0x110
[182317.105421]  [<ffffffff812310d3>] ext4_commit_super+0x193/0x260
[182317.105596]  [<ffffffff812314ee>] ext4_setup_super+0xee/0x1e0
[182317.105774]  [<ffffffff8123dbad>] ext4_fill_super+0x172d/0x2210
[182317.105951]  [<ffffffff8114aa06>] ? memcg_init_list_lru_node+0x46/0x70
[182317.106127]  [<ffffffff81197c4f>] mount_bdev+0x1af/0x1f0
[182317.106300]  [<ffffffff8117143f>] ? alloc_pages_current+0xaf/0x160
[182317.106475]  [<ffffffff8123c480>] ? ext4_alloc_flex_bg_array+0x110/0x110
[182317.106651]  [<ffffffff8122d415>] ext4_mount+0x15/0x20
[182317.106824]  [<ffffffff81197813>] mount_fs+0x43/0x170
[182317.106997]  [<ffffffff811b4b06>] vfs_kern_mount+0x76/0x130
[182317.107169]  [<ffffffff811b5a38>] do_new_mount+0xc8/0x370
[182317.107343]  [<ffffffff811b60f0>] do_mount+0x1c0/0x1f0
[182317.107515]  [<ffffffff811b619b>] SyS_mount+0x7b/0xc0
[182317.107687]  [<ffffffff815917ee>] entry_SYSCALL_64_fastpath+0x12/0x71

WARN(bdi_cap_writeback_dirty(wb->bdi) &&
     !test_bit(WB_registered, &wb->state),
     "bdi-%s not registered\n", wb->bdi->name);


On examining the crashdump the main reason is that wb->state in this 
case is 0. The device in question is a dm-thin volume. WB_registered 
is basically set in either bdi_register or cgwb_create functions. 
However, I couldn't figure where those are called for dm devices. Looking
at struct bdi_writeback the blkcg_css points to blkcg_root and memcg_css 
also points to the root memcg. IOW the process is in the root cgroup. 

Essentially I'm trying to figure out where is the BDI for this device supposed
to be initialised (registered) so that the warn doesn't trigger? This is 
happening on a 4.2.5 vanilla kernel. I have a complete crashdump from when
this happened so if you need any more state information I'd be happy to 
provide it. 

This is triggered when a activating a volume group, then activating the 
logical volume and finally mounting the volume and on this mounting happening 
the warn is triggered. 
