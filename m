From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 2/3] cgroups: allow a cgroup subsystem to reject a fork
Date: Sat, 21 Mar 2015 22:25:56 +1100
Message-ID: <CAOviyagGvm4z8eAWitR267U3br-60vVJ9A5MMtFENy9xt9zuLQ@mail.gmail.com>
References: <1426307835-5893-1-git-send-email-cyphar@cyphar.com>
	<1426307835-5893-3-git-send-email-cyphar@cyphar.com>
	<20150316165335.GC8353@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150316165335.GC8353-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Tejun,

>> +int cgroup_can_fork(struct task_struct *child, void **state)
>> +{
>> +     struct cgroup_subsys *ss;
>> +     struct css_set *cset;
>> +     int i, j, retval;
>> +
>> +     cset = task_css_set(current);
>> +     get_css_set(cset);
>
> So, you stuck with css_set refcnting.  That's fine, but please do
> finish discussing in the original thread instead of throwing out new
> version without explaining why you reached a particular conclusion.
> Did you explore the idea of passing an opaque pointer from can_fork to
> post_fork?  If so, why did you choose this direction instead of that
> one?

The reason for using css_set is for future-proofness. If we stick with just
passing around the css, then we'd be stuck with only working with one
particular cgroup subsystem (and it would also make the code unwieldy). I'll
post this to that thread too, but the main reason is that it would make the
generic callback pids-specific.

> Also, what pins the cset between task_css_set() and get_css_set()?
> task_css_set() is protected by RCU and the above should have triggered
> RCU warning if the debug option is enabled.  Please always test with
> the debug options enabled, especially the lockdep and RCU ones.

Debug was enabled AFAIK and I didn't get anything in `dmesg`. I've fixed it
anyway.

>> +     *state = cset;
>
> There's no reason for css_set pointer to be passed around as an opaque
> pointer.  The type is fixed.  I suppose this is from me mentioning
> void pointer in the previous thread but that was about the cpuset
> can_fork() implementation returning its css pointer, not css_set.
> Please conclude discussions before working on the following version.

Yes, I misunderstood what you wanted the opaque pointer to point to. But I had
thought of doing it like that before, and decided against it for the reasons
outlined above.

>> @@ -5249,6 +5315,24 @@ void cgroup_post_fork(struct task_struct *child)
>>       }
>>
>>       /*
>> +      * Deal with tasks that were migrated mid-fork. If the css_set
>> +      * changed between can_fork() and post_fork() an organisation
>> +      * operation has occurred, and we need to revert/reapply the
>> +      * the can_fork().
>> +      */
>> +     for_each_subsys_which(need_canfork_callback, ss, i) {
>> +             struct cgroup_subsys_state *css = cset->subsys[i],
>> +                                        *old_css = old_cset->subsys[i];
>> +
>> +             /*
>> +              * We only reapply for subsystems whose
>> +              * association changed in the interim.
>> +              */
>> +             if (old_css != css && ss->reapply_fork)
>> +                     ss->reapply_fork(css, old_css, child);
>> +     }
>
> Do we really need a separate callback for this?  Can't we just add
> @old_css param to ss->fork() which is NULL if it didn't change since
> can_fork()?

I feel that reapply_fork() being a special case of fork() (or vice versa) just
feels like a weird API. The two actions are fundamentally different -- one is
basically confirming that the fork went through and the other is alerting the
subsystem that the association changed during a fork.

--
Aleksa Sarai (cyphar)
www.cyphar.com
