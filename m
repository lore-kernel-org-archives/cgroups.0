From: syzbot <syzbot+2ab700fe1829880a2ec6-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Subject: Re: [syzbot] [cgroups?] possible deadlock in static_key_slow_inc (3)
Date: Thu, 08 Jun 2023 20:17:24 -0700
Message-ID: <000000000000d1565005fda9cef1@google.com>
References: <000000000000bd448705fda123f5@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <000000000000bd448705fda123f5-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, hverkuil-cisco-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org, hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

syzbot has bisected this issue to:

commit eb1d969203eb8212741751f88dcf5cb56bb11830
Author: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Date:   Fri Oct 21 12:21:25 2022 +0000

    media: vivid: fix control handler mutex deadlock

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16af9d95280000
start commit:   5f63595ebd82 Merge tag 'input-for-v6.4-rc5' of git://git.k..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15af9d95280000
console output: https://syzkaller.appspot.com/x/log.txt?x=11af9d95280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3c980bfe8b399968
dashboard link: https://syzkaller.appspot.com/bug?extid=2ab700fe1829880a2ec6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=142e0463280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10a32add280000

Reported-by: syzbot+2ab700fe1829880a2ec6-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Fixes: eb1d969203eb ("media: vivid: fix control handler mutex deadlock")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
