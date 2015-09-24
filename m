From: Andrey Wagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: WARNING: static_key_slow_dec used before call to jump_label_init
Date: Thu, 24 Sep 2015 10:10:59 +0300
Message-ID: <CANaxB-xdm4ewW+sNV5G9tCi0F0Q5zEvYBpEcGCLuneogkom78Q@mail.gmail.com>
References: <CANaxB-yFuS4SA2znSvcKrO9L_CbHciHYW+o9bN8sZJ8eR9FxYA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=sIuDFmDFjszkJIW5S0noaSiKkTMEhVF06L2gIOTRXm8=;
        b=cTxoa4QAK1YHEqyNEwIMww9nz8YTApoRyTq0r81Tvor5YnC8Iibuqiax3zminMH5kq
         eUNvCDz5J4ZbJAeX8TX2FiijSBX46SI/OIq63cnjF3RnABib2ZRytsp9XSNa+ekU/h2W
         KgFN6KXob3vf9/yW/c7Rslckv5R6JIWvV5US1OFQYfMlOKWkfeofsEPK/0WIbqCx6i2z
         E9vTbzJnwOVPlbmm3oUTDNfbYswnvXMhsVcraqIuPtOffyLv0H82VBjMaen4pepHfskR
         wHuOERdiY5D2DMYh3RJpclzrdfTMbDDsbYHe1zCXZ7jkdBydxO97bPmd1W1+YHLt1Iup
         PnUg==
In-Reply-To: <CANaxB-yFuS4SA2znSvcKrO9L_CbHciHYW+o9bN8sZJ8eR9FxYA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

2015-09-24 9:57 GMT+03:00 Andrey Wagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Hello,
>
> I booted kernel with cgroup_disable=cpu and get this warning:
>
> [    0.000000] Kernel command line:
> BOOT_IMAGE=/boot/vmlinuz-4.3.0-rc2-next-20150923 no_timer_check
> console=ttyS0,115200n8 root=UUID=01bc7316-b1f4-45c9-a23a-0

[    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-4.3.0-rc2-next-20150923 no_timer_check
console=ttyS0,115200n8 root=UUID=01bc7316-b1f4-45c9-a23a-00c5a2336ef2
console=tty1 ro rhgb quiet LANG=en_US.UTF-8
initrd=/boot/initramfs-4.3.0-rc2-next-20150923.img debug
cgroup_disable=cpu
You have new mail in /var/spool/mail/root

> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: CPU: 0 PID: 0 at kernel/jump_label.c:99
> static_key_slow_dec+0x44/0x60()
> [    0.000000] static_key_slow_dec used before call to jump_label_init
> [    0.000000] Modules linked in:
>
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted
> 4.3.0-rc2-next-20150924 #1
> [    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    0.000000]  0000000000000000 ebd8af5cfcdffb28 ffffffff81c03da8
> ffffffff813b18c2
> [    0.000000]  ffffffff81c03df0 ffffffff81c03de0 ffffffff8108dd52
> ffffffff81c5bad0
> [    0.000000]  ffff88003ffe663a ffffffff81c49a00 0000000000000001
> ffff88003ffe662b
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff813b18c2>] dump_stack+0x44/0x62
> [    0.000000]  [<ffffffff8108dd52>] warn_slowpath_common+0x82/0xc0
> [    0.000000]  [<ffffffff8108ddec>] warn_slowpath_fmt+0x5c/0x80
> [    0.000000]  [<ffffffff8119c054>] static_key_slow_dec+0x44/0x60
> [    0.000000]  [<ffffffff81d826b6>] cgroup_disable+0xaf/0xd6
> [    0.000000]  [<ffffffff81d5f9de>] unknown_bootoption+0x8c/0x194
> [    0.000000]  [<ffffffff810b0c03>] parse_args+0x273/0x4a0
> [    0.000000]  [<ffffffff8119d592>] ? printk+0x57/0x73
> [    0.000000]  [<ffffffff81d5fd67>] start_kernel+0x205/0x4b8
> [    0.000000]  [<ffffffff81d5f952>] ? set_init_arg+0x55/0x55
> [    0.000000]  [<ffffffff81d5f120>] ? early_idt_handler_array+0x120/0x120
> [    0.000000]  [<ffffffff81d5f315>] x86_64_start_reservations+0x2a/0x2c
> [    0.000000]  [<ffffffff81d5f461>] x86_64_start_kernel+0x14a/0x16d
> [    0.000000] ---[ end trace 8a774ae3ff020690 ]---
>
> Thanks,
> Andrew
