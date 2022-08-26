From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH bpf-next v9 1/5] bpf: Introduce cgroup iter
Date: Fri, 26 Aug 2022 18:57:59 +0200
Message-ID: <20220826165759.GA30475@blackbody.suse.cz>
References: <20220824030031.1013441-1-haoluo@google.com>
 <20220824030031.1013441-2-haoluo@google.com>
 <20220825152455.GA29058@blackbody.suse.cz>
 <CA+khW7hdciswrjhY19uQu0rAurWXbfb4xuOYEZqXETu954=-sA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661533081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HS6suzfimgcX49bwowySd7vxBltKHbEMB2e3PjKhmGc=;
        b=bBddGvKpe0UmGgiX8JfudWgFaahhSoOCRX6du44L21ceY7MHbTmViYLYoE+qg7oVuzwHP1
        HlsCzJVHQG4VZenGr9Oy4eIszlc5mhTuTAXGi5Owkrv89VKeU7g3GvzuGmW5MI3TPCrarA
        4UEaMwg/izOd061mpJpRyjI0S500beo=
Content-Disposition: inline
In-Reply-To: <CA+khW7hdciswrjhY19uQu0rAurWXbfb4xuOYEZqXETu954=-sA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Martin KaFai Lau <martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 25, 2022 at 11:56:11AM -0700, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> Michal, this patch series has merged. Do you need me to send your
> patch on your behalf, or you want to do it yourself?

I added some more fixups. Continuation at [1].

Thanks,
Michal

[1] https://lore.kernel.org/r/20220826165238.30915-1-mkoutny-IBi9RG/b67k@public.gmane.org/


--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCYwj7kAAKCRAkDQmsBEOq
uTtEAP994SXoW7qIIWHKut58dTNgXsZ5qIYJ4bcHfCZDi2Vl0gD/U717nbJsE694
Hwve+ftlMVPjFoarSc3ohEgcwawK3gs=
=w1mO
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
