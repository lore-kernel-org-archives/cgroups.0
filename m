From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Revert "mm/vmscan: never demote for memcg reclaim"
Date: Wed, 18 May 2022 12:51:10 -0700
Message-ID: <afd96793-549d-94eb-607c-6a785788397a@intel.com>
References: <20220518190911.82400-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652903473; x=1684439473;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qI2hRvQWGqLlvCgm5r1r2wIsZFcii9ZgTyxajRKplqk=;
  b=HnF17rcebY7JhrTHtbMkV9gZnCRCyOeotFWbV5UC1PS6FO46q9AjRe0E
   ARodhDmCNdA5Ukt8xz95d6R9qcZPBK6Uedg7eoWuNywTnG/TdhJjpTADH
   XzomDAaau/qzQPMhtbIwwW+xgGYgQJ+WjcJQGDp7GCHovG5D3P5TPGpFO
   mJSEE80YzLz3ZNDtAN4EUIIfzR0vcRUGCS++qiBOLtFOYV2yuqULXI9R+
   0vcwOQW+iVJqB35YCmg+nAp2eNVptCfTe4+RQnHciFPPJ5sIkeEbzU1n4
   xDKoMyVTkge5FNb6uHZiZG+bM7t9LGXJqp+uSdGQnABoFHqHtCuCe0aRt
   g==;
Content-Language: en-US
In-Reply-To: <20220518190911.82400-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On 5/18/22 12:09, Johannes Weiner wrote:
> However, with NUMA balancing now doing tier promotions, demotion is
> part of the page aging process. Global reclaim demotes the coldest
> toptier pages to secondary memory, where their life continues and from
> which they have a chance to get promoted back. Essentially, tiered
> memory systems have an LRU order that spans multiple nodes.

Thanks for the detailed explanation.  Ultimately, this was just intended
as an optimization to make cgroup reclaim more efficient.  But, I agree
that ordering correctness should trump efficiency.

Acked-by: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

