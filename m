From: Gang Li <gang.li@linux.dev>
Subject: Re: [PATCH v4] mm: oom: introduce cpuset oom
Date: Thu, 17 Aug 2023 16:40:46 +0800
Message-ID: <9ba0de31-b9b8-fb10-011e-b24e9dba5ccd@linux.dev>
References: <20230411065816.9798-1-ligang.bdlg@bytedance.com>
 <ZDVwaqzOBNTpuR1w@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1692261651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nIphj18RtSktOChYllHuu9FMoXo0StpvUC/Vo4hk6Xc=;
        b=YoBZrjACVksy7EYTvMwTn/K0VhdgDsK1M9FMSZYMJ2ji5UPgut5HZmPHbNhafQHl9OVfRz
        hutBe++EfG9ZTsLKVWqvz45nyDwaBBdqTcSBVJQZxhkor7Bdr+Oqmg58p50bHfR9dy1AkI
        zpiGdJyUq2jAD+qB2jRuuxdP/waMHIg=
Content-Language: en-US
In-Reply-To: <ZDVwaqzOBNTpuR1w@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko@suse.com>
Cc: Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, rientjes@google.com, Zefan Li <lizefan.x@bytedance.com>, linux-kernel@vger.kernel.org

Apologize for the extremely delayed response. I was previously occupied
with work unrelated to the Linux kernel.

On 2023/4/11 22:36, Michal Hocko wrote:
> I believe it still wouldn't hurt to be more specific here.
> CONSTRAINT_CPUSET is rather obscure. Looking at this just makes my head
> spin.
>          /* Check this allocation failure is caused by cpuset's wall function */
>          for_each_zone_zonelist_nodemask(zone, z, oc->zonelist,
>                          highest_zoneidx, oc->nodemask)
>                  if (!cpuset_zone_allowed(zone, oc->gfp_mask))
>                          cpuset_limited = true;
> > Does this even work properly and why? prepare_alloc_pages sets
> oc->nodemask to current->mems_allowed but the above gives us
> cpuset_limited only if there is at least one zone/node that is not
> oc->nodemask compatible. So it seems like this wouldn't ever get set
> unless oc->nodemask got reset somewhere. This is a maze indeed.Is there

In __alloc_pages:
```
/*
  * Restore the original nodemask if it was potentially replaced with
  * &cpuset_current_mems_allowed to optimize the fast-path attempt.
  */
ac.nodemask = nodemask;
page = __alloc_pages_slowpath(alloc_gfp, order, &ac);

```

__alloc_pages set ac.nodemask back to mempolicy before call
__alloc_pages_slowpath.


> any reason why we cannot rely on __GFP_HARWALL here? Or should we

In prepare_alloc_pages:
```
if (cpusets_enabled()) {
	*alloc_gfp |= __GFP_HARDWALL;
	...
}
```

Since __GFP_HARDWALL is set as long as cpuset is enabled, I think we can
use it to determine if we are under the constraint of CPUSET.

But I have a question: Why we always set __GFP_HARDWALL when cpuset is
enabled, regardless of the value of cpuset.mem_hardwall?


Thanks,
Gang Li
