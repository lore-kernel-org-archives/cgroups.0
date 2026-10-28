Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207946;
	b=JHZLRY7YH4ZqzCf2fBBPbAB6eLqfmZ1q7YdHjoCa9awR2twpPBBVH/Mpme6XUbK927O3
	 T97K3NjSjRWCgPpj/REys7yxSxcGXjXRWpPb48hnVh50myZv7GImiwViR0qH9YaA4wX8h
	 ty74nM9P4xRLkt/u+PmTfXkKMWFLYvXbrKUMxKVYWns89Bt8Jlfh1HQPR8L/oewyFqCAg
	 //gsGOwkac0N7sGHF1w9t5qXvc4zMANwV+e3MvMyOmWSH8ty9pi8q0VkV6BBxHeTAlUwS
	 kZJd7kzdQni2W5WNNmjoPDCmUJ5R7yQUTsYJGV9RBHbWI1j20Cg3xnEoQxDEKmz0ykw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207946;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References;
	bh=iA59H/LDNhkaV57ivIpVgCN8zVjfYFqLt84NAT8Jikg=;
	b=l99B9pCp2t5aVP94SJ+EqpgXtoZoyygLgIKlzF6sSM6um80cZq90yyN0HRET+Yu5Z1+g
	 lvZIvBe5ZXCQEwCyULtliqzZpGqzXg4Gx4GYUVu1tXociRkIykcJaBtOsn5ECMueJFppH
	 PPVSuOffBvr16aeEJ2a4UF/EmBpo1eH6HPW8j1OXH+Wc0n6J1zmX6ucO5MBWUEPwGf1V7
	 bRtecm3rQ36aAdy937ygJoQDhylIsxVu3WHO1/f5oAtWcEO62jQARiDHT2graA6dC1fls
	 Ef9wZ/PvTZGj1FtNMEsV1jxVreQomHgxnD0XSgPAAxP32Sc8sBW9ZPfF0z7XIZtisSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MeiUkkTx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11C0606A31C;
	Wed, 28 Oct 2026 17:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MeiUkkTx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCFE1F01825;
	Wed, 28 Oct 2026 17:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793207945;
	bh=iA59H/LDNhkaV57ivIpVgCN8zVjfYFqLt84NAT8Jikg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=MeiUkkTxcl/ZYalrXsKfZK5vIOlQrmac2J0jzKLvwfTSVkHW/EqJju3D2t5LraDBO
	 HFBWcUhcKn1N9O9rwcgt7ycPunBlHdJaWWUmKIi5Obw31rPdeq3wBL2J4pJ0nVXidE
	 JqByT/tUR5FPDpjikQrL4ioCo1Wm45zMK8adF6UPkLnSHnXG0Df4ZvmeRfQWJm7JT/
	 v6Cf33DnRjATzw74NYdsy5RY49irRJk+HTAvPxntr1fG3+RRLiOPcAkl/iNMPw1Nh8
	 S+PflWOLZEOebmXde98cg5hbdX57G7CmBYnXk5vhP+A0kOxw6ai7w29GpWVoPhRJFE
	 dOLHhWgZtzAMQ==
Date: Wed, 28 Oct 2026 07:19:04 -1000
Message-ID: <5572f45165fa3ec7d16e1d17eb2c3fb6@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 John Fastabend <john.fastabend@gmail.com>, Andrii Nakryiko <andrii@kernel.org>,
 Martin KaFai Lau <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, JP Kobryn <jp.kobryn@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
 Jesper Dangaard Brouer <hawk@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
 KP Singh <kpsingh@kernel.org>, Tao Chen <chen.dylane@linux.dev>,
 Mykyta Yatsenko <yatsenko@meta.com>, Leon Hwang <leon.hwang@linux.dev>,
 Anton Protopopov <a.s.protopopov@gmail.com>, Amery Hung <ameryhung@gmail.com>,
 Tobias Klauser <tklauser@distanz.ch>, Eyal Birger <eyal.birger@gmail.com>,
 Rong Tao <rongtao@cestc.cn>, Hao Luo <haoluo@google.com>,
 Peter Zijlstra <peterz@infradead.org>, Miguel Ojeda <ojeda@kernel.org>,
 Nathan Chancellor <nathan@kernel.org>, Kees Cook <kees@kernel.org>,
 Jeff Xu <jeffxu@chromium.org>, mkoutny@suse.com, Jan Hendrik Farr <kernel@jfarr.cc>,
 Christian Brauner <brauner@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
 Brian Gerst <brgerst@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>,
 Willem de Bruijn <willemb@google.com>, Jason Xing <kerneljasonxing@gmail.com>,
 Paul Chaignon <paul.chaignon@gmail.com>, Lance Yang <lance.yang@linux.dev>,
 Jiayuan Chen <jiayuan.chen@linux.dev>, Emil Tsalapatis <emil@etsalapatis.com>,
 Ihor Solodrai <ihor.solodrai@linux.dev>, Barry Song <baohua@kernel.org>,
 Geliang Tang <geliang@kernel.org>, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH 0/2] memcg_ext: dynamic memory.low and memory.min protection
