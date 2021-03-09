From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 1/9] memcg: accounting for allocations called with
 disabled BH
Date: Tue, 9 Mar 2021 12:39:18 -0800
Message-ID: <YEfc9uCc8sfs7ooT@carbon.dhcp.thefacebook.com>
References: <18a0ae77-89ff-2679-ab19-378e38ce2be2@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=tHuKjlTLpADUaNz75myE9AgMalB26gUPldhWPOy2lQU=;
 b=M6cgp/J8LZUTF59ukKAFPc81sTMIY99bA4uCRZcHpRwHZC5hROP9CPQtxfac0ewIx+eh
 3CR7uxGTXtBUDHRN7xbMk8zEDRT0RBStd0a6i4jivSMzdRHrmsq6hxqk2koi5fxEHrnx
 GtvJgwCPXvphR0YH/Y8MX/ItQi5V7p0CS1I= 
Content-Disposition: inline
In-Reply-To: <18a0ae77-89ff-2679-ab19-378e38ce2be2-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Tue, Mar 09, 2021 at 11:03:48AM +0300, Vasily Averin wrote:
> in_interrupt() check in memcg_kmem_bypass() is incorrect because
> it does not allow to account memory allocation called from task context
> with disabled BH, i.e. inside spin_lock_bh()/spin_unlock_bh() sections
> 
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Good catch!

It looks like the bug was there for years: in_interrupt() was there since
the commit 7ae1e1d0f8ac ("memcg: kmem controller infrastructure") from 2012!
So I guess there is no point for a stable fix, but it's definitely nice to
have it fixed.

Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

for this patch and the rest of the series.

Thank you!

> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 845eec0..568f2cb 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1076,7 +1076,7 @@ static __always_inline bool memcg_kmem_bypass(void)
>  		return false;
>  
>  	/* Memcg to charge can't be determined. */
> -	if (in_interrupt() || !current->mm || (current->flags & PF_KTHREAD))
> +	if (!in_task() || !current->mm || (current->flags & PF_KTHREAD))
>  		return true;
>  
>  	return false;
> -- 
> 1.8.3.1
> 
