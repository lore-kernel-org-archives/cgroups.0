Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C62E455175
	for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 14:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787670005; cv=none; b=kMpG4tcRUV5iPgCsnVEPzP5MCytrAvt+MQDKewkDSulRll2zoAESPF427+h4k548fDZIGeSmeka6XNnb9XccQgfdyxcHQJPBtd4NyHQH3wHTNen7COtD9ZiQXUst+RlfKsbZXoj4stgyp75cky4BMNG2H/kzKB6SqxV8PQM6sA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787670005; c=relaxed/simple;
	bh=Dpw4rtPNIhmMqn7wNJpVZncgvMPX1xG1jtECbsm5Vj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AUYoW45Nd+wNNzOENieys82azqDrRQbBG0HjEl73Jd5fzbJI5FxD/0MUdPXH3gF+5FsP94sG+Fk6G5uydwWNmyvipO4iVLjxqPOL2ZVQO7ZlA4nOUmZB7rM9qCiZnJYxoeuvencx9mNqYgHh3lfjRrDcS6HT+OGDDugNL1vW5Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TaE266Wd; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TaE266Wd"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6a10d02ff43so9459646a12.0
        for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 07:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787669994; x=1788274794; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=06QgDRd3KsQRNkIC849obH3kyg/ANunDmHU+Cwu/Xpo=;
        b=TaE266Wdpq6iQsaokirOQEe4P7Up3BdlXLynmT2tdAbixOEuLgylVj3/ONXvl240Gd
         XOLYm886a43G/NjFMJ33EcK8dDdAF8cWS2NjjOSAOCi/rn3fBe6u1Xf46fSqOz0o12vP
         0NCt4aZ2NjrKTVBvUJcnqgg2YsyNY3FQf6ac7Ri5KEa4HPcYlg9grx4a/Bh2eRo/ySMh
         EfRT/nmlHsNWGm2LzStmUJKh/TnnICIE1HpJkousfGkVO80IXxLWxA2pGFPVoaN4b/E0
         OON4P1FJEenXJhGzsZd3QJewKyf27NhyFqrq2x7/1/1Q9a2TThPF5/J+SdFoRzCBHCuh
         SgLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787669994; x=1788274794;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=06QgDRd3KsQRNkIC849obH3kyg/ANunDmHU+Cwu/Xpo=;
        b=QeLlHri4894Cw8Eo7ONjBHR04g5n9npi1ARLfaEdxTJxzGLDCEwFpHBVEJLn1madHE
         d11FIF14yybvIutl4r7cKXZRUsiyjdfJkZcs9VvWp4RC4cFPySozmrQF9XjTyoeFy7Gf
         /1HF2vJO0bwGe8EBof4o1jk2t7KL5mbkyx7NiCZw0AWrphXBnpRCYtyHqxv3XUkNgzll
         ArfHexeZY2t0kZ7MkEAfxZ4wuL3+7dmt4PTiZjz/8GRmsmvSVytq9w+bGiFRJaDB9qJ2
         zFOYDgSFGorfyO7JMoVOejDUQVKFsymelbBLS3nM49FUISQO6EdeWG/zenn9MRhV23dN
         Qqgg==
X-Forwarded-Encrypted: i=1; AHgh+RpWtDKHA5ikZ0Cd5x54f6TcaPjWbAnovI3+3nJeIEc/S96+7b+DmpVsDk0vZtklVHduegFd6p5E@vger.kernel.org
X-Gm-Message-State: AFuF++kGRZLNW7pPwnsSef9YZseVAbzjceynHnlDMnl/917cyYOJnJNT
	qv3HWxXT/Kmk9KTGWeaY8zSgtcFgo7QNgLWS04EyMt25eJEtRFX6a4OQXW3PM0JQ20I=
