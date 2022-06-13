From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH bpf-next v2 6/8] cgroup: bpf: enable bpf programs to
 integrate with rstat
Date: Mon, 13 Jun 2022 10:05:24 -0700
Message-ID: <CAJD7tkba1Ojd+jd7WCa5Lc4sr=3e=4E4_UviHyhLtPfxZcyzpA@mail.gmail.com>
References: <20220610194435.2268290-7-yosryahmed@google.com>
 <202206110544.D5cTU0WQ-lkp@intel.com> <CAJD7tkZqCrqx0UFHVXv3VMNNk8YJrJGtVVy_tP3GDTryh375PQ@mail.gmail.com>
 <20220611195706.j62cqsodmlnd2ba3@macbook-pro-3.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KoHbfQqPxgY9yzkcDMM8WJkeOP/2rasHhf0aBaG7YMk=;
        b=CGQlrM5BP7x7O5U5HXhVD5E6vhiC48JFPNq/iEHbZugUGF1PH9mRo1PEbdLg95PhIT
         85sgUpFKPx6kQ0goj4wa4ZGoO+Agj+ijb78wILvKTIUWV4R1ylkwaTwj+QJNJ59U3kV2
         EvmdCDyDRC6z34zBOyxBfhggAWuE5PeN3eIW7NxGN0nA1/Ff9Mlb5Dpwf6qQHpvIU873
         CYR4KBRtjQ6a/yi3Qft7sU6fZOAU5sBJsiPl6NCNDhcKTH294QdGfYDpV70YW4zda0vY
         0pahJvLUSaRLuf63uiUYZCaC4Jvi0Vs7J+7ZzBHghgaKHmKJvIquFADEf+ZbvuP2pIaT
         t5GA==
In-Reply-To: <20220611195706.j62cqsodmlnd2ba3@macbook-pro-3.dhcp.thefacebook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: kernel test robot <lkp@intel.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <skhan@linuxfoundation.org>, Michal Hocko <mhocko@kernel.org>, kbuild-all@lists.01.org, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Linux

On Sat, Jun 11, 2022 at 12:57 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Jun 10, 2022 at 02:30:00PM -0700, Yosry Ahmed wrote:
> >
> > AFAICT these failures are because the patch series depends on a patch
> > in the mailing list [1] that is not in bpf-next, as explained by the
> > cover letter.
> >
> > [1] https://lore.kernel.org/bpf/20220421140740.459558-5-benjamin.tissoires@redhat.com/
>
> You probably want to rebase and include that patch as patch 1 in your series
> preserving Benjamin's SOB and cc-ing him on the series.
> Otherwise we cannot land the set, BPF CI cannot test it, and review is hard to do.

Sounds good. Will rebase do that and send a v3.
