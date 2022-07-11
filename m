From: Hao Luo <haoluo@google.com>
Subject: Re: [PATCH bpf-next v3 8/8] bpf: add a selftest for cgroup
 hierarchical stats collection
Date: Sun, 10 Jul 2022 23:01:22 -0700
Message-ID: <CA+khW7gu73pRFi73BR20OCJhzrs8-kHfTYYR38+MJUpt6wqXoA@mail.gmail.com>
References: <20220709000439.243271-1-yosryahmed@google.com>
 <20220709000439.243271-9-yosryahmed@google.com> <b4936952-2fe7-656c-2d0d-69044265392a@fb.com>
 <9c6a0ba3-2730-eb56-0f96-e5d236e46660@fb.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mrs4ZeeiZ30d9zxxyd0TAMHLWBLjUqpYMMgWU2Rjksk=;
        b=o3x3uU7aTeQVHBt9dwXxqVH+LURiGmbgWGv5f2lh+MhkWW4Q7M5Y/2XQRL5kRjmkWZ
         QmRVk9DIMPYjwfTrYCTnZwgjSm1ixtdCNp5H0px54eUWOm0QHnab+EhPXGqNlJPUkkwT
         Gs6caZOS3WNlZxB3pffmztHLVrAdk1CWK/lzXMN4jw9nj/xITQ1o3hhBG8LNs1Bs+AO6
         mhq5c0pMM5Y+77LuJ+6TFHuhMdoT4DE9sa51o977kpXqiQIKPfJm2ZrBUTldF0J6uY5z
         KWAuvN0v+AyzBHVSKPxPW1fxGbVvjPi2fvqXXZIdyMfpCksQrsIXFdnyxxqCGVQyQzHU
         Qeyw==
In-Reply-To: <9c6a0ba3-2730-eb56-0f96-e5d236e46660@fb.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yonghong Song <yhs@fb.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>, KP Singh <kpsingh@kernel.org>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, John Fastabend <john.fastabend@gmail.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>

On Sun, Jul 10, 2022 at 5:51 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/10/22 5:26 PM, Yonghong Song wrote:
[...]
>
> BTW, CI also reported the test failure.
> https://github.com/kernel-patches/bpf/pull/3284
>
> For example, with gcc built kernel,
> https://github.com/kernel-patches/bpf/runs/7272407890?check_suite_focus=true
>
> The error:
>
>    get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
>    get_cgroup_vmscan_delay:PASS:vmscan_reading 0 nsec
>    check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan:
> actual 28390910 != expected 28390909
>    check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan:
> actual 0 != expected -2
>    check_vmscan_stats:PASS:test_vmscan 0 nsec
>    check_vmscan_stats:PASS:root_vmscan 0 nsec
>

Yonghong,

I noticed that the test only failed on test_progs-no_alu32, not
test_progs. test_progs passed. I believe Yosry and I have only tested
on test_progs. I tried building and running the no_alu32 version, but
so far, not able to run test_progs-no_alu32. Whenever I ran
test_progs-no_alu32, it exits without any message. Do you have any
clue what could be wrong?

> >
[...]
