From: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH bpf-next v5 4/8] bpf: Introduce cgroup iter
Date: Thu, 28 Jul 2022 10:26:32 -0700
Message-ID: <CA+khW7gws1+bWQ2zpodVfAP_rtXv=8K3SSMLx4e9Lh4eKgtnmA@mail.gmail.com>
References: <20220722174829.3422466-1-yosryahmed@google.com>
 <20220722174829.3422466-5-yosryahmed@google.com> <CAP01T76p7CCj2i4X7PmZiG3G3-Bfx_ygnO0Eg+DnfwLHQiEPbA@mail.gmail.com>
 <CA+khW7g2kriOb7on0u_UpGpS2A0bftrQowTB0+AJ=S7rpLKaZA@mail.gmail.com> <639f575e-bc8c-46b9-b21b-bd9fbba835c1@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=id4JWD15x2b6Sb0RDjkodbSRKI5pJBPMhp/NyAFO6Wg=;
        b=ZIv6KqB5YatdsGxiUke6mhx2cB60Jg0nC16W2vfPQN0fh/N7+rSg2esvcPFp3oQ0Qo
         VHjyWTcrZS4B2xIeRUQg3Gp6mFclRSXQTuXEq4EBLT9560pu4oKuV2IcCmrPaN3K57YD
         fqkWbB62X3m1yLgVGqW29+TyZDcTl05KFRbvNOhw5qm4araf+Og1cnkexpRLSmrnqH+e
         8dEi+uSiErW4xqdWg5wBrqWGS+eC2RKjvCWmK/k9Lgkgpintww82349+3yFfSGnbrQL3
         TI8oLqq57xt37hUMYpK9bVuJrreQjyuyOPW6IV+epVfGVfQiPKHIQpUL5j+bEfgLBWYK
         qA4A==
In-Reply-To: <639f575e-bc8c-46b9-b21b-bd9fbba835c1-b10kYP2dOMg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>
Cc: Kumar Kartikeya Dwivedi <memxor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen@google.c>

On Wed, Jul 27, 2022 at 11:56 PM Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org> wrote:
>
>
>
> On 7/22/22 1:33 PM, Hao Luo wrote:
> > On Fri, Jul 22, 2022 at 11:36 AM Kumar Kartikeya Dwivedi
> > <memxor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>
> >> On Fri, 22 Jul 2022 at 19:52, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
<...>
> >>> +
> >>> +static int __cgroup_iter_seq_show(struct seq_file *seq,
> >>> +                                 struct cgroup_subsys_state *css, int in_stop);
> >>> +
> >>> +static void cgroup_iter_seq_stop(struct seq_file *seq, void *v)
> >>> +{
> >>> +       /* pass NULL to the prog for post-processing */
> >>> +       if (!v)
> >>> +               __cgroup_iter_seq_show(seq, NULL, true);
> >>> +       mutex_unlock(&cgroup_mutex);
> >>
> >> I'm just curious, but would it be a good optimization (maybe in a
> >> follow up) to move this mutex_unlock before the check on v? That
> >> allows you to store/buffer some info you want to print as a compressed
> >> struct in a map, then write the full text to the seq_file outside the
> >> cgroup_mutex lock in the post-processing invocation.
> >>
> >> It probably also allows you to walk the whole hierarchy, if one
> >> doesn't want to run into seq_file buffer limit (or it can decide what
> >> to print within the limit in the post processing invocation), or it
> >> can use some out of band way (ringbuf, hashmap, etc.) to send the data
> >> to userspace. But all of this can happen without holding cgroup_mutex
> >> lock.
> >
> > Thanks Kumar.
> >
> > It sounds like an idea, but the key thing is not about moving
> > cgroup_mutex unlock before the check IMHO. The user can achieve
> > compression using the current infra. Compression could actually be
> > done in the bpf program. user can define and output binary content and
> > implement a userspace library to parse/decompress when reading out the
> > data.
>
> Right mutex_unlock() can be moved to the beginning of the
> function since the cgroup is not used in
>    __cgroup_iter_seq_show(seq, NULL, true)

Ok. Will do.
