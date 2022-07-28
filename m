From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH bpf-next v5 6/8] cgroup: bpf: enable bpf programs to
 integrate with rstat
Date: Thu, 28 Jul 2022 06:51:57 -1000
Message-ID: <YuK+rbZXg7CYjLhE@slm.duckdns.org>
References: <20220722174829.3422466-1-yosryahmed@google.com>
 <20220722174829.3422466-7-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=fUVrK6g6lEQcJgvUhuFR+4LVGwptL3CDZhDO7VRmNOg=;
        b=TOhl89jKQ+CkKM87tj1vWT5uQe8ni61gDVjTKzKPd+UpFyilcZ9zwRWS+IPM5TGXaU
         u4OZN8NerzC0JJFwL/LMrixY61CQxOavVDHVnFiRXhWoqiKIS84crWtf2ADSbsopoDx9
         CqQVo0FPvxJzSOYl/kChHOYJRiYCXURZQu8o9ZpkYt7W9Jc0yqedeTqfNgiIUSdvNoKH
         2xPMnNg3Z1+5kPRZ2bfAL3VxeSVJUXCxZbwDO0jc3uxzGND46zHX0Q20Wi38L9P+V6EH
         CfgH6pPNiN77F64BMbn4ufnL8wVhgVcbTodO/fXy6GyeF4xIHvXyxZkVykVSklWTTq82
         5KGw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220722174829.3422466-7-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>, KP Singh <kpsingh@kernel.org>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, John Fastabend <john.fastabend@gmail.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>

On Fri, Jul 22, 2022 at 05:48:27PM +0000, Yosry Ahmed wrote:
> Enable bpf programs to make use of rstat to collect cgroup hierarchical
> stats efficiently:
> - Add cgroup_rstat_updated() kfunc, for bpf progs that collect stats.
> - Add cgroup_rstat_flush() sleepable kfunc, for bpf progs that read stats.
> - Add an empty bpf_rstat_flush() hook that is called during rstat
>   flushing, for bpf progs that flush stats to attach to. Attaching a bpf
>   prog to this hook effectively registers it as a flush callback.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
