Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793222500;
	b=s6cgPXUktnXsJc/Ax73TWrnmmvLsdNEP5lFeCPNCg/Xp7SnT5Xjtx+stmNSc2zt7viCI
	 2Sov8egkct1yq2j07THQPepU9TL85TzdNk+JDWKp427ZqT+A2THwVkpEKBn785umkie0M
	 SYUU9Ry+CI6YSVfTvBF8DoMjmhjytmLfcVXIZZ8wLcVXkTSq+ZcbPzGImbGX52kxDk0Qh
	 Bh4ooYQWkVdplrB+gCDdyEs7/hhdEaofBeLC9Ad9e7VhlG8welf4lYp5VYHCqKE3QFYMU
	 U8p8MDHv/uEPcjmz4E4hnfslDBNYte/lQQKzokrnTHPQRKARg3VI4hcgypDyWiasQjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793222500;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=/AnoOf4KaoFS/ftZh5xPkws/q1U7dINbhxvKXiKw/hw=;
	b=Y2arbfL0Y3qVucbt12ViXni7rWFFF47JgfXnRXvgEjQ3N4wh5o+gTB1UfyxvCzBpFPcZ
	 Ad7T4eOFIXAUjEEf7Dh2libcd2G0wbbg7+qElXsQ0alZm32Rf7MIibppdhPTlq9ZMpCU7
	 KeRMSp3lg4j1qcu3g011nhpZoBCzrPIo/Xtg7DcgtS1iWk+znnvd1lXVxF2nQly2txhTQ
	 2h49Hn1BHgLNBoMEkE0v4QBEnWZkLnbceRgm3oALHWRgUM+qAJbSrpmOY1Oze9P91X5vc
	 +1zMPVj6WC2/hNZFOyQ83yZ+EfGqTiPcRdXWqaiE6+ospt1MgywUo5ndtnxtFAeYeuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmpxchg.org;
	spf=pass smtp.mailfrom=cmpxchg.org;
	dkim=pass header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=C0bh0Mps;
	arc=none smtp.remote-ip=209.85.128.170
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6779C606A31F
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 21:21:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6779C606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=C0bh0Mps
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-8ae8607e8afso11996057b3.3
        for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 14:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1793222497; x=1793827297; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/AnoOf4KaoFS/ftZh5xPkws/q1U7dINbhxvKXiKw/hw=;
        b=C0bh0Mps1qm3/4kL6QqtrrocFRbdkoL6IZA3D82P0RWdr6+DOFzB8s5zW2RI8bVS2K
         Mg27GpCHXxtvNQpZkQ0yZmqL/72TEG7KSkRWdsmZIEDDitYmUvSx9qCSpt7OmPUv0Y4s
         r2eJBY/DmmL83xCy2P/sXRSP3APelzWGeej4J2Zq6ph5V+QNpKYwLpne/F0khHpkREjs
         A3dl30zWrM9zQQ0sgMSDVF2yky9YFY/9QsrLalMQrbn2vK8EI1R0TRsnqvdKtp7PnFXi
         zDCm02U7MnGPnYpz6QunJCDJikTzZWC2QMuYth2M8sI99Y/BW+ITdq+6HiGu7BxdsEwN
         8sFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793222497; x=1793827297;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/AnoOf4KaoFS/ftZh5xPkws/q1U7dINbhxvKXiKw/hw=;
        b=Y/3Zp2MtV62K6NYBWMBY66iTpaCFOG1eA0Ew0THmEMENNY5tDYQf7nRkdM5ga31/I8
         xFWlPZenYtC2F/ncfOW+3kVMzO4G7YHwwNYi8GK5pXs4OUx3z0mg4Tn4FsVOIdQvQhjI
         BRU7Pdthgvd4dhAVuS56mcEbe1Y3nOO3bXCw7+VUkH+coZ+E/fRfJ0LYhQAX7+ZdXbHu
         rB8s10WJ9RRgbs5eZcQnu+HEE+WU/uj27kDIpCevLY8J+CwpfMZi8hTn++TzJUCsNP0W
         wJo34jvY9tWBRJjo7sgHawANOgKkrhmNzXfjJ8KhNfiC29VAh0p5dskVzlw0WUY1uJad
         19EA==
