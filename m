From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v2] memcg: Fix memcg_kmem_bypass() for remote memcg
 charging
Date: Wed, 13 May 2020 09:11:10 -0700
Message-ID: <20200513161110.GA70427@carbon.DHCP.thefacebook.com>
References: <e6927a82-949c-bdfd-d717-0a14743c6759@huawei.com>
 <20200513090502.GV29153@dhcp22.suse.cz>
 <76f71776-d049-7407-8574-86b6e9d80704@huawei.com>
 <20200513112905.GX29153@dhcp22.suse.cz>
 <3a721f62-5a66-8bc5-247b-5c8b7c51c555@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=igsYSo8Rnj6AmhEEXQNL3hz7d88Zd8kYSLUh0Cs0nos=;
 b=MXedZEZyw5bxnxbfGeyniV729AsiWCIr0AWvMRoaQlNsZgqidsm5cDO4xBi1dX61FP3k
 IXylAtDI0wxu6hpx9mISYBvsm8sJ4ir1KQyo5FiY5+Ot8DSBpSa/DqTBqhnlWvtZFrGE
 cuNNBjLP1514vRzJrVy4Rkly8ptPEENb7z0= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=igsYSo8Rnj6AmhEEXQNL3hz7d88Zd8kYSLUh0Cs0nos=;
 b=MJZvbtQGba6MreT5VR30DnXgtFKRGpjEiagFzp6TTr2Q9+MiynUxof2a5t+wc8GI6Eln+rcObrXkW8fvNdtDgns0GYzadcHEVRCQlbdXR4Cx86CMrTWXgUTX8Hz1ojygmHY2YBmKU17f6jDaXdAg+DrRXuLYmWJEzdvJ7/eznFs=
Content-Disposition: inline
In-Reply-To: <3a721f62-5a66-8bc5-247b-5c8b7c51c555-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed, May 13, 2020 at 07:47:49PM +0800, Zefan Li wrote:
> While trying to use remote memcg charging in an out-of-tree kernel module
> I found it's not working, because the current thread is a workqueue thread.
> 
> As we will probably encounter this issue in the future as the users of
> memalloc_use_memcg() grow, it's better we fix it now.
> 
> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
> 
> v2: add a comment as sugguested by Michal. and add changelog to explain why
> upstream kernel needs this fix.
> 
> ---
> 
>  mm/memcontrol.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a3b97f1..43a12ed 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2802,6 +2802,9 @@ static void memcg_schedule_kmem_cache_create(struct mem_cgroup *memcg,
>  
>  static inline bool memcg_kmem_bypass(void)
>  {
> +	/* Allow remote memcg charging in kthread contexts. */
> +	if (unlikely(current->active_memcg))
> +		return false;
>  	if (in_interrupt() || !current->mm || (current->flags & PF_KTHREAD))
>  		return true;

Shakeel is right about interrupts. How about something like this?

static inline bool memcg_kmem_bypass(void)
{
	if (in_interrupt())
		return true;

	if ((!current->mm || current->flags & PF_KTHREAD) && !current->active_memcg)
		return true;

	return false;
}

Thanks!
