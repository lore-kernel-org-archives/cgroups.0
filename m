From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH 1/5] mm, memcg: remove unused functions
Date: Fri, 30 Jul 2021 10:39:01 +0800
Message-ID: <CAMZfGtUon=R1EEW4Y33DQ1_DQg9ciUyyTJnxgUH5=MyAWLU+=w@mail.gmail.com>
References: <20210729125755.16871-1-linmiaohe@huawei.com> <20210729125755.16871-2-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P+arnXaTaJFGxX6D4lzafx9633DBfkJpPAK5Nf+O5Qw=;
        b=cBgyvqCISrEPhMOzj61PGUaSCvJs1xoa9d/Yx1CcLHIYtPm60B0d7pcJ7ynvT4w3I6
         se5akXAXqk5sZBpgoxuQXLy3LYgQZpIfK7dW/YFHdCWQd3lShO0vNt/hoEUZ5rtwQPfu
         BqAnum2fv6J8DX+qHj8ylDP9eXCw/rtQvCyWD/GyQG58JLNadwSrSURiX8L6vQNOi6wM
         BqCwpB2w+S8vdyG9+4r4PyDKTpxHtm7OOzw6kahoIDyUclDGepEOplKqWnrWqSYJJfY2
         bEv3Ip6h9ZSOwIJVzdXY4RZX8AYvZy7geUw2GguQgD9iQViLc9qSAq5H0LdjwxFOt0g3
         jrIg==
In-Reply-To: <20210729125755.16871-2-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Alex Shi <alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Jul 29, 2021 at 8:57 PM Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>
> Since commit 2d146aa3aa84 ("mm: memcontrol: switch to rstat"), last user
> of memcg_stat_item_in_bytes() is gone. And since commit fa40d1ee9f15 ("mm:
> vmscan: memcontrol: remove mem_cgroup_select_victim_node()"), only the
> declaration of mem_cgroup_select_victim_node() is remained here. Remove
> them.
>
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
