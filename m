From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v12 7/8] cgroup: add a tset_get_css macro
Date: Tue, 19 May 2015 11:18:41 +1000
Message-ID: <CAOviyahr_2xwVUjhYMCSgW5om4N9N_i1VZKsoqw8S5PM-muLbg@mail.gmail.com>
References: <1431960667-26593-1-git-send-email-cyphar@cyphar.com>
	<1431960667-26593-8-git-send-email-cyphar@cyphar.com>
	<20150518213423.GI24861@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150518213423.GI24861-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, richard-/L3Ra7n9ekc@public.gmane.org, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Tejun,

>> +/**
>> + * tset_get_css - obtain and get css for (tset, subsys_id)
>> + * @tset: target taskset
>> + * @subsys_id: target subsystem id
>> + *
>> + * Since all of the tasks in a taskset are guaranteed to have the same css, it's
>> + * safe to grab the ref of just the first task's css and treat it as though you
>> + * have a ref on the taskset's "collective" css.
>> + */
>> +#define tset_get_css(tset, subsys_id)                                        \
>> +     task_get_css(cgroup_taskset_first(tset), subsys_id)
>
> They aren't tho.  It depends on the hierarchy configuration.  csses
> belonging to hierarchies which aren't the current migration target may
> differ.

Okay, I was confused by what you said earlier. In this case, we might
as well just move all of the attach accounting to ->attach() and not
deal with reverting it (unless we're guaranteed that the css of each
task in the tset doesn't change between ->can_attach() and
->cancel_attach()).

--
Aleksa Sarai (cyphar)
www.cyphar.com
