From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [regression] cpuset: offlined CPUs removed from affinity masks
Date: Wed, 19 Feb 2020 10:50:35 -0500 (EST)
Message-ID: <59426509.702.1582127435733.JavaMail.zimbra@efficios.com>
References: <1251528473.590671.1579196495905.JavaMail.zimbra@efficios.com> <1317969050.4131.1581955387909.JavaMail.zimbra@efficios.com> <20200219151922.GB698990@mtj.thefacebook.com> <1589496945.670.1582126985824.JavaMail.zimbra@efficios.com> <20200219154740.GD698990@mtj.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com CCD34249842
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1582127435;
        bh=n5cHT89YZyqvy7ZJIr0GDRx3VH9Jg3ndn0oVBAB6nME=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=CmPM8/EWqcMTIbi1mbdrVOPedy+TO3w3D66BhLXu7EBQJz/InhT+S9wuJ76gOKznf
         FrMGRQcZR2XJo1sLQSUwR29n8cRxJTP3QF2usBRcVgyIjelW2vJ+yf4wGGzjABmTm9
         XDvuBRIBK9djAXHiX1yvM77F51JVkPHgwatvw5bS87zdCrgOqmcvi4/EyYNhcccpVZ
         6SHL5al2i0pWjfUHghhCLaUihNKQZlQBQhYxxxnAKGyDHYQTOYadJ2GWKjIZaUyzL0
         FCz5giEUKWpDSbfKoEFKL5vBVPZ2g6fdHB0jYLARjs33Z+ZwVW1bbddPAuujNxmK7L
         ydeAy0PBy2qVQ==
In-Reply-To: <20200219154740.GD698990-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Valentin Schneider <valentin.schneider-5wv7dgnIgG8@public.gmane.org>

----- On Feb 19, 2020, at 10:47 AM, Tejun Heo tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:

> On Wed, Feb 19, 2020 at 10:43:05AM -0500, Mathieu Desnoyers wrote:
>> The regression I'm talking about here is that CONFIG_CPUSET=y changes the
>> behavior of the sched_setaffinify system call, which existed prior to
>> cpusets.
>> 
>> sched_setaffinity should behave in the same way for kernels configured with
>> CONFIG_CPUSET=y or CONFIG_CPUSET=n.
>> 
>> The fact that cpuset decides to irreversibly change the task affinity mask
>> may not be considered a regression if it has always done that, but changing
>> the behavior of sched_setaffinity seems to fit the definition of a regression.
> 
> We generally use "regression" for breakages which weren't in past
> versions but then appeared later. It has debugging implications
> because if we know something is a regression, we generally can point
> to the commit which introduced the bug either through examining the
> history or bisection.
> 
> It is a silly bug, for sure, but slapping regression name on it just
> confuses rather than helping anything.

I can look into figuring out the commit introducing this issue, which I
suspect will be close to the introduction of CONFIG_CPUSET into the
kernel (which was ages ago). I'll check and let you know.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
