From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: fix slub memory accounting
Date: Tue, 23 Feb 2021 07:21:58 -0800
Message-ID: <CALvZod4fYvxusqw=g=Sc99eiW5pd7Qu0YFh=SpUna5Ltd9Pwbg@mail.gmail.com>
References: <20210223092423.42420-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XGL+ZEl1VxWchCvh5LCCnMOsswk/yP/QAWF1B7tp0PE=;
        b=Wy4BbxDEhgR4O7gMewi35UNKdoIq+5jPJHkEkUPI4l+zHkf/xvB3AtgtOh0iXos53O
         Zk5wGQPK48Zhpdf64dMiDAILYpmCATxqBwyi0OlNqSYSwz+hK+/9WNhp8lMNLJqBX99c
         wK4rGFVCouTcrfF/JOUpofuiPJ8fF49tqSkBBrTFMUmEw9nAgfPYyBuuln6d8YW5I8Vc
         keqpKNlB6pCw7G2BICq8n+GOkqOstBrhwKcOBIXQybErStqxgPXeiIgiNLY1VeybMdgO
         kzt0LAl78laUJAX1afg+UQPm4iS7baqN1P55qK5me5WGklMBebxv6wW+nN/50r8akgA1
         a/dQ==
In-Reply-To: <20210223092423.42420-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Feb 23, 2021 at 1:25 AM Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
>
> SLUB currently account kmalloc() and kmalloc_node() allocations larger
> than order-1 page per-node. But it forget to update the per-memcg
> vmstats. So it can lead to inaccurate statistics of "slab_unreclaimable"
> which is from memory.stat. Fix it by using mod_lruvec_page_state instead
> of mod_node_page_state.
>
> Fixes: 6a486c0ad4dc ("mm, sl[ou]b: improve memory accounting")
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
