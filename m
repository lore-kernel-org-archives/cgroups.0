From: "Paul E. McKenney" <paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] selftests: cgroup: fix test_kmem_basic false positives
Date: Tue, 1 Aug 2023 09:39:28 -0700
Message-ID: <c40ca485-f52e-411a-9f33-3adabc53c0fc@paulmck-laptop>
References: <20230801135632.1768830-1-hannes@cmpxchg.org>
Reply-To: paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690907969;
        bh=peOB4gYXHi9+NQFqAEhqF+m0ecPnTZOeDb0Ne46VrRw=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=sstKmFBZwEw5V1wDtDA9C654z/Yt8zMozmuZHnlnXA+FW1Bfr3b4cWTxtjWqAVrMc
         DGtbYQFs7QmqFA7SlAYC0oArqV3nFtR4/0L4aN7rkwIo83nqld1sh7qIz7oBdHAR9i
         kWqZ66M4DSoRCfRCezLkRP5GmObapL0IaVJeb+prgzS2jCu0lsFrTMet1a6E59wBeS
         cJR78bviYofqm3PhnqJ4cHr6D4hD10UeWMTjXBosOQISY7JvEccmRLNse6D3BpiG6R
         1/i/Z4AXElHXBtgQTqbP1oxoGtE0IF18eC5+32UBmpx4NFOPrmEUvG1h06FdZEjCb7
         pG1VVo7qCb6Lw==
Content-Disposition: inline
In-Reply-To: <20230801135632.1768830-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Aug 01, 2023 at 09:56:32AM -0400, Johannes Weiner wrote:
> This test fails routinely in our prod testing environment, and I can
> reproduce it locally as well.
> 
> The test allocates dcache inside a cgroup, then drops the memory limit
> and checks that usage drops correspondingly. The reason it fails is
> because dentries are freed with an RCU delay - a debugging sleep shows
> that usage drops as expected shortly after.
> 
> Insert a 1s sleep after dropping the limit. This should be good
> enough, assuming that machines running those tests are otherwise not
> very busy.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

I am putting together something more formal, but this will certainly
improve things, as Johannes says, assuming the system goes mostly
idle during that one-second wait.  So:

Acked-by: Paul E. McKenney <paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Yes, there are corner cases, such as the system having millions of
RCU callbacks queued and being unable to invoke them all during that
one-second interval.  But that is a corner case, and that is exactly
why I will be putting together something more formal.  ;-)

							Thanx, Paul

> ---
>  tools/testing/selftests/cgroup/test_kmem.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/selftests/cgroup/test_kmem.c
> index 258ddc565deb..1b2cec9d18a4 100644
> --- a/tools/testing/selftests/cgroup/test_kmem.c
> +++ b/tools/testing/selftests/cgroup/test_kmem.c
> @@ -70,6 +70,10 @@ static int test_kmem_basic(const char *root)
>  		goto cleanup;
>  
>  	cg_write(cg, "memory.high", "1M");
> +
> +	/* wait for RCU freeing */
> +	sleep(1);
> +
>  	slab1 = cg_read_key_long(cg, "memory.stat", "slab ");
>  	if (slab1 <= 0)
>  		goto cleanup;
> -- 
> 2.41.0
> 
