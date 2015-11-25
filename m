From: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Subject: Re: WARNING in handle_mm_fault
Date: Thu, 26 Nov 2015 00:27:17 +0900
Message-ID: <201511260027.CCC26590.SOHFMQLVJOtFOF@I-love.SAKURA.ne.jp>
References: <CACT4Y+ZCkv0BPOdo3aiheA5LXzXhcnuiw7kCoWL=b9FcC8-wqg@mail.gmail.com>
	<20151125084403.GA24703@dhcp22.suse.cz>
	<565592A1.50407@I-love.SAKURA.ne.jp>
	<CACT4Y+Zn+mK37-mvqDQTyt1Psp6HT2heT0e937SO24F7V1q7PA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACT4Y+Zn+mK37-mvqDQTyt1Psp6HT2heT0e937SO24F7V1q7PA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, kcc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org

Dmitry Vyukov wrote:
> If the race described in
> http://www.spinics.net/lists/cgroups/msg14078.html does actually
> happen, then there is nothing to check.
> https://gcc.gnu.org/ml/gcc/2012-02/msg00005.html talks about different
> memory locations, if there is store-widening involving different
> memory locations, then this is a compiler bug. But the race happens on
> a single memory location, in such case the code is buggy.
> 

All ->in_execve ->in_iowait ->sched_reset_on_fork ->sched_contributes_to_load
->sched_migrated ->memcg_may_oom ->memcg_kmem_skip_account ->brk_randomized
shares the same byte.

sched_fork(p) modifies p->sched_reset_on_fork but p is not yet visible.
__sched_setscheduler(p) modifies p->sched_reset_on_fork.
try_to_wake_up(p) modifies p->sched_contributes_to_load.
perf_event_task_migrate(p) modifies p->sched_migrated.

Trying to reproduce this problem with

 static __always_inline bool
 perf_sw_migrate_enabled(void)
 {
-	if (static_key_false(&perf_swevent_enabled[PERF_COUNT_SW_CPU_MIGRATIONS]))
-		return true;
 	return false;
 }

would help testing ->sched_migrated case.
