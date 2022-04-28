From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 4/5] mm: zswap: add basic meminfo and vmstat coverage
Date: Thu, 28 Apr 2022 13:27:46 -0400
Message-ID: <YmrOkk3jKr4dsjkJ@cmpxchg.org>
References: <20220427160016.144237-1-hannes@cmpxchg.org>
 <20220427160016.144237-5-hannes@cmpxchg.org>
 <Ymmnrkn0mSWcuvmH@google.com>
 <YmmznQ8AO5RLxicA@cmpxchg.org>
 <Ymm3WpvJWby4gaD/@cmpxchg.org>
 <Ymm/wayEB3MH6ZRY@google.com>
 <YmqfGaIhE8W+Z1mo@cmpxchg.org>
 <YmrItoe1W9dya+An@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ywIQvVwgag1com6bDxPqmKMeB7A08MtYuevMsyOSOPQ=;
        b=8QDJnLhAmNHGsLaBQmDqBrcILYyDP9jv4WD9nDDyluZQ3AyEx3MdCGQSDqxW70SGO6
         dHjEacPn670Cttc+vma5fsmybXQrEWDwOSriDm4M1zh/p8R0cfGR+P2UeAOOswBdPoPN
         UymIxmq005YN0pWaKnhy3Qt5T8fMP40inSpO/g4yKZyoeuGW2l3pub90YoPGUGQkiuLX
         cmUr1lNoAFW3vWIR6Ju6NmnMFVQlilVHADUJd9/Hwy6MK77xIUrA6Iyos41ScIK3y026
         cbYAaiaMgarYe1E4TgstRbzWse+RFycZstcjBiJwinrr2bYwiHSWcfz1tz0VoDWKMy1B
         frzg==
Content-Disposition: inline
In-Reply-To: <YmrItoe1W9dya+An-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Streetman <ddstreet-EkmVulN54Sk@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, Apr 28, 2022 at 10:02:46AM -0700, Minchan Kim wrote:
> On Thu, Apr 28, 2022 at 10:05:13AM -0400, Johannes Weiner wrote:
> > But I'd ack a patch that adds a combined "Compressed" counter for zram
> > + zswap if you send it, Minchan.
> 
> If we really want to go separate stat for zswap and zram, it would
> be better to use direct name "Zram: " instead of comrpessed.

That works for me as well.
