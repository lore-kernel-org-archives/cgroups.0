Received: from mail-oi2-f12.google.com (mail-oi2-f12.google.com [74.125.231.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9504F5DE1
	for <cgroups@vger.kernel.org>; Thu, 17 Sep 2026 17:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667826; cv=none; b=pJhaJt4mve/pKLEh22zm+1azbUvRwCKdvFH6bdotb2Sx6AjfLSimLpTWWzhAXiqYz5Swu60w05/qJxps1ZKVDlgAF4c0OdLxAl83aJTvq9HnH835vYpnRQmt4+sRaMg2eGkFcyvm3usULbmOTw7yKWcf/+joxznrt5ThPgttSbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667826; c=relaxed/simple;
	bh=puSlUV2kHgNle66pG3NUaKXN4ZatxoIWNs+bOAAg7a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SaXv2VksH9Kc5LLjCwY5bbh6fOw2apNlx340N3fVRxQCvyIU5C4nr/yMozSLIEh/IYuYSAWYa2j9bJwvFjJuQTKXVGRuVNeAlDb5PI/pbNllrtM5eB9V6s+B/SaMGXkWb6pr/jMHeLCk/qYbE0Us2vHkZEldErw33jQKMk8LZxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CZQ34fQw; arc=none smtp.client-ip=74.125.231.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CZQ34fQw"
Received: by mail-oi2-f12.google.com with SMTP id 5614622812f47-4b5c61966d0so625579b6e.3
        for <cgroups@vger.kernel.org>; Thu, 17 Sep 2026 10:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789667823; x=1790272623; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vbjWNmPKTP4kQU9l/195vv1JQgSjVzz8hVj2Dw5IYw8=;
        b=CZQ34fQwI0k9m4tf7gOpbbBgIeRTuHVr+9hWtW7Qu4g/UMnfygTqTuR3l6FAXScCS/
         BoVdbf5yg4d28j3e5aS9O/2lSiXXYBA+WNsa0vYUIhXREHc1dgLXtluAUAjLPNjV0EJO
         q+/K3SVRZFpG3+FwbgzfRD571Fk00tq1JOI2I26zXgwi74DOnjZZOjDHIVDsZq+cXwQH
         12444B/7CowDXyiYRN0UKoQDjaUa/WIknq9OMlrC3cfkJmDCDIAXQY6Pcp/Hier4q9QC
         u8yhIo5sWBXOaQJzJTnj1ZZGc3+8EdDBl4tgUkdw2jS5GYCytzmJGH8JIQ2XG4lOb0+y
         s76Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789667823; x=1790272623;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vbjWNmPKTP4kQU9l/195vv1JQgSjVzz8hVj2Dw5IYw8=;
        b=g6tN5Z4p15OkEOhEyJ8F8IYjWh1diGVbqu5Qh7eqkLyzTlfvG0WkAR34/aNNBdz4ou
         XvXE5UJAh3QfGOAHzyBlzi59BctvJxIpvaKx1Gd3JBqDtEnv6zdyNCUN86PZ6CjkuMxi
         99Ua5b3KqmoqRu/WrQzVG2Mf+SkKWbGcSRxKiUl19UmUOD6jq3cuS4RwkWvWFVd5xqpK
         DDg1f4a5MhexWNxQyRcyZ2kFTn1RElEH53+dCCo+TpOzbMyoBaa9zGL0y23CwO93bL+J
         BPJkMfKDjniPdj4gOckOkaSu4JChNgbzK4r4PiaCUJsp52hD8+KRm6etgKI5iQz2yCIC
         tKWA==
X-Forwarded-Encrypted: i=1; AKwUvBzRsu0Yg49XL4reID5Tfso7V4+qQ5cnLAy7/fpsj7L61J4Y9geqRA4o+XL9V0oO/Vsqi5nr9GOP@vger.kernel.org
X-Gm-Message-State: AFuF++lpCjZzCngeGIsevGUJDHQ7o19k0m8FmY662ikl7hSCGGGgwem2
	exZUBBg5IV9nnTdvkdih23IoK1BOVYZvuNojL2fN2zcuVzImm5Ff7TCO
X-Gm-Gg: AYBFou3khN042bzLVAqSX4Ddbhtk0NJqNRgt+MdRwsJv/de8U7UbtTaTbUy/4IAtb1o
	NLz5lJf1qDDoW8aZJIzkblCq3MOkjrYkLywivnC2I7G6yl+uRZNqMU96lFUo4/BHVDYGU6FCtEw
	4L+//UTdsRrCdTwtbzkstdbowMYkAk0kAEo5uhjQh3l0fVUToiHgxTCAbJSn++CaMGrlalNsnsc
	9Lyl1Oz2q0OW59I72UCJG663lbJ1B9x8PMK6hcroCRcm+rpd+EazZmsViVwBt2U5VEdvCUUr/V1
	wmfhMeEii5UfJbaAUqjP9jGpTnznQHqJb67XGKqSA9H8+etUahgB04is0f6JzZxPGaktoMuVdk+
	if5uWpdwiFX7iGjHclMop4PFqS+UYH8MjJyD1kAvHXTB96VNswLSF0bNXPOtdHgaaZ2FgGpYBDy
	/DUUFdlyDit/d6b1cV5+TDS+VD8A8nP20Q/7eSTK96dyT3icKilsWEZPgk0AbGbEnwbJ3cszuvN
	Sy99qXHUDFSpwW/W6IfdzebgW+MVw==
X-Received: by 2002:a05:6808:5190:b0:4b9:e5fa:8906 with SMTP id 5614622812f47-4ca4b643e8bmr7461249b6e.25.1789667823338;
        Thu, 17 Sep 2026 10:57:03 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:23::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4cb6cc42831sm3206625b6e.7.2026.09.17.10.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 10:57:03 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v6 0/5] mm/page_counter: move stock from mem_cgroup to page_counter
Date: Thu, 17 Sep 2026 10:57:00 -0700
Message-ID: <20260917175701.2343946-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260916210552.891730-1-joshua.hahnjy@gmail.com>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 16 Sep 2026 14:05:46 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> v5 --> v6
> =========
> Following feedback that v5 combined the (1) stock abstraction move from
> memcg to page_counter and (2) changing the allocation / draining
> behavior, v6 limits itself to only the first goal. It retains the
> existing seven-slot per-CPU design and drain policy.
> 
> INTRODUCTION
> ============
> Memcg keeps a per-CPU stock of precharged pages so that small, frequent
> allocations do not walk the page_counter hierarchy every time.
> Today, the stock implementation is within memcontrol code, even though
> the operation it caches is a page_counter charge. This makes it
> difficult to add new page_counters to a memcg and preserve the fast
> path behavior.
> 
> This matters for future work like my tiered memcg limits series [1]
> which introduces multiple new page_counters to memcg. Without making
> stock a page_counter-level property, it means that every memcg charge
> now goes through multiple page_counter hierarchy walks, instead of
> being able to cache these charges.
> 
> To make future page_counters scalable and performant, move stock from
> mem_cgroup to page_counter so that each page_counter can opt into its
> own per-CPU cache of pre-charged pages.
> 
> We get an added benefit of simplifying try_charge_memcg code, which now
> has all the stock management handled transparently within the
> page_counter layer.

Sashiko raised one bug for the series:

 @@ -192,11 +245,20 @@ bool page_counter_try_charge(struct page_counter *counter,
  				WRITE_ONCE(c->watermark, new);
  		}
  	}
 +	if (charge > nr_pages)
 +		page_counter_refill_stock(counter, charge - nr_pages);
 +	if (nr_charged)
 +		*nr_charged = charge;
  	return true;

 failed:

And asked: Does this unconditionally report the batched size to the
caller even if the excess was rejected by the stock and uncharged from
the hierarchy?

---

This is true, but this is already the behavior for vanilla memcg.
In this series I'm hoping to preserve all existing semantics without
changing behaviors, so I can fix this problem in a separate issue.

Specifically, in vanilla try_charge_memcg:

done_restock:
	if (batch > nr_pages)
		refill_stock(memcg, batch - nr_pages);

...
			current->memcg_nr_pages_over_high += batch;

So I've just preserved the exact semantics that we used to have before.

The problem isn't that big anyways though, it's a transient inflation
in memcg_over_high and will be wiped on the next high handling run,
and there is no effect on accounting or permanent inflations.

So I think this issue is pre-existing and a minor transient inflation
for memcg_over_high at best. If this looks problematic I can write an
orthogonal fix separately.

Thanks anyways, Sashiko!
Joshua