X-Forwarded-Encrypted: i=1; AKwUvBxTm8Z6jTed5J+xkMnJZa2H+Po/isqi2Q853rMLIzKWfpZUIXOycrSl3E9cPASPkWOOsJWgacZV@vger.kernel.org
X-Gm-Message-State: AFq9FYJ6vNWN0hVYb7uwV8JRLXvuJPQke8lH3iOd8049vRmCJUZStpxn
	TWAFnfECe35UowzPjEXqW88iheRFS6fE8o65Psz9uNmZVQhGQnU4z4As2XXEUfRd+Do=
X-Gm-Gg: AYBFou28FBOkpSt5yAYcsZZWOUhAJbpiQ6t15YhaBqtrNApDSSaNa3VViK/0b9fHZfm
	lWg3S+t7lHG1N7ia7br9roefXXhOsmikbyEHAlwuLPor9W72r1EnDJ9rDqaJrjEIFBRolgz8Xxp
	8vS+5WWZHjkK6hDguAZny0OeS9bmd9hLpsB1OL9aOeLsjVjg+UHocwyfD7ruG2yl8kHAx7IH5Cc
	VYYSSDInwPXKVI/UfqgjAPa68I1KktmPC3lyNxorgaMagyiy8EsnklcHMcjDfgZjcRss3FCHy6+
	DqhrRmGTY/vRpLkD7aEUcHH6RUJad7xWWiiYOiCg8OLBrak8wyClk07etvbWHSwxNGwmZYESonR
	z8MxpApOIDOQwnygjNEKEROy1n84cc1szrvOBb7ZO9z7qHhXAqSRlQkrXkQx2LblOe/Cn0Y5TRf
	xYEPgInvkxLl1vbFh/FJYtgLqhfJ5X6FunxE9R/BgO6zZvfOaX7Md5IjG5BTcZzL80qPO/R3i82
	iK90DJty4oGubNulNf3+WCsd9ISj8O4qROfP9Ya9zji0+2puXPxl6Q1dDyydlJYxitJZ+XcjVaj
	Pv5K5Qso76+0RU0rFknKSjXFwaEm
X-Received: by 2002:a05:690c:c5e0:b0:8a6:1901:30d9 with SMTP id 00721157ae682-8b1b5c9952emr18568837b3.37.1793222497186;
        Wed, 28 Oct 2026 14:21:37 -0700 (PDT)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b19e566718sm35368027b3.17.2026.10.28.14.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 14:21:36 -0700 (PDT)
Date: Wed, 28 Oct 2026 17:21:36 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: roman.gushchin@linux.dev, muchun.song@linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/vmscan: remove redundant !mem_cgroup_online()
 checks
Message-ID: <auJnYNDHiAED_dtv@cmpxchg.org>
References: <20261028010611.3929937-1-tjmercier@google.com>
 <20261028010611.3929937-2-tjmercier@google.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028010611.3929937-2-tjmercier@google.com>

On Tue, Oct 27, 2026 at 06:06:05PM -0700, T.J. Mercier wrote:
> Since commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
> dying memory cgroup for LRU folios") and commit 0e0ac326c511 ("memcg:
> move LRU size accounting on reparenting instead of copying it"),
> mem_cgroup_css_offline() reparents all LRU folios to the parent memcg
> and zeroes the child's lrugen->nr_pages and lru_zone_size before the
> memcg is offlined. Nothing can repopulate the offlined memcg's lruvec
> afterwards. A folio that is off the LRU during reparenting looks up its
> lruvec through its objcg, which now points to the parent so it is put
> back on the parent's LRU.
> 
> As a result, lruvec_lru_size() and lruvec_evictable_size() are always 0
> when !mem_cgroup_online(memcg) is true, making the offlined memcg special
> cases in get_scan_count(), lruvec_is_sizable(), and shrink_one() dead
> code. Remove them.
> 
> With the get_nr_to_scan() special case removed, an offlined memcg that
> still has stale effective protection now has
> apply_proportional_protection() applied like get_scan_count() does, so
> the MGLRU and traditional LRU behavior is now the same.
> 
> Signed-off-by: T.J. Mercier <tjmercier@google.com>

Great cleanup!

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
