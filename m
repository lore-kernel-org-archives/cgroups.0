Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0773AFAE6
	for <cgroups@vger.kernel.org>; Wed, 24 Jun 2026 13:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782306370; cv=none; b=rEMTtsZzNELTs7J+rktTezdhyF4amfHUbejuoG3WmE0o0awPawDJUDf14wXS8kGYxdsE3V/lyeUuVKVDqe4bN3ArS++CWU8+G6srHChIpHfISCmas9G4Sj7lQ8Pd5fry/zp4kPtaBdhknmKoria09fNdu8BDZ6Cee5ncuAeHVcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782306370; c=relaxed/simple;
	bh=DuA83fRrvg9FcK3+uKVtP7zDj3cARtxSAMCxIPj6Ris=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GxQqwB5bcDD6p6fXOfyETLmurFkaLYTxla0hFM9/fNj9sFkoue3r4JeQVmzkrU7L24UQp9n10Yvvl4mealxKEV3SYQTZVs8S1jQzl1UlMs9q9O+PP5zukQSMi35RjNw89OXPZasPrPuX76JefqAIRermLVNM4PknZjZmnVYCxvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t7N5AMoP; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="t7N5AMoP"
Message-ID: <96334e07-dbd9-47a0-93f5-ac4762b7b919@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782306356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z2iAFOHBRMR/Xa17pT7sXAqMACpdvIbkzmpfw9EGJVs=;
	b=t7N5AMoP0/i8dFY3FrC7HO2yNmLfeZFETlWYqXUODrlmNpqyaftZywjo0y9UNn13O8QGRa
	AXb39zIwwMhdHGGwdLIWZOxZlc/RB5gme76K1wm+eYFw8s2/p0wLK8vNz3AEO2CElTbLsC
	uEFuGXWFUWXMM2nzKZ+r26KvGnuXTwQ=
Date: Wed, 24 Jun 2026 21:05:32 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/7] Prepare mutable list iterators to cache cursor
 state
To: Jani Nikula <jani.nikula@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Tejun Heo <tj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Paul Moore <paul@paul-moore.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: David Howells <dhowells@redhat.com>,
 Simona Vetter <simona.vetter@ffwll.ch>, Randy Dunlap
 <rdunlap@infradead.org>, Luca Ceresoli <luca.ceresoli@bootlin.com>,
 Philipp Stanner <phasta@kernel.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 linux-ntfs-dev@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, audit@vger.kernel.org, bpf@vger.kernel.org,
 netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kexec@lists.infradead.org, live-patching@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-pm@vger.kernel.org, rcu@vger.kernel.org, sched-ext@lists.linux.dev,
 linux-mm@kvack.org, virtualization@lists.linux.dev, damon@lists.linux.dev,
 llvm@lists.linux.dev, chengkaitao <chengkaitao@kylinos.cn>
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
 <88f34c7fa5a3d1700cc8005818751d6aa31f09df@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <88f34c7fa5a3d1700cc8005818751d6aa31f09df@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



在 2026/6/22 16:37, Jani Nikula 写道:
> On Mon, 22 Jun 2026, Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
>> Add *_mutable() iterator variants for list, hlist and llist.  The new
>> helpers are variadic and support both forms.  In the common case, the
>> caller omits the temporary cursor and the macro creates a unique internal
>> cursor with typeof(pos) and __UNIQUE_ID().  If a loop really needs an
>> explicit temporary cursor, the caller can still pass it and the helper
>> keeps the existing *_safe() behaviour.
>>
>> For example, a call site may use the shorter form:
>>
>>   list_for_each_entry_mutable(pos, head, member)
>>
>> or keep the explicit temporary cursor form:
>>
>>   list_for_each_entry_mutable(pos, tmp, head, member)
> 
> I'm unconvinced it's a good idea to allow two forms with macro trickery,
> *especially* when it's not the last argument you can omit. I think it's
> a footgun.
> 
> IMO stick with the first form only, and there'll always be the _safe
> variant that can be used when the temp pointer is needed.

Could we go back to the v1 version? What do you think of that
implementation approach?

https://lore.kernel.org/all/20260529082149.76764-1-kaitao.cheng@linux.dev/

-- 
Thanks
Kaitao Cheng

