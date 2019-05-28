From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] mm: memcontrol: don't batch updates of local VM stats and events
Date: Tue, 28 May 2019 10:37:15 -0700
Message-ID: <CAHk-=wgaLQjZ8AZj76_cwvk_wLPJjr+Dc=Qvac_vHY2RruuBww@mail.gmail.com>
References: <20190520063534.GB19312@shao2-debian> <20190520215328.GA1186@cmpxchg.org>
 <20190521134646.GE19312@shao2-debian> <20190521151647.GB2870@cmpxchg.org> <CALvZod5KFJvfBfTZKWiDo_ux_OkLKK-b6sWtnYeFCY2ARiiKwQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F2jMeMvfMZ6+f8aMiqek9ZN+qjHWyjCaTe5iI/rDq+E=;
        b=F1ETGdXeFfCBHmdWbLBHd8vZ7taVOvI6ORkmxBqkgmnSIzcWwbuL7Fhv0S2FLp97AT
         XCPInppgu1tkfwt4dcLiPmzEju6ML58hvTfKMWoxMW2Wuusd11zPUwBSNYNdyPwqwnst
         6LPs3DuCLXNIyE4Zp2se+L+KeAMs1gw7ROLd4=
In-Reply-To: <CALvZod5KFJvfBfTZKWiDo_ux_OkLKK-b6sWtnYeFCY2ARiiKwQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, kernel test robot <rong.a.chen@intel.com>, LKP <lkp@01.org>, LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <guro@fb.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>

On Tue, May 28, 2019 at 9:00 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> I was suspecting the following for-loop+atomic-add for the regression.

If I read the kernel test robot reports correctly, Johannes' fix patch
does fix the regression (well - mostly. The original reported
regression was 26%, and with Johannes' fix patch it was 3% - so still
a slight performance regression, but not nearly as bad).

> Why the above atomic-add is the culprit?

I think the problem with that one is that it's cross-cpu statistics,
so you end up with lots of cacheline bounces on the local counts when
you have lots of load.

But yes, the recursive updates still do show a small regression,
probably because there's still some overhead from the looping up in
the hierarchy. You still get *those* cacheline bounces, but now they
are limited to the upper hierarchies that only get updated at batch
time.

Johannes? Am I reading this right?

                   Linus
