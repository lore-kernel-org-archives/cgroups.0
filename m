Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795827440;
	b=h1fi272or9Uw0SqNg+QC2LjToa/dIVc8YAz3TxToGVT0TbmMcD/O19NJrymJrpLtV6LE
	 1FBEe3b6ccllWi7cJVuxgY/10Wl4+gDWbfcedqe7pSUvFFE8+0Ja419c1ZEp8tnE1qpDP
	 P3Ra9OAqXKXbzwcVqd3UbsEWiYiGFReJspFiP6Vp+tsEg8BawrY4V/4je5tF+QEo1Cqva
	 HkUyxqWWciavDyrpd2Q4gQ5KYTi9KEgD4sajz+TAFE71+Q8ewErNGfnDhehG1mmZTYIKo
	 11Lg9zoVSzLX6xQ+mWwSX8wlVRRCOJiFNBXG6y1KHMQUm+vqW2snMexIZ8tqEaaLWug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795827440;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition:User-Agent;
	bh=OkwyOiCRAz5EAkzPE2HGFHWSVBJwZ9Gjp6yJVpEfm8Q=;
	b=gyRb6Q9eMq808Sixip2fZVg4RaHe1gv5smz9jfjOMc6i8xo4tdjXkyiKV5OrCszhFjxF
	 aEr1bwvxmHCwvZVxzQXo04RI9trx9iqlKTijJI0LfsAWlLq/LVaaBFUnYh6wCV4bOQRUD
	 hGSJtOvXLG/C5rIg6khM7tAmy9saT+bDU09hFT8rjBch5PToN4m4lO+5nvN3nDXScGgl0
	 eEoK/hjiQM0AVPBQ2TJyaEUzlk2cNdZ0j9O9D5Paj9KkwaPOetFRRubCAmSs4zA/BTmij
	 LV1GFF6HUGoaWZ2O0B053Iv3LGo77+Wkv6SJBfbAX7Jmkfo5inZF6tYXmfOZ27BhXDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=C2yVn601;
	arc=none smtp.remote-ip=209.85.128.170
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F54606A323
	for <cgroups@vger.kernel.org>; Sat, 28 Nov 2026 00:57:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59F54606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=C2yVn601
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-8b51389f58cso93828937b3.3
        for <cgroups@vger.kernel.org>; Fri, 27 Nov 2026 16:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1795827439; x=1796432239; darn=vger.kernel.org;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OkwyOiCRAz5EAkzPE2HGFHWSVBJwZ9Gjp6yJVpEfm8Q=;
        b=C2yVn6010RByzLoQdU0F2bY5TVCz2FI4O4hBokJJ5jDBRg5aY+GcCWso+QRAq5qvZ6
         rpAdyPUuEhtLk9JRl5H0jYje6dtOOVfrDgAxQLMybP9vO3ikaYNsAUIhUliub6kfm2pi
         go+MWzhHEoNKc/8q9BTKhY+BSFOr47O+aKKas=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795827439; x=1796432239;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OkwyOiCRAz5EAkzPE2HGFHWSVBJwZ9Gjp6yJVpEfm8Q=;
        b=ww3w54aAt0K5f6nyScvIzyZ+MbhwG8bkb2wAVPU9XXrMbY+yMynwM5IIcgJNMEZTXy
         lMhEVIDj1wMJenhxxzEtANudvSTM81p1SaM0s3S+ZKr5nq9W03hC7qEnupBS7G0wX7pa
         JzLZkOfhG4NhHkSogBVUiwhc1xU8R9O0zEBrrd8NdSONv8pMA6rL4ATRIJtCGoauyYbB
         /4CuUs7Sbi8U6XXnItkf8tDnSYNXM6BnOIbWKyTE23cimyAF7JxZx1Wv3SffzNdQICUh
         pVFNg9PvOOWM7nPQzdps5hESt4FDFinsZm/mt5NMsmWiphGUjxcU5c0IipEofHzJqGi0
         L5Dg==
X-Forwarded-Encrypted: i=1; AL+hErFeVKvtDtVbqKziNQxxNgpx39P6L1RIcgx46MkrryNwC8w8UdeUGn7tA99LYT7aUzqgDW8wAcmt@vger.kernel.org
X-Gm-Message-State: APuU4Z/VoKGpAv0jaGhxnjs9B6WKF0FV5vyX1cF3vF6RbUEnbcMb2tBz
	1Vz5oEPS9mBWK/4UzOe8W1XupIn1wAEfJbLX8tkUOCewg310/GTUhw2QYdOWv9VCRCw=
