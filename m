From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH bpf-next v1 2/5] cgroup: bpf: add cgroup_rstat_updated()
 and cgroup_rstat_flush() kfuncs
Date: Fri, 20 May 2022 09:06:45 -0700
Message-ID: <CAJD7tkaPD94+61hrdr8qTV66RtfWOC+35=nGb9id_N1LrisCPA@mail.gmail.com>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-3-yosryahmed@google.com> <YodCPWqZodr7Shnj@slm.duckdns.org>
 <CAJD7tkYDLc9irHLFROcYSg1shwCw+Stt5HTS08FW3ceQ5b8vqQ@mail.gmail.com>
 <20220520093607.sadvim2igfde6x22@apollo.legion> <Yod4cN+HayIDhR/c@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vjm4J0UEt15jqND8yu0VfF/JH1EN98mQjkeJ7hl8/Ec=;
        b=pPChiNi8weWzvtqUuLzWWN2Kgh2JKNWRx5//iF1unO8QpnGtgal2d+z5kUsLbQsqKy
         iHC3AYYDtLWRRgw2yCAySZ8Ywti0zeA2fYn2pv1Xe4XdvkmRTRyUHnRjCLoEL43VJa0g
         1J8laDrC6/zJaUOeTtGsHCUINSBHrKxQ7oXtFbZabduDuf43ww/MDXDlbez6NkDjViSO
         LsjWN1wqp7T6IXSp894JQqkMs270xetYAn1vvBHxJ++4OeXX48qWMWNLUTLtcY1aSWDJ
         pnmt8q1zLR1CrKceQKXburkrirj3qSugVm3o12bP8B2MFxjXwSKaUfM01FpwzqTdSzsH
         J+WQ==
In-Reply-To: <Yod4cN+HayIDhR/c@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Networking

On Fri, May 20, 2022 at 4:16 AM Tejun Heo <tj@kernel.org> wrote:
>
> On Fri, May 20, 2022 at 03:06:07PM +0530, Kumar Kartikeya Dwivedi wrote:
> > With static noinline, the compiler will optimize away the function. With global
> > noinline, it can still optimize away the call site, but will keep the function
> > definition, so attach works. Therefore __weak is needed to ensure call is still
> > emitted. With GCC __attribute__((noipa)) might have been more appropritate, but
> > LLVM doesn't support it, so __weak is the next best thing supported by both with
> > the same side effect.

Thanks a lot for the explanation!

>
> Ah, okay, so it's to prevent compiler from optimizing away call to a noop
> function by telling it that we don't know what the function might eventually
> be. Thanks for the explanation. Yosry, can you please add a comment
> explaining what's going on?

Will add a comment explaining things in the next section.  Thanks for
reviewing this, Tejun!

>
> Thanks.
>
> --
> tejun
