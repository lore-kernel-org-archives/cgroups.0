From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 1/3] mm: page_counter: remove unneeded atomic ops for low/min
Date: Mon, 22 Aug 2022 07:55:58 -0700
Message-ID: <CALvZod720nwfP68OM2QtyyWJpOV5aO8xF6iuN0U2hpX9Pzj8PA@mail.gmail.com>
References: <20220822001737.4120417-1-shakeelb@google.com> <20220822001737.4120417-2-shakeelb@google.com>
 <YwNSlZFPMgclrSCz@dhcp22.suse.cz> <YwNX+vq9svMynVgW@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Q7WYgfj+D74q3tCpU5JrwR7f8DS8YPdEHB5QL4Zw+3E=;
        b=jjZM2OFr/3FVWHbl+N6HxUndM4ZQsTxjvR0U5CsuexneKgVxqdV1bXLtaFMj4Z0OGG
         3rbrlz78/uOXN4/dBpeueMFz7QDTr89EvKklVfCjuU38Xe6odVZy5ZIZfFogK2w9Kz08
         O2Xg6uOeH2cAeEZ7kHIG3YkhVp1G7ltowW0IQOo8qvWCACurSPdYzcOV5ebirHsqU4fv
         BrKhmOCSgPClIiIzFGj5oOJ2erOyckssP0wY1islBfgBntr7B/hpZWVE5+nTof6D/jks
         FYtLJt7EkaEUp/kmK6o9V8yjRSu6idnj6Btq68OCK3Qjp59HUWfIapwm0yH6RRbPlx4F
         UBMA==
In-Reply-To: <YwNX+vq9svMynVgW@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <songmuchun@bytedance.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Eric Dumazet <edumazet@google.com>, Soheil Hassas Yeganeh <soheil@google.com>, Feng Tang <feng.tang@intel.com>, Oliver Sang <oliver.sang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, lkp@lists.01.org, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Mon, Aug 22, 2022 at 3:18 AM Michal Hocko <mhocko@suse.com> wrote:
>
> On Mon 22-08-22 11:55:33, Michal Hocko wrote:
> > On Mon 22-08-22 00:17:35, Shakeel Butt wrote:
> [...]
> > > diff --git a/mm/page_counter.c b/mm/page_counter.c
> > > index eb156ff5d603..47711aa28161 100644
> > > --- a/mm/page_counter.c
> > > +++ b/mm/page_counter.c
> > > @@ -17,24 +17,23 @@ static void propagate_protected_usage(struct page_counter *c,
> > >                                   unsigned long usage)
> > >  {
> > >     unsigned long protected, old_protected;
> > > -   unsigned long low, min;
> > >     long delta;
> > >
> > >     if (!c->parent)
> > >             return;
> > >
> > > -   min = READ_ONCE(c->min);
> > > -   if (min || atomic_long_read(&c->min_usage)) {
> > > -           protected = min(usage, min);
> > > +   protected = min(usage, READ_ONCE(c->min));
> > > +   old_protected = atomic_long_read(&c->min_usage);
> > > +   if (protected != old_protected) {
> >
> > I have to cache that code back into brain. It is really subtle thing and
> > it is not really obvious why this is still correct. I will think about
> > that some more but the changelog could help with that a lot.
>
> OK, so the this patch will be most useful when the min > 0 && min <
> usage because then the protection doesn't really change since the last
> call. In other words when the usage grows above the protection and your
> workload benefits from this change because that happens a lot as only a
> part of the workload is protected. Correct?

Yes, that is correct. I hope the experiment setup is clear now.

>
> Unless I have missed anything this shouldn't break the correctness but I
> still have to think about the proportional distribution of the
> protection because that adds to the complexity here.

The patch is not changing any semantics. It is just removing an
unnecessary atomic xchg() for a specific scenario (min > 0 && min <
usage). I don't think there will be any change related to proportional
distribution of the protection.
