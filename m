From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] memcg: lost css_put in memcg_expand_shrinker_maps()
Date: Tue, 11 Feb 2020 06:44:04 -0800
Message-ID: <20200211144404.GB480760@tower.DHCP.thefacebook.com>
References: <c98414fb-7e1f-da0f-867a-9340ec4bd30b@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=898GNIYJYiCvxqLwhhSO7pZniKBGW1/77sws03+Vo/o=;
 b=hEWH7kaFExfm/zUnj507655AaP9x3dZlggEInPKOfljx8ZauVJ8Y4d35MCWPmpYw+7GN
 lHhqzEHITYOLqYeWGpKqXbBcjhbx5s0nDfd+crnQJo91VjzpdC+weA6aiWS8LuULh3XH
 QCdxxo0qvk5JHdnPuDVEbvDaAI5iU7rCl1s= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=898GNIYJYiCvxqLwhhSO7pZniKBGW1/77sws03+Vo/o=;
 b=PRK9wpjp32GGpnjmCOX3Xnv2J2D7h42S/QfStXYrZYmvSTlz377kqWZFVTF4ydHkaHp3apT9Zvru/qI9pk89SUhEfDk5Aa+XXB6Z5jp0Oddct1EZQkGA2YHaY5N+9CP0NgfpvrmEQkBKT36/k69S1H257CKy6wrO123WoSCLilw=
Content-Disposition: inline
In-Reply-To: <c98414fb-7e1f-da0f-867a-9340ec4bd30b-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Feb 11, 2020 at 02:20:10PM +0300, Vasily Averin wrote:
> for_each_mem_cgroup() increases css reference counter for memory cgroup
> and requires to use mem_cgroup_iter_break() if the walk is cancelled.
> 
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Fixes commit 0a4465d34028("mm, memcg: assign memcg-aware shrinkers bitmap to memcg")
> 
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Thank you!

> ---
>  mm/memcontrol.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6c83cf4..e2da615 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -409,8 +409,10 @@ int memcg_expand_shrinker_maps(int new_id)
>  		if (mem_cgroup_is_root(memcg))
>  			continue;
>  		ret = memcg_expand_one_shrinker_map(memcg, size, old_size);
> -		if (ret)
> +		if (ret) {
> +			mem_cgroup_iter_break(NULL, memcg);
>  			goto unlock;
> +		}
>  	}
>  unlock:
>  	if (!ret)
> -- 
> 1.8.3.1
> 
