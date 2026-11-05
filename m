Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793912806;
	b=EkeOJmCDjumpgAcMOLkGZcp5OqdPcsKQqnFl8sgVfnTLT/4RSZPOIrgbNxvy1192Nwcr
	 JD+PgSEJ2n3eEik2vO8GxUmDygFQgyMXGY5evFqL8SPARCNvCF1SSPHBj7H6Yz9vbUPKL
	 oW6jF3qxpYTfox+9RNOtkGkNHAptFFS2X1/ut+vSllgGmBrUamkQPn9sGvb4WJaqRWkoZ
	 +HmvqN1n6IyiDG7ESSwlmeU7CBssD/zzPvjhBfhf8kong1bWYgjcGgnivh/rLyGYmHoOf
	 yd5sdBFeUmmmCcH2hO0qqGJS3j86I8GmP1avdmSQN1Tb6XX2EbOc4BZdV8NI/z5z+3A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793912806;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Content-Type:Content-Transfer-Encoding;
	bh=PQ5xrz6/5W9B/AU5YTZ4/YsX+i9J+WP+jzQ06aUOz0I=;
	b=1UXv8jrWluqXAxz2Zk7r2arYTN4t+Rp30PZQo+9OcigBLxPtOGlFmN5Px+RdNGHj4MJC
	 eTfLZeJsyo/HcJlvm1O6EXtHc5+0NArl+5d+RPcOma6qR5dngPgVW+dMOywyrE0CzvJME
	 7C0PLAwH3G3nEqSXvjiIro7Y4ahSfvqX41G1nA70zIRaAAn7OgykUnCK6BzJbo6GPFkR+
	 ACYFxuLV7hMiH8we+cVjlca7nLsagbmZvNewj3Qxx7P5NX3Pc5sJDlBlW0MHd/rDGgS+3
	 0pZh9D5ce4wajJJZ66n1LRoUW1gX2B1ePKbmW9vIFpHnGZ8+mWS6rAwdEacxpXNBpeg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MwJ76Ks5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9595606A326
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 21:06:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9595606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MwJ76Ks5
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-49134c8509fso7850f8f.1
        for <cgroups@vger.kernel.org>; Thu, 05 Nov 2026 13:06:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793912804; cv=none;
        d=google.com; s=arc-20260327;
        b=E5TTyLwgHakpsNhBfyVOEFYR8KBMDIaxhfRoMOW1Lp6I2CGak9CtvcEeO6AQ5XlDCw
         nqmJF/vlz62q9iLdP4YRcFxxXwlZAHm35n60Lly9xdLHqKxjHjFhCbV4PWuJp9jKW/+U
         /rus5x43gc6E5bzgtss/gHn8v4YuXw4JMQSx60pIdlNiIqhnKswF1YwAKsCR9L9aXb8O
         zhJ0s89LoaHMVm5kOy9AXzYcd/w6S1jzJEvBCBp8kh5W2j14uDYLPNrAWfjbbmM4KabT
         EHfiFbLuTs3pOg54Zi+0M4T4kxU3JpqTMq+cYN5DdwfFowOTdcHs4OR4SRUmokKs0Ude
         FG4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=PQ5xrz6/5W9B/AU5YTZ4/YsX+i9J+WP+jzQ06aUOz0I=;
        fh=1/29HsXu8mBMqVjtGa9ZMf7UBHpn1jqBX/U8oTf18i0=;
        b=dapfsSUIvH5NdZnmDbsiV/EVgL2pBejHMTDRCpEh0NUEMwKVgJHdX1G5pkUX13YUnM
         wa2X6JCLDmWVQdfuQ3NnkKwvc6b5nusc0AW4KKdQiIVaoIIm0+BgzONOwUMg0/yU8a0k
         iZqDxMGotKfh7zuOE5M30m90LGyFTJSVs4sQKscDMWtnrmfLDhAiE8zgZu9z39fnkK+5
         g2LhTMmAsIdNYuWTd/6ciWCbvZQ1RfDqDYyt+/qBiWXPHjE9klpRg3w9f0omjopTzdES
         azeu5nenZI8BghDBtxEW/x3So0zJq1gERv5N8rGWi/nWMdtfPvwnEl3pIaYeCNUVtyGV
         b/9A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793912804; x=1794517604; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PQ5xrz6/5W9B/AU5YTZ4/YsX+i9J+WP+jzQ06aUOz0I=;
        b=MwJ76Ks5Y+rKs77nfkcWgGGIm90efC1A+MzQ+8wZ3Hi9xf1bd4nsNC7HWcgOPZ7FZg
         yu54ZNROcPfiNnVTY6hcmbKqOTu21bEKggFBcVHJM+tDzLsJanQQkMruevgqEqFQ9m9b
         9Okrho5OhtlFmvCVeQwSmsdSvH1UZ3wZ06hHH75dUUoCbMAdmWEOgok0pbVFs/FgEkKG
         5b7CgmRYgVNxIIj49pasfL3Qz8teKSM5+X6pMqe6PiBQVUltaxwnLdbAbeEn5iY7EZOw
         MImujzfSruFsGdab0k1HbDIPF+nWQipw4z/7b27A7MIBv4HUFubKWVhEU8kTJ6eZwyNV
         T8WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793912804; x=1794517604;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PQ5xrz6/5W9B/AU5YTZ4/YsX+i9J+WP+jzQ06aUOz0I=;
        b=sIlTYGsD4u1wUkkC/PQnpxeZv0Px+9M8JUnAVm8OJst+5SYLRHv6wtG8qT51imfZJv
         gCZmbWDfsj1lOIGXKAGhu3FYyuiPGmwouojGCtizp3oqKUzNmV6jUBVYesm7XY809byk
         GWbUtJGDN8pwVpgONHV2GesaFjJnd0sKsXUurcozfv6Mh78JgDwjAiIo+owHUF5FcA19
         WsanMo9v6SePvcgg3hqPe/qAmkhWnrLtEnU43n7vVVw4iXfC7E0hlUDc/r3jpgatavsl
         +rGotXSLjOHNGulRY9cHqQjy5KKL/vAjcRaIR5FCOZnoQaEiXtEE3DIczHgI0O7jk9wT
         4zVw==
