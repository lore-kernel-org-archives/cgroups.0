From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
Date: Fri, 20 May 2022 18:53:39 -1000
Message-ID: <YohwU2sXYbKvvcWS@slm.duckdns.org>
References: <20220520012133.1217211-4-yosryahmed@google.com>
 <YodGI73xq8aIBrNM@slm.duckdns.org>
 <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com>
 <YodNLpxut+Zddnre@slm.duckdns.org>
 <73fd9853-5dab-8b59-24a0-74c0a6cae88e@fb.com>
 <YofFli6UCX4J5YnU@slm.duckdns.org>
 <CA+khW7gjWVKrwCgDD-4ZdCf5CMcA4-YL0bLm6aWM74+qNQ4c0A@mail.gmail.com>
 <CA+khW7iDDkO3h5WQixEA=nUL-tBmCTh7fMAf3iwNy98UfM-k9g@mail.gmail.com>
 <4cbdd3e9-c6fe-d796-5560-cd09c9220868@fb.com>
 <CA+khW7hGcrvihbb1CV4c4o6yO_3Ju3oU4_04G_A+TKh0vLHY3w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=102aBn0JR3M/WwS/swzSPfkILVklTAZC91XPQIvJBTg=;
        b=PWGRyF2fNaOh4KaYB/zeiEKUH4gVVH4H7/ifcFFhuRWNsHCrDxe8YmmVCugYL2ge9K
         zejnWxqg72zkAp6mdOfbgk1JYA8QaLe+5ci+P6t3IhXcw6uEjCOsGtRFT9guS4M3lMlp
         8hQZX+oEqT2++YZAZOpGw6ZYfCsXmlin7UO1ccUEzS15hfEQuG/9ir0nBZpYFgwd9uUe
         iyWJlGzS8v047mIOfI13H2TS+nNFXUNqB9/aimVaQG7r1j4+cEfcoE06h4FmGaNRC0xx
         ktOjxgUqAfaAK+m1pHith2BbIi28SgkRUtd/OEYblqICMdjcyzdCDP2f7mVsDhktTthj
         NiBw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <CA+khW7hGcrvihbb1CV4c4o6yO_3Ju3oU4_04G_A+TKh0vLHY3w@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Luo <haoluo@google.com>
Cc: Yonghong Song <yhs@fb.com>, Yosry Ahmed <yosryahmed@google.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@v>

On Fri, May 20, 2022 at 07:43:12PM -0700, Hao Luo wrote:
> Yes, passing a cgroup_id as the seek() syscall parameter was what I meant.
> 
> Tejun previously requested us to support seek() for a proper iterator.
> Since Alexei has a nice solution that all of us have ack'ed, I am not
> sure whether we still want to add seek() for bpf_iter as Tejun asked.
> I guess not.

Yeah, I meant seeking with the ID but it's better to follow the same
convention as other iterators.

Thanks.

-- 
tejun
