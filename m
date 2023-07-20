From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/8] memory recharging for offline memcgs
Date: Thu, 20 Jul 2023 14:34:16 -0700
Message-ID: <CAJD7tkYhu3g9u7HkUTFBtT3Q4edVZ2g1TWV1FDcyM9srrYCBLg@mail.gmail.com>
References: <20230720070825.992023-1-yosryahmed@google.com>
 <20230720153515.GA1003248@cmpxchg.org> <ZLmRlTej8Tm82kXG@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689888893; x=1690493693;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8M/vsrDPgbcMRJ+Hz8ExsxXitAhWOIkWtKa6/Y/Z+4I=;
        b=FEFpmVz/KKb7wDCywJRnVOnCvgFqDWvuSDQWT41va4UtaSdnRtPeDDIcVMNGR0e29e
         rJg8Ax3YNYlSISDYQ7jzUG307edzjLS8LL/bfFzWh4KgLjwVvEs3kuIEY2KP94tb1FIa
         TNgD0z2sfZymCarasxwj5xXZiDpn0O8nTxxYnA7xx3Pn+93XaS8GnuC8MLgnxvViKia8
         EyzHAi3axJqTvk9MtT6m05861Akes4vvAFB2hyEmpckWFpyT6wFzCIBDIXKwo93ldJwO
         ZRZDtA7ptbLtMZz3GKphLmh7gcU4+Qe0DoASAzsDNGpCEfFrYbCa8wmCteJ03AHnh/aA
         UvMA==
In-Reply-To: <ZLmRlTej8Tm82kXG-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jul 20, 2023 at 12:57=E2=80=AFPM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Thu, Jul 20, 2023 at 11:35:15AM -0400, Johannes Weiner wrote:
> > It could also be argued that if you don't want to lose control over a
> > set of resources, then maybe don't delete their control domain while
> > they are still alive and in use. For example, when restarting a
> > workload, and the new instance is expected to have largely the same
> > workingset, consider reusing the cgroup instead of making a new one.
>
> Or just create a nesting layer so that there's a cgroup which represents =
the
> persistent resources and a nested cgroup instance inside representing the
> current instance.

In practice it is not easy to know exactly which resources are shared
and used by which cgroups, especially in a large dynamic environment.

>
> Thanks.
>
> --
> tejun