In-Reply-To: <c652f3e6198b143fcf29f5540a769228f3d8470c@linux.dev>
References: <cover.1793086858.git.zhuhui@kylinos.cn>
 <769e80ffa618327ac03c13c4657e7229@kernel.org>
 <c652f3e6198b143fcf29f5540a769228f3d8470c@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list

Hello, Hui.

On Wed, Oct 28, 2026 at 10:27:33AM +0000, Hui Zhu wrote:
> memory.low is a request, and what reclaim honors is elow, which
> page_counter_calculate_protection() derives on each pass from the
> parent's elow, the siblings' requests and the tree's usage.  At the
> first level below the reclaim root that comes out equal to what was
> written, and there the knob is enough.  Deeper down it is capped by the
> parent's budget and shared out between siblings according to what they
> claimed and what they use, so what a cgroup wrote and what it ends up
> with can differ.  As far as I can tell none of that is visible from
> userspace: memory.low reads back the declared value, and I could not
> find anything that exports elow.
...
> So the derived value seems to be usable only where it is derived,
> inside the check, and that is where low_policy() sits: it is evaluated
> per pass and is handed that pass's own inputs - the memcg, the reclaim
> target, the elow just computed, the usage - instead of being state that
> is read at the check.

The visibility of effective values is a problem of wider scope, not an
argument for implementing bpf struct_ops. There were discussions in the
past on whether we could expose some meaningful effective value. They
didn't lead to anything conclusive, and we may yet find a way to expose
something more useful.

Also, the hook doesn't use elow to decide anything. mem_cgroup_below_low()
and below_min() return true as long as elow or emin covers the usage.
They ask the policies only once the usage exceeds it, and the only
answer a policy can give is BELOW, which makes reclaim skip the cgroup.
So, what the hook buys in the nested case isn't access to the per-pass
elow. It lets a cgroup escape the ceiling that its parent's protection
imposes on the subtree.

Some of that may be innate to nested protection semantics. One
shortcoming may be that there's no way for a parent to "passthrough" in
terms of protection, because there's no way for a parent to be neutral.
If its memory.low is too low, that's the ceiling for the whole
subhierarchy. If it's set high, the subtree gets the total protection
one way or another. There may be arguments for a different semantics
which changes the shape of the protection.

However, it doesn't make sense to let a BPF program escape the parent's
policy, and, again, none of this is an argument for adding bpf
struct_ops.

> The other half is what a policy can key on.  memory.low has one
> dimension, bytes.  A policy program is not limited to the ctx it is
> handed; it can also use state that other BPF programs keep, so
> protection can be a function of activity rather than of size - a
> workingset refault rate, for instance.  [1] reads those counters from
> BPF and acts on them; it drives reclaim rather than answering a
> protection hook, but the signal it reads is the one such a policy would
> want.  The limit is on the output rather than the input: the hook
> returns a boolean, so it cannot grant anything memory.low cannot.

These signals are all available to userspace. The workingset refault
counters are in memory.stat, PSI is in memory.pressure, and whatever
state other BPF programs keep sits in BPF maps which userspace can read.
So, the inputs aren't the difference. What's left is how quickly and how
often the protection gets adjusted.

That may be an argument, but nothing so far shows that struct_ops is
needed for it. Can you demonstrate a realistic and useful scenario which
can't be achieved from userspace but can be with struct_ops?

Thanks.

--
tejun
