From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH mm] vmalloc: back off when the current task is
 OOM-killed
Date: Sun, 19 Sep 2021 16:31:26 -0700
Message-ID: <20210919163126.431674722b8db218453dc18c@linux-foundation.org>
References: <YT8PEBbYZhLixEJD@dhcp22.suse.cz>
        <d07a5540-3e07-44ba-1e59-067500f024d9@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632094288;
        bh=zyJGiIuWE5OLgrUwe9tcbx/tG63SoIirkujQLHeuHsk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ueCIGMa2UqDW7NZYr2xH1V1f2uLeYgpzucwCUQsgrMzW1PofIQ59as8TZpWnli+P9
         EUKAVZXzAPzg4ZiWrxiQio7O2cU+4X6QoXL6rhQZrPG/m1WGOposi9Gb1c6ei6SMNY
         QyzFxQUkv59B/4V5H9uH6lYE0kxYf0t55rngF3Sg=
In-Reply-To: <d07a5540-3e07-44ba-1e59-067500f024d9-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, "Uladzislau Rezki (Sony)" <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Fri, 17 Sep 2021 11:06:49 +0300 Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:

> Huge vmalloc allocation on heavy loaded node can lead to a global
> memory shortage. A task called vmalloc can have the worst badness
> and be chosen by OOM-killer, however received fatal signal and
> oom victim mark does not interrupt allocation cycle. Vmalloc will
> continue allocating pages over and over again, exacerbating the crisis
> and consuming the memory freed up by another killed tasks.
> 
> This patch allows OOM-killer to break vmalloc cycle, makes OOM more
> effective and avoid host panic.
> 
> Unfortunately it is not 100% safe. Previous attempt to break vmalloc
> cycle was reverted by commit b8c8a338f75e ("Revert "vmalloc: back off when
> the current task is killed"") due to some vmalloc callers did not handled
> failures properly. Found issues was resolved, however, there may
> be other similar places.

Well that was lame of us.

I believe that at least one of the kernel testbots can utilize fault
injection.  If we were to wire up vmalloc (as we have done with slab
and pagealloc) then this will help to locate such buggy vmalloc callers.

> Such failures may be acceptable for emergencies, such as OOM. On the other
> hand, we would like to detect them earlier. However they are quite rare,
> and will be hidden by OOM messages, so I'm afraid they wikk have quite
> small chance of being noticed and reported.
> 
> To improve the detection of such places this patch also interrupts the vmalloc
> allocation cycle for all fatal signals. The checks are hidden under DEBUG_VM
> config option to do not break unaware production kernels.

This sounds like a pretty sad half-measure?

