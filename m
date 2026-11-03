Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793687200;
	b=5j1HjsyvXEuiQIcjcH9Fo4Cm2bH4zfvLt2l9IRoMbZuc7ertiR0boEdOopbGKHvniY9B
	 ZMqev5iu6CR2jvYK0BQSlehtOAE17w0GMg2jaC7oilKnK0+tB75boNUcIEUSPRDPhAqr/
	 BOTeMWLI82lYnNO3T40WUpprLCqVwbwUmowS6M29kpHMuFa4fxXQqFQXEiVNSmeyXqwdF
	 WpQgSEcOvENlwSpbp0nCROzaMiYDyTN48S/CuHUIqSNGlzeAoB3rztXG+LV6wtavGAfce
	 H+Kpm/TaVKsSTaZ93jWsg11HwsVJP1GfdxtWN1g8OPydU/qPEAuCFXp0NIvn7TPadMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793687200;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=8YqOpFkmr9cAx+aebIVE0MX85yK0hEwpHWmKUBVI4T8=;
	b=xt2priaJuffN6bJ75dC8EgN5VOhcHU5AFKzkIwcJ03WxUpakjWe3Hz0U4Nv0SxEuYgU4
	 57oWhg+5wMJyL/HVWYvyqIa0QH2X/YdQUiHUF0QlArTQcfeM/lz3T1ZivsmJDiIVrU5dn
	 N90LnWZWCBOxZKrncfjlnVQfs9AwPEpOurUTrLMhM+dKE5H8B3zrD6kRWls1/Lw6Nxrxr
	 PiWWayt3u39rYgiMN44Kl0rLzPB+sxYopZDvcubtZVhbgTAyfdGazKogIjZMZR9NIinow
	 7vmiA+ipLjialMXFZX4lzePISNHsYLfyUK20yvxHvAx781DYRzEiDnD7oINkVeikR8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SrAfoQaS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E45606A32D
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 06:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SrAfoQaS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3491F00919
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 06:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793687199;
	bh=8YqOpFkmr9cAx+aebIVE0MX85yK0hEwpHWmKUBVI4T8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SrAfoQaSfOIdTZ6xXJwdTLEs8ETPE4XmWfd0jOTnxdhm5EQSZ5tAnErdcowd7raqB
	 LAWN5a65qcGRHmTLWoCFeinA3+cdn4iEHZAHgcXw95TQZDREDMU9Vq3JRxyfpffQlH
	 d70oVdE0aNoO/AnpFLcz6d6R7D5ACDTAdIqBUtKfQNwmlx+YTUMR7TV/wKQ7++KNZs
	 /bqY27fGuwDRGOqZXpyis6GNus/oticbBRAgFROfQOHrXBqGIHy+9q9GNzalQQduiq
	 cr9BrktrvvaBpull3pwLx29yLofYCMtoKRb/nfS4BdJD8HdiJwE73ZtPIWR2RHSmta
	 xgkcI1EtMQ8mA==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-93f30660e69so266009785a.0
        for <cgroups@vger.kernel.org>; Mon, 02 Nov 2026 22:26:39 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBy97HCRPVXb1E3eoUqWxBLTJWeNA7sOOBVHi7xJqDdt7YhiMhN8F48yOpXImRyEqe9JgOv7TyLJ@vger.kernel.org
X-Gm-Message-State: APuU4Z/w2g6B9otpJijJU1pniPqxR9U5W9pmPiHjLgwsd2+drRcMUKSA
	X/6xSDDDYK9Syo8xPDlYsP7ej/v0xnUeqb+ZfXgZ1Aliyhy33tB0XUzC0INPg4+1c2epBZco2zi
	/NQThiWIyYJeWDQ+RyF5k32UFjKSfgrs=
X-Received: by 2002:a05:620a:880c:b0:93f:1936:b229 with SMTP id
 af79cd13be357-944217ee7a9mr1684444285a.77.1793687199176; Mon, 02 Nov 2026
 22:26:39 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261103025610.3738894-1-ridong.chen@linux.dev> <20261103025610.3738894-7-ridong.chen@linux.dev>
In-Reply-To: <20261103025610.3738894-7-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Tue, 3 Nov 2026 14:26:28 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zLDFkp9vfK+PxyF21LV5rEnUqmUumgmMGuwRx8MzAfnA@mail.gmail.com>
X-Gm-Features: AclHuK8HVKdqMIREpv0PqEm0E3nZYzV_dWHIZArjnQaiOz33ddVcOx-caGz6_NQ
Message-ID: <CAGsJ_4zLDFkp9vfK+PxyF21LV5rEnUqmUumgmMGuwRx8MzAfnA@mail.gmail.com>
Subject: Re: [PATCH v6 6/7] mm/mglru: add lruvec_gen_size() helper
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Dave Chinner <david@fromorbit.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, 
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 3, 2026 at 10:57=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> The number of pages of a given type in a generation is computed by
> summing lrugen->nr_pages[gen][type][] over all zones and clamping each
> per-zone counter to >=3D 0, since the counters are updated locklessly and
> can transiently go negative. This loop is open-coded in
> lruvec_evictable_size() and in the debugfs lru_gen output.
>
> Add lruvec_gen_size() to compute it from a seq, and convert both users.
> Put it in mm/vmscan.h so that the vmscan tracepoints, which include that
> header, can use it as well.
> An upcoming tracepoint and the MGLRU swappiness rework will also use it.
>
> No functional change.
>
> Suggested-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>
