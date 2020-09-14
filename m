From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm/memcg: Unify swap and memsw page counters
Date: Mon, 14 Sep 2020 08:37:21 -0700
Message-ID: <CALvZod6e3+F_YfEvTSJv015Z=BgHOMQPiYs0Kg9SMRPMHjJsFw@mail.gmail.com>
References: <20200914024452.19167-1-longman@redhat.com> <20200914024452.19167-4-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K4ao+npZ6MxTlYLJj73SuM3MYmDgRwOTBj2VBQ+8aQw=;
        b=QqiQ6xW7AdhcYi1OC2qsAevLzikaA4B2B2HmiF8E4JiJ3lndiY2zyjlmfQdljBEpsu
         wnzt39W7OkhG6hVVv0LU6qArb8GcclfoatunyFpVXrFjrN8WwKHyFrturfPeDR1N4uIg
         O7WvUBHhSaBagCz8j4SJtlrL++cp0DKMDP76VZxD69TxZFiq7XP246R/5nGrcvgM9z+M
         sr+Gh5le/CKY1RrlTeDP9/dVwTXsyll0buo08vjzthzY6ziEoCxtDPi6G88Ipvigmuu/
         ViTE32WfPr4r5OnN1bimsysiOcMNByATfPHjxJ+eTRjx5Si0EMvHdcuOTIFexSCUI8gv
         47hw==
In-Reply-To: <20200914024452.19167-4-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Sun, Sep 13, 2020 at 7:45 PM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> The swap page counter is v2 only while memsw is v1 only. As v1 and v2
> controllers cannot be active at the same time, there is no point to keep
> both swap and memsw page counters in mem_cgroup. The previous patch has
> made sure that memsw page counter is updated and accessed only when in
> v1 code paths. So it is now safe to alias the v1 memsw page counter to v2
> swap page counter. This saves 14 long's in the size of mem_cgroup. This
> is a saving of 112 bytes for 64-bit archs.
>
> While at it, also document which page counters are used in v1 and/or v2.
>
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
