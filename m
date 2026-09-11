Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EBB3749F2
	for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 15:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789139846; cv=none; b=lGSUlNhpIdIheTGQLHgkyCzUc8X8HVSoP4GnxXPXekxVoG4D+RWnBHjn7X9+Xl9euZV8eBal+afzzWdWH5NAR4N8Wpjq/DwwfTXGjJ2HHVe8LE043tBqAXfT6TaGdJKn8P7kZvj+dFasUL2HMVLjhyq4yvhK+4ssFnEvBFYj+08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789139846; c=relaxed/simple;
	bh=2JzqsoiLxocAa5D2L3SPzdIZsS+OW1mUD+PJx4LQgiw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wh3wL783fMX9aVxLx1fJe3IFnHkMx13ZzZvgoJvmsUCO5vthmFmW0wy/uqpYIokEN4BAr7jW0l0xWsoGonbGOOshOmK2WEaaNWlrpqaKeQPNcUE6pCQujPLFNYsVxUotGmRewj3+Ayj1LK9G6NAu3pF1xGkaTFjy0AmN+iiOpdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=I6RtdCym; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="I6RtdCym"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6a173ad7cf4so1595621a12.3
        for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 08:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789139843; x=1789744643; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2JzqsoiLxocAa5D2L3SPzdIZsS+OW1mUD+PJx4LQgiw=;
        b=I6RtdCymQit8YVXUfVke0ZwgoF+2b4Tc/vK0eZ2VUZDUJChIYtI6CnGF4+IqV5FMy3
         LOyeMJAaPO2kxMgLgb1ATDws207sX2VFKoAFTuMzLtypckeKCdP8poCGi+BBj04Lfq+D
         kG9uHWBdcrp47SkdypV1RxuPCBKHyoJhlalbk3yJG1h39CeiZQW7rqBlpHHhXbIcxNDJ
         1CDfNWCv8YLccrEGqj9XLOO7+0cvtgfU4Jl2JwaD/kkPq/DrsUYm+ycsaBjzpikCU2xH
         OaOTgz7S78hceZxdyxmBLUuED4unG6DduCxil069rY9oJ3424QX13qkDmAkBTb1egp9j
         UO9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789139843; x=1789744643;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2JzqsoiLxocAa5D2L3SPzdIZsS+OW1mUD+PJx4LQgiw=;
        b=IUzddS5qP8q9APNaCkOZOejAK9eadhrfz7Vvx7eusGbb95gLhEdP7+FWE4JwN6Rl74
         jJ8JbP+WYjNAmxxAgDB+HXIx93EoEqb6teXaFYqLtmfM7b0GntgkR0BfW8rfb0KFXWzy
         QWzZeMKsj0wvWy3dCkH12Cyo6e6EYnX2LdYuwaFEVg9wTxotSukFLF67LhGbl5nVaYh4
         B2esAyzOZIQW9bFjOOAjymTLdZINjqCkQ9/GB8ogDSegzNIGPRklUXddg6n2kkaTuXNQ
         61ayveDQJe+FLpIwYBvXyNNDNbBPxBleMl15AV8viC+oPq4hRzSOtaSXPyfCGgEsHl2I
         NBlA==
X-Forwarded-Encrypted: i=1; AKwUvBzmbwBRIuepPCDQE4Jory4RM1USM9xRvjYjAYAncp8NKY1N8nTK6GTku5fj4OjS7XaK7VzhOKXG@vger.kernel.org
X-Gm-Message-State: AFuF++kXraVw+To8rh1WttXI1LjCNRm/WFc2qFvnN3sgIvAT8P8DdY4I
	o3WjtAe07MKKnqTMlI7v62/l+1HehxqAQjEM+xN/K2X1tckbC/sWsN10zq9BcCpVKLM=
X-Gm-Gg: AYBFou3GCjjCKyOqbOx5xbwJ4y7B7xpRoLQFO2Ja9xhx95MI1RdbcHxB/at6ViA3tDo
	K2D1U5AFarfgSRViz+77FYN7Thu3i2u2s2ePupgHe5A+uw3j34G4FrkzS6G6cCeFKiXo7dwHHFr
	aez+BL0VAYYTGdMaUYC6WtxNhf2NmAM6KpoKtsXzFY5ToOV8o1HacQ7OrEjoK1cnT702qh/4Ywa
	kqP5qZBry3ScS7JcGvLlFQ1qV1aMcXy8i/sdXmUIUcH962+p6usQid5z8KxQJQvOTAKb72t2cud
	J8m6Mfe0V5XPltOHeHk3vQA24zyrmh0OI0F9coEOa8ubnb6zuTdhkEsg0aFAq3Wr9JIyqGrMiOz
	EOQVj7FxHubsvAhrPUjSDnFWx4FKdN8/SiiZQjRZHxnyyB8f0d3mbpeXmjMf1EJpjMTXigtsHy+
	hPfnBUmP3oDNYvqVleFWMf9cWX03jCGS0tkTPHs23+Z/8O6hJH/orecE4Gcv1wwwbIPAJzXZmxk
	g==
X-Received: by 2002:a17:906:6a03:b0:c29:45ce:85ad with SMTP id a640c23a62f3a-c29667f24c6mr225571866b.1.1789139843199;
        Fri, 11 Sep 2026 08:17:23 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2966026e2esm93138666b.19.2026.09.11.08.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 08:17:22 -0700 (PDT)
Date: Fri, 11 Sep 2026 17:17:20 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: linuszeng@tencent.com
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
	Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	Jingxiang Zeng <jingxiangzeng.cas@gmail.com>, Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2 0/3] mm: page_counter: move hierarchical protection
 out of struct page_counter
Message-ID: <aqQZus_Cc3mRiuXn@localhost.localdomain>
References: <20260909-descriptive-name-v2-0-d7dd7c099049@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ozrropszbqjorccy"
Content-Disposition: inline
In-Reply-To: <20260909-descriptive-name-v2-0-d7dd7c099049@tencent.com>


--ozrropszbqjorccy
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH v2 0/3] mm: page_counter: move hierarchical protection
 out of struct page_counter
MIME-Version: 1.0

Hi.

On Wed, Sep 09, 2026 at 05:44:18PM +0800, linuszeng via B4 Relay <devnull+linuszeng.tencent.com@kernel.org> wrote:
> No functional change is intended: protection semantics and the cgroup
> v1/v2 behaviour are preserved.

It is not clear from the description what is the intention then :-)

Do you have any measurements that the reduced cache footprint
changes performance for setups without protection?
And what is the positive impact on protected scenarios where the
counters are in (possibly) different cacheline and one indirection
further?

Thanks,
Michal

--ozrropszbqjorccy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaqQbfBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AjHdwEA9eabDSoks6Xn+ni3bc0I
AP32Ul+BBWTmz5HMyoTjovoA/2JJSh5lKBEsuu0fwEMrZGzX9XiTI5mG6CHzszPG
ztkH
=VS/g
-----END PGP SIGNATURE-----

--ozrropszbqjorccy--
