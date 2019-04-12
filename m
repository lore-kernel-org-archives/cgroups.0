From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 3/4] mm: memcontrol: fix recursive statistics correctness
 & scalabilty
Date: Fri, 12 Apr 2019 13:38:07 -0700
Message-ID: <CALvZod6uw0auc_j+QWC-QBEGwLemtG=uUaf2dxwgbZUkOq6=1A@mail.gmail.com>
References: <20190412151507.2769-1-hannes@cmpxchg.org> <20190412151507.2769-4-hannes@cmpxchg.org>
 <CALvZod4xu10+E41YyaamigysZAnDcdA09f5m-hGd72LeJ9VmEg@mail.gmail.com> <20190412201004.GA27187@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WOEqioenipxbzm+7k35/3dZl524W3sMRWwsLbeTAQhk=;
        b=vjhFS4fOxo2Fj0LqIMr1LXlEtE5hGVVS4kg+kni9d0nYGWqXbVHBHSHDIq6HjqHVfK
         6/CW+MALCvXA2OOeNtACh91JZ2d7/8n7Nmk05bGR15WV91PMf6W15BncEgCrcgoFF8QN
         O7fLLfSLR0wLz07gnsUNyjy0216a+mO11nLfQxSY6N6pNAJaXHen01o7PZzJF0yPz/Nk
         QVfTDGoL7y78XALI4X+1XaMzIF7naI/6arE9XqfIOC4GxkYQncqS/CBoVSnnFuCdD78D
         iMGEN3gMLjo5XKLB91tkWEP9ATedoWxAYvi1q/zTbTQZt/BqpSFRYue4qJwPLPzU1/9Y
         /jiw==
In-Reply-To: <20190412201004.GA27187@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team@fb.com, Roman Gushchin <guro@fb.com>

On Fri, Apr 12, 2019 at 1:10 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Fri, Apr 12, 2019 at 12:55:10PM -0700, Shakeel Butt wrote:
> > We also faced this exact same issue as well and had the similar solution.
> >
> > > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> >
> > Reviewed-by: Shakeel Butt <shakeelb@google.com>
>
> Thanks for the review!
>
> > (Unrelated to this patchset) I think there should also a way to get
> > the exact memcg stats. As the machines are getting bigger (more cpus
> > and larger basic page size) the accuracy of stats are getting worse.
> > Internally we have an additional interface memory.stat_exact for that.
> > However I am not sure in the upstream kernel will an additional
> > interface is better or something like /proc/sys/vm/stat_refresh which
> > sync all per-cpu stats.
>
> I was talking to Roman about this earlier as well and he mentioned it
> would be nice to have periodic flushing of the per-cpu caches. The
> global vmstat has something similar. We might be able to hook into
> those workers, but it would likely require some smarts so we don't
> walk the entire cgroup tree every couple of seconds.
>
> We haven't had any actual problems with the per-cpu fuzziness, mainly
> because the cgroups of interest also grow in size as the machines get
> bigger, and so the relative error doesn't increase.
>

Yes, this is very machine size dependent. We see this issue more often
on larger machines.

> Are your requirements that the error dissipates over time (waiting for
> a threshold convergence somewhere?) or do you have automation that
> gets decisions wrong due to the error at any given point in time?

Not sure about the first one but we do have the second case. The node
controller does make decisions in an online way based on the stats.
Also we do periodically collect and store stats for all jobs across
the fleet. This data is processed (offline) and is used in a lot of
ways. The inaccuracy in the stats do affect all that analysis
particularly for small jobs.
