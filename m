From: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [syzbot] [cgroups?] [mm?] KCSAN: data-race in drain_all_stock /
 drain_obj_stock (4)
Date: Fri, 21 Apr 2023 16:38:45 +0200
Message-ID: <CACT4Y+ZfucZhM60YPphWiCLJr6+SGFhT+jjm8k1P-a_8Kkxsjg@mail.gmail.com>
References: <00000000000058b63f05f9d98811@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682087938; x=1684679938;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uE8L66mYi61Gg000YX9CaB4PguSbhnlIM05Rg2iq/GU=;
        b=g3rmUy97ewR5Qob/EIc0qirnHyGan7c3n7pweFBrjd4IKEX1NVaHijC/5eHO4MNEDW
         Ff3BUAQNyy0m/fGS9YWwhDtiFnB5bLlPAjjH6fTEFwOvUJbkRqH9u3P763jj6of+sfJV
         eh1paFZ6ywkGWJqWKXSSu3i6LkZ0rb1dLjXid+GjA3s3hyJwVUlPonXyw6Cz30d88pjH
         TLOU/sY30TqTHGlXm0/qbIZsfLkAThaztVPBD3OR4nmNuVPX6xNzmzb7bGHzouRJKy77
         iQTEbiCwwv2DBX8+uESfd1BeUMHZ/N3avr3F3IScinfFcGzEoNS/DlIRNt1JSYsaTWTy
         mWzw==
In-Reply-To: <00000000000058b63f05f9d98811-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+774c29891415ab0fd29d-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org

On Fri, 21 Apr 2023 at 16:33, syzbot
<syzbot+774c29891415ab0fd29d-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    534293368afa Merge tag 'kbuild-fixes-v6.3' of git://git.ke..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11a0c26ec80000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=85fa20c996a2e46d
> dashboard link: https://syzkaller.appspot.com/bug?extid=774c29891415ab0fd29d
> compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/ec0e584af797/disk-53429336.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/423a67f52f94/vmlinux-53429336.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/8409b9716faa/bzImage-53429336.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+774c29891415ab0fd29d-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org

Here this:

stock->cached_objcg = NULL;

runs concurrently with:

if (stock->cached_objcg) {
    memcg = obj_cgroup_memcg(stock->cached_objcg);

If I am reading this correctly, this can cause a NULL deref, if
cached_objcg is reset between the check and the use.



> ==================================================================
> BUG: KCSAN: data-race in drain_all_stock / drain_obj_stock
>
> write to 0xffff888237c2a2f8 of 8 bytes by task 19625 on cpu 0:
>  drain_obj_stock+0x408/0x4e0 mm/memcontrol.c:3306
>  refill_obj_stock+0x9c/0x1e0 mm/memcontrol.c:3340
>  obj_cgroup_uncharge+0xe/0x10 mm/memcontrol.c:3408
>  memcg_slab_free_hook mm/slab.h:587 [inline]
>  __cache_free mm/slab.c:3373 [inline]
>  __do_kmem_cache_free mm/slab.c:3577 [inline]
>  kmem_cache_free+0x105/0x280 mm/slab.c:3602
>  __d_free fs/dcache.c:298 [inline]
>  dentry_free fs/dcache.c:375 [inline]
>  __dentry_kill+0x422/0x4a0 fs/dcache.c:621
>  dentry_kill+0x8d/0x1e0
>  dput+0x118/0x1f0 fs/dcache.c:913
>  __fput+0x3bf/0x570 fs/file_table.c:329
>  ____fput+0x15/0x20 fs/file_table.c:349
>  task_work_run+0x123/0x160 kernel/task_work.c:179
>  resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
>  exit_to_user_mode_loop+0xcf/0xe0 kernel/entry/common.c:171
>  exit_to_user_mode_prepare+0x6a/0xa0 kernel/entry/common.c:203
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
>  syscall_exit_to_user_mode+0x26/0x140 kernel/entry/common.c:296
>  do_syscall_64+0x4d/0xc0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> read to 0xffff888237c2a2f8 of 8 bytes by task 19632 on cpu 1:
>  obj_stock_flush_required mm/memcontrol.c:3319 [inline]
>  drain_all_stock+0x174/0x2a0 mm/memcontrol.c:2361
>  try_charge_memcg+0x6d0/0xd10 mm/memcontrol.c:2703
>  try_charge mm/memcontrol.c:2837 [inline]
>  mem_cgroup_charge_skmem+0x51/0x140 mm/memcontrol.c:7290
>  sock_reserve_memory+0xb1/0x390 net/core/sock.c:1025
>  sk_setsockopt+0x800/0x1e70 net/core/sock.c:1525
>  udp_lib_setsockopt+0x99/0x6c0 net/ipv4/udp.c:2692
>  udp_setsockopt+0x73/0xa0 net/ipv4/udp.c:2817
>  sock_common_setsockopt+0x61/0x70 net/core/sock.c:3668
>  __sys_setsockopt+0x1c3/0x230 net/socket.c:2271
>  __do_sys_setsockopt net/socket.c:2282 [inline]
>  __se_sys_setsockopt net/socket.c:2279 [inline]
>  __x64_sys_setsockopt+0x66/0x80 net/socket.c:2279
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> value changed: 0xffff8881382d52c0 -> 0xffff888138893740
>
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 1 PID: 19632 Comm: syz-executor.0 Not tainted 6.3.0-rc2-syzkaller-00387-g534293368afa #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
> ==================================================================
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/00000000000058b63f05f9d98811%40google.com.
