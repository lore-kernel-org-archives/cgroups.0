From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v18 00/32] per memcg lru_lock
Date: Mon, 24 Aug 2020 13:24:20 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.2008241231460.1065@eggly.anvils>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com> <20200824114204.cc796ca182db95809dd70a47@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=jZJmpxUuRgi9v+jqMkzrZxBWaBUdOYUK94hlHfWB0r0=;
        b=MR7Bq/ZQYkG+RC4+pV7gn6md1ynlBoEqj97iWI4NmkE5R4tB+vonwjD3hBXKNY5NXi
         s6RgBUQ6GmZB9oN4eO759+P2STSWXsvR2iTFwi5em6FO1uSp9K6BrqWiBz2kHenZzz1P
         Py+yCIIKP4LDK18RFOWS5hwNf9QS/atikITGHcNt+QLbnxvvnLbqWHGkYnXujCSOVLTs
         81PlBJi5s6WGIJnJ2cHHmh6PUWyvIS66CnqqIjAVzz/+qHPYBCk5bMfIYwxbQwPJZTlO
         HeP6Hse7VzkhwJXSINHM5U3hSAJUo0uzysf4ar42eBFpZytIQnrqwxAFiM3GD2E23ZeY
         IOmA==
In-Reply-To: <20200824114204.cc796ca182db95809dd70a47-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Mon, 24 Aug 2020, Andrew Morton wrote:
> On Mon, 24 Aug 2020 20:54:33 +0800 Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:
> 
> > The new version which bases on v5.9-rc2.

Well timed and well based, thank you Alex.  Particulary helpful to me,
to include those that already went into mmotm: it's a surer foundation
to test on top of the -rc2 base.

> > the first 6 patches was picked into
> > linux-mm, and add patch 25-32 that do some further post optimization.
> 
> 32 patches, version 18.  That's quite heroic.  I'm unsure whether I
> should merge it up at this point - what do people think?

I'd love for it to go into mmotm - but not today.

Version 17 tested out well.  I've only just started testing version 18,
but I'm afraid there's been a number of "improvements" in between,
which show up as warnings (lots of VM_WARN_ON_ONCE_PAGE(!memcg) -
I think one or more of those are already in mmotm and under discussion
on the list, but I haven't read through yet, and I may have caught
more cases to examine; a per-cpu warning from munlock_vma_page();
something else flitted by at reboot time before I could read it).
No crashes so far, but I haven't got very far with it yet.

I'll report back later in the week.

Andrew demurred on version 17 for lack of review.  Alexander Duyck has
been doing a lot on that front since then.  I have intended to do so,
but it's a mirage that moves away from me as I move towards it: I have
some time in the coming weeks to get back to that, but it would help
me if the series is held more static by being in mmotm - we may need
fixes, but improvements are liable to get in the way of finalizing.

I still find the reliance on TestClearPageLRU, rather than lru_lock,
hard to wrap my head around: but for so long as it's working correctly,
please take that as a problem with my head (and something we can
certainly change later if necessary, by re-adding the use of lru_lock
in certain places (or by fitting me with a new head)).

> 
> > 
> > Following Daniel Jordan's suggestion, I have run 208 'dd' with on 104
> > containers on a 2s * 26cores * HT box with a modefied case:
> > https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git/tree/case-lru-file-readtwice
> > With this patchset, the readtwice performance increased about 80%
> > in concurrent containers.
> 
> That's rather a slight amount of performance testing for a huge
> performance patchset!

Indeed.  And I see that clause about readtwice performance increased 80%
going back eight months to v6: a lot of fundamental bugs have been fixed
in it since then, so I do think it needs refreshing.  It could be faster
now: v16 or v17 fixed the last bug I knew of, which had been slowing
down reclaim considerably.

When I last timed my repetitive swapping loads (not loads anyone sensible
would be running with), across only two memcgs, Alex's patchset was
slightly faster than without: it really did make a difference.  But
I tend to think that for all patchsets, there exists at least one
test that shows it faster, and another that shows it slower.

> Is more detailed testing planned?

Not by me, performance testing is not something I trust myself with,
just get lost in the numbers: Alex, this is what we hoped for months
ago, please make a more convincing case, I hope Daniel and others
can make more suggestions.  But my own evidence suggests it's good.

Hugh
