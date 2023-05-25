From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm/memcontrol: export memcg.swap watermark via sysfs for
 v2 memcg
Date: Wed, 24 May 2023 21:21:03 -0400
Message-ID: <20230525012103.GA24888@cmpxchg.org>
References: <20230524181734.125696-1-lars@pixar.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20221208.gappssmtp.com; s=20221208; t=1684977665; x=1687569665;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j98gJ4+KN81zlHrINZqrH05Pl+KjXomFxD3KB2ZcwUg=;
        b=aM2MHGY4xUTYKWMcoV1R2ROW5efcpmXigmAL+mMZ5XEnMx0rFxVwZKHGcFfPYyyt4C
         fgrmVpz11FsExkBVjSERPrjP/wh8NJ8MczWW9ITix0Db7wdihD4Ac3W9Mlx3hGIcY5TV
         eWQRaHpScNvFpMGTp8PaXSBqvklX5x18eHZyXR1L9T342LW4WcMfkmIGLFObi24tJs7s
         r0eLa8u0K8XpmMUwXl6S5cB/KijNkqetUl/um5sOvatWTu21sGkGtGRXB3jq44zaDkwf
         svBLbM/mdYZ5c5IYM34uw64uf1dbIgdjkcoAQJCLo/AQyVz0V8ojNZ34TAgKmo2ooHRX
         L9hw==
Content-Disposition: inline
In-Reply-To: <20230524181734.125696-1-lars@pixar.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Lars R. Damerow" <lars@pixar.com>
Cc: mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, tj@kernel.org, lizefan.x@bytedance.com, corbet@lwn.net, muchun.song@linux.dev, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Wed, May 24, 2023 at 11:17:33AM -0700, Lars R. Damerow wrote:
> This patch is similar to commit 8e20d4b33266 ("mm/memcontrol: export
> memcg->watermark via sysfs for v2 memcg"), but exports the swap counter's
> watermark.
> 
> We allocate jobs to our compute farm using heuristics determined by memory
> and swap usage from previous jobs. Tracking the peak swap usage for new
> jobs is important for determining when jobs are exceeding their expected
> bounds, or when our baseline metrics are getting outdated.
> 
> Our toolset was written to use the "memory.memsw.max_usage_in_bytes" file
> in cgroups v1, and altering it to poll cgroups v2's "memory.swap.current"
> would give less accurate results as well as add complication to the code.
> Having this watermark exposed in sysfs is much preferred.
> 
> Signed-off-by: Lars R. Damerow <lars@pixar.com>

Looks good to me.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
