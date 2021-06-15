From: Waiman Long <llong@redhat.com>
Subject: Re: [PATCH 0/4] cgroup/cpuset: Allow cpuset to bound displayed cpu
 info
Date: Mon, 14 Jun 2021 22:53:53 -0400
Message-ID: <0e21f16d-d91b-7cec-d832-4c401a713b10@redhat.com>
References: <20210614152306.25668-1-longman@redhat.com>
 <YMe/cGV4JPbzFRk0@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623725638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QdYxDbQWiJKAKMyRdXqAnaZNwtk+EcbNLD508mdqaII=;
        b=SnRF/3WapR3gHUhk/TYsu52nKeEZgnGutfGZsSrfuGKIgJgA2HJ17okApRwUsIPxBHzu9i
        WrFYbkIQIfWhQJjV1vlbdEzSbi9GrH0JOdz8j3uwDptla0OwQnvKN1JvXffW3B7xS7zh3z
        z+3zGtN5X0UgTuvwmsCMeOrVM5uiAL0=
In-Reply-To: <YMe/cGV4JPbzFRk0@slm.duckdns.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Iurii Zaikin <yzaikin@google.com>, x86@kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org

On 6/14/21 4:43 PM, Tejun Heo wrote:
> Hello,
>
> On Mon, Jun 14, 2021 at 11:23:02AM -0400, Waiman Long wrote:
>> The current container management system is able to create the illusion
>> that applications running within a container have limited resources and
>> devices available for their use. However, one thing that is hard to hide
>> is the number of CPUs available in the system. In fact, the container
>> developers are asking for the kernel to provide such capability.
>>
>> There are two places where cpu information are available for the
>> applications to see - /proc/cpuinfo and /sys/devices/system/cpu sysfs
>> directory.
>>
>> This patchset introduces a new sysctl parameter cpuset_bound_cpuinfo
>> which, when set, will limit the amount of information disclosed by
>> /proc/cpuinfo and /sys/devices/system/cpu.
> The goal of cgroup has never been masquerading system information so that
> applications can pretend that they own the whole system and the proposed
> solution requires application changes anyway. The information being provided
> is useful but please do so within the usual cgroup interface - e.g.
> cpuset.stat. The applications (or libraries) that want to determine its
> confined CPU availability can locate the file through /proc/self/cgroup.

Thanks for your comment. I understand your point making change via 
cgroup interface files. However, this is not what the customers are 
asking for. They are using tools that look at /proc/cpuinfo and the 
sysfs files. It is a much bigger effort to make all those tools look at 
a new cgroup file interface instead. It can be more efficiently done at 
the kernel level.

Anyway, I am OK if the consensus is that it is not a kernel problem and 
have to be handled in userspace.

BTW, do you have any comment on another cpuset patch that I sent a week 
earlier?

https://lore.kernel.org/lkml/20210603212416.25934-1-longman@redhat.com/

I am looking forward for your feedback.

Cheers,
Longman

