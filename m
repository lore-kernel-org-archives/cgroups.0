From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] [PATCH 2/3] mm: Charge active memcg when no mm is set
Date: Sat, 3 Apr 2021 13:47:05 +0800
Message-ID: <CAMZfGtVwxo-UMq8RD_2hpLAbhhYzSkDi_J7kQOJ3yzFz=-5USQ@mail.gmail.com>
References: <20210402191638.3249835-1-schatzberg.dan@gmail.com> <20210402191638.3249835-3-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V+wFWYRFis43GOTN2XRu8TgjxNZOmO8IgF4gRsiv9cA=;
        b=pMd1FbuvZ5E2fr1ocmyqnh+uLdNieVu/k08bIWoaWboRu1GuMhWuxbxzopnRIIA9lc
         zKwlsLoFQIrvZO9+Oo5f16yHnpzmH+iue6MrfQZ68f+gsl7xZ5h4aANWgAt4AjBkOBIn
         LczolwaRoieF168IcrjESxGMivxeYdlo7Pm9SyQ/si7aRk4o9K2fQKJkVd7bDtift8BP
         irNQU99mPX+t2pMHMjigsm8Gc9ruDFKeFl/YCvdAbROCuItCoolqDlnbbTsjNsM8SmMt
         RqMuLSmnqc5b8HrGIBHt14Fxr9KQXLtRLhBl5pAV9AM5fVsGMKr2+SMyr/9c/sjy9u4c
         nEdw==
In-Reply-To: <20210402191638.3249835-3-schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:BLOCK LAYER" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:MEMORY MANAGEMENT" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>

On Sat, Apr 3, 2021 at 3:17 AM Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> set_active_memcg() worked for kernel allocations but was silently
> ignored for user pages.
>
> This patch establishes a precedence order for who gets charged:
>
> 1. If there is a memcg associated with the page already, that memcg is
>    charged. This happens during swapin.
>
> 2. If an explicit mm is passed, mm->memcg is charged. This happens
>    during page faults, which can be triggered in remote VMs (eg gup).
>
> 3. Otherwise consult the current process context. If there is an
>    active_memcg, use that. Otherwise, current->mm->memcg.
>
> Previously, if a NULL mm was passed to mem_cgroup_charge (case 3) it
> would always charge the root cgroup. Now it looks up the active_memcg
> first (falling back to charging the root cgroup if not set).
>
> Signed-off-by: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Acked-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
> Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Thanks.
