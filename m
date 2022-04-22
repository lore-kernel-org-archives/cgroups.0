From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH 5/5] cgroup: Fix racy check in alloc_pagecache_max_30M()
 helper function
Date: Fri, 22 Apr 2022 16:56:14 -0700
Message-ID: <YmNAni3YH2fWFrSZ@carbon>
References: <20220422155728.3055914-1-void@manifault.com>
 <20220422155728.3055914-6-void@manifault.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1650671780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+EaQSEVslaLuejAKqVFqZ9iCKFR405OvDd1jGIm3QWY=;
        b=v5MGwbB6eilouV9kuZMZyAE6+dLSBhKbVeaZ8F/6IViG8ajAxiF9ycz9BrGwqr4PehJJzi
        P+XdDJ6vFBGpWd2jzo2fNy6RCUvTT1QUJMmHjzWoSmvKLW/AeewWt+FwV95+eCQgCI98lY
        xW6F8hjtauFm0NCmWFgLIOXxX0xLQBM=
Content-Disposition: inline
In-Reply-To: <20220422155728.3055914-6-void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Apr 22, 2022 at 08:57:29AM -0700, David Vernet wrote:
> alloc_pagecache_max_30M() in the cgroup memcg tests performs a 50MB
> pagecache allocation, which it expects to be capped at 30MB due to the
> calling process having a memory.high setting of 30MB. After the allocation,
> the function contains a check that verifies that MB(29) < memory.current <=
> MB(30). This check can actually fail non-deterministically.
> 
> The testcases that use this function are test_memcg_high() and
> test_memcg_max(), which set memory.min and memory.max to 30MB respectively
> for the cgroup under test. The allocation can slightly exceed this number
> in both cases, and for memory.max, the process performing the allocation
> will not have the OOM killer invoked as it's performing a pagecache
> allocation.  This patchset therefore updates the above check to instead use
> the verify_close() helper function.
> 
> Signed-off-by: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>

Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

Thanks, David!
