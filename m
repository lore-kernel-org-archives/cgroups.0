Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778E63C98B7
	for <cgroups@vger.kernel.org>; Fri,  9 Oct 2026 07:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791529356; cv=none; b=TXZgQ1LW/wz9aVRDutrZBu2vrar4paEqipjVcM52uKv31Ob+FL7Ms9tcVMzT72V2X514HNdSwuyPNwOUQjIRA2aO13K69dho0NWz8Fbm9jdZniQI81yBC/roXx3pj43QWwqXibXSIPr9cBKb6Vb6bE/GOnndz6HaCB67Bx6fSjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791529356; c=relaxed/simple;
	bh=TPxOKHJ895l/zZBrxoHbLiI9IaPlmjfGv9C/U5YFa/8=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=AHOzTmEvedT42XYbl6+kP6pUfaYXmpdwN0noOiRjG+iATWnn4rm7bscFfRwGVTYBBGs0OBpiPzILVe65BOpOqqMAGlm3EtCvCbVVdMCgfVL1jFMM2NG8VREn0di8IxrpWez4FZXFZu6QtbvTWbRblVXuIvnbYuYxSmr+S/kylCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=C9N8jCAC; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="C9N8jCAC"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a005aa0838so1408375e9.0
        for <cgroups@vger.kernel.org>; Fri, 09 Oct 2026 00:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791529354; x=1792134154; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id
         :references:in-reply-to:user-agent:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=TPxOKHJ895l/zZBrxoHbLiI9IaPlmjfGv9C/U5YFa/8=;
        b=C9N8jCAC0Iem1Aze75g9YeAY9EO3ZF5Z442gaZX7XR9vuY01P9rjdlkS25mnhvk3kd
         Zkp+WuYXNqWqZop75J/P2Diz5NYOOQjuBr4fNKZpuxvCuBwE7c22xEd2pSwWum9xNWs4
         p5nQ5YhW0Rs75Axh6UW1V0yDby3Y5oAzB7ZM1tHLxJZlXE1nGg2vmuevQTsWVTNllKPn
         AT+F4z8aMZ/7y4xqcGj2laFVgUN92AZKiVe1gRq+79We61VOV34WiGarv96vEHJkSFjS
         9pQXcGLx1zpE3Y67O4KSUxvzG5kefPZXVoN+UQs5qwVGBfUwsbabIZ5Eym8pHzB56jB4
         ccsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791529354; x=1792134154;
        h=content-transfer-encoding:content-type:mime-version:message-id
         :references:in-reply-to:user-agent:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TPxOKHJ895l/zZBrxoHbLiI9IaPlmjfGv9C/U5YFa/8=;
        b=qRJUpHs4CRBGAWh/q8svFFk6hfljtzO/ADI7NU3sLpDTNbINmlD+e5RP1BErXw3OTD
         goM481Wd8kRV5tUuuez+m7OuwbvLWHhS4xhg3V3kRPSJVdgvmyljNWLgvPnWsMuCWDTr
         UvDrmgYR9zC8HvAcpsPDcbTQtAlnPECXZgMrd6z/DXkH6igTYQavx9zoGqlSrGSDC7Vb
         8oc7LQMWCKbVAgUe/L+kCj4pUtYe7qQ7IPmq4pNIglSYeBYoRzYcYeMTAjDNas0Uty7c
         EEmgGA9wNwMEKnA9m+Ul8X49YV2O3nywB0zfihzAiuQRcNGer7kyr2KMj8jwvG33rhoj
         I7Lg==
X-Forwarded-Encrypted: i=1; AKwUvBxtrpOlJU7VKO4jAIfAuRKyiBthylNFPnX/Mz9Ip2hEtnyNCJb4kSJ2+sqFDTISBKh0hZ3Djx1B@vger.kernel.org
X-Gm-Message-State: AFuF++ngPOMlRipfLpKcvcZ+8eoOio3c8WoY3WXapkznu/d2+eRu1Eu3
	2q0FQGN4NxK9k2Y/bStmljdM2+O4zpjBVvfUtnbOw38thOaicATgcnzmQ9MTQfyCkU8=
X-Gm-Gg: AYBFou2eDF6rgpl0dh6HC35qYSIya4R/C5/9dp3VlIEfw37Y0LcXSkcK5XSTJZ+pubr
	nA/P//MkpgCqEjCawjLdYuonkcMjQMJ8lbK2LRO4cSRE5GV9YIiC4QTmzg3Nq96X5Uk4CFU5gYZ
	40qkogRar22rsv5uPIleWgi8JJWXa+wXjFYD+ULvFYFu4oYU5P5OFmn3M411NWruVFEVnft1bNP
	AYCsclRyDhy9B0d8TpEIbitWV/yQfBosip4As8dHpxWMVkbSnBcB2WNTjXS7NEEAVPuF9DZxpjF
	usw5NdlZnbnyvtaoXj0G3MxzfVAxTUidLNNLeRwJFV9ouhta9umB7rBYZM/FWPpNgomvvkIo15A
	OnWZ4fDK1R6JqYGPusae8Sov/z+GP8ZCQulvHyArNFRdPW7JV1iIhXh1OW0hjIePT1rCaVSRhps
	8nZV1etbirWJjA3wsmPrVZ0mzJ1XdudbJ2xwuw5gKn41zQ1dVcMT1GwV52Mw4AzOeVpiGbSh6Pd
	wC1cQ==
