From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 5/6] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Fri, 27 Aug 2021 18:50:10 -0400
Message-ID: <392c3724-f583-c7fc-cfa1-a3f1665114c9@redhat.com>
References: <20210825213750.6933-1-longman@redhat.com>
 <20210825213750.6933-6-longman@redhat.com> <YSfQ0mYWs2zUyqGY@mtj.duckdns.org>
 <32e27fcc-32f1-b26c-ae91-9e03f7e433af@redhat.com>
 <YShjb2WwvuB4s4gX@slm.duckdns.org>
 <d22ea3be-2429-5923-a80c-5af3b384def9@redhat.com>
 <YSlY0H/qeXQIGOfk@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630104615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=En27XuojdaIOCdDdv7ALogd6FL3p5QlR3VuvOI+21oc=;
        b=If7lvt6Ynyw5pAp39g3GP38rKpsPBNvu2lOXvd/cug2ghJwZoQE2QqeD8HxDKWcinLl608
        XjWO8JCIsXsWX5xcuNJakQngA17LiGX0JzzG0eWv2VdDMCoFU/tl9OFWWgHEls+dTCLGOb
        BeTfrVec7YJjlCBsL370fz6TCpwY1Pg=
In-Reply-To: <YSlY0H/qeXQIGOfk-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On 8/27/21 5:27 PM, Tejun Heo wrote:
> Hello,
>
> On Fri, Aug 27, 2021 at 05:19:31PM -0400, Waiman Long wrote:
>> Well, that is a valid point. The cpus may have been offlined when a
>> partition is being created. I can certainly relent on this check in forming
>> a partition. IOW, cpus_allowed can contain some or all offline cpus and a
>> valid (some are online) or invalid (all are offline) partition can be
>> formed. I can also allow an invalid child partition to be formed with an
>> invalid parent partition. However, the cpu exclusivity rules will still
>> apply.
>>
>> Other than that, do you envision any other circumstances where we should
>> allow an invalid partition to be formed?
> Now that most restrictions are removed from configuration side, just go all
> the way? Given that the user must check the status afterwards anyway, I
> don't see technical or even usability reasons for leaving some pieces
> behind. Going all the way would be easier to use too - bang in the target
> config and read the resulting state to reliably find out why a partition
> isn't valid, especially if we list *all* the reasons so that the user
> tell whether the configuration is as intended immediately.

The cpu exclusivity rule is due to the setting of CPU_EXCLUSIVE bit. 
This is a pre-existing condition unless you want to change how the 
cpuset.cpu_exclusive works.

So the new rules will be:

1) The "cpuset.cpus" is not empty and the list of CPUs are exclusive.
2) The parent cgroup is a partition root (can be an invalid one).
3) The "cpuset.cpus" is a subset of the parent's cpuset.cpus.allowed.
4) No child cgroup with cpuset enabled.

I think they are reasonable. What do you think?

Cheers,
Longman

