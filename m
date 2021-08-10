From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 0/9] cgroup/cpuset: Add new cpuset partition type &
 empty effecitve cpus
Date: Mon, 9 Aug 2021 21:12:18 -0400
Message-ID: <1df2d0be-f2b7-3e57-e656-2bcdf2a3c821@redhat.com>
References: <20210720141834.10624-1-longman@redhat.com>
 <YP9ChFvrGrDMGzbe@slm.duckdns.org>
 <b2f49b2e-d5a4-1504-bd0c-0bd82943d855@redhat.com>
 <YRGwXw3KW8eFhEa8@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628557941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b7XJ3sqkjfHFuPFTck2dP2wBhFySTzytxDlqqd+iwHA=;
        b=h1OFKbIIeaeupfqAQWeURjAt5qoHseogEQGFEhh3RL8PrXaUpF13xi1G48mDcsW5MF+s9S
        weJqAxJvvoTMDTJc2MBycqwaj8kX1U70jFR+KS4uVLJjDHo8SoQBzlG22updBhcbR/SMvK
        XRS0KBIrlRYwIKkdJuRjzwXBa9DXq0k=
In-Reply-To: <YRGwXw3KW8eFhEa8-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On 8/9/21 6:46 PM, Tejun Heo wrote:
> Hello, Waiman. Sorry about the delay. Was off for a while.
>
> On Tue, Jul 27, 2021 at 05:14:27PM -0400, Waiman Long wrote:
>> However, if we have a complicated partition setup with multiple child
>> partitions. Invalid cpuset.cpus change in a parent partition will cause all
>> the child partitions to become invalid too. That is the scenario that I
>> don't want to happen inadvertently. Alternatively, we can restrict those
> I don't think there's anything fundamentally wrong with it given the
> requirement that userland has to monitor invalid state transitions.
> The same mass transition can happen through cpu hotplug operations,
> right?
>
>> invalid changes if a child partition exist and let it pass through and make
>> it invalid if it is a standalone partition.
>>
>> Please let me know which approach do you want me to take.
> I think it'd be best if we can stick to some principles rather than
> trying to adjust it for specific scenarios. e.g.:
>
> * If a given state can be reached through cpu hot [un]plug, any
>    configuration attempt which reaches the same state should be allowed
>    with the same end result as cpu hot [un]plug.
>
> * If a given state can't ever be reached in whichever way, the
>    configuration attempting to reach such state should be rejected.

OK, I got it. I will make the necessary changes and submit a new patch 
series.

Thanks,
Longman

