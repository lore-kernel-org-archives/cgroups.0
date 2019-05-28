From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: memcontrol: don't batch updates of local VM stats
 and events
Date: Tue, 28 May 2019 16:32:18 -0400
Message-ID: <20190528203218.GA20452@cmpxchg.org>
References: <20190520063534.GB19312@shao2-debian>
 <20190520215328.GA1186@cmpxchg.org>
 <20190521134646.GE19312@shao2-debian>
 <20190521151647.GB2870@cmpxchg.org>
 <CALvZod5KFJvfBfTZKWiDo_ux_OkLKK-b6sWtnYeFCY2ARiiKwQ@mail.gmail.com>
 <CAHk-=wgaLQjZ8AZj76_cwvk_wLPJjr+Dc=Qvac_vHY2RruuBww@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6BVjplRJjVAtzerMfL/A1WtErQukGLzsV7QIdL5tHLg=;
        b=jALHoOYbd78sWqXXZgYaR8eLxuPF63IYkarb8Baf2n7TaE6XnnepYOIMqCLibAQqG/
         0ZJcwCe35su/Un1bvTKr+H9yfbCkChIWYtLnHoLbFPQ+U51SOhGPOu4PDiNGWKDyuQHL
         0/Bh3Wz253mmN/utA/8DiIGX5r6qBJPfGgk2oct7Uvpyn5Aq64Mj1G8+uxa7XdNfHW+L
         8fhCvz7JKJm3Xx8NvpGLGFD4eU7BVn/g6ehW/Z+dcsnVXOV+p0CbvsIyL5hTi4cc4/M+
         4pbItZvCXZDDcetGaQGkGh6Bfg4tzcbzzSbFPSqysI8fYYPgfmUXhZy7tlj2NzsFGGpx
         tXyw==
Content-Disposition: inline
In-Reply-To: <CAHk-=wgaLQjZ8AZj76_cwvk_wLPJjr+Dc=Qvac_vHY2RruuBww@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, kernel test robot <rong.a.chen@intel.com>, LKP <lkp@01.org>, LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <guro@fb.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>

On Tue, May 28, 2019 at 10:37:15AM -0700, Linus Torvalds wrote:
> On Tue, May 28, 2019 at 9:00 AM Shakeel Butt <shakeelb@google.com> wrote:
> >
> > I was suspecting the following for-loop+atomic-add for the regression.
> 
> If I read the kernel test robot reports correctly, Johannes' fix patch
> does fix the regression (well - mostly. The original reported
> regression was 26%, and with Johannes' fix patch it was 3% - so still
> a slight performance regression, but not nearly as bad).
> 
> > Why the above atomic-add is the culprit?
> 
> I think the problem with that one is that it's cross-cpu statistics,
> so you end up with lots of cacheline bounces on the local counts when
> you have lots of load.

In this case, that's true for both of them. The workload runs at the
root cgroup level, so per definition the local and the recursive
counters at that level are identical and written to at the same
rate. Adding the new counter obviously caused the regression, but
they're contributing equally to the cost, and we could
remove/per-cpuify either of them for the fix.

So why did I unshare the old counter instead of the new one? Well, the
old counter *used* to be unshared for the longest time, and was only
made into a shared one to make recursive aggregation cheaper - before
there was a dedicated recursive counter. But now that we have that
recursive counter, there isn't much reason to keep the local counter
shared and bounce it around on updates.

Essentially, this fix-up is a revert of a983b5ebee57 ("mm: memcontrol:
fix excessive complexity in memory.stat reporting") since the problem
described in that patch is now solved from the other end.

> But yes, the recursive updates still do show a small regression,
> probably because there's still some overhead from the looping up in
> the hierarchy. You still get *those* cacheline bounces, but now they
> are limited to the upper hierarchies that only get updated at batch
> time.

Right, I reduce the *shared* data back to how it was before the patch,
but it still adds a second (per-cpu) counter that needs to get bumped,
and the loop adds a branch as well.

But while I would expect that to show up in a case like will-it-scale,
I'd be surprised if the remaining difference would be noticeable for
real workloads that actually work with the memory they allocate.
