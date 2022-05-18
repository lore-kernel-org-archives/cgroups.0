From: Stephen Zhang <starzhangzsd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix potential null pointer risk
Date: Wed, 18 May 2022 09:04:12 +0800
Message-ID: <CANubcdX7rvnWPd6BfLsHpchxCtmbg67mARHQbJXgpr6Ezkm1jQ@mail.gmail.com>
References: <20220517073106.1704628-1-zhangshida@kylinos.cn> <YoPWWfoZ+6PrHuJl@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cGbIZ0WjSw2ZJa647FvL8buifxBLVMmodCe2ePJMeJM=;
        b=NorNrwCZP1aJ/u2RVDG9zK0qpsF3l1n2Vx79ANbCZTXP1MuDNkyoGmYJE3J4L2g6JF
         ZD80dJOmGCe2z4I8I7bizk/FHdX0bwcCt+dEcYAFmltKL6f8/rZnktPPuFPHwDFMzCPB
         rDuNjFOeNv9W0gufxxvk0CI7C8P7qfQOwkGBkAYPsXa9FHjHognB0BqIFrZ+GMCTOpLi
         eNjxITHqU9P5GRBwcnCsywD8kPBTu68U83wkRuZ3B/pCwtCgw+gIpZLmPIDvbeK6tVxO
         afFPfkpp2D5HTzX6DbC6wQOuUi++Ma6gAjtloUl3vUjphBPvbXEBC/kVnZ2nS/lmuXG3
         gGQw==
In-Reply-To: <YoPWWfoZ+6PrHuJl-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, zhangshida <zhangshida-UOlijcLmZ/InDS1+zs4M5A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> =E4=BA=8E2022=E5=B9=B45=E6=9C=8818=E6=97=A5=E5=91=
=A8=E4=B8=89 01:07=E5=86=99=E9=81=93=EF=BC=9A
>
> The function is never called for a root cgroup. The parent check up above=
 in
> the same function is superflous. So, maybe remove that?
>
> Thanks.
>
> --
> tejun

Thanks. I will remake a patch based on this.

