From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] memcg: fix compile warning on non-numa systems
Date: Mon, 16 Jan 2012 09:47:15 +0100
Message-ID: <20120116084715.GA1639@tiehlicka.suse.cz>
References: <4F13BE05.70505@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4F13BE05.70505-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hiroyuki KAMEZAWA <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>

On Mon 16-01-12 14:04:53, Li Zefan wrote:
> Fix this warning:
> 
>   CC      mm/memcontrol.o
> mm/memcontrol.c: In function 'memcg_check_events':
> mm/memcontrol.c:779:22: warning: unused variable 'do_numainfo'

This has been already posted by Kirill and I didn't like the solution
(https://lkml.org/lkml/2011/12/27/86). He then reposted with a different
version (https://lkml.org/lkml/2012/1/6/281).
The later one looks better but I still think this is not worth
complicate the code just to get rid of this warning.

> 
> Signed-off-by: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> ---
>  mm/memcontrol.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 602207b..c8aeab8 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -776,14 +776,16 @@ static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
>  	/* threshold event is triggered in finer grain than soft limit */
>  	if (unlikely(mem_cgroup_event_ratelimit(memcg,
>  						MEM_CGROUP_TARGET_THRESH))) {
> -		bool do_softlimit, do_numainfo;
> -
> -		do_softlimit = mem_cgroup_event_ratelimit(memcg,
> -						MEM_CGROUP_TARGET_SOFTLIMIT);
> +		bool do_softlimit;
>  #if MAX_NUMNODES > 1
> +		bool do_numainfo;
> +
>  		do_numainfo = mem_cgroup_event_ratelimit(memcg,
>  						MEM_CGROUP_TARGET_NUMAINFO);
>  #endif
> +
> +		do_softlimit = mem_cgroup_event_ratelimit(memcg,
> +						MEM_CGROUP_TARGET_SOFTLIMIT);
>  		preempt_enable();
>  
>  		mem_cgroup_threshold(memcg);
> -- 
> 1.7.3.1
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
