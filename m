From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [regression] cpuset: offlined CPUs removed from affinity masks
Date: Wed, 19 Feb 2020 11:08:39 -0500 (EST)
Message-ID: <1358308409.804.1582128519523.JavaMail.zimbra@efficios.com>
References: <1251528473.590671.1579196495905.JavaMail.zimbra@efficios.com> <1317969050.4131.1581955387909.JavaMail.zimbra@efficios.com> <20200219151922.GB698990@mtj.thefacebook.com> <1589496945.670.1582126985824.JavaMail.zimbra@efficios.com> <20200219154740.GD698990@mtj.thefacebook.com> <59426509.702.1582127435733.JavaMail.zimbra@efficios.com> <20200219155202.GE698990@mtj.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 9CFC0249D3F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1582128519;
        bh=gm+uOkF6FbD5Qx6WLJ5PceGGH4S/trnMWToBF+XAeXA=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=odCt4KGKzyE+ngKubwyUTKzgWkT5ju+1dJp+LvC9suDjrI4reZ+FKogUt8lcXNCgQ
         YBEK4v2sUbtJoVPaqf6PjRyfiepGY3AoITCkGUn/auLvZpBfmpFHwR1JfL1wNvZvCK
         E4XvGKdp9dlZ4shVssFRIEYiuYeAWKeOcFUKIbLCnELvx4LTXxPHjMDUsQVw3boeBf
         xIU9umdFguRhs3BY0upjrKFnd4yNlbMD8Up9rBChsPyzPEMWTzCYvINCVy00eBtT8+
         XTkdMFs7FqFU67y8WHOogfSCv+BosoWRmRocXhiNAXrIpQdF9A2qoHKjoYoXdmQePt
         MAShvnTfvhR4g==
In-Reply-To: <20200219155202.GE698990-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Valentin Schneider <valentin.schneider-5wv7dgnIgG8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

----- On Feb 19, 2020, at 10:52 AM, Tejun Heo tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:

> On Wed, Feb 19, 2020 at 10:50:35AM -0500, Mathieu Desnoyers wrote:
>> I can look into figuring out the commit introducing this issue, which I
>> suspect will be close to the introduction of CONFIG_CPUSET into the
>> kernel (which was ages ago). I'll check and let you know.
> 
> Oh, yeah, I'm pretty sure it goes way back. I don't think tracking
> that down would be necessary. I was just wondering whether it was a
> recent change because you said it was a regression.

It's most likely not a recent regression, but it has unfortunate effects
on the affinity mask which directly affects my ongoing work on the
pin_on_cpu() system call [1].

The sched_setaffinity vs cpu hotplug semantic provided by CONFIG_CPUSET=n
if fine for the needs on pin_on_cpu(): when a CPU comes back online,
those reappear in the affinity mask, but it is not the case with
CONFIG_CPUSET=y.

I wonder if applying the online cpu masks to the per-thread affinity mask
is the correct approach ? I suspect what we may be looking for here is to keep
the affinity mask independent of cpu hotplug, and look-up both the per-thread
affinity mask and the online cpu mask whenever the scheduler needs to perform
"is_cpu_allowed()" to check task placement.

Then whenever sched_getaffinity or cpusets try to query the current set of
cpus on which a task can run right now, it could also look at both the task's
affinity mask and the online cpu mask.

Thanks,

Mathieu

[1] https://lore.kernel.org/r/20200121160312.26545-1-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
