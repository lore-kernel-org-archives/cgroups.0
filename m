From: syzbot <syzbot+65684128cd7c35bc66a1-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Subject: Re: inconsistent lock state in sco_conn_del
Date: Sat, 12 Sep 2020 05:59:07 -0700
Message-ID: <000000000000e5419905af1d5d2b@google.com>
References: <0000000000004991e705ac9d1a83@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0000000000004991e705ac9d1a83-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, johan.hedberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, kennyyu-b10kYP2dOMg@public.gmane.org, kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org

syzbot has bisected this issue to:

commit 135b8b37bd91cc82f83e98fca109b80375f5317e
Author: Kenny Yu <kennyyu-b10kYP2dOMg@public.gmane.org>
Date:   Tue Jun 21 18:04:36 2016 +0000

    cgroup: Add pids controller event when fork fails because of pid limit

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12f6d80d900000
start commit:   e8878ab8 Merge tag 'spi-fix-v5.9-rc4' of git://git.kernel...
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11f6d80d900000
console output: https://syzkaller.appspot.com/x/log.txt?x=16f6d80d900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c61610091f4ca8c4
dashboard link: https://syzkaller.appspot.com/bug?extid=65684128cd7c35bc66a1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=121ef0fd900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16c3a853900000

Reported-by: syzbot+65684128cd7c35bc66a1-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Fixes: 135b8b37bd91 ("cgroup: Add pids controller event when fork fails because of pid limit")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
