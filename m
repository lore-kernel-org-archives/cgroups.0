From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH bpf-next 1/9] bpf: introduce CGROUP_SUBSYS_RSTAT
 program type
Date: Tue, 10 May 2022 12:09:17 -1000
Message-ID: <YnrijQK6l77qAo+z@slm.duckdns.org>
References: <20220510001807.4132027-1-yosryahmed@google.com>
 <20220510001807.4132027-2-yosryahmed@google.com>
 <Ynqyh+K1tMyNCTUW@slm.duckdns.org>
 <CAJD7tkZVXJY3s2k8M4pcq+eJVD+aX=iMDiDKtdE=j0_q+UWQzA@mail.gmail.com>
 <YnrEDfZs1kuB1gu5@slm.duckdns.org>
 <CAJD7tkahC1e-_K0xJMu-xXwd8WNVzYDRgJFua9=JhNRq7b+G8A@mail.gmail.com>
 <YnrSrKFTBn3IyUfa@slm.duckdns.org>
 <CAJD7tkbeZPH9UJXtGeopPnTSVPYN-GzzM51SE_QNuLmiaVNpeA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K/YRl0EHG6/vXUptECv10Aauq/B8k7rs/JZcz3pAi9w=;
        b=CJvFFv58sImc2fcQ7NsltAoprTMkf9aZO2qc39iio4VUJ+QAhHceQxanfIuUeIi5Nm
         W24275MUyU6Z6K6+FBOiW62RkCq2sZC1HOJ/ffKJabKOHIBTVrPBRDzdofuuLXhcOfqg
         1lnstTBHmuonZVrjv3cX/EM733/CP+IwyYzrH1GcL2u0Wn0aXSxPYXiKakw4rB/NA3UH
         X+V1l4tH5u7VXfQ5syp8MZv8EF5IUZRjUdKpaoTP/mQXZAM2WISVdqSZW8Ly95fHSSwg
         LyqF6dVvC9WnSNLoa6nEfPa6DEwLmOVttivdoBEHQEcwqapkfLt6jxYRbhyTSZ1486Hy
         8h9Q==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <CAJD7tkbeZPH9UJXtGeopPnTSVPYN-GzzM51SE_QNuLmiaVNpeA@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>

Hello,

On Tue, May 10, 2022 at 02:55:32PM -0700, Yosry Ahmed wrote:
> That's great to hear. I am all in for making the userspace interface
> simpler. I will rework this patch series so that the BPF programs just
> attach to "rstat" and send a V1.
> Any other concerns you have that you think I should address in V1?

Not that I can think of right now but my bpf side insight is really limited,
so it might be worthwhile to wait for some bpf folks to chime in?

Thanks.

-- 
tejun