X-Forwarded-Encrypted: i=1; AKwUvBwf6LlK7rAQKHWClfqedn9kkKDYHv7I4doHCaHEjWw9dudY2jTqx1ceia9y21VfWNiOqwcLNxqG@vger.kernel.org
X-Gm-Message-State: APuU4Z+g3rhuwrvfV4cJH7Sq7STAKRtx6jXhnIAjFfWaqUFDYolCBxnh
	UcNYiiAk3TMd3nWwU01XHHTuVKpgJ4Kfb2A+pgVvWWvj6Y4LpiLq9nQNRu0KB574n5Y+lRPbRlO
	v7x9/lk79x3CuoQ3glgop84JUCQT/pHE=
X-Gm-Gg: AYBFou1bi2YMEVRapavuGB0muL9TEh5ONr2+3VbCOJA3HeAy3R312JWizPZxXMcN7Kh
	KrLAW9P2CjbSCMnn/MjUcyV0eBg3ZzrquvUlyIekvUdQSWbgpOajKS4yOiED3GhDHF3mMVMssyi
	++BWuqBLVpa4B19YRtcwQTqSFX0wDdbwt8FjglPFUCSZtK3RsUQud/T3ndcyMxZcSi9USQpBdIW
	0Y+FleSWCCytR7+sq+IAvnB1B4WhUxJp/yVv0SetNpaVPs+C8Wab35NiWKvjnIa6CExmSpXcsPe
	O8R+NsB9JFgHZHfyvoIYPDzbpd0gm5KNOk4Y1Ssfw4Ez/0cAKoTx5xebNIa5fsPvFWdRsBXVm4V
	nhRy00+JECqndQdjqoyebvlOseaBUpIGAwW50tFsFIyS6HEMTMu++5d/sbry8Fv2KwRJUTx/8As
	nWh1idmYjgueTfrmITH6notjApV36aU6+OqvPDu/JDVmWMdDR1ln0c
X-Received: by 2002:a05:6000:2510:b0:48d:f488:f32a with SMTP id
 ffacd0b85a97d-492775f23a9mr1599167f8f.56.1793912803834; Thu, 05 Nov 2026
 13:06:43 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 5 Nov 2026 14:06:32 -0700
X-Gm-Features: AclHuK8Cjd9cUW2LR9znWEJxOp10JF8kDZifUXejaVPmbKzhx3QybC-mp6UtYl8
Message-ID: <CAKEwX=NXSwSiuY65EV5nqFocMLd6-afsiJfgy_ahB2v_MDmcng@mail.gmail.com>
Subject: Virtual Swap Sync
To: "David Hildenbrand (Arm)" <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Gregory Price <gourry@gourry.net>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rik van Riel <riel@surriel.com>, Wei Xu <weixugc@google.com>, 
	Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi folks,

Sorry for the delay in scheduling. I also figured it was not a good
time with all the merge activity + the big list of issues that needs
urgent attention :)

Since no one responded to the last email, I took the liberty to do
some timezone math and create the meeting myself :) How does this
sound?

Thursday Nov 12, 2026 =E2=8B=85 5pm - 6pm (Pacific Time (Canada))

which translates to:

Vancouver: Thursday November 12, 5PM PT
US west coast: Thursday November 12 4:00pm PST
US east coast: Thursday November 12 7:00pm EST
Europe: 1:00am Friday November 13 CET
Beijing: 8:00am Friday November 13 CST

Folks, can you double check the invitation, and please let me know if
I missed you in the invite :)

Best,
Nhat
