From: Michal Hocko <mhocko@kernel.org>
Subject: Re: general protection fault in __mem_cgroup_free
Date: Tue, 3 Apr 2018 11:43:29 +0200
Message-ID: <20180403094329.GJ5501@dhcp22.suse.cz>
References: <001a113fe4c0a623b10568bb75ea@google.com>
 <20180403093733.GI5501@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180403093733.GI5501@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+8a5de3cce7cdc70e9ebe@syzkaller.appspotmail.com>
Cc: cgroups@vger.kernel.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, vdavydov.dev@gmail.com, Andrey Ryabinin <aryabinin@virtuozzo.com>

On Tue 03-04-18 11:37:33, Michal Hocko wrote:
> [CC Andrey]
> 
> On Sat 31-03-18 13:47:05, syzbot wrote:
> > Hello,
> > 
> > syzbot hit the following crash on upstream commit
> > 9dd2326890d89a5179967c947dab2bab34d7ddee (Fri Mar 30 17:29:47 2018 +0000)
> > Merge tag 'ceph-for-4.16-rc8' of git://github.com/ceph/ceph-client
> > syzbot dashboard link:
> > https://syzkaller.appspot.com/bug?extid=8a5de3cce7cdc70e9ebe
> > 
> > So far this crash happened 14 times on upstream.
> > C reproducer: https://syzkaller.appspot.com/x/repro.c?id=5578311367393280
> > syzkaller reproducer:
> > https://syzkaller.appspot.com/x/repro.syz?id=5708657048158208
> > Raw console output:
> > https://syzkaller.appspot.com/x/log.txt?id=6693821748346880
> > Kernel config:
> > https://syzkaller.appspot.com/x/.config?id=-2760467897697295172
> > compiler: gcc (GCC) 7.1.1 20170620
> > 
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+8a5de3cce7cdc70e9ebe@syzkaller.appspotmail.com
> > It will help syzbot understand when the bug is fixed. See footer for
> > details.
> > If you forward the report, please keep this part and the footer.
> > 
> > RBP: 00000000006dcc20 R08: 0000000000000002 R09: 0000000000003335
> > R10: 0000000000000000 R11: 0000000000000246 R12: 0030656c69662f2e
> > R13: 00007f1747954d80 R14: ffffffffffffffff R15: 0000000000000006
> > kasan: CONFIG_KASAN_INLINE enabled
> > kasan: GPF could be caused by NULL-ptr deref or user memory access
> > general protection fault: 0000 [#1] SMP KASAN
> > Dumping ftrace buffer:
> >    (ftrace buffer empty)
> > Modules linked in:
> > CPU: 0 PID: 4422 Comm: syzkaller101598 Not tainted 4.16.0-rc7+ #372
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > RIP: 0010:free_mem_cgroup_per_node_info mm/memcontrol.c:4111 [inline]
> > RIP: 0010:__mem_cgroup_free+0x71/0x110 mm/memcontrol.c:4120
> 
> Is this a real bug or a KASAN false positive? The RIP points at
>         free_percpu(pn->lruvec_stat_cpu);
> 
> Which can be NULL if we are failing to allocate per-node data in
> mem_cgroup_alloc. You stack unwinder seems to point to
> mem_cgroup_css_alloc->mem_cgroup_free though and that one cannot see
> NULL memcg->nodeinfo[node] AFAICS.
> 
> Even if this is really mem_cgroup_alloc path then calling free_percpu
> with NULL pointer should be OK. Or am I missing something?

Scratch that. The bug is real. We can have memcg->nodeinfo[node] =
NULL from mem_cgroup_alloc. It uses the same failure path as the pcp
allocation failure.

This should fix it. I will send the full patch with proper changelog
shortly
---
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e3d5a0a7917f..0a9c4d5194f3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4340,6 +4340,9 @@ static void free_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
 {
 	struct mem_cgroup_per_node *pn = memcg->nodeinfo[node];
 
+	if (!pn)
+		return;
+
 	free_percpu(pn->lruvec_stat_cpu);
 	kfree(pn);
 }
-- 
Michal Hocko
SUSE Labs
