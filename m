From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: WARNING in try_charge
Date: Mon, 6 Aug 2018 19:47:00 +0900
Message-ID: <884de816-671a-44d4-a6a1-2ad7eff53715@I-love.SAKURA.ne.jp>
References: <0000000000005e979605729c1564@google.com>
 <20180806091552.GE19540@dhcp22.suse.cz>
 <CACT4Y+Ystnwv4M6Uh+HBKbdADAnJ6otfR0GoA20crzqV+b2onQ@mail.gmail.com>
 <20180806094827.GH19540@dhcp22.suse.cz>
 <CACT4Y+ZEAoPWxEJ2yAf6b5cSjAm+MPx1yrk70BWHRrnDYdyb_A@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+ZEAoPWxEJ2yAf6b5cSjAm+MPx1yrk70BWHRrnDYdyb_A@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dmitry Vyukov <dvyukov@google.com>, Michal Hocko <mhocko@kernel.org>
Cc: syzbot <syzbot+bab151e82a4e973fa325@syzkaller.appspotmail.com>, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vladimir Davydov <vdavydov.dev@gmail.com>

On 2018/08/06 19:39, Dmitry Vyukov wrote:
> On Mon, Aug 6, 2018 at 11:48 AM, Michal Hocko <mhocko@kernel.org> wrote:
>> Btw. running with the above diff on top might help us to ideantify
>> whether this is a pre-mature warning or a valid one. Still useful to
>> find out.

Since syzbot already found a syz reproducer, you can ask syzbot to test it.

> 
> The bug report has a reproducer, so you can run it with the patch. Or
> ask syzbot to test your patch:
> https://github.com/google/syzkaller/blob/master/docs/syzbot.md#testing-patches
> Which basically boils down to saying:
> 
> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> master

Excuse me, but this is linux-next only problem. Therefore,

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4603ad75c9a9..852cd3dbdcd9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1388,6 +1388,8 @@ static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool ret;
 
 	mutex_lock(&oom_lock);
+	pr_info("task=%s pid=%d invoked memcg oom killer. oom_victim=%d\n",
+			current->comm, current->pid, tsk_is_oom_victim(current));
 	ret = out_of_memory(&oc);
 	mutex_unlock(&oom_lock);
 	return ret;

F.Y.I. Waiting until __mmput() completes (with timeout using OOM score feedback)
( https://syzkaller.appspot.com/x/patch.diff?x=101e449c400000 ) solves this race.
