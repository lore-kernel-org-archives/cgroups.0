From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 1/3] mm: memcg: fix stale protection of reclaim target memcg
Date: Fri, 2 Dec 2022 16:56:36 -0800
Message-ID: <CAJD7tkZdq2n29P+nbiONzDrvZy0eRpCQfvVVX1A2SMYdV6TVZw@mail.gmail.com>
References: <20221202031512.1365483-1-yosryahmed@google.com>
 <20221202031512.1365483-2-yosryahmed@google.com> <CAJD7tkZouk+r=Qk554AOk1-3eYy-gTC8KC+OJQY13ZkNZ9Qe+Q@mail.gmail.com>
 <20221202163527.a72646c9d42f3678b20dac7b@linux-foundation.org>
 <CAJD7tkapGALWoqrs+cbE8i1w4eDcdj=naHxqybPu6NLAnCZ0iQ@mail.gmail.com> <20221202165027.8d0761724f30f6701a9a5da0@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DPjZ7mvL7nYnQckkbN4QRAK9DHc9/tMCEO18HbgrivA=;
        b=TLQIPa6gXHX7UTknaOw9/ETbs+uVF1fmEX74fdi9pMYVGiGbTNTYzeRZWh3UVan/A5
         pgdygh7OpAFfNfU10yhfPrHmD1RPbAHkH571Ih/cObNYEwvWz4MfiIzl3RIhPhuVNRWn
         Akv7MU3BSaPnJoowJnA5vNdzOyYKKugnxnxmH++c0xFDIis6hURGi68K3zljnG2ylZS2
         FpBG1mEk6kbCq1bqwDv1XZDHvseqr0RdUee1wWlmpFiSR0CfuZ1k9HkOB/9rHqQmY9Lc
         RKtzIiGlEPW68kLDLYfyiP0IcEdtwHWB7Ge9weEkCT2wr5yOO/MMZCSk+P+6nhIz7DzI
         vA+w==
In-Reply-To: <20221202165027.8d0761724f30f6701a9a5da0-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri, Dec 2, 2022 at 4:50 PM Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>
> On Fri, 2 Dec 2022 16:38:12 -0800 Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> > On Fri, Dec 2, 2022 at 4:35 PM Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> > >
> > > On Fri, 2 Dec 2022 16:26:05 -0800 Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > >
> > > > Andrew, does this need to be picked up by stable branches?
> > >
> > > Does it?  The changelog doesn't have a clear description of the
> > > user-visible effects of the flaw, which is the guiding light for a
> > > backport?
> > >
> > >
> >
> > There are 2 example scenarios in the changelog that misbehave without
> > this fix, cases where the protection of a memcg that is the target of
> > reclaim is not ignored as it should be.
>
> Yes.  I found them quite unclear.  How would someone who is
> experiencing a particualr runtime issue be able to recognize whether
> this patch might address that issue?
>

When we are doing memcg reclaim, the intended behavior is that we
ignore any protection (memory.min, memory.low) of the target memcg
(but not its children). Ever since the patch pointed to by the "Fixes"
tag, we actually read a stale value for the target memcg protection
when deciding whether to skip the memcg or not because it is
protected. If the stale value happens to be high enough, we don't
reclaim from the target memcg.

Essentially, in some cases we may falsely skip reclaiming from the
target memcg of reclaim because we read a stale protection value from
last time we reclaimed from it.
