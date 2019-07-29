From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH RFC] mm/memcontrol: reclaim severe usage over high limit
 in get_user_pages loop
Date: Mon, 29 Jul 2019 11:49:52 -0400
Message-ID: <20190729154952.GC21958@cmpxchg.org>
References: <156431697805.3170.6377599347542228221.stgit@buzz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uUW0YKHPLieEQydyNjaqE+DPJSP/Cf4fqcZtPwBzjUQ=;
        b=Cc+rnM3wvWjLyuINuMWXDGs5fxT5e9t10JNduKKSfTicMo308IATLLWRf1HbfpWVFJ
         b9HvoMhkEEadSy05edUEx8sn1mVyofmiYp6O2xYQvx9A1WtU4SuHaPssop3lf5ncDbCt
         yG5gMY4JLtex+4bR+Q44glXssu1lBsGRrlcGVKY1Zanm/FcxXPu9Lpcm8BrKG2Kqswp+
         rb3AJRXbn4R0hDAXhtZXs3XIx2+JoGwvRFnm4k9C4FTS9vMmF8Ya9luCi/wweOUwz+Vp
         ouAIcGKMhFgKox4L1g3oYilw3A/fOpStl9pHs6Z5h8qQlenPlAGWPeZVHxefOnX7b/y2
         zufw==
Content-Disposition: inline
In-Reply-To: <156431697805.3170.6377599347542228221.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>

On Sun, Jul 28, 2019 at 03:29:38PM +0300, Konstantin Khlebnikov wrote:
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -847,8 +847,11 @@ static long __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
>  			ret = -ERESTARTSYS;
>  			goto out;
>  		}
> -		cond_resched();
>  
> +		/* Reclaim memory over high limit before stocking too much */
> +		mem_cgroup_handle_over_high(true);

I'd rather this remained part of the try_charge() call. The code
comment in try_charge says this:

	 * We can perform reclaim here if __GFP_RECLAIM but let's
	 * always punt for simplicity and so that GFP_KERNEL can
	 * consistently be used during reclaim.

The simplicity argument doesn't hold true anymore once we have to add
manual calls into allocation sites. We should instead fix try_charge()
to do synchronous reclaim for __GFP_RECLAIM and only punt to userspace
return when actually needed.
