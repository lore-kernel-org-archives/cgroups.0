Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794582301;
	b=BGq3GuIBTVCAxJIDpLNenSmFdKk3bcU6IjmmPcdhKI/tCftZRqGtj1iGOD2Tjs1IxB0l
	 cT/zKWvwhHDiqV17zaCAhrZXZ4JIeqs6zcplynGarqwSvdFyMWJA+E88ApaWPVYs0d9OQ
	 Mq9XZ8WANPAyI/hH2ODeydMji/WN/Rv1ini2dYgrqe3RZN0dhB3l8K7VTz2RI4KMbWVfm
	 qmZX0AVJOEwgDyHtTH4dBUz1sJhZtFOm2bZcwVsTVataqNj68JvcoxZqUp3D1sJWdJo1X
	 cpuQfs/qLevuLx2qSQU9Vdw7sYAiqR/4VpoVKoCv1k0QBs5xFCzF6yZcSv6Qv8ZYCbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794582301;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KemPF4UyXFCnRn0FFZM6lfFKM0OQmZfUuPBKXbcJpj4=;
	b=vr1Ej/DYE4sNBG/WVIFSeMlj63dwRhPSlfC0+u9bC2RmLf1Q+KjZzb8vN+pxxwcwTw9q
	 +7R+AqZR7sD9nrUF/NED3GmpnnWYvco4BNbMpkuNqqxAKOU/JIJbHRIghu7urkZ7Icqgq
	 38Fh3yV1CvRAGWYjN5VSbrdNFtNY8jruQl5oHru7BbfGDR9bH+0VWXXuEdwWLrtWInruG
	 0yExsax5kxpPvQnb8q3NFWfoPXOdqex8lXQ+aeCM+o0aWCuyLu7CBXD24vQE1uQ6r9A3N
	 MVcmJFQaQDuoA2L7RdIHGodU819MCc98HcjJuRfQ9iL9hq+g9QmWE/DsYeiPmXpGwSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YRzKTiO8;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE32606A88E
	for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 15:05:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6CE32606A88E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YRzKTiO8
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-498f5fa5103so464111f8f.2
        for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 07:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794582300; x=1795187100; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KemPF4UyXFCnRn0FFZM6lfFKM0OQmZfUuPBKXbcJpj4=;
        b=YRzKTiO8grTuhhH901jJ29obt0j4Vt+j43mhWEoTgbm1muLsCcdfRcEaCkVPj6ommm
         TzC2ro3m2xKqeVvot75B49gn6BAIu5fwOPn6dPQx5xru6EMzZoJIyhaD60IONKHoCPcb
         7uIIXD6A7rTrBEi076STClaiA50f8iR1Gn8EdaKRwK+BdqTfpy1eaKQABYeC4scIIHzs
         J02TFbKm7Rn3I+TWXFraArR9NqrdYPCKpeMQRJsAfrR6hv2GGI+o+zI6mMzQAgZpp8tj
         g1Rd1XrgKCppTBbiBEPdjuMH6qkBKMsx/4YCgdroaqU7fOldE+uJWAbdZp6o7PjcQCcu
         IqVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794582300; x=1795187100;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KemPF4UyXFCnRn0FFZM6lfFKM0OQmZfUuPBKXbcJpj4=;
        b=jJhIrehYmNFHVL3dSweaQ4aszX2aaBushK/r30I1VKvGety+2n+HzdTGDNrlzvRNXZ
         n3XseDFymvQIBzd9R7zezhkdxXpbu7y2ncxpgG0fLzySb5ObWy97o41V5+vF6ktP0L/c
         1EHIma4dmFkr+bVZhE1wVw2Fxfg3fqo/o7CLnZ1AUVeqRmBSmbWwqbF56MCqlp8SL84E
         yBv/GMhO31V1HjoC0uPimLrjy/GPiVyaHyOGJJRJYz6YU0nhuf2+wQ2vtRoMdsrkrH5+
         PcowLHoaUQr4fiZKmFdIWf84s1PXlvaexwVst6P2a9oheT0gK868kYvNKtBfnaw3zxoP
         w25w==
X-Forwarded-Encrypted: i=1; AL+hErEwTIYw536dv+Ho9e2+ZzHUjRCPpHGTBzznTi7dmlrIlgExjU+A3/OuAg/bdAefnGFIc0pbZqei@vger.kernel.org
X-Gm-Message-State: APuU4Z/d02nWoHfDUMVLUypzgD1dk79cCBAlMbKy7tBPhiOKVk49Ik0V
	7DR74Tok00p5alYk2Kjx1NVzBDH2iEi7w++cROZFV7w/1zB+9touWYGj
