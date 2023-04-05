From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 6/8] workingset: memcg: sleep when flushing stats in
 workingset_refault()
Date: Wed, 5 Apr 2023 10:00:47 +0200
Message-ID: <20230405080047.5omnatjbwz46f3y5@blackpad>
References: <20230330191801.1967435-1-yosryahmed@google.com>
 <20230330191801.1967435-7-yosryahmed@google.com>
 <20230404165305.ffs7uscqpndnfytn@blackpad>
 <CAJD7tkb-0rXL9V2TX-Ax-3OkwJPYx_GaOT4D=VCA60riit+dOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xkpos56pi67t66c5"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680681648; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NF83qlVzxv5rP31TK87fQBjgypo+iPk8Tgc/ff/LzS0=;
        b=nWYAwbTopJSeJ+HfSY6AkXfF6hH7nbJMp50CUAQdErLnNegkaTgEgfo0Xtcp3Y0Zy6IYqu
        XsFYsercb9dhTAcnh9CiJLDMkcLllZsaGQ8D5uWxucNnpWOTOwS2i2ciWfvyLP63x+kb7Z
        f8bb2+A7sVt9W5n2EwOktFXUdweSbwk=
Content-Disposition: inline
In-Reply-To: <CAJD7tkb-0rXL9V2TX-Ax-3OkwJPYx_GaOT4D=VCA60riit+dOw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>


--xkpos56pi67t66c5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 04, 2023 at 11:09:02AM -0700, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> IIUC there are multiple places where we can sleep in this path, we can
> sleep waiting for a page to be read from disk, we can sleep during
> allocating the page to read into, and IIUC the allocations on the
> fault path can even run into reclaim, going into the vmscan code. So
> there are precedents, but I am not sure if that's enough argument.

I expect it'd depend on the proportion of the slow/fast paths.
OK, let's see how it turns out in wider population.

Thanks,
Michal

--xkpos56pi67t66c5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZC0qqwAKCRAkDQmsBEOq
uQd1AP9da0usdZXtaqKldZWC3hNIo/w+tYQarhExM3TWXX+KGQEAvck6zPYNvKdu
uhY4KtMQkxSOomI7xDc/A08Ae98OjA8=
=ErRC
-----END PGP SIGNATURE-----

--xkpos56pi67t66c5--
