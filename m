From: Roman Gushchin <guro@fb.com>
Subject: Re: WARNING in cgroup_exit
Date: Wed, 8 May 2019 04:19:58 +0000
Message-ID: <20190508041950.GA29396@castle>
References: <000000000000a573da058858083c@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=PL+cCfAiQG1R6Xx5r1Hl7gTS8cogqZ6EL7hry29zehU=;
 b=W7cBdHkUidgmx6lLbaJHhmKy+QsaO+D1AqbDPASomvL6lyq1tqoOOBhe1HDV6OfhQyzc
 ye460NxRVg4Bh+AZKsiNtiaErpaoM1EsjYVI1e++0m1AFqFN/axfmMMvKyfDWJ7EOF8O
 ELVr1erwxaMMxJT1R/WY2gGplm0Ro/h39r0= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PL+cCfAiQG1R6Xx5r1Hl7gTS8cogqZ6EL7hry29zehU=;
 b=BqdEm1/r762Z6yHeYGy196B/G7KmjmNjl7DHda2ktwUFRQu/rymHqqDNLOWD+GUSf/UVe579UyrsPVCO1EaYgQ5b9KNhgdoDtfsb6OQTj9LKkmHHI72BKliIrhIx2b5H0rFXGCYNF3Aa8nC9Cm5mx0fEElayklGng9u+pvOJwDg=
In-Reply-To: <000000000000a573da058858083c@google.com>
Content-Language: en-US
Content-ID: <5ABAAF49F10CC241A744BA0F8295D68F@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: syzbot <syzbot+f14868630901fc6151d3@syzkaller.appspotmail.com>
Cc: "ast@kernel.org" <ast@kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, Martin Lau <kafai@fb.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "lizefan@huawei.com" <lizefan@huawei.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Song Liu <songliubraving@fb.com>, "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>, "tj@kernel.org" <tj@kernel.org>, Yonghong Song <yhs@fb.com>

Hi!

I'm aware of this problem and presumably know where it comes from. I expect=
 that
https://github.com/rgushchin/linux/commit/b1b6d210789ac0f5d83fd45fdab35eba1=
3cd2ce8
will fix it. I'll post it upstream tomorrow after some additional checks.

Thanks!

Roman

On Tue, May 07, 2019 at 08:36:07PM -0700, syzbot wrote:
> Hello,
>=20
> syzbot found the following crash on:
>=20
> HEAD commit:    00c3bc00 Add linux-next specific files for 20190507
> git tree:       linux-next
> console output: https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__sy=
zkaller.appspot.com_x_log.txt-3Fx-3D15220ec8a00000&d=3DDwIBaQ&c=3D5VD0RTtNl=
Th3ycd41b3MUw&r=3DjJYgtDM7QT-W-Fz_d29HYQ&m=3D4iaRvebxGXyCS0fK4EQzBl8b5C4bdR=
pBidLVWLI_GuM&s=3DhD1Gj5E63Z0nnx5OQgxeVKb91lJkZHE3qat1sAGP1ZI&e=3D
> kernel config:  https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__sy=
zkaller.appspot.com_x_.config-3Fx-3D63cd766601c6c9fc&d=3DDwIBaQ&c=3D5VD0RTt=
NlTh3ycd41b3MUw&r=3DjJYgtDM7QT-W-Fz_d29HYQ&m=3D4iaRvebxGXyCS0fK4EQzBl8b5C4b=
dRpBidLVWLI_GuM&s=3D_232tg9h9GVIkU_E6zSkqXt_VzdcnBSpy_oTxiER55s&e=3D
> dashboard link: https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__sy=
zkaller.appspot.com_bug-3Fextid-3Df14868630901fc6151d3&d=3DDwIBaQ&c=3D5VD0R=
TtNlTh3ycd41b3MUw&r=3DjJYgtDM7QT-W-Fz_d29HYQ&m=3D4iaRvebxGXyCS0fK4EQzBl8b5C=
4bdRpBidLVWLI_GuM&s=3DodzDbHDodu7xVLUX5bYH4hZS4TDEJ_Q-Wda-pamijDo&e=3D
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__sy=
zkaller.appspot.com_x_repro.syz-3Fx-3D10fcf758a00000&d=3DDwIBaQ&c=3D5VD0RTt=
NlTh3ycd41b3MUw&r=3DjJYgtDM7QT-W-Fz_d29HYQ&m=3D4iaRvebxGXyCS0fK4EQzBl8b5C4b=
dRpBidLVWLI_GuM&s=3DynJR0QYyNDxBMdGoc8vUawwmdbQQ4uGaH47E1lCToTw&e=3D
> C reproducer:   https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__sy=
zkaller.appspot.com_x_repro.c-3Fx-3D1202ffa4a00000&d=3DDwIBaQ&c=3D5VD0RTtNl=
Th3ycd41b3MUw&r=3DjJYgtDM7QT-W-Fz_d29HYQ&m=3D4iaRvebxGXyCS0fK4EQzBl8b5C4bdR=
pBidLVWLI_GuM&s=3DTOZmN6wU-5eoDmgsf8dUSHVHfd8PiXWMHtLF8zIfVR0&e=3D
>=20
> IMPORTANT: if you fix the bug, please add the following tag to the commit=
:
> Reported-by: syzbot+f14868630901fc6151d3@syzkaller.appspotmail.com
>=20
> WARNING: CPU: 0 PID: 8653 at kernel/cgroup/cgroup.c:6008
> cgroup_exit+0x51a/0x5d0 kernel/cgroup/cgroup.c:6008
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 0 PID: 8653 Comm: syz-executor076 Not tainted 5.1.0-next-20190507 #2
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
>  panic+0x2cb/0x75a kernel/panic.c:218
>  __warn.cold+0x20/0x47 kernel/panic.c:575
>  report_bug+0x263/0x2b0 lib/bug.c:186
>  fixup_bug arch/x86/kernel/traps.c:179 [inline]
>  fixup_bug arch/x86/kernel/traps.c:174 [inline]
>  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
>  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
>  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:972
> RIP: 0010:cgroup_exit+0x51a/0x5d0 kernel/cgroup/cgroup.c:6008
> Code: 00 48 c7 c2 20 7f 6d 87 be d3 01 00 00 48 c7 c7 20 80 6d 87 c6 05 0=
1
> 93 f1 07 01 e8 fb 03 ed ff e9 b1 fb ff ff e8 96 f9 05 00 <0f> 0b e9 75 fc=
 ff
