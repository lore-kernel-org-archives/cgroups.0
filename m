From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH] memcg: provide reclaim stats via 'memory.reclaim'
Date: Wed, 25 May 2022 13:31:42 -0700
Message-ID: <CAJD7tkb7DRK_9wtiSFPiV6zsZGYYxs_JGECODtP+pta4k4MaiA@mail.gmail.com>
References: <20220518223815.809858-1-vaibhav@linux.ibm.com>
 <YoYj4sLJfGke5IGT@dhcp22.suse.cz> <87zgjcg4xs.fsf@vajain21.in.ibm.com>
 <YodDaFVeU33bu7yQ@dhcp22.suse.cz> <CAJD7tkYwv2LDZeV2F5pxuniw7LCNjBapDCm3WuRhzwTH-jN3PA@mail.gmail.com>
 <YozFZI2euSjWPgDb@cmpxchg.org> <CAJD7tkZxvmnrrjc4yAe5mC+SL-MZqMkn21yjetiLYyq0B=AhtA@mail.gmail.com>
 <Yo3v5k8UBNHF6QRi@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A0dEd4NUNMrTRFFSR3+OfkYzmb9W3Zxpow0f09EOgls=;
        b=s5IkQauZnOLISvCoz7A9uhGFFCaH1f6gh+yufCmj+HN/vMS6luKtssU9qd7rvuHP09
         HhINtg7TpvcOmZm1ouHcVkjKk6zEEeNeWY6nO4yudTi3fchpTd2jAQqb7M+Nqsts4Yl7
         iU8Hbk1kY75EEpSOU6r93DqrrMnxdh+0P0FaPzPHtty0hvs+DnUoYHaN0FJ8JZvzSoqy
         3Q8c8fxts4s9EzUn+2U1k5GK3ykGZ9PNN1dkeb+A9fBG9SRLbEsFSjaOXJdyhkQ5EpFr
         5OFDAMcBoiBF7XQQZ+WFPEM44Gcr2BZC20P7JgeRPoHbwD64VcWUoQXv3RdTO+wXTsYy
         iKYA==
In-Reply-To: <Yo3v5k8UBNHF6QRi@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vaibhav Jain <vaibhav@linux.ibm.com>, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Shakeel Butt <shakeelb@google.com>, David Rientjes <rientjes@google.com>

On Wed, May 25, 2022 at 1:59 AM Michal Hocko <mhocko@suse.com> wrote:
>
> On Tue 24-05-22 12:01:01, Yosry Ahmed wrote:
> > On Tue, May 24, 2022 at 4:45 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > >
> > > On Mon, May 23, 2022 at 03:50:34PM -0700, Yosry Ahmed wrote:
> > > > I think it might be useful to have a dedicated entry in memory.stat
> > > > for proactively reclaimed memory. A case where this would be useful is
> > > > tuning and evaluating userspace proactive reclaimers. For instance, if
> > > > a userspace agent is asking the kernel to reclaim 100M, but it could
> > > > only reclaim 10M, then most probably the proactive reclaimer is not
> > > > using a good methodology to figure out how much memory do we need to
> > > > reclaim.
> > > >
> > > > IMO this is more useful, and a superset of just reading the last
> > > > reclaim request status through memory.reclaim (read stat before and
> > > > after).
> > >
> > > +1
> >
> > It might also be useful to have a breakdown of this by memory type:
> > file, anon, or shrinkers.
> >
> > It would also fit in nicely with a potential type=file/anon/shrinker
> > argument to memory.reclaim. Thoughts on this?
>
> Can we start simple and see what real usecases actually will need?

Agreed. Let's start with a single proactively reclaimed memory stat
and then add subcategories if/when needed.

> --
> Michal Hocko
> SUSE Labs
