From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/5] cgroup/cpuset: Miscellaneous updates
Date: Wed, 15 Mar 2023 12:59:13 -0400
Message-ID: <bba0ed25-1130-d272-45cf-b14c95aa991f@redhat.com>
References: <20230306200849.376804-1-longman@redhat.com>
 <20230315162436.GA19015@willie-the-truck>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678899558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mo4/ufj5aP4JcG4WHWN3/PJ1VlRuoKnOT1MocwMtouQ=;
        b=P6EzsC67lOxS7zw4gkF81w0ZspBxaRXr6MWEdfbL/QzWoP5wcWwoGY2+SpwQjZ9+Mgmkqb
        T7jGCt8xqX3yoMtDenffmpTjMYPX8SJHZ3QyxP8e8TAJqL8I8W0Uw4l02W78h57hQ3NZZC
        CvGQGKzSsDi4Xr2MdJz2t4AXeAQ2qMA=
Content-Language: en-US
In-Reply-To: <20230315162436.GA19015@willie-the-truck>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>


On 3/15/23 12:24, Will Deacon wrote:
> Hi Waiman,
>
> On Mon, Mar 06, 2023 at 03:08:44PM -0500, Waiman Long wrote:
>> This patch series includes miscellaneous update to the cpuset and its
>> testing code.
>>
>> Patch 2 is actually a follow-up of commit 3fb906e7fabb ("cgroup/cpuset:
>> Don't filter offline CPUs in cpuset_cpus_allowed() for top cpuset tasks").
>>
>> Patches 3-4 are for handling corner cases when dealing with
>> task_cpu_possible_mask().
> Thanks for cc'ing me on these. I ran my arm64 asymmetric tests and, fwiw,
> I get the same results as vanilla -rc2, so that's good.
>
> One behaviour that persists (and which I thought might be addressed by this
> series) is the following. Imagine a 4-CPU system with CPUs 0-1 being 64-bit
> only. If I configure a parent cpuset with 'cpuset.cpus' of "0-2" and a
> child cpuset with 'cpuset.cpus' of "0-1", then attaching a 32-bit task
> to the child cpuset will result in an affinity mask of 4. If I then change
> 'cpuset.cpus' of the parent cpuset to "0-1,3", the affinity mask of the
> task remains at '4' whereas it might be nice to update it to '8', in-line
> with the new affinity mask of the parent cpuset.
>
> Anyway, I'm not complaining (this is certainly _not_ a regression), but
> I thought I'd highlight it in case you were aiming to address this with
> your changes.

I believe it is because changes in parent cpuset only won't cause the 
tasks in the child cpuset to be re-evaluated unless it causes a change 
in the effective_cpus of the child cpuset. This is the case here. We 
currently don't track how many tasks in the child cpusets are using 
parent's cpumask due to lacking runnable CPUs in the child cpuset. We 
can only fix this if we track those special tasks. It can be fixable, 
but I don't know if it is a problem that is worth fixing.

Cheers,
Longman

