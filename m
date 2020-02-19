From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [regression] cpuset: offlined CPUs removed from affinity masks
Date: Wed, 19 Feb 2020 10:43:05 -0500 (EST)
Message-ID: <1589496945.670.1582126985824.JavaMail.zimbra@efficios.com>
References: <1251528473.590671.1579196495905.JavaMail.zimbra@efficios.com> <1317969050.4131.1581955387909.JavaMail.zimbra@efficios.com> <20200219151922.GB698990@mtj.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com DB6D92492E5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1582126985;
        bh=F+/vdu5pAZWzqj4UTYnyy130uOCt0HluNqHg8+kURaY=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=Dn2LM6/Ip3rOfbochDsUS8wZ5WDY0vgo8z2AYSbk/UEtRPEdKAKNZalD9xkxRRKGG
         xIebRmZTqKeFBhD85KZF1HIZiyhw8M1zvsluupHf9evznni7VJGHnht76y6JiVzKBw
         aVeHKq0QBG3vlSIr135Dxuw2yJ9NWPZGdyQHVrhEkbzkPtmlTDJvv1oST5+iqQmeJG
         rLerfJviGIxtX950z4ZjIIpnXx+FmMvnrM681XsDw8GjLPtPdqVbKDwlJskZzxmSHX
         B2eVbOHejv+y3bffPOgPUo5mG3tpIfgTsGybTSCitYBycMIYwRWulrVAimntrIU3qP
         MiiBdphPSe9bA==
In-Reply-To: <20200219151922.GB698990-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Valentin Schneider <valentin.schneider-5wv7dgnIgG8@public.gmane.org>

----- On Feb 19, 2020, at 10:19 AM, Tejun Heo tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:

> Hello,
> 
> On Mon, Feb 17, 2020 at 11:03:07AM -0500, Mathieu Desnoyers wrote:
>> Hi,
>> 
>> Adding Tejun and the cgroups mailing list in CC for this cpuset regression I
>> reported last month.
>> 
>> Thanks,
>> 
>> Mathieu
>> 
>> ----- On Jan 16, 2020, at 12:41 PM, Mathieu Desnoyers
>> mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org wrote:
>> 
>> > Hi,
>> > 
>> > I noticed the following regression with CONFIG_CPUSET=y. Note that
>> > I am not using cpusets at all (only using the root cpuset I'm given
>> > at boot), it's just configured in. I am currently working on a 5.2.5
>> > kernel. I am simply combining use of taskset(1) (setting the affinity
>> > mask of a process) and cpu hotplug. The result is that with
>> > CONFIG_CPUSET=y, setting the affinity mask including an offline CPU number
>> > don't keep that CPU in the affinity mask, and it is never put back when the
>> > CPU comes back online. CONFIG_CPUSET=n behaves as expected, and puts back
>> > the CPU into the affinity mask reported to user-space when it comes back
>> > online.
> 
> Because cpuset operations irreversibly change task affinity masks
> rather than masking them dynamically, the interaction has always been
> kinda broken. Hmm... Are there older kernel vesions which behave
> differently? Off the top of my head, I can't think of sth which could
> have changed that behavior recently but I could easily be missing
> something.

Hi Tejun,

The regression I'm talking about here is that CONFIG_CPUSET=y changes the
behavior of the sched_setaffinify system call, which existed prior to
cpusets.

sched_setaffinity should behave in the same way for kernels configured with
CONFIG_CPUSET=y or CONFIG_CPUSET=n.

The fact that cpuset decides to irreversibly change the task affinity mask
may not be considered a regression if it has always done that, but changing
the behavior of sched_setaffinity seems to fit the definition of a regression.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
