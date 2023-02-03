From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] cpuset: Fix cpuset_cpus_allowed() to not filter
 offline CPUs
Date: Fri, 3 Feb 2023 10:35:13 -0500
Message-ID: <26617070-e32b-cfc2-d741-0294d5aea0c3@redhat.com>
References: <20230131221719.3176-1-will@kernel.org>
 <20230131221719.3176-2-will@kernel.org>
 <6b068916-5e1b-a943-1aad-554964d8b746@redhat.com>
 <Y9otWX+MGOLDKU6t@hirez.programming.kicks-ass.net>
 <83e53632-27ed-8dde-84f4-68c6776d6da8@redhat.com>
 <a892d340-ea99-1562-0e70-176f02f195c2@redhat.com>
 <Y9rVVldS19oyIZ+g@hirez.programming.kicks-ass.net>
 <773e2f22-211e-163f-64bb-15ae29ad161b@redhat.com>
 <20230203115045.GB5927@willie-the-truck>
 <d626998b-4cb0-dd8f-fd97-21715bf2eb0b@redhat.com>
 <Y90nn9NVkEhcZ6nq@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675438526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uug3Jhs3c7xaX/Rx/hsjur5gbFszvyaZzpEQCntiDz4=;
        b=CPdK4CBF44zKDePe/148nBkJBugcYXoP0fRjksht9ED9dQddYYejzyQjcccinVdU4wAO+s
        5StJlciAUZwg2fSYprXxf6Pz6nvb6ankkCcfwmemeI0V9GuxbOPNRmSw+tx7Gt2PNJSqSh
        ibUjCnp+8f9BlAlODPONjm/X1i/Q6tI=
Content-Language: en-US
In-Reply-To: <Y90nn9NVkEhcZ6nq-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On 2/3/23 10:26, Peter Zijlstra wrote:
> On Fri, Feb 03, 2023 at 10:13:10AM -0500, Waiman Long wrote:
>
>> I think I know where the problem is. It is due to the fact the cpuset
>> hotplug code doesn't update cpumasks of the tasks in the top cpuset (root)
>> at all when there is a cpu offline or online event. It is probably because
>> for some of the tasks in the top cpuset, especially the percpu kthread,
>> changing their cpumasks can be catastrophic. The hotplug code does update
>> the cpumasks of the tasks that are not in the top cpuset. This problem is
>> irrespective of whether v1 or v2 is in use.
> I've been saying this exact thing for how many mails now?

My bad. The fact that sched_getaffinity() masks off the offline cpus 
makes me thought incorrectly that tasks in the top cpuset were also 
updated by the hotplug code. Further testing indicates this is the case.

Thanks,
Longman

