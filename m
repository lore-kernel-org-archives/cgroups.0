From: yong w <yongw.pur@gmail.com>
Subject: Re: [PATCH v1] mm: Add configuration to control whether vmpressure
 notifier is enabled
Date: Sat, 14 Aug 2021 15:47:48 +0800
Message-ID: <CAOH5QeAY2ENs1s8hGuaHr2j9dV4=TaoR08UDOYRKHx+LjDc1DQ@mail.gmail.com>
References: <1628855870-5070-1-git-send-email-wang.yong12@zte.com.cn> <YRZvAojYDsVPT+wr@casper.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8fEyrpDTg47gFd31UzZ0ta6jHJGs7IbNEF5lPQeob9k=;
        b=S5ZVB7A1d2RXw59YAFt0TXWz/Wt5TZ0DWeW0q+UryXgdVVKbqE2RcpAP6EsGasYPfD
         5i8e5LogHj/0gy9QkBERQx0c7EYo761ovSOQLzu94EUaTuQ7BC1SarXd+r6impvMeoYn
         chIdS/jV38XGr2LDPhhEQNyNh7hJsmRF9fwmSTbCq4INUT2bHBFtz7D43xQjVmljVD17
         K62/SK/t7Wrx0LfoE90kYlKSoCYRbJoMXfkQnyEPx78yxHzJgixh/0lsNGkPKH+/LFhJ
         tLKV/2hK31CzFKsNYqiUBT8I7KQ53oMLb+wgPuik1BpzKuYbiuQvYtNFhy9dq8hkpKqi
         0wQw==
In-Reply-To: <YRZvAojYDsVPT+wr@casper.infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Matthew Wilcox <willy@infradead.org>
Cc: tj@kernel.org, corbet@lwn.net, akpm@linux-foundation.org, mhocko@kernel.org, vdavydov.dev@gmail.com, tglx@linutronix.de, peterz@infradead.org, Shakeel Butt <shakeelb@google.com>, guro@fb.com, alexs@kernel.org, richard.weiyang@gmail.com, sh_def@163.com, sfr@canb.auug.org.au, wang.yong12@zte.com.cn, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, yang.yang29@zte.com.cn

Matthew Wilcox <willy@infradead.org> =E4=BA=8E2021=E5=B9=B48=E6=9C=8813=E6=
=97=A5=E5=91=A8=E4=BA=94 =E4=B8=8B=E5=8D=889:09=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Aug 13, 2021 at 04:57:50AM -0700, yongw.pur@gmail.com wrote:
> > @@ -855,7 +856,7 @@ At reading, current status of OOM is shown.
> >            The number of processes belonging to this cgroup killed by a=
ny
> >            kind of OOM killer.
> >
> > -11. Memory Pressure
> > +11. Memory Pressure (CONFIG_MEMCG_VMPRESSURE)
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Did you build the documentation after changing it (eg make htmldocs)?

Thank you for your reply.
Sorry, I didn't  build the documentation after changing it.I will pay
attention next time.

Thanks.
