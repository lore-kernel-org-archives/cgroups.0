Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E39F30596F
	for <cgroups@vger.kernel.org>; Thu, 27 Aug 2026 13:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787837320; cv=none; b=ZNWwkEQd6088kh7RIyThF/XKcXUW0LFLzcRUTCuelVqojHCry/NgN5gjZ3iavxqbfOMyYMxbAUUZh8MNlrorX6N0hBXqh15biVibVwhtnSRKez4IeJ7yat5fgflpxwLvjEqenCM6ASqZrNAS2+Dp04X6OEwymeL6Q/hmOdxtXvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787837320; c=relaxed/simple;
	bh=faP9ygWQlSRIrFbk7BiUYjG/H8pEcJDzSB8VBBaM9e4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Beo9sl3uT8JIpq/TUAxsIL5wnpjVegiUid8Mim5ik+jHAA9B8X/gi+sII2XyhSQalqTa+AqVA+TOUkzntb0FYtpPTvhHUeAeBOiqxcOqSziEZ7A/PKWM9i3IzZGod5OhG3kZt/FqcN8lpoLDG15JAFFlk8iM0+XkU46jFDf1gHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gUZtmTV3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=WdmAbWsY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gUZtmTV3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="WdmAbWsY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787837309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=faP9ygWQlSRIrFbk7BiUYjG/H8pEcJDzSB8VBBaM9e4=;
	b=gUZtmTV3MKN6TM1zG4YFx4L6xzKoEkFGZLrKsdc324upBHnWkP7LgjbRCyF4RcYTsedOXr
	ZvFQXwtKoSApvj4Oba3M+NVw7w45rnTYm1YP/54m3Olyt17GGQkN3uFt9NebdUTAxmurzh
	H9OaaKLknkYPkEmT0ko8ft9UiGT8NYU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-147-AcYhoOQJNdC4MImq0L_zsw-1; Thu, 27 Aug 2026 09:28:28 -0400
X-MC-Unique: AcYhoOQJNdC4MImq0L_zsw-1
X-Mimecast-MFC-AGG-ID: AcYhoOQJNdC4MImq0L_zsw_1787837307
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-47d81cf0c4cso1040627f8f.2
        for <cgroups@vger.kernel.org>; Thu, 27 Aug 2026 06:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787837307; x=1788442107; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=faP9ygWQlSRIrFbk7BiUYjG/H8pEcJDzSB8VBBaM9e4=;
        b=WdmAbWsYA9GBmKEovs2NOouKO5Ogd+yVS7DT81BhxNWkpV9CqFCIkEHDSewYENMjIw
         IY5OYnSrZP7YR/GOgoIJceJG9LQ9CElhIFcXoBzfRiBoMPGsmYNZIn9//jOHkzk9/h0e
         ikF7DGyLrpunJwO7zXBLgiunqbsOAhreY5KhWfeRNEAe7RL8+9h9J/Ar5LpqJFvD1tVW
         8SOXD2c4CuiL2C/gCGxpXasj8vlCcG4t6t3AsftLpABpujJanTCeGE5s9yZ2AF65LdVT
         hrCshIkU+gh7mygO20V4z46H+/AKBMk3juktoW1UUvWVozLW93SC/zLgvHhsbxSYgXjl
         v39w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787837307; x=1788442107;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=faP9ygWQlSRIrFbk7BiUYjG/H8pEcJDzSB8VBBaM9e4=;
        b=NgTEZhfj6SRPgTl+5ZIh3jtCMl/1bQmDGpmjOhipMfSiP/ij7wSSwIK59HD8DSH5XM
         6kXNpsgZggUA5GkBhrXV5F2rr3GLk4cfK1RKX8SYoeTPdW7F0NEt9sSroNxtTfjAmXPN
         anXW8OII8jSUaeyBWb0R4CxK7TcrPaYAd/o8s9qqWvYoPAZsBc5nspusqgeNhBOL6Qng
         TNoeX72JNddT7P8GR/UnQHC+tayqzigTpbslPEJgZIslV7U573LEd5pNT1i/p3S+9j6B
         rLNFYLJ6VgHeH3i6vUIoPOdwmIg3yDK/46Y2TmYaPknmKlrhB1b/FrLWfl16yagSyJWr
         nBDQ==
X-Forwarded-Encrypted: i=1; AHgh+RpnmlNkdBHPhsAFs5wUUJz4PihoNWPlS3qTLOB1q64WdmOpX0BRhpokjha1KPOb0yq7d1xEuVJf@vger.kernel.org
X-Gm-Message-State: AFuF++mmlTN+Zlz2pNgLfB1IDLPeLyW2BCvZ1A00li51fcdHUqYHls7o
	tY2j+pNFRvzjF5Mtq/0kJwAHsFFHoeVpyeGShPgcVQSQx6CUskXH08aT0imweUhaMB8288gObtD
	Nn25Vgufa+RALqtMLHx5wStGyXwzRMZV/9pTSbXFwNPmZS6wVH2r4zC1gTnw=
