From: Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v2 5/8] selftests/bpf: Test cgroup_iter.
Date: Mon, 27 Jun 2022 23:11:13 -0700
Message-ID: <60365571-bcf0-d096-d023-c9a8bc9a40a7@fb.com>
References: <20220610194435.2268290-1-yosryahmed@google.com>
 <20220610194435.2268290-6-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=C9yRgUCUTP0ZkKNKC5p1wjiKYW6UECYUdIOfJIE464s=;
 b=ni9Sc4t5uUsaZgPAK16lfeCzia9VWURl92DYzl4pDmcAUzLvKJaaDXrIHcokBjPB2njR
 lvrHpAThdLrzywu+JQ79LXBdMibB7ak1XcbWP2XsP8/fSpuD+u8juzWBRMBuVbid1bTa
 tjfJQUIj9vcn6VdQu8Zi/0P37scwfrhiDWY= 
Content-Language: en-US
In-Reply-To: <20220610194435.2268290-6-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Yosry Ahmed <yosryahmed@google.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org



On 6/10/22 12:44 PM, Yosry Ahmed wrote:
> From: Hao Luo <haoluo@google.com>
> 
> Add a selftest for cgroup_iter. The selftest creates a mini cgroup tree
> of the following structure:
> 
>      ROOT (working cgroup)
>       |
>     PARENT
>    /      \
> CHILD1  CHILD2
> 
> and tests the following scenarios:
> 
>   - invalid cgroup fd.
>   - pre-order walk over descendants from PARENT.
>   - post-order walk over descendants from PARENT.
>   - walk of ancestors from PARENT.
>   - early termination.
> 
> Signed-off-by: Hao Luo <haoluo@google.com>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Acked-by: Yonghong Song <yhs@fb.com>
