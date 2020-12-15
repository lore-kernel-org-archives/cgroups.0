From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v21 00/19] per memcg lru lock
Date: Mon, 14 Dec 2020 18:16:34 -0800 (PST)
Message-ID: <alpine.LSU.2.11.2012141734060.3082@eggly.anvils>
References: <1604566549-62481-1-git-send-email-alex.shi@linux.alibaba.com> <20201214164712.39da20f908c6199eb4cde961@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=barWCp514FjI25PzXmxIiJLF9ZYJy6zAnVMGHuNnvjw=;
        b=eSfw5tE5a2wyn/jRdln7YAqK4uoJDzhoOSSzqwQ5qxbNTUu8xMlWjaXC7G3TEn4e8r
         uLpGMcOzcVFpNK3nmRELzDuOc45uXP0skLftpKCCwBENsio2lWi5P1Wgq7ikEROkQpWQ
         3YbtThWQJ1IxnwaeruDgP25bwNonC1HTWo8kTUjSaF3Unc485ytQGNh3h82CaFGMHANU
         piMpvmtCW6oI0m9ysD4F2cWp1l3oXEFVwPlJ5D51AG1RA1eI2Wj8xrRzZLFicod9+PFm
         M/E9NqaLWYBojoQRlPJp6aAUV7d0J/UeDq0xB0AEniFLbz2HOFIn8J8CK/R7uHSboKd1
         BqSA==
In-Reply-To: <20201214164712.39da20f908c6199eb4cde961-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Mon, 14 Dec 2020, Andrew Morton wrote:
> On Thu,  5 Nov 2020 16:55:30 +0800 Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:
> 
> > This version rebase on next/master 20201104, with much of Johannes's
> > Acks and some changes according to Johannes comments. And add a new patch
> > v21-0006-mm-rmap-stop-store-reordering-issue-on-page-mapp.patch to support
> > v21-0007.
> 
> I assume the consensus on this series is 'not yet"?

Speaking for my part in the consensus: I don't share that assumption,
the series by now is well-baked and well reviewed by enough people over
more than enough versions, has been completely untroublesome since it
entered mmotm/linux-next a month ago, not even any performance bleats
from 0day, and has nothing to gain from any further delay.

I think it was my fault that v20 didn't get into 5.10: I'd said "not yet"
when you first tried a part of v19 or earlier in mmotm, and by the time
I'd completed review it was too late in the cycle; Johannes and Vlastimil
have gone over it since then, and I'd be glad to see it go ahead into
5.11 very soon. Silence on v21 meaning that it's good.

Various of us have improvements or cleanups in mind or in private tree,
but nothing to hold back what's already there.

> 
> Also, did
> https://lkml.kernel.org/r/0000000000000340a105b49441d3-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org get
> resolved?

Alex found enough precedents for that, before inclusion of his series,
so it should not discourage from moving his series forward.  I have
ignored that syzreport until now, but will take a quick try at the
repro now, to see if I'm inspired - probably not, but we'll see.

Hugh
