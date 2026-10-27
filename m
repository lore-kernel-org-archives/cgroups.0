Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793125033;
	b=oNjDGwAYUjufgXvFqfZDOtk8ygR7JOJkqErv5xf9ugCrtTCgjVgxFACe3TpciUA4EPhk
	 2pj4SAUl6XnAKVGjRyJ+e42O/hNrzVCvSYoRFrzyRl0pCm3lv1eAThowOmOjjQJypXSuc
	 KH1RSOtlFNIoykUGS1/Jl3IaQ4XDR3xnfCbRwaF5gNHfPlfQ3sMZXYmPUWTRBxY0IJQLB
	 wZ5BFcnNayl4WBnAl7XQFpAPNnFrVngiASH95VykkiTPdJR1bdEU4zDMI7B2L/f3l3g7I
	 99QwHF4YgfBP/WOViJs8W1MLUbOPm8MFjXI1FrHg28xGMcoXzPPuJREtO3D40xE+jpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793125033;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References;
	bh=BQlG+dpy8YjBQ/Jf8HDAX4aO1LrQ0VKAd1X1FNGlEsc=;
	b=ydZxHM1FTxOwNYGeKHuCcwOpP2FCqg1peeharRkys3ckSn4oRIJpFd8sM4rE9WMFAWMs
	 hOFFNxn5Sf2D5Q5R6s+bzbabmL01o/RpN9Po6PeVyzCYiHDz4+v7Df3d7CXlBYAyb+i3K
	 QwrlJYMwM17G96vc/+4ZQl2PyukcfMEKcrX+i01uKRrBwD8kQAxRkwztdf/YDdnN92/zZ
	 M4yhfb+9KWDd36FWutp5kObQs8INneuewYT6jhR+GV5pKISabpDieQHwX/tDoyapb3NSj
	 cVfUryrC9d9Prniftp89AEJNTLvFmsngl2RTUJFIEFhqXafVPi+XtfvIcfgudgDeVAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jLPqgKVf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2CF606A31D;
	Tue, 27 Oct 2026 18:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jLPqgKVf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6511F031E5;
	Tue, 27 Oct 2026 18:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793125032;
	bh=BQlG+dpy8YjBQ/Jf8HDAX4aO1LrQ0VKAd1X1FNGlEsc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=jLPqgKVfOPVsDgLwoMZ16UseK8OHOo8JpJwNW/YVi0kw3fyQlEsd/UVg32FMZs3OW
	 r4P5KEJCPIj/KOyDQJDreVJVPyrB9ZKlgbeWThq5yAcHYydcr3eWO39CsPMsWs4YzX
	 ty8ec6TIzned9CARBFQmSPik48yQoBZn5DuK+GyZh73+m/oGiaCpMUsswuEpUy1+/B
	 23Ww8KgzPaUGxYKedH2WJ6EK08iuAw/pGCySpsh73GwcFgXbpCs1fGhaD+DjqHzW4p
	 yCNW05kom5Kf5o1qvD3E9oL7GPtzdiHaTHg/5xmtSzKc2wlh09rM45Nyjj1+dO0iMI
	 u+HyATTnHHaaA==
Date: Tue, 27 Oct 2026 08:17:11 -1000
Message-ID: <769e80ffa618327ac03c13c4657e7229@kernel.org>
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
In-Reply-To: <cover.1793086858.git.zhuhui@kylinos.cn>
References: <cover.1793086858.git.zhuhui@kylinos.cn>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list

Hello, Hui.

On Tue, Oct 27, 2026 at 05:11:58PM +0800, Hui Zhu wrote:
> Why it matters: memory.low and memory.min protect a cgroup by a fixed
> threshold and have no idea whether it is using the memory.  A
> high-priority cgroup that holds a large working set and then goes idle
> keeps suppressing reclaim on its siblings, and that memory is wasted.
> A policy program sees the real activity - page faults, charges - and
> can grant or withdraw protection as it changes.

This doesn't justify the changes. Why can't the same be achieved by
adjusting memory.low and memory.min from userspace? The arguments made
so far are neither convincing nor proven.

Thanks.

--
tejun
