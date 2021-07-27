From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v7 10/10] memcg: enable accounting for ldt_struct objects
Date: Tue, 27 Jul 2021 15:36:54 -0700
Message-ID: <CALvZod4OjK75uh2nHA8QOfefUSXD7ZSxm3qaQY+aA9zDuKmNnw@mail.gmail.com>
References: <6f21a0e0-bd36-b6be-1ffa-0dc86c06c470@virtuozzo.com>
 <cover.1627362057.git.vvs@virtuozzo.com> <38010594-50fe-c06d-7cb0-d1f77ca422f3@virtuozzo.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q9riWywpJIN08LA7hQqUxqDxz6rPo4nB08ihydLn/AQ=;
        b=gsi7ICxX3ii2PVLmoIZtbBP0sGaJTU2D5/yA3Ue2ciJeEvL1IJrMuRT/R4K+SEAU83
         dflfu+Kv3TLZT5zypULzNgkU0BxQVsaYvBuZCiiacoY7mOBwZWlhz86OhP+QozXBliwD
         PM88Om9Hc4nuKpfSc1WXAx3wU1tvWkkF7e8POK0mPB6S/TYEKZt/qsCWV7KLuWjm+MmN
         jTnKKr0ZoV54o/SxlyKF0bRskE2KKw4AKUYMzGjmbhz/ZFBBBRoe7LyRCAhqF7+ZcHmg
         DJnoniScr++Z7XjGjrgJIxV2pshZQsHb8o57jYwclc/FgRIiKZA45kPQr3r8ajnRDcdx
         ytUw==
In-Reply-To: <38010594-50fe-c06d-7cb0-d1f77ca422f3@virtuozzo.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Cgroups <cgroups@vger.kernel.org>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>

On Mon, Jul 26, 2021 at 10:34 PM Vasily Averin <vvs@virtuozzo.com> wrote:
>
> Each task can request own LDT and force the kernel to allocate up to
> 64Kb memory per-mm.
>
> There are legitimate workloads with hundreds of processes and there
> can be hundreds of workloads running on large machines.
> The unaccounted memory can cause isolation issues between the workloads
> particularly on highly utilized machines.
>
> It makes sense to account for this objects to restrict the host's memory
> consumption from inside the memcg-limited container.
>
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> Acked-by: Borislav Petkov <bp@suse.de>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
