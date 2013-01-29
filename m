From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 0/6] memcg: disable swap cgroup allocation at swapon
Date: Tue, 29 Jan 2013 16:15:31 +0100
Message-ID: <20130129151531.GI29574@dhcp22.suse.cz>
References: <510658E3.1020306@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <510658E3.1020306-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 28-01-13 18:54:27, Jeff Liu wrote:
> Hello,
> 
> Here is the v2 patch set for disabling swap_cgroup structures allocation
> per swapon.
> 
> In the initial version, one big issue is that I have missed the swap tracking
> for the root memcg, thanks Michal pointing it out. :)
> 
> In order to solve it, the easiest approach I can think out is to bypass the root
> memcg swap accounting during the business and figure it out with some global stats,
> which means that we always return 0 per root memcg swap charge/uncharge stage, and
> this is inspired by another proposal from Zhengju:
> "memcg: Don't account root memcg page statistics -- https://lkml.org/lkml/2013/1/2/71"
> 
> Besides that, another major fix is deallocate swap accounting structures on the last
> non-root memcg remove after all references to it are gone rather than doing it on
> mem_cgroup_destroy().
> 
> Any comment are welcome!

Could you also post your testing methodology and results, please? It
would be also really great if you could sum up memory savings.

Anyway thanks this second version looks really promising.

> v1->v2:
> - Refactor swap_cgroup_swapon()/swap_cgroup_prepare(), to make the later can be
>   used for allocating buffers per the first non-root memcg creation.
> - Bypass root memcg swap statistics, using the global stats to figure it out instead.
> - Export nr_swap_files which would be used when creating/freeing swap_cgroup
> - Deallocate swap accounting structures on the last non-root memcg removal
> 
> Old patch set:
> v1:
> http://marc.info/?l=linux-mm&m=135461016823964&w=2
> 
> 
> Thanks,
> -Jeff
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>

-- 
Michal Hocko
SUSE Labs
