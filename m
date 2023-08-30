From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH-cgroup v7 0/6] cgroup/cpuset: Support remote partitions
Date: Wed, 30 Aug 2023 16:01:14 -0400
Message-ID: <d0380dfa-ee2e-e492-38e3-31bf6644e511@redhat.com>
References: <20230817132454.755459-1-longman@redhat.com>
 <ZO-X4KnEtOjhJffR@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693433910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mWMbXQ/6lKzvuk9wmWLP6Zov9vMWJLOe43uW9KJ/WLU=;
        b=Sc9jTOAz+O98u/aZdDHLY8KOqOcwB2lc8aVI5b5oITvCIHqBKkX4lnMKYdnal6Wl/ep5bh
        Zg3mF2v9tvXx/dO7RxFj79dM002hAp+6eemqf2/4BMY+GIaocH5Vz+zWUobVp8e8uPR7RC
        FLO6iCBX4nwwr52/LfSogtNE1MEguYc=
Content-Language: en-US
In-Reply-To: <ZO-X4KnEtOjhJffR-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Giuseppe Scrivano <gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


On 8/30/23 15:26, Tejun Heo wrote:
> Hello, Waiman.
>
> On Thu, Aug 17, 2023 at 09:24:48AM -0400, Waiman Long wrote:
>>   v7:
>>    - Fix a compilation problem in patch 1 & a memory allocation bug in
>>      patch 2.
>>    - Change exclusive_cpus type to cpumask_var_t to match other cpumasks
>>      and make code more consistent.
> This overall looks fine to me but I'm afraid we're a bit too late for this
> devel cycle. I'll merge these into cgroup/for-6.7 when it opens.

Yes, I am aware it is too late for v6.6. My current target is v6.7. BTW, 
I do have some minor twists to address some corner case issue. I will 
post a new version before the merge window close.

Thanks,
Longman

