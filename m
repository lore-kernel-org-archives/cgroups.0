From: Lord Glauber Costa of Sealand <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2 3/6] memcg: introduce memsw_accounting_users
Date: Tue, 29 Jan 2013 13:46:33 +0400
Message-ID: <51079A79.9090802@parallels.com>
References: <510658F0.9050802@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <510658F0.9050802-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jeff Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On 01/28/2013 02:54 PM, Jeff Liu wrote:
> As we don't account the swap stat number for the root_mem_cgroup anymore,
> here we can just return an invalid CSS ID if there is no non-root memcg
> is alive.  Also, introduce memsw_accounting_users to track the number of
> active non-root memcgs.
> 
> Signed-off-by: Jie Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> CC: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> CC: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> CC: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> CC: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> 
> ---
>  mm/page_cgroup.c |   16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
> index c945254..189fbf5 100644
> --- a/mm/page_cgroup.c
> +++ b/mm/page_cgroup.c
> @@ -336,6 +336,8 @@ struct swap_cgroup {
>  };
>  #define SC_PER_PAGE	(PAGE_SIZE/sizeof(struct swap_cgroup))
>  
> +static atomic_t memsw_accounting_users = ATOMIC_INIT(0);
> +

I am not seeing this being incremented or decremented. I can only guess
that it comes in later patches. However, they are clearly used as a
global reference counter.

This is precisely one of the use cases static branches solve very
neatly. Did you consider using them?

True, they will help a lot more when we are touching hot paths, and swap
is hardly a hot path.

However, since one of the main complaints about memcg has been that we
inflict "death by a thousand cuts", maybe it wouldn't hurt everything
else being the same.

Michal and others, do you have any feelings here?
