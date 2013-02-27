From: Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH] memcg: implement low limits
Date: Wed, 27 Feb 2013 00:20:36 -0800
Message-ID: <xr93y5eacgmj.fsf@gthelen.mtv.corp.google.com>
References: <8121361952156@webcorp1g.yandex-team.ru>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=x-received:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version:content-type;
        bh=gdgCa61rc9/ONT9g+vVb0uFfHFLiIurec0DUcoB0WFI=;
        b=o/npXRTMTBiiq10I3tqRIQmIkyeD2M88tTXX3gFJJn2OBz2iMHjDhIG7fUSNVCI6h5
         CabR53rrbuMx88arMpHdds6jkLfdqsApJkMJ5jckVhUYug9sEZxTD7WdzRtTjvHfeoJd
         3HIH2G+sM3M7FtDABQjYxqzRrucR5IXZulmLIBp9XVZC6a5VzTvl0y8tTvR973dvMRYc
         N0yd+SucRv0BhJEMAFfXaMISKFsGLo/DTMVv07+g2LSeNBdaYMBjINJBCtmowG09m7l3
         pd6Kqn3rKr4bSdgpZSH6QZSchZbrR/IlslN3SwTMFkmC4Otv+fEwmAuCbr8hlbb5CMSN
         85Cg==
In-Reply-To: <8121361952156@webcorp1g.yandex-team.ru> (Roman Gushchin's
	message of "Wed, 27 Feb 2013 12:02:36 +0400")
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <klamm@yandex-team.ru>
Cc: Johannes Weiner-Arquette <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>, mel@csn.ul.ie, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Wed, Feb 27 2013, Roman Gushchin wrote:

> Hi, all!
>
> I've implemented low limits for memory cgroups. The primary goal was to add an ability 
> to protect some memory from reclaiming without using mlock(). A kind of "soft mlock()".
>
> I think this patch will be helpful when it's necessary to protect production processes from
> memory-wasting backup processes.
>
> --
>
> Low limits for memory cgroup can be used to limit memory pressure on it.
> If memory usage of a cgroup is under it's low limit, it will not be
> affected by global reclaim. If it reaches it's low limit from above,
> the reclaiming speed will be dropped exponentially.
>
> Low limits don't affect soft reclaim.
> Also, it's possible that a cgroup with memory usage under low limit
> will be reclaimed slowly on very low scanning priorities.

So the new low limit is not a rigid limit.  Global reclaim can reclaim
from a cgroup when its usage is below low_limit_in_bytes although such
reclaim is less aggressive than when usage is above low_limit_in_bytes.
Correct?

Why doesn't memcg reclaim (i.e. !global_reclaim) also consider
low_limit_in_bytes?

Do you have demonstration of how this improves system operation?

Why is soft_limit insufficient?

> Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
> ---
>  include/linux/memcontrol.h  |    7 +++++
>  include/linux/res_counter.h |   17 +++++++++++
>  kernel/res_counter.c        |    2 ++
>  mm/memcontrol.c             |   67 +++++++++++++++++++++++++++++++++++++++++++
>  mm/vmscan.c                 |    5 ++++
>  5 files changed, 98 insertions(+)

Need to update Documentation/cgroups/memory.txt explaining the external
behavior of this new know and how it interacts with soft_limit_in_bytes.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
