From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
Date: Fri, 20 May 2022 15:19:19 -0700
Message-ID: <20220520221919.jnqgv52k4ajlgzcl@MBP-98dd607d3435.dhcp.thefacebook.com>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-4-yosryahmed@google.com>
 <YodGI73xq8aIBrNM@slm.duckdns.org>
 <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com>
 <YodNLpxut+Zddnre@slm.duckdns.org>
 <73fd9853-5dab-8b59-24a0-74c0a6cae88e@fb.com>
 <YofFli6UCX4J5YnU@slm.duckdns.org>
 <CA+khW7gjWVKrwCgDD-4ZdCf5CMcA4-YL0bLm6aWM74+qNQ4c0A@mail.gmail.com>
 <CAJD7tkaJQjfSy+YARFRkqQ8m7OGJHO9v91mSk-cFeo9Z5UVJKg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b7Vm31N1KmiKaz7SbohqBjKzTjmGJnpUAVkpKWUThMY=;
        b=H3ZjIy79fwHtkOfYF1Ill/fMPUjrPR7E2pkOa/YhCb1jGsvLLxRr6uOQICQCl8yq2h
         KzSERIApbRFXR9lmG4Uk3nHZvFVq8Uue1kE4LnmFLR/v/rN9npvSJts7f+iytk8LCo9a
         fpRMMlwIruvdNJLVHaMg5qOJAgX4M5Fc/F1tt0tD6yZZrIAOeapE9xs6S16JiuWCsju2
         Asxl3i8dLiXmCXxEAOBresM3uaNtP212C8mONg3FwmL4Z7oqEaT+taMPqifRHmMmn/nx
         2IQLI+zcVqY30ca/PvxFcTrMC7DqzhHrftAfzpFMlIUEPLJgJV9MGm5xgioYQqWSeEHB
         nm+g==
Content-Disposition: inline
In-Reply-To: <CAJD7tkaJQjfSy+YARFRkqQ8m7OGJHO9v91mSk-cFeo9Z5UVJKg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>, Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Networking <netdev@v>

On Fri, May 20, 2022 at 02:18:42PM -0700, Yosry Ahmed wrote:
> >
> > The userspace needs to specify the identity of the cgroup, when
> > creating bpf_iter. This identity could be cgroup id or fd. This
> > identity needs to be converted to cgroup object somewhere before
> > passing into bpf program to use.
> 
> 
> Let's sum up the discussion here, I feel like we are losing track of
> the main problem. IIUC the main concern is that cgroup_iter is not
> effectively an iterator, it rather dumps information for one cgroup. I
> like the suggestion to make it iterate cgroups by default, and an
> optional cgroup_id parameter to make it only "iterate" this one
> cgroup.

We have bpf_map iterator that walks all bpf maps.
When map iterator is parametrized with map_fd the iterator walks
all elements of that map.
cgroup iterator should have similar semantics.
When non-parameterized it will walk all cgroups and their descendent
depth first way. I believe that's what Yonghong is proposing.
When parametrized it will start from that particular cgroup and
walk all descendant of that cgroup only.
The bpf prog can stop the iteration right away with ret 1.
Maybe we can add two parameters. One -> cgroup_fd to use and another ->
the order of iteration css_for_each_descendant_pre vs _post.
wdyt?
