From: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH bpf-next v3 4/8] bpf: Introduce cgroup iter
Date: Thu, 21 Jul 2022 10:21:53 -0700
Message-ID: <CA+khW7ihQmjwGuVPCEuZ5EXMiMWWaxiAatmjpo1xiaWokUNRGw@mail.gmail.com>
References: <20220709000439.243271-1-yosryahmed@google.com>
 <20220709000439.243271-5-yosryahmed@google.com> <370cb480-a427-4d93-37d9-3c6acd73b967@fb.com>
 <a6d048b8-d017-ea7e-36f0-1c4f88fc4399@fb.com> <CA+khW7gmVmXMg4YP4fxTtgqNyAr4mQqnXbP=z0nUeQ8=hfGC3g@mail.gmail.com>
 <2a26b45d-6fab-b2a2-786e-5cb4572219ea@fb.com> <CA+khW7jp+0AadVagqCcV8ELNRphP47vJ6=jGyuMJGnTtYynF+Q@mail.gmail.com>
 <3f3ffe0e-d2ac-c868-a1bf-cdf1b58fd666@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S3C8q1laz4rBJ9aGVPrsPOjt/QLLVMunUdYBJjHo4DE=;
        b=FilIoPgSWSX+M9Q5xzcjR7Bm7oSCIxKHBRehRGwnQpyGPiolhL1PxrDc/gy3NEOgOA
         WtGktAZpu/0N7X96yPfmjrLk2bK/wsS8TEOdha+N5u6sMaZkwMhw8bnIsVuTtsAWfZ9o
         htlMSo/fKYogD8FOwfdEzo5i+r75wKKrQSZlleXpxHTTDFqyRHQyrtEU3d8Qj5hwOytl
         2Vl8qkFZwE4dMFP7JDWy90fDAGFnFDYaM5yEfdAeOrfMN5c4raOQQd17eiuYR0t0J5A5
         vpib/yCSI2QQxVVS5XwklwcxvCmxO2tOy1SVFzfY7kFlxniF2kdvaqzNIhWOLJ+DZBJ+
         dnaQ==
In-Reply-To: <3f3ffe0e-d2ac-c868-a1bf-cdf1b58fd666-b10kYP2dOMg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu, Jul 21, 2022 at 9:15 AM Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org> wrote:
>
>
>
> On 7/20/22 5:40 PM, Hao Luo wrote:
> > On Mon, Jul 11, 2022 at 8:45 PM Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org> wrote:
> >>
> >> On 7/11/22 5:42 PM, Hao Luo wrote:
> > [...]
> >>>>>> +
> >>>>>> +static void *cgroup_iter_seq_start(struct seq_file *seq, loff_t *pos)
> >>>>>> +{
> >>>>>> +    struct cgroup_iter_priv *p = seq->private;
> >>>>>> +
> >>>>>> +    mutex_lock(&cgroup_mutex);
> >>>>>> +
> >>>>>> +    /* support only one session */
> >>>>>> +    if (*pos > 0)
> >>>>>> +        return NULL;
> >>>>>
> >>>>> This might be okay. But want to check what is
> >>>>> the practical upper limit for cgroups in a system
> >>>>> and whether we may miss some cgroups. If this
> >>>>> happens, it will be a surprise to the user.
> >>>>>
> >>>
> >>> Ok. What's the max number of items supported in a single session?
> >>
> >> The max number of items (cgroups) in a single session is determined
> >> by kernel_buffer_size which equals to 8 * PAGE_SIZE. So it really
> >> depends on how much data bpf program intends to send to user space.
> >> If each bpf program run intends to send 64B to user space, e.g., for
> >> cpu, memory, cpu pressure, mem pressure, io pressure, read rate, write
> >> rate, read/write rate. Then each session can support 512 cgroups.
> >>
> >
> > Hi Yonghong,
> >
> > Sorry about the late reply. It's possible that the number of cgroup
> > can be large, 1000+, in our production environment. But that may not
> > be common. Would it be good to leave handling large number of cgroups
> > as follow up for this patch? If it turns out to be a problem, to
> > alleviate it, we could:
> >
> > 1. tell users to write program to skip a certain uninteresting cgroups.
> > 2. support requesting large kernel_buffer_size for bpf_iter, maybe as
> > a new bpf_iter flag.
>
> Currently if we intend to support multiple read() for cgroup_iter,
> the following is a very inefficient approach:
>
> in seq_file private data structure, remember the last cgroup visited
> and for the second read() syscall, do the traversal again (but not
> calling bpf program) until the last cgroup and proceed from there.
> This is inefficient and probably works. But if the last cgroup is
> gone from the hierarchy, that the above approach won't work. One
> possibility is to remember the last two cgroups. If the last cgroup
> is gone, check the 'next' cgroup based on the one before the last
> cgroup. If both are gone, we return NULL.
>

I suspect in reality, just remembering the last cgroup (or two
cgroups) may not be sufficient. First, I don't want to hold
cgroup_mutex across multiple sessions. I assume it's also not safe to
release cgroup_mutex in the middle of walking cgroup hierarchy.
Supporting multiple read() can be nasty for cgroup_iter.

> But in any case, if there are additional cgroups not visited,
> in the second read(), we should not return NULL which indicates
> done with all cgroups. We may return EOPNOTSUPP to indicate there
> are missing cgroups due to not supported.
>
> Once users see EOPNOTSUPP which indicates there are missing
> cgroups, they can do more filtering in bpf program to avoid
> large data volume to user space.
>

Makes sense. Yonghong, one question to confirm, if the first read()
overflows, does the user still get partial data?

I'll change the return code to EOPNOTSUPP in v4 of this patchset.

> To provide a way to truely visit *all* cgroups,
> we can either use bpf_iter link_create->flags
> to increase the buffer size as your suggested in the above so
> user can try to allocate more kernel buffer size. Or implement
> proper second read() traversal which I don't have a good idea
> how to do it efficiently.

I will try the buffer size increase first. Looks more doable. Do you
mind putting this support as a follow-up?

> >
> > Hao
> >
> >>>
> > [...]
> >>>>> [...]
