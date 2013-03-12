From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH -v2] device: separate all subsys mutexes (was: Re: [BUG]
 potential deadlock led by cpu_hotplug lock (memcg involved))
Date: Tue, 12 Mar 2013 17:21:19 +0100
Message-ID: <20130312162119.GB5963@dhcp22.suse.cz>
References: <513ECCFE.3070201@huawei.com>
 <20130312101555.GB30758@dhcp22.suse.cz>
 <20130312110750.GC30758@dhcp22.suse.cz>
 <20130312130504.GD30758@dhcp22.suse.cz>
 <20130312133446.GA3514@kroah.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130312133446.GA3514-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>

On Tue 12-03-13 06:34:46, Greg Kroah-Hartman wrote:
> On Tue, Mar 12, 2013 at 02:05:04PM +0100, Michal Hocko wrote:
> > The fix is quite simple. We can pull the key inside bus_type structure
> > because they are defined per device so the pointer will be unique as
> > well. bus_register doesn't need to be a macro anymore so change it
> > to the inline. We could get rid of __bus_register as there is no other
> > caller but maybe somebody will want to use a different key so keep it
> > around for now.
> 
> Nice work, but just drop __bus_register(), no one should need to use a
> new key for this type of thing, now that you have added a per-bus_type
> variable.

OK v2 below. I have also ranamed __key to lock_key. Who is going to take
the patch?
---
From e40ec869758f6d52b8f7192cac38646f2cd9bc34 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Date: Tue, 12 Mar 2013 17:18:28 +0100
Subject: [PATCH] device: separate all subsys mutexes

ca22e56d (driver-core: implement 'sysdev' functionality for regular
devices and buses) has introduced bus_register macro with a static
key to distinguish different subsys mutex classes.

This however doesn't work for different subsys which use a common
registering function. One example is subsys_system_register (and
mce_device and cpu_device).

