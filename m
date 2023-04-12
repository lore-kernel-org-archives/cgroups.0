From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 0/5] cgroup/cpuset: Fix CLONE_INTO_CGROUP problem &
 other issues
Date: Wed, 12 Apr 2023 14:29:46 -0400
Message-ID: <168bb07f-844f-13f5-e4bd-77c2cec94046@redhat.com>
References: <20230411133601.2969636-1-longman@redhat.com>
 <ZDb32V9xcWOi2_CL@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681324195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MWy6sv13whg9JBQjJjQUf4sYt60lbACx2Lp0OS4PkY8=;
        b=D5l7WUWTCLSZCk29NeBNCBzDz0QoAY5/Ytj4T/OOvyGUeD41Oq0qv6EzZiPkxBbozE0jEm
        XVpfMyA2JJ6/O054VXCCrRLLJjRV3NqyKDLpR/PUYGHods4+wQJbKm16R+y8AOGxtH1qqJ
        Eu9TcZF/SnznlJRaf4dGG71QncidKkA=
Content-Language: en-US
In-Reply-To: <ZDb32V9xcWOi2_CL-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Giuseppe Scrivano <gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


On 4/12/23 14:26, Tejun Heo wrote:
> On Tue, Apr 11, 2023 at 09:35:56AM -0400, Waiman Long wrote:
>>   v4:
>>    - Add missing rcu_read_lock/unlock to cpuset_cancel_fork() in patch 3.
>>    - Add patch 5 to reduce performance impact for the
>>      non-CLONE_INTO_CGROUP case.
>>
>>   v3:
>>    - Update patches 2 & 3 to put task_cs() call under rcu_read_lock().
>>
>>   v2:
>>    - Drop v1 patch 3
>>    - Add a new patch to fix an issue in cpuset_cancel_attach() and
>>      another patch to add cpuset_can_fork() and cpuset_cacnel_fork()
>>      methods.
>>
>> The first patch in this series fixes a problem in
>> cpuset_cancel_attach(). Patches 2 and 3 fixes the CLONE_INTO_CGROUP
>> problem in cpuset. Patch 4 is a minor fix. The last patch is a
>> performance optimization patch for the non-CLONE_INTO_CGROUP case.
> Applied 1-4 to cgroup/for-6.3-fixes w/ stable cc'd. Given that the fixes are
> a bit involved, the breakages have been there for quite a while and the
> cpuset code has changed quite a bit, backporting might not be trivial tho.
> Let's see how that goes.

I know stable backport won't be straight forward. I am planning to help 
in the backporting effort. Thanks for taking these into your cgroup tree.

Cheers,
Longman

