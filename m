From: Ivan Babrou <ivan@cloudflare.com>
Subject: Re: Expensive memory.stat + cpu.stat reads
Date: Mon, 10 Jul 2023 16:23:45 -0700
Message-ID: <CABWYdi20sL8pK2jjS=v0OG+dPxWnSBXvknVEWeyB47V0F5Wayw@mail.gmail.com>
References: <CABWYdi0c6__rh-K7dcM_pkf9BJdTRtAU08M43KO9ME4-dsgfoQ@mail.gmail.com>
 <gbqumqkxixvvrbbqh55rw6thgfa67tw2kkcuauc4xj5t6pnivd@3yfkokngo43w>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1689031436; x=1691623436;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ax+jVrYfNmxpClqi51wVQRM9DJaaLI9Ll9U+M+qNnIE=;
        b=BLXTGXARwPCt0Z3QY6Hkyqe8P+UvKJuwOcDpcUhFrh7oauHoH7ek9S8FnzkxNKruxX
         h3Fkat+06xrYJVtdH+Ksjd099ymifYhPIVXtCSUuBFupjA4JzaCHCo03hWSvfs1PRNB+
         k5eZnIfD3YabAza1cBlawD8pI6YWJibUkXyDA=
In-Reply-To: <gbqumqkxixvvrbbqh55rw6thgfa67tw2kkcuauc4xj5t6pnivd@3yfkokngo43w>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, Linux MM <linux-mm@kvack.org>, kernel-team <kernel-team@cloudflare.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, Jul 10, 2023 at 7:44=E2=80=AFAM Michal Koutn=C3=BD <mkoutny@suse.co=
m> wrote:
>
> Hello.
>
> On Fri, Jun 30, 2023 at 04:22:28PM -0700, Ivan Babrou <ivan@cloudflare.co=
m> wrote:
> > As you might've noticed from the output, splitting the loop into two
> > makes the code run 10x faster.
>
> That is curious.
>
> > We're running Linux v6.1 (the output is from v6.1.25) with no patches
> > that touch the cgroup or mm subsystems, so you can assume vanilla
> > kernel.
>
> Have you watched for this on older kernels too?

We've been on v6.1 for quite a while now, but it's possible that we
weren't paying enough attention before to notice.

> > I am happy to try out patches or to do some tracing to help understand
> > this better.
>
> I see in your reproducer you tried swapping order of controllers
> flushed.
> Have you also tried flushing same controller twice (in the inner loop)?
> (Despite the expectation is that it shouldn't be different from half the
> scenario where ran two loops.)

Same controller twice is fast (whether it's mem + mem or cpu + cpu):

warm-up
completed: 17.24s [manual / cpu-stat + mem-stat]
completed:  1.02s [manual / mem-stat+mem-stat]
completed:  0.59s [manual / cpu-stat+cpu-stat]
completed:  0.44s [manual / mem-stat]
completed:  0.16s [manual / cpu-stat]
running
completed: 14.32s [manual / cpu-stat + mem-stat]
completed:  1.25s [manual / mem-stat+mem-stat]
completed:  0.42s [manual / cpu-stat+cpu-stat]
completed:  0.12s [manual / mem-stat]
completed:  0.50s [manual / cpu-stat]
