From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm: memcontrol: fix NR_WRITEBACK leak in memcg and system stats
Date: Wed, 7 Feb 2018 07:44:08 -0800
Message-ID: <CALvZod5-35Y+_eot6-6J5HyssnmAW-wfYhuQdxxA9Zj8Ng2e+g@mail.gmail.com>
References: <20180203082353.17284-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=ceieI8GRX02JzQZwW8S+/7Fasl+C5z8Hnc6EsaRkFHc=;
        b=UCfaV2qxbClBC9dnYwX10iHmcEEfbs2ItDOHChqPYFgiDz5j/agwVW2oYYZCujpfrB
         WJCWySz+xkEyq22EH3fhbmcJ4klmPzsSciZ8vhiVyJDWMzUZDRDRi+2IvxXkwInvm8qT
         YakEpWTjkvxTmVAbnnQevtW/mad3HzOgyVLsV5AoxGdxZEFoXpLGHCAIEFx4l274OlHU
         TyTkZWVm/rBM2wX+EA/sL8QvFN0DqJlalbDbexw+uqBV7IY1PyRBQ+Sd5YeMm+nEICqi
         p9eCBlaaQ6z+RgLtedP0dcZ7U33WpETweGsy2A/VyatfFcvzI4B7QNjL+qwqKFq66/Ip
         jHDQ==
In-Reply-To: <20180203082353.17284-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team@fb.com

On Sat, Feb 3, 2018 at 12:23 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> After the ("a983b5ebee57 mm: memcontrol: fix excessive complexity in
> memory.stat reporting"), we observed slowly upward creeping
> NR_WRITEBACK counts over the course of several days, both the
> per-memcg stats as well as the system counter in e.g. /proc/meminfo.
>
> The conversion from full per-cpu stat counts to per-cpu cached atomic
> stat counts introduced an irq-unsafe RMW operation into the updates.
>
> Most stat updates come from process context, but one notable exception
> is the NR_WRITEBACK counter. While writebacks are issued from process
> context, they are retired from (soft)irq context.
>
> When writeback completions interrupt the RMW counter updates of new
> writebacks being issued, the decs from the completions are lost.
>
> Since the global updates are routed through the joint lruvec API, both
> the memcg counters as well as the system counters are affected.
>
> This patch makes the joint stat and event API irq safe.
>
> Fixes: a983b5ebee57 ("mm: memcontrol: fix excessive complexity in memory.stat reporting")
> Debugged-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Should this be considered for stable?
