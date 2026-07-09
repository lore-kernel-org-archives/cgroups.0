Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04661F3D56
	for <cgroups@vger.kernel.org>; Thu,  9 Jul 2026 15:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783611576; cv=none; b=V7iLiKOMi+UjqhrWict7hTuZmqjN+eEuXr9oRQkWlwhe0CNvDmOQdKTGwTkdYqygi3+Nszg7ff1ll2DrPBl+ovIdolgWnEWKj14+7dJSONIMGhRvZ55cWzzMXmtHhouO8KHDJhl9+hW99NqQjzZwI4Kh46HncNmSTe7co1CpUDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783611576; c=relaxed/simple;
	bh=R07iPGczI9CMuDV0hOy0iNA4x3E3zIrOkLWW9OgU5bY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iFhbEast0Lrs/ZBcn6OHZkP26XvXccmfZ3iRc6tD4HG9+3izQrePTdQ7bklCEMNpGgyHWthlQXoQdf494fa+XPn3NaL3fE+rWpaWNSFn7uxMlnC5KQo10mwQZUybjOeAJyTM8XPQ3t41HvhGAkLAc2wymWUBqpWO6NhuEd+05KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MW/3wwQs; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MW/3wwQs"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-84537d04408so101554b3a.0
        for <cgroups@vger.kernel.org>; Thu, 09 Jul 2026 08:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783611574; x=1784216374; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lXXGap0Q/LiZLJdfHOXl3AEYRU8Fj6byPx+ImpQAltY=;
        b=MW/3wwQsArRbjmfHx+GQxCpb6sE0rnlhThiXJj//cFt2f/8ukD5D8wdhC426OqIWU1
         coDhkkEQcyW3icnPBFtdEGu6nv64V1ASjWaxf8kEImoFA8WhIvzYWXCG5fIK5Fazeml6
         glcLUAuT2vjIh/U2dSYGGIppYT8sBIHT1nK6VLDIOCo+ILE0J5cJ1BA6adfL9Ka9/JHL
         J8PpRSMhN7bDh20AciNAFPBOzLspj+nFr13DYWSBM24UqISksYiE2jMpsYQ0NLXlzQwL
         V2AQ7BY9wmuZWBxGQvUlBfZgzrojL3pd/OTO9rYULPM8oecXJO0oq4YtuxlQi6UWyrhT
         mNrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783611574; x=1784216374;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lXXGap0Q/LiZLJdfHOXl3AEYRU8Fj6byPx+ImpQAltY=;
        b=X+TJmyuPnJwkuNlwR6/aKGQFVgqq5g6WOHLBbCptJyuew1wEZR59HkZM61R262T5jy
         65kxj/JTshuTaOQJmJJEmYYfbEJaoN5RXKIatlkT6eO23zatyYXZDjEX9N1uDuiCDA/p
         vMwS176wQwOv3rrM1YdlZ9w2RyC2aU9nlrW7xxzhF0s4jODsyH1pYLdgssXAdkS7+vJ5
         02FsRgofSTU2npjgu8nO+P7GamYdL2Y73zkNQui69FFV0Y4WbaMRqqQIFsw5jCKqw+k3
         54zmVFhk6ubLRh9jwloxmtKCXUJrwKLpnodQj/YW8gWWnYnffqzfTFd2EN0oWfAnrAyM
         Lghg==
X-Forwarded-Encrypted: i=1; AHgh+RppRbLlZllRwib1RsmdEh7wivup5i6lzSGw8WO7Xw8Jr3NrFl7O7/Y9sSsHXb/JH9T5EPb/lo7N@vger.kernel.org
X-Gm-Message-State: AOJu0YwacsyFfjwViliksjCFNpo4vjxZssQc755xmBlY+aF3bYTmHJXu
	UiIlTJ1QEMjekMAH6Ig8GeaCXbmES82Md/vgg8hB5ZXBCP5Xqgb+Hx08
X-Gm-Gg: AfdE7cl5UtXiSR0TSZVH5Dj8GNdC2dtUErKEFyYNmEjCBCgbS5MFzDzR1/GdXLd4yy1
	fB9BYzzat2cXu4BNeKFzvTDTQslwSqrEVbETWxhdxrM2YIcfFL/ps5sXutoCY+6w6WhzbzLI5fK
	J/PH6fxxM5HNPg7JzflTt+D+mwCUHcn2NN8ZS/EATkB60OXUfPsNCRKXl+VTtYw4vK1xmtNRqA3
	lgI24eyf4iOeWi2GGjfidwKTgJh+AFjAT0520iokAe6EoSavMdwsZSTbRrbkZ87yS5ojwq6cXju
	LIJ0meZWJNmNUPJGzIl9QRxY0EBbdfxOlFFPya8olpERa+cj/UI5RZoEVYrv0JyJ1WZFAJiROYo
	Yyy5jzCfs6TKmi9Te8O2uf56WKAmxnhkdTjjell+xyiHO2cBKnMA/Q2SMNFFboQH31GVeRe/Lnm
	tX3a9TkVP+euEOFdyDrxBpuRpyTT3bJA3KbgqHrETTHOSuPv5BdLfnk9Q=
X-Received: by 2002:a05:6a00:a93:b0:847:8971:87d8 with SMTP id d2e1a72fcca58-848560021c5mr3191674b3a.6.1783611574014;
        Thu, 09 Jul 2026 08:39:34 -0700 (PDT)
Received: from debian.lan ([240e:391:ea3:6910::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84856d5d619sm1491303b3a.39.2026.07.09.08.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 08:39:33 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: hannes@cmpxchg.org
Cc: xueyuan.chen21@gmail.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	baohua@kernel.org,
	zhaonanzhe@xiaomi.com,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com
Subject: Re: [RFC PATCH v2 2/3] mm: distinguish large folio swap allocation failures
Date: Thu,  9 Jul 2026 23:39:24 +0800
Message-ID: <20260709153924.772408-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <ak-4d67hVnC2_BBH@cmpxchg.org>
References: <ak-4d67hVnC2_BBH@cmpxchg.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On Thu, Jul 09, 2026 at 11:04:23AM -0400, Johannes Weiner wrote:

Hi Johannes,

>On Thu, Jul 09, 2026 at 11:01:12AM -0400, Johannes Weiner wrote:
>> On Thu, Jul 09, 2026 at 10:51:23PM +0800, Xueyuan Chen wrote:
>> > @@ -5550,10 +5558,7 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
>> >  
>> >  	if (mem_cgroup_disabled() || do_memsw_account())
>> >  		return nr_swap_pages;
>> > -	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg))
>> > -		nr_swap_pages = min_t(long, nr_swap_pages,
>> > -				      READ_ONCE(memcg->swap.max) -
>> > -				      page_counter_read(&memcg->swap));
>> > +	nr_swap_pages = min(nr_swap_pages, page_counter_margin(&memcg->swap));
>> 
>> This hunk is unrelated to this patch. Don't mix refactor work with new
>> functionality. Make the previous patch a pure refactor job (where you
>> add page_counter_margin() and use it here ^), like I had proposed.

You're right, that refactor doesn't belong in patch 2.

>I also liked my version of mem_cgroup_get_nr_swap_pages() a bit
>better. Please just use my patch, keep the From: and you can add
>
>Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>

I'll use your version in v3, keep your From: and Signed-off-by, and make
patch 1 a pure refactor patch that adds page_counter_margin() and
converts mem_cgroup_get_nr_swap_pages() to use it.

Patch 2 will only keep the functional folio_alloc_swap()/memcg charge
changes.

Thanks,
Xueyuan
