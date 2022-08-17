From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] mm: correctly charge compressed memory to its memcg
Date: Wed, 17 Aug 2022 10:17:01 -0700
Message-ID: <20220817101701.149fff9ef57f447dd8bb0dc9@linux-foundation.org>
References: <20220811081913.102770-1-liliguang@baidu.com>
        <YvpkK8fwCEPGmif+@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660756622;
        bh=sW2vlMqA2/k4m+CqkD1Vg77XK6jsg6cOZAQ48jZAEO4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZlumYuQX50WUifM8caT+mwnMVMdFTD+KKJBFBKSJ3IsTjf34CnZSzncE+xBuPGahC
         Tc1J2GaYoN2BbSDjpm3OC6uBY+V2aXmteyfjnUK/mhhNR5Qzfc+cji4C0GfYtdHdai
         rpTbb0iIH68t+kyo1aupJ8A3E6AvpNZRtfJRUVoc=
In-Reply-To: <YvpkK8fwCEPGmif+-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: liliguang <liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon, 15 Aug 2022 11:20:11 -0400 Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:

> Great catch. I think this qualifies for stable.
> 
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 5.19
> Fixes: f4840ccfca25 ("zswap: memcg accounting")
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> 
> Andrew, can you please take this through the MM tree?

Sure, but I'm not subscribed to cgroups@ and it wasn't cc'ed to
linux-kernel so no patch for me.

I could reconstitute it from the quoted patch but that's a bit lame and
we don't get a usable Link: tag.

So please redo, refresh, retest and resend?