> ff e8 8a f9 05 00 48 c7 c2 e0 82 6d 87 be 85 02
> RSP: 0018:ffff888086c17a80 EFLAGS: 00010093
> RAX: ffff88808e99a000 RBX: 0000000000000001 RCX: ffffffff816b0b5e
> RDX: 0000000000000000 RSI: ffffffff816b0eea RDI: 0000000000000001
> RBP: ffff888086c17b18 R08: ffff88808e99a000 R09: ffffed1010d82f3e
> R10: ffffed1010d82f3d R11: 0000000000000003 R12: ffff88808e99a000
> R13: ffff8880981c3200 R14: ffff888086c17af0 R15: 1ffff11010d82f52
>  do_exit+0x97a/0x2fa0 kernel/exit.c:889
>  do_group_exit+0x135/0x370 kernel/exit.c:980
>  get_signal+0x425/0x2270 kernel/signal.c:2638
>  do_signal+0x87/0x1900 arch/x86/kernel/signal.c:815
>  exit_to_usermode_loop+0x244/0x2c0 arch/x86/entry/common.c:163
>  prepare_exit_to_usermode arch/x86/entry/common.c:198 [inline]
>  syscall_return_slowpath arch/x86/entry/common.c:276 [inline]
>  do_syscall_64+0x57e/0x670 arch/x86/entry/common.c:301
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x4471e9
> Code: e8 3c e6 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f=
7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff
> 0f 83 ab 06 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f479f748db8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> RAX: fffffffffffffe00 RBX: 00000000006dcc38 RCX: 00000000004471e9
> RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00000000006dcc38
> RBP: 00000000006dcc30 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dcc3c
> R13: 00007ffd1ab0c31f R14: 00007f479f7499c0 R15: 0000000000000001
> Shutting down cpus with NMI
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
>=20
>=20
> ---
> This bug is generated by a bot. It may contain errors.
> See https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__goo.gl_tpsmEJ&=
d=3DDwIBaQ&c=3D5VD0RTtNlTh3ycd41b3MUw&r=3DjJYgtDM7QT-W-Fz_d29HYQ&m=3D4iaRve=
bxGXyCS0fK4EQzBl8b5C4bdRpBidLVWLI_GuM&s=3D-w9lCOsM40BNPAQbJETOta_aO2oUunuWH=
F7_HEF_s4M&e=3D for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>=20
> syzbot will keep track of this bug report. See:
> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__goo.gl_tpsmEJ-23st=
atus&d=3DDwIBaQ&c=3D5VD0RTtNlTh3ycd41b3MUw&r=3DjJYgtDM7QT-W-Fz_d29HYQ&m=3D4=
iaRvebxGXyCS0fK4EQzBl8b5C4bdRpBidLVWLI_GuM&s=3DwbPAdt5WlkacKUJ6S-HTGGEVDOC1=
zOhIrPgSCdOq3UI&e=3D for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__goo.gl_tpsmEJ-23te=
sting-2Dpatches&d=3DDwIBaQ&c=3D5VD0RTtNlTh3ycd41b3MUw&r=3DjJYgtDM7QT-W-Fz_d=
29HYQ&m=3D4iaRvebxGXyCS0fK4EQzBl8b5C4bdRpBidLVWLI_GuM&s=3DOmC7nK5BIF4c92BuG=
G7AK2hjFHZhajxJG-VJh0jJRvc&e=3D
