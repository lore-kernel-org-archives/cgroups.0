From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] mm/memcg: Remove obsolete memcg_free_kmem()
Date: Tue, 5 Oct 2021 22:20:45 -0700
Message-ID: <CALvZod4Rhv8vSVRGnqHwRuuBHQ=E-YZk7JGjRWHftM4+9cSQ5A@mail.gmail.com>
References: <20211005202450.11775-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ciDVGqsYOH35J7AcMoo3IqFXoCRGKtna/4nNh2oAa8I=;
        b=PX0XPkQdsK6VcV1+qe5E+Ws3MuZHQRH5zK2EJhibfZ1p+ae4ZLUqE2uyBANAjRuZCx
         GeXpFV/AWrWBo/t32n6nw7eG4uGD/5B7/23okivlIH+KKES5dAZfgyXnQ8zz89hrnhPM
         liKp70d2Hxfq9gkAMHIEsKT5+fjZa7TZwmjSBJXjsXXQEkrxQdL0FD32ljWrdxHAMCbX
         WnJASMLr+YbRvIAuQ2AVgfQQBurUUPQzn36gJAv4Bo6RUWXkC5/e0yQ0j6zENpg0Y1xI
         6hc+6ZYVIm6sWazuZZAzbzbGlbefkJHxqehgLmcH6zD4QcLJtCvSBX/YGszd1nb/k+W0
         vdTg==
In-Reply-To: <20211005202450.11775-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Tue, Oct 5, 2021 at 1:25 PM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> Since commit d648bcc7fe65 ("mm: kmem: make memcg_kmem_enabled()
> irreversible"), the only thing memcg_free_kmem() does is to call
> memcg_offline_kmem() when the memcg is still online which can happen when
> online_css() fails due to -ENOMEM. However, the name memcg_free_kmem()
> is confusing and it is more clear and straight forward to call
> memcg_offline_kmem() directly from mem_cgroup_css_free().
>
> Suggested-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
