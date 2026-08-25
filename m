Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD2D484241
	for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 14:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787669679; cv=none; b=Fon6dhtnn+KHpoLW7+fOBptRdUcY5zjCWbbhmFEyjyJ8YD+czk9zK9Ch0vgeSzPh2JzFJzx+0MQXs+Gu7ug2xxDIOjHkVixtlVBdODDmyS8axY29INBfalHh8LsgQP1W8SOVGxWiBIJIXpaN9wFaPZClcLPjx3pDPYO8m04PPzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787669679; c=relaxed/simple;
	bh=zwUVJRPwaRqENGbYEecI9EZN1Ls2VD+gRIwnQhAVUYM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pd/u0V2+5YtFR0d40uVsjUpe+fAp6/to4F3m7J25hVI/ZTPVdNBKigH/X4SDBFRXY+YgUcs/aGK9snMUrFIaR4FZdiwPHcWhTrzmrCMsPp3YJ6LSknaX3gHfrQ55IM/G+jdAk4MM+aKkuQS+l45tM6SZNZrUS/EU2Uj60sclLZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BQ1zw6pC; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=o91fCOG3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BQ1zw6pC";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="o91fCOG3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787669670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2GckowvKcKSZKNqS6mM8Rx6dNZPUZzNliQME9DsHgsg=;
	b=BQ1zw6pCFF/cPq0HS56lnLknJWOMdAImS2r6HZhJSvY/ZqxXP4sC5DOP/y+79AM37dNZyJ
	S5S2ZbZfefu2i7YiV3KAgZzaHu4vfGhzub33tsKCitXzGMMLc/bDI2CoNBa5vzc+SteXRB
	DAo10R7vFq9goWVGER/AUQlbu7QKuYg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-208-7iIHwpU7MWq-kH8AMP8iCA-1; Tue, 25 Aug 2026 10:54:27 -0400
X-MC-Unique: 7iIHwpU7MWq-kH8AMP8iCA-1
X-Mimecast-MFC-AGG-ID: 7iIHwpU7MWq-kH8AMP8iCA_1787669667
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-90cc540a846so1167486d6.0
        for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 07:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787669667; x=1788274467; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2GckowvKcKSZKNqS6mM8Rx6dNZPUZzNliQME9DsHgsg=;
        b=o91fCOG3kJFbBAD564MDlenbKozQD3/VX9LsYdwCX6bSbJHxEYDzTQgfEMqBQIEism
         kv6MVxcLap7hVn8d6XlTv5MvWWMoCz+3nKn7LwQeu52wP8ohwuxaqhOD9UdTrEuAJp15
         mFq/ztI+4CE/HrE/LCcO7rgdFHLazgkjLsQIPlCBCVaNHAIJWyaqqT6yYWFbhZI8il+T
         QTURnzVB4jIny840BSolVdta2e15vR5F+dOEmZ13zARPmrQIpBRv9Jih6Xw7LmW8Os2/
         E3zX8VWzsJWrxCSWpmIl1NTNqdRLBi+vIrwf4VcrvrmsAvljIFKstzPeob+TYhExHh2r
         g6vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787669667; x=1788274467;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=2GckowvKcKSZKNqS6mM8Rx6dNZPUZzNliQME9DsHgsg=;
        b=W52sg7WNOOVUjARb6kWKXhGi4wUF16bGCxzOhDbKcztDfsEhtCGm8/lbGW1zVEFVkZ
         ffPIGh5f96bjgVMPBPAh7ACfClFlUJEXcri2OcvBCcrjIQ6Cc+89WAq1pNnmdsLJuVQM
         NRg/WIWfvMWSs3PHSe9t2viI29jtN4orYOgYbgibWjqGQeziHDY0db7NPV1d7eoTfLGM
         8S12FWMNnH5FyMAlzgFyWRi3F5HY2703viyV8a1cjP/o8AhyvPDzYZs0aBfBbTLiIuJy
         LrzSVjHEX9fpBQG6aMeUkWMywLRB/ysmK08CxaLaPatc+f0kPrJeHTuiBwFEyeeaP8Pz
         ZFAQ==
