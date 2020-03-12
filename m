From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [regression] cpuset: offlined CPUs removed from affinity masks
Date: Thu, 12 Mar 2020 15:47:50 -0400 (EDT)
Message-ID: <1289608777.27165.1584042470528.JavaMail.zimbra@efficios.com>
References: <1251528473.590671.1579196495905.JavaMail.zimbra@efficios.com> <20200219154740.GD698990@mtj.thefacebook.com> <59426509.702.1582127435733.JavaMail.zimbra@efficios.com> <20200219155202.GE698990@mtj.thefacebook.com> <1358308409.804.1582128519523.JavaMail.zimbra@efficios.com> <20200219161222.GF698990@mtj.thefacebook.com> <316507033.21078.1583597207356.JavaMail.zimbra@efficios.com> <20200312182618.GE79873@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com ABCFB283B3C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1584042470;
        bh=A1HR5wx2ul5UN/781Z2t5qlpWkPcTJFFf8FZtwQy6S0=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=I7XIwjfakzD+Ifo0HlzHk72yMKTKFW2SQR4uZPsMLjCFAmT7H1X/5XqyV/9FAMR2X
         DM+oMyxtBE/rnPjt2hW3PHY0fE2DtI2XgYspcckeHbnchZwyywjLDAL1q4e3ksB/6O
         snuzo2y365fmrlkxdgMu6d0AgnN1i4koJP5A5ytLg83TOm2AbvaOpV7QZf9FX+tCQT
         VKCU7vvkuDNQe7FCkW89i/BkBJckT6wuK2DWcKceDq6A4DYE17lKOklXKgQHzv/Zot
         ln1eVE+etQHwwZrsd+kaVMlfnJ3OYrGZvNIxNx68XFgZ887Oo7/wao7M1PUiCsFU96
         bhr2lRGbzncQA==
In-Reply-To: <20200312182618.GE79873-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Valentin Schneider <valentin.schneider-5wv7dgnIgG8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

----- On Mar 12, 2020, at 2:26 PM, Tejun Heo tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:

> Hello,
> 
> On Sat, Mar 07, 2020 at 11:06:47AM -0500, Mathieu Desnoyers wrote:
>> Looking into solving this, one key issue seems to get in the way: cpuset
>> appear to care about not allowing to create a cpuset which has no currently
>> active CPU where to run, e.g.:
> ...
>> Clearly, there is an intent that cpusets take the active mask into
>> account to prohibit creating an empty cpuset, but nothing prevents
>> cpu hotplug from creating an empty cpuset.
>> 
>> I wonder how to solve this inconsistency ?
> 
> Please try cpuset in cgroup2. It shouldn't have those issues.

After figuring how to use cgroup2 (systemd.unified_cgroup_hierarchy=1 boot
parameter helped tremendously), and testing similar scenarios, it indeed
seems to have a much saner behavior than cgroup1.

Considering that the allowed cpu mask is weird wrt cgroup1 and cpu hotplug,
and that cgroup2 allows thread-level granularity, it does not make much sense
to prevent the pin_on_cpu() system call I am working on from pinning
on cpus which are not present in the allowed mask.

I'm currently investigating approaches that would detect situations
where a thread is pinned onto a CPU which is not part of its allowed
mask, and set the task prio at MAX_PRIO-1 (the lowest fair priority
possible) in those cases.

The basic idea is to allow applications to pin to every possible cpu, but
not allow them to use this to consume a lot of cpu time on CPUs they
are not allowed to run.

Thoughts ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
