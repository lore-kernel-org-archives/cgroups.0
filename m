Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795235730;
	b=wDrvO9GyIjWmdX+lnNn1eIyN/RIPRIJP/HZTnOcV+xI7rh1C3AYorVZ7dSxLJtHTtVuk
	 WbnVY9Ur/9dJoPOMAAObp0vCDWKlLOLEcDFdy9kh1TMn8hAS9hRcLbPvvc3w6RX2zz8bJ
	 oTmnCw9ineOLqXOY75FcSMEnYCS1j90xiCNPSQpfpkt+jd/R3MYxt60A+mj71BqU9Xwz/
	 pQNE5U2TQgh2nC6emkFgY6YIVXVWMFgCRE2A28ExYWsuGdmwfLJ7QdX8Dq7VN1571zLIb
	 2NqkK44qkyvXe8p+mRelXmpH86Hs2rIJoviEmyHmvZ1HOcij9WkhLNOIpDt4jrvbWNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795235730;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9R6zaVIvtgH5jzl+qiEpRbTjV5svwtDU6V7VCAEyGSE=;
	b=3058bll1ELv1vJa48DqWk2jqETbTJHO59VtJ5vp8QqqsaJFSgTnDvQCaCFhlhsE5kb2w
	 9LjaPW5i7T/MgSUKBioeEopT/3mwxI2aGLiK/oef+95E/Mixtr8E3HBefXFlJVWXNznfk
	 i5GcczBCO2Or0qh9pHJ0QuuhQp7NDb5uzdIYLjnwvZyktBJ3JKb4w4a1e2qXS/sDsGyKa
	 ILt8wfYod5rN8hqwrMa5Z2Q/l094jNZMdsl4fQTP1SYIXWJc1EhDzmH6EMrwhZavRxpEv
	 EhayyRpB+3oedz8sU5iHP8IH/+g2Ly/G8Nd4JANP5vrVYjJeNw3iRlrnloIvdVIHKGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rJ0c2FQa;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758EA606A6BD
	for <cgroups@vger.kernel.org>; Sat, 21 Nov 2026 04:35:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 758EA606A6BD
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rJ0c2FQa
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a210470b49so14007785e9.2
        for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 20:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795235728; x=1795840528; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9R6zaVIvtgH5jzl+qiEpRbTjV5svwtDU6V7VCAEyGSE=;
        b=rJ0c2FQaY85mIEKE24XBYeYjXwakqGKvCspyEqc+nGoiqY9yc0PAHhZJRYpl2fKHn2
         O50f1TU4idsNGR07JZbjcZU0laQtv6liqd+7rrLCV+8p6QmcHXK/IVrFnt3vTLbQie85
         3woJ9AHBJldjrKS+CSpG61enN7z2T8GquENXxfXDL7z6l0JP7DLMBsLx9HByvehXn1AH
         g1ts1UUBeoOhhEcjHszVysVxjIwWNKF3IwPiB3N3AX7UxwtVD3UGs50Gq/00NVq6a9uR
         N7vGunDQWZxzaArUXcroPjo4CKWW+yILZSW7N/gIWXLga+QzSNAgq9FwAwNexgFdkHdS
         wxvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795235728; x=1795840528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9R6zaVIvtgH5jzl+qiEpRbTjV5svwtDU6V7VCAEyGSE=;
        b=faX1A+AcraGrfjcMLsGwGZXcDFec6kpOO2izvrAzaJM8E83ZaxEcCg86mFvmZ4WkY+
         of8dmoMkRVZMUZGz3xhvjANhBAHpDOlN62bGv4MsVwteD39+3kN1tsMfASObRet4zcCE
         sijpi0AzCioLQRATAsbxNYeWw0wjOGwpvMvvMJ4e7vuVo120ptu+Gf4ifo4UKveMBnkY
         bOuvrXuPlEN26khPdlaEca8vDdwaj4jOi4+IKGrjCqnbSFYonoOytCPdqJZS3MfrPp8a
         H7SdgzQLFl3rms38AF6LHrG99yban1LlBqAxoiv8Lv8X5z90GGqwyd5JmbRhcHOn8iPm
         iUww==
