From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: Fix incorrect flushing of lruvec data in obj_stock
Date: Mon, 2 Aug 2021 07:32:01 -0700
Message-ID: <CALvZod7-x4ezYcUh+ycTzWypL9bLpL-fdRsZrw1iM+__H2_s_g@mail.gmail.com>
References: <20210802022827.10192-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=19nfVkDw1JHrHyLVrxQ7C3iIv4HJUAVawRYI+zVDKis=;
        b=g2rXIt6PCcJyTa2L7O6qIeZjWDnqOSfddyk6MrYcfEsfL7ZHrImFAKiYu/6qeNFXml
         uFaNVZeiebZF2qSRn4MPkT99U8W2aI+dIRtgDQCtGeKJguajzSd2fILGxt3hoaOrg5Al
         jNhOcCLyG2pjA96otAuaSej7Cs/zqm5fq7ZGMOXetpdUIAfuG7QYlshPWqrprPyvnP/b
         eWM3QaOgo34fZF71q7x5gABjzMONsiYCOtCG0wrB3MMQG3KaQk5Cflt++3Ea2NnFguBI
         Vvm4lTfSqGY7YleaXqoyw66XVOUYcxVgtMYqifv6gkKvQu33r8bafyCu1ggNmNAPF1uk
         2QEg==
In-Reply-To: <20210802022827.10192-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing@linu>

On Sun, Aug 1, 2021 at 7:28 PM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> When mod_objcg_state() is called with a pgdat that is different from
> that in the obj_stock, the old lruvec data cached in obj_stock are
> flushed out. Unfortunately, they were flushed to the new pgdat and
> hence the wrong node, not the one cached in obj_stock.
>
> Fix that by flushing the data to the cached pgdat instead.
>
> Fixes: 68ac5b3c8db2 ("mm/memcg: cache vmstat data in percpu memcg_stock_pcp")
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

After incorporating Michal's comments, you can add:

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
