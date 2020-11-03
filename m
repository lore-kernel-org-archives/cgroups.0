From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
Date: Mon, 2 Nov 2020 21:42:52 -0800
Message-ID: <CAADnVQKuoZDB-Xga5STHdGSxvSP=B6jQ40kLdpL1u+J98bv65A@mail.gmail.com>
References: <20201007152355.2446741-1-Kenny.Ho@amd.com> <CAOWid-d=a1Q3R92s7GrzxWhXx7_dc8NQvQg7i7RYTVv3+jHxkQ@mail.gmail.com>
 <20201103053244.khibmr66p7lhv7ge@ast-mbp.dhcp.thefacebook.com> <CAOWid-eQSPru0nm8+Xo3r6C0pJGq+5r8mzM8BL2dgNn2c9mt2Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MuNT1kBsmjFVlwCSohMVH0XAUpaiqhjCv+VgJCXYn0k=;
        b=LQcQ8Age9Axwo8J/829d2HXmpiJvQwk7ycJxrWRlT8zpJ3qF9MuzhIpBhvAhiSR+hb
         mG9XHWU7bdhknsPJxSxxMMLg2F/tuhgOGAcbS5bIbu7IeoTnEGsRaRlBTZHrssQgMhM5
         dhL4qOSKVAlKR/eigT63eGr05e8xe7fyDgp9mgTKE/F5t0ckHbU2jHiXavzhSYScwq1z
         xibrtSd4QPFO5DuMkxd0GEc55SHeO0TFYSscQuZyNrxlrlMlxMgYVMWyBguiQ7If+zgS
         dERkjRfy/0TIDpDmOZVyuv2rIHF4fV2COuff1yXN3jCbSObv098KCXOJVKUbWHf6GhOE
         7pFQ==
In-Reply-To: <CAOWid-eQSPru0nm8+Xo3r6C0pJGq+5r8mzM8BL2dgNn2c9mt2Q@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kenny Ho <y2kenny@gmail.com>
Cc: Kenny Ho <Kenny.Ho@amd.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@chromium.org>, bpf <bpf@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, Alex Deucher <alexander.deucher@amd.com>, amd-gfx list <amd-gfx@lists.freedesktop.org>

On Mon, Nov 2, 2020 at 9:39 PM Kenny Ho <y2kenny@gmail.com> wrote:
>
> Thanks for the reply.

pls don't top post.

> Cgroup awareness is desired because the intent
> is to use this for resource management as well (potentially along with
> other cgroup controlled resources.)  I will dig into bpf_lsm and learn
> more about it.

Also consider that bpf_lsm hooks have a way to get cgroup-id without
being explicitly scoped. So the bpf program can be made cgroup aware.
It's just not as convenient as attaching a prog to cgroup+hook at once.
For prototyping the existing bpf_lsm facility should be enough.
So please try to follow this route and please share more details about
the use case.