X-Forwarded-Encrypted: i=1; AHgh+RrMPunArgpKSyXLjpXywdr6EQWAGCA9kLAykhLkblDPR8zuIuNBBoBvALLsM+b+DCRaPq5SOem1@vger.kernel.org
X-Gm-Message-State: AFuF++kIkt2gAnMYZznZsArC2WuDk5btG2T37gqbf3oG+qowuF7aIVjJ
	W71I2uB6kCHbRkD3w8wj35TbKXEGJsSJsnmhyU+8JgXqRXuWtfvhSVB0K1Rhp4yJ74zZX2idS4j
	Yt39QMk7z4PCNtvyR/PbLPt5kaPxkXFmfV3PdlG4SmSufZVLq8QxCPgqLTzo=
X-Gm-Gg: AR+sD12/xqxQAweb1yE7d3EIJrezuIJy9lC8IIJWQGpM2Lythq+koxgfKAyRHLMapMs
	8LIHLyJEtZbtBjBnG7fRhTPIwLiOztR1XRCzZxLGpjgUT3lrEIadKWWuArfeX3whvn9OHm8D8aZ
	gcNnVm3K/ILQxFbA1Rlqjg7tUMW6Uy8qGwms8ht8eWbFnHTHWanm+0ZfXSJbfe+Tt2sQ5JBNdLn
	A7YlzNYR1g5mliqbfvW1GSyeGKqQUyVIUuhDXVgZSvW/hjaG6Dmeuh53yCvMLer2oGlwFHlvfVM
	TGBRKNvxGQVo7dpd3CkjdIeFCAoHofe2Fimz6px+Cr+3JyqimE1xVjLMy2yI4bYjEbLGpB6Zx7l
	ndeB6lcrBzJVoaaWZJNgG/faHL2ewBdL/ytd7VlqwvkEI
X-Received: by 2002:a05:6214:4304:b0:908:7fce:f111 with SMTP id 6a1803df08f44-90c80c13e25mr416128716d6.6.1787669667131;
        Tue, 25 Aug 2026 07:54:27 -0700 (PDT)
X-Received: by 2002:a05:6214:4304:b0:908:7fce:f111 with SMTP id 6a1803df08f44-90c80c13e25mr416127656d6.6.1787669666433;
        Tue, 25 Aug 2026 07:54:26 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90cc63e8d21sm592276d6.13.2026.08.25.07.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 07:54:25 -0700 (PDT)
Date: Tue, 25 Aug 2026 10:54:24 -0400
From: Eric Chanudet <echanude@redhat.com>
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Message-ID: <ao2rHli8HUCJ8h8Q@echanude-thinkpadx1carbongen13.rmtusma.csb>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <aoxEGzZ1eVzIU8xH@localhost.localdomain>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aoxEGzZ1eVzIU8xH@localhost.localdomain>

On Mon, Aug 24, 2026 at 03:18:54PM +0200, Michal Koutný wrote:
> Hi Eric.
> 
> On Fri, Aug 21, 2026 at 02:56:52PM -0400, Eric Chanudet <echanude@redhat.com> wrote:
> > Finally register the per-area usage counters in the cgroupfs. Each CMA
> > area creates a memory.cma.<area>.{current,max} pair for reporting and
> > limitation for each area.
> 
> These areas quite resemble dmem regions.
> What is the relation to the previous dmem double-charging [1]?
> (Successor, alternative,...)

They are, although I did not make it clear in the cover letter, my bad.

This is a CMA centric alternative to the other series that tried to
issue the memcg charge through dmem[1]. CMA seemed to better fit under
memcg directly as I couldn't find a solution on how to correctly charge
memcg once in dmem where it was determined to double-charge or not.

[1] https://lore.kernel.org/all/20260519-cgroup-dmem-memcg-double-charge-v2-0-db4d1407062b@redhat.com/

> 
> Thanks,
> Michal



-- 
Eric Chanudet

