From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH bpf-next v4 1/8] btf: Add a new kfunc set which allows to
 mark a function to be sleepable
Date: Fri, 22 Jul 2022 10:49:52 -0700
Message-ID: <CAJD7tkaSx9Oc3WC1C3BObRRXgsj6gvG6hRj9oL-P_BeWXvjS-A@mail.gmail.com>
References: <20220722021313.3150035-1-yosryahmed@google.com>
 <20220722021313.3150035-2-yosryahmed@google.com> <CAADnVQ+c7uuVXukguvy9x2HjM9K8rj6LOa_QJ_n+MVB-bOx3uQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gUTDStGbNNw1f/BTAauOJuxuHrm/bJ5Do+y2MoJFquA=;
        b=Ew6/AHGD9JmeBb3RRlzM2HRqhGhbZX1gLPxyfbOLnHm7krtjtVsgu1gPvDAnbCexP/
         hHUFF9gXmeyog/wnl+8F4z52le24cuf6m+6dpZamYs16B2PvRP54pBayNDl3lgQQB/kp
         hKycIP0bVMhP9givw1kievFqR4ER331GbkItxSRvtJZwOe7StGhXfkCEYqi0AMsv4XnX
         qtb9R1lAO9qDKvGZuqDxMKuolAevLHQIV1Pzi1ckspKF3KunAYZNdGiY8rUIPNP/Nl4D
         Slkv9aCN48TELd8pjAVcxtPY+gs5PC1ewbVxR1H/Qmrq/zhPqHAFBUsMneVTDNhdIFqU
         JVcg==
In-Reply-To: <CAADnVQ+c7uuVXukguvy9x2HjM9K8rj6LOa_QJ_n+MVB-bOx3uQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shake>

On Fri, Jul 22, 2022 at 9:20 AM Alexei Starovoitov
<alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On Thu, Jul 21, 2022 at 7:13 PM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > From: Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >
> > This allows to declare a kfunc as sleepable and prevents its use in
> > a non sleepable program.
> >
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > ---
> >  include/linux/btf.h |  2 ++
> >  kernel/bpf/btf.c    | 13 +++++++++++--
> >  2 files changed, 13 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/btf.h b/include/linux/btf.h
> > index 1bfed7fa0428..6e7517573d9e 100644
> > --- a/include/linux/btf.h
> > +++ b/include/linux/btf.h
> > @@ -18,6 +18,7 @@ enum btf_kfunc_type {
> >         BTF_KFUNC_TYPE_RELEASE,
> >         BTF_KFUNC_TYPE_RET_NULL,
> >         BTF_KFUNC_TYPE_KPTR_ACQUIRE,
> > +       BTF_KFUNC_TYPE_SLEEPABLE,
> >         BTF_KFUNC_TYPE_MAX,
> >  };
>
> This patch needs refactoring using the new BTF_ID_FLAGS scheme.
> When you do that please update the Documentation/bpf/kfuncs.rst as well.
>
> Thanks!

Sent v5 rebased on top of the new kfunc flags infrastructure, and
added documentation for sleepable kfuncs.
