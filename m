From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol.c: drains percpu charge caches in
 memory.reclaim
Date: Thu, 10 Nov 2022 15:42:43 +0100
Message-ID: <20221110144243.GA10562@blackbody.suse.cz>
References: <20221110065316.67204-1-lujialin4@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1668091365; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QggOl6oet9gjyrUMq6KLf3FzSdMoYy/LwzCTm6J8+gA=;
        b=ZMS072hGRT7Bf0y9PM16lWz0Q8PM65nd78eBvUC9sFc0C1kpezgASqxeIDMK8aTmA7+k+1
        iYFDCN1izrUXQKtA2wb/YLjQSxzOThg5HHql5Iz3xnt8FvW44zm+MpzNTXDLKfVn/MuY7n
        c7Q7OCw4Yfo5nWtlAIE6hJ8bG400Igk=
Content-Disposition: inline
In-Reply-To: <20221110065316.67204-1-lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Jialin.

On Thu, Nov 10, 2022 at 02:53:16PM +0800, Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> When user use memory.reclaim to reclaim memory, after drain percpu lru
> caches, drain percpu charge caches for given memcg stock in the hope
> of introducing more evictable pages.

Do you have any data on materialization of this hope?

IIUC, the stock is useful for batched accounting to page_counter but it
doesn't represent real pages. I.e. your change may reduce the
page_counter value but it would not release any pages. Or have I missed
a way how it helps with the reclaim?

Thanks,
Michal

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY20N4QAKCRAkDQmsBEOq
ubBKAQDp1xBK5/DkToOkWZCbNxS9WdDxDYDsi9+ZeCKLncwpHQD9HaNqQZdrxab3
/hyNSLGsED0LyA/3PnNvyOufETMiWQ4=
=jyz6
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
