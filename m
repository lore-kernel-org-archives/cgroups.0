From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/3] mm: memcg: add a helper for non-unified stats
 flushing
Date: Tue, 22 Aug 2023 18:35:00 +0200
Message-ID: <5y3e32ek6owren3q5e3gzonzxzdhs53ihywj3mtbhz56hnizfy@fctafygsnfaq>
References: <20230821205458.1764662-1-yosryahmed@google.com>
 <20230821205458.1764662-3-yosryahmed@google.com>
 <y7vvyndehadwy5ouounm5oyo52bqhsysiizuphzki2h3bwpdpc@3hvaq6sp6f4k>
 <CAJD7tkaVuiMU-ifJiyH5d_W1hi9DnAymYJxzBxEKCVX+tU=OCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7f63xjlvpzzrd5op"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1692722101; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Qt0ZLoOqT9+wpCm2Ny+8HuPkuahGjnCugCYXd8XlMx4=;
        b=Pax4caF2Ef7NBtayR04STCzFqckSNupMb66tw35QjhgWvF9+wKzVgjJBg9YlG0KcbLsLZ2
        oCi24HsoJGkFuND2JYvuNfi4s3gIN/HH/BaylrFafuhYEdWG+9nZ1ta4ax3RchF+ksp0vy
        C1CLitUshYgpH557xXomFZYOIxXdAA8=
Content-Disposition: inline
In-Reply-To: <CAJD7tkaVuiMU-ifJiyH5d_W1hi9DnAymYJxzBxEKCVX+tU=OCA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--7f63xjlvpzzrd5op
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 22, 2023 at 09:00:06AM -0700, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> We can probably also kick FLUSH_TIME forward as well.

True, they guard same work.

> Perhaps I can move both into do_stats_flush() then. If I understand
> correctly this is what you mean?

Yes.

> What do you think?

The latter is certainly better looking code.

I wasn't sure at first about moving stats_flush_threshold reset before
actual flush but on second thought it should not be a significant change
- readers: may skip flushing, the values that they read should still be
  below the error threshold,
- writers: may be slowed down a bit (because of conditional atomic write
  optimization in memcg_rstat_updates), presumably not on average
  though.

So the latter should work too.

Michal

--7f63xjlvpzzrd5op
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZOTjsgAKCRAGvrMr/1gc
jnZMAP9j2epDKDEIrW1B1fJASKjVt5dkRJM2SCYyQNX6oNKqUAEAnUs7Pg88u8E/
lU8WkkS7hOz1ZQ2abpo1AtoV7nqS6QU=
=FEfo
-----END PGP SIGNATURE-----

--7f63xjlvpzzrd5op--
