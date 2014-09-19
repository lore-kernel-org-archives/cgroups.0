From: Cong Wang <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Kernel crash in cgroup_pidlist_destroy_work_fn()
Date: Thu, 18 Sep 2014 17:23:53 -0700
Message-ID: <CAM_iQpUFy4q-8=F=YW9fnE5XGWUiFH7nxEKQXfT4gh5S8Ehu=Q@mail.gmail.com>
References: <CAM_iQpVNzx1r8x-bP5CoiCX8PFk15JYHw_XfpYvJGgdkFHj8Gw@mail.gmail.com>
	<54191C41.3080003@huawei.com>
	<541953AF.7000201@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=E/dfig4MPt7zDqbXi+fyuVc04HY3pF7N2NDz9JQ4rtg=;
        b=RWOFC+y7VmYeUGo7w5vLKJvZHacEW20OTpjZoH41c+BTeprxazFU3EARUxpIOYBhz5
         Rzs61rJInEXYGIJBbYJK++QRPEpKV0epbJ2lTAwXq9Cc+k94BnN+Uhtn8ZIikYSJhInw
         0tHCOtHS1zzHZYl57XRSksO1mXltwKtmx7SRs3Wf/CjjfNC8pB2InhrLYWLLY+nB2zdU
         GAkbJPjwiyov4PsKdAmLgPXd65grqme6Qn5NutaVMCc0y0cgJWAoVlLWvocC9MhBY/5Z
         Y8Js2LWI/JPsGGvFOGtgCBKStShpoJUDf9X5N5ZS+ZadSP8HRrVz6UjrZdpmEt9C5vWa
         FBJA==
In-Reply-To: <541953AF.7000201-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi, Zefan


Thanks for your reply. You are right, vfs refcount should guarantee us
there is no more file read before we destroy that cgroup. I thought
there is somewhere else could release that cgroup refcount.

Maybe I didn't make it clear, this bug is hardly reproducible, we only
saw it once (otherwise I would have more clue and test my patch).
The full stacktrace is at the end of this email, for your reference.

Reading the code again, I thought we could have some race in-flight
work and pending work, but cgroup_pidlist_destroy_work_fn() should
get this right by checking the pending bit after holding mutex, what's
more, we should only have one in-flight work for this workqueue, therefore
the code seems pretty safe.

The unbalanced mutex_unlock() you fixed actually is hard to hit since
the memory must run out in that case, and I don't get any OOM
information from the bug reporter. So I think I can rule out this case.


Thanks!

--------------------------------------->

[15955.313964] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000027
[15955.314958] IP: [<ffffffff814ad8b5>] __mutex_lock_slowpath+0x2f/0x1a0
[15955.316088] PGD 0
[15955.316310] Oops: 0000 [#1] SMP
[15955.316810] Modules linked in: tun ipv6 bonding dm_multipath
scsi_dh video sbs sbshc acpi_pad acpi_ipmi parport_pc lp parport
tcp_diag inet_diag ipmi_devintf dell_rbu sg igb i2c_algo_bit ptp
pps_core iTCO_wdt iTCO_vendor_support dcdbas hed ipmi_si
ipmi_msghandler i7core_edac i2c_i801 shpchp i2c_core edac_core ioatdma
dca lpc_ich mfd_core microcode ahci libahci libata sd_mod scsi_mod
[15955.321422] CPU: 5 PID: 7280 Comm: kworker/5:2 Not tainted 3.14.14 #1
[15955.322275] Hardware name: Dell       C6100           /0D61XP, BIOS
1.66 12/23/2011
[15955.323326] Workqueue: cgroup_pidlist_destroy cgroup_pidlist_destroy_work_fn
[15955.324317] task: ffff8800ad899840 ti: ffff880323b50000 task.ti:
ffff880323b50000
[15955.325236] RIP: 0010:[<ffffffff814ad8b5>]  [<ffffffff814ad8b5>]
__mutex_lock_slowpath+0x2f/0x1a0
[15955.326465] RSP: 0018:ffff880323b51dc0  EFLAGS: 00010286
[15955.327178] RAX: ffffffffffffffff RBX: ffff88032c7de0f8 RCX: ffff88032e188ac0
[15955.328061] RDX: 0000000080000000 RSI: 0000000000000140 RDI: ffff88032c7de0f8
[15955.328927] RBP: ffff880323b51e08 R08: ffff88032e188ac0 R09: 0000000000000000
[15955.329784] R10: 0000000000000000 R11: 0000000000000040 R12: 0000000000000000
[15955.330778] R13: ffff8800ad899840 R14: ffff880333cb7200 R15: 0000000000000000
[15955.331650] FS:  0000000000000000(0000) GS:ffff880333ca0000(0000)
knlGS:0000000000000000
[15955.332616] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[15955.333329] CR2: 0000000000000027 CR3: 0000000001a0c000 CR4: 00000000000007e0
[15955.334584] Stack:
[15955.334798]  ffff880323b51e08 ffffffff8100163f ffff880323b51de8
ffffffff8107d6e8
[15955.335751]  ffff88032c7de0f8 0000000000000000 ffff880333cb2300
ffff880333cb7200
[15955.336831]  0000000000000000 ffff880323b51e20 ffffffff814ada45
ffff88032e188ab8
[15955.337779] Call Trace:
[15955.338053]  [<ffffffff8100163f>] ? __switch_to+0x1ca/0x3d2
[15955.338739]  [<ffffffff8107d6e8>] ? mmdrop+0x11/0x20
[15955.339386]  [<ffffffff814ada45>] mutex_lock+0x1f/0x2f
[15955.340054]  [<ffffffff810bd2b9>] cgroup_pidlist_destroy_work_fn+0x22/0x66
[15955.340898]  [<ffffffff810710b9>] process_one_work+0x16d/0x289
[15955.341629]  [<ffffffff81071877>] worker_thread+0x149/0x1f5
[15955.342327]  [<ffffffff8107172e>] ? rescuer_thread+0x27f/0x27f
[15955.343049]  [<ffffffff810764db>] kthread+0xae/0xb6
[15955.343685]  [<ffffffff81070000>] ? idle_worker_timeout+0x4/0x5b
[15955.344499]  [<ffffffff8107642d>] ? __kthread_parkme+0x61/0x61
[15955.345245]  [<ffffffff814b532c>] ret_from_fork+0x7c/0xb0
[15955.345934]  [<ffffffff8107642d>] ? __kthread_parkme+0x61/0x61
[15955.346663] Code: 90 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 89
fb 48 83 e4 f0 48 83 ec 20 65 4c 8b 2c 25 80 b8 00 00 48 8b 47 18 48
85 c0 74 05 <8b> 40 28 eb 05 b8 01 00 00 00 85 c0 0f 84 9f 00 00 00 4c
8d 63
[15955.349439] RIP  [<ffffffff814ad8b5>] __mutex_lock_slowpath+0x2f/0x1a0
[15955.350270]  RSP <ffff880323b51dc0>
[15955.350635] CR2: 0000000000000027
[15955.351481] ---[ end trace 169754b1b86c507e ]---
