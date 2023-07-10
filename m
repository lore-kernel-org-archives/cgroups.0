From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: Expensive memory.stat + cpu.stat reads
Date: Mon, 10 Jul 2023 16:44:53 +0200
Message-ID: <gbqumqkxixvvrbbqh55rw6thgfa67tw2kkcuauc4xj5t6pnivd@3yfkokngo43w>
References: <CABWYdi0c6__rh-K7dcM_pkf9BJdTRtAU08M43KO9ME4-dsgfoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="b77s5ccberk4hrjr"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1689000295; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2dSDCIryhoqYz8ZS1bBqRNqc86fubisnGZKJq77QBlA=;
        b=ZOh9PSn4qAb49Y/vRW4RvILvHVqDNm8r7BSRKjNFgqVMKsAHnK+MLjUCMjalAB1ujYKCXP
        VH9Y13+ev6/vDr7W357nCLvnoVwnsFHEaGMUZGMQZXiDaIpzdjn2cZa1YiBoRWsDx1qnAW
        cfgvONSAD46IH0pcuEFK25CaUCcA8C8=
Content-Disposition: inline
In-Reply-To: <CABWYdi0c6__rh-K7dcM_pkf9BJdTRtAU08M43KO9ME4-dsgfoQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, kernel-team <kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


--b77s5ccberk4hrjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello.

On Fri, Jun 30, 2023 at 04:22:28PM -0700, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>=
 wrote:
> As you might've noticed from the output, splitting the loop into two
> makes the code run 10x faster.

That is curious.

> We're running Linux v6.1 (the output is from v6.1.25) with no patches
> that touch the cgroup or mm subsystems, so you can assume vanilla
> kernel.

Have you watched for this on older kernels too?

> I am happy to try out patches or to do some tracing to help understand
> this better.

I see in your reproducer you tried swapping order of controllers
flushed.=20
Have you also tried flushing same controller twice (in the inner loop)?
(Despite the expectation is that it shouldn't be different from half the
scenario where ran two loops.)

Thanks,
Michal

--b77s5ccberk4hrjr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZKwZYwAKCRAGvrMr/1gc
jkiaAP0cMXwbvKMrd3UFe9bkgPZXxl1WeME+caCgKNQqMZaS1AD/eGWbOeKD5V7A
KBibSziS+oGtgU+Wg7XvKGBFaasJZA4=
=jPdL
-----END PGP SIGNATURE-----

--b77s5ccberk4hrjr--
