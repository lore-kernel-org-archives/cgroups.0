From: Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: fix obsolete comment above
 MEM_CGROUP_MAX_RECLAIM_LOOPS
Date: Thu, 13 Jul 2023 21:16:25 +0800
Message-ID: <F1480552-81A0-4245-A444-5F49BAB7D0AF@linux.dev>
References: <20230713121432.273381-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689254225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I+dPUPTmwBYtftPXHExk6W0A20wTkFyNXTYbt9nVnXc=;
        b=Plf1VJZqsSocTgkFrvxT3pd8zwNJ3D3lTkylOpz2s1XWebviS34/mH15tUhOnXdXnrAeht
        KjpZvZZ5RCLrfkACYLGWk9t66HInMYsE0xVVoFXFJc7K7Xgcc83jofaWDe8g3l6Phw7YYn
        g7iZVP2HiFm7/jeu8KZOUuEFKDmycvQ=
In-Reply-To: <20230713121432.273381-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>



> On Jul 13, 2023, at 20:14, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> 
> Since commit 5660048ccac8 ("mm: move memcg hierarchy reclaim to generic
> reclaim code"), mem_cgroup_hierarchical_reclaim() is already renamed to
> mem_cgroup_soft_reclaim(). Update the corresponding comment.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Thanks.

