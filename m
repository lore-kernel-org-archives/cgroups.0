From: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/6] mm: memcontrol: use the node-native slab memory
 counters
Date: Sat, 3 Jun 2017 20:39:06 +0300
Message-ID: <20170603173906.GC15130@esperanza>
References: <20170530181724.27197-1-hannes@cmpxchg.org>
 <20170530181724.27197-4-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GpClLB/jB2/fRiYqz4/Qc8LRg06aLFF4cpZOm4x7hmg=;
        b=d3adZv9Gs87lEV4vqab3gO0lpztpjrWymAT7wY9D20ZQ7I8jRzVepp3CfJjP1JDd+c
         a6vqKi8SKOevtOgec6OlLLuqkq5IoWqDfBXPUDGVw1zpdz26hx26Er1eA4e6/Kg2z/JN
         4cx5joiZesQR70yB4WUW0qYx5ig4BXInXJbkFp5VMOd+aZcMdmLFbvb1F7LSnieJnfdM
         O/2CBGd08CHEuRTF29RjCQVz+A/DG6RKL9h4D5ylZ4MWvlA3RSlf7fv4Bps8TMLi732f
         /35uNq/ABeo2ooGqH7r6LU5Zcwy1rxd+J02PGuKIGz7vxUg8HwbBDCx8J+GNIDHgezv6
         wkQQ==
Content-Disposition: inline
In-Reply-To: <20170530181724.27197-4-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, May 30, 2017 at 02:17:21PM -0400, Johannes Weiner wrote:
> Now that the slab counters are moved from the zone to the node level
> we can drop the private memcg node stats and use the official ones.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> ---
>  include/linux/memcontrol.h | 2 --
>  mm/memcontrol.c            | 8 ++++----
>  mm/slab.h                  | 4 ++--
>  3 files changed, 6 insertions(+), 8 deletions(-)

Not sure if moving slab stats from zone to node is such a good idea,
because they may be useful for identifying the reason of OOM, especially
on 32 bit hosts, but provided the previous patch is accepted, this one
looks good to me.

Acked-by: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
