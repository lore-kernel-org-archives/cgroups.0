From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v10 3/4] cgroups: allow a cgroup subsystem to reject a fork
Date: Fri, 24 Apr 2015 23:59:31 +1000
Message-ID: <CAOviyajrizKYCbSZZU0BzYeH_8A62_vq1zyzJ-z7=qBV+owWSg@mail.gmail.com>
References: <1429446154-10660-1-git-send-email-cyphar@cyphar.com>
	<1429446154-10660-4-git-send-email-cyphar@cyphar.com>
	<20150422155445.GD10738@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150422155445.GD10738@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org, richard@nod.at, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hey,

>> +#define CGROUP_PREFORK_COUNT 0
>> +
>>  static inline int cgroup_init_early(void) { return 0; }
>>  static inline int cgroup_init(void) { return 0; }
>>  static inline void cgroup_fork(struct task_struct *p) {}
>> -static inline void cgroup_post_fork(struct task_struct *p) {}
>> +static inline int cgroup_can_fork(struct task_struct *p,
>> +                               void *s[CGROUP_PREFORK_COUNT])
>> +{
>> +     return 0;
>> +}
>
> Style consistency?

It's because it wraps. I can move it to be something like:

static inline int cgroup_can_fork(struct task_struct *p,
                               void *s[CGROUP_PREFORK_COUNT])
                               { return 0; }

If you like.

>> @@ -2078,6 +2084,18 @@ static void cgroup_task_migrate(struct cgroup *old_cgrp,
>>       list_move_tail(&tsk->cg_list, &new_cset->mg_tasks);
>>
>>       /*
>> +      * We detach from the old_cset subsystems here. We must do this
>> +      * before we drop the refcount for old_cset, in order to make sure
>> +      * that nobody frees it underneath us.
>> +      */
>> +     for_each_e_css(css, i, old_cgrp) {
>> +             struct cgroup_subsys_state *old_css = old_cset->subsys[i];
>> +
>> +             if (old_css->ss->detach)
>> +                     old_css->ss->detach(old_css, tsk);
>> +     }
>
> I don't get this.  What can ->detach do that ->can_attach cannot?

->detach signifies that a task is being migrated away from a cgroup.
On second thought, we could just use task_css() on each task in the
tset to figure out what the cgroup the task is being migrated away
from is and just uncharge that inside ->can_attach.

On the same point, are all the tasks in a tset passed to ->can_attach
guaranteed to have the same css? Or do I have to uncharge each one
individually?

--
Aleksa Sarai (cyphar)
www.cyphar.com
