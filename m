Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74ABA48CD5B;
	Thu, 13 Aug 2026 17:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786640867; cv=none; b=sUa4PrANtPv4Kp4fzZrmpKpYWUlHwuIBdK25QZBvAI3aD5LpgBBpKkD6UaM0dKnMoo9ik7P+YFmc+EaE5r9WPvs8BJmNGq3htmRJ4R+NM997Ainhdn1Iy/Ry8AEVgA8rZ/NnZZajC4RdrdfQTf6dYqI8OFuUTs+8PHRnUS3qpvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786640867; c=relaxed/simple;
	bh=C9QwBrIM5q6k4hdVreq12DlUAvQG066COtPYSj38ois=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=r4oCSGXc3vS2N7RruDGtPK5Uf/mrBx8iDriR6u6jGw8IWdotYIB77FC3gttO8j55gNdpS9NGwvOgtm7tjR1zgEzVYLoXZCve8OcoUmTfxE5Dq9dYEMWvPdWeK27SZONlFeqMODVI8NOOpPLENkcVrRONXE0DjkMkQIQf0PgAY5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l6/55D1p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l6/55D1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D464A1F000E9;
	Thu, 13 Aug 2026 17:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786640866;
	bh=PKRAeK+XaoOSz8i+k2Leco4J4jAfWktnkTRSqbkuLKM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=l6/55D1pW/RcwnNP2uahedYxgXA6SfshCx0z2EmsF/OjK7lXLkJYcVuMj32OgAtCk
	 cyfxTg517dDPPDyBv37OY7J0Dg7H+yvt9uBSLsjahX6DCkiy861Q0UWxH3vrTipjOr
	 z0VQcL+BxxHQ4uNYdk+pn+SRzhXykT+Rowb9iXDWol9mVH3MBnAPPT2f4iaP6WDJiY
	 Veb4fyO4f+V0k0RVHbHdI+bEHuStwcwlDAgx/cZMRCWXHbKAVLXv0kzKb9POLlpUNB
	 IpMV/QY2isVa888VI0683WHUztUubnxgHMP4QK3lVsvECdyF6rPzDM5jVY0yujlHZj
	 /tF2Jc9UVdZsg==
Date: Thu, 13 Aug 2026 07:07:45 -1000
Message-ID: <acf9c9a19bbac2dd116869a181bb1dfe@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Hui Zhu <zhuhui@kylinos.cn>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 John Fastabend <john.fastabend@gmail.com>,
 Andrii Nakryiko <andrii@kernel.org>,
 Martin KaFai Lau <martin.lau@linux.dev>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, JP Kobryn <inwardvessel@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Stanislav Fomichev <sdf@fomichev.me>, KP Singh <kpsingh@kernel.org>,
 Tao Chen <chen.dylane@linux.dev>, Mykyta Yatsenko <yatsenko@meta.com>,
 Leon Hwang <leon.hwang@linux.dev>,
 Anton Protopopov <a.s.protopopov@gmail.com>,
 Amery Hung <ameryhung@gmail.com>, Tobias Klauser <tklauser@distanz.ch>,
 Eyal Birger <eyal.birger@gmail.com>, Rong Tao <rongtao@cestc.cn>,
 Hao Luo <haoluo@google.com>, Peter Zijlstra <peterz@infradead.org>,
 Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Kees Cook <kees@kernel.org>, Jeff Xu <jeffxu@chromium.org>,
 mkoutny@suse.com, Jan Hendrik Farr <kernel@jfarr.cc>,
 Christian Brauner <brauner@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Brian Gerst <brgerst@gmail.com>,
 Masahiro Yamada <masahiroy@kernel.org>,
 Willem de Bruijn <willemb@google.com>,
 Jason Xing <kerneljasonxing@gmail.com>,
 Paul Chaignon <paul.chaignon@gmail.com>,
 Lance Yang <lance.yang@linux.dev>, Jiayuan Chen <jiayuan.chen@linux.dev>,
 Emil Tsalapatis <emil@etsalapatis.com>,
 Ihor Solodrai <ihor.solodrai@linux.dev>, Barry Song <baohua@kernel.org>,
 Geliang Tang <geliang@kernel.org>, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf-next 2/4] bpf: add bpf_thread_wq kthread-backed
 workqueue with cgroup placement
In-Reply-To: <cfb06f2626062fa60efbbd9d34089819b1a34522.1786086076.git.zhuhui@kylinos.cn>
References: <cover.1786086076.git.zhuhui@kylinos.cn>
 <cfb06f2626062fa60efbbd9d34089819b1a34522.1786086076.git.zhuhui@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello, Hui.

On Fri, Aug 07, 2026 at 03:01:50PM +0800, Hui Zhu wrote:
> Introduce bpf_thread_wq, a new BPF embedded map field similar to
> bpf_wq but backed by a dedicated kthread_worker instead of a system
> workqueue. The worker kthread can be attached to a specific cgroup at
> init time so BPF-deferred callbacks run under the resource limits of
> the target cgroup.

I find the name bpf_thread_wq unnecessarily confusing. The kernel
counterpart is kthread_worker, not workqueue. Maybe name it
bpf_kthread_worker?

Thanks.

-- 
tejun
