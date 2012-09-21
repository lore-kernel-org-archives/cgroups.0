From: Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH v3 08/16] slab: allow enable_cpu_cache to use preset
 values for its tunables
Date: Fri, 21 Sep 2012 12:29:20 +0300
Message-ID: <CAOJsxLFeh5G1JBMmZPkwMBTEXSJB7Bmp1yvvbDz0suWE5sReYA@mail.gmail.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
	<1347977530-29755-9-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=TUvNFQldKkkr2PlxZ3H+MSoEeai30YWSb8sLFLTgtLo=;
        b=bKLrcwUqdR7/eI8hlruxXw3zveenuBJM8m8nRFjMjTlvsFY7lQFrvYDYRfmm6CoGix
         6M6uUuO3J1m+ef9j6gxOYLzNTGjfWdGlNb1aAuY0scHTLZQHC/wwP7YuQmNO9wFCcgnf
         7vMdr7shIk1P7ICp9sGq42bvq66KKvrruRMU5viKB/Tw5Kcipz2dZn5LfiJ6dzCm6WB7
         rdb4HXFxdfG7OP4YG5uQMYxK4VNFNWG/V7SNKPamXqBIZPbQEe/rTw8VYWTNw/5xaCIm
         wDjmtQr3oHklnQDCxOqyaCFtDjJpsZoglOMYJELWLUUd1A7V2MSnYwdbeJ0YtV6sOX8s
         kdhg==
In-Reply-To: <1347977530-29755-9-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, Suleiman Souhlal <suleiman@google.com>, Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>

On Tue, Sep 18, 2012 at 5:12 PM, Glauber Costa <glommer@parallels.com> wrote:
> diff --git a/mm/slab.c b/mm/slab.c
> index e2cf984..f2d760c 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -4141,8 +4141,19 @@ static int do_tune_cpucache(struct kmem_cache *cachep, int limit,
>  static int enable_cpucache(struct kmem_cache *cachep, gfp_t gfp)
>  {
>         int err;
> -       int limit, shared;
> -
> +       int limit = 0;
> +       int shared = 0;
> +       int batchcount = 0;
> +
> +#ifdef CONFIG_MEMCG_KMEM
> +       if (cachep->memcg_params.parent) {
> +               limit = cachep->memcg_params.parent->limit;
> +               shared = cachep->memcg_params.parent->shared;
> +               batchcount = cachep->memcg_params.parent->batchcount;

Style nit: please introduce a variable for
"cachep->memcg_params.parent" to make this human-readable.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
