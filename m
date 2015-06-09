From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v13 4/5] cgroup: allow a cgroup subsystem to reject a fork
Date: Tue, 9 Jun 2015 17:20:58 +1000
Message-ID: <CAOviyai2LMkFJuOhc=ZEckuackTnfPBwCsB6aLxTBJD3-vb1=w@mail.gmail.com>
References: <1433547736-11707-1-git-send-email-cyphar@cyphar.com>
	<1433548938-32560-4-git-send-email-cyphar@cyphar.com>
	<20150609044133.GQ21465@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150609044133.GQ21465-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, richard-/L3Ra7n9ekc@public.gmane.org, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

>> @@ -4924,6 +4927,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
>>
>>       have_fork_callback |= (bool)ss->fork << ss->id;
>>       have_exit_callback |= (bool)ss->exit << ss->id;
>> +     have_canfork_callback |= (bool)ss->can_fork << ss->id;
>
> Hmmm.... do we still need this mask?  We're already restricting
> iteration pretty heavily.

CGROUP_CANFORK_{START,END,COUNT} aren't used to restrict the
iteration. They're used for restricting the size of the @ss_priv
array. If you want, I can use CANFORK_{START,END} to restrict the
iteration -- I just prefer using the for_each_subsys_which API for
iterating over active cgroups. :/

--
Aleksa Sarai (cyphar)
www.cyphar.com
