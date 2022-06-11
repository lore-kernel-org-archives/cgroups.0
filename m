From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH bpf-next v2 6/8] cgroup: bpf: enable bpf programs to
 integrate with rstat
Date: Sat, 11 Jun 2022 12:57:06 -0700
Message-ID: <20220611195706.j62cqsodmlnd2ba3@macbook-pro-3.dhcp.thefacebook.com>
References: <20220610194435.2268290-7-yosryahmed@google.com>
 <202206110544.D5cTU0WQ-lkp@intel.com>
 <CAJD7tkZqCrqx0UFHVXv3VMNNk8YJrJGtVVy_tP3GDTryh375PQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=69qufdjHZYbeHsBwGe+HrL6zSpg4GE3ElfZE/CEpkyQ=;
        b=f++YpzR5KW9PWNVQnwBZeC4BYVySUNWUywzBPcqEkDMsHP7whRtKdbDnED0JnsAIUY
         DuNFL3fl5QyGoXE1x1+G0bZaVqZQL+D4Z619LX9xiI4NOLrPokU9c3QjLyuygt3seQzj
         7dEK/IY5CU31UAi8ZqkoiEM1kp1xp0wKpL5N2gQqr1EP7UrZANkI8+S1Ilv7Ca+Wr38K
         6M1N0uWjM87BhWhVVx6drQ5VybmkFoRqGepvynIsSIUMBHPUKuR88corOkKV92gJg2e8
         UR2HpKIwpu4cZJIw9tdjlxDmupZrQs2ugBNEhO9hQw7cGynYbMO8Uk666TNMu7cQwkwf
         O80Q==
Content-Disposition: inline
In-Reply-To: <CAJD7tkZqCrqx0UFHVXv3VMNNk8YJrJGtVVy_tP3GDTryh375PQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: kernel test robot <lkp@intel.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <skhan@linuxfoundation.org>, Michal Hocko <mhocko@kernel.org>, kbuild-all@lists.01.org, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Linux

On Fri, Jun 10, 2022 at 02:30:00PM -0700, Yosry Ahmed wrote:
> 
> AFAICT these failures are because the patch series depends on a patch
> in the mailing list [1] that is not in bpf-next, as explained by the
> cover letter.
> 
> [1] https://lore.kernel.org/bpf/20220421140740.459558-5-benjamin.tissoires@redhat.com/

You probably want to rebase and include that patch as patch 1 in your series
preserving Benjamin's SOB and cc-ing him on the series.
Otherwise we cannot land the set, BPF CI cannot test it, and review is hard to do.
