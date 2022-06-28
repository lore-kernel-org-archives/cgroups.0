From: Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v2 6/8] cgroup: bpf: enable bpf programs to
 integrate with rstat
Date: Mon, 27 Jun 2022 23:12:12 -0700
Message-ID: <1c1fb651-cc69-4b5c-1b68-8f29908794bc@fb.com>
References: <20220610194435.2268290-1-yosryahmed@google.com>
 <20220610194435.2268290-7-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=9FLlWCroOJLCiBuUFLOKEZapYDLZK7Fs0eCw0G1GhzQ=;
 b=qsLBGWBpWfJPg64cMbSUQGazFcmdP39ZwRB+9vqR4B9h8slosCevYRElQ/7EMCXyYLEm
 8QWfK+9e2GAcmmvltFNrb1j/hraROfAK3e0mnzTDu3In0WtwFL6BbqTF98n8dhgMuo9M
 YL3IO5tMJlBdjXUwKO6nmjbX0jCLL/jbeT8= 
Content-Language: en-US
In-Reply-To: <20220610194435.2268290-7-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Yosry Ahmed <yosryahmed@google.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org



On 6/10/22 12:44 PM, Yosry Ahmed wrote:
> Enable bpf programs to make use of rstat to collect cgroup hierarchical
> stats efficiently:
> - Add cgroup_rstat_updated() kfunc, for bpf progs that collect stats.
> - Add cgroup_rstat_flush() kfunc, for bpf progs that read stats.
> - Add an empty bpf_rstat_flush() hook that is called during rstat
>    flushing, for bpf progs that flush stats to attach to. Attaching a bpf
>    prog to this hook effectively registers it as a flush callback.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Acked-by: Yonghong Song <yhs@fb.com>
