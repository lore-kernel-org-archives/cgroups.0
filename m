From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v10 4/4] cgroups: implement the PIDs subsystem
Date: Sat, 25 Apr 2015 00:24:08 +1000
Message-ID: <CAOviyahq6kr8Q-sXHHmwrZmFrPfj-kJ8QjUYNceRZAG1ZfLv_A@mail.gmail.com>
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

Also,

>> +struct pids_cgroup {
>> +     struct cgroup_subsys_state      css;
>> +
>> +     /*
>> +      * Use 64-bit types so that we can safely represent "max" as
>> +      * (PID_MAX_LIMIT + 1).
>             ^^^^^^^^^^^^^^^^^
> ...
>> +static struct cgroup_subsys_state *
>> +pids_css_alloc(struct cgroup_subsys_state *parent)
>> +{
>> +     struct pids_cgroup *pids;
>> +
>> +     pids = kzalloc(sizeof(struct pids_cgroup), GFP_KERNEL);
>> +     if (!pids)
>> +             return ERR_PTR(-ENOMEM);
>> +
>> +     pids->limit = PIDS_MAX;
>                       ^^^^^^^^^

%PIDS_MAX = (%PID_MAX_LIMIT + 1). I can clarify this in the comments
if you want.

--
Aleksa Sarai (cyphar)
www.cyphar.com
