From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] mm, memcg: Avoid stale protection values when cgroup
 is above protection
Date: Thu, 30 Apr 2020 09:49:46 +0800
Message-ID: <CALOAHbAzZUwGq3mnEtOcSetvAAm+m=X_KnQ2eS9U0QQVHggWYg@mail.gmail.com>
References: <cover.1588092152.git.chris@chrisdown.name> <d454fca5d6b38b74d8dc35141e8519b02089a698.1588092152.git.chris@chrisdown.name>
 <CALOAHbCotD1-+o_XZPU_4_i8Nn98r5F_5NpGVd=z6UG=rUcCmA@mail.gmail.com>
 <20200430011626.GA2754277@chrisdown.name> <CALOAHbCL_JJgcy9r99Kn81-o_t-fs_nQ+n7aKMHO-02QMCufEw@mail.gmail.com>
 <20200430014603.GB2754277@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y8ASo8zpK+8qPNof8u/cHdMqtlz7+kslUfS8Oj2LKzo=;
        b=YsKFQT3reOM6k0etzlNKatoAoB8eS3oSXg4aogSsGj+BS7hEjdMtOWVXaO77T/HQKw
         hEHrq0ofC8VjwZ/x3c3taB/oV7KRQUk+1oNGjllLZimTrlsev1U6dhu0zYATgrIupuLp
         q0+Pb1D18JWDP/JQ8CNbqKpSNyCWfzylUEcabcyuin1SoTDUBQOEuLVXEL1nTk/jZFS9
         hECoJovbAA/7cRjo02LMY0G2azloJS4+2tS526YUo20DtmTdxQEvDDrFzhMO3rPMVxH4
         xgBf93K/xt09nGnW7hloNRwre4qBtdkX5aRu425sPKLvu0HFOheQBbJp6rxIBG/dv1li
         Tfrw==
In-Reply-To: <20200430014603.GB2754277-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Apr 30, 2020 at 9:46 AM Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org> wrote:
>
> Yafang Shao writes:
> >My concern is why we add these barriers to memcg protection
> >specifically but don't add these barriers to the other memebers like
> >memcg->oom_group which has the same issue ?
> >What is the difference between these members and that members ?
>
> There are certainly more missing cases -- I didn't look at oom_group
> specifically, but it sounds likely if there's not other mitigating factors.
> Most of us have just been busy and haven't had time to comprehensively fix all
> the potential store and load tears.
>
> Tearing is another case of something that would be nice to fix once and for all
> in the memcg code, but isn't causing any significant issues for the timebeing.
> We should certainly aim to avoid introducing any new tearing opportunities,
> though :-)
>
> So the answer is just that improvement is incremental and we've not had the
> time to track down and fix them all. If you find more cases, feel free to send
> out the patches and I'll be happy to take a look.

Thanks for your suggestion.
I'm planning to add these barriers all over the memory cgroup code.

-- 
Thanks
Yafang
