Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411F551CF6B
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 12:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790167224; cv=none; b=XcbBilmq6wzPrBgIIHT5vy0OZOWS9Vf3Fjnewdyr8l0O/Bew3CqEI2FIzavOYbLo5O8nrFFJHlB/Lr8sHBH42EYhFSe+TSyBcTUvuxbc3tHwCICxAumqqLN8fX04oM0zBtoMTViizaQqwk/Ul0hekZPO1JNjN81DtVTRy51HEFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790167224; c=relaxed/simple;
	bh=OuZ8YWn9k/k6Oru5iFZlYbbmFNh1wlAXq+ln8CUZHXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f8WAaXpe8ZCGwwqpV5V4TE8h2h8NGzciTnLK0uNpUsWsDWn6pAytxvdc44kw+mpN7jpNAtN8q4lqr6co75oz9Q5qRGyFEW9l3RgLRNRto25KZjn+LvoxTVTjSrXae3Yt3VMEgIKhSPLBt3ZTLuPGfcb4deR5rZYK0sEBNWdp4Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PfVZHEr2; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PfVZHEr2"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cd5462b69so4748525e9.1
        for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 05:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790167221; x=1790772021; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TdBLUyvMtWr6klMUk5a/hwwvszeiGBeUfZaFfQvLAEA=;
        b=PfVZHEr2+mR/LU5erEQzBSM7jLkdibSU1Gb1niSmd//SoXb3aCz24BbGYYWr186gfg
         ZBKWOW6nCVbnUntntaDmxCZMtJ2aYV8XItVawaH1s13poN9dCYgOCfzwOnYuJjgVX6in
         xLSckdxBeU5G/vVVJaphgOWNQWGY9cuTwBJwjufOjeI6BxXvDjFgmYN8IF8shoXbHrKB
         MKzp8/1Jkv2RB3HIQ3E2d6ihHlun6RFDodc3wwv0JGa5jK+HH9hMX6xbipMNlN7RBZ+I
         HEQjz4kMuagSTz+MM4MkC2h9WvlSaCFtqI/qBa1DnUWe358hAEp5fqcywiYZhC1eNDzM
         Ylzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790167221; x=1790772021;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TdBLUyvMtWr6klMUk5a/hwwvszeiGBeUfZaFfQvLAEA=;
        b=ByI8YIsaciE+T097D55RWREByeubf6aCr2CwvDz0rzk2jxbq8ufHosYMPLQp15jcAH
         CZzx5FQScS4IrWqgF8pN3PMzFZfdGRhsZOgnYsn9niDlM3GnuEVvJgkohcpE7UTC/qvE
         jrjuWRaGLcTF20tLSSu3UcCWK8L5f+sSltNbmZhBgCrEdbo6n593j4TWipp/hlfz4vKv
         pEw9cpb/yMax3JH9CSYv7s7GWRqZqTNvGJUYRLdckVLBZSRMZU4R6UPoC2M7wX3MxlWG
         naqewJGFm3SkBPFCQmMeJ5MI8oE2aSl6KNhWBtHBtzNnZwlV8tF5vodG7PQByikHaY++
         Au9g==
X-Forwarded-Encrypted: i=1; AKwUvBzkZ3ckScoMS1KaTA+q5JmOtVOR2kD3K4FbYD1Zh0pNwHyxaK5tzUMGMW1oGFat/KE1V20Jb8lA@vger.kernel.org
X-Gm-Message-State: AFuF++kxDa3m7tXY0xKyEgBziT/479W/GKSQleaCDX1ak9qP7hI7fKRu
	n4BVa2d0TIO2p3CyqLOa1RZgwKHvTDngXv0XeVuDnHdVPYvsbbxatPTMbQyvAfCnS5s=
X-Gm-Gg: AYBFou1EvODX8wWoypQ+v8W7tlzpqbY+XZSJNGs1KqIsmDcnpuUM801aelWOqn0nbdQ
	cg24TQuXa30xY8pNWTa52Gg3Mpg+Oh6lIhOjdFpkF+/KbZCsYlcCwi+6tZhXTF1zTt5EYivOevq
	GPiej+2cwsffg9warMInRWrUIAJl9ZnbDebPWP3l+PTPQgpMdo9LC2fZ2mi07uzj6dCke70jqFg
	En4JvfzNT1pgbt6QZyV3bJEZSVoxUzwA8JrMZsLpFw745AVSEEF619cu2jNjTre5Vb8pp8L+fuP
	2Amsma+NlCx39PyWN6bmC038H1qGmHrw+RGkNNmpPfZSSxCgKEhBTEWUyys9PVms8+QdIXCS6pc
	7h5Mfk7dPNFg+oxhJzVGUmTHsCosbJ+mUPztTzNrmeqCNJdBGI8cqOdm7nkbCnmUyCNq3GpFvdF
	tEz9PhrDiwpdxqdiWogLx/5gA55SVDs5crx6/qVi9NOXbsELS7Te+pFWotfha7XfRds9aJCjnzp
	A==
X-Received: by 2002:a05:600d:8643:20b0:49f:bc0d:2e9 with SMTP id 5b1f17b1804b1-49fdfd90205mr23203125e9.0.1790167221389;
        Wed, 23 Sep 2026 05:40:21 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4886876c119sm7240332f8f.15.2026.09.23.05.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 05:40:20 -0700 (PDT)
Date: Wed, 23 Sep 2026 14:40:18 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Qinyun Tan <qinyuntan@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Usama Arif <usama.arif@linux.dev>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Xunlei Pang <xlpang@linux.alibaba.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] mm: restore per-memcg reclaim for NONSLAB
 shrinkers under nokmem
Message-ID: <arPGEda3po0-Mbh6@localhost.localdomain>
References: <20260910080722.3961351-1-qinyuntan@linux.alibaba.com>
 <20260922183547.788d21b89868bf820e94cc62@linux-foundation.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jduqwrsbz2lze7tg"
Content-Disposition: inline
In-Reply-To: <20260922183547.788d21b89868bf820e94cc62@linux-foundation.org>


--jduqwrsbz2lze7tg
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3 0/4] mm: restore per-memcg reclaim for NONSLAB
 shrinkers under nokmem
MIME-Version: 1.0

On Tue, Sep 22, 2026 at 06:35:47PM -0700, Andrew Morton <akpm@linux-foundat=
ion.org> wrote:
> On Thu, 10 Sep 2026 16:07:18 +0800 Qinyun Tan <qinyuntan@linux.alibaba.co=
m> wrote:
>=20
> > With cgroup.memory=3Dnokmem, the THP deferred split shrinker and the
> > zswap shrinker are degraded in two ways.
>=20
> Obvious question which may have recently been addressed:
>=20
> Why are we keeping nokmem around?  How useful are its memory savings
> and is anyone actually using it?

Besides (not so significant) memory savings, there are also runtime
savings (not spending time with accounting of each kernel allocation)
and environmnents where shared (not)accounting of kernel objects is
preferred (as other resources than memory are shared anyways).

The above are IMO justifiable reasons and I know such users.

HTH,
Michal

--jduqwrsbz2lze7tg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCarPImhsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AhuYwEAq+e3Y6FWb+6/NZTcNcD/
OwbFXuc9bSQF8eyv2blq63IA/3OX78kjmj6FDtiaJ3JiP6ozQ4i+Uppjk/m6YUto
JN8K
=dA2e
-----END PGP SIGNATURE-----

--jduqwrsbz2lze7tg--
