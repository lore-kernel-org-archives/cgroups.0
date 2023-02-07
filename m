From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/2] sched/isolation: Merge individual nohz_full features
 into a common housekeeping flag
Date: Tue, 7 Feb 2023 13:59:00 +0100
Message-ID: <20230207125900.GA24523@blackbody.suse.cz>
References: <20230203232409.163847-1-frederic@kernel.org>
 <20230203232409.163847-2-frederic@kernel.org>
 <20230206155107.GA31453@blackbody.suse.cz>
 <Y+I61dp5qPkWK4s2@lothringen>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1675774742; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7QoTLoXlIMxSw37JX85ExzUtBnHWAzOyLQ2c0uIpTLM=;
        b=IgskfTMKEaO1jmC/N1nUWksgS2w7L8hHtYNz/l/0AgYHAEeL8SvjUTb1X8N2aT+oc21fQK
        uVxDNfqkoggQQalEcTuNbwT7BnJg3edJ2qvl5KTiMunxb80wXQkiLAlWEaNbjCA56AE9lC
        dWFgdQMn5ORKYrhQw9DZoNFkuARlRtw=
Content-Disposition: inline
In-Reply-To: <Y+I61dp5qPkWK4s2@lothringen>
List-ID: <cgroups.vger.kernel.org>
To: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leonardo <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 07, 2023 at 12:49:41PM +0100, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> But what do we need these annotations for? The only outcome I've ever
> seen with these is that it confuses everyone.

Take that as a note of a lone actor then who found it useful documenting
relations between various parts of the code.

> This way I can add the support for each part smoothly.

Yeah, that makes sense.

> For example first patch moves HK_TYPE_TIMER to HK_TYPE_KERNEL_NOISE
> and unbound timers are supported by cpuset.kernel_noise, second patch
> moves HK_TYPE_WQ to HK_TYPE_KERNEL_NOISE and unbound workqueues are
> supported by cpuset.kernel_noise, etc until all of them turned by
> nohz_full= are supported...

So does this mean you'll re-introduce the finer grained HK_* flags
again?

The idea (not only mine?) is that this would extend
cpuset.cpus.partition that only allows HK_TYPE_DOMAIN analogy. The
mapping to individual flags may not be exposed to users. The graduality
could be achieved by adding more flags under user_exposed_term.

Just to be on the same page -- that's how I understand it, the original
HK_* resolution turned out impractical for users and that's why the
direction is towards some loose combinations representing user
intentions. Is that right?


Cheers,
Michal

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHQEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY+JLBQAKCRAkDQmsBEOq
udOKAPdJq+O7uJgDbO4QNyCO7NcKnOeMid700809Y9NpPfptAP94KF/OZau1bPKP
nGKv3/uKXc7NKO/TqZ2HmKeGpdNzDg==
=vDYK
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
