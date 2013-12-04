From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 2/2] mm: memcg: do not allow task about to OOM kill to
 bypass the limit
Date: Wed, 4 Dec 2013 15:51:57 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1312041546370.6329@chino.kir.corp.google.com>
References: <1386197114-5317-1-git-send-email-hannes@cmpxchg.org> <1386197114-5317-3-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=5OvzI1Mwzo4KL1vRrtozCQPerqrS3CLNKOLn5NvCQts=;
        b=fVepudujgqgSQgabBJMfKs3Gva1J+UFQ+y3/IqtON6OO4KM65g/kOx6mh6a/CDdfLB
         3EiclGyQiKHVE3HBz1lA81PwOSefW3bZkZ9/W0Xq45WxcZV4gAT2uFdmNPeEnEczhChX
         I/dmb8XMAG33fUrvEGVuQikSkiiq22q96MNs+7hI8H2nR3R1kXrYBQ0+khL1gnyE9mwe
         Xk24G6sH5iDXcVfthIsWl2agkvOHUr7fKL1z+rYztClFCHuerK86eWgUruzcJcYNeipp
         you46oo46eTmF83aYOsQyS+hO2lBHvL/HSJpyN7rDybzaPb28kjuBqB4yGiVitt11TaM
         i1kA==
In-Reply-To: <1386197114-5317-3-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 4 Dec 2013, Johannes Weiner wrote:

> 4942642080ea ("mm: memcg: handle non-error OOM situations more
> gracefully") allowed tasks that already entered a memcg OOM condition
> to bypass the memcg limit on subsequent allocation attempts hoping
> this would expedite finishing the page fault and executing the kill.
> 
> David Rientjes is worried that this breaks memcg isolation guarantees
> and since there is no evidence that the bypass actually speeds up
> fault processing just change it so that these subsequent charge
> attempts fail outright.  The notable exception being __GFP_NOFAIL
> charges which are required to bypass the limit regardless.
> 
> Reported-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: David Rientjes <rientjes@google.com>

Thanks!

I think we should consider marking this for stable@vger.kernel.org for 
3.12 since the original patch went into 3.12-rc6.  Depending on the number 
of allocators in the oom memcg, the amount of memory bypassed can become 
quite large.

For example, in a memcg with a limit of 128MB, if you start 10 concurrent 
processes that simply allocate a lot of memory you can get quite a bit of 
memory bypassed.  If I start 10 membench processes, which would cause a 
128MB memcg to oom even if only one such process were running, we get:

# grep RSS /proc/1092[0-9]/status
VmRSS:	   15724 kB
VmRSS:	   15064 kB
VmRSS:	   13224 kB
VmRSS:	   14520 kB
VmRSS:	   14472 kB
VmRSS:	   13016 kB
VmRSS:	   13024 kB
VmRSS:	   14560 kB
VmRSS:	   14864 kB
VmRSS:	   14772 kB

And all of those total ~140MB of memory while bound to a memcg with a 
128MB limit, about 10% of memory is bypassed.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
