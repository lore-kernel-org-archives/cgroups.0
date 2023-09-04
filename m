From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v4 3/4] mm: memcg: let non-unified root stats flushes
 help unified flushes
Date: Mon, 4 Sep 2023 17:29:14 +0200
Message-ID: <6tne52ip62ucev7nmnim3m7fhcydnwcytyxynrlxxgaf4cbqea@r4hec425izap>
References: <20230831165611.2610118-1-yosryahmed@google.com>
 <20230831165611.2610118-4-yosryahmed@google.com>
 <ZPXupwjewuLgksAI@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="syrk2v4vngqj4sdi"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1693841356; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dJLufghybCMa24PDpvfycL/ikAXyEs0VewOCLgkv2eg=;
        b=j299Sc/TsT+nZFscMydQEj2Gnb7vTxcXBX03rHpI6p62mNFZ0JNS37/wHT+lxSh8I4HRio
        T7WshfgDW2/PHpCAFYArzL5GQ/X6MIYbfmkqyng04a5RByI7GD2aQt+OrG4IbPK7KD9Wl4
        qrNllUW9brGOnw5F/f9Q580XqOYnNUk=
Content-Disposition: inline
In-Reply-To: <ZPXupwjewuLgksAI-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--syrk2v4vngqj4sdi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello.

On Mon, Sep 04, 2023 at 04:50:15PM +0200, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> I have hard time to follow why we really want/need this. Does this cause
> any observable changes to the behavior?

Behavior change depends on how much userspace triggers the root memcg
flush, from nothing to effectively offloading flushing to userspace tasks.
(Theory^^^)

It keeps stats_flush_threshold up to date representing global error
estimate so that error-tolerant readers may save their time and it keeps
the reasoning about the stats_flush_threshold effect simple.

Michal

--syrk2v4vngqj4sdi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZPX3wwAKCRAGvrMr/1gc
jrH9AQDraTQKzMHznCeTIWsFz0m6SziVQ0WMnHb90hQ5OGjzQQD/dPHTWpaxgO+S
ff5xBhybWn1PrJqNeXXnqzuYpF1d/gA=
=ACcJ
-----END PGP SIGNATURE-----

--syrk2v4vngqj4sdi--
