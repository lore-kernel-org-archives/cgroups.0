From: Daniel Drake <drake@endlessm.com>
Subject: Re: [PATCH 0/9] psi: pressure stall information for CPU, memory, and
 IO v4
Date: Mon, 17 Sep 2018 13:22:14 +0800
Message-ID: <CAD8Lp47F5N8xN41KFHybVVTpV_TEewERD-eJov6iiqBJUyVR9g@mail.gmail.com>
References: <20180828172258.3185-1-hannes@cmpxchg.org> <20180905214303.GA30178@cmpxchg.org>
 <20180907110407.GQ24106@hirez.programming.kicks-ass.net> <20180907150955.GC11088@cmpxchg.org>
 <CAJuCfpG1=pXOg=1GwC33Uy0BcXNq-BsR6dO0JJq4Jnm5TyNENQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=WpYvUsoYgEGeP6B6ATx+yRD/LNy0fnUPx29m2jEuTH0=;
        b=ERLqbQ82XbYx90SfX4tnL/wbyHap91e5MDsXAGtg188sqPSn0VU/1QGQVJyykCCLuL
         k2S2qg8x5oU5LkUewMwlT9nZQw4IjIOPRw66rADU5GaCG+ReitZsyvVnFrcMFirUSS0r
         KjxiQc0+Qap2ZRl87QFxnWLt/xooxreN9W+4jBUQAGKl9vvHHLxEwd/9UYbK5P0aNxGz
         1Pgl+ZNVIdS0MKWT/1/x9P4Wwf3P/awtEAZhHChx+AXkhkjiNdOR1x8fCfBrXdLCbd9d
         XLO2h1PVt/Gzif01jRz1O/wwumAy5so8xJ6gLq56EA0z7u4UMT8gfEJo49/oHTaFmVAf
         8w3Q==
In-Reply-To: <CAJuCfpG1=pXOg=1GwC33Uy0BcXNq-BsR6dO0JJq4Jnm5TyNENQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Peter Enderborg <peter.enderborg@sony.com>, Shakeel Butt <shakeelb@google.com>, Mike Galbraith <efault@gmx.de>, linux-mm <linux-mm@kvack.org>, cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-team@fb.com

Hi Suren

On Fri, Sep 7, 2018 at 11:58 PM, Suren Baghdasaryan <surenb@google.com> wrote:
> Thanks for the new patchset! Backported to 4.9 and retested on ARMv8 8
> code system running Android. Signals behave as expected reacting to
> memory pressure, no jumps in "total" counters that would indicate an
> overflow/underflow issues. Nicely done!

Can you share your Linux v4.9 psi backport somewhere?

Thanks
Daniel
