From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH 3/4] mm/memcg: retrieve parent memcg from css.parent
Date: Tue, 11 Jan 2022 11:12:43 +0800
Message-ID: <CAMZfGtWmo62c0aeszxEjCTN8OVV8iAKiUytvwOMuZ9qD=Ke2Dg@mail.gmail.com>
References: <20220111010302.8864-1-richard.weiyang@gmail.com> <20220111010302.8864-3-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vePxboaj5Wzxcx+RQdgsE8w7bUmtQir6BsCsMhN8f0c=;
        b=ieCdWrzviTyUE7447aiXEbq7Rt8+vOuuPSLhn3BqOqU1oZG6sXDX+a7WFqsctJHyaA
         ftggmDSC1l1LOiLOUfTt2HTtmCfX0IqGvhiX6E2oNnaL92Sp4+6ZLshokZq+F/IQrxBP
         Y4Lbi8/N8rSslC2ktHdn5M8vuK4gWImnoyQ4xHxJWv7xOjIR8K3d0eq52b8qSDlk5nRS
         UeJiPGwXFKD3ErfN1RYhYXXyjN6qoU2dZkWxneN9bOKYcH0O26+bkzyuER3wnmBINvJa
         8xB+Z0jgKHtuO6V7z5iytxsXLRTVAR+70Bo3X1jS9nsDSDUqIRoJf5CwQrAEDV5RGjS1
         cE2A==
In-Reply-To: <20220111010302.8864-3-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Tue, Jan 11, 2022 at 9:03 AM Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> The parent we get from page_counter is correct, while this is two
> different hierarchy.
>
> Let's retrieve the parent memcg from css.parent just like parent_cs(),
> blkcg_parent(), etc.
>
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Thanks.
