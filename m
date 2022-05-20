From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
Date: Fri, 20 May 2022 01:27:38 -1000
Message-ID: <Yod7Kt4WHUCQF6ZL@slm.duckdns.org>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-4-yosryahmed@google.com>
 <YodGI73xq8aIBrNM@slm.duckdns.org>
 <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com>
 <YodNLpxut+Zddnre@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+9muHQcSOPadjELaK4tBcIlD0k856uUfntUxfRazXLk=;
        b=Ao4YwNxEANIqA3Dyk1b/rxmBdNuHL7GvoYBuDycoCTZQt/Vw7ghB/x/W1uDmrygwUh
         ZCOdrrAEkOWjqjv6YVqpVG4zrjzsDCqFbhMv46EPRRMudfif5CGT4m7OGe5qGXs2xCH6
         gdzX9ygA7ovfxwBmlG4x9Irbwdb3DkHTyKqVVGELOPbMvf9k6p/xlMXriOgcjKGO4rLv
         pPIJvH/5FMQq9/loteNF5RYVpe4mtKF4+lZuVNiVrwpN6GT7rXoipiYq/z2HO9FxiVLd
         tyeTXejon/ephAWoN7uz4Bdz48sZvRU0qsArH1lB8+SpkRWYtZpMHOweZEBpupJDWxFz
         zTWw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <YodNLpxut+Zddnre@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>

On Thu, May 19, 2022 at 10:11:26PM -1000, Tejun Heo wrote:
> If you *must* do the iterator, can you at least make it a proper iterator
> which supports seeking? AFAICS there's nothing fundamentally preventing bpf
> iterators from supporting seeking. Or is it that you need something which is
> pinned to a cgroup so that you can emulate the directory structure?

Or, alternatively, would it be possible to make a TEST_RUN_PROG to output a
text file in bpffs? There just doesn't seem to be anything cgroup specific
that the iterator is doing that can't be done with exposing a couple kfuncs.

Thanks.

-- 
tejun
