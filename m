Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF72433DEC2
	for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 15:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784819772; cv=none; b=qy1JvDbj9SBHzxo/ixFiWDjGhQHuWnm5b+KUiMEJ2r3IbI0BQkgi2bTDdmtHhJToWG4mjMuv3JcJwaSuQKeb+toNnU3wZxO/Mewo+S+zuhWbeHrmQZGmRvC0ke5MGL0EcSch/EiA0cZRq7gESIly4nHf2OTWOQbB15x4q2JG4JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784819772; c=relaxed/simple;
	bh=Wn73hxUvFBtMo4dZdptjR3hnsJQ/iakCzTrCgd0Rz+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uVlcgKiE1OvWmk681ZmZ6YtXKDGHiA0ViUuwCD+9WwycqPpMYXwWJX9HH54O1W18Ca5YQStiBeX9ZG9VDS737dox+4JK2Leplv2bp4Ku7d9ci3jrexWnXQyzxLRrU4zMrp3M6nUgHqIVIIeCvAHpPM4NGpuYgRVThYPYAYP0NTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nEsQFjNU; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nEsQFjNU"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cecdc24b1cso1373435ad.1
        for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 08:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784819769; x=1785424569; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=q7dX3fQLU+MQfWobvf+BU2EOiXlvtWcP5jxjjttRSJQ=;
        b=nEsQFjNUIb5/iTesqYN2IZmwsFbzQ/qCWcWrmfpDgy2woq+nEswwiWpudUIamSTVIz
         DuPt47+dxHlUXHAo6kHy7LcbCzNbQHnRkXVrGam9Sa5J5Njf40lx6vCrDGvz4Zlx8ifX
         YtahPbpvlAcucANQYXJY+zLmc7+HZNm7Gdz6wmLpdmgY892xAKXoM5SVq9JYvVtkqSRV
         N46Fa/MYh2MhBRrBfXRGeCgluvOvPwLVyiB54fDADI3UfKnItZnjoUjvh+leheAARz3q
         iNjI3kdSPvEaY0p+0lqUAlrEKl3mSiIDLWV2DOx0GKMFB1joIgbIOnCBpqI4RR490/DJ
         izmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784819769; x=1785424569;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q7dX3fQLU+MQfWobvf+BU2EOiXlvtWcP5jxjjttRSJQ=;
        b=qSog+dD5f9UJUyviYxlIW+7pHO53DmpkgjKWEILsv+6nmmzPB9U3pMC1qguIeu+ait
         aIxFmh7sd8OzXtFprHAh22YKoI3OjG1puOHuUcBoYVjUwtjXXRrosfS/ybjYe30+H/th
         +glAN+XlyQx2kdcJhxdS9tEfRboSSqkQWjy1tt851AkQh5cFghS26ROjSzKXckBrgcuj
         7d435Kp97/9LRKPagCjv1/IsTRmvfbV78vOpNa9uO5j/KnVlSyFYnkCqCy3My8I7ctHw
         bAwmkGlVk9ddSxHxSQ+WCZFe0/6h9tobw7hKy0M6/fX4kSi+ni3yMDYc4U0wW4YOY2WY
         Tmwg==
X-Forwarded-Encrypted: i=1; AHgh+RqAgzTfOXiQ1b/wwB53i4m9V1ffeXF99MhH7aBWZKR1BatlLrPjF8/S6vB8a3F9AJPoN2vjmcme@vger.kernel.org
X-Gm-Message-State: AOJu0YyBj1/SWHF524LP86KBpJMiM/Er4pizAvYcy/pNOsvS+QVKjorI
	PN78U6ywKBuGAERRuxYDILFXxKR/U+BusLpqxx0ZbQxmBky8/bShjReX5XjqmkAh5R2fdkEh
X-Gm-Gg: AR+sD12RgmS3t6gKsCdf4ck+X3D849DljRTtQIiIC+oEqkK8pKnE3ZEwrGqttl38rUW
	poHoLgsXFB2vpGEzp4Djj0fEYSj6EjaC9/GdPridMiiRUCFFtgBGyohxUwfqssQxmZFZfnoZuFZ
	6wHetTsbA/lrYDBkaG1T1UlrHjaX99jM0zaG075zZOnkery0T29b+Ne0pJsJGa8XOnjLfVIsrJk
	+hptwGUtiYy5S5kKJ4+VUgmB21i/oYcRbL5sXN1j8hGEX6IgNEk/fpNln5JdhOqp4Zxcgw2iFQn
	H88Lwb0nr6mGXZf3kf404nVXkAT4RAaoOw4k2honbM82rms2l07PNpFc7hSSSUeXOtM7ZzkZAYL
	7/c3XgDQ7SCWkiIZ27HChaff0JFLBeulj2bmLCVK8CW2Cd8eUTy4LgXI35c4nucuy05JVYp9RoX
	+xZEFJnuZCawMKa3VffLEyIarDCiPyr1ZdnNEfc/LHFtW3qOwwkDFXPd1b3q2VMXSEc1crd8Tie
	6+vzK5EcdgtVDM=
X-Received: by 2002:a17:903:1a84:b0:2cc:d6de:d58e with SMTP id d9443c01a7336-2cfbd0a553amr478115ad.4.1784819768864;
        Thu, 23 Jul 2026 08:16:08 -0700 (PDT)
Received: from debian.lan ([155.117.85.27])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8f312763sm35276065ad.61.2026.07.23.08.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 08:16:08 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: youngjun.park@lge.com
Cc: xueyuan.chen21@gmail.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	baohua@kernel.org,
	zhaonanzhe@xiaomi.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com
Subject: Re: [RFC PATCH v3 2/4] mm: distinguish large folio swap allocation failures
Date: Thu, 23 Jul 2026 23:15:47 +0800
Message-ID: <20260723151547.377588-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <al+alXxG/8XRCM3y@yjaykim-PowerEdge-T330>
References: <al+alXxG/8XRCM3y@yjaykim-PowerEdge-T330>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On Wed, Jul 22, 2026 at 01:13:09AM +0900, Youngjun Park wrote:
>On Fri, Jul 17, 2026 at 08:25:12PM +0800, Xueyuan Chen wrote:
>...
>>  	local_lock(&percpu_swap_cluster.lock);
>>  	if (!swap_alloc_fast(folio))
>> @@ -1730,11 +1734,16 @@ int folio_alloc_swap(struct folio *folio)
>>  	}
>>  	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
>> -	if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap)))
>> +	if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap,
>> +						&nr_swap_pages))) {
>>  		swap_cache_del_folio(folio);
>
>IMHO,
>If we get here the allocation succeeded and only the charge failed, so
>we already know global swap space exists.
>(And also swap_cache_del_folio right above even puts the slots back, 
>so nr_swap_pages goes up again)
>
>Could we just take the margin and decide -E2BIG or -ENOMEM from that?
>
>Youngjun
>

Thank you for the review, Youngjun. You're right.

When the memcg charge fails at this point, the swap slot allocation has
already succeeded. After swap_cache_del_folio() releases those slots,
re-reading the global free swap count may also include the slots that
were just returned, so it is not useful for classifying the charge
failure.

I changed the charge failure path to use the remaining memcg margin
alone:

	if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap,
						&swap_margin))) {
		swap_cache_del_folio(folio);
		return order && swap_margin > 0 ? -E2BIG : -ENOMEM;
	}

The global free swap count is now considered separately when classifying
swap allocation failures and the early rejection paths.

Thanks for catching this. I will include the change in the next version.

Thanks
Xueyuan