X-Gm-Gg: AYBFou0lTrKFcdw23WtERonEPWlk378fmrNzOZoX6T+lE91Un9gQGSVI2UbwEU5BSgj
	Gx3kngMvn8gqys6IfZuG07aG4AJ+jlTe+ZguR2brX/9PqU8X1QAU66N0DjtBuDsz75wYXn4h/oh
	Fw2kq8RFUGvbWm4H0xQXZzDKeLenKT9DJly1OVlfBOXTyFRxBRnGxE8/cqVLxLQyG9MXA07FA3t
	63Bnu5GiMfOJof9fPJV/yTQVHGipifscjbJrEmrIk3zo7Tfq5czTphYV/6zWSAtoxuErLTTlVYj
	LkwQqSTE+8Ud87W8DHyS+GVVRzLev7FZdvWxttwu0+c5chWqhC8wMK4k8KG+e6FwfKZZ+/wfr7y
	XLrEcgmjfhyIOVDQXMWhGLahwnK6Q+rSiJbw6UtG9gvD9GfenbbBq4zUA4rZT9vEc7N78AmWkgG
	+nIUvXOrMGWb78qBsNzi3ATIUG4Af9yqrw6yutA8tp3k6fvA7WH+MC10LwBkI3/tlo7SObQBsc3
	dy0pqNDJb/qpOp38PnBkV3abb5W28YbLmerlX6QfIatDmmSYhbNBYrloPRCF7En91MYmxfFt4r0
	BRtM4pit6Muf5dL43ivzCWOSNeaT2jhdcBbwJyPywUQ4sKt3qZgQZNy2g5SgACUy6UYb5zlY2G8
	fSQ==
X-Received: by 2002:a05:6000:2486:b0:493:5d67:499 with SMTP id ffacd0b85a97d-49c712ac9edmr5552285f8f.14.1794582299355;
        Fri, 13 Nov 2026 07:04:59 -0800 (PST)
Received: from andreayoga.wind3.hub ([31.189.56.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f1c1797sm6390874f8f.11.2026.11.13.07.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 07:04:58 -0800 (PST)
From: Andrea Parri <parri.andrea@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrea Parri <parri.andrea@gmail.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org,
	linux-kernel@vger.kernel.org,
	tglx@kernel.org,
	will@kernel.org,
	boqun@kernel.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	luca.abeni@santannapisa.it,
	mathieu.poirier@linaro.org,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	m.szyprowski@samsung.com,
	kayracizmeci@gmail.com,
	weihengqiuu@gmail.com,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v5 18/29] sched/deadline: Move a task's bandwidth only where room was made
Date: Fri, 13 Nov 2026 16:04:36 +0100
Message-ID: <20261113150438.9119-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <d58e067d-05ae-4e4d-9d34-b0ac2741b211@efficios.com>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com> <20261108185406.1549770-19-mathieu.desnoyers@efficios.com> <avVk0UU8IRGoo77v@jlelli-thinkpadt14gen4.remote.csb> <d58e067d-05ae-4e4d-9d34-b0ac2741b211@efficios.com>
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

On Fri, Nov 13, 2026 at 08:35:03AM -0500, Mathieu Desnoyers wrote:
> Hi Juri,
>
> > > +/* The caller made room for the deadline bandwidth in the new root domain. */
> > > +#define SCA_DL_BW_RESERVED 0x20
> >
> > Why not 0x10?
>
> No reason. 0x10 is free. The planned next version uses it.

Hi Mathieu,

A heads-up, since both are under review: [1] adds SCA_DL_CHECK as
0x10, so if your next version also takes 0x10 and both get merged,
the result would build with the two flags silently sharing a bit.

Your plan in [2] to change the affinity check and the early exit also
overlaps [1], which moves dl_task_check_affinity() into
__set_cpus_allowed_ptr_locked(), right above that early exit.

I'm happy to rebase [1] on your series, or the other way around,
whichever is easier.

[1] https://lore.kernel.org/20261105164856.29698-1-parri.andrea@gmail.com/
[2] https://lore.kernel.org/94d8d7af-b04f-4c59-ae3b-e693d4457a65@efficios.com/

Thanks,
  Andrea
