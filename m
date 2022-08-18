From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH bpf-next v2 07/12] bpf: Introduce new helpers bpf_ringbuf_pages_{alloc,free}
Date: Thu, 18 Aug 2022 10:30:44 -0700
Message-ID: <CAEf4Bzbcs_k-NBgO7tky3brTraHFKLwEg1RQrhZNJVY7Tsbz7w@mail.gmail.com>
References: <20220818143118.17733-1-laoar.shao@gmail.com> <20220818143118.17733-8-laoar.shao@gmail.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=erWfx2JL8VWK/Fye7TEq9V21Uimrc0ebZ49GLDL2zgo=;
        b=Lz2iNaQP2P0Z6N2IOph6qWi1Zxr2Wk+aNsIAu4DHI96Idb2HK2EYVji9rPh1UZ2m86
         kQgUgs5De791SDHluwVuxaNRYPvXlHmnO44ZXI/9K+HJt2VTCaHkEZO0FCmEFvH7hI+0
         brnFtbsQB3eCUJOhrb2WRjmM+G8N7bonDL1bSlEnVaKrsHMa0hkaOcIh/MfGl8AVe9CZ
         Bd6VB5Ja0Y6kphczVBVOwpTmbgFLKDYcFjP+Zs2w5pwz6JDYnut4Z3SCRMqIr8gRSUsJ
         ZT4mX2cvVpT4iXV0YwY0N0PloTD7IhJonTfNn5D29rqawzXVHarkLx2vNNL59pndJ1uL
         urHQ==
In-Reply-To: <20220818143118.17733-8-laoar.shao@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao@gmail.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, songmuchun@bytedance.com, akpm@linux-foundation.org, tj@kernel.org, lizefan.x@bytedance.com, cgroups@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org

On Thu, Aug 18, 2022 at 7:32 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> Allocate pages related memory into the new helper
> bpf_ringbuf_pages_alloc(), then it can be handled as a single unit.
>
> Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  kernel/bpf/ringbuf.c | 80 ++++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 56 insertions(+), 24 deletions(-)
>

LGTM.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

> diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
> index 5eb7820..1e7284c 100644
> --- a/kernel/bpf/ringbuf.c
> +++ b/kernel/bpf/ringbuf.c
> @@ -59,6 +59,57 @@ struct bpf_ringbuf_hdr {
>         u32 pg_off;
>  };
>

[...]
