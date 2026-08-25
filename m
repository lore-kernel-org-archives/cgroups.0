Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F693485CD1
	for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 14:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787669286; cv=none; b=gJ2udfXJrkRj283qMqcN/i4cL/cd7qMy7luCMz/4y2/hKSuInnsp0fGYpip8kTD+Rk4zf5iWDHGWbyF+LPPB4KMY7EqDWsIcQ7gigePVuG8rQ+pIrP7LgwsPmfeRtnh+olGHP8iie5uPdm5ScLRVOAWDj9ZcIzrvAsm8VUpupqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787669286; c=relaxed/simple;
	bh=pzHvhf/kcUn1uGQQoMmmsZdAbSQgFg/DB45H52WF0/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H6YtWNRvtH9JVe9Q7SqGPPWbDiril34v0uXwA25u+zQ7kw8gjrKuxIt6CWq+nDPfjKOsBf5LnHi8ZwzwWgu+nNH6egaFNMhunt2xhy3PKK9dqUsd8+/Qa694r8wPFxPwCN+YHoQlaVSYg/CAStYoF3LAtus0koso2Mury0I38RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QZxxNM14; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=qZsXYCQg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QZxxNM14";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="qZsXYCQg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787669277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6s1XusrMHrXnvzwU6UboxiHzAtGjQbneiTvP5eiCfbQ=;
	b=QZxxNM14PlXY3erNql86FCv3plRA3wi1X40oGzVVXDKGtys8SlgwbggGTlGMcAd48r8Pnv
	9hcCmWpQAq5cpNShll4q/iwA14OmhPTcAS+pEUnyMpk7WK4e+fuu/fczxzsI1YGwWV2BrS
	bLHq0bIDDBeAtn3LtSYuILYuygajLq0=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-371-lhmEvHAjMp29av6HyZIO6A-1; Tue, 25 Aug 2026 10:47:56 -0400
X-MC-Unique: lhmEvHAjMp29av6HyZIO6A-1
X-Mimecast-MFC-AGG-ID: lhmEvHAjMp29av6HyZIO6A_1787669275
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-9375d92d8cdso379128585a.2
        for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 07:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787669275; x=1788274075; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6s1XusrMHrXnvzwU6UboxiHzAtGjQbneiTvP5eiCfbQ=;
        b=qZsXYCQg0NcRrl7FoyWeU9aVLadAaFI5eoIdcamwsj3oq/aHNZllmiigvELzLiCzpL
         K0TjfSf/+Fdlo5+wkJc2dXQIyFKRWLta9hlLN7GLmaR77QVOoouajeRg6SWDKVNIYnWO
         dKTdm76ZRaIWWwmP1ccSTiJFapcI3SQZRzQmHx48G3XLkChevTDvHes81cPP9EUkkjs4
         2aSyZjHysL0+zJS6OgCcKF1VBRN30520Nzws+AVKQZNwOk+hvtEXPUmh/+fJhZP6gFBf
         e7MIOGBuNCwjBSAM/GQNdwz+bGT1d8WCj1ER6nLmXBDNK0bXBaoMozUalybvFbfLuQML
         pHnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787669275; x=1788274075;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6s1XusrMHrXnvzwU6UboxiHzAtGjQbneiTvP5eiCfbQ=;
        b=st/SYE7SfiY2pkPoe4sn89MBdBX47GGuNFa5ZAG1jQFMOLuKNpCp49gde/3VAUHlAa
         erOj76IwhAQALKC1DIGA2gybwza40qMsj8GsFgVFInDmVMOxTwQQ7aXaGwwjA40YnF98
         PUCNkDP3mwNyiVNgIA1AHpkET//QP9qFDbH6BXL8ZvuqdvsUWeylWJXk6lIEBg9P1Tkp
         p/uryK95CAaYVvOIuJUkrNHMj7ony+83TM5Rp9gj1x1k5C0u5hFPmldISygdoO8eXzPB
         Sr5lFO4ZOxDucOBpeMXdNAVr50GOq1dkSNa9Y+ALvXKTf8uFvRWoV0jPhffovt9hiBzY
         HM0g==
