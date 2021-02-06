From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] mm: memcontrol: replace the loop with a list_for_each_entry()
Date: Fri, 5 Feb 2021 17:00:07 -0800
Message-ID: <CALvZod6Xv6jJbUsJ0Rh+7tS=SjOPxY5MqHLtr2JdJZov9T45wQ@mail.gmail.com>
References: <20210204163055.56080-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fb95oN2pGx3nj+Eb9wyweMoS+j1I5Uh71GzG+Sz5oEM=;
        b=rmxoZUiSYkE8WfcgoGpH7IesJ19msP/HBOrSblBil1jDywKKNf0JAOM/ZXWZUbHylE
         ZC3ZwMo8GNEAQB5DwMZpU2qre6bGCokTjqEtWwoGcnoQbvNYKFvMNBxN7n5bth2tqddl
         jmseJ5ITj1AUUqey4rvVJJY1pFpw/ZMB+uIMqEwX1S0n2zl3xv9Z4/ve3yPhU7VwNabe
         6zD1LGmW7sV8jwByfF3vS8tVg14Cx2jqVW9wQCcQWsHcvraZsvbtriBpxYOr89geqVgw
         S5rAqh/fXXn7MLD7GG1OqbukEsSXVqs+Y9uQyfp2tZiDJ0cl9RhZ5jngWRQErTthIzRj
         q/UA==
In-Reply-To: <20210204163055.56080-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Feb 4, 2021 at 8:39 AM Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
>
> The rule of list walk has gone since:
>
>  commit a9d5adeeb4b2 ("mm/memcontrol: allow to uncharge page without using page->lru field")
>
> So remove the strange comment and replace the loop with a
> list_for_each_entry().
>
> There is only one caller of the uncharge_list(). So just fold it into
> mem_cgroup_uncharge_list() and remove it.
>
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
