From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH bpf-next 1/9] bpf: introduce CGROUP_SUBSYS_RSTAT
 program type
Date: Tue, 10 May 2022 15:10:09 -0700
Message-ID: <CAJD7tkZPLStC2h5PhZpDhp+vSBM3oExROpOO33_SdB+bpUMo_Q@mail.gmail.com>
References: <20220510001807.4132027-1-yosryahmed@google.com>
 <20220510001807.4132027-2-yosryahmed@google.com> <Ynqyh+K1tMyNCTUW@slm.duckdns.org>
 <CAJD7tkZVXJY3s2k8M4pcq+eJVD+aX=iMDiDKtdE=j0_q+UWQzA@mail.gmail.com>
 <YnrEDfZs1kuB1gu5@slm.duckdns.org> <CAJD7tkahC1e-_K0xJMu-xXwd8WNVzYDRgJFua9=JhNRq7b+G8A@mail.gmail.com>
 <YnrSrKFTBn3IyUfa@slm.duckdns.org> <CAJD7tkbeZPH9UJXtGeopPnTSVPYN-GzzM51SE_QNuLmiaVNpeA@mail.gmail.com>
 <YnrijQK6l77qAo+z@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u7uOUCqMoDgltJ1uxZ5LMikYT8wvvkHVCGV6bc1awcY=;
        b=Gd7NslwHhpbIbxp10MPezPhTaEU5GdrwG8KeXZN8DL72uNDigerprtOo0TkFtwaOd3
         mWkOyJ08FDW34jRv/tAS7FAW30ZQyBqaiFyE93uZTlsyiBezkqXtI5KUb3f23DdQ6MZS
         X0EhZuRxspsI8kngmi34mQjgoANio3kHInTXm5gn+4m8xQsuyxwUmP++TfEBV2SBbJzz
         oH7ilbDk5KBGr/29XTHbFFeRyVSm7/Af1v1Slrac5Sz6rLUqt3S8UAhSVajhfyhTdQTT
         fACT+w973yomcwW3HIcFPP5L7MXi0Qt/JDzndbbI8CiD81VlxTsmiGtyMS9qmqQmOLYb
         uAUw==
In-Reply-To: <YnrijQK6l77qAo+z-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Networking <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, May 10, 2022 at 3:09 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Tue, May 10, 2022 at 02:55:32PM -0700, Yosry Ahmed wrote:
> > That's great to hear. I am all in for making the userspace interface
> > simpler. I will rework this patch series so that the BPF programs just
> > attach to "rstat" and send a V1.
> > Any other concerns you have that you think I should address in V1?
>
> Not that I can think of right now but my bpf side insight is really limited,
> so it might be worthwhile to wait for some bpf folks to chime in?
>

Sounds good. Will wait for feedback on the BPF side of things before I
send a V1.

> Thanks.
>
> --
> tejun
