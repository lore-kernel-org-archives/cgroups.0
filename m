From: yong w <yongw.pur@gmail.com>
Subject: Re: [PATCH v2] mm: Add configuration to control whether vmpressure
 notifier is enabled
Date: Sat, 4 Sep 2021 18:41:00 +0800
Message-ID: <CAOH5QeBrxpddmTL40ryajjCJZ4WHJsaubYKBvaeikikn1JmJ9Q@mail.gmail.com>
References: <1629417219-74853-1-git-send-email-wang.yong12@zte.com.cn>
 <YR+Rc9HC6OqlEq4I@dhcp22.suse.cz> <CAOH5QeCfwF0hX3XpoThEtwnddtOFEU9Jtp0Hoj+Q37D4Q6HC0Q@mail.gmail.com>
 <YR/NRJEhPKRQ1r22@dhcp22.suse.cz> <CAOH5QeDUUqrMnuws6cnBDU_oub4cK6KsHeX39p7Eikr4Bcjcnw@mail.gmail.com>
 <YSzh31BasoxUQXAu@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7+4MmuaT7rzL8mD6S0mX3jwc0NJwjLstDiX92Mhzqd4=;
        b=PmmreLIE6KPwSpV+eJRLKMgW3Z30UIoOJXn2XWGN5zOeZCiFFCbe72Se9ehgrpy4QD
         NSUwp6ElCXnxyH3HMiP/c7mvFVBX0VxpM+vAZ6tzeeNkIYoa9IZZ/6Oa9bkdQcsx16zA
         c3mq2QFsv+7/sMkbzVjO4BjRpMFFTTbjpdXp2iHK5z628+Mtl8+rVvWvWcoEE/qcJLz7
         3k424wbk3KYmigidxMfjdlkW1VCzH1CQmEiX3kY44zePy+dMwzYrLWU2Lcly/QHNUfvN
         OayFV6GeBgs9vriO3vIkYddgKANYIoBqD9OawdPifLI/DOQHSp7UbVhE81giyoFbYeJg
         0NEg==
In-Reply-To: <YSzh31BasoxUQXAu@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <guro@fb.com>, alexs@kernel.org, Wei Yang <richard.weiyang@gmail.com>, Hui Su <sh_def@163.com>, Stephen Rothwell <sfr@canb.auug.org.au>, wang.yong12@zte.com.cn, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, yang.yang29@zte.com.cn

Michal Hocko <mhocko@suse.com> =E4=BA=8E2021=E5=B9=B48=E6=9C=8830=E6=97=A5=
=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=889:49=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sun 22-08-21 17:46:08, yong w wrote:
> > > All those reasons should be a part of the changelog.
> > >....
> > > I am not sure these are sufficient justifications but that is somethi=
ng
> > > to discuss. And hence it should be a part of the changelog.
> > >
> > OK, These reasons will be added to the patch notesin later versions.
> >
> > > > 3. In the case where the user does not need vmpressure,  vmpressure
> > > > calculation is additional overhead.
> > >
> > > You should quantify that and argue why that overhead cannot be furthe=
r
> > > reduced without config/boot time knobs.
> > >
> > The test results of the previously used PFT tool may not be obvious.
> > Is there a better way to quantify it?
>
> This is a question for you to answer I am afraid. You want to add a
> configuration option and (as explained) that is not free of cost from
> the maintenance POV. There must a very good reason to do that.
Sorry for the late reply.The previous email mentions some reasons.
and several tools were used to test, but the data did not meet the expectat=
ions.
I'll try other test methods later.

> > > > In some special scenes with tight memory, vmpressure will be execut=
ed
> > > > frequently.we use "likely" and "inline"
> > > > to improve the performance of the kernel, why not reduce some
> > > > unnecessary calculations?
> > >
> > > I am all for improving the code. Is it possible to do it by other mea=
ns?
> > > E.g. reduce a potential overhead when there no events registered?
> > Yes, the method you mentioned may be feasible, but it does not conflict
> > with this patch.
>
> It is not in conflict but runtime overhead reduction without more burden
> on the configurability is usually a preferred approach.
I agree with you.I had an idea that we use global variables to identify whe=
ther
there is event registration,however, global variables need to be
protected with locks.
I feel that there is little room for optimization in the code.

Thanks.
