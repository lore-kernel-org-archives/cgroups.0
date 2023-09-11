From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v4 4/4] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Mon, 11 Sep 2023 15:11:41 +0200
Message-ID: <ZP8SDdjut9VEVpps@dhcp22.suse.cz>
References: <20230831165611.2610118-1-yosryahmed@google.com>
 <20230831165611.2610118-5-yosryahmed@google.com>
 <ZPX0kCKd4TaVLJY7@dhcp22.suse.cz>
 <CAAPL-u9D2b=iF5Lf_cRnKxUfkiEe0AMDTu6yhrUAzX0b6a6rDg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694437902; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dAnggcIlt7gXO1y/HPyY0b6GxiBZLKtzxMTmkT2O7rM=;
        b=DJYa/aPW6CAm2WlLnbW5KJO3XGRc5Dai0Q10q1uOkqmgSNq0uKLo7puZ/HozKYaHC6603K
        Xd0keI4YJWugG1I69OR92Hy+/F9seThNKxFw3laAgo+kygOX1MiZpicUjF72v0I8SIpx/E
        oWAyV2AkEAWgRDXnn0R3Q+yNRRQLCoU=
Content-Disposition: inline
In-Reply-To: <CAAPL-u9D2b=iF5Lf_cRnKxUfkiEe0AMDTu6yhrUAzX0b6a6rDg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Xu <weixugc@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Tejun Heo <tj@kernel.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>

On Thu 07-09-23 17:52:12, Wei Xu wrote:
[...]
> I tested this patch on a machine with 384 CPUs using a microbenchmark
> that spawns 10K threads, each reading its memory.stat every 100
> milliseconds.

This is rather extreme case but I wouldn't call it utterly insane
though.

> Most of memory.stat reads take 5ms-10ms in kernel, with
> ~5% reads even exceeding 1 second.

Just curious, what would numbers look like if the mutex is removed and
those threads would be condending on the existing spinlock with lock
dropping in place and removed. Would you be willing to give it a shot?

-- 
Michal Hocko
SUSE Labs
