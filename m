From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] cpuset: Fix cpuset_cpus_allowed() to not filter
 offline CPUs
Date: Thu, 2 Feb 2023 11:06:51 -0500
Message-ID: <d630ca53-71f0-c735-fbc3-e826479aa86b@redhat.com>
References: <20230131221719.3176-1-will@kernel.org>
 <20230131221719.3176-2-will@kernel.org>
 <6b068916-5e1b-a943-1aad-554964d8b746@redhat.com>
 <Y9t1sP/6nFht7RSN@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675354020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K7phcfiE83fVwz5I8bWRnbFjaiLhRCsY0h7b3g24mK8=;
        b=AW496yp2glKYX90OUYaHtuuGXVy+pO2vCOPu3U/eqrxBJb/1aifyPa4E2eT6Nsibj/wGAA
        TWO9tljCuFdD+8dgGMhVlf47CHsWUTZPvqhiTGEDGcYLqJqqnpxCw64sCDaG8pYDG3ukbP
        mniapK6/BXwr1Ak/skk4rJvzLu22WuU=
Content-Language: en-US
In-Reply-To: <Y9t1sP/6nFht7RSN-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2/2/23 03:34, Peter Zijlstra wrote:
> On Tue, Jan 31, 2023 at 11:14:27PM -0500, Waiman Long wrote:
>
>> A major concern I have is the overhead of creating a poor man version of v2
>> cpus_allowed. This issue can be worked around even for cpuset v1 if it is
>> mounted with the cpuset_v2_mode option to behave more like v2 in its cpumask
>> handling. Alternatively we may be able to provide a config option to make
>> this the default for v1 without the special mount option, if necessary.
> It is equally broken for v2, it masks against effective_cpus. Not to
> mention it explicitly starts with cpu_online_mask.

After taking a close look at the patch, my understanding of what it is 
doing is as follows:

v2: cpus_allowed will not be affected by hotplug. So the new 
cpuset_cpus_allowed() will return effective_cpus + offline cpus that 
should have been part of effective_cpus if online before masking it with 
allowable cpus and then go up the cpuset hierarchy if necessary.

v1: cpus_allowed is equivalent to v2 effective_cpus. It starts at the 
current cpuset and move up the hierarchy if necessary to find a cpuset 
that have at least one allowable cpu.

First of all, it does not take into account of the v2 partition feature 
that may cause it to produce incorrect result if partition is enabled 
somewhere. Secondly, I don't see any benefit other than having some 
additional offline cpu available in a task's cpumask which the scheduler 
will ignore anyway. v2 is able to recover a previously offlined cpu. So 
we don't gain any net benefit other than the going up the cpuset 
hierarchy part.

For v1, I agree we should go up the cpuset hierarchy to find a usable 
cpuset. Instead of introducing such a complexity in 
cpuset_cpus_allowed(), my current preference is to do the hierarchy 
climbing part in an enhanced cpuset_cpus_allowed_fallback() after an 
initial failure of cpuset_cpus_allowed(). That will be easier to 
understand than having such complexity and overhead in 
cpuset_cpus_allowed() alone.

I will work on a patchset to do that as a counter offer.

Cheers,
Longman



