From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: add a helper function to check may oom
 condition
Date: Mon, 9 Sep 2013 13:22:18 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1309091317570.16291@chino.kir.corp.google.com>
References: <522D2FE5.3080606@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=QxoaiRJwkllLPnrKp+EomArPswuurIcfZAqtDLd/7Kg=;
        b=DK0iisGoYWgIepoBAKW1xIMPy6+TXqgXZZ8XM9f0duz0nbXTNHBYQsMVVnRnUBqcNy
         qyHp/oTpsc07BFIMdClHpkljGvuXUpelxCS+sVBmui0oFb13DuyItzXGGFtGi7uKfypQ
         PO/HbJt0Tm9zHZkvzG2S0l0/ylxQBZnn+/zanf817XBFqNYeiV6eW9qmFoUHl/jgztpi
         +PKJb/b2fSzMo8Gaidc4Uiwdh7A5Rs6D+nXSonM7pInWjDkAS30AzgZ2AKOARVvENR/R
         FSb0mKlRzs2DxpsbiZXfm8eHVuPMY0HR56ZkxDSZMnz063GQLk+WIU3mqSVJrbkq/O57
         X4oA==
In-Reply-To: <522D2FE5.3080606-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Mon, 9 Sep 2013, Qiang Huang wrote:

> diff --git a/include/linux/oom.h b/include/linux/oom.h
> index da60007..d061c63 100644
> --- a/include/linux/oom.h
> +++ b/include/linux/oom.h
> @@ -82,6 +82,11 @@ static inline void oom_killer_enable(void)
>  	oom_killer_disabled = false;
>  }
> 
> +static inline bool may_oom(gfp_t gfp_mask)

Makes sense, but I think the name should be more specific to gfp flags to 
make it clear what it's using to determine eligibility, maybe oom_gfp_allowed()? 
We usually prefix oom killer functions with "oom".

Nice taste.

> +{
> +	return (gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY);
> +}
> +
>  extern struct task_struct *find_lock_task_mm(struct task_struct *p);
> 
>  /* sysctls */