X-Gm-Gg: AR+sD11TQz+7zQ3jojuijNfCwdqzgxnHY8avSucVvdJdfcKv7Emt4Haz/GBlnKmRbDG
	w0Q8R5SHXEWTyEADOrKOa5HknkuicpvrFcJLQTqgnE4KqidG8EgCvv9Dzw21se8xse5O5Hkgk3V
	1jHuqrM1sThfZWhDWmd+VsrYwzE7N5xmMteHLLZfk3lDYB1bwcaVXdAIjMmLLSutgZAO7A1lsPe
	2+7/wk859OGoS/BLwt2vPOyf+Wiv/hnp3LJYAawI5rzsm8jXfihS8yGcAdtRH4Ei89fKi+02ZD3
	nan2xZkZPWj1UpJZ2hrfVONJ0Ulhfub5pnt3gs2cjtdQ6ZRLTIAQKM/Y5QwKHbm6nZEB9RxWR4u
	fq1+qS+fnzQBSl1fx/MAYliYmXa51hYRi/Akv5ml2kWiwo08hUbaImfOxP6uQklfi0/CWDLnvdf
	d9Yoz+L+VKIKzjZ8SkjVazYoODpx8pe3/bPFRxUmWWjPYJo4dU45DN51Q1gqxiFL0Liho8Ig4=
X-Received: by 2002:a17:907:b048:20b0:c20:1c9c:b36f with SMTP id a640c23a62f3a-c246a4b154amr2894042866b.8.1787669994328;
        Tue, 25 Aug 2026 07:59:54 -0700 (PDT)
Received: from localhost (109-81-80-32.rct.o2.cz. [109.81.80.32])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249606a905sm2134790566b.13.2026.08.25.07.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 07:59:53 -0700 (PDT)
Date: Tue, 25 Aug 2026 16:59:52 +0200
From: Michal Hocko <mhocko@suse.com>
To: Eric Chanudet <echanude@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>,
	Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Message-ID: <ao2t6HP-Zt5KDg30@tiehlicka>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <aowHqqaqK7TeexQH@tiehlicka>
 <ao2gA_m3BCBu2esy@echanude-thinkpadx1carbongen13.rmtusma.csb>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao2gA_m3BCBu2esy@echanude-thinkpadx1carbongen13.rmtusma.csb>

On Tue 25-08-26 10:47:53, Eric Chanudet wrote:
> On Mon, Aug 24, 2026 at 10:58:18AM +0200, Michal Hocko wrote:
> > On Fri 21-08-26 14:56:52, Eric Chanudet wrote:
> > > CMA allocations are currently unaccounted for by cgroup memory
> > > controllers. As system resources, they should fall under memcg, but CMA
> > > areas partition the available space for different purposes and memcg
> > > doesn't have a good representation for that.
> > 
> > Which CMA usecases are covered by this work? It would be also great to
> > spend more time describing usecases.
> 
> We would like to offer some usage guaranties to userspace processes
> ending up doing allocations in CMA.
> 
> For example, a shared CMA area is described in device-tree for an ARM64
> platforms. Userspace components could then, for example, allocate from
> it through the dmabuf heap, or a device or framework-specific ioctl for
> that matter, to use the buffer with sensors. The dtb may have other CMA
> areas described additionally that may or may not be used by that
> component. In this context, we would like the ability to limit one of
> the userspace component to over-allocate and choke the other(s).

How exactly is this supposed to work? How is the CMA access controled
and opted in for accounting. What happens when memcg limits are hit. And
many more details, please.

> memcg
> looked like a good fit to achieve this, albeit handling the areas, so a
> cgroup has a quota in a given CMA resource.

Please expand more on why do you think this fits into the memcg model.
AFAIU we are talking about a unreclaimable memory and reservations of
CMA areas.

> This trails from an earlier post where we tried doing this using
> dmem[1], but I was unable to reconcile the requirement for memcg
> accounting[2] since from dmem I didn't have memory objects to charge nor
> the guaranty there was one. Given CMA is always system memory, it looked
> like a better fit to try something without dmem.
> 
> Best,
> 
> [1] https://lore.kernel.org/all/20260519-cgroup-dmem-memcg-double-charge-v2-0-db4d1407062b@redhat.com/
> [2] https://lore.kernel.org/all/ahB7pCu_G4vuswc0@linux.dev/
> 
> > -- 
> > Michal Hocko
> > SUSE Labs
> > 
> 
> -- 
> Eric Chanudet

-- 
Michal Hocko
SUSE Labs
