From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH] memcg: provide reclaim stats via 'memory.reclaim'
Date: Tue, 24 May 2022 12:01:01 -0700
Message-ID: <CAJD7tkZxvmnrrjc4yAe5mC+SL-MZqMkn21yjetiLYyq0B=AhtA@mail.gmail.com>
References: <20220518223815.809858-1-vaibhav@linux.ibm.com>
 <YoYj4sLJfGke5IGT@dhcp22.suse.cz> <87zgjcg4xs.fsf@vajain21.in.ibm.com>
 <YodDaFVeU33bu7yQ@dhcp22.suse.cz> <CAJD7tkYwv2LDZeV2F5pxuniw7LCNjBapDCm3WuRhzwTH-jN3PA@mail.gmail.com>
 <YozFZI2euSjWPgDb@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zPoBKVvC2etY1rrj+YwE9RcWhQO3Aeb8jFG7VSlxgGE=;
        b=eShZOTIUQ93TOWjEzr249Q2WlZgXfVBXRXVkiPqqzxHc3weu9dWI5q3Ho56xWalhYm
         DNCo2rp9rMlgNBrK8z0XY/wW3LtOYML1vS+M+JPqvzdBIyhIp4u0EN07gBXsnOV6nri8
         362c3np7lTLklsZKcOFMwfRRupNLAPynTYIAwR6xjCdZj/A/gIhF1Qfk1QwtUz1zpdDg
         OwP1XDrZlsnRRXavqft/ReWGqQnEA11Wn1yavd6amKib47Nc170P/orJbWp9qtErNk/7
         CisGNh6vWRjQoZRymrDq8S4Qa8rADzUXLl566tiu679wuf5A6NCGy//TjeVsXiZq3cdx
         FakQ==
In-Reply-To: <YozFZI2euSjWPgDb@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>, Vaibhav Jain <vaibhav@linux.ibm.com>, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Shakeel Butt <shakeelb@google.com>, David Rientjes <rientjes@google.com>

On Tue, May 24, 2022 at 4:45 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Mon, May 23, 2022 at 03:50:34PM -0700, Yosry Ahmed wrote:
> > I think it might be useful to have a dedicated entry in memory.stat
> > for proactively reclaimed memory. A case where this would be useful is
> > tuning and evaluating userspace proactive reclaimers. For instance, if
> > a userspace agent is asking the kernel to reclaim 100M, but it could
> > only reclaim 10M, then most probably the proactive reclaimer is not
> > using a good methodology to figure out how much memory do we need to
> > reclaim.
> >
> > IMO this is more useful, and a superset of just reading the last
> > reclaim request status through memory.reclaim (read stat before and
> > after).
>
> +1

It might also be useful to have a breakdown of this by memory type:
file, anon, or shrinkers.

It would also fit in nicely with a potential type=file/anon/shrinker
argument to memory.reclaim. Thoughts on this?
