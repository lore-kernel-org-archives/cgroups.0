From: Hao Luo <haoluo@google.com>
Subject: Re: [PATCH bpf-next v2 3/8] bpf, iter: Fix the condition on p when
 calling stop.
Date: Tue, 21 Jun 2022 00:25:55 -0700
Message-ID: <CA+khW7jU=Fqt49jxG8y5n2YtRu4_C1gFUW-PqZGY_Rt8PGrGEg@mail.gmail.com>
References: <20220610194435.2268290-1-yosryahmed@google.com>
 <20220610194435.2268290-4-yosryahmed@google.com> <ee47c4af-aa4f-3ede-74b9-5d952df2fb1e@fb.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d2goD1P8UZdoMASbRq27dQ+7VURQY6z/sy9q6Pv8gJ0=;
        b=Nxf6B2MS9DZB/qkHAQOWw5j6Bxtg9kXmQExGgUeWaC3kJp0lzK6x8BHGxiyuf1PBbq
         uePpIuL+U7i0MRI/BGAYmGPWtW3pprxDU7KhDqDB55rrl2psNymEaK1oB9Bk2tuIs0DO
         vCe/RlXfewePsPZV77Rrn5giVYffEX1nAG2gak+cWKoIlPw8DsgjcHyzW6vHnei8W4yi
         bldDvXWFxnpNK7oFaUEuYWDrqSGqvzjcEkefGn6o6BMvxx9I4fD/jCRn9exwoZxlLOq9
         pgUC+UKExjEp8eFrG6lsYClq/9xrrmInHpBjHS9tBiUEBgX64G+DrX1Itm0fIudn52v3
         lk7w==
In-Reply-To: <ee47c4af-aa4f-3ede-74b9-5d952df2fb1e@fb.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yonghong Song <yhs@fb.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org

On Mon, Jun 20, 2022 at 11:48 AM Yonghong Song <yhs@fb.com> wrote:
>
> On 6/10/22 12:44 PM, Yosry Ahmed wrote:
> > From: Hao Luo <haoluo@google.com>
> >
> > In bpf_seq_read, seq->op->next() could return an ERR and jump to
> > the label stop. However, the existing code in stop does not handle
> > the case when p (returned from next()) is an ERR. Adds the handling
> > of ERR of p by converting p into an error and jumping to done.
> >
> > Because all the current implementations do not have a case that
> > returns ERR from next(), so this patch doesn't have behavior changes
> > right now.
> >
> > Signed-off-by: Hao Luo <haoluo@google.com>
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
>
> Acked-by: Yonghong Song <yhs@fb.com>

Yonghong, do you want to get this change in now, or you want to wait
for the whole patchset? This fix is straightforward and independent of
other parts. Yosry and I can rebase.
