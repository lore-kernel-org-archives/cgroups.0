Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.119
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793183263;
	b=vos0MvL6h+rnZu4etv3O0SIJh326ZDGYk1tYO5u5awjIxdkKtoEh8EOKTBRumztCn/6b
	 +myeMytl9rDZSLHXlFo0pneGSutmo89vUybA32BkAcr4eB97mvma3RinQc3/ZhT72EIpX
	 LwGEuUJNqh74UsVNx5oPjseyjrpys1S9k8wKjH4C2zVbs2Ur3TGxf6P/YRnF4QGFlk5db
	 VL7M9bOOQ0tHCgRNkw3e9S9nT+aymT83XVq24FOfk8WqabMlR06e9zWzpGfLsrzYU8Ppr
	 gqthPZDTeBTc2ShXGKNXNDhzKUnlAdyHhTh9nUgrvvN5WiU1O1+GMAAyvovF7JBuzqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793183263;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=CAsQNlvEQewVVFce1WqlpSDwej6JOKTiJP6Vd2oTTAg=;
	b=NS6ENpZUW8Yx07vq10Uk115KuCgWSeLe+V6I6fv+D7Ymv1svH9NMyvsH6O/KQxadyuDs
	 Z+zHaS5k3Ir5TUon7SQRYLpDN2uEKgzFXZCnBnemlUgqDXWdpk2FZpkpl/qnfuYGw/ie/
	 hsbooumtbd28mAg55QLb+6cP6q0F0qGTspCTjpb8vR7lbwjcECot+YUy9NmgJIj6ufSrY
	 3xwKa0C95JYCjm/XYT8BgixwSvbonOvxlKjBQwQwnLj3T1Q5Xml6pIcybphB0sh3UGZnX
	 6rRE7dSyJmaaZo1Qb5F3LERKccuRVTNPLfaMNIwiKC+qyQZ/agRf68O+TOvItzjxoGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="Jmwex/kK";
	arc=none smtp.remote-ip=91.218.175.119
Received: from mta0.migadu.com (out-119.mta0.migadu.com [91.218.175.119])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF45606A31A
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 10:27:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6EF45606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Jmwex/kK
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=OSNgAFP+VgQv9q7o9VlptAb+MUtYzG3jKiN7D8DtKj8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793183254; v=1; x=1793788054;
 b=Jmwex/kK7FpuCV4bqSsS5FCwcMt+EqZgDLePJZ4dvcrpEr4L/YHoyx7QKjmO1CIocO5OCbGr
 tkZmoFbOPWPIzOshnL3/DpTiXzlghHbrudm38WhVc3KkL5yD0mKtIroNlIaYfbth6p94x+Qcx/Q
 vj7/M3C4X89z4qZWGeENzS/M=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ee56cd7c32368443;
	Wed, 28 Oct 2026 10:27:33 +0000
X-Mizu-Trace-ID: ee56cd7c32368443
X-Migadu-Flow: FLOW_OUT
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Wed, 28 Oct 2026 10:27:33 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Hui Zhu" <hui.zhu@linux.dev>
Message-ID: <c652f3e6198b143fcf29f5540a769228f3d8470c@linux.dev>
TLS-Required: No
Subject: Re: [RFC PATCH 0/2] memcg_ext: dynamic memory.low and memory.min
 protection
To: "Tejun Heo" <tj@kernel.org>
Cc: "Alexei Starovoitov" <ast@kernel.org>, "Daniel Borkmann"
 <daniel@iogearbox.net>, "John Fastabend" <john.fastabend@gmail.com>,
 "Andrii Nakryiko" <andrii@kernel.org>, "Martin KaFai Lau"
 <martin.lau@linux.dev>, "Eduard Zingerman" <eddyz87@gmail.com>, "Kumar
 Kartikeya Dwivedi" <memxor@gmail.com>, "Song Liu" <song@kernel.org>,
 "Yonghong Song" <yonghong.song@linux.dev>, "Jiri Olsa"
 <jolsa@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, "Michal
 Hocko" <mhocko@kernel.org>, "Roman Gushchin" <roman.gushchin@linux.dev>,
 "Shakeel Butt" <shakeel.butt@linux.dev>, "Muchun Song"
 <muchun.song@linux.dev>, "JP Kobryn" <jp.kobryn@linux.dev>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Shuah Khan" <shuah@kernel.org>,
 davem@davemloft.net, "Jakub Kicinski" <kuba@kernel.org>, "Jesper Dangaard
 Brouer" <hawk@kernel.org>, "Stanislav Fomichev" <sdf@fomichev.me>, "KP
 Singh" <kpsingh@kernel.org>, "Tao Chen" <chen.dylane@linux.dev>, "Mykyta
 Yatsenko" <yatsenko@meta.com>, "Leon Hwang" <leon.hwang@linux.dev>,
 "Anton Protopopov" <a.s.protopopov@gmail.com>, "Amery Hung"
 <ameryhung@gmail.com>, "Tobias Klauser" <tklauser@distanz.ch>, "Eyal
 Birger" <eyal.birger@gmail.com>, "Rong Tao" <rongtao@cestc.cn>, "Hao Luo"
 <haoluo@google.com>, "Peter Zijlstra" <peterz@infradead.org>, "Miguel
 Ojeda" <ojeda@kernel.org>, "Nathan Chancellor" <nathan@kernel.org>, "Kees
 Cook" <kees@kernel.org>, "Jeff Xu" <jeffxu@chromium.org>,
 mkoutny@suse.com, "Jan Hendrik Farr" <kernel@jfarr.cc>, "Christian
 Brauner" <brauner@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>,
 "Brian Gerst" <brgerst@gmail.com>, "Masahiro Yamada"
 <masahiroy@kernel.org>, "Willem de Bruijn" <willemb@google.com>, "Jason
 Xing" <kerneljasonxing@gmail.com>, "Paul Chaignon"
 <paul.chaignon@gmail.com>, "Lance Yang" <lance.yang@linux.dev>, "Jiayuan
 Chen" <jiayuan.chen@linux.dev>, "Emil Tsalapatis" <emil@etsalapatis.com>,
 "Ihor Solodrai" <ihor.solodrai@linux.dev>, "Barry Song"
 <baohua@kernel.org>, "Geliang Tang" <geliang@kernel.org>,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org, "Hui Zhu" <zhuhui@kylinos.cn>
