From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] cpuset: Fix cpuset_cpus_allowed() to not filter
 offline CPUs
Date: Wed, 1 Feb 2023 14:17:59 -0500
Message-ID: <5a1a6e1f-2d19-e2ff-8f2c-63d185aa057b@redhat.com>
References: <20230131221719.3176-1-will@kernel.org>
 <20230131221719.3176-2-will@kernel.org>
 <6b068916-5e1b-a943-1aad-554964d8b746@redhat.com>
 <Y9otWX+MGOLDKU6t@hirez.programming.kicks-ass.net>
 <83e53632-27ed-8dde-84f4-68c6776d6da8@redhat.com>
 <a892d340-ea99-1562-0e70-176f02f195c2@redhat.com>
 <37f158af-6ca8-9f5a-c87a-0266d8bb21a6@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675279086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e12sH+zkKNX78AjXSikDkdXZisiXuIfpSmor0Y5G9UI=;
        b=UPbwi0eGz7miwa5Ntn9dFkaT3jpjI+B1R6BnA0+LUObL2ULHkfcLvrdRx7F5efqAq6h34t
        0ANWmmIcVXNczOAFw0nS2AL/biqXBug++U3CyUfX1DK/9gwy4A8ULq00MoLuNxDtB2XB79
        DzO7OoSnesAGT9nUA8HR9LXEarIGBV0=
Content-Language: en-US
In-Reply-To: <37f158af-6ca8-9f5a-c87a-0266d8bb21a6-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2/1/23 14:14, Waiman Long wrote:
> One possible solution is to use cpuset_cpus_allowed_fallback() in case 
> none of the cpus in the current cpuset is allowed to be used to run a 
> given task.

It looks like we will need to enhance cpuset_cpus_allowed_fallback() to 
walk up cpuset tree to find one that have useable cpus.

Cheers,
Longman

