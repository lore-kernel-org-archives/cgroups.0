Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792462481;
	b=eX3X+lvWijymBX9aV7Bp4CCFSz5VuEXAL6aZTlHkdIVABiSs5FLIzAfbRfNduxesp52e
	 S3XLsFv7uZ7DloxL3mg/z6lTYkp/t8DW5O6flxPj8WI1FNnFSXFQRr0PF6TVcHprDrYJJ
	 wrERoyta2wG76hF8lU4jegQffe/PezjdGJup2PiiSdTy7BkeNM5EyQ9Z/6cwoWnnZdfuW
	 0XogBV+U0e5taJOZ2S0U2/sX4rfWKYbYPcdTxeGz7J9Nkg1iHiYQ0uMzBaj07H9y9bvgZ
	 JyC3jQXvOrB8Y1wBQIvG1Pec3u7sWBtDzpaa1CC+5zxwgX3IL8H5H//6F+khMjYUk+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792462481;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=5Iwx53FddK31aCeF3yTsYcRGG3DAdKI2xVbjXFtQkwA=;
	b=gipIQuGHyYbQrCuO3Hs5stowT7gA39b4ZItn8Du7i9V2xWxKYZJvuEL+rRscrhWlGjBw
	 Umd7uEnaHj0DHJ5PNIqOLLWabBHqzWQR/ofWQLOoVXZ0Mq+i35P9NOhFVp6pgX/E2zIca
	 ETClPojJ5Qn5/U+afq1C/MTYZ253H+y7zY+hd76OTAQuLs/nI/Q/tsVBP8Uz7mbD27GU4
	 qAa5q2LORV7MS8H7QIN67X3UI3e0xyiMh9H2D+AXd0nWYVDXJheoP6t/AjLcgxndwVlN/
	 OZ+Xa3u8qp//bWguPBQ3i2dTHosrkKRK+QBLionObMMikxD/x52k8l75nR57GW6GMZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=oBihJ65C;
	arc=none smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4147606A31D
	for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 02:14:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4147606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=oBihJ65C
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48df54150dfso2069992f8f.0
        for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 19:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792462479; x=1793067279; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5Iwx53FddK31aCeF3yTsYcRGG3DAdKI2xVbjXFtQkwA=;
        b=oBihJ65CMLYBqYHD9hPzlwUnnU21Djjlk+0ywA8lRRGdNyRHqBkmkB2lVi7j7VuJ1l
         MPwAaFfom20siTmykpM4ACL2ty3lpQ6vyWJJmpPI8ZNX5UWUMWNCT76IcffFNMOUGFTk
         ORdK+O3A4W904mNRG0BhTfAQ3NjS8YqXkkKvnV12Bxd9kRss/cY1Tv6b9jyxrJCeHjml
         1UVPVfEtj0r/j8yx2gjVcG3pxob+11ZYhiUZjgUj33HkXufAXfebmxat2Oeiaf2Mav0z
         Vvwv6t7UGKyBpY9zHG+AYKsyBiV69wdVVX/+3Y2olVz6L5eDY0ngAgoqozcmxhtarnNO
         JaXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792462479; x=1793067279;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5Iwx53FddK31aCeF3yTsYcRGG3DAdKI2xVbjXFtQkwA=;
        b=VhIiK+hnDu5R9uj7kGI7U03SQ6ILHUFMGD/FOZZy2/XVBULjdb0eNLjyVOGwrrg9u1
         5YFsSqgebEvFdTNAfkk0L+CF40qpTy/IuX/SSIHP9zKyStwBwIk/wH0IF3cfxx0tD8GM
         cVmC3V2FFnE+BLAmTH1+FdK0b+n0YqLTcUe4PFZydQ17zUuYCYqovpaz15Q2v8OwS0LO
         ZZ71GnD9WM7TpwRDVO1oaYX6C5HS5OnvwyJlLgM4zMi0HyUYvCJ8zy7pWCYMws6ZvEmN
         0lNVju1SNqUtrFNKI0SNAdBnIG+PDIGkGrj20U/CxCQgxB89rTAQ+aJI1T71AtBYoBuY
         Mc+g==
