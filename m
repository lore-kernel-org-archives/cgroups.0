From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v10 4/4] cgroups: implement the PIDs subsystem
Date: Thu, 23 Apr 2015 10:43:12 +1000
Message-ID: <CAOviyagHJhxD8E+CeEdy399ARPaNyyiSJSJjByK=5ALN5jxbJw@mail.gmail.com>
References: <1429446154-10660-1-git-send-email-cyphar@cyphar.com>
	<1429446154-10660-5-git-send-email-cyphar@cyphar.com>
	<20150422162954.GF10738@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150422162954.GF10738-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Tejun,

>> +     rcu_read_lock();
>> +     css = task_css(current, pids_cgrp_id);
>> +     if (!css_tryget_online(css)) {
>> +             retval = -EBUSY;
>> +             goto err_rcu_unlock;
>> +     }
>> +     rcu_read_unlock();
>
> Hmmm... so, the above is guaranteed to succeed in finite amount of
> time (the race window is actually very narrow) and it'd be silly to
> fail fork because a task was being moved across cgroups.
>
> I think it'd be a good idea to implement task_get_css() which loops
> and returns the current css for the requested subsystem with reference
> count bumped and it can use css_tryget() too.  Holding a ref doesn't
> prevent css from dying anyway, so it doesn't make any difference.

Hmmm, okay. I'll work on this later.

>> +     rcu_read_lock();
>> +     css = task_css(task, pids_cgrp_id);
>> +     css_get(css);
>
> Why is this safe?  What guarantees that css's ref isn't already zero
> at this point?

Because it's already been exposed by pids_fork, so the current css_set
(which contains the current css)'s ref has been bumped. There isn't a
guarantee that there is a ref to css, but there is a guarantee the
css_set it is in has a ref. The problem with using tryget is that we
can't fail here.

>> +static ssize_t pids_max_write(struct kernfs_open_file *of, char *buf,
>> +                           size_t nbytes, loff_t off)
>> +{
>> +     struct cgroup_subsys_state *css = of_css(of);
>> +     struct pids_cgroup *pids = css_pids(css);
>> +     int64_t limit;
>> +     int err;
>> +
>> +     buf = strstrip(buf);
>> +     if (!strcmp(buf, PIDS_MAX_STR)) {
>> +             limit = PIDS_MAX;
>> +             goto set_limit;
>> +     }
>> +
>> +     err = kstrtoll(buf, 0, &limit);
>> +     if (err)
>> +             return err;
>> +
>> +     /* We use INT_MAX as the maximum value of pid_t. */
>> +     if (limit < 0 || limit > INT_MAX)
>
> This is kinda weird if we're using PIDS_MAX for max as it may end up
> showing "max" after some larger number is written to the file.

The reason for this is because I believe you said "PIDS_MAX isn't
meant to be exposed to userspace" (one of the previous patchsets used
PIDS_MAX as the maximum valid value).

--
Aleksa Sarai (cyphar)
www.cyphar.com
