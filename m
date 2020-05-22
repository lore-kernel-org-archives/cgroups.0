From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 2/2] mm, memcg: Decouple e{low,min} state mutations
 from protection checks
Date: Sat, 23 May 2020 00:27:24 +0800
Message-ID: <CALOAHbArZ3NsuR3mCnx_kbSF8ktpjhUF2kaaTa7Mb7ocJajsQg@mail.gmail.com>
References: <20200505084127.12923-1-laoar.shao@gmail.com> <20200505084127.12923-3-laoar.shao@gmail.com>
 <CA+G9fYseWc_7yq0M5Onju_HxbFid6DbuuaEFf-KUpqfxdF-QTg@mail.gmail.com>
 <CALOAHbBTt1pMo0kwheWqPfU7RTXcDHWJ-x8=5mpw327uiy2qzA@mail.gmail.com>
 <CA+G9fYtmpjunUetTmf2yquB1rwZA+nnWOiueWbAMx483c0wUvQ@mail.gmail.com>
 <CALOAHbCdXrU1AeLd4pWubutuG6HP4xKvxRkXeOv=sd_MMW58rg@mail.gmail.com>
 <20200522160626.GB1112005@chrisdown.name> <20200522160709.GC1112005@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TysnkmOIkLeX9KxlHLPL4xK1JYCC9XQVpNTteD8sJWI=;
        b=lfm2XyuLMBYBEMicKkNUBvKtTqemJXPbmFBeN/eDLNIxq1Id68/49Ne+gIoDwSCuxt
         PeZotFigJ3ZPSD9p6jTGhATFunfQ9qsPYh76th8MHBQeNDElh3K4ig7cWIiYTF1beD9I
         ZhK/eAXZzgrN6Zfj6BDIp8VMQbVyI5viIJjrVpBW/BnSbFVqqUN0n3+xKKdukU2d4JTt
         ocbVEWftg/opspRtHbRTG3DtRVxzVSXWHlF/bgAKDT0g/A+frfgtgjGZZy2+xfX+Hu+f
         3xn7ErM5jt3GoVN0OtIsP+1x1V9o3ktTP2HTuxHEsbtjlbdMByZrDzBW/vFnZKr6Qwz8
         CEfg==
In-Reply-To: <20200522160709.GC1112005-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Naresh Kamboju <naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkft-triage-cunTk1MwBs8s++Sfvej+rw@public.gmane.org

On Sat, May 23, 2020 at 12:07 AM Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org> wrote:
>
> Chris Down writes:
> >Yafang Shao writes:
> >>I will do it.
> >>If no one has objection to my proposal, I will send it tomorrow.
> >
> >If the fixup patch works, just send that. Otherwise, sure.
>
> Oh, I see the other reply from Naresh now saying it didn't help.
>
> Sure, feel free to do that for now then while we work out what the real problem
> is.

Regarding the root cause, my guess is it makes a similar mistake that
I tried to fix in the previous patch that the direct reclaimer read a
stale protection value.  But I don't think it is worth to add another
fix. The best way is to revert this commit.

-- 
Thanks
Yafang