X-Forwarded-Encrypted: i=1; AKwUvByU9KjXRUrFoFwCQVSq7P7o9iCr357vN+7NuEq05UYN9iXCVd951A5o8oK7a4LtwNM5qtqtdfgm@vger.kernel.org
X-Gm-Message-State: AFq9FYKM4R0c9RoLNo52e5SbAygC8h2kJdeQOGwnAJd7gHukdy1XTp/N
	8xkLIKdwK8joyRC/q86VesFJaN1BsG2AgeI7U0l0sZyDX37+GC6DF5G1
X-Gm-Gg: AYBFou2IXMfOWb/UFPI+H5jGkD1fWt3PKoMW1a1g5QgzVh2I8ajT+8/iMSoFOM5Q/k7
	QI+ysRcWSSEx48BAGZ08AlAtefGizchORowmRSo+fDcQD8W2xkxJRsc3I1XmuhSA1y44u5g/dvc
	VZKgLKdnxzF/VsGtsyFIBMG7m5LO9NdAL+cFx8wZIpa5pKEFnKpGvHpSaeKMyNMgCXTl50zYzR8
	kJGaSxa8nezKqmUx9Wmke+a7ytvbyn/bRHkplj0veIW+RTVgsbUOPokSfMphZTaQOJ2nwv3inlU
	eCe2akP+iuSBImcWChvC7wyQDE77gGHgrGmffNuIi5vM5gUPx/KPkcu1+4R5sENi2Jvut7C762n
	AArXlJjTeswq51evxUgMCqUY22y8OkW2ZkbnxKy8/0S0H/MHR6HoKiZZakPXwvbsxbCmO8ljucj
	op/QrzsSOYhA3YCS5uiuWAFKRC5lnSpg+9QfoE7muy+r6jzcaLp/PaVRnkwXBBsjJ56HAJmjqTs
	6Xj6elbw8gyowk8z5WUTPLTnv57ODV1wQ+995k+zZxMGYhWceKZsvzSCDyNUChmwLg8H2OnSVZM
	WTzUWKp9g3UggUylQFz0LN0n2Qnbn2jekUekHry7P/P0oGTsyHeES5UyUMpLI5xgNMLbykwCnY5
	Y7z5xQoT+sw==
X-Received: by 2002:a05:6000:491d:b0:488:5852:6ee3 with SMTP id ffacd0b85a97d-48e07bc2f43mr19882172f8f.34.1792462478968;
        Mon, 19 Oct 2026 19:14:38 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-9c92-6501-cda9-90cd-4e49-75d9.310.pool.telefonica.de. [2a02:3100:9c92:6501:cda9:90cd:4e49:75d9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e1d8208b1sm2879816f8f.33.2026.10.19.19.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 19:14:38 -0700 (PDT)
Date: Tue, 20 Oct 2026 04:14:36 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Harry Yoo <harry@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Stevens <stevensd@google.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Shuah Khan <shuah@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/3] locking, mm: Add atomic allocator trylocks on
 RT
Message-ID: <atbOS2rs94fB2red@gmail.com>
References: <20261005070625.8871-1-kmehltretter@gmail.com>
 <asZ8jmWNoGk5tYce@thinkpad>
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
In-Reply-To: <asZ8jmWNoGk5tYce@thinkpad>

On Wed, Oct 07, 2026 at 07:15:29PM +0100, Harry Yoo wrote:
> On Mon, Oct 05, 2026 at 09:06:22AM +0200, Karl Mehltretter wrote:
> > On PREEMPT_RT, a BPF task-storage program attached to sched_waking
> > can deadlock when kmalloc_nolock() obtains an rtmutex-backed allocator
> > spinlock while try_to_wake_up() holds p->pi_lock. Releasing the allocator
> > lock can enter priority-inheritance or wakeup code and re-enter scheduler
> > locking.
> > 
> > The first RFC [1] rejected every non-preemptible caller. That prevents the
> > deadlock, but it also rejects BPF arena allocation and faults under the
> > arena's ordinary raw lock.
> > 
> > This RFC instead adds an atomic owner state for bounded PREEMPT_RT spinlock
> > trylocks. Atomic acquisition succeeds only from the completely free state.
> 
> Please don't skip discussion stage and jump into submitting a very
> intrusive change across locking and mm, assisted by LLM? :/
> 
> I don't think attempts to tackle this problem will make progress without
> discussing and getting buy-in from (PREEMPT_RT) locking folks.
> 

Sebastian, Peter, Thomas, did you have a chance to look at the locking
direction here?

Thanks,
Karl
