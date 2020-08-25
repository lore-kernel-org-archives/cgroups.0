From: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v18 00/32] per memcg lru_lock
Date: Mon, 24 Aug 2020 21:56:27 -0400
Message-ID: <20200825015627.3c3pnwauqznnp3gc@ca-dmjordan1.us.oracle.com>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
 <20200824114204.cc796ca182db95809dd70a47@linux-foundation.org>
 <alpine.LSU.2.11.2008241231460.1065@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=LY6QXv+QQJLtDU1fswIE+NA2N2Om8CrOP23/sePbiW8=;
 b=OwaW/7vjdlu4dZ2+5+N3MgPoSuzJUxwXHWtbSOxWsbYuaWRd8Ln2Ody6DRZV6e2Ni31r
 2UMtKxyKirqtXL3TooNaAIVz4wgGcIXNcutvALRVEoFq0RQ6maIyOzvGdvM4O4PR2Nk8
 4qNHXEGT/qhmZajoaUOQ+bXYpUjTGuxmnmHyg6x1zFrV5xYCqpRm8oD+A8rWfCft7CAQ
 ucipuE5IUKM+vFQSC320Adm9gKKm8E6G/DT+61vRnGp5qG6LOsMJKl1WdDn5wGKtRUKN
 SMNf23y35k8D4MP3PeERkJ/B9qZoZSMuvdGs3jQPAqDehH+gzFH2yFH9rVXtQAGq8ZaR Gw== 
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.2008241231460.1065-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Mon, Aug 24, 2020 at 01:24:20PM -0700, Hugh Dickins wrote:
> On Mon, 24 Aug 2020, Andrew Morton wrote:
> > On Mon, 24 Aug 2020 20:54:33 +0800 Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:
> Andrew demurred on version 17 for lack of review.  Alexander Duyck has
> been doing a lot on that front since then.  I have intended to do so,
> but it's a mirage that moves away from me as I move towards it: I have

Same, I haven't been able to keep up with the versions or the recent review
feedback.  I got through about half of v17 last week and hope to have more time
for the rest this week and beyond.

> > > Following Daniel Jordan's suggestion, I have run 208 'dd' with on 104
> > > containers on a 2s * 26cores * HT box with a modefied case:

Alex, do you have a pointer to the modified readtwice case?

Even better would be a description of the problem you're having in production
with lru_lock.  We might be able to create at least a simulation of it to show
what the expected improvement of your real workload is.

> > > https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git/tree/case-lru-file-readtwice
> > > With this patchset, the readtwice performance increased about 80%
> > > in concurrent containers.
> > 
> > That's rather a slight amount of performance testing for a huge
> > performance patchset!
> 
> Indeed.  And I see that clause about readtwice performance increased 80%
> going back eight months to v6: a lot of fundamental bugs have been fixed
> in it since then, so I do think it needs refreshing.  It could be faster
> now: v16 or v17 fixed the last bug I knew of, which had been slowing
> down reclaim considerably.
> 
> When I last timed my repetitive swapping loads (not loads anyone sensible
> would be running with), across only two memcgs, Alex's patchset was
> slightly faster than without: it really did make a difference.  But
> I tend to think that for all patchsets, there exists at least one
> test that shows it faster, and another that shows it slower.
> 
> > Is more detailed testing planned?
> 
> Not by me, performance testing is not something I trust myself with,
> just get lost in the numbers: Alex, this is what we hoped for months
> ago, please make a more convincing case, I hope Daniel and others
> can make more suggestions.  But my own evidence suggests it's good.

I ran a few benchmarks on v17 last week (sysbench oltp readonly, kerndevel from
mmtests, a memcg-ized version of the readtwice case I cooked up) and then today
discovered there's a chance I wasn't running the right kernels, so I'm redoing
them on v18.  Plan to look into what other, more "macro" tests would be
sensitive to these changes.