X-Gm-Gg: AZFdTZeFpfMxRxaXf8sYO87+WbXh6eubknuNOhJMZQHrn9PVvc0svs/1cHuhJDkV9qX
	Mf+7d3s8XfLB1Yx//JPniSFMKJs+PsQK/RxKbDt4+TcPyVaqZ2ajieJqNtbd2/vcOzsyWzoz71n
	wbwbs+ew9h6YhyR1PZufaffqruLbWy/dHW4wsE/t45aRmWFkHqWYDuF9bl+4NpT8EC8H8RKhx+Y
	ytlxmfi45/qXDXa9CMg1Y+mO5vTmODpxvSzf3Qb7b049oNNT+/vqc713Ug7d90hbEcd1IZeCJFP
	Yi/8zgQt5si4QEWEXayvkBVkQU9Myl2W7C4yYAjHpE9cNL25Daa8KFGgV2HqWwCvBE7H8zFic+O
	qPtQo+mhC7xfTBduWxKlYBalFGRKGxivSYRlafbphhCaG3rhsyXV7CaFG1mTiyM2JnaF2AKE7II
	0c0YLJEuXXWCmWWe8tqjTYTH3baLY0dxDFxH46VSMw/jjuveFPoIN137St8DQj06pNXHjodptGy
	pt1dJfNRooFbQZbw5wZLvF9LdePi2B9+XNdVQ4oTL4u76z07i0mPBXjY1DU8xu3wvKzqEPOYT5g
	9k7TGibHLZiJwXJ6a9TGJcmsOaSK6cIPEDeSeUhX0mTWfUmaxR5MKN7xQ5hw5eDsf6AotSe9/3t
	MgX8xKl9MLF6sHLJUnWD09YKMt0Sgplmk3Yq4aMZoRgJQr9oe6zKscVodq7gIAGAwzvcx/gXbfa
	6Oi7AJ4HcFY8tq9ig2sSQ3xzDBBZf2fRue4LC38JIiGTa3YnRO8fpUoRF9DiM3h+IAj+6DPgB6y
	n4OXvhSFHM4cjlihZPqRGs=
X-Received: by 2002:a05:690c:9b11:b0:8b0:f116:1200 with SMTP id 00721157ae682-8b5204efae0mr102371357b3.85.1795827439428;
        Fri, 27 Nov 2026 16:57:19 -0800 (PST)
Received: from [172.20.0.2] (c-73-207-185-9.hsd1.ga.comcast.net. [73.207.185.9])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b52028bfa2sm100757467b3.14.2026.11.27.16.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 16:57:18 -0800 (PST)
Date: Fri, 27 Nov 2026 16:57:16 -0800
From: Chris Down <chris@chrisdown.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Greg Thelen <gthelen@google.com>,
	Greg KH <greg@kroah.com>, Ming Lei <tom.leiming@gmail.com>,
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] mm/vmscan: Fix legacy memcg reclaim deadlock
	against filesystem freeze
In-Reply-To: <20261126180228.9b672a945d480e3d3f301985@linux-foundation.org>
References: <17d0d1395c0237d201a1abb2473d51f5@kernel.org>
	<f188775aea9580f9ab2b477788503434@kernel.org>
	<20261126180228.9b672a945d480e3d3f301985@linux-foundation.org>
Message-ID: <awom7B9Evkdhq1EY@chrisdown.name>
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
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Andrew,

Andrew Morton writes:
>Can people please take a look and suggest whether it should be a
>standalone patch, or just fold it into this patch, "mm/vmscan: Fix
>legacy memcg reclaim deadlock against filesystem freeze"?

Yes, I think we should fold it in so that stable doesn't get the fix
without the scoping. With the other patch on top, the reproducer I used
for Tejun's patch doesn't deadlock either.

>(That's mem_cgroup's fifth bool - maybe scrunch them all into an
>atomic_t and do atomic bitops on it?)

Hmm, oom_group and zswap_writeback are in the read-mostly group on
purpose. I also think packing them into one word with runtime-written
flags like this one is likely to result in cache line thrashing, though
I haven't tested that. It wouldn't save space either, at least in the
x86_64 config I built (given each bool sits in what would otherwise be
padding).

>(I am told that moving wb_wait_skip to just after oom_group would avoid
>increasing sizeof(mem_cgroup), but that puts wb_wait_skip into the
>read-mostly section. wdyt?)

On x86_64 it doesn't increase the size from the previous situation I don't
think, since peaks_lock is followed by a 4 byte hole, and then wb_wait_skip
just dutifully slots into it. In that config, pahole gives 2240 bytes for
struct mem_cgroup both with and without the other patch. So I'd keep it in
memcg_cold, since the read-mostly group is for fields that are set when the
memcg is created and only read after that.

It does need an entry in memcg_struct_check(), though. Every other field
in the groups is asserted there, and without one nothing checks that
wb_wait_skip stays in memcg_cold:

    CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
                                  wb_wait_skip);

With that added:

Reviewed-by: Chris Down <chris@chrisdown.name>

Chris
