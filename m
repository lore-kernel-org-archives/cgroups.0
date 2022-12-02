From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH v3 2/3] selftests: cgroup: refactor proactive reclaim
 code to reclaim_until()
Date: Fri, 2 Dec 2022 14:20:58 -0800
Message-ID: <Y4p6SlewnfvOFs7d@P9FQF9L96D.corp.robot.car>
References: <20221202031512.1365483-1-yosryahmed@google.com>
 <20221202031512.1365483-3-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1670019664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Nb8k+DXeBU/J0+0BiQ1cnwf8hXfYeMnAmujWdPmsnKU=;
        b=UxM8kjrT9Ea2zn2bW1xVTLb0ig9zVs+Un8YBzcLzK7pOIf97+C/ov/djzFl3e7QSaXWeda
        FP0gGaYLRkXM8B1mFBNJc0IsIcbnK3fQgl0fMEbesY65k0hd48x2jgSiiNubIX1gTlc9SL
        8p/21LJMfIiYG6LzYyf1NcABb1nKOqw=
Content-Disposition: inline
In-Reply-To: <20221202031512.1365483-3-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri, Dec 02, 2022 at 03:15:11AM +0000, Yosry Ahmed wrote:
> Refactor the code that drives writing to memory.reclaim (retrying, error
> handling, etc) from test_memcg_reclaim() to a helper called
> reclaim_until(), which proactively reclaims from a memcg until its
> usage reaches a certain value.
> 
> While we are at it, refactor and simplify the reclaim loop.
> 
> This will be used in a following patch in another test.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Suggested-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

Reviewed-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

Thanks!