X-Forwarded-Encrypted: i=1; AL+hErFgJPm7fH9+nbRDhRBzOXkMJEfD/PUCTsztbOo4BWK12UT1hjQ6MBXSwAv/UP6vnK4f+fULdbiN@vger.kernel.org
X-Gm-Message-State: APuU4Z/cYYsjl8PSBYO8z+NsTCAtdLWr0XX3y5FBxv2DlclPfFfu0njS
	LcgV9F7dEOK2BRmOEW0mrdycPgHOjXrKf2BgNFw6XdRgw1rMfzuTx3OH
X-Gm-Gg: AZFdTZd3sodg/CSevv14B4/l2OUlIrLnsFi0m5/YkEgNMkdyyBAq2mBEBMwIDBDU7o+
	CAVes2hgzdsnb/xyLHV/VBQLQn3ORWKQcrcgBDle62M3lX8cT4zpqu/GuW/DzGPC7Lyf6ZbYWto
	vL0wSzVfhiLTM0+l2GEuCOqbC5Br0e6HhT81AjMfa/3rVYZwAZDS2gpsy2fH/WfBVpRaK0v8zr5
	z3+v4JYr6Tn7YftZGgarVAbyjVGkySNW34iQwWH0hUfqzhWO44R4IDCYIe1WvCahdE15100UO1F
	xXgAVPBD6tAc69Zg6EGsemZsBjaU9qfqdMVaTN/jfJfRfD4qnFi4mLPJ61E0fZcXdpbkvk1Fc+S
	YrbwKluNMXDX9MjRAilB0my7guBDcODpzwQUMjh7kKNrRaZuouNFL+gIwT8u6ooKwWap0ALqDlR
	qEpKZL1eciCE5B4J3nIwlsmwcYtpzGQ31m6BPyzQkkASeWKO0G8lQrWc+x8zp2H0QKrOGgP3rlX
	1+4Gr/5SVEKMlHkfgBR+xqAK8dPaKPI284uQtjp9SmESAZjUKdw6u8CdwJPmT4WUbEPvgPDTbkz
	9bQ/SU18D162i1+3GEqU8Eeva3DeuYJEfpgq2OrqTqx+a9vMZroRdUKt7OAEjOrHnD73KGnjQdY
	0VuuZoJM41nyQLo+tNmyFh0D8A+jURKqHRinHXQHW1PM7y2TeAZRpvLW0leeugKdIJWbw+x3YIg
	nXV6lknOWoGUbhwr31um1ZAUfhASJtwu/R
X-Received: by 2002:a05:600c:820d:b0:4bb:7b4d:6396 with SMTP id 5b1f17b1804b1-4bb887e21c6mr111271405e9.3.1795235727586;
        Fri, 20 Nov 2026 20:35:27 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a02-3100-aeb0-6801-ad74-bca0-dc5f-7242.310.pool.telefonica.de. [2a02:3100:aeb0:6801:ad74:bca0:dc5f:7242])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8526cbd0sm214023515e9.0.2026.11.20.20.35.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Nov 2026 20:35:27 -0800 (PST)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Stevens <stevensd@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	Amery Hung <ameryhung@gmail.com>,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/3] locking, mm: Add atomic allocator trylocks on RT
Date: Sat, 21 Nov 2026 05:35:13 +0100
Message-Id: <20261121043513.20538-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20261020152708.3atPlnSl@linutronix.de>
References: <20261005070625.8871-1-kmehltretter@gmail.com> <20261020152708.3atPlnSl@linutronix.de>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, Oct 20, 2026 at 05:27:08PM +0200, Sebastian Andrzej Siewior wrote:
> What is it that you try to achieve and why. Why is !PREEMPT_RT not
> affected? Half of the problems origin from PI-boosst.
> Why has the nolock an rmutex-backed allocator.

The bug still reproduces on v7.4-rc3. 

GDB caught n->list_lock's unlock re-entering try_to_wake_up() under p->pi_lock.
kmalloc_nolock() uses normal SLUB locks. On RT they are rtmutex-backed, unlike
!RT.

> can_spin_trylock() skips hardirq and NMI. There is a trylock on the
> local_lock_t.
> Why do we have this mess and couldn't we avoid having it?

This was IRQ-disabled task context, so the check passed.

> I looked at the patches and there something about hardirq-atomic waiter.
> Wen don't have this. I don't think we want.

OK, I am dropping it.

I plan two patches: move range-tree allocation before arena->spinlock, then
restore the RT check that rejects non-preemptible callers. Does that sound like
the right split?

Thanks,
Karl
