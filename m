From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v7 03/10] memcg: enable accounting for file lock caches
Date: Tue, 27 Jul 2021 14:41:23 -0700
Message-ID: <CALvZod6xT-Hh3Jndh4uY_YXstjk18Lq_kLxo1huBPnb8A84Wew@mail.gmail.com>
References: <6f21a0e0-bd36-b6be-1ffa-0dc86c06c470@virtuozzo.com>
 <cover.1627362057.git.vvs@virtuozzo.com> <b009f4c7-f0ab-c0ec-8e83-918f47d677da@virtuozzo.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s93ky4F/jioIoNmdtZvpaIjb8/udfZPafTlFZjDMqHQ=;
        b=R8iLQFVMijNvae4GMHQsDyKNJF1x6r0W7+1jWZhTLpPYX7jpQldHzHrpSGKdSGe8OB
         2dUeA4EQCX8Qhh8ndamI5LuUzwNaMLGiIjV/goZKSMkcQeDY81ehXZ907DPyaA0k6eyk
         6JSfkAPSRjslQzjF22lcu5/hizvGfzsfq/oP3Hl5uzqq6QpEGU03LVJIFm0ek2RbdTBS
         QHPA2SP83GMPrVFBySAAhlD43A1Qaxjb6vifSAvDl9b1vwStGPYCvohj3pP/l3Bx1MpG
         RkuHnFM0MrGqkZWeNzKMpd8+6OK2JCZPEBFaJe5l7sjk5VRrvv/O5G5IePluX4xby4R+
         xbog==
In-Reply-To: <b009f4c7-f0ab-c0ec-8e83-918f47d677da@virtuozzo.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Cgroups <cgroups@vger.kernel.org>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Mon, Jul 26, 2021 at 10:33 PM Vasily Averin <vvs@virtuozzo.com> wrote:
>
> User can create file locks for each open file and force kernel
> to allocate small but long-living objects per each open file.
>
> It makes sense to account for these objects to limit the host's memory
> consumption from inside the memcg-limited container.
>
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
