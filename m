From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 0/2] Support cgroup1 in get from fd/file interfaces
Date: Tue, 11 Oct 2022 06:51:25 -1000
Message-ID: <Y0WfDQ95i9lFJKUz@slm.duckdns.org>
References: <20221011003359.3475263-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ADBsxLunge1AhqEpSVfGO0kFOloOABIAiXPDugpYJZk=;
        b=XEG0+rifCJBs/VBmh3mu4URmwTT/ffH/L1xVT0nYnfMdL2BvMHjdfRoyoRBRnB7RZ4
         5BnpGQywEA/92cRoaZCZncGb9B0QnB/wtC85n5uLMYxEC2+B9ny+fQ+JvyO5w2UxNfCH
         yITSzjKTNhmdMRklBn3mf5s0m4hr1EL3TNjovWH297zbwGFOtErDgOjzLqcvo7XqrWVR
         1mO90RNcL8plTUjxhbMb4SdUv9U9lJtg/TjZ7eNkJa273jilFF44fYe48Pjeo5VzTGyc
         EZjN7POAOMZAZ5DLeCfJJOR/UzUhHIqwSLGknhAXyfBZJngu4vROfvegVQdXt5YpVyEJ
         tW7w==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20221011003359.3475263-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org

On Tue, Oct 11, 2022 at 12:33:57AM +0000, Yosry Ahmed wrote:
> commit f3a2aebdd6fb ("cgroup: enable cgroup_get_from_file() on cgroup1")
> enabled using cgroup_get_from_file() and cgroup_get_from_fd() on
> cgroup1, to enable bpf cgroup_iter to attach to cgroup1.
> 
> Apparently, other callers depended on these functions only supporting
> cgroup2, so f3a2aebdd6 was reverted. Instead, add new separate interfaces
> that support both cgroup1 and cgroup2 and use them in bpf cgroup_iter.

Applied to cgroup/for-6.1-fixes.

Thanks.

-- 
tejun
