From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v21 00/19] per memcg lru lock
Date: Mon, 14 Dec 2020 18:28:07 -0800
Message-ID: <20201214182807.b95df2cd4b22dba37e1f6ffa@linux-foundation.org>
References: <1604566549-62481-1-git-send-email-alex.shi@linux.alibaba.com>
        <20201214164712.39da20f908c6199eb4cde961@linux-foundation.org>
        <alpine.LSU.2.11.2012141734060.3082@eggly.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607999289;
        bh=slstsyQ5JPFm4UzsTcoHM8XYj2Zgq9w2a6Y8T3mYAqA=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=UPYRgmtHyTjcqK47L9AAX1Rfo31gdLIZ4tiG0cb061cd3YFgE/R/BgJQFQwWEmQcN
         2ae/Ek+hZrOSyjmZCZJGB9CIFxjnS7JTD+rHgd321PxMMAAnBKJfejP68jMGLuz+HJ
         t2POAUptSWQG/Uus0i74Ly4L3E6kAn9j7tnS5PKI=
In-Reply-To: <alpine.LSU.2.11.2012141734060.3082-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Mon, 14 Dec 2020 18:16:34 -0800 (PST) Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> On Mon, 14 Dec 2020, Andrew Morton wrote:
> > On Thu,  5 Nov 2020 16:55:30 +0800 Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:
> > 
> > > This version rebase on next/master 20201104, with much of Johannes's
> > > Acks and some changes according to Johannes comments. And add a new patch
> > > v21-0006-mm-rmap-stop-store-reordering-issue-on-page-mapp.patch to support
> > > v21-0007.
> > 
> > I assume the consensus on this series is 'not yet"?
> 
> Speaking for my part in the consensus: I don't share that assumption,

OK, thanks, I'll include it in patch-bomb #2, Tues or Weds.
