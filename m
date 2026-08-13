Received: from mail-wm2-f10.google.com (mail-wm2-f10.google.com [74.125.225.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E545352010
	for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 03:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786591592; cv=none; b=k7gWY1l+RPk/nrZtOBNHlMnf9imi0Q/DwqwobnP0rVY9icmvaJ4hh17i338uxetxmYVUVHQkAnNsw5ioaZq07PbDKmE6/5tk+Jj7tSXNV6HMHBmt+mXneQ+PlCIZUe0k11UBsvmnIZHl/8AxN47Eq8o/Kra1qCUvhIjU3ggbTGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786591592; c=relaxed/simple;
	bh=X0pHP4S2OsRNcX4/HbKprcP2h56QDiwvZLsJATuwvS4=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=gMLT8nbNbcluAkKcrHzrb6E85zjBO1SdTCJe0Xe9HGfnzUJBRDy3GEWxQjweVTsxTPtrK+Kh+/Z0rEjpbUVyi4GDJDpLDfOMAcxJGH3zqTg/NcazlFokaceeWYZ/ifOmYvLLtxDlZyzz4431UZmMveg7Y0uuFIXc8s5UvJ6R0Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OyGzc+CZ; arc=none smtp.client-ip=74.125.225.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OyGzc+CZ"
Received: by mail-wm2-f10.google.com with SMTP id 5b1f17b1804b1-495501e57beso4303625e9.1
        for <cgroups@vger.kernel.org>; Wed, 12 Aug 2026 20:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786591589; x=1787196389; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=glE18fTWGFGOtieGZ/t9cUibr9Ip5396IdYy4itNJLM=;
        b=OyGzc+CZYyaigbVJVAELJ3hPfH3bFkcydqDPyzVpDTLspUl9dMB92tfymlwohqKazP
         Ug4Yd+yHsVtYxlyNDZHc5WvTq8zmOtRitcivDH++cQDCss766gKdtsbTOExoUDZ+Gp2i
         Mus2HK92AsvmSLPg0i0A1PEhW6M5oJnqFfO/pSc6E68EoWe8mNaQPiyfRMgEeXWYbHoA
         JfZAkzOb3JMI9H+VUUvKNWw63ss7uMtCTNMu4vxzwDvCweoJFD0Wn5s2wUGn7idjv9Vk
         BWWwX2VqK/c+Jyv/qvVUWxj38c5KILmrhF4Q2QiqbyQDZMn9oWY4TsvgO+9wqT7lDTbz
         KD6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786591589; x=1787196389;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=glE18fTWGFGOtieGZ/t9cUibr9Ip5396IdYy4itNJLM=;
        b=VsMp8iPcdsWSy5eDKBdONSOzsth0YIRb7yGBT+dXrpTrkwxiGK6qYuyfn9MosBLTp9
         ObG2RBz5k3SFLiIaV6UbHsDHvXCFV0fX621kb5zXObeLNdNmF599uVHgqKjgASSm8oj/
         xdZNZL8ddPhZyjmkKV3RAvskeDYwDYbAGxxjrDstbANRWakYSi29DkdbyZjy1QVXts0m
         DVNLDDfL9ZnxDUWZPHGGj9dQBUVscZSvRVdApsqO4GnXxZVij3hrsFmGwRj2WT1Q6Mu8
         5gpkJo85T7Dl2F7udqbwkzy5QeOX+TfHcDG75kE78/WzvLaifwsVA6QgA2IXcZTfewcm
         slRQ==
X-Forwarded-Encrypted: i=1; AHgh+RqDeTTdEjo4JtvD79+nzSQXCBP2YE2oV5lGq7w+K5ywKyOQW56JWi5AwxnHm3bUIwCzzUc72Ok/@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7GVAUOc/LLYh5e7AMJNz4wc29vIX5ZeNR6txBUJd8cHVDoJVK
	1x+QBGBWjgnfoA/rrQDDRdyHP4MQSkQPpUl8xvZCyh0u8ZH/a7uNK46C
X-Gm-Gg: AR+sD11ihu3ac6IvNJWCbE+mbpTHiJNVvRRwjLMdVwD8szXvUQI3dbGpKsJmgpXvyZ2
	NmN5x6vvVKBJnPSpH0FSX1V+ZjX3T7CsTfTsu8F6XEDwOg4bflREweov0B9JdLx9jMlmqrvw9yo
	lqyOmamoSXSq9UHkKO+CbMXsXoVbuBCk/J3051LPyseMFazAeqK05N9Ed+kpK1Uor8z/iq12L/i
	fz3SL8eighaiwK25G3gUAVB4eUTbQjpr16shPC0IcJ3kzmhm8jCPvEyloaKG2y/aP+coS27j2kf
	7cDFU1Z+wh90cM+Ot6HM8mdZ4fzv1shTTpGeFxbZZ/Y4wFO/d22S9HK3LpQp8v2Y1LKf0z78a0U
	w80RkZ0RT3T5xoDkT94Pi3RFLGiCw+gZLpywkdgdTm/T8XzJr0g2ija3qSKC09g79ZBssUdndVo
	jd3+6btDPX9jTNP+n3QxaqHcGf2rxtCJALbVbKsp//ohxDLNVfIfqKbjcXtgLv80pRQsGj2H+uW
	Eg1YuHNY7V6L32Gbucs02byuBDaFxcqk/wiGKZDvbxfArObE93KBrxXwF+Qa0mbVfsCGaQWiPYR
	3SgFQr1AMqVCE5ofCmE/PwY+SXAlngwlVxUGnQ==
X-Received: by 2002:adf:e008:0:10b0:481:5167:d526 with SMTP id ffacd0b85a97d-48159c8d9f8mr2408652f8f.6.1786591588609;
        Wed, 12 Aug 2026 20:26:28 -0700 (PDT)
Received: from localhost (nat-icclus-192-26-29-3.epfl.ch. [192.26.29.3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815a569ab3sm2609540f8f.11.2026.08.12.20.26.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2026 20:26:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 13 Aug 2026 05:26:26 +0200
Message-Id: <DKNHV09PBQZP.IRQL20BY574I@gmail.com>
Cc: "Hui Zhu" <zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next 2/4] bpf: add bpf_thread_wq kthread-backed
 workqueue with cgroup placement
From: "Kumar Kartikeya Dwivedi" <memxor@gmail.com>
To: "Hui Zhu" <hui.zhu@linux.dev>, "Alexei Starovoitov" <ast@kernel.org>,
 "Daniel Borkmann" <daniel@iogearbox.net>, "John Fastabend"
 <john.fastabend@gmail.com>, "Andrii Nakryiko" <andrii@kernel.org>, "Martin
 KaFai Lau" <martin.lau@linux.dev>, "Eduard Zingerman" <eddyz87@gmail.com>,
 "Song Liu" <song@kernel.org>, "Yonghong Song" <yonghong.song@linux.dev>,
 "Jiri Olsa" <jolsa@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>,
 "Michal Hocko" <mhocko@kernel.org>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Muchun Song" <muchun.song@linux.dev>, "JP Kobryn"
 <inwardvessel@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 "Shuah Khan" <shuah@kernel.org>, <davem@davemloft.net>, "Jakub Kicinski"
 <kuba@kernel.org>, "Jesper Dangaard Brouer" <hawk@kernel.org>, "Stanislav
 Fomichev" <sdf@fomichev.me>, "KP Singh" <kpsingh@kernel.org>, "Tao Chen"
 <chen.dylane@linux.dev>, "Mykyta Yatsenko" <yatsenko@meta.com>, "Leon
 Hwang" <leon.hwang@linux.dev>, "Anton Protopopov"
 <a.s.protopopov@gmail.com>, "Amery Hung" <ameryhung@gmail.com>, "Tobias
 Klauser" <tklauser@distanz.ch>, "Eyal Birger" <eyal.birger@gmail.com>,
 "Rong Tao" <rongtao@cestc.cn>, "Hao Luo" <haoluo@google.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Miguel Ojeda" <ojeda@kernel.org>,
 "Nathan Chancellor" <nathan@kernel.org>, "Kees Cook" <kees@kernel.org>,
 "Tejun Heo" <tj@kernel.org>, "Jeff Xu" <jeffxu@chromium.org>,
 <mkoutny@suse.com>, "Jan Hendrik Farr" <kernel@jfarr.cc>, "Christian
 Brauner" <brauner@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>,
 "Brian Gerst" <brgerst@gmail.com>, "Masahiro Yamada"
 <masahiroy@kernel.org>, "Willem de Bruijn" <willemb@google.com>, "Jason
 Xing" <kerneljasonxing@gmail.com>, "Paul Chaignon"
 <paul.chaignon@gmail.com>, "Lance Yang" <lance.yang@linux.dev>, "Jiayuan
 Chen" <jiayuan.chen@linux.dev>, "Emil Tsalapatis" <emil@etsalapatis.com>,
 "Ihor Solodrai" <ihor.solodrai@linux.dev>, "Barry Song"
 <baohua@kernel.org>, "Geliang Tang" <geliang@kernel.org>,
 <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
 <cgroups@vger.kernel.org>, <linux-mm@kvack.org>, <netdev@vger.kernel.org>,
 <linux-kselftest@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <cover.1786086076.git.zhuhui@kylinos.cn>
 <cfb06f2626062fa60efbbd9d34089819b1a34522.1786086076.git.zhuhui@kylinos.cn>
In-Reply-To: <cfb06f2626062fa60efbbd9d34089819b1a34522.1786086076.git.zhuhui@kylinos.cn>

On Fri Aug 7, 2026 at 9:01 AM CEST, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> Introduce bpf_thread_wq, a new BPF embedded map field similar to
> bpf_wq but backed by a dedicated kthread_worker instead of a system
> workqueue. The worker kthread can be attached to a specific cgroup at
> init time so BPF-deferred callbacks run under the resource limits of
> the target cgroup.
>
> Three kfuncs are exposed:
>   bpf_thread_wq_init(twq, map, cgroup_id, flags)   [KF_SLEEPABLE]
>   bpf_thread_wq_set_callback(twq, cb, flags, aux)
>   bpf_thread_wq_start(twq, flags)
>
> bpf_thread_wq_init() is registered only for BPF_PROG_TYPE_SYSCALL
> programs. It creates a kthread worker and may attach it to a cgroup;
> those paths can sleep and acquire kthread and cgroup locks. Restricting
> init to syscall programs prevents it from running in BPF contexts that
> may already hold locks which could deadlock with those paths.
>
> bpf_thread_wq intentionally avoids the bpf_async infrastructure used by
> bpf_timer and bpf_wq. That infrastructure drives cleanup from irq_work
> in hardirq context, while bpf_thread_wq cancellation and final teardown
> may need to sleep through kthread_cancel_work_sync(),
> kthread_destroy_worker() and a final cgroup_put().
> bpf_thread_wq_cancel_and_free() therefore cancels work synchronously and
> drops the context reference; the last put waits for tasks-trace RCU
> readers and then schedules process-context work to run bpf_prog_put(),
> cgroup_put(), kthread_destroy_worker() and kfree().
>
> Add BTF/map support for bpf_thread_wq fields, map teardown hooks,
> verifier handling for the callback kfunc, and cgroup_kthread_attach() to
> move the worker into the requested cgroup.
>
> Supported map types are BPF_MAP_TYPE_HASH, BPF_MAP_TYPE_LRU_HASH, and
> BPF_MAP_TYPE_ARRAY, consistent with bpf_wq and bpf_task_work.
>
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---

Hi Hui,

Thanks for sharing the patches. I think Sashiko and Mykyta already pointed =
out a
couple of issues with the current implementation, but I would like to comme=
nt on
the higher-level approach.

If I understood the past discussions and current set correctly, the reason =
for
your choice to move from bpf_wq to bpf_thread_wq was primarily to enable co=
rrect
CPU accounting of the work done by threads to specific cgroups.

I think this is a step in the right direction, but looking at the bigger
picture, I feel we need a more flexible solution.

In practice, users deciding to do async reclaim through such a BPF interfac=
e
would want to scale and compact the number of threads doing reclaim-related=
 work
dynamically, based on available idle resources, but also application-specif=
ic
metrics, and I do not think the bpf_thread_wq abstraction provides enough
flexibility in managing work scheduling related aspects precisely.

What we probably should expose is the ability for programs to manage their =
own
wait queues and subscribe kthreads managed by BPF programs dynamically to t=
hem.
User-defined policies can dictate how many threads remain active, whether t=
hey
busy poll, and when they go to sleep, completely under the program's contro=
l.

Looking beyond this particular example, there are cases where work is stash=
ed in
queues, and threads draw items from the pool and process them. In such case=
s
having flexibility in deciding the mapping between threads and queues is al=
so
important. We want to thus allow management of the work item queues from th=
e
program itself, and not hide it behind the API to offer the desired level o=
f
control.  The order in which items are ranked in individual queues, and the
order in which queues are processed horizontally by threads is also a desir=
able
property.

Correctly associating the BPF-managed kthread to a cgroup should still be
possible in a manner similar to what you did in this set. But the amount of
control programs can exert over how work is scheduled and the level of
concurrency will be much higher if we disaggregate and generalize each part=
 of
the picture (wait queues, kthreads, and work item queues, which can be
implemented in BPF itself).

I am not aware of ways to back charge time spent to remote cgroups, but if
desired we could also explore that option when a single thread does work on
behalf of multiple cgroups. It is something to be explored.

I've been working on related patches, and will post RFC set for bpf_kthread=
 and
bpf_waitq management in due time.  Until then I recommend that you continue
experimenting with the existing async execution primitives for now.

> [...]
