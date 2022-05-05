From: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 2/6] cgroup: gpu: Add a cgroup controller for allocator
 attribution of GPU memory
Date: Thu, 5 May 2022 16:56:45 -0700
Message-ID: <CABdmKX2gaWn9X9V3sr9Oyqs3WRsCFr_GTx2A1ifS-cJxGg9RCQ@mail.gmail.com>
References: <20220502231944.3891435-1-tjmercier@google.com>
 <20220502231944.3891435-3-tjmercier@google.com> <20220504122558.GB24172@blackbody.suse.cz>
 <CABdmKX2DJy0i3XAP7xTduZ8KFVKtgto24w714YJNUb_=pfYiKw@mail.gmail.com> <20220505115015.GD10890@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VvFMpzRd3f5HOLZivGIaiJD1ZP3hh+AxpWSTf89n1T0=;
        b=LHAmBR4rXfqs1vhxinJbl8NDwSEWy62HrFVgBmifLXL/yTuw5QPat09BJ4dMwG/1nA
         l5RVXL4eVFyjMEF5Iv1k8eKRoV5VclTCvRe84/b6anAg4r02lTrN5bdFEEhobKNRLth3
         nz986sSoAVJa+QzvEDKqNgydg6qsTqkENspWffK/bIqW5Xs3J8XozPTDh1CcKbhWKwRg
         LWcH9kSyH1gvn2q3yDFesk164XBtY3K+GNoi6iGClpA7ct3dDnH0L57fHaIdNulErE2j
         TVN1C+LkyHh48XJp1C/q7YVoZJkeAVXvVCU6D4W4x7GoBZxqB55ZcGff8i7OHIyMaqzU
         65fg==
In-Reply-To: <20220505115015.GD10890-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, John Stultz <jstultz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Carlos Llamas <cmllamas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, Shuah Khan <skhan-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, May 5, 2022 at 4:50 AM 'Michal Koutn=C3=BD' via kernel-team
<kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org> wrote:
>
> On Wed, May 04, 2022 at 10:19:20AM -0700, "T.J. Mercier" <tjmercier@googl=
e.com> wrote:
> > Should I export these now for this series?
>
> Hehe, _I_ don't know.
> Depends on the likelihood this lands in and is built upon.
>
Ok, I'll leave these unexported for now unless I hear otherwise.

> > No, except maybe the gpucg_bucket name which I can add an accessor
> > function for. Won't this mean depending on LTO for potential inlining
> > of the functions currently implemented in the header?
>
> Yes.  Also depends how much inlining here would be performance relevant.
> I suggested this with an OS vendor hat on, i.e. the less such ABI, the
> simpler.
>
> > I'm happy to make this change, but I wonder why some parts of the
> > kernel take this approach and others do not.
>
> I think there is no convention (see also
> Documentation/process/stable-api-nonsense.rst ;-)).
>
Alright I'll queue this change up for the next rev.

> Regards,
> Michal

Thanks again!

>
> --
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to kernel-team+unsubscribe-z5hGa2qSFaTowKkBSvOlow@public.gmane.org
>
