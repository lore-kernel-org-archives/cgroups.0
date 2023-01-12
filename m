From: Yuanchu Xie <yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/2] mm: multi-gen LRU: working set extensions
Date: Wed, 11 Jan 2023 17:50:02 -0800
Message-ID: <CAJj2-QFg_7msfB+k2hv2jx13HCJ_-EBhqbuHwLjOVUhZvTN38w@mail.gmail.com>
References: <20221214225123.2770216-1-yuanchu@google.com> <87k01ulxdd.fsf@linux.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UI4K5mRi88yph1Y15SVIzngc8V0hAChiN1WwnseNjSo=;
        b=iX6gRZV8sICaehqfIKKCsTSZN1Qto1VW/o+R0dPGvkB24JZnDkCpMXaGC1UFCMCDAc
         65kuNToXIj4iXR4wXhLwWIDCeYuJgxjaQ/q+do9MI07FludH6aZA3vLr/9IkjsITho1/
         ZgBV3Si+v22hTmbdtckw6PN7PpNig1Dew2+7PUya3A5kMFGyHhvVHfD+DbOlVm71omPW
         1SwwzDe4Gs6f0NzLBZ+IIXwOGRD9kSi2XJe8Qd8ijsWWpakPWge0tVjudFgQAW3GGS2R
         cIJHdBLnBJ4GCsGFjMH/J/n5H+PMYqXtd3GCNGPPiJ91I14Hcy8XzkCIj2evn8CIcQit
         LY4g==
In-Reply-To: <87k01ulxdd.fsf-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jan 9, 2023 at 10:25 PM Aneesh Kumar K.V
<aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org> wrote:
>
> Yuanchu Xie <yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:
>
> > Introduce a way of monitoring the working set of a workload, per page
> > type and per NUMA node, with granularity in minutes. It has page-level
> > granularity and minimal memory overhead by building on the
> > Multi-generational LRU framework, which already has most of the
> > infrastructure and is just missing a useful interface.
> >
> > MGLRU organizes pages in generations, where an older generation contains
> > colder pages, and aging promotes the recently used pages into the young
> > generation and creates a new one. The working set size is how much
> > memory an application needs to keep working, the amount of "hot" memory
> > that's frequently used. The only missing pieces between MGLRU
> > generations and working set estimation are a consistent aging cadence
> > and an interface; we introduce the two additions.
>
> So with kold kthread do we need aging in reclaim ? Should we switch reciam
> to wakeup up kold kthread to do aging instead of doing try_to_inc_max_seq?
> This would also help us to try different aging mechanism which can run
> better in a kthread.
If I understand correctly, MGLRU tries to put off aging as much as
possible for reclaim, and prefers aging uniformly in kswapd, so that
already sort of happens. With periodic aging on, reclaim only triggers
aging when it reclaims memory less than (MIN_NR_GENS * aging_interval)
cold.
