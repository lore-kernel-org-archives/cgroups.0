From: Jiri Slaby <jslaby@suse.cz>
Subject: memcg causes crashes in list_lru_add
Date: Mon, 29 Apr 2019 10:16:28 +0200
Message-ID: <f0cfcfa7-74d0-8738-1061-05d778155462@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, mm <linux-mm@kvack.org>, Linux kernel mailing list <linux-kernel@vger.kernel.org>

Hi,

with new enough systemd, one of our systems 100% crashes during boot.
Kernels I tried are all affected: 5.1-rc7, 5.0.10 stable, 4.12.14.

The 5.1-rc7 crash:
> [   12.022637] systemd[1]: Starting Create list of required static device nodes for the current kernel...
> [   12.023353] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> [   12.041502] #PF error: [normal kernel read fault]
> [   12.041502] PGD 0 P4D 0 
> [   12.041502] Oops: 0000 [#1] SMP NOPTI
> [   12.041502] CPU: 0 PID: 208 Comm: (kmod) Not tainted 5.1.0-rc7-1.g04c1966-default #1 openSUSE Tumbleweed (unreleased)
> [   12.041502] Hardware name: Supermicro H8DSP-8/H8DSP-8, BIOS 080011  06/30/2006
> [   12.041502] RIP: 0010:list_lru_add+0x94/0x170
> [   12.041502] Code: c6 07 00 66 66 66 90 31 c0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 49 8b 7c 24 20 49 8d 54 24 08 48 85 ff 74 07 e9 46 00 00 00 31 ff <48> 8b 42 08 4c 89 6a 08 49 89 55 00 49 89 45 08 4c 89 28 48 8b 42
> [   12.041502] RSP: 0018:ffffb11b8091be50 EFLAGS: 00010202
> [   12.041502] RAX: 0000000000000001 RBX: ffff930b35705a40 RCX: ffff9309cf21ade0
> [   12.041502] RDX: 0000000000000000 RSI: ffff930ab61bc587 RDI: ffff930a17711000
> [   12.041502] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> [   12.041502] R10: 0000000000000000 R11: 0000000000000008 R12: ffff9309f5f86640
> [   12.041502] R13: ffff930ab5705a40 R14: 0000000000000001 R15: ffff930a171dc4e0
> [   12.041502] FS:  00007f42d6ea5940(0000) GS:ffff930ab7800000(0000) knlGS:0000000000000000
> [   12.041502] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   12.041502] CR2: 0000000000000008 CR3: 0000000057dec000 CR4: 00000000000006f0
> [   12.041502] Call Trace:
> [   12.041502]  d_lru_add+0x44/0x50
> [   12.041502]  dput.part.34+0xfc/0x110
> [   12.041502]  __fput+0x108/0x230
> [   12.041502]  task_work_run+0x9f/0xc0
> [   12.041502]  exit_to_usermode_loop+0xf5/0x100
> [   12.041502]  do_syscall_64+0xe2/0x110
> [   12.041502]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [   12.041502] RIP: 0033:0x7f42d77567b7
> [   12.041502] Code: ff ff ff ff c3 48 8b 15 df 96 0c 00 f7 d8 64 89 02 b8 ff ff ff ff eb c0 66 2e 0f 1f 84 00 00 00 00 00 90 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 8b 15 b1 96 0c 00 f7 d8 64 89 02 b8
> [   12.041502] RSP: 002b:00007fffeb85c2c8 EFLAGS: 00000202 ORIG_RAX: 0000000000000003
> [   12.041502] RAX: 0000000000000000 RBX: 000055dfb6222fd0 RCX: 00007f42d77567b7
> [   12.041502] RDX: 00007f42d78217c0 RSI: 000055dfb6223053 RDI: 0000000000000003
> [   12.041502] RBP: 00007f42d78223c0 R08: 000055dfb62230b0 R09: 00007fffeb85c0f5
> [   12.041502] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000000
> [   12.041502] R13: 000055dfb6225080 R14: 00007fffeb85c3aa R15: 0000000000000003
> [   12.041502] Modules linked in:
> [   12.041502] CR2: 0000000000000008
> [   12.491424] ---[ end trace 574d0c998e97d864 ]---

