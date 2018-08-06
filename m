From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: WARNING in try_charge
Date: Mon, 6 Aug 2018 12:34:30 +0200
Message-ID: <CACT4Y+ZJsDo1gjzHvbFVqHcrL=tFJXTAAWLs9mAJSv3+LiCdmA@mail.gmail.com>
References: <0000000000005e979605729c1564@google.com> <20180806091552.GE19540@dhcp22.suse.cz>
 <CACT4Y+Ystnwv4M6Uh+HBKbdADAnJ6otfR0GoA20crzqV+b2onQ@mail.gmail.com> <20180806094827.GH19540@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=EOvO6ky/dS/nmCHrL9ZkqthUZTkIuPHfdA3nBASzyOU=;
        b=s31OAPyz69cMIGyF2Uo4w4fHhn65+lQFQXqZ71S5PEYn1fCDqLX7nQgdUlNuhk6S/S
         L3B3O4q1LVY4Fbfx+8cV1gPRVAoMp9hHydP+eRC1bFqSyaepkvJz3j8eoXmZOKz0u97g
         LlRa78CxpvDX0An1Zgd8Vg6nvq9kaSO1bCNnIhqw8wxR/fB5/FhTk7Ap7NX5/Ln1SEDs
         AOJdLIKYlqYlEpSJVk1RmhyhJ+pZ2bjsh7bevDuorZeNZWoT04u/Lax2PfAEHZp+OQkJ
         ILVl3GEi87Aaq5Yp1CeYgX9MejgdF6UATPMVhYfjQjo0ZBMQ9URKCMsg4iSSZ50pNxeh
         ucAQ==
In-Reply-To: <20180806094827.GH19540@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: syzbot <syzbot+bab151e82a4e973fa325@syzkaller.appspotmail.com>, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Dmitry Torokhov <dtor@google.com>

On Mon, Aug 6, 2018 at 11:48 AM, Michal Hocko <mhocko@kernel.org> wrote:
> On Mon 06-08-18 11:30:37, Dmitry Vyukov wrote:
>> On Mon, Aug 6, 2018 at 11:15 AM, Michal Hocko <mhocko@kernel.org> wrote:
> [...]
>> > More interesting stuff is higher in the kernel log
>> > : [  366.435015] oom-kill:constraint=CONSTRAINT_MEMCG,nodemask=(null),cpuset=/,mems_allowed=0,oom_memcg=/ile0,task_memcg=/ile0,task=syz-executor3,pid=23766,uid=0
>> > : [  366.449416] memory: usage 112kB, limit 0kB, failcnt 1605
>> >
>> > Are you sure you want to have hard limit set to 0?
>>
>> syzkaller really does not mind to have it.
>
> So what do you use it for? What do you actually test by this setting?

syzkaller is kernel fuzzer, it finds kernel bugs by doing whatever is
doable from user-space. Some of that may not make sense, but it does
not matter because kernel should still stand still.

> [...]
>> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> > index 4603ad75c9a9..852cd3dbdcd9 100644
>> > --- a/mm/memcontrol.c
>> > +++ b/mm/memcontrol.c
>> > @@ -1388,6 +1388,8 @@ static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>> >         bool ret;
>> >
>> >         mutex_lock(&oom_lock);
>> > +       pr_info("task=%s pid=%d invoked memcg oom killer. oom_victim=%d\n",
>> > +                       current->comm, current->pid, tsk_is_oom_victim(current));
>> >         ret = out_of_memory(&oc);
>> >         mutex_unlock(&oom_lock);
>> >         return ret;
>> >
>> > Anyway your memcg setup is indeed misconfigured. Memcg with 0 hard limit
>> > and basically no memory charged by existing tasks is not going to fly
>> > and the warning is exactly to call that out.
>>
>>
>> Please-please-please do not mix kernel bugs and notices to user into
>> the same bucket:
>
> Well, WARN_ON used to be a standard way to make user aware of a
> misbehavior. In this case it warns about a pottential runaway when memcg
> is misconfigured. I do not insist on using WARN_ON here of course. If
> there is a general agreement that such a condition is better handled by
> pr_err then I am fine with it. Users tend to be more sensitive on
> WARN_ONs though.

The docs change was acked by Greg, and Andrew took it into mm, Linus
was CCed too. It missed the release because I guess it's comments only
change, but otherwise it should reach upstream tree on the next merge
window.

WARN is _not_ a common way to notify users today. syzbot reports _all_
WARN occurrences and you can see there are not many of them now
(probably 1 another now, +dtor for that one):
https://syzkaller.appspot.com#upstream
There is probably some long tail that we need to fix. We really do
want systematic testing capability. You do not want every of 2 billion
linux users to come to you with this kernel splat, just so that you
can explain to them that it's some programs of their machines doing
something wrong, right?

WARN is really a bad way to inform a user about something. Consider a
non-kernel developer, perhaps even non-programmer. What they see is
"WARNING: CPU: 1 PID: 23767 at mm/memcontrol.c:1710
try_charge+0x734/0x1680" followed by some obscure things and hex
numbers. File:line reference is pointless, they don't what what/where
it is. This one is slightly better because it prints "Memory cgroup
charge failed because of no reclaimable memory! This looks like a
misconfiguration or a kernel bug." before the warning. But still it
says "or a kernel bug", which means that they will come to you. A much
friendlier for user way to say this would be print a message at the
point of misconfiguration saying what exactly is wrong, e.g. "pid $PID
misconfigures cgroup /cgroup/path with mem.limit=0" without a stack
trace (does not give any useful info for user). And return EINVAL if
it can't fly at all? And then leave the "or a kernel bug" part for the
WARNING each occurrence of which we do want to be reported to kernel
developers.
