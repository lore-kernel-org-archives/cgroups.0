From: syzbot <syzbot+dd8e45eb61404849cde9-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Subject: Re: [syzbot] KMSAN: uninit-value in psi_poll_worker
Date: Fri, 26 Aug 2022 02:27:25 -0700
Message-ID: <000000000000a4d93d05e7218510@google.com>
References: <0000000000002c7abf05e721698d@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0000000000002c7abf05e721698d-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    3a2b6b904ea7 x86: kmsan: enable KMSAN builds for x86
git tree:       https://github.com/google/kmsan.git master
console+strace: https://syzkaller.appspot.com/x/log.txt?x=14d6a513080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8e64bc5364a1307e
dashboard link: https://syzkaller.appspot.com/bug?extid=dd8e45eb61404849cde9
compiler:       clang version 15.0.0 (https://github.com/llvm/llvm-project.git 610139d2d9ce6746b3c617fb3e2f7886272d26ff), GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10fc7ac7080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14ea06db080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+dd8e45eb61404849cde9-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org

=====================================================
BUG: KMSAN: uninit-value in psi_show+0x701/0x810 kernel/sched/psi.c:1082
 psi_show+0x701/0x810 kernel/sched/psi.c:1082
 cgroup_io_pressure_show+0x2b6/0x2f0 kernel/cgroup/cgroup.c:3662
 cgroup_seqfile_show+0x1fe/0x470 kernel/cgroup/cgroup.c:3991
 kernfs_seq_show+0x13b/0x1f0 fs/kernfs/file.c:217
 seq_read_iter+0x926/0x20c0 fs/seq_file.c:230
 kernfs_fop_read_iter+0x1f2/0xa10 fs/kernfs/file.c:299
 call_read_iter include/linux/fs.h:2181 [inline]
 generic_file_splice_read+0x1e5/0x770 fs/splice.c:309
 do_splice_to fs/splice.c:793 [inline]
 splice_direct_to_actor+0x5b2/0x1190 fs/splice.c:865
 do_splice_direct+0x252/0x3d0 fs/splice.c:974
 do_sendfile+0xbe9/0x1ba0 fs/read_write.c:1249
 __do_sys_sendfile64 fs/read_write.c:1317 [inline]
 __se_sys_sendfile64+0x202/0x2a0 fs/read_write.c:1303
 __x64_sys_sendfile64+0xb9/0x110 fs/read_write.c:1303
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:732 [inline]
 slab_alloc_node mm/slub.c:3258 [inline]
 slab_alloc mm/slub.c:3266 [inline]
 kmem_cache_alloc_trace+0x696/0xdf0 mm/slub.c:3297
 kmalloc include/linux/slab.h:600 [inline]
 psi_cgroup_alloc+0x83/0x250 kernel/sched/psi.c:960
 cgroup_create kernel/cgroup/cgroup.c:5430 [inline]
 cgroup_mkdir+0x10a3/0x3080 kernel/cgroup/cgroup.c:5550
 kernfs_iop_mkdir+0x2ba/0x520 fs/kernfs/dir.c:1185
 vfs_mkdir+0x62a/0x870 fs/namei.c:4013
 do_mkdirat+0x466/0x7b0 fs/namei.c:4038
 __do_sys_mkdirat fs/namei.c:4053 [inline]
 __se_sys_mkdirat fs/namei.c:4051 [inline]
 __x64_sys_mkdirat+0xc4/0x120 fs/namei.c:4051
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

CPU: 1 PID: 3493 Comm: syz-executor306 Not tainted 6.0.0-rc2-syzkaller-47460-g3a2b6b904ea7 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
=====================================================

