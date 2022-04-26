From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH v2 1/5] cgroups: Refactor children cgroups in memcg tests
Date: Mon, 25 Apr 2022 18:56:08 -0700
Message-ID: <YmdROKOEfiP1rk8q@carbon>
References: <20220423155619.3669555-1-void@manifault.com>
 <20220423155619.3669555-2-void@manifault.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1650938176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eknS5mZjx4pi0PW50DuACc81xMEJlhElzkFotI9xECI=;
        b=Zy5KwFrskWKcY3bLKvYR+K/romXFvT8ubAkmxpL922s/9KYhDYlCYyxcYgBNWmO6yRbAyC
        IFVV3DYFHNBmr/F90mhh7Pla2zpFxQqPYO7rgaZdV6JsTx9RICKkLRnpAIprEhvq78S2W5
        GPndu/sXoZVZyLWfyONdz6s6ipZHESo=
Content-Disposition: inline
In-Reply-To: <20220423155619.3669555-2-void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Sat, Apr 23, 2022 at 08:56:17AM -0700, David Vernet wrote:
> In test_memcg_min() and test_memcg_low(), there is an array of four sibling
> cgroups. All but one of these sibling groups does a 50MB allocation, and
> the group that does no allocation is the third of four in the array.  This
> is not a problem per se, but makes it a bit tricky to do some assertions in
> test_memcg_low(), as we want to make assertions on the siblings based on
> whether or not they performed allocations. Having a static index before
> which all groups have performed an allocation makes this cleaner.
> 
> This patch therefore reorders the sibling groups so that the group that
> performs no allocations is the last in the array. A follow-on patch will
> leverage this to fix a bug in the test that incorrectly asserts that a
> sibling group that had performed an allocation, but only had protection
> from its parent, will not observe any memory.events.low events during
> reclaim.
> 
> Signed-off-by: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>

Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

Thanks!