X-Received: by 2002:a05:600c:a086:b0:4a0:1f9e:5f78 with SMTP id 5b1f17b1804b1-4a18e3ea887mr15384705e9.0.1791529353543;
        Fri, 09 Oct 2026 00:02:33 -0700 (PDT)
Received: from ehlo.thunderbird.net ([2a00:11b1:1081:dc93:96ae:ba90:5787:8bd2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18be96549sm52255005e9.6.2026.10.09.00.02.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 00:02:33 -0700 (PDT)
Date: Fri, 09 Oct 2026 09:02:31 +0200
From: Vlastimil Babka <vbabka@suse.com>
To: Harry Yoo <harry@kernel.org>, Kees Cook <kees@kernel.org>
CC: Vlastimil Babka <vbabka@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
 Kuniyuki Iwashima <kuniyu@google.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Willem de Bruijn <willemb@google.com>,
 Jason Xing <kerneljasonxing@gmail.com>, cgroups@vger.kernel.org,
 netdev@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_net-next_v6_0/8=5D_net=3A_skb=3A_isolate_s?=
 =?US-ASCII?Q?kb_data_area_allocations_into_a_separate_bucket?=
User-Agent: Thunderbird for Android
In-Reply-To: <asgAh4mrr_yd622U@thinkpad>
References: <20261006092030.got.500-kees@kernel.org> <asgAh4mrr_yd622U@thinkpad>
Message-ID: <70EBD8E2-6DBA-4758-9CA3-D5CB661CD3B7@suse.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On October 8, 2026 11:25:13 PM GMT+02:00, Harry Yoo <harry@kernel=2Eorg> wr=
ote:
>On Tue, Oct 06, 2026 at 02:20:26AM -0700, Kees Cook wrote:
>> Hi!
>
>Hi Kees!
>
>Was hoping to say hi to you at LPC but I missed the chance ;)
>Maybe next time=2E Safe travels!
>
>Uh, my mailbox stopped working for a few days as I forgot to renew
>subscription=2E (Kiryl told me it's bouncing, thanks!) Hopefully I didn't
>miss too much=2E=2E=2E
>
>> This gets the buckets able to handle memcg (GFP_KERNEL_ACCOUNT) with
>> isolation (since it's common due to AF_UNIX),
>
>Cool!
>
>> and GFP_DMA with fall back
>> (since it's rare)=2E
>
>> It gave me an excuse to build out bucket kunit tests
>> too, and that (and LLM review) found a couple other issues that needed
>> fixing too, including msg_msg allocations going uncharged to their memc=
g
>> when CONFIG_SLAB_BUCKETS=3Dn (fixed in 2/8)=2E
>
>Oh=2E
>
>> Harry, on your v4 question[1] about bucket users giving their own
>> alignment: I tried that in v5, but a set's allocations don't always
>> come from its own caches=2E With CONFIG_SLAB_BUCKETS=3Dn, after a faile=
d
>> kmem_buckets_create(), and for the DMA and reclaimable fallbacks, they
>> come from the general kmalloc caches, which can only give kmalloc()'s
>> alignment=2E
>>
>> So v6 goes back to mirroring the kmalloc cache's alignment,
>
>I might be missing something, but why is that a problem?
>
>For kmem_buckets users, the reason* to specify alignment is because
>they might need less strict alignment than kmalloc=2E
>
>(*Perhaps it's nice to document that in the comment)
>
>However, because kmem_buckets can fall back to kmalloc on e=2Eg=2E kernel=
s
>w/o CONFIG_SLAB_BUCKETS, it should be fine to fall back=2E No?
>
>Creating kmem_buckets with more strict alignment than
>kmalloc doesn't make sense=2E=20
>
>> and drops the ctor and flags arguments for the same reason=2E
>
>Uh, for ctor and flags, yes=2E We can't have them in kmem_buckets=2E
>
>> And the whole
>> exploration made me realize I had a completely wrong understanding of
>> how memcg worked=2E :P
>>=20
>> The bulk of this is mm/slab, but the final patch is netdev, which Paolo
>> acked in v4, so I'm hoping this whole series can go via slab?
>
>Going thorough slab/for-next sounds reasonable to me once it gets
>some reviews=2E
>
>Vlastimil?

Sure! If you review and feel it's ready to be added there, please do so=2E=
 I couldn't yet due to conferencing, should be able next week=2E

