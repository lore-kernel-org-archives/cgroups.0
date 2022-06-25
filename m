From: syzbot <syzbot+ec972d37869318fc3ffb-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Subject: Re: [syzbot] WARNING in folio_lruvec_lock_irqsave
Date: Fri, 24 Jun 2022 23:00:09 -0700
Message-ID: <0000000000003ad3d705e23f66ae@google.com>
References: <0000000000004b03c805e2099bf0@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0000000000004b03c805e2099bf0-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org

syzbot has bisected this issue to:

commit cca700a8e695fbe4a647e3a509ac513f05d5740a
Author: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Date:   Tue Jun 21 12:56:58 2022 +0000

    mm: lru: use lruvec lock to serialize memcg changes

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15abaf18080000
start commit:   ac0ba5454ca8 Add linux-next specific files for 20220622
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17abaf18080000
console output: https://syzkaller.appspot.com/x/log.txt?x=13abaf18080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=12809dacb9e7c5e0
dashboard link: https://syzkaller.appspot.com/bug?extid=ec972d37869318fc3ffb
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12d0f470080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1145df0ff00000

Reported-by: syzbot+ec972d37869318fc3ffb-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Fixes: cca700a8e695 ("mm: lru: use lruvec lock to serialize memcg changes")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
