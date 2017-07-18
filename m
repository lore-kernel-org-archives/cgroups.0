From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: Show control files in cgroup2 root after mount
Date: Tue, 18 Jul 2017 16:00:45 -0400
Message-ID: <539870d2-8b85-2f54-61bd-4ba068e75ce0@redhat.com>
References: <1500406336-29512-1-git-send-email-longman@redhat.com>
 <20170718195148.GC3365493@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 517CB3B721
In-Reply-To: <20170718195148.GC3365493-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 07/18/2017 03:51 PM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Tue, Jul 18, 2017 at 03:32:16PM -0400, Waiman Long wrote:
>> It was found that when a cgroup2 filesystem was mounted, control
>> files other than the base cgroup.* ones were not shown in the root
>> directory.  They were shown only after some controllers were activated
>> in the root's cgroup.subtree_control file.
>>
>> This was caused by a lack of the kernfs_activate() call which was fixed
>> by this patch.
>>
>> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  kernel/cgroup/cgroup.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
>> index 89a23c6..fb1893b 100644
>> --- a/kernel/cgroup/cgroup.c
>> +++ b/kernel/cgroup/cgroup.c
>> @@ -2024,8 +2024,10 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
>>  
>>  		dentry = cgroup_do_mount(&cgroup2_fs_type, flags, &cgrp_dfl_root,
>>  					 CGROUP2_SUPER_MAGIC, ns);
>> -		if (!IS_ERR(dentry))
>> +		if (!IS_ERR(dentry)) {
>>  			apply_cgroup_root_flags(root_flags);
>> +			kernfs_activate(cgrp_dfl_root.cgrp.kn);
>> +		}
> Heh, that's tricky.  I'm not quite sure where the unactivated files
> are being added tho because that'd be where we should be activating.
> I *think* that they are already activated as part of
> cgroup_add_cftypes() but I am obviously qmissing something.  I'll try
> to repro the issue and find where we're skipping the activation call.
>
> Thanks!
>
From my own debugging, the controller files (e.g. the debug controller)
were indirectly populated by the rebind_subsystems() call.

[    1.628103] css_populate_dir: init subsystem debug
[    1.628944] ------------[ cut here ]------------
[    1.629796] WARNING: CPU: 0 PID: 1 at kernel/cgroup/cgroup.c:1584
css_populate_dir+0x141/0x180
[    1.631401] Modules linked in:
[    1.632052] CPU: 0 PID: 1 Comm: systemd Tainted: G        W      
4.13.0-rc1-cgroup2+ #13
[    1.633642] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[    1.634627] task: ffff91d84e1f0000 task.stack: ffffb40b8189c000
[    1.635630] RIP: 0010:css_populate_dir+0x141/0x180
[    1.636548] RSP: 0018:ffffb40b8189fb88 EFLAGS: 00010246
[    1.637457] RAX: 0000000000000026 RBX: ffff91d84fcb7ec0 RCX:
ffffffffaec60ae8
[    1.638538] RDX: 0000000000000000 RSI: 0000000000000082 RDI:
0000000000000246
[    1.639689] RBP: ffffb40b8189fbb0 R08: 0000000000000000 R09:
0000000000000325
[    1.640889] R10: 00000000ffffffff R11: 0000000000000324 R12:
ffffffffaecec3f8
[    1.642071] R13: ffff91d84fcb7ec0 R14: ffffffffaf1f6770 R15:
ffffffffaeceea60
[    1.643263] FS:  00007fc8c9624940(0000) GS:ffff91dad7200000(0000)
knlGS:0000000000000000
[    1.651469] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.653184] CR2: 00007fc8c9630000 CR3: 0000000190bff000 CR4:
00000000001406f0
[    1.654401] Call Trace:
[    1.654975]  cgroup_apply_control_enable+0x103/0x340
[    1.655906]  ? css_next_descendant_pre+0x35/0x40
[    1.656834]  ? cgroup_propagate_control+0x101/0x150
[    1.657719]  cgroup_apply_control+0x1a/0x30
[    1.658521]  rebind_subsystems+0x18a/0x3b0
[    1.659272]  cgroup_setup_root+0x18f/0x380
[    1.660086]  cgroup1_mount+0x2c5/0x490
[    1.660842]  cgroup_mount+0x9d/0x390
[    1.661586]  mount_fs+0x39/0x150
[    1.662238]  vfs_kern_mount+0x67/0x130
[    1.663027]  do_mount+0x1e2/0xc90
[    1.663718]  ? kmem_cache_alloc_trace+0x14b/0x1b0
[    1.664548]  SyS_mount+0x83/0xd0
[    1.665254]  entry_SYSCALL_64_fastpath+0x1a/0xa5

For the default cgroup2 root, kernfs_activate() was only called at the
beginning in cgroup_init() with only the base cgroup files added. No
more call after that until I touched the cgroup.subtree_control file.

Cheers,
Longman

