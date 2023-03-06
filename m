From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH v2, 0/4] mm, memcg: cgroup v1 and v2 tunable load/store
 tearing fixes
Date: Mon, 6 Mar 2023 09:51:32 -0800
Message-ID: <ZAYoJPAEHemTFjtY@P9FQF9L96D>
References: <20230306154138.3775-1-findns94@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230306154138.3775-1-findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tangyeechou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Mon, Mar 06, 2023 at 11:41:34PM +0800, Yue Zhao wrote:
> This patch series helps to prevent load/store tearing in
> several cgroup knobs.
> 
> As kindly pointed out by Michal Hocko and Roman Gushchin
> , the changelog has been rephrased.
> 
> Besides, more knobs were checked, according to kind suggestions
> from Shakeel Butt and Muchun Song.
> 
> v1:
> - Add [WRITE|READ]_ONCE for memcg->oom_group
> v2:
> - Rephrase changelog
> - Add [WRITE|READ]_ONCE for memcg->oom_kill_disable,
>  memcg->swappiness, vm_swappiness and memcg->soft_limit
> 
> Yue Zhao (4):
>   mm, memcg: Prevent memory.oom.group load/store tearing
>   mm, memcg: Prevent memory.swappiness load/store tearing
>   mm, memcg: Prevent memory.oom_control load/store tearing
>   mm, memcg: Prevent memory.soft_limit_in_bytes load/store tearing

Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
for the series.

Thank you!
