From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH] mm: Proportional memory.{low,min} reclaim
Date: Mon, 28 Jan 2019 16:42:13 -0500
Message-ID: <20190128214213.GB15349@chrisdown.name>
References: <20190124014455.GA6396@chrisdown.name>
 <20190128210031.GA31446@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=a9PsKmGgPsTKkLBb3g/jY5/HxZPgchB4hPGH18bC0Lo=;
        b=QWvsOqRqyIcKZR7jItEvBi0genFdYcFV76xiW7vN4DO4Eba+BvzpUc474b40EBe4es
         h4O385MUeLovYQGLyM9wvEI2R3H0Lshq64jenrQ1csimCipZwR+Ux6IUPGUTgHM8Jw5f
         0a2oM0SqHJFVbknYw26SZ8N4D2DVfzvcaDunk=
Content-Disposition: inline
In-Reply-To: <20190128210031.GA31446@castle.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Kernel Team <Kernel-team@fb.com>

Roman Gushchin writes:
>Hm, it looks a bit suspicious to me.
>
>Let's say memory.low = 3G, memory.min = 1G and memory.current = 2G.
>cgroup_size / protection == 1, so scan doesn't depend on memory.min at all.
>
>So, we need to look directly at memory.emin in memcg_low_reclaim case, and
>ignore memory.(e)low.

Hmm, this isn't really a common situation that I'd thought about, but it seems 
reasonable to make the boundaries when in low reclaim to be between min and 
low, rather than 0 and low. I'll add another patch with that. Thanks

>> +			scan = clamp(scan, SWAP_CLUSTER_MAX, lruvec_size);
>
>Idk, how much sense does it have to make it larger than SWAP_CLUSTER_MAX,
>given that it will become 0 on default (and almost any other) priority.

In my testing, setting the scan target to 0 and thus reducing scope for reclaim 
can result in increasing the scan priority more than is desirable, and since we 
base some vm heuristics based on that, that seemed concerning.

I'd rather start being a bit more cautious, erring on the side of scanning at 
least some pages from this memcg when priority gets elevated.

Thanks for the review!
