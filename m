From: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH bpf-next v3 00/13] bpf: Introduce selectable memcg for bpf map
Date: Wed, 7 Sep 2022 09:13:09 -0700
Message-ID: <CAADnVQ+ZMCeKZOsb3GL0CnnZW0pxR0oDTUjqDczvbsVAViLs-Q@mail.gmail.com>
References: <20220902023003.47124-1-laoar.shao@gmail.com> <Yxi8I4fXXSCi6z9T@slm.duckdns.org>
 <Yxi8i3eP4fDDv2+X@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=CdfonG3Daj+a+DRtXJOAxXJ4mGEklFmGRagUZWD+cvk=;
        b=Z1rGqY1ffwxgupGWkW6pQ+f5YhPrqQnvr/EKxVoO5zamDhVUf5LFJW6hwj/MoDMCGo
         rCiXcvnPDuekOgwxJPi7xLOUMAr3g7SVrx3Ijy6giUgCxCU3P+Cy7G1iQu/YtGCS+X09
         jq4RJykUP1fu4qw2jrQEP4nQpO546ANxS8bWLYiBJyJ/hfR7W41j9LbGe11pSK1HFXfa
         qvA7OgVXsIBXah6n3P8RTNJzcNSYepd8caKdsjGhuNOJcLoMOnRsTag7aQlQQCeLeGjL
         rVIKJrbqOqCz0HBcs/YudYF7oXU3fUx3qoEnHjsrRgckkwr9OlrcaW5HMhkj7XH3PibM
         Ur9Q==
In-Reply-To: <Yxi8i3eP4fDDv2+X-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Netwo

On Wed, Sep 7, 2022 at 8:45 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Wed, Sep 07, 2022 at 05:43:31AM -1000, Tejun Heo wrote:
> > Hello,
> >
> > On Fri, Sep 02, 2022 at 02:29:50AM +0000, Yafang Shao wrote:
> > ...
> > > This patchset tries to resolve the above two issues by introducing a
> > > selectable memcg to limit the bpf memory. Currently we only allow to
> > > select its ancestor to avoid breaking the memcg hierarchy further.
> > > Possible use cases of the selectable memcg as follows,
> >
> > As discussed in the following thread, there are clear downsides to an
> > interface which requires the users to specify the cgroups directly.
> >
> >  https://lkml.kernel.org/r/YwNold0GMOappUxc-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org
> >
> > So, I don't really think this is an interface we wanna go for. I was hoping
> > to hear more from memcg folks in the above thread. Maybe ping them in that
> > thread and continue there?
>
> Ah, another thing. If the memcg accounting is breaking things right now, we
> can easily introduce a memcg disable flag for bpf memory. That should help
> alleviating the immediate breakage while we figure this out.

Hmm. We discussed this option already. We definitely don't want
to introduce an uapi knob that will allow anyone to skip memcg
accounting today and in the future.
