From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: Remove unused mod_memcg_obj_state()
Date: Mon, 19 Oct 2020 08:12:48 -0700
Message-ID: <CALvZod49YJkG7z+Bnben2pUbw=TyXrHJE1wWt9HbY_85oNpXNA@mail.gmail.com>
References: <20201013153504.92602-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zk46YEU8AFrJPMd2DZK0YXhrQs/eaI3r0nLePqJ0ljY=;
        b=QfCrOWagyVz1D/JQhVoyJQsbYNAjvQ/iL7mZq7ErUA3+oG3FeUeyngHtmr1rE78TW2
         jEnzyi82NX2BxtlxZFHebEGmu38P5zJj9WCs6+iSqnxIoj5aGi0JeTWr3DPX+dP3+yKX
         ROusE4YeJT4cVzU+K8MYz96BljmWIdtJ4HuB9/BgDhjxhYPDGT9OUp0VhAxFbSPCyCJz
         DYeUCyUbDI2Esf8lS0dCx3esOjAXoE4j9oDYLRJMVAOtEtegY53K58fX77sPIETx8NZO
         JuHNAesgnTu5m+RsUsU2DJ5hVSNRke6vMLvbfwGKTfX1Qwu/jUJ7of6sDfo5LButNPCA
         FYZg==
In-Reply-To: <20201013153504.92602-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Tue, Oct 13, 2020 at 8:36 AM Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
>
> Since commit:
>
>   991e7673859e ("mm: memcontrol: account kernel stack per node")
>
> There is no user of the mod_memcg_obj_state(). This patch just remove
> it. Also rework type of the idx parameter of the mod_objcg_state()
> from int to enum node_stat_item.
>
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
