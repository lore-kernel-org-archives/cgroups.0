From: Weiping Zhang <zwp10758-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 0/3] blkcg: add blk-iotrack
Date: Wed, 25 Mar 2020 20:49:24 +0800
Message-ID: <CAA70yB7a7VjgPLObe-rzfV0dLAumeUVy0Dps+dY5r-Guq2Susg@mail.gmail.com>
References: <cover.1584728740.git.zhangweiping@didiglobal.com> <20200324182725.GG162390@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iz+O4JY70/I6593EiYb3vc9QehOFE8IiCgzzBxiW4a8=;
        b=eKBMcEjgLZnyeEd11yYfakt9CIsppElK+QY7MTSFwKvXZW/YKZ7ZmTS5bsV3G/bC3d
         6/JF2+vOQUDQl5o2zVCDog0GopXRG3lV5vxmUKLSTjuqKceWTb1biDHq9++h+QCjOszV
         OyOdMIHPmW4OAWDXt3LmJ3qe1I8DI3PbkD1L4LucYNKQyJlRVF/K1xiLq8ormRElmWnk
         DaVEtB5gGmmHTDQEdWWDwY4sVf1gSQ2+9X2bSbmaOLVEcFCTazyz+PQlezXPGNPqxsri
         00nFyYipB7MDDMxrstPkCW0VMiE/aLDqivvyhOAFvLuZZxPncSSEzxJC22sWBemBPf8q
         Bumw==
In-Reply-To: <20200324182725.GG162390-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> =E4=BA=8E2020=E5=B9=B43=E6=9C=8825=E6=97=A5=E5=91=
=A8=E4=B8=89 =E4=B8=8A=E5=8D=882:27=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sat, Mar 21, 2020 at 09:20:36AM +0800, Weiping Zhang wrote:
> > The user space tool, which called iotrack, used to collect these basic
> > io statistics and then generate more valuable metrics at cgroup level.
> > From iotrack, you can get a cgroup's percentile for io, bytes,
> > total_time and disk_time of the whole disk. It can easily to evaluate
> > the real weight of the weight based policy(bfq, blk-iocost).
> > There are lots of metrics for read and write generate by iotrack,
> > for more details, please visit: https://github.com/dublio/iotrack.
> >
> > Test result for two fio with randread 4K,
> > test1 cgroup bfq weight =3D 800
> > test2 cgroup bfq weight =3D 100
> >
> > Device      io/s   MB/s    %io    %MB    %tm   %dtm  %d2c %hit0 %hit1 %=
hit2 %hit3 %hit4 %hit5  %hit6  %hit7 cgroup
> > nvme1n1 44588.00 174.17 100.00 100.00 100.00 100.00 38.46  0.25 45.27 9=
5.90 98.33 99.47 99.85  99.92  99.95 /
> > nvme1n1 30206.00 117.99  67.74  67.74  29.44  67.29 87.90  0.35 47.82 9=
9.22 99.98 99.99 99.99 100.00 100.00 /test1
> > nvme1n1 14370.00  56.13  32.23  32.23  70.55  32.69 17.82  0.03 39.89 8=
8.92 94.88 98.37 99.53  99.77  99.85 /test2
>
> Maybe this'd be better done with bpf?
>
Hi Tejun,

How about support both iotrack and bpf?
If it's ok I want to add bpf support in another patchset, I saw that
iocost_monitor.py was base on drgn, maybe write a new script
"biotrack" base on drgn.

For this patchset, iotrack can work well, I'm using it to monitor
block cgroup for
selecting a proper io isolation policy.

Thanks a ton
Weiping
> --
> tejun
