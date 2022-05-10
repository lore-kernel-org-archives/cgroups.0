From: Hao Luo <haoluo@google.com>
Subject: Re: [RFC PATCH bpf-next 8/9] bpf: Introduce cgroup iter
Date: Tue, 10 May 2022 11:25:13 -0700
Message-ID: <CA+khW7i1Pcc9_bfxVhtzGQkevmodie7=M-57ScMqUyw5U=KW4A@mail.gmail.com>
References: <20220510001807.4132027-1-yosryahmed@google.com> <20220510001807.4132027-9-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i/K+z4FbavDUp9taCkfXpbx13rVcW3GTSvwjLfREXAU=;
        b=Tty5wMz7Ghu646JswlNLX+XwgMjXTrtdIAnTGLzWswd7pJqjghhee9uTTrSBkA1mS5
         TASpWLvrSWJ0o/VmKB1zZ2EKL7bj0qTC3lvVRuamF3i9rZ6kaQX5QDmWCn9TRCB5uXkV
         r8gOHaTXenDSj1D57niaR5CpxS9xrrcL40YA8vpjqNI+g1gL5pCdsCqYcSLce1I6fc3z
         kWNzuDcKIBDb+SwqrxV9F0c+DchRf6wXrjkpR+hTKigiASG8TQ/T4toShl24UGOGYEeY
         ZEnNjV6vVbfPH9Mde3cglN60wQIz6IJ5FIeBa8eN2oVUv11BpQol0cmvcrU6FhcjdmJZ
         DX4A==
In-Reply-To: <20220510001807.4132027-9-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org

On Mon, May 9, 2022 at 5:18 PM Yosry Ahmed <yosryahmed@google.com> wrote:
>
> From: Hao Luo <haoluo@google.com>
>
> Introduce a new type of iter prog: cgroup. Unlike other bpf_iter, this
> iter doesn't iterate a set of kernel objects. Instead, it is supposed to
> be parameterized by a cgroup id and prints only that cgroup. So one
> needs to specify a target cgroup id when attaching this iter. The target
> cgroup's state can be read out via a link of this iter.
>
> Signed-off-by: Hao Luo <haoluo@google.com>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>  include/linux/bpf.h            |   2 +
>  include/uapi/linux/bpf.h       |   6 ++
>  kernel/bpf/Makefile            |   2 +-
>  kernel/bpf/cgroup_iter.c       | 148 +++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h |   6 ++
>  5 files changed, 163 insertions(+), 1 deletion(-)
>  create mode 100644 kernel/bpf/cgroup_iter.c
>

Thanks Yosry for posting this patch! Dear reviewers, this is v2 of the
cgroup_iter change I sent previously at

https://lore.kernel.org/bpf/20220225234339.2386398-9-haoluo@google.com/

v1 - > v2:
- Getting the cgroup's reference at the time at attaching, instead of
at the time when iterating. (Yonghong) (context [1])
- Remove .init_seq_private and .fini_seq_private callbacks for
cgroup_iter. They are not needed now. (Yonghong)

[1] https://lore.kernel.org/bpf/f780fc3a-dbc2-986c-d5a0-6b0ef1c4311f@fb.com/

Hao
