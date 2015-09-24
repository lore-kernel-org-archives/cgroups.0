From: Andrey Wagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: WARNING: static_key_slow_dec used before call to jump_label_init
Date: Thu, 24 Sep 2015 09:57:22 +0300
Message-ID: <CANaxB-yFuS4SA2znSvcKrO9L_CbHciHYW+o9bN8sZJ8eR9FxYA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        bh=4MyWn7K9lmzCQUA1ClQWlN3EeX5vB1SU+T8schHZHQQ=;
        b=Gm2rq7fGP3wXyf0C4HkJm72BoQw+GCk+ucmJ07L5hmq6LfCquz+ymbbcBUFDm46z3c
         gkybg2sNjBaXJi5UEEzsdL+7Ycg7DfLQWcnRdrNMyYjk/xMmkJeQGgKsYEDrW3zQaCka
         YQxk+7sYIxdEMDX8HS6OvuevoqPtsSVwhUv7wkLZZ/ivLlTBWHK96VqFyY7hl+LYSLXA
         +T89QRftbd8j9Z78O7dtHDwr0Ka4zsoUJwYZHxurmuOYVy23+0KSBLx/nk+VpoiDek+5
         YB01wT55PLLAy6kIdHJpDMvf8R5TqYx2oUJ7dwB2gHkO/uh1NIrecfwJArZnUO5h7nd4
         rQgQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hello,

I booted kernel with cgroup_disable=cpu and get this warning:

[    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-4.3.0-rc2-next-20150923 no_timer_check
console=ttyS0,115200n8 root=UUID=01bc7316-b1f4-45c9-a23a-0
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/jump_label.c:99
static_key_slow_dec+0x44/0x60()
[    0.000000] static_key_slow_dec used before call to jump_label_init
[    0.000000] Modules linked in:

[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted
4.3.0-rc2-next-20150924 #1
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000]  0000000000000000 ebd8af5cfcdffb28 ffffffff81c03da8
ffffffff813b18c2
[    0.000000]  ffffffff81c03df0 ffffffff81c03de0 ffffffff8108dd52
ffffffff81c5bad0
[    0.000000]  ffff88003ffe663a ffffffff81c49a00 0000000000000001
ffff88003ffe662b
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff813b18c2>] dump_stack+0x44/0x62
[    0.000000]  [<ffffffff8108dd52>] warn_slowpath_common+0x82/0xc0
[    0.000000]  [<ffffffff8108ddec>] warn_slowpath_fmt+0x5c/0x80
[    0.000000]  [<ffffffff8119c054>] static_key_slow_dec+0x44/0x60
[    0.000000]  [<ffffffff81d826b6>] cgroup_disable+0xaf/0xd6
[    0.000000]  [<ffffffff81d5f9de>] unknown_bootoption+0x8c/0x194
[    0.000000]  [<ffffffff810b0c03>] parse_args+0x273/0x4a0
[    0.000000]  [<ffffffff8119d592>] ? printk+0x57/0x73
[    0.000000]  [<ffffffff81d5fd67>] start_kernel+0x205/0x4b8
[    0.000000]  [<ffffffff81d5f952>] ? set_init_arg+0x55/0x55
[    0.000000]  [<ffffffff81d5f120>] ? early_idt_handler_array+0x120/0x120
[    0.000000]  [<ffffffff81d5f315>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81d5f461>] x86_64_start_kernel+0x14a/0x16d
[    0.000000] ---[ end trace 8a774ae3ff020690 ]---

Thanks,
Andrew
