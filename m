From: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [syzbot] WARNING in cpuset_write_resmask
Date: Tue, 3 May 2022 13:48:52 +0200
Message-ID: <CACT4Y+aV-3dT7QDSs1a+yuJ_AZHJZQYDEK4fKwC-ZjsP+65LJg@mail.gmail.com>
References: <000000000000264b2a05d44bca80@google.com> <00000000000070561105dbd91673@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bSXV9PrUUGhVycOu/J4fBj5chKdIrO0Ql5olYi0vSd8=;
        b=EhLk4QD8o470moC0OQtXUJEkeGOuhJP7m3BdSFzrKvpKeHc++CQ5VcBNB8p+t/+ULb
         mUs0X7+NoyUX71r4F4Q6AqvPde/whddEC8nQgV7/xuf543eAWAourHoKkPFOJIVkJ7f5
         y5S8nlT5aC3a9dDgieTz47gxlMOYr7Fq+aor/UlSZpj5j4euCtAGzUU6xKKogQ7B2GID
         bCDIgFY52vnw19sjxzyI8JFWMW3iwMEo4+N/DPmGXgTUmP0vrhPGU2Yb7CNN3YJ0BJxk
         v0UUrXC5KaM/A6D9gMwaP6XrN3FgYA8EFuKmgSEuQVmzC+EFHcPsMnGdc4JYv7c99/Go
         txgQ==
In-Reply-To: <00000000000070561105dbd91673-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: syzbot <syzbot+568dc81cd20b72d4a49f-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, changbin.du-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, hkallweit1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yajun.deng-fxUVXftIFDnyG1zEObXtfA@public.gmane.org

On Mon, 4 Apr 2022 at 21:25, syzbot
<syzbot+568dc81cd20b72d4a49f-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit d068eebbd4822b6c14a7ea375dfe53ca5c69c776
> Author: Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org>
> Date:   Fri Dec 17 15:48:54 2021 +0000
>
>     cgroup/cpuset: Make child cpusets restrict parents on v1 hierarchy
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D142f17f770=
0000
> start commit:   e5313968c41b Merge branch 'Split bpf_sk_lookup remote_por=
t..
> git tree:       bpf-next
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dc40b67275bfe2=
a58
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D568dc81cd20b72d=
4a49f
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D13bb97ce700=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D12062c8e70000=
0
>
> If the result looks correct, please mark the issue as fixed by replying w=
ith:
>
> #syz fix: cgroup/cpuset: Make child cpusets restrict parents on v1 hierar=
chy
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisect=
ion

Based on commit subject looks reasonable:

#syz fix: cgroup/cpuset: Make child cpusets restrict parents on v1 hierarch=
y
