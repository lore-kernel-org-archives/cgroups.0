From: yong w <yongw.pur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] mm: Add configuration to control whether vmpressure
 notifier is enabled
Date: Sun, 22 Aug 2021 18:06:00 +0800
Message-ID: <CAOH5QeCGunHAnYD=s8vDZ1krnruoCV9kbpEikTcHsxcC+KXoow@mail.gmail.com>
References: <1629417219-74853-1-git-send-email-wang.yong12@zte.com.cn>
 <CALvZod5usW9OEsJSbeGYBnSGVDNLLKqMoGAx-JQrX6s62r-XiA@mail.gmail.com> <CAOH5QeCf6+xiT_Wjtw=BegCYWc2H52qeKVsTh2aha0SG2xyU5w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lDNBGIq+xGdVYw1TUBg1mZGiYyDFgWVG+GX+moPobUw=;
        b=czNcR77rw/X56j3Zar4Kopj/sUheukLLzJQWR+1pmlT99701iQkSSg0UgAVn0Y9+iY
         ylQLwbDLvKww8h65MzXNUl7vU72Njq70cP9MPI5Ebg+3ZWgMOj+7mXct1RhyLdtjvMRK
         AUgCmab2SKk7y+BtB614dhhP0ehHirc9NiSMlqtX4cJyM33u3F6dsCCx+1rX8QYQFLtE
         U/FjAXG/VhwnTeFyjZTq0O1icCvLC6RRAkXfolLTIZovp/bG5NPvE+XEXqskkNg3Jfc6
         EBtNJxdBcGw5oMxCgqkK+Jx4q4Yh3Y6/zNR51GOPYKGhXr9VJf1D+jpUJm9wziX6x9OZ
         faWg==
In-Reply-To: <CAOH5QeCf6+xiT_Wjtw=BegCYWc2H52qeKVsTh2aha0SG2xyU5w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hui Su <sh_def-9Onoh4P/yGk@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, wangyong <wang.yong-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

Hello, I find the code of socket pressure and vmpressure are related.
And there are two ways to be discussed
1. The calculation of socket pressure is handed over to the psi.
2. Vmpresssure and psi update socket pressure respectively, and are
configured separately.

Thanks.

yong w <yongw.pur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =E4=BA=8E2021=E5=B9=B48=E6=9C=8820=E6=97=A5=E5=
=91=A8=E4=BA=94 =E4=B8=8B=E5=8D=8810:29=E5=86=99=E9=81=93=EF=BC=9A
>
> Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> =E4=BA=8E2021=E5=B9=B48=E6=9C=8820=E6=
=97=A5=E5=91=A8=E4=BA=94 =E4=B8=8B=E5=8D=887:42=E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Thu, Aug 19, 2021 at 4:54 PM <yongw.pur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > >
> > > From: wangyong <wang.yong-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> > >
> > > Inspired by PSI features, vmpressure inotifier function should
> > > also be configured to decide whether it is used, because it is an
> > > independent feature which notifies the user of memory pressure.
> > >
> >
> > It is also used by the networking stack to check memory pressure. See
> > mem_cgroup_under_socket_pressure().
>
>  Thanks for your replly, mem_cgroup_under_socket_pressure does use vmpres=
sue,
>  I'll check it.
