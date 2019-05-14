From: Roman Gushchin <guro@fb.com>
Subject: Re: WARNING: CPU: 1 PID: 228 at kernel/cgroup/cgroup.c:5929
Date: Tue, 14 May 2019 19:42:53 +0000
Message-ID: <20190514194249.GD12629@tower.DHCP.thefacebook.com>
References: <CAGnkfhwMSNm4uSkcGtqaGmYanfNK9rx6m2a3TqJh08YitbGAUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=x2HFRFfSV1QxX6NnMPuTXEkpxhm1CN1+DRXTpJBPqzY=;
 b=qf+YY+9tkLof8ft9297xPNc8GsFJugEcUFgvSB2SBe58rr0LhhuB9VXKMg1Bz7RJ37pv
 7osKi7pPJbrmI4RKmxJvj0jYdJ0b5pcfIbVn5sG0rmKwcgUYqX7e8xIJ084MHS6zd0Gc
 ktT4OJUV/DnICQYll/X90BvJ8O2Li6H6B+A= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x2HFRFfSV1QxX6NnMPuTXEkpxhm1CN1+DRXTpJBPqzY=;
 b=E60x6FJhQCjW2rBDumKABRYv4tXauNZoQSzyWbo3uRBZP3Cz+QAe1tn+M+/oLloUyowf2BWf1FGlTedLX3wNDGNZgsJBZgLeVEX1f+IYDKubB1hPVvpX1WYtyodxiTSRmIJG6vaUJQvaXlAWvhBFklYwHbILO2yxRh8aSHo6H9M=
In-Reply-To: <CAGnkfhwMSNm4uSkcGtqaGmYanfNK9rx6m2a3TqJh08YitbGAUg@mail.gmail.com>
Content-Language: en-US
Content-ID: <9BC2166E8518164EAC9F7F902EC5908D@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Matteo Croce <mcroce@redhat.com>
Cc: "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>

Hi Matteo!

Thank you for the report!

Can you, please, try the patch from this mail:
https://lkml.org/lkml/2019/5/14/639 ?

Thanks!

Roman

On Tue, May 14, 2019 at 09:23:48PM +0200, Matteo Croce wrote:
> Hi,
>=20
> I have the following splat when a ptraced process exits:
>=20
> root@debian64:~# strace true
> execve("/bin/true", ["true"], 0x7ffd444fdfb0 /* 18 vars */) =3D 0
> [..]
> exit_group(0)                           =3D ?
> [    5.394349] WARNING: CPU: 1 PID: 228 at kernel/cgroup/cgroup.c:5929 cg=
roup_exit+0xed/0x100
> [    5.394606] CPU: 1 PID: 228 Comm: true Not tainted 5.1.0-rc3-kvm+ #86
> [    5.394819] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1=
.12.0-2.fc30 04/01/2014
> [    5.395091] RIP: 0010:cgroup_exit+0xed/0x100
> [    5.395269] Code: 04 89 c3 7e d5 48 83 c4 08 5b 5d c3 f0 ff 43 28 0f 8=
8 8e 4d 34 00 eb a3 48 8b 85 78 06 00 00 48 8b 78 38 e8 e5 25 00 00 eb 82 <=
0f> 0b e9 5f ff ff ff 66 66 2e 0f 1f 84 00 00 00 00 00 90 55 be 05
> [    5.395827] RSP: 0018:ffffc9000037be38 EFLAGS: 00010002
> [    5.396009] RAX: ffff88807be8bc40 RBX: ffff888078f62400 RCX: ffff88807=
8f62468
> [    5.396236] RDX: ffff888078f62448 RSI: ffff888078f62400 RDI: ffff88807=
8f62408
> [    5.396463] RBP: ffff888078f89580 R08: ffff888078f89c60 R09: 000000000=
0000000
> [    5.396692] R10: ffff88807adc1100 R11: 0000000000000001 R12: ffff88807=
8f89580
> [    5.396919] R13: ffff888078f89b80 R14: 0000000000000000 R15: ffff88807=
8ed4060
> [    5.397169] FS:  0000000000000000(0000) GS:ffff88807da80000(0000) knlG=
S:0000000000000000
> [    5.397425] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    5.397614] CR2: 00007f017ea1d9a0 CR3: 0000000001a0c000 CR4: 000000000=
00006a0
> [    5.397846] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [    5.398097] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000=
0000400
> [    5.398324] Call Trace:
> [    5.398408]  do_exit+0x27f/0xa10
> [    5.398550]  ? ptrace_do_notify+0x6c/0x80
> [    5.398694]  do_group_exit+0x35/0xa0
> [    5.398838]  __x64_sys_exit_group+0xf/0x10
> [    5.398983]  do_syscall_64+0x48/0x340
> [    5.399127]  ? __do_page_fault+0x1aa/0x3f0
> [    5.399272]  ? __put_user_4+0x19/0x20
> [    5.399418]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [    5.399598] RIP: 0033:0x7f017ea1d9d6
> [    5.399745] Code: Bad RIP value.
> [    5.399885] RSP: 002b:00007ffc187f7aa8 EFLAGS: 00000246 ORIG_RAX: 0000=
0000000000e7
> [    5.400144] RAX: ffffffffffffffda RBX: 00007f017eb0e760 RCX: 00007f017=
ea1d9d6
> [    5.400370] RDX: 0000000000000000 RSI: 000000000000003c RDI: 000000000=
0000000
> [    5.400601] RBP: 0000000000000000 R08: 00000000000000e7 R09: fffffffff=
fffff80
> [    5.400858] R10: 00007ffc187f7974 R11: 0000000000000246 R12: 00007f017=
eb0e760
> [    5.401105] R13: 0000000000000001 R14: 00007f017eb17428 R15: 000000000=
0000000
> [    5.401337] ---[ end trace 6bf3ae0d5396cf27 ]---
>=20
> I found the offending commit bisecting, and seems to be this one.
>=20
> commit 96b9c592def5d7203bdad1337d9c92a2183de5cb
> Author: Roman Gushchin <guro@fb.com>
> Date:   Fri Apr 26 10:59:45 2019 -0700
>=20
>     cgroup: get rid of cgroup_freezer_frozen_exit()
>=20
>=20
> Regards,
> --=20
> Matteo Croce
> per aspera ad upstream
