From: Neha Agarwal <nehaagarwal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] mm, thp: make deferred_split_shrinker memcg-aware
Date: Fri, 20 Oct 2017 09:47:38 -0700
Message-ID: <CAEvLuNbH0azyfSydbu3yNZ-_xY-G_5YrDDneCwcFbv+NgYd10w@mail.gmail.com>
References: <20171019200323.42491-1-nehaagarwal@google.com> <20171020071250.ftqn2d356yekkp5k@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=OXjs/TlJrQ03p5OuMN5pzqKNTubNwwGrcjPXfzBhxgY=;
        b=urB94GkuTSmTccJ3zZdPST7JX9NjdltS1XVclQdyZZK0ykRnT/UkB/FU3MrMS9E52R
         BgYsSvKEQQNWpt0QBovVpNsirwVAGIl6GQdcXcfW0gyJrXH5tnv+1FcYo1HluQJgWYV7
         OGLJWdxUbalccC8THu7Q1KKfFtxQ3e2bvAYKjZ34wzqahhHeC9Tn+fUfJSsXy298n3DS
         W1X795DVI9F4N/n+iLf4J//jDQLjqZiLGWKBdlzbBJ/oD8jvHnuyelWkRSeVWyG9BAcn
         1RGcBbvUE8Nyu65bQ5Qg9qNTRIAvSog6YXHKTHn2cVqU5f5GImEFmlvCSJJsh/PKetX4
         8png==
In-Reply-To: <20171020071250.ftqn2d356yekkp5k-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Kemi Wang <kemi.wang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Shaohua Li <shli-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

[Sorry for multiple emails, it wasn't in plain text before, thus resending.]

On Fri, Oct 20, 2017 at 12:12 AM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Thu 19-10-17 13:03:23, Neha Agarwal wrote:
>> deferred_split_shrinker is NUMA aware. Making it memcg-aware if
>> CONFIG_MEMCG is enabled to prevent shrinking memory of memcg(s) that are
>> not under memory pressure. This change isolates memory pressure across
>> memcgs from deferred_split_shrinker perspective, by not prematurely
>> splitting huge pages for the memcg that is not under memory pressure.
>
> Why do we need this? THP pages are usually not shared between memcgs. Or
> do you have a real world example where this is not the case? Your patch
> is adding quite a lot of (and to be really honest very ugly) code so
> there better should be a _very_ good reason to justify it. I haven't
> looked very closely to the code, at least all those ifdefs in the code
> are too ugly to live.
> --
> Michal Hocko
> SUSE Labs

Hi Michal,

Let me try to pitch the motivation first:
In the case of NUMA-aware shrinker, memory pressure may lead to
splitting and freeing subpages within a THP, irrespective of whether
the page belongs to the memcg that is under memory pressure. THP
sharing between memcgs is not a pre-condition for above to happen.

Let's consider two memcgs: memcg-A and memcg-B. Say memcg-A is under
memory pressure that is hitting its limit. If this memory pressure
invokes the shrinker (non-memcg-aware) and splits pages from memcg-B
queued for deferred splits, then that won't reduce memcg-A's usage. It
will reduce memcg-B's usage. Also, why should memcg-A's memory
pressure reduce memcg-B's usage.

By making this shrinker memcg-aware, we can invoke respective memcg
shrinkers to handle the memory pressure. Furthermore, with this
approach we can isolate the THPs of other memcg(s) (not under memory
pressure) from premature splits. Isolation aids in reducing
performance impact when we have several memcgs on the same machine.

Regarding ifdef ugliness: I get your point and agree with you on that.
I think I can do a better job at restricting the ugliness, will post
another version.

-- 
Thanks,
Neha Agarwal
