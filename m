From: Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: fix wrong function name above
 obj_cgroup_charge_zswap()
Date: Fri, 4 Aug 2023 14:37:00 +0800
Message-ID: <0C7F407E-07AD-45F2-A31B-064080DD4B1C@linux.dev>
References: <20230803120021.762279-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691131056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RGE7IlwwlQoLXGjaNOVIcJyf2once2coPl7qKdP4X7c=;
        b=eXtrKGg9hj64tjMqlRwEdhExZl+fcIsOGj6fMR5eIidNPFrRSEz/JTeYqWy7oof1QW0WwS
        4eZf32iOkbIBdkOiUNoofWKgK21mPqYwxVuvDaZehAs/6W56yyKfloTXJD21IsXMdBctU/
        il7uSAK3OP/3XO4/Dazm3/eRnSnQPL4=
In-Reply-To: <20230803120021.762279-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



> On Aug 3, 2023, at 20:00, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> 
> The correct function name is obj_cgroup_may_zswap(). Correct the comment.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Thanks.

