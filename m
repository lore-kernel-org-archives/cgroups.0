From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v3 16/16] memcg: enable accounting for ldt_struct objects
Date: Thu, 22 Apr 2021 14:26:15 +0200
Message-ID: <20210422122615.GA7021@zn.tnic>
References: <dddf6b29-debd-dcb5-62d0-74909d610edb@virtuozzo.com>
 <94dd36cb-3abb-53fc-0f23-26c02094ddf4@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1619094373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=JglfRayovDMQVqeriuhpOiFo+lgNzm5LhdlgTwXaVhI=;
        b=iIzRUDXhTEsdbaT+50GL0ZwpdhkmyvwZTeDFdVYRTpQRo4I5Bg33C8DLrM4Btfc0GUZ4RY
        ZdZK3mbji5oBIvjKWBEaWzu8XRZw1HAAQ/rDVsI8yn4DLbeEX3FBp7yyjiW1J8p0K1E/w5
        zA/JuqORz8avyv50hKaReb6Tdydg6ls=
Content-Disposition: inline
In-Reply-To: <94dd36cb-3abb-53fc-0f23-26c02094ddf4-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>

On Thu, Apr 22, 2021 at 01:38:01PM +0300, Vasily Averin wrote:

You have forgotten to Cc LKML on your submission.

> Each task can request own LDT and force the kernel to allocate up to
> 64Kb memory per-mm.
> 
> There are legitimate workloads with hundreds of processes and there
> can be hundreds of workloads running on large machines.
> The unaccounted memory can cause isolation issues between the workloads
> particularly on highly utilized machines.
> 
> It makes sense to account for this objects to restrict the host's memory
> consumption from inside the memcg-limited container.
> 
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> ---
>  arch/x86/kernel/ldt.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
> index aa15132..a1889a0 100644
> --- a/arch/x86/kernel/ldt.c
> +++ b/arch/x86/kernel/ldt.c
> @@ -154,7 +154,7 @@ static struct ldt_struct *alloc_ldt_struct(unsigned int num_entries)
>  	if (num_entries > LDT_ENTRIES)
>  		return NULL;
>  
> -	new_ldt = kmalloc(sizeof(struct ldt_struct), GFP_KERNEL);
> +	new_ldt = kmalloc(sizeof(struct ldt_struct), GFP_KERNEL_ACCOUNT);
>  	if (!new_ldt)
>  		return NULL;
>  
> @@ -168,9 +168,10 @@ static struct ldt_struct *alloc_ldt_struct(unsigned int num_entries)
>  	 * than PAGE_SIZE.
>  	 */
>  	if (alloc_size > PAGE_SIZE)
> -		new_ldt->entries = vzalloc(alloc_size);
> +		new_ldt->entries = __vmalloc(alloc_size,
> +					     GFP_KERNEL_ACCOUNT | __GFP_ZERO);

You don't have to break that line - just let it stick out.

>  	else
> -		new_ldt->entries = (void *)get_zeroed_page(GFP_KERNEL);
> +		new_ldt->entries = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
>  
>  	if (!new_ldt->entries) {
>  		kfree(new_ldt);
> -- 

In any case:

Acked-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
