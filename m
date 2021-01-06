From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v21 00/19] per memcg lru lock
Date: Tue, 5 Jan 2021 19:10:01 -0800 (PST)
Message-ID: <alpine.LSU.2.11.2101051834450.1361@eggly.anvils>
References: <1604566549-62481-1-git-send-email-alex.shi@linux.alibaba.com> <aebcdd933df3abad378aeafc1a07dfe9bbb25548.camel@redhat.com> <CALvZod448Ebw7YE-HVCNXNSbtvTcTvQx+_EqcyxTVd_SZ4ATBA@mail.gmail.com> <49be27f2652d4658f80c95bea171142c35513761.camel@redhat.com>
 <alpine.LSU.2.11.2101051326410.6519@eggly.anvils> <f127c35a34a391d20b05c53c17adeb72464b28ee.camel@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=W/PpEKlUbN28jcfj5YrFvkIXjBCbIDL7mYlBH/tOtfs=;
        b=bmoh1VQZHSZjSrOM6u1ba6MIirJY9CfW1kYiAp9WYOf/riWyAnLCEGxk/5FH3HjjpE
         pYap8ubcX3zHFbkOERTsYBbzxYK7rH+ZsL88OuIAwJl2BWR2FyddP6Eb6+k8KfDnrLGd
         2fjyOIK+OXv5qRpdFTIJOC+SSSk6qdmSazk/6zHuESaSbyhyLWM8Nmn2MX5G/LkSdZu0
         i8d8eXZ+UG+wCxiHc4J8coLbNuOHX6k7dBvxkeTf2WdxrmLjb41ACPKpYp6SFcie82FK
         gLUHYI2dBDx0VRGINwGa1rxqAreOsOVQKJZmp2Eri5C1uU0UzFHGtSLXJwDBUD30L+lV
         nTfw==
In-Reply-To: <f127c35a34a391d20b05c53c17adeb72464b28ee.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qian Cai <qcai-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel test robot <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko@sus>

On Tue, 5 Jan 2021, Qian Cai wrote:
> On Tue, 2021-01-05 at 13:35 -0800, Hugh Dickins wrote:
> > This patchset went into mmotm 2020-11-16-16-23, so probably linux-next
> > on 2020-11-17: you'll have had three trouble-free weeks testing with it
> > in, so it's not a likely suspect.  I haven't looked yet at your report,
> > to think of a more likely suspect: will do.
> 
> Probably my memory was bad then. Unfortunately, I had 2 weeks holidays before
> the Thanksgiving as well. I have tried a few times so far and only been able to
> reproduce once. Looks nasty...

I have not found a likely suspect.

What it smells like is a defect in cloning anon_vma during fork,
such that mappings of the THP can get added even after all that
could be found were unmapped (tree lookup ordering should prevent
that).  But I've not seen any recent change there.

It would be very easily fixed by deleting the whole BUG() block,
which is only there as a sanity check for developers: but we would
not want to delete it without understanding why it has gone wrong
(and would also have to reconsider two related VM_BUG_ON_PAGEs).

It is possible that b6769834aac1 ("mm/thp: narrow lru locking") of this
patchset has changed the timing and made a pre-existing bug more likely
in some situations: it used to hold an lru_lock before that BUG() on
total_mapcount(), and now does not; but that's not a lock which should
be relevant to the check.

When you get more info (or not), please repost the bugstack in a
new email thread: this thread is not really useful for pursuing it.

Hugh
