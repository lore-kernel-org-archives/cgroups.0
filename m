From: Michal Hocko <mhocko@kernel.org>
Subject: Re: WARNING in try_charge
Date: Mon, 6 Aug 2018 11:48:27 +0200
Message-ID: <20180806094827.GH19540@dhcp22.suse.cz>
References: <0000000000005e979605729c1564@google.com>
 <20180806091552.GE19540@dhcp22.suse.cz>
 <CACT4Y+Ystnwv4M6Uh+HBKbdADAnJ6otfR0GoA20crzqV+b2onQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+Ystnwv4M6Uh+HBKbdADAnJ6otfR0GoA20crzqV+b2onQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+bab151e82a4e973fa325@syzkaller.appspotmail.com>, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vladimir Davydov <vdavydov.dev@gmail.com>

On Mon 06-08-18 11:30:37, Dmitry Vyukov wrote:
> On Mon, Aug 6, 2018 at 11:15 AM, Michal Hocko <mhocko@kernel.org> wrote:
[...]
> > More interesting stuff is higher in the kernel log
> > : [  366.435015] oom-kill:constraint=CONSTRAINT_MEMCG,nodemask=(null),cpuset=/,mems_allowed=0,oom_memcg=/ile0,task_memcg=/ile0,task=syz-executor3,pid=23766,uid=0
> > : [  366.449416] memory: usage 112kB, limit 0kB, failcnt 1605
> >
> > Are you sure you want to have hard limit set to 0?
> 
> syzkaller really does not mind to have it.

So what do you use it for? What do you actually test by this setting?

[...]
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 4603ad75c9a9..852cd3dbdcd9 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -1388,6 +1388,8 @@ static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >         bool ret;
> >
> >         mutex_lock(&oom_lock);
> > +       pr_info("task=%s pid=%d invoked memcg oom killer. oom_victim=%d\n",
> > +                       current->comm, current->pid, tsk_is_oom_victim(current));
> >         ret = out_of_memory(&oc);
> >         mutex_unlock(&oom_lock);
> >         return ret;
> >
> > Anyway your memcg setup is indeed misconfigured. Memcg with 0 hard limit
> > and basically no memory charged by existing tasks is not going to fly
> > and the warning is exactly to call that out.
> 
> 
> Please-please-please do not mix kernel bugs and notices to user into
> the same bucket:

Well, WARN_ON used to be a standard way to make user aware of a
misbehavior. In this case it warns about a pottential runaway when memcg
is misconfigured. I do not insist on using WARN_ON here of course. If
there is a general agreement that such a condition is better handled by
pr_err then I am fine with it. Users tend to be more sensitive on
WARN_ONs though.

Btw. running with the above diff on top might help us to ideantify
whether this is a pre-mature warning or a valid one. Still useful to
find out.
-- 
Michal Hocko
SUSE Labs
