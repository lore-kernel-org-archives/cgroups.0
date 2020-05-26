From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH mm v5 RESEND 1/4] mm: prepare for swap over-high
 accounting and penalty calculation
Date: Tue, 26 May 2020 10:35:32 -0400
Message-ID: <20200526143532.GA848026@cmpxchg.org>
References: <20200521002411.3963032-1-kuba@kernel.org>
 <20200521002411.3963032-2-kuba@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kbXXCHKsbJxEBFGuFNxmnV1nB1pn7eVIzOVnQZl39BE=;
        b=L41qAU2gVYT6UQ3/bOvbAXNg6uvd0q5EUUFQIWCXmgMneAL7lD1EO+7yxopAGmBbf6
         gGVngFiyuJSjMD2/r4cxhC6nCZjpKYWRUpQ4lVcjOr7I8x9nXJL+LTGwoJh6imPZ4pCW
         BK0EI6BZWvYC6Q7984gFkoEgnMohmZO+bhIpboR9rO5xjdqymQVbE/TYU/pHJsbUnHGo
         UeJSseAupE6xTe2UkbOBVICNEroCr0oe2oaH0xdJwz9R4KwPiT5Dw1C1vnZ49PK5BsRa
         DQkaNdfm9ioT835YuZU7btJAX7o0+yeeLkYXr+b5WcxrQwbAA/N0oY2e1SqTvBmFePuH
         P0Yg==
Content-Disposition: inline
In-Reply-To: <20200521002411.3963032-2-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On Wed, May 20, 2020 at 05:24:08PM -0700, Jakub Kicinski wrote:
> Slice the memory overage calculation logic a little bit so we can
> reuse it to apply a similar penalty to the swap. The logic which
> accesses the memory-specific fields (use and high values) has to
> be taken out of calculate_high_delay().
> 
> Signed-off-by: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
