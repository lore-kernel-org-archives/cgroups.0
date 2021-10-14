From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] memcg: page_alloc: skip bulk allocator for __GFP_ACCOUNT
Date: Thu, 14 Oct 2021 11:23:36 -0400
Message-ID: <YWhLeAL5RPfLjrlO@cmpxchg.org>
References: <20211013194338.1804247-1-shakeelb@google.com>
 <YWfZNF7T7Fm69sik@dhcp22.suse.cz>
 <CALvZod4Br9iwq-qfdwj6dzgW2g1vEr2YL4=w_mQjOeWWDQzFjw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=By52BGa835IE4lyaZQwwtW5rAiE3tQH6DwCoYXbpm9E=;
        b=acZGhTzeICP5dR16o7d44zA806wjXfAFaH1u+XIyklzn3XApXetVdZA3xTVlo6FV5W
         7mhpqHdrKn7qQG7YCGWrsqMSJ/LTR/sUkidAix1OyA/T5a0UqzOy5hF3mNNla4ltmNFv
         Oay9ZIvxwsHCCOhe7oxdDn96wZcPm2/8GRVyNXK3Tsya2KnW4E7zPJ8qnAmCU+MNu/ve
         HLuf6dKzLLJhCV4MCVolKpTi/TjWPmfzTh0oahUwDKa7TbJkhez4zxc3/dtIjbEd9/lt
         Hx+Gx9w2Nxx8DFDInfXyLREY1KDQ3Irf/QLYT1oM84jVfQXe/4exZYV8UPDJWWWD9OtT
         spzg==
Content-Disposition: inline
In-Reply-To: <CALvZod4Br9iwq-qfdwj6dzgW2g1vEr2YL4=w_mQjOeWWDQzFjw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Oct 14, 2021 at 08:01:16AM -0700, Shakeel Butt wrote:
> Regarding xfs_buf_alloc_pages(), it is not using __GFP_ACCOUNT

It probably should, actually. Sorry, somewhat off-topic, but we've
seen this consume quite large amounts of memory. __GFP_ACCOUNT and
vmstat tracking seems overdue for this one.
