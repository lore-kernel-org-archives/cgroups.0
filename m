From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch] memcg: disable hierarchy support if bound to the legacy
 cgroup hierarchy
Date: Mon, 2 Mar 2015 18:58:21 +0100
Message-ID: <20150302175821.GA18345@dhcp22.suse.cz>
References: <1425317939-13305-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=RRAs5Qoyko7utWMR8xqUO16lbAT7ofeuiE7cCP6VCyg=;
        b=mDfswqA2ws11jqEpcNitdX6awK+LqFdQLa82GIFc3Md92JCOOfYRjeT0Oz9QrSThkn
         a1nKjd/FS/tgSv7BBVl6GMrejkQUeGYj+6mVqizEqasV/GCvxUAH8C9k2Snq8W7oip1p
         qPHO4tg62jKlcEANmpKJcTv50mBKb3HpXyTKrvHywz58cETtcq1vsY8Fk7bzsoOj0d3w
         WDANMk2/KteYDxvJ9ZZueCk5S0pZcGY8EPnFjSlBUNSbKAdgXszki4JkiZzu6ViMwIBA
         yuON99sQDWtleOqsvO8K7a2FUsyeX5dOE5ooTXjSEolUM4ZLDBAanaWm14RjWRH/urm2
         IE0A==
Content-Disposition: inline
In-Reply-To: <1425317939-13305-1-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 02-03-15 12:38:59, Johannes Weiner wrote:
> From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> 
> If the memory cgroup controller is initially mounted in the scope of the
> default cgroup hierarchy and then remounted to a legacy hierarchy, it
> will still have hierarchy support enabled, which is incorrect. We should
> disable hierarchy support if bound to the legacy cgroup hierarchy.
> 
> Signed-off-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

I had this one on the radar but I wasn't sure about the first cgroup
part so I haven't acked it. Once Tejun picked it up this one is good as
well.

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  mm/memcontrol.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Andrew, could you please pick this up for 4.0?  I don't think it's
> urgent enough for -stable, though.  Thanks!
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 0c86945bcc9a..68d4890fc4bd 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5238,7 +5238,9 @@ static void mem_cgroup_bind(struct cgroup_subsys_state *root_css)
>  	 * on for the root memcg is enough.
>  	 */
>  	if (cgroup_on_dfl(root_css->cgroup))
> -		mem_cgroup_from_css(root_css)->use_hierarchy = true;
> +		root_mem_cgroup->use_hierarchy = true;
> +	else
> +		root_mem_cgroup->use_hierarchy = false;
>  }
>  
>  static u64 memory_current_read(struct cgroup_subsys_state *css,
> -- 
> 2.3.0
> 

-- 
Michal Hocko
SUSE Labs