X-Gm-Gg: AR+sD11u94hTenz0yvdj9KTmzXffnTzmnorIVlyvNARI1nQcj/norrQj4EXrp17CK43
	rFWzWtwbgRXR38hCuK9acMtMqjs2gGiNXuAxhTtPsN7z/SRjvJAmKFW4O6uMH8tk775OKcb09GZ
	vZipPc/Ez8Ez3vx35JKnJoUIdb5eORU2m5pRrwCtzhI0CoUp7bqp3MKlfYdbWST94Ve8OthWwki
	Tz5EFKu8dGiMkvzC9BDZPU0wyQzgmSEZfqN3ljiXeCfsB6F36UWjTFrjv3K5wiqbHZiZ+yVbltK
	hKS6Uth56ibI0FqG0Sq+l0xjTNa4pIu/e9/FxRWR123z0pkNd4CJnplps45Y31AtKy83H4sktw=
	=
X-Received: by 2002:a05:6000:29ce:b0:47f:8ac0:282 with SMTP id ffacd0b85a97d-482e26c3ff0mr15609422f8f.17.1787837306996;
        Thu, 27 Aug 2026 06:28:26 -0700 (PDT)
X-Received: by 2002:a05:6000:29ce:b0:47f:8ac0:282 with SMTP id ffacd0b85a97d-482e26c3ff0mr15609319f8f.17.1787837306492;
        Thu, 27 Aug 2026 06:28:26 -0700 (PDT)
Received: from localhost ([2a01:e0a:a99:9822:ca7f:54ff:fe01:374c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482e279eb1csm9177838f8f.4.2026.08.27.06.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 06:28:25 -0700 (PDT)
Date: Thu, 27 Aug 2026 15:28:23 +0200
From: Maxime Ripard <mripard@redhat.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Eric Chanudet <echanude@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Message-ID: <20260826-brave-nyala-of-elevation-d23aea@houat>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <aowHqqaqK7TeexQH@tiehlicka>
 <ao2gA_m3BCBu2esy@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <ao2t6HP-Zt5KDg30@tiehlicka>
 <ao3UKM5SbxBmxuR0@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <ao3quaSze8YjPjxZ@tiehlicka>
 <ao3tFg4JLNlbylTR@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <ao6eC2SUIGVz3Qct@tiehlicka>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="yiahqkhps5b233tk"
Content-Disposition: inline
In-Reply-To: <ao6eC2SUIGVz3Qct@tiehlicka>


--yiahqkhps5b233tk
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
MIME-Version: 1.0

On Wed, Aug 26, 2026 at 10:04:27AM +0200, Michal Hocko wrote:
> > > You cannot really assume usecase, requirements, lifetime etc. for an
> > > arbitrary cma area. I do not think this is a viable way forward. Focus
> > > on your real usecase, which seems to be dmabufs.
> >=20
> > While dmabufs are indeed my main use case, they are quite generic and
> > may not always have system memory backing them (device memory). Working
> > at the CMA allocator alleviated these disparities.
> >=20
> > > Explain what do you want to achieve and then we can think whether mem=
cg
> > > is the right model for that usecase
> >=20
> > Hopefully I expressed this in a better way by now. In short, enforce
> > usage limits for concurrent CMA users using shared CMA resources.
>=20
> Thanks. Yes this is more clear now. And it resembles hugetlb situation
> more than memcg. You simply need a memory pool specific access and usage
> control. Dispersing that to a global memcg limit seems rather coarse and=
=20
> I would say impractical. So it really calls for a per pool control with
> an understanding of how the specific pool really works.

I'm not entirely sure what you meant there, but I think we also need to
have it account in a "global" limit somewhere. Which CMA pool is backing
a CMA device allocation is pretty unpredictable and unstable across
boots, so if userspace wants to put meaningful limits somewhat
generically, we'll need some kind of catchall limit.

Maxime

--yiahqkhps5b233tk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCapA7cgAKCRAnX84Zoj2+
di1+AYCIo8KLWPYOzEwBgbqOdUgA/zgdVT/joCROq5h9TbzGRbFQcxXH7KRg+7fJ
IKAwfJkBf0pN5A/Vo2FO2QoLXkGlaXcWUBJakY9boX9YnDyDdS+4c88lV2EjJudO
EXr1S+1vDw==
=t0iU
-----END PGP SIGNATURE-----

--yiahqkhps5b233tk--

