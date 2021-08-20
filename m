From: yong w <yongw.pur@gmail.com>
Subject: Re: [PATCH v2] mm: Add configuration to control whether vmpressure
 notifier is enabled
Date: Fri, 20 Aug 2021 22:29:27 +0800
Message-ID: <CAOH5QeCf6+xiT_Wjtw=BegCYWc2H52qeKVsTh2aha0SG2xyU5w@mail.gmail.com>
References: <1629417219-74853-1-git-send-email-wang.yong12@zte.com.cn> <CALvZod5usW9OEsJSbeGYBnSGVDNLLKqMoGAx-JQrX6s62r-XiA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AcRjO0xn0//tKpsefB7FKZRMM8l5ZYGF15ZbjtpoAwc=;
        b=TWeYTHvGvR0cOQKdJQxLaHbz89VS4iAf2sA0cXbL8lbSvh4YCxheGK/bYtm27yVOGi
         Nsq4u3RPE5xUohWi6naocP38+1gL35O9AT6HU+m42uKyXid6C5KfYrZ2WUFF9Y2ADv+W
         t7sab2777I5dKUOCnKxTR29xng+cMxCCwbx39g6rY6kFYK1KdTDcpEv4ySpcpQNivrAk
         l27JqtARINoSWYUHGbIFKBVlKHhik4aUhYmy/AFgrGBdJuNTYVx14c/UQ5twYn9a5csn
         tPUPCq9QAeowEKVZC2imbRitgY+UTbFYGW/jd5EuT114hP0laTFG3FMiXmCMKK+TgjBM
         MVBg==
In-Reply-To: <CALvZod5usW9OEsJSbeGYBnSGVDNLLKqMoGAx-JQrX6s62r-XiA@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Roman Gushchin <guro@fb.com>, alexs@kernel.org, Wei Yang <richard.weiyang@gmail.com>, Hui Su <sh_def@163.com>, Stephen Rothwell <sfr@canb.auug.org.au>, wang.yong12@zte.com.cn, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, yang.yang29@zte.com.cn, wangyong <wang.yong@zte.com.cn>

Shakeel Butt <shakeelb@google.com> =E4=BA=8E2021=E5=B9=B48=E6=9C=8820=E6=97=
=A5=E5=91=A8=E4=BA=94 =E4=B8=8B=E5=8D=887:42=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, Aug 19, 2021 at 4:54 PM <yongw.pur@gmail.com> wrote:
> >
> > From: wangyong <wang.yong@zte.com.cn>
> >
> > Inspired by PSI features, vmpressure inotifier function should
> > also be configured to decide whether it is used, because it is an
> > independent feature which notifies the user of memory pressure.
> >
>
> It is also used by the networking stack to check memory pressure. See
> mem_cgroup_under_socket_pressure().

 Thanks for your replly, mem_cgroup_under_socket_pressure does use vmpressu=
e,
 I'll check it.
