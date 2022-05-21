From: Hao Luo <haoluo@google.com>
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
Date: Fri, 20 May 2022 19:34:45 -0700
Message-ID: <CA+khW7gGrwTrDsfWp7wj=QaCg01FNj381a1QLs1ThsjAkW85eQ@mail.gmail.com>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-4-yosryahmed@google.com> <YodGI73xq8aIBrNM@slm.duckdns.org>
 <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com>
 <YodNLpxut+Zddnre@slm.duckdns.org> <73fd9853-5dab-8b59-24a0-74c0a6cae88e@fb.com>
 <YofFli6UCX4J5YnU@slm.duckdns.org> <CA+khW7gjWVKrwCgDD-4ZdCf5CMcA4-YL0bLm6aWM74+qNQ4c0A@mail.gmail.com>
 <CAJD7tkaJQjfSy+YARFRkqQ8m7OGJHO9v91mSk-cFeo9Z5UVJKg@mail.gmail.com>
 <20220520221919.jnqgv52k4ajlgzcl@MBP-98dd607d3435.dhcp.thefacebook.com>
 <Yogc0Kb5ZVDaQ0oU@slm.duckdns.org> <5b301151-0a65-df43-3a3a-6d57e10cfc2d@fb.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GPOY2d2iNuO65egkCFZw3rXLU46LbwzRq0Gho1bvrl4=;
        b=gYTL0x/S9SWMzL5yr5pHjL2Os0iUM04qyTCySwDHjdtl4ZDNWVsWyGNPYQTmwR+Wa5
         vVvdRd0+/BHBjj+ZE+kimSd/G5xlwM+XO/ecdcutR1uZwUMaxdUWmyB2RMOqH+6zgwko
         ggJRNM7RXDYfxEO2YdBlTCPs9OiAGlPOnrs9/BOwORDAc5THxIwoVjG1ZxrNO1Wqp1un
         Xae4Tn5esHxugHU4Md0EVA17aJQTl0MJwZ9IfrTBn0P1+CYouofVbq7Gs1KNJI9rt+Lq
         hDWArAengQ0djrKjfvMKg39LWXmqeEcUV8yYVD9rNhDOPtjQrbnxQlXYRbWwysYvePbD
         P4Fw==
In-Reply-To: <5b301151-0a65-df43-3a3a-6d57e10cfc2d@fb.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yonghong Song <yhs@fb.com>
Cc: Tejun Heo <tj@kernel.org>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Yosry Ahmed <yosryahmed@google.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Linux Kernel Mailing List <linux-kernel@vger.ke>

On Fri, May 20, 2022 at 5:59 PM Yonghong Song <yhs@fb.com> wrote:
> On 5/20/22 3:57 PM, Tejun Heo wrote:
> > Hello,
> >
> > On Fri, May 20, 2022 at 03:19:19PM -0700, Alexei Starovoitov wrote:
> >> We have bpf_map iterator that walks all bpf maps.
> >> When map iterator is parametrized with map_fd the iterator walks
> >> all elements of that map.
> >> cgroup iterator should have similar semantics.
> >> When non-parameterized it will walk all cgroups and their descendent
> >> depth first way. I believe that's what Yonghong is proposing.
> >> When parametrized it will start from that particular cgroup and
> >> walk all descendant of that cgroup only.
> >> The bpf prog can stop the iteration right away with ret 1.
> >> Maybe we can add two parameters. One -> cgroup_fd to use and another ->
> >> the order of iteration css_for_each_descendant_pre vs _post.
> >> wdyt?
> >
> > Sounds perfectly reasonable to me.
>
> This works for me too. Thanks!
>

This sounds good to me. Thanks. Let's try to do it in the next iteration.
