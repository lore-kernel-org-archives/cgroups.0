From: Mukesh Ojha <quic_mojha-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 linux-next] mm: memcontrol: Fix a typo in comment
Date: Mon, 15 Aug 2022 20:26:01 +0530
Message-ID: <4323bf73-7a29-7a0e-55ef-b75fcfa76414@quicinc.com>
References: <20220815065102.74347-1-xu.panda@zte.com.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=JulapoFWk3dxtqxAH3G3jT1Nroa70FxVbmz4oDd1F2c=;
 b=KR5sGZsx9MVkU2CoNuIQ426wYA8fwqUy4Rpy8RLT4lDjCKH8w37qfW3vGnQu9oonxR9m
 H2fQPe7gbMc7dC1Zosg2Z2Um8cO0jrqldfxAeTImQ2CtUKYEVviXM0jmLHpaSxYhS3hv
 FEquYyY1wJhIovoaqqRl3rFZ1E5pZMDheojt3tt0FWM/Zyesyvoi0MjqPXFJbHmYYwDe
 s7FS3ZWBEHNMgSe0/B2Qg0KPgwJ9/h/TQ5p1TAwRIPuSTFlqZHeMP1Rcreyic2icI/Na
 E8G9Pjn+Q78Hymy3YbyGS68kf6R0rE5wcCZQV5GSo/J+MVuAuRlOveIJ74IUqyJeNkPI FQ== 
Content-Language: en-US
In-Reply-To: <20220815065102.74347-1-xu.panda-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xupanda <xu.panda-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>, Zeal Robot <zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>


On 8/15/2022 12:21 PM, cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: xupanda <xu.panda-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> 
> Fix a spelling mistake in comment.
> 
> Reported-by: Zeal Robot <zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> Signed-off-by: xupanda <xu.panda-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> Signed-off-by: CGEL ZTE <cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> ---
> Change for v2:
>   - fix wrong title
> ---
> 
>   mm/memcontrol.c     |  2 +-
>   1 files changed, 1 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b69979c9ced5..4dddd8be320a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1143,7 +1143,7 @@ static void invalidate_reclaim_iterators(struct mem_cgroup *dead_memcg)
>   	} while ((memcg = parent_mem_cgroup(memcg)));
>   
>   	/*
> -	 * When cgruop1 non-hierarchy mode is used,
> +	 * When cgroup1 non-hierarchy mode is used,

Reviewed-by: Mukesh Ojha <quic_mojha-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>

-Mukesh

>   	 * parent_mem_cgroup() does not walk all the way up to the
>   	 * cgroup root (root_mem_cgroup). So we have to handle
>   	 * dead_memcg from cgroup root separately.
