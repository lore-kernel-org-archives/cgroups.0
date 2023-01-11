From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 2/2] mm: multi-gen LRU: cgroup working set stats
Date: Wed, 11 Jan 2023 15:19:29 +0100
Message-ID: <20230111141929.GB14685@blackbody.suse.cz>
References: <20221214225123.2770216-1-yuanchu@google.com>
 <20221214225123.2770216-3-yuanchu@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="s2ZSL+KKDSLx8OML"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1673446770; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aKKeQDX5M27cS/Y9GBuMn/99ULlrTykEwpfkno661Kc=;
        b=to8kz4beF0J5+Jua7QNB8vFl6GUJjWv2r5Gk4VJFgzU5OoWyXI6qVdVJVqfLsAHAwBIpd+
        JcW/8PLRwK64v0/VdyJlj2HPas1hD2siFx/d3EnLP/Rsu3Zr5OxTrjTLp9kkNvY1vFT5Jj
        Psify++zY792qbyISArVvzllMunvKnM=
Content-Disposition: inline
In-Reply-To: <20221214225123.2770216-3-yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Yuanchu Xie <yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 14, 2022 at 02:51:23PM -0800, Yuanchu Xie <yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> +static int memory_page_idle_age_format(struct mem_cgroup *root,
> +				       struct seq_file *m)
> +{
> +	struct mem_cgroup *memcg;
> +	unsigned long *table;
[...]
> +	table = kmalloc_array(PAGE_IDLE_AGE_NR_RANGES * nr_node_ids *
> +				      ANON_AND_FILE,
> +			      sizeof(*table), __GFP_ZERO | GFP_KERNEL);
> +
[...]
> +	memory_page_idle_age_print(m, table);
> +	return 0;

FTR, the table seems leaked here.


Michal

--s2ZSL+KKDSLx8OML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY77FbgAKCRAkDQmsBEOq
uYurAP9JGeUGRS6AfrMninhvfGTvmei8qAImveRp13FIRINKGwEAlYRvprpP/hbL
IvrnjwZQ0UVS9+oYjQTsbbZbJVGfhgE=
=qQ2L
-----END PGP SIGNATURE-----

--s2ZSL+KKDSLx8OML--
