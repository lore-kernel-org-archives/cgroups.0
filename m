From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 4/5] mm/memcg: Separate out object stock data into its
 own struct
Date: Mon, 12 Apr 2021 16:07:01 -0700
Message-ID: <CALvZod4Rd3arXjJX87dbSoO5iL6HauSfSdWxkreT_ydGYiAHiA@mail.gmail.com>
References: <20210412225503.15119-1-longman@redhat.com> <20210412225503.15119-5-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aTRzEJFSpnM/9p6JIBDLvAw2rNJrlqUIjfDvML3pE+I=;
        b=EHPYiqK56Fzjbrc/qW5NAyRz0w3Dd7UjTe+Axr6LHCmgrAtap46JcXM/jhRbSqGaqj
         gELdIQCoZW1yGJ7H6bqgbzih4W9cnGFArn0Rj0j+2c2Q3GbIY+2GgqX5/PEk3shQ3giX
         3lwvh05R+eQ8cJZSE+I0lFHl8NpHDPVHuC/uwPpK4IBXWJ+59w/w2ofII93zsVvGa8V/
         8pB0HpV4QPaPPvjSlPmTAq6DQctnDEAsvd5fxTuZs2L8FEl4PFyJqmgPzFtfmpoThlEr
         5Z5TwK//szee0vkGALcf84NtuKt4j+yXoePUMMGhTUPBYvf/wC7+E0u8EY6RwdWpgrZU
         Dkiw==
In-Reply-To: <20210412225503.15119-5-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing@linu>

On Mon, Apr 12, 2021 at 3:55 PM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> The object stock data stored in struct memcg_stock_pcp are independent
> of the other page based data stored there. Separating them out into
> their own struct to highlight the independency.
>
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
