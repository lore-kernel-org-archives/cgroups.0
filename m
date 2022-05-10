From: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH bpf-next 8/9] bpf: Introduce cgroup iter
Date: Tue, 10 May 2022 15:49:59 -0700
Message-ID: <CA+khW7gUdZQq77jO2_A6rvE6f+HV=sGfBVGvAmazGPvwudE0RQ@mail.gmail.com>
References: <20220510001807.4132027-1-yosryahmed@google.com>
 <20220510001807.4132027-9-yosryahmed@google.com> <Ynq04gC1l7C2tx6o@slm.duckdns.org>
 <CA+khW7girnNwap1ABN1a4XuvkEEnmkztTV+fsuC3MsxNeB08Yg@mail.gmail.com> <YnriMPYyOP9ibskc@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5pgf2LC4mfZtxmKKitMud+Oy12RPGcU3F46iHWGsadA=;
        b=ekAQBJLQ0g2H+FUmFV5f70dwdMJlmpMe43UT4QIXA58jzQ7eDTurlQUHhbMjmFXgUn
         iSvHyXVOpjYMsk92HbvRZQl8ByOek4TmP4dutBYmWmysLSp+0lz8VY73TGj93QW0TK/I
         wFDu3nWggMxUUhT25DqnrpkQRHcZyfZQlsTbTl94c/g9RyI7z/yYTSrr78bkYPz4zPE6
         iY4Bp9up41gXopOTZgVvz0svbTi1cJwop5wCmJ5rigsS40iOXz4jYN10Zh1qCwptI9S1
         NrCYR94Zlax6XmK+bd61BAf+16YQeV+dhN2Bpph/aIHzuhFyMVqWf35ODyxRjEeOQHST
         hZVg==
In-Reply-To: <YnriMPYyOP9ibskc-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, May 10, 2022 at 3:07 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Tue, May 10, 2022 at 02:12:16PM -0700, Hao Luo wrote:
> > > Is there a reason why this can't be a proper iterator which supports
> > > lseek64() to locate a specific cgroup?
> > >
> >
> > There are two reasons:
> >
> > - Bpf_iter assumes no_llseek. I haven't looked closely on why this is
> > so and whether we can add its support.
> >
> > - Second, the name 'iter' in this patch is misleading. What this patch
> > really does is reusing the functionality of dumping in bpf_iter.
> > 'Dumper' is a better name. We want to create one file in bpffs for
> > each cgroup. We are essentially just iterating a set of one single
> > element.
>
> I see. I'm just shooting in the dark without context but at least in
> principle there's no reason why cgroups wouldn't be iterable, so it might be
> something worth at least thinking about before baking in the interface.
>

Yep. Conceptually there should be no problem to iterate cgroups in the
system. It may be better to have two independent bpf objects: bpf_iter
and bpf_dumper. In our use case, we want bpf_dumper, which just
exports data out through fs interface.

Hao