X-Forwarded-Encrypted: i=1; AHgh+RrW7tRML3RkO/uu1uTw5e0fLlkfY07IBzH/TmES/DqmbqmoFdZ4srTH/pFir+WY/0dh4gARlDdS@vger.kernel.org
X-Gm-Message-State: AFuF++kXEUKEzwqhZaM0/ZSoOhzHqKv9zYMrpMZv1eJF16K5FYwkVibX
	HMozP7NO1uRKou++56ohVjN6OC775PDfowVqfbQZBj5zuzyuB6MQJpAILFw1M69gyqwvg6wV0Al
	uAQJLu/xKsJ7kY98459AKapEwlLV60udrQxiE5JkYqBwaAlHjycxaQ1mF6dQ=
X-Gm-Gg: AR+sD12WufS8RiO9uddO9hO5PjIHGq8VFSgquM9mGAfJzceWo15gd0J+OC9edP50Qd6
	lGqlwzt/Mq+/03CejYkvclLVXF2kw+Ryd0hB9R3AwGjfSUsGwAvMnmLK9Jv049HHwl89H7uVwC/
	exmsaEtQ7xgbJQnVae5YPTQBCkq4NUDLrjVCmnd4GTQmS1ctoOkWti1CGzYehjN4yATSI+1lar4
	EZGuUraZTZLaGEoNdf2ePosUwrAaB89eIuRvUlNhlefDLDtZECokkcmkisLwTiZwl+k/zOD0PPG
	zX0BK9LJnL582voprJlwff5Ffy5RZZSuXJZmWuMFBMcRrLQ5XWF4b6z8AO6b7W+Jhr5l/FfD66O
	wrNkoU2MdvgJFgZNIffYEWP0r0pV6rRbDAP/F6yT9iCkm
X-Received: by 2002:a05:620a:a413:10b0:936:d35d:204 with SMTP id af79cd13be357-937468b3248mr1928934985a.13.1787669275400;
        Tue, 25 Aug 2026 07:47:55 -0700 (PDT)
X-Received: by 2002:a05:620a:a413:10b0:936:d35d:204 with SMTP id af79cd13be357-937468b3248mr1928929085a.13.1787669274849;
        Tue, 25 Aug 2026 07:47:54 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93749abeba9sm745605585a.3.2026.08.25.07.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 07:47:54 -0700 (PDT)
Date: Tue, 25 Aug 2026 10:47:53 -0400
From: Eric Chanudet <echanude@redhat.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Message-ID: <ao2gA_m3BCBu2esy@echanude-thinkpadx1carbongen13.rmtusma.csb>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <aowHqqaqK7TeexQH@tiehlicka>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aowHqqaqK7TeexQH@tiehlicka>

On Mon, Aug 24, 2026 at 10:58:18AM +0200, Michal Hocko wrote:
> On Fri 21-08-26 14:56:52, Eric Chanudet wrote:
> > CMA allocations are currently unaccounted for by cgroup memory
> > controllers. As system resources, they should fall under memcg, but CMA
> > areas partition the available space for different purposes and memcg
> > doesn't have a good representation for that.
> 
> Which CMA usecases are covered by this work? It would be also great to
> spend more time describing usecases.

We would like to offer some usage guaranties to userspace processes
ending up doing allocations in CMA.

For example, a shared CMA area is described in device-tree for an ARM64
platforms. Userspace components could then, for example, allocate from
it through the dmabuf heap, or a device or framework-specific ioctl for
that matter, to use the buffer with sensors. The dtb may have other CMA
areas described additionally that may or may not be used by that
component. In this context, we would like the ability to limit one of
the userspace component to over-allocate and choke the other(s). memcg
looked like a good fit to achieve this, albeit handling the areas, so a
cgroup has a quota in a given CMA resource.

This trails from an earlier post where we tried doing this using
dmem[1], but I was unable to reconcile the requirement for memcg
accounting[2] since from dmem I didn't have memory objects to charge nor
the guaranty there was one. Given CMA is always system memory, it looked
like a better fit to try something without dmem.

Best,

[1] https://lore.kernel.org/all/20260519-cgroup-dmem-memcg-double-charge-v2-0-db4d1407062b@redhat.com/
[2] https://lore.kernel.org/all/ahB7pCu_G4vuswc0@linux.dev/

> -- 
> Michal Hocko
> SUSE Labs
> 

-- 
Eric Chanudet

