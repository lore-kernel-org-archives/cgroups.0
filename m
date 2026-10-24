Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792880658;
	b=tOD9KjU4xsjXy3v+hUzFcDQSCdUJD9c+/L04nsRMYGwbk5Flj/Qd3iQXX11KD6BdsVFu
	 I2WZsU/dSHyIn6QTvwpkKoM8WVqIcqmJz1ZL7czyZtmLDIi2xjpQ6qMWovnzr9pIiJ+5f
	 ZA0K1sC064DQkzZO/P9oCtZ/MGt9ZZc7Xiqqg+pOedLKlelGEafGhvW8TKKBCzPELhryT
	 uHya6alEZPcVoZaDaKIzhcxZAy62/Yof1lNxYSgy/X5b5shKnzKkpTanbdmvsBE3EwMgm
	 hHq5Dsl3SRdT+Quwrj/6NflhmZgeT1kRJeiUS9Py8XGR8LAEx2FcO/Z5M5t8kEH69SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792880658;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ZO95lvl9Nqr2fnKfjhNvY3odHppkPAvE0sy9YV0MAyE=;
	b=Esgc1hm9XhjCvEfnCqYyrYYss//VwGen2FevOjKxjlMKqUYhq6DRt+7uwc2eb5L8t73i
	 fKE1Dq7pxtXVQ0cZ4dNHd4qJe5PNGR/FeSBXuPmNuICoafK2vQ1GYimtw89Yi62G7Z6/l
	 JTKrCmCIuukPtROB5p4WRSFkkg1+O56pVOIT3y8fivL4qFPbgr/FdPtSw+v73qr3XRBMk
	 IAE3/cG0WQ7W0Qtx5YNXpIe3RD55GGbT8n167VaEo4uQ7N6cla9535d5oH8BqDCAjk0uA
	 DJc0ZDbrGuKu7wBuYPnMnrZ12rvyCLCmZ/XGsT8BGuXdjucqAq6kRcku45sQohopktA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DcwlgpnI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B80606A31A
	for <cgroups@vger.kernel.org>; Sat, 24 Oct 2026 22:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DcwlgpnI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCD61F031E4
	for <cgroups@vger.kernel.org>; Sat, 24 Oct 2026 22:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792880657;
	bh=ZO95lvl9Nqr2fnKfjhNvY3odHppkPAvE0sy9YV0MAyE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=DcwlgpnI8DL+2mapwB28c0Uuo/uZkOQbIkpHc/v1SllyC8AnQiHsey8hJ4aUWdbT4
	 prMadH1kOhGswoIzNgX1P+u7U3KoTwqUBcWHh2XYWZ5bxDbPXCFaxmk+P2urzWr1Rm
	 tN/5ED+hsmoVE+0QG0XA0UDNI4BCf1ZefiXFb5Qd5/jU4/xxPiEDB4jLllmx0hbm3K
	 EN3bqey/NcRl3d0IV+S3TGGgleI5BqCIn+v74y01Z2wbeUWXGv7IvSemJyMiXrTytO
	 jmFrvEKOiSx/o2gKOwmTm2S066vyIZyZSIob0mQDj8qkp6Et+Vy3xhiiFLqwSXFeD6
	 V70By5SJLar2w==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93f2493c28bso158794485a.0
        for <cgroups@vger.kernel.org>; Sat, 24 Oct 2026 15:24:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxluYpirGV15ouZ90gUFf7vwDGxzIvCsRjRWIzhN8GQeX5NgVYzc97MpNx25eSLq+cRpxQegLT1@vger.kernel.org
X-Gm-Message-State: AFq9FYJWdN3XBjuODwYrERaOJK8Epm7MeuNGxRlZLEOou6oPbd2wd1zA
	o/vhtqRTVMBIWLDP4LlJpfvvbMtyffBcGr+adX+/AjbooUwZjP0PS3EntlFJ4lhoQgIHAi9HUG3
	RBmDzGtSLCRMSIaVP7gnpU7BFxBMw3a8=
X-Received: by 2002:a05:620a:2616:b0:93e:c06a:7313 with SMTP id
 af79cd13be357-940ef914186mr385330485a.13.1792880657009; Sat, 24 Oct 2026
 15:24:17 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261019034426.2354049-1-ridong.chen@linux.dev> <20261019042308.2372396-2-ridong.chen@linux.dev>
In-Reply-To: <20261019042308.2372396-2-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sun, 25 Oct 2026 06:24:06 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z7u_PtSkjm+kH7JX_ZZDLSnGr1teHq6By0ovgB23O8_w@mail.gmail.com>
X-Gm-Features: AclHuK9i0KBXAHQuNAppLi1kJlXPAo77Un_nGJoXjbM4tmAAAAcT3v5pEG65SEY
Message-ID: <CAGsJ_4z7u_PtSkjm+kH7JX_ZZDLSnGr1teHq6By0ovgB23O8_w@mail.gmail.com>
Subject: Re: [PATCH v4 7/9] mm/vmscan: pass scan_control to mm_vmscan_balance_pgdat_end
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

On Mon, Oct 19, 2026 at 12:24=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev=
> wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> balance_pgdat() passes sc.order and sc.nr_reclaimed to
> mm_vmscan_balance_pgdat_end as bare arguments. Pass the enclosing
> struct scan_control instead and read the fields out in TP_fast_assign,
> consistent with the other reclaim tracepoints. highest_zoneidx stays a
> separate argument: it is a balance_pgdat() parameter, and
> sc.reclaim_idx may differ from it by the time the end event fires.
>
> No functional change. The tracefs event format (TP_STRUCT__entry and
> TP_printk) is unchanged, so tracefs-based consumers are unaffected.
> BPF programs attached via raw_tp/tp_btf see the new TP_PROTO and need
> to be adjusted; tracepoints are not a stable ABI (see
> Documentation/bpf/bpf_design_QA.rst).
>
> Assisted-by: LLM
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

Could we combine patches 4=E2=80=937 into a single patch? The changes
seem a bit too scattered across separate patches.

Best Regards
Barry
