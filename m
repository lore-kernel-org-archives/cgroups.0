From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v10 4/4] cgroups: implement the PIDs subsystem
Date: Sat, 25 Apr 2015 00:07:34 +1000
Message-ID: <CAOviyagQTu_ARVURBmtHtXGMugMsgSyZ2Es3ix8mQASCNkuPyA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

>>> +     rcu_read_lock();
>>> +     css = task_css(current, pids_cgrp_id);
>>> +     if (!css_tryget_online(css)) {
>>> +             retval = -EBUSY;
>>> +             goto err_rcu_unlock;
>>> +     }
>>> +     rcu_read_unlock();
>>
>> Hmmm... so, the above is guaranteed to succeed in finite amount of
>> time (the race window is actually very narrow) and it'd be silly to
>> fail fork because a task was being moved across cgroups.
>>
>> I think it'd be a good idea to implement task_get_css() which loops
>> and returns the current css for the requested subsystem with reference
>> count bumped and it can use css_tryget() too.  Holding a ref doesn't
>> prevent css from dying anyway, so it doesn't make any difference.
>
> Hmmm, okay. I'll work on this later.

Would something like this suffice?

struct cgroup_subsys_state *task_get_css(struct task_struct *task, int
subsys_id) {
        bool have_ref = false;
        struct cgroup_subsys_state *css;

        while(!have_ref) {
                rcu_read_lock();
                css = task_css(task, subsys_id);
                have_ref = !css_tryget(css);
                rcu_read_unlock();
        }

        return css;
}

Also, as a side note (in the same vein I guess), does a ref on a
css_set give you an implicit ref on a css inside that css_set, or are
those two orthogonal operations?

--
Aleksa Sarai (cyphar)
www.cyphar.com
