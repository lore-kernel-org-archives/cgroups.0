From: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [V2][PATCH] cgroup: fix memory leak caused by missing cgroup_bpf_offline
Date: Fri, 22 Oct 2021 14:29:24 -0700
Message-ID: <CAADnVQJANZQJ5pAeH5KkC2rtY1TDFA_AomDfaPaBY_hw8qhgSA@mail.gmail.com>
References: <20211018075623.26884-1-quanyang.wang@windriver.com>
 <YXIUMJWrXUcrvZf5@carbon.DHCP.thefacebook.com> <35e9e89f-d92f-06f9-b919-ef956d99d7df@windriver.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ol5e64LpFv12Uil1+Y88UDesKUE1+NUsIExRzpZDEd8=;
        b=BpmWcikC+ew8/gMm6u1SAa+zQSytt+28rPkVD5UD9I2c7P06ebvMGKHBAHptJ1Lq8L
         UA1XQ4C+3ESsY0odxDK5aAETefQyvMnYkj1Lr3huk98RrYTPlQwZfXsinwPvZlzqD0wo
         gNdvqKs3E5yFjwIMvH/1dmamiM9QdmoP1I4A8q1UqieeLL5a5itT/wVC6kuHRrzzwOKK
         0o5rJs11ikZPvW7bOzw9JQUVnQUbPIQ2Ias6W43qmCQNYSYFtvjnYMY9tvFGipiUpd5l
         R+8k2jXj+KQdxj+pr11/XkTbBvnpR72l94pSyNVf1pA5sKoQPOVgS6TRv4k/HyYXbzJP
         Hd5Q==
In-Reply-To: <35e9e89f-d92f-06f9-b919-ef956d99d7df-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Quanyang Wang <quanyang.wang-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, mkoutny-IBi9RG/b67k@public.gmane.org, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Network Development <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Oct 22, 2021 at 4:56 AM Quanyang Wang
<quanyang.wang-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org> wrote:
> >> Fixes: 2b0d3d3e4fcf ("percpu_ref: reduce memory footprint of percpu_ref in fast path")
> >> Fixes: 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf from cgroup itself")
> >> Signed-off-by: Quanyang Wang <quanyang.wang-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
> >> ---
> >> V1 ---> V2:
> >> 1. As per Daniel's suggestion, add description to commit msg about the
> >> balance of cgroup's refcount in cgroup_bpf_offline.
> >> 2. As per Michal's suggestion, add tag "Fixes: 4bfc0bb2c60e" and add
> >> description about it.
> >> 3. Fix indentation on the percpu_ref_is_dying line.
> >
> > Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> >
> > The fix looks correct, two fixes tag are fine too, if only it won't
> > confuse scripts picking up patches for stable backports.
> >
> > In fact, it's a very cold path, which is arguably never hit in the real
> > life. On cgroup v2 it's not an issue. I'm not sure we need a stable
> > backport at all, only if it creates a noise for some automation tests.
> >
> > Quanyang, out of curiosity, how did you find it?
> I ran ltp testsuite to find this.
>
> ./runltp -f controllers -s cgroup
>
> Thanks,
> Quanyang
> >
> > Anyway, thanks for catching and fixing it!

Applied to bpf tree. Thanks everyone!
