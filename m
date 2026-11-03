Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793731213;
	b=w/riYGfk6wb/mbh42LKlNPndsN9yuIByelIwPMD6qL56nRRmwoVfaOw0DBxKBAAIwAU6
	 pQvYmm3JokCGKCP4v9f0ZvrYaQzbBH2zHedy/A7poicu9olHgZs+MBAcxRhMK53bFZ+Yr
	 5+6ZCqo0dHFQ6DtsFGyQ+edN4PQig90EMtAugGgcR6wtmGOxHXQb+QH/znaMtJ/Ofiz2l
	 znE+cF6QFYQvJEBTyHrKeyKTbgXT0VDvxTwbQMkPUDQ3CYzuGwudtZ2eK+HIQUVlW08G1
	 p8UZg6bnPFnWFue0vzFrcUzP+86B2UVNOnNBHReoUb1mX1Vtwum0h+jgLmw/15BNgrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793731213;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Content-Type:Date:Message-Id:Cc:Subject:From:To:In-Reply-To:
	 References:Content-Transfer-Encoding:MIME-Version;
	bh=1LUYnHObY7Q3ByIwXxp+Nywos3UJ2Q6dqziyGEM81xo=;
	b=p1VF7Md0NRmMO5g5nQS3BrOXD1MnRarW/hxOpn4WuKsrV1iI0U627WwU6n0wZjXL3A+x
	 0IBdatKvP0WaznyJYKnNGMAja8W9W+6F6q2/jG3lsmuNI9SqMSw3mA0zAjS6YsSiSYNms
	 mcToj2lfx6Kct95nkhxe653ZjYmPu90TMhfwIRZ0Sxc0sGkSrCtfL6HU3Mro3F+e2ff7h
	 c9/QSuQlF/hdapl9UfCVt2c8hOrrzO4WIfy3tL6XLPGODD1XGgnfIUDp4MP/H8N0fNFj/
	 fEOCBhNAAMSDEQnNr2/gqXeUi2H1SEVr3RQWb5bOnk0t4TD3QuOCXTF2jNFwVMg659A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ikPjzMCp;
	arc=none smtp.remote-ip=209.85.216.54
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDB8606A328
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 18:40:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4DDB8606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ikPjzMCp
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3ad2b3b1c02so2491266a91.1
        for <cgroups@vger.kernel.org>; Tue, 03 Nov 2026 10:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793731213; x=1794336013; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1LUYnHObY7Q3ByIwXxp+Nywos3UJ2Q6dqziyGEM81xo=;
        b=ikPjzMCpaDfmG8KPOzOEsJwFM+yQDjU4pRBJOrPrJestD5TluUkSMIg74H4UZxemrM
         OjnAb7uRvPHCTXCTG1bFdZaz1Cfd0Iwkz2UQnW08QY0m9uibKlx7eZHklFGOYx5oL6Mr
         Ejf9pP1RgIBeJQt5PTkbPGsXzG6AHdWAHFCT527MBajkGq/jZRfXVSai0GiYseiTweU3
         B8k5XTKmBtBP7J9WYzD3p0DdIj/redhtrzwLXHD7GnY327miZxMuKkbyzSPELOoV/nLn
         U+j5LhqKkke+ra3hON+8Zodxmcp6cWnmvhoznRKHb8R9xDvb94dsMxJiEm72lRVZSO0L
         Xczw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793731213; x=1794336013;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1LUYnHObY7Q3ByIwXxp+Nywos3UJ2Q6dqziyGEM81xo=;
        b=K1ilVHMutxciTeinleRAOKYCHkgvTEfRQKuKp1Qxmr6kbMWnElfDfb6Cu2/+kY0BF/
         3p8gnCE5IvP1cjh/NxWNevId0FbbHxTkIkaeiy82PWsfL15l1HpOTcdAbb9toKp1s/Wy
         8ReDKFwxe18zboJKbcM4lTy8as8aGb63Tcnrwc/be8lllCa5PEUEeIL4Usx9u30MQC6E
         xuWYbImFJw/rXSbYnxS7/2dGGZAKP6a3P3mB4iCrziXCKlpeDJLHfgPo8G2ACB80+JSS
         FdKUgK4P/MVP6dfc+bpbhREsf6/W9SnpftFXKR+OqsqeLGKNgJRmJAvfpDucQd3nk7vn
         Dzew==
X-Forwarded-Encrypted: i=1; AKwUvBzvZSSf/7wDst+4A/9EKblsdjhNB4sQpHN03iYPds8SbZ8A26rRTL+SNdlY6sE/SWIY5Eam9Vbr@vger.kernel.org
X-Gm-Message-State: APuU4Z9HSD2JKXW5v3STPGB20SOGE91EtB4kVbFftQTkY6Z3gMpyZodx
	/bimWtx5vIkudaZ9Y+SaibPGEcz1T2CpMPdTU5MydaZ3tb643VAHT4U6
