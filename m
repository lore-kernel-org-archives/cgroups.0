From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm, memcg: unify reclaim retry limits with page allocator
Date: Fri, 22 May 2020 07:07:56 -0700
Message-ID: <CALvZod6ijEUKTXzi1oDV0R2HdU6bcxUn_zDigskuSPtzn-vw0g@mail.gmail.com>
References: <20200520163142.GA808793@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ASpIJRV1LgbYaIn/8sihf9PSqZ7K//HA8oIfV5Jji1U=;
        b=Q98veh9b1zBp4PWhmCf74WRK0Byrzkwey2rtOIQaXyx1kyEDcG3M6jXlCJOhaNxM5/
         9sj2TOOYHXEwh0fYzQ9FWMZfc0E8eE1/WZ2qrZajc+2KYj6iyYljfm/4TvkU3jkfOFI3
         YYUty1xtwI/bERs9jSMcLkRivOd74V0q8VEyy+weMSJJux6/WgAlmVEJMy5S77lYpI6X
         C4RRVTYaZZ3O6DoGtybBgW13esxeDx7YL6yHgkoJ4xGvMUndKjLCAM0tNGLW0pfCIKJU
         1RIk/vV7uokJ+qdYAfnkLwrgbKEC2CRiXSL18tpjvsHmOZiGRKjVtgqW4lxZcNme/MRF
         2niQ==
In-Reply-To: <20200520163142.GA808793@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <kernel-team@fb.com>

On Wed, May 20, 2020 at 9:32 AM Chris Down <chris@chrisdown.name> wrote:
>
> Reclaim retries have been set to 5 since the beginning of time in
> 66e1707bc346 ("Memory controller: add per cgroup LRU and reclaim").
> However, we now have a generally agreed-upon standard for page reclaim:
> MAX_RECLAIM_RETRIES (currently 16), added many years later in
> 0a0337e0d1d1 ("mm, oom: rework oom detection").
>
> In the absence of a compelling reason to declare an OOM earlier in memcg
> context than page allocator context, it seems reasonable to supplant
> MEM_CGROUP_RECLAIM_RETRIES with MAX_RECLAIM_RETRIES, making the page
> allocator and memcg internals more similar in semantics when reclaim
> fails to produce results, avoiding premature OOMs or throttling.
>
> Signed-off-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
