From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch] mm: memcontrol: fold move_anon() and move_file()
Date: Wed, 14 Jan 2015 16:42:10 +0100
Message-ID: <20150114154210.GG4706@dhcp22.suse.cz>
References: <1421175592-14179-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=DOtWP78DuPWzR/704nuhcOVLqlMXLEVqCgDH0ce6n6Y=;
        b=kw3JT1+zWZr2wWAx5Kv/Ps93Q0/CICLDzMp1sYPvhxovmOZImTRUBRhK6925ncse/P
         jiY8PeCYKG5rkyAJ9BHc5of3dBJerzgSSTJxGRIsf8egr/SQn3zZzK3SSym1Z7gu63V2
         OPbgUW6oF7FhpfWqlO5x4mfpYtkN6+vwDGp8dSJckUuaUbyhn2UUszqoqnpGLLYeHFxT
         UFMvtzc5e0Z3JOTN1ALEv1acOVGjzj5xhC5o+HF4rIoSZf4NZd9i51q8Dl/w3mDUWA/F
         clSURTvdvzWPNP8I9ayO/GvjDBa/rl2jEfRuIc3NNxranhNKCjEaDM2r/EoiDmSqA1J6
         xpNw==
Content-Disposition: inline
In-Reply-To: <1421175592-14179-1-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 13-01-15 13:59:52, Johannes Weiner wrote:
> Turn the move type enum into flags and give the flags field a shorter
> name.  Once that is done, move_anon() and move_file() are simple
> enough to just fold them into the callsites.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

one nit below

> ---
>  mm/memcontrol.c | 49 ++++++++++++++++++-------------------------------
>  1 file changed, 18 insertions(+), 31 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 5a5769e8b12c..692e96407627 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -360,21 +360,18 @@ static bool memcg_kmem_is_active(struct mem_cgroup *memcg)
>  
>  /* Stuffs for move charges at task migration. */
>  /*
> - * Types of charges to be moved. "move_charge_at_immitgrate" and
> - * "immigrate_flags" are treated as a left-shifted bitmap of these types.
> + * Types of charges to be moved.
>   */
> -enum move_type {
> -	MOVE_CHARGE_TYPE_ANON,	/* private anonymous page and swap of it */
> -	MOVE_CHARGE_TYPE_FILE,	/* file page(including tmpfs) and swap of it */
> -	NR_MOVE_TYPE,
> -};
> +#define MOVE_ANON	0x1U
> +#define MOVE_FILE	0x2U
> +#define MOVE_MASK	0x3U

#define MOVE_MASK	(MOVE_ANON | MOVE_FILE)

would be probably better
[...]
-- 
Michal Hocko
SUSE Labs