X-Gm-Gg: AYBFou0uYl1cTSpXAYS9LzN27gIKjKShYJ+6T4pOlJLeFYCUq4ymGp0IOhqYBdXefSv
	RUWzzqbTmdp8BLktYe2qKoi+YPrGrEkU5oVsmwHDMvGlRdD6yRSGwuh79IkCNgWrd2uiVN3vvGK
	OZyy2i936yPaHELugQAGlHvy/Sr6HLzy9BVKQXGQz6ukkI0/hggPZA1QAyi2Dnl8yZbpgTB2kKI
	5vvfzhn6mtanPMgkm/yKKG5/naXwdB1tYb6/AdQyTZnzDN6xiom9T/uhoR+pvpRH+njyg0z+vsm
	VZPvOhehlF+qpheLMsvDRAgVGSBlhIxAvV0lC1AUJmdwpmVXdOnJaPYw9MlfEPFikP1Qlb+gpan
	99TJmZ+lFQltoPJvckefvCbhjIOnbAkq2HInUpiQVJSJTNaNvIeTVfDOZvOny8NHQ92COSkkHLS
	WroinKQqNsYKNNVLviSWSLV8JRwiipksd0nt9+4QfoXCVYtxgzbT55FFQSKGnH8ogFv2IMXP1Ek
	3tq7EIuB0cJXRyLGBXHfyNCJIK6seX9AQiffNENA0D7mN1f4PEo+aVAGwVWQZ5TXJtqGZATVnmV
	9EFeY71Dlcl3FLPdpIf7vFXcasNxIC0Fk29/nu8FDcz+VpgH0AFoRlwul0WSDGyvIVgTwJdLasL
	wZ7H6UHDWjDt5xzRmrxcezCZ6LTMk9Vadnw==
X-Received: by 2002:a17:90b:3e83:b0:3ab:2737:3396 with SMTP id 98e67ed59e1d1-3ae89855ccbmr11961848a91.65.1793731212415;
        Tue, 03 Nov 2026 10:40:12 -0800 (PST)
Received: from localhost ([153.61.198.247])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b094d70a60sm58552a91.1.2026.11.03.10.40.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 10:40:10 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Tue, 03 Nov 2026 18:40:09 +0000
Message-Id: <DMLSN9VHK0P3.2A97046A4YXGY@gmail.com>
Cc: <kernel-team@meta.com>, <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-rt-devel@lists.linux.dev>, "Sashiko"
 <sashiko-bot@kernel.org>
Subject: Re: [PATCH for-next-fixes v2 4/5] mm/slab: fix a deadlock in
 memcg_alloc_abort_single()
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Harry Yoo (Meta)" <harry@kernel.org>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Michal Hocko" <mhocko@kernel.org>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Muchun Song" <muchun.song@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Hao
 Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>
In-Reply-To: <20261103-kmalloc-nolock-fixes-v2-4-19167cfe4779@kernel.org>
References: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org> <20261103-kmalloc-nolock-fixes-v2-4-19167cfe4779@kernel.org>
Content-Transfer-Encoding: 8bit
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Tue, Nov 03, 2026 at 06:47 AM Harry Yoo (Meta) <harry@kernel.org> wrote:
>  	if (likely(size == 1)) {
> -		memcg_alloc_abort_single(s, *p);
> +		bool allow_spin = alloc_flags_allow_spinning(ac->alloc_flags);
> +
> +		memcg_alloc_abort_single(s, *p, allow_spin);
>  		*p = NULL;
>  	} else {
>  		kmem_cache_free_bulk(s, size, p);

can we call kfree_nolock(*p) here when spinning is not allowed ?
Karl's patch did that. You replied that memcg_slab_free_hook() should
not see an object that is not charged:
https://lore.kernel.org/all/asaAwg1KeZoEYd4K@thinkpad/
It's fine. __memcg_slab_free_hook() skips an object with objcg == NULL.
The else branch relies on that. kmem_cache_free_bulk() also gets
the objects that are not charged yet.

> +	if (likely(allow_spin))
>  		__slab_free(s, slab, object, object, 1, _RET_IP_);
> +	else
> +		defer_free(s, object);

That's an irq_work interrupt per failed charge.
kfree_nolock() tries free_to_pcs() first. It calls defer_free() only
when that fails.

Then no need for allow_spin in memcg_alloc_abort_single(),
and the fix doesn't depend on patch 2.

Something like this (compile tested only):

diff --git a/mm/slub.c b/mm/slub.c
index 45e077c..fb92b48 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2551,7 +2551,10 @@ bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
 		return true;

 	if (likely(size == 1)) {
-		memcg_alloc_abort_single(s, *p);
+		if (likely(alloc_flags_allow_spinning(ac->alloc_flags)))
+			memcg_alloc_abort_single(s, *p);
+		else
+			kfree_nolock(*p);
 		*p = NULL;
 	} else {
 		kmem_cache_free_bulk(s, size, p);