In-Reply-To: <769e80ffa618327ac03c13c4657e7229@kernel.org>
References: <cover.1793086858.git.zhuhui@kylinos.cn>
 <769e80ffa618327ac03c13c4657e7229@kernel.org>

"Tejun Heo" <tj@kernel.org mailto:tj@kernel.org?to=3D%22Tejun%20Heo%22%20=
%3Ctj%40kernel.org%3E > :


>=20
>=20Hello, Hui.
>=20
>=20On Tue, Oct 27, 2026 at 05:11:58PM +0800, Hui Zhu wrote:
>=20
>=20>=20
>=20> Why it matters: memory.low and memory.min protect a cgroup by a fix=
ed
> >  threshold and have no idea whether it is using the memory. A
> >  high-priority cgroup that holds a large working set and then goes id=
le
> >  keeps suppressing reclaim on its siblings, and that memory is wasted=
.
> >  A policy program sees the real activity - page faults, charges - and
> >  can grant or withdraw protection as it changes.
> >=20
>=20This doesn't justify the changes. Why can't the same be achieved by
> adjusting memory.low and memory.min from userspace? The arguments made
> so far are neither convincing nor proven.
>=20
>=20Thanks.
>=20
>=20--
> tejun
>

Hi Tejun,

Thanks for taking a look.

You are right about that paragraph.  It describes what dynamic
protection does rather than saying why it has to happen in the kernel,
and at the timescale I described a userspace agent writing memory.low
would keep up fine.  I will drop it.

Let me try to say what I was reaching for, from the code rather than
from a benchmark - a comparison between BPF and a userspace agent would
say at least as much about how well I wrote the agent as about the
interface, so I am not sure it would settle much.

memory.low is a request, and what reclaim honors is elow, which
page_counter_calculate_protection() derives on each pass from the
parent's elow, the siblings' requests and the tree's usage.  At the
first level below the reclaim root that comes out equal to what was
written, and there the knob is enough.  Deeper down it is capped by the
parent's budget and shared out between siblings according to what they
claimed and what they use, so what a cgroup wrote and what it ends up
with can differ.  As far as I can tell none of that is visible from
userspace: memory.low reads back the declared value, and I could not
find anything that exports elow.

Exporting elow would not help, because elow is not a property of the
cgroup alone.  It depends on the reclaim root as well, which is why
page_counter_calculate_protection() warns that it is not stateless and
is only valid as part of a top-down tree iteration, and why
mem_cgroup_protection() carries the example of a concurrent global and
targeted reclaim driving a child's elow to zero.  A file would show
whichever value the last reclaim happened to leave there.

So the derived value seems to be usable only where it is derived,
inside the check, and that is where low_policy() sits: it is evaluated
per pass and is handed that pass's own inputs - the memcg, the reclaim
target, the elow just computed, the usage - instead of being state that
is read at the check.

The other half is what a policy can key on.  memory.low has one
dimension, bytes.  A policy program is not limited to the ctx it is
handed; it can also use state that other BPF programs keep, so
protection can be a function of activity rather than of size - a
workingset refault rate, for instance.  [1] reads those counters from
BPF and acts on them; it drives reclaim rather than answering a
protection hook, but the signal it reads is the one such a policy would
want.  The limit is on the output rather than the input: the hook
returns a boolean, so it cannot grant anything memory.low cannot.

I would be interested in how you see this - in particular whether the
nested case is worth supporting at all, and if it is, whether this is
the right shape for it.  I am happy to rework the patches, and to add a
demonstration of one concrete policy if that would make it easier to
judge.

[1] https://github.com/teawater/memcg-async-reclaim/tree/memcg_ext_plus

Thanks,
Hui
