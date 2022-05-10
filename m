From: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH bpf-next 8/9] bpf: Introduce cgroup iter
Date: Tue, 10 May 2022 14:12:16 -0700
Message-ID: <CA+khW7girnNwap1ABN1a4XuvkEEnmkztTV+fsuC3MsxNeB08Yg@mail.gmail.com>
References: <20220510001807.4132027-1-yosryahmed@google.com>
 <20220510001807.4132027-9-yosryahmed@google.com> <Ynq04gC1l7C2tx6o@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XYVHi22m1+mXSFa7Nc0RAjeQBwpnm2Xj7XiJSm9Cw/Q=;
        b=bg0OJPq+1ifxyjjTiknBIfD7bywHGJRstK0TY4IrD//sypqPQuAu3G5PLlFk8jLsA8
         BEQB49EYqZHFcSpANBU9k4Y4McljWHHn2nRCFpO5phZwcXHOwS+0YCcMXrkqWuM2yrPi
         CyKeidXdVQPHVG6HF5DB6+aF6PCg7NLaSemz7x8nLmDOcotb7t/kqV/y62a4g6mQjj0D
         WTAVCIve7Uw+uKvbL0lArYC8g7crryu2JrsgF2yAeDqDPrj42kkWhTaSjTVlUcz7xGi1
         XdNRaMFLU5TIpjY4TmcWhK5EdQ+fYDZNJOTnvtHUVaNSVIwMzJ/RrAqI8ijt0Lz1unjN
         hh0Q==
In-Reply-To: <Ynq04gC1l7C2tx6o-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello Tejun,

On Tue, May 10, 2022 at 11:54 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Tue, May 10, 2022 at 12:18:06AM +0000, Yosry Ahmed wrote:
> > From: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >
> > Introduce a new type of iter prog: cgroup. Unlike other bpf_iter, this
> > iter doesn't iterate a set of kernel objects. Instead, it is supposed to
> > be parameterized by a cgroup id and prints only that cgroup. So one
> > needs to specify a target cgroup id when attaching this iter. The target
> > cgroup's state can be read out via a link of this iter.
>
> Is there a reason why this can't be a proper iterator which supports
> lseek64() to locate a specific cgroup?
>

There are two reasons:

- Bpf_iter assumes no_llseek. I haven't looked closely on why this is
so and whether we can add its support.

- Second, the name 'iter' in this patch is misleading. What this patch
really does is reusing the functionality of dumping in bpf_iter.
'Dumper' is a better name. We want to create one file in bpffs for
each cgroup. We are essentially just iterating a set of one single
element.

> Thanks.

>
> --
> tejun
