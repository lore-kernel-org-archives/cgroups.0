From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [regression] cpuset: offlined CPUs removed from affinity masks
Date: Mon, 30 Mar 2020 15:53:02 -0400 (EDT)
Message-ID: <266054305.17171.1585597982690.JavaMail.zimbra@efficios.com>
References: <1251528473.590671.1579196495905.JavaMail.zimbra@efficios.com> <1358308409.804.1582128519523.JavaMail.zimbra@efficios.com> <20200219161222.GF698990@mtj.thefacebook.com> <316507033.21078.1583597207356.JavaMail.zimbra@efficios.com> <20200312182618.GE79873@mtj.duckdns.org> <1289608777.27165.1584042470528.JavaMail.zimbra@efficios.com> <20200324180139.GB162390@mtj.duckdns.org> <195391080.10219.1585078246788.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com CB5C4251A66
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1585597982;
        bh=gw3EOeeRn8TwcNYr/XONiZlE5qIU4OEg5lWi3bCmVfs=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=Rx4PF07tkD4lV5RmbBpWW063TmT2yF/R9wlH2eHnjoVswpS/t5/Zxp2YZptg4agEm
         j7qJCws6zF9awHxUSG8/6BMZysOFMg/+wtkOtlLXWhwo0msL7c56yIQxFUZ19c2N6G
         OCgm3lSwsdexQjDF1QdFkfBSeTcmK/Lwyk2tbmtMMz9qaMLZteAtHuE8sX75v6ulIZ
         CYH364HljGpdR67yJsDxO5DHdk+XJbw5GV8GcHtoMeYewn2XlckErSUeCMCeR2Eiw/
         yGfsUSYuEIC7tprALzu1uPwz8xRGqHtL6j3tf+KQzjD/1Lsj5hWUN3eqCOXPT3D5hx
         gqCe1kySr6Uyw==
In-Reply-To: <195391080.10219.1585078246788.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Valentin Schneider <valentin.schneider-5wv7dgnIgG8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

----- On Mar 24, 2020, at 3:30 PM, Mathieu Desnoyers mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org wrote:

> ----- On Mar 24, 2020, at 2:01 PM, Tejun Heo tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:
> 
>> On Thu, Mar 12, 2020 at 03:47:50PM -0400, Mathieu Desnoyers wrote:
>>> The basic idea is to allow applications to pin to every possible cpu, but
>>> not allow them to use this to consume a lot of cpu time on CPUs they
>>> are not allowed to run.
>>> 
>>> Thoughts ?
>> 
>> One thing that we learned is that priority alone isn't enough in isolating cpu
>> consumptions no matter how low the priority may be if the workload is latency
>> sensitive. The actual computation capacity of cpus gets saturated way before cpu
>> time is saturated and latency impact from lowered mips becomes noticeable. So,
>> depending on workloads, allowing threads to run at the lowest priority on
>> disallowed cpus might not lead to behaviors that users expect but I have no idea
>> what kind of usage models you have on mind for the new system call.
> 
[...]

One possibility would be to use SCHED_IDLE scheduling class rather than SCHED_OTHER
with nice +19. The unfortunate side-effect AFAIU shows up when a thread requests to
be pinned on a CPU which is continuously overcommitted. It may never run. This could
come as a surprise for the user. The only case where this would happen is if:

- A thread is pinned on CPU N, and
  - CPU N is not part of the allowed mask for the task's cpuset (and is overcommitted), or
  - CPU N is offline, and the fallback CPU is not part of the allowed mask for the
    task's cpuset (and is overcommitted).

Is it an acceptable behavior ? How is userspace supposed to detect this kind of situation
and mitigate it ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
