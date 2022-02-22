From: syzbot <syzbot+568dc81cd20b72d4a49f-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Subject: Re: [syzbot] WARNING in cpuset_write_resmask
Date: Mon, 21 Feb 2022 19:28:09 -0800
Message-ID: <0000000000002752dc05d892f094@google.com>
References: <000000000000264b2a05d44bca80@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <000000000000264b2a05d44bca80-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, changbin.du-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, hkallweit1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yajun.deng-fxUVXftIFDnyG1zEObXtfA@public.gmane.org

syzbot has bisected this issue to:

commit e4b8954074f6d0db01c8c97d338a67f9389c042f
Author: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Date:   Tue Dec 7 01:30:37 2021 +0000

    netlink: add net device refcount tracker to struct ethnl_req_info

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15c42532700000
start commit:   e5313968c41b Merge branch 'Split bpf_sk_lookup remote_port..
git tree:       bpf-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17c42532700000
console output: https://syzkaller.appspot.com/x/log.txt?x=13c42532700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c40b67275bfe2a58
dashboard link: https://syzkaller.appspot.com/bug?extid=568dc81cd20b72d4a49f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13bb97ce700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12062c8e700000

Reported-by: syzbot+568dc81cd20b72d4a49f-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Fixes: e4b8954074f6 ("netlink: add net device refcount tracker to struct ethnl_req_info")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