In the end this leads to the following lockdep splat:
[  207.271924] ======================================================
[  207.271932] [ INFO: possible circular locking dependency detected ]
[  207.271942] 3.9.0-rc1-0.7-default+ #34 Not tainted
[  207.271948] -------------------------------------------------------
[  207.271957] bash/10493 is trying to acquire lock:
[  207.271963]  (subsys mutex){+.+.+.}, at: [<ffffffff8134af27>] bus_remove_device+0x37/0x1c0
[  207.271987]
[  207.271987] but task is already holding lock:
[  207.271995]  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff81046ccf>] cpu_hotplug_begin+0x2f/0x60
[  207.272012]
[  207.272012] which lock already depends on the new lock.
[  207.272012]
[  207.272023]
[  207.272023] the existing dependency chain (in reverse order) is:
[  207.272033]
[  207.272033] -> #4 (cpu_hotplug.lock){+.+.+.}:
[  207.272044]        [<ffffffff810ae329>] lock_acquire+0xe9/0x120
[  207.272056]        [<ffffffff814ad807>] mutex_lock_nested+0x37/0x360
[  207.272069]        [<ffffffff81046ba9>] get_online_cpus+0x29/0x40
[  207.272082]        [<ffffffff81185210>] drain_all_stock+0x30/0x150
[  207.272094]        [<ffffffff811853da>] mem_cgroup_reclaim+0xaa/0xe0
[  207.272104]        [<ffffffff8118775e>] __mem_cgroup_try_charge+0x51e/0xcf0
[  207.272114]        [<ffffffff81188486>] mem_cgroup_charge_common+0x36/0x60
[  207.272125]        [<ffffffff811884da>] mem_cgroup_newpage_charge+0x2a/0x30
[  207.272135]        [<ffffffff81150531>] do_wp_page+0x231/0x830
[  207.272147]        [<ffffffff8115151e>] handle_pte_fault+0x19e/0x8d0
[  207.272157]        [<ffffffff81151da8>] handle_mm_fault+0x158/0x1e0
[  207.272166]        [<ffffffff814b6153>] do_page_fault+0x2a3/0x4e0
[  207.272178]        [<ffffffff814b2578>] page_fault+0x28/0x30
[  207.272189]
[  207.272189] -> #3 (&mm->mmap_sem){++++++}:
[  207.272199]        [<ffffffff810ae329>] lock_acquire+0xe9/0x120
[  207.272208]        [<ffffffff8114c5ad>] might_fault+0x6d/0x90
[  207.272218]        [<ffffffff811a11e3>] filldir64+0xb3/0x120
[  207.272229]        [<ffffffffa013fc19>] call_filldir+0x89/0x130 [ext3]
[  207.272248]        [<ffffffffa0140377>] ext3_readdir+0x6b7/0x7e0 [ext3]
[  207.272263]        [<ffffffff811a1519>] vfs_readdir+0xa9/0xc0
[  207.272273]        [<ffffffff811a15cb>] sys_getdents64+0x9b/0x110
[  207.272284]        [<ffffffff814bb599>] system_call_fastpath+0x16/0x1b
[  207.272296]
[  207.272296] -> #2 (&type->i_mutex_dir_key#3){+.+.+.}:
[  207.272309]        [<ffffffff810ae329>] lock_acquire+0xe9/0x120
[  207.272319]        [<ffffffff814ad807>] mutex_lock_nested+0x37/0x360
[  207.272329]        [<ffffffff8119c254>] link_path_walk+0x6f4/0x9a0
[  207.272339]        [<ffffffff8119e7fa>] path_openat+0xba/0x470
[  207.272349]        [<ffffffff8119ecf8>] do_filp_open+0x48/0xa0
[  207.272358]        [<ffffffff8118d81c>] file_open_name+0xdc/0x110
[  207.272369]        [<ffffffff8118d885>] filp_open+0x35/0x40
[  207.272378]        [<ffffffff8135c76e>] _request_firmware+0x52e/0xb20
[  207.272389]        [<ffffffff8135cdd6>] request_firmware+0x16/0x20
[  207.272399]        [<ffffffffa03bdb91>] request_microcode_fw+0x61/0xd0 [microcode]
[  207.272416]        [<ffffffffa03bd554>] microcode_init_cpu+0x104/0x150 [microcode]
[  207.272431]        [<ffffffffa03bd61c>] mc_device_add+0x7c/0xb0 [microcode]
[  207.272444]        [<ffffffff8134a419>] subsys_interface_register+0xc9/0x100
[  207.272457]        [<ffffffffa04fc0f4>] 0xffffffffa04fc0f4
[  207.272472]        [<ffffffff81000202>] do_one_initcall+0x42/0x180
[  207.272485]        [<ffffffff810bbeff>] load_module+0x19df/0x1b70
[  207.272499]        [<ffffffff810bc376>] sys_init_module+0xe6/0x130
[  207.272511]        [<ffffffff814bb599>] system_call_fastpath+0x16/0x1b
[  207.272523]
[  207.272523] -> #1 (umhelper_sem){++++.+}:
[  207.272537]        [<ffffffff810ae329>] lock_acquire+0xe9/0x120
[  207.272548]        [<ffffffff814ae9c4>] down_read+0x34/0x50
[  207.272559]        [<ffffffff81062bff>] usermodehelper_read_trylock+0x4f/0x100
[  207.272575]        [<ffffffff8135c7dd>] _request_firmware+0x59d/0xb20
[  207.272587]        [<ffffffff8135cdd6>] request_firmware+0x16/0x20
[  207.272599]        [<ffffffffa03bdb91>] request_microcode_fw+0x61/0xd0 [microcode]
[  207.272613]        [<ffffffffa03bd554>] microcode_init_cpu+0x104/0x150 [microcode]
[  207.272627]        [<ffffffffa03bd61c>] mc_device_add+0x7c/0xb0 [microcode]
[  207.272641]        [<ffffffff8134a419>] subsys_interface_register+0xc9/0x100
[  207.272654]        [<ffffffffa04fc0f4>] 0xffffffffa04fc0f4
[  207.272666]        [<ffffffff81000202>] do_one_initcall+0x42/0x180
[  207.272678]        [<ffffffff810bbeff>] load_module+0x19df/0x1b70
[  207.272690]        [<ffffffff810bc376>] sys_init_module+0xe6/0x130
[  207.272702]        [<ffffffff814bb599>] system_call_fastpath+0x16/0x1b
[  207.272715]
[  207.272715] -> #0 (subsys mutex){+.+.+.}:
[  207.272729]        [<ffffffff810ae002>] __lock_acquire+0x13b2/0x15f0
[  207.272740]        [<ffffffff810ae329>] lock_acquire+0xe9/0x120
[  207.272751]        [<ffffffff814ad807>] mutex_lock_nested+0x37/0x360
[  207.272763]        [<ffffffff8134af27>] bus_remove_device+0x37/0x1c0
[  207.272775]        [<ffffffff81349114>] device_del+0x134/0x1f0
[  207.272786]        [<ffffffff813491f2>] device_unregister+0x22/0x60
[  207.272798]        [<ffffffff814a24ea>] mce_cpu_callback+0x15e/0x1ad
[  207.272812]        [<ffffffff814b6402>] notifier_call_chain+0x72/0x130
[  207.272824]        [<ffffffff81073d6e>] __raw_notifier_call_chain+0xe/0x10
[  207.272839]        [<ffffffff81498f76>] _cpu_down+0x1d6/0x350
[  207.272851]        [<ffffffff81499130>] cpu_down+0x40/0x60
[  207.272862]        [<ffffffff8149cc55>] store_online+0x75/0xe0
[  207.272874]        [<ffffffff813474a0>] dev_attr_store+0x20/0x30
[  207.272886]        [<ffffffff812090d9>] sysfs_write_file+0xd9/0x150
[  207.272900]        [<ffffffff8118e10b>] vfs_write+0xcb/0x130
[  207.272911]        [<ffffffff8118e924>] sys_write+0x64/0xa0
[  207.272923]        [<ffffffff814bb599>] system_call_fastpath+0x16/0x1b
[  207.272936]
[  207.272936] other info that might help us debug this:
[  207.272936]
[  207.272952] Chain exists of:
[  207.272952]   subsys mutex --> &mm->mmap_sem --> cpu_hotplug.lock
[  207.272952]
[  207.272973]  Possible unsafe locking scenario:
[  207.272973]
[  207.272984]        CPU0                    CPU1
[  207.272992]        ----                    ----
[  207.273000]   lock(cpu_hotplug.lock);
[  207.273009]                                lock(&mm->mmap_sem);
[  207.273020]                                lock(cpu_hotplug.lock);
[  207.273031]   lock(subsys mutex);
[  207.273040]
[  207.273040]  *** DEADLOCK ***
[  207.273040]
[  207.273055] 5 locks held by bash/10493:
[  207.273062]  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff81209049>] sysfs_write_file+0x49/0x150
[  207.273080]  #1:  (s_active#150){.+.+.+}, at: [<ffffffff812090c2>] sysfs_write_file+0xc2/0x150
[  207.273099]  #2:  (x86_cpu_hotplug_driver_mutex){+.+.+.}, at: [<ffffffff81027557>] cpu_hotplug_driver_lock+0x17/0x20
[  207.273121]  #3:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8149911c>] cpu_down+0x2c/0x60
[  207.273140]  #4:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff81046ccf>] cpu_hotplug_begin+0x2f/0x60
[  207.273158]
[  207.273158] stack backtrace:
[  207.273170] Pid: 10493, comm: bash Not tainted 3.9.0-rc1-0.7-default+ #34
[  207.273180] Call Trace:
[  207.273192]  [<ffffffff810ab373>] print_circular_bug+0x223/0x310
[  207.273204]  [<ffffffff810ae002>] __lock_acquire+0x13b2/0x15f0
[  207.273216]  [<ffffffff812086b0>] ? sysfs_hash_and_remove+0x60/0xc0
[  207.273227]  [<ffffffff810ae329>] lock_acquire+0xe9/0x120
[  207.273239]  [<ffffffff8134af27>] ? bus_remove_device+0x37/0x1c0
[  207.273251]  [<ffffffff814ad807>] mutex_lock_nested+0x37/0x360
[  207.273263]  [<ffffffff8134af27>] ? bus_remove_device+0x37/0x1c0
[  207.273274]  [<ffffffff812086b0>] ? sysfs_hash_and_remove+0x60/0xc0
[  207.273286]  [<ffffffff8134af27>] bus_remove_device+0x37/0x1c0
[  207.273298]  [<ffffffff81349114>] device_del+0x134/0x1f0
[  207.273309]  [<ffffffff813491f2>] device_unregister+0x22/0x60
[  207.273321]  [<ffffffff814a24ea>] mce_cpu_callback+0x15e/0x1ad
[  207.273332]  [<ffffffff814b6402>] notifier_call_chain+0x72/0x130
[  207.273344]  [<ffffffff81073d6e>] __raw_notifier_call_chain+0xe/0x10
[  207.273356]  [<ffffffff81498f76>] _cpu_down+0x1d6/0x350
[  207.273368]  [<ffffffff81027557>] ? cpu_hotplug_driver_lock+0x17/0x20
[  207.273380]  [<ffffffff81499130>] cpu_down+0x40/0x60
[  207.273391]  [<ffffffff8149cc55>] store_online+0x75/0xe0
[  207.273402]  [<ffffffff813474a0>] dev_attr_store+0x20/0x30
[  207.273413]  [<ffffffff812090d9>] sysfs_write_file+0xd9/0x150
[  207.273425]  [<ffffffff8118e10b>] vfs_write+0xcb/0x130
[  207.273436]  [<ffffffff8118e924>] sys_write+0x64/0xa0
[  207.273447]  [<ffffffff814bb599>] system_call_fastpath+0x16/0x1b

