From: Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v2 3/8] bpf, iter: Fix the condition on p when
 calling stop.
Date: Mon, 20 Jun 2022 11:48:08 -0700
Message-ID: <ee47c4af-aa4f-3ede-74b9-5d952df2fb1e@fb.com>
References: <20220610194435.2268290-1-yosryahmed@google.com>
 <20220610194435.2268290-4-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ILl9jNqradX78KiS55v+M1Sf8SHefP9G5qWvhFuuqsQ=;
 b=bfpDquyBDf5cVK8hc7m56me+nXfyl5D2yb0m8E+8oweQ10xuenhfSxgpFQb8ZoAelK0F
 8kaqJyZqBfmmkFQemcvYwWOCosB9ZD0pO2DeuaOmaxSrSvmDaRec15zxSra4RyzRq56h
 0mJtsBjr/a80EbsEUN6V/EiWApzCEykmEfU= 
Content-Language: en-US
In-Reply-To: <20220610194435.2268290-4-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Yosry Ahmed <yosryahmed@google.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org



On 6/10/22 12:44 PM, Yosry Ahmed wrote:
> From: Hao Luo <haoluo@google.com>
> 
> In bpf_seq_read, seq->op->next() could return an ERR and jump to
> the label stop. However, the existing code in stop does not handle
> the case when p (returned from next()) is an ERR. Adds the handling
> of ERR of p by converting p into an error and jumping to done.
> 
> Because all the current implementations do not have a case that
> returns ERR from next(), so this patch doesn't have behavior changes
> right now.
> 
> Signed-off-by: Hao Luo <haoluo@google.com>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Acked-by: Yonghong Song <yhs@fb.com>
