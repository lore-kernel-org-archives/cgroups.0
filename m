Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE61472067
	for <cgroups@vger.kernel.org>; Fri,  9 Oct 2026 07:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791529666; cv=none; b=t/V0xoACtQwPWp6aEXyXSTNbtgwItxANQlL6OV2k4k/mtUeiSxw4SXSvqlJLVqy4XHAxCxxELMnBHlsLKqOGMV9P5+hcv+OlsKrc9hvFUgzOv/Qkyc71mxz3zg3Rdr0JO3E0ZtdsNa1U/o2Ov2wsuELVqzzJ4y+STb6BgtFUn34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791529666; c=relaxed/simple;
	bh=AOBfyMObxsPKe5555MA7X0XhuhbKoT8tcSGCgf4g340=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jj4bNZkS6kplieStn1vq53ZmDSBgXqcFD/uKoEj7BMGPPvOrZUSLKHqS4pGbwwCyS6pjdgdx7C5ZaKXxR1rQdpGJFoOvrS8tCEjed/zO3dLc5lA9POdj2rHKmJKqdGbx4j5+GVXPFAhI/vrxnVD/QshMU2N+WhytZYeMxTy4qhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B0FazBUM; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B0FazBUM"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4998b5a63e2so58986535e9.1
        for <cgroups@vger.kernel.org>; Fri, 09 Oct 2026 00:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791529663; x=1792134463; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sKKm9SmEIl/bnNoeHMWb5gysBaP9kkRYpBJirexaJDo=;
        b=B0FazBUMi25Nrrx2P3zFQv2Ew0+HrurV02ZxT0ILniaokSjQwT9spny6pLPlp1arCQ
         1nAdmH3V1brYpLPo7/AztGbTYqYoJJgWo98R3F97yxJ4sq8ZBEGYHgri/atjcF2d6pkI
         jbLcBH9o3tVEXeAtKs1O/scczwwJxtXZS/4/mls0BYyO8yOsEFwj5Kijs9eJehnAmisA
         iA+GKPcr1x1HpVpwtgwfz5NeI+GgRU+dMy9ucDUovhkXoMK+uXY4w6cFkRYrzzAzLSUg
         ca2YmFMruULHowX/r57yL5GemGkCyKceU0f55382ZLGYbx2V3I9+xMDTRJCZAJjnrGlp
         Q0QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791529663; x=1792134463;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sKKm9SmEIl/bnNoeHMWb5gysBaP9kkRYpBJirexaJDo=;
        b=StWFulMa+Tm8Pyr7Uz6XsOZ9jCru2sla+hMo1/IoX4IIZKYNElOAcDw8mrUhz5VxkE
         T9QoQxvnVAuX2OWdqzE8Uy9o7pUycrrOqpNJ0OOX4TRus2ZGWdjIdRIfuE2LGVy7QCmn
         MzjIGaxHhKKjBQRz6Rz28NESDW9whMi4JnHYa/p+ndm7Y35WxIefnanP+Wq2cp2cDI+0
         teCIpozdtXaIOE+wJZbJxklPG7rOUCH75R8T5b23muFt2Mi0xzj7xEoUImHTzmMvVfHi
         qGakMwD06wi+quvV61MQ49hHEPjiqDDYjKWHjL6uj4wFX5Q8pZiOB7mac3UmFfkMmQQJ
         9NtQ==
X-Forwarded-Encrypted: i=1; AKwUvBxzfZjL4ZTjgpD6V0IxbaP2YL5SG+OQLM3MLaUYTcQ21pDEl2Eta7de6xeQA46vBsChKeWfyRdm@vger.kernel.org
X-Gm-Message-State: AFuF++l7F6JeQoKjyeoay5Rs0OaXQsDlGjjoE9UogaTuLJ055pCiuDIG
	tjqsnNKy+aFWEFND6rHbuv7MhGXFjnVWugov6e8TYBrLjK7zXOSwFuIG
X-Gm-Gg: AYBFou27mOWSe0m9aTTqNbxL/WQNpXSnT4+CptNUVVTrck29yvr8YOLe0raXXRgAQ3U
	IbfFaK6yGVbOKaIHJBMjGEQgXy2tcXg7qOkOaKMVv/XrAkLG30Rti7wJlfBw58PrC26fpPU/OyW
	Cuhgd2PQ8Vl90cZNdQNw7c6LRTHT5+Yth1C8rjwH/QQCyXw2Dg3uYrMtxAJ5b5qYgZ+mWILbvqB
	Kd0njbtZPUXFd2OwHNop6mM9U9/p+sGKQ1hV+mF1zlONIK6bmiHif2Omx2qEi2bDhbCqKIEYBvI
	qZiW7YN8sdSi9DNjbW4+hGoYTLLs6FdKe0iuLfncsyMaW7w9FzdmaLgxEM/Txarlsp84+Gbrqs+
	YA8rifenG+mI9joLg7g5CMLs11AnCIwJKVS8eSR6yjW1hUCc3aENb8ICvQKSC8eZm/LmUFiaSkF
	ktwtxSjwMcNmE9Ixs3203HDa5/hNfbHWFMSJXygVW9U7kIS71LBhkTdkvoNU9/TTUn+SBFWvaim
	4Z1kaJRwBCX02KPxHHzut98QsoOkAZfD1ILGkatxoSO4NRYS0mN7Ed2DPylSufU3t61NnYk5aNd
	D/rpn79gWm1GKxVerNR47BL5qnRwdcq9hiVgbb4h82kZPunfGtQRvFavpBVnQK5Y84ilAY6hKLV
	djIEvECHjXQ==
X-Received: by 2002:a05:600c:8708:b0:4a1:7b05:3a6d with SMTP id 5b1f17b1804b1-4a18e49881amr14849175e9.8.1791529663117;
        Fri, 09 Oct 2026 00:07:43 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-a128-aa01-297a-7094-853e-a20c.310.pool.telefonica.de. [2a02:3100:a128:aa01:297a:7094:853e:a20c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bf2caf4sm41656205e9.10.2026.10.09.00.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 00:07:42 -0700 (PDT)
Date: Fri, 9 Oct 2026 09:07:41 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Harry Yoo <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Alexei Starovoitov <ast@kernel.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH 1/2] mm/slub: preserve no-lock freeing after memcg charge
 failure
Message-ID: <asiSUpAYYU8Od4HM@gmail.com>
References: <20261001044056.75079-1-kmehltretter@gmail.com>
 <20261001044056.75079-2-kmehltretter@gmail.com>
 <asaAwg1KeZoEYd4K@thinkpad>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asaAwg1KeZoEYd4K@thinkpad>

On Wed, Oct 07, 2026 at 07:40:17PM +0100, Harry Yoo wrote:
> > 
> > Use kfree_nolock() when the allocation flags disallow spinning.  This
> > keeps the SLUB object rollback on the no-lock free path.  The failed
> > allocation continues to return NULL.
> 
> When this happens, the object is not charged by memcg.
> 
> The kernel should not invoke memcg_slab_free_hook() (called by
> kfree_nolock()) for a slab object that is not charged by memcg.
> 

Agreed. I'll avoid the memcg free hook on charge abort.

One question: kfree_nolock() currently skips init_on_free, while the
existing charge-abort path honors it. Was that intentional? I couldn't
find it discussed in the introduction threads.

If kfree_nolock() should honor init_on_free, I'll include that fix as
the first patch in the revised series. The charge-abort fix will then
reuse the shared initialization helper.

Karl