Which reports a false possitive deadlock because it sees:
1) load_module -> subsys_interface_register -> mc_deveice_add (*) -> subsys->p->mutex -> link_path_walk -> lookup_slow -> i_mutex
2) sys_write -> _cpu_down -> cpu_hotplug_begin -> cpu_hotplug.lock -> mce_cpu_callback -> mce_device_remove(**) -> device_unregister -> bus_remove_device -> subsys mutex
3) vfs_readdir -> i_mutex -> filldir64 -> might_fault -> might_lock_read(mmap_sem) -> page_fault -> mmap_sem -> drain_all_stock -> cpu_hotplug.lock

but
1) takes cpu_subsys subsys (*) but 2) takes mce_device subsys (**) so
the deadlock is not possible AFAICS.

The fix is quite simple. We can pull the key inside bus_type structure
because they are defined per device so the pointer will be unique as
well. bus_register doesn't need to be a macro anymore so change it
to the inline. We could get rid of __bus_register as there is no other
caller but maybe somebody will want to use a different key so keep it
around for now.

Reported-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Signed-off-by: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
---
 drivers/base/bus.c     |    8 ++++----
 include/linux/device.h |   12 +++---------
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 24eb078..4a299b3 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -898,18 +898,18 @@ static ssize_t bus_uevent_store(struct bus_type *bus,
 static BUS_ATTR(uevent, S_IWUSR, NULL, bus_uevent_store);
 
 /**
- * __bus_register - register a driver-core subsystem
+ * bus_register - register a driver-core subsystem
  * @bus: bus to register
- * @key: lockdep class key
  *
  * Once we have that, we register the bus with the kobject
  * infrastructure, then register the children subsystems it has:
  * the devices and drivers that belong to the subsystem.
  */
-int __bus_register(struct bus_type *bus, struct lock_class_key *key)
+int bus_register(struct bus_type *bus)
 {
 	int retval;
 	struct subsys_private *priv;
+	struct lock_class_key *key = &bus->lock_key;
 
 	priv = kzalloc(sizeof(struct subsys_private), GFP_KERNEL);
 	if (!priv)
@@ -981,7 +981,7 @@ out:
 	bus->p = NULL;
 	return retval;
 }
-EXPORT_SYMBOL_GPL(__bus_register);
+EXPORT_SYMBOL_GPL(bus_register);
 
 /**
  * bus_unregister - remove a bus from the system
diff --git a/include/linux/device.h b/include/linux/device.h
index 43dcda9..6793a19 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -110,17 +110,11 @@ struct bus_type {
 	struct iommu_ops *iommu_ops;
 
 	struct subsys_private *p;
+	struct lock_class_key lock_key;
 };
 
-/* This is a #define to keep the compiler from merging different
- * instances of the __key variable */
-#define bus_register(subsys)			\
-({						\
-	static struct lock_class_key __key;	\
-	__bus_register(subsys, &__key);	\
-})
-extern int __must_check __bus_register(struct bus_type *bus,
-				       struct lock_class_key *key);
+extern int __must_check bus_register(struct bus_type *bus);
+
 extern void bus_unregister(struct bus_type *bus);
 
 extern int __must_check bus_rescan_devices(struct bus_type *bus);
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
