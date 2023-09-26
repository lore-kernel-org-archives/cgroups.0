From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH bpf-next 0/8] bpf, cgroup: Add bpf support for cgroup controller
Date: Tue, 26 Sep 2023 11:08:39 +0800
Message-ID: <CALOAHbBAOY7dRO-gQnGXU0xdD2DdzdgX5FLx9ty=u7Q1ZEfL8w@mail.gmail.com>
References: <20230922112846.4265-1-laoar.shao@gmail.com> <9e83bda8-ea1b-75b9-c55f-61cf11b4cd83@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695697755; x=1696302555; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LHSIKUeBex5AI8uxl+C0er1czMgcQqC68b/wIooWTTM=;
        b=GKTNcrEA5fTTZLWAYJZ/DtBxvpv0317vg7njbKqQChkBIC7y6kzJkMIHvVOY385l2y
         GgS6hxpAJHYyYCcxR94JMcJcMrdB8q2i+7w1Xnje+Xzoxk9sz9Rpxmv/2hRurqdSkhP2
         Wx62aFVtHk2EuMgTtbX3IoMQSV/nBEtsgAmP3P9WX6SBbMv9VLlR3UpZJzm81xebu2bc
         oMgPPAklf+Uzm5YNQ4rIP6VuV/jufhdYcxgiPb6lD+SC5Ghrh6eEvCct96CXNI06RRqk
         YxsmVcJUtItPrZwG9gu4PssZpqHVR4HXIDsuEo+n8LhY+NfVALlrEgzE+PLVT+tr3wX7
         0SOw==
In-Reply-To: <9e83bda8-ea1b-75b9-c55f-61cf11b4cd83-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Kui-Feng Lee <sinquersw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yonghong.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Sep 26, 2023 at 2:22=E2=80=AFAM Kui-Feng Lee <sinquersw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =
wrote:
>
>
>
> On 9/22/23 04:28, Yafang Shao wrote:
> > Currently, BPF is primarily confined to cgroup2, with the exception of
> > cgroup_iter, which supports cgroup1 fds. Unfortunately, this limitation
> > prevents us from harnessing the full potential of BPF within cgroup1
> > environments.
> >
> > In our endeavor to seamlessly integrate BPF within our Kubernetes
> > environment, which relies on cgroup1, we have been exploring the
> > possibility of transitioning to cgroup2. While this transition is
> > forward-looking, it poses challenges due to the necessity for numerous
> > applications to adapt.
> >
> > While we acknowledge that cgroup2 represents the future, we also recogn=
ize
> > that such transitions demand time and effort. As a result, we are
> > considering an alternative approach. Instead of migrating to cgroup2, w=
e
> > are contemplating modifications to the BPF kernel code to ensure
> > compatibility with cgroup1. These adjustments appear to be relatively
> > minor, making this option more feasible.
>
> Do you mean giving up moving to cgroup2? Or, is it just a tentative
> solution?

Our transition to cgroup2 won't happen in the near future. It's a
long-term job.

--=20
Regards
Yafang