Enabling KASAN reveals a bit more:
> Allocated by task 1:
>  __kasan_kmalloc.constprop.13+0xc1/0xd0
>  __list_lru_init+0x3cd/0x5e0

This is kvmalloc in memcg_init_list_lru_node:
        memcg_lrus = kvmalloc(sizeof(*memcg_lrus) +
                              size * sizeof(void *), GFP_KERNEL);

>  sget_userns+0x65c/0xba0
>  kernfs_mount_ns+0x120/0x7f0
>  cgroup_do_mount+0x93/0x2e0
>  cgroup1_mount+0x335/0x925
>  cgroup_mount+0x14a/0x7b0
>  mount_fs+0xce/0x304
>  vfs_kern_mount.part.33+0x58/0x370
>  do_mount+0x390/0x2540
>  ksys_mount+0xb6/0xd0
...
>
> Freed by task 1:
>  __kasan_slab_free+0x125/0x170
>  kfree+0x90/0x1a0
>  acpi_ds_terminate_control_method+0x5a2/0x5c9

This is a different object (the address overflowed to an acpi-allocated
memory). Irrelevant info.

> The buggy address belongs to the object at ffff8880d69a2e68
>  which belongs to the cache kmalloc-16 of size 16
> The buggy address is located 8 bytes to the right of
>  16-byte region [ffff8880d69a2e68, ffff8880d69a2e78)

Hmm, 16byte slab. 'memcg_lrus' allocated above is 'struct
list_lru_memcg' defined as:
        struct rcu_head         rcu;
        /* array of per cgroup lists, indexed by memcg_cache_id */
        struct list_lru_one     *lru[0];

sizeof(struct rcu_head) is 16. So it must mean that 'size' used in the
'kvmalloc' above in 'memcg_init_list_lru_node' is 0. That cannot be correct.

This confirms the theory:
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -366,8 +366,14 @@ static int memcg_init_list_lru_node(stru
        struct list_lru_memcg *memcg_lrus;
        int size = memcg_nr_cache_ids;

+       if (!size) {
+               pr_err("%s: XXXXXXXXX size is zero yet!\n", __func__);
+               size = 256;
+       }
+
        memcg_lrus = kvmalloc(sizeof(*memcg_lrus) +
                              size * sizeof(void *), GFP_KERNEL);
+       printk(KERN_DEBUG "%s:    a=%px\n", __func__, memcg_lrus);
        if (!memcg_lrus)
                return -ENOMEM;


and even makes the beast booting. memcg has very wrong assumptions on
'memcg_nr_cache_ids'. It does not assume it can change later, despite it
does.

These are dump_stacks from 'memcg_alloc_cache_id' which changes
'memcg_nr_cache_ids' later during boot:
CPU: 1 PID: 1 Comm: systemd Tainted: G            E
5.0.10-0.ge8fc1e9-default #1 openSUSE Tumbleweed (unreleased)
Hardware name: Supermicro H8DSP-8/H8DSP-8, BIOS 080011  06/30/2006
Call Trace:
 dump_stack+0x9a/0xf0
 mem_cgroup_css_alloc+0xb16/0x16a0
 cgroup_apply_control_enable+0x2d7/0xb40
 cgroup_mkdir+0x594/0xc50
 kernfs_iop_mkdir+0x21a/0x2e0
 vfs_mkdir+0x37a/0x5d0
 do_mkdirat+0x1b1/0x200
 do_syscall_64+0xa5/0x290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe




I am not sure why this is machine-dependent. I cannot reproduce on any
other box.

Any idea how to fix this mess?

The report is in our bugzilla:
https://bugzilla.suse.com/show_bug.cgi?id=1133616

thanks,
-- 
js
suse labs
