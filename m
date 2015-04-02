From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v8 3/4] cgroups: allow a cgroup subsystem to reject a fork
Date: Fri, 3 Apr 2015 10:42:27 +1100
Message-ID: <CAOviyai9dvCTGK=VUm0uDSo7XbmKk1BFDrRzL15ppAWf8YjG3w@mail.gmail.com>
References: <1427878641-5273-1-git-send-email-cyphar@cyphar.com>
	<1427878641-5273-4-git-send-email-cyphar@cyphar.com>
	<20150401160258.GP9974@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150401160258.GP9974-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Tejun.

>> +struct cgroup_fork_state {
>> +     void *ss_state[CGROUP_SUBSYS_COUNT];
>> +};
>
> Can we collect the subsystems which require pre/post fork callbacks to
> the front in group_subsys.h and do do CGROUP_SUBSYS_FORK_COUNT (or
> whatever) instead?  Then, we don't need all these subsys bitmasks
> either we can just test the index against that and be done with it.

I tried doing this and the kernel would refuse to boot. I believe it has
something to do with the ordering of early_init subsystems, but I'm not
entirely sure (this optimisation can be dealt with later [it's non-critical],
so IMO this should be done in a separate patchset [if at all]). Also, your
later comments would fix the subsys bitmask problem (we can just pass the
default %NULL), we don't even need to test the index.

--
Aleksa Sarai (cyphar)
www.cyphar.com
