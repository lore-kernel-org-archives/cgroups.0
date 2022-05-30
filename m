From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] memcg: enable accounting in keyctl subsys
Date: Mon, 30 May 2022 13:38:04 -0700
Message-ID: <20220530133804.9215aa841958e84fdfe5272f@linux-foundation.org>
References: <1626682667-10771-1-git-send-email-nglaive@gmail.com>
        <0017e4c6-84d8-6d62-2ceb-4851771fec18@linux.dev>
        <YovnzLqXqEHY6SAC@kernel.org>
        <ca0ba233-ed09-5dce-5f38-2e05b1114610@linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653943085;
        bh=EgZSRpIvza4/feORMuYAVyeFfwuHkSzhuAxB/51p+YQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T/KtKDTOjmbUAvZXUh7CFi3RvMpybj7HCsKVqlf77jkECjyf4tatE02G3y0Mp5h5b
         JgVO5LMnrDP7d/iKtZkTkK6iKsgRy6L38NFoVAC7ZOhFY5vXmz+5hn32XgKmUGCyMD
         j+CEpNd3noRQb3YxsLRy6ZkeY8m0cXEe0TCKQufw=
In-Reply-To: <ca0ba233-ed09-5dce-5f38-2e05b1114610-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Yutian Yang <nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, shenwenbo-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Mon, 30 May 2022 12:38:28 +0300 Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:

> Dear Andrew,
> could you please pick up this patch too?
> 
> ...
>
> >> Reviewed-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
>
> ...
>
> >> PS. Should I perhaps resend it?

Yes, would someone please resend.  And please also retest it - the
patch is almost a year old.

> > Acked-by: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

