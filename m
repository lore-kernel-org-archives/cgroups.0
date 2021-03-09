From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/9] memcg accounting from OpenVZ
Date: Tue, 9 Mar 2021 13:12:59 -0800
Message-ID: <CALvZod5YOtqXcSqn2Zj2Nb_SKgDRKOMW4o5i-u_yj7CanQVtGQ@mail.gmail.com>
References: <5affff71-e503-9fb9-50cb-f6d48286dd52@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mS9vo6iXv4jFE0RaAV7Z3FQHExEtvgPe4n5aXOd4Ddc=;
        b=Yi+mL8MLTiKYYsa94zraqn379hUW+MeC29zszoENAedRL5SdQ19igl19IemtwyjI31
         3cZVNfhuDWDPtC4lhaBhc9Pi6SFGfECg/5dujXNWZJFV7I4A91ecNzInpD/5qcm0AvwM
         LDl1z2ZjzAY8wwCk5J+RCYMS5chvpsTcRoDzf9ZfbCWS+Ym7Wgrb/3EjtUcoQIBexeBx
         v00yijtoXh7YCVkZ6wOGepP2dMwHap9YJAhPwdE0T+TLKj8vYswLV2oObYEI8J68PJgW
         sRvSlbGH07gMR7YNsT3GfIBJAsLy4foKcAkFhbukb3pnRPyO3nS7J1ZXIkaI/C/R0r+Z
         woHw==
In-Reply-To: <5affff71-e503-9fb9-50cb-f6d48286dd52-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Tue, Mar 9, 2021 at 12:04 AM Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
>
> OpenVZ many years accounted memory of few kernel objects,
> this helps us to prevent host memory abuse from inside memcg-limited container.
>

The text is cryptic but I am assuming you wanted to say that OpenVZ
has remained on a kernel which was still on opt-out kmem accounting
i.e. <4.5. Now OpenVZ wants to move to a newer kernel and thus these
patches are needed, right?
