Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792826549;
	b=RwN5fWin4XtA53RzHUKXg2jSY4xiC9Okf7OvwEtbqbe3w/OxKkWt3vcwi7uyouBmPCEb
	 suUgC/4E4PQIgzRyObXKtK5aWyB6PztTFdyciOdbR8oOZbbdDKl+CBQdy5RufZeLgi36b
	 41yqD3yOU5c+vu+EPazQc/WqhEMLZvmf2qQf2hVmdoXXaowGVozBU6b9rp4KfVWlmEvs4
	 WVvFACSjFqpErjvdmyHXCXK4A4s9zfFmA37afUDzD6FSpV3hO5QOp60fFT92jUD1juzAr
	 zhiUyFRLtNqJwMvP6keiI/N6UeAz2N9wm+Q3nG+Tb7hruJXr4vwrbY/XHsffqwNB5/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792826549;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=TkGvhbo8uCfcmT5BQSwIkA1ZNaWITnDyLwroqOawhFA=;
	b=mIR+qq1HSmKUN/am+3y/yRtzsuVSFV0hLkfom7DH8nC7+uemPzqLRkptmZBnc0R/uxum
	 eaE9wVUiOFR8ltVnjUMonpkvWrYxTwHBzJro685NKCNjHniVZdpnGMEkKNortaYbsDspJ
	 hUhA5tVfkJIhlXWkTWpdp8E+fMYVla1hsd8BSUmLnmO+0vCznDiRTuI4RVhs3lfq2OKQj
	 +WAE8AaL2fYJ12LO/bb6Kinj+x5ijEtgHqkPJouPx2QiYX0miDRRhztUYZpsGju0B9D88
	 +UYIVRLmBP7pqpSC83maBcyHZuqsv3xal6+7KzBIVkLRlevR655KOWH+pYW8QnnjTyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C66Wz9GK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3DF606A31D
	for <cgroups@vger.kernel.org>; Sat, 24 Oct 2026 07:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C66Wz9GK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F0C1F01829
	for <cgroups@vger.kernel.org>; Sat, 24 Oct 2026 07:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792826549;
	bh=TkGvhbo8uCfcmT5BQSwIkA1ZNaWITnDyLwroqOawhFA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=C66Wz9GKMH9eWP3KjPne9n1gdC4LfnIDpgTBj18latoVkXOi5f8/BiwnoQ+pw7Jym
	 9Ugyp50w53PhzBHJjiWK5gPvLwW3lcjB7mZ+FMvTtWxwkUpX/8WRGr2LCXCwRhvrrH
	 hki5q9lJcrQt0yNY8OSjhrztMPEqhUFkY0aW4JZ0oV9VAmRfBNU0v/o7HSNBxbql64
	 7qYTzvgL8jFqSuiSrnxfgM7CDFATdqkG6601ofKjJk+qESWsqs01zXqPh8ksRUEutG
	 gnm2pNyCoGLuIqwU7AkaV9uweRXZfdeHEZTBtMrOENMVC0zaaIBcJ/tEWOFGYmuVY4
	 7uJlMNZ6dw8EQ==
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-91c3fd7bbdeso13949696d6.1
        for <cgroups@vger.kernel.org>; Sat, 24 Oct 2026 00:22:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBynIxqHAKsMD6LWR+heoKUdjzrqgRKyPQFVKu15DlbRuyxmElFU0UG98WtBloDefwJIaJbvTWrE@vger.kernel.org
X-Gm-Message-State: AFq9FYIbuibW9hWka1mjxgoVxmpG3vZZspaRQ40fCg3gcVI6Fylx3gG7
	xixZ+k7LiwAPAUZ9crMIMqfZvmb/aM9c0ACrtJDn0CnhRGmQSMaoYaJlnWe4rvTu9jf4vTF8APH
	uPeLOEfcuN4wJa8i7ooUL88DrTduIHaI=
X-Received: by 2002:a05:620a:4385:b0:93f:953:9a1d with SMTP id
 af79cd13be357-940ef9bc448mr169348385a.67.1792826548495; Sat, 24 Oct 2026
 00:22:28 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261019034426.2354049-1-ridong.chen@linux.dev> <20261019035252.2357900-2-ridong.chen@linux.dev>
In-Reply-To: <20261019035252.2357900-2-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sat, 24 Oct 2026 15:22:17 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yQrp3kKJfkXPyLN35Zk_O_gBvnPnUmbwxCU2GVzrE-Zw@mail.gmail.com>
X-Gm-Features: AclHuK89s87eEZ3BnSPuNzTPl5Fwn-4GMSCXcuFKmZMlVEBMhQsRB9l0-sHv3zY
Message-ID: <CAGsJ_4yQrp3kKJfkXPyLN35Zk_O_gBvnPnUmbwxCU2GVzrE-Zw@mail.gmail.com>
Subject: Re: [PATCH v4 2/9] mm/vmscan: move vmscan tracepoints to a local header
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
	linux-mm@kvack.org, cgroups@vger.kernel.org, bpf@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 19, 2026 at 11:53=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev=
> wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> Move include/trace/events/vmscan.h to mm/trace_vmscan.h so that the
> tracepoints can be extended to reference vmscan-internal structures such
> as struct scan_control, which is not visible outside mm/.  This mirrors
> what several other subsystems already do with their trace headers (e.g.
> fs/fuse/fuse_trace.h, fs/gfs2/trace_gfs2.h, fs/lockd/trace.h).  As they
> do, set TRACE_INCLUDE_PATH to "." and add mm/ to the include path of
> vmscan.o, the only user that defines CREATE_TRACE_POINTS.
>
> No functional change.
>
> Assisted-by: LLM
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>
