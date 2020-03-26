From: Weiping Zhang <zwp10758@gmail.com>
Subject: Re: [RFC 0/3] blkcg: add blk-iotrack
Date: Thu, 26 Mar 2020 23:08:45 +0800
Message-ID: <CAA70yB4e65nbV=ZA8OT-SUkq+ZQOGGB9e-3QKJ_PqXjVaXGvFA@mail.gmail.com>
References: <cover.1584728740.git.zhangweiping@didiglobal.com>
 <20200324182725.GG162390@mtj.duckdns.org> <CAA70yB7a7VjgPLObe-rzfV0dLAumeUVy0Dps+dY5r-Guq2Susg@mail.gmail.com>
 <20200325141236.GJ162390@mtj.duckdns.org> <CAA70yB5yH9H6-gaKfRSTmgd6vvzP4T9N7v-NAD0MsRL+YTexHw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=v7owHCnct69sVSGTFZo23hO2nNZX5mJ9i48UAPStm8Q=;
        b=OYo+MZCZD9qQc+5Syq25CWi7ldhbTbqCtzNloZ5rcO6PkSCD4h9+BK1oIRjnxw4xxW
         1PKxXUTHHz3GlbqjT9vEB+xcjOzLx0Cx9r9dApziEa/dGEdBFKZXNx24EgGUbxJl0eV+
         daYOEUS6fFGCtmHze90408IEMKwi1K2blW8GZQTvAEKf3AZSZTVhSGklWL75NbSOc2MD
         EEjNsVcdShFaCMM+iNcD3LOlu0Qhqi2rEelVgo9rqE8W1Gn/cDURL/TeOEeAQrZnAGl6
         E+16v8g33VmlG99IPSlz8ORp8DveELwjJEFo+VO/g2XhQrnKd77rtxpRxq0idStIzK/H
         MEhA==
In-Reply-To: <CAA70yB5yH9H6-gaKfRSTmgd6vvzP4T9N7v-NAD0MsRL+YTexHw@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, cgroups@vger.kernel.org

Weiping Zhang <zwp10758@gmail.com> =E4=BA=8E2020=E5=B9=B43=E6=9C=8826=E6=97=
=A5=E5=91=A8=E5=9B=9B =E4=B8=8A=E5=8D=8812:45=E5=86=99=E9=81=93=EF=BC=9A
>
> Tejun Heo <tj@kernel.org> =E4=BA=8E2020=E5=B9=B43=E6=9C=8825=E6=97=A5=E5=
=91=A8=E4=B8=89 =E4=B8=8B=E5=8D=8810:12=E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Wed, Mar 25, 2020 at 08:49:24PM +0800, Weiping Zhang wrote:
> > > For this patchset, iotrack can work well, I'm using it to monitor
> > > block cgroup for
> > > selecting a proper io isolation policy.
> >
> > Yeah, I get that but monitoring needs tend to diverge quite a bit
> > depending on the use cases making detailed monitoring often need fair
> > bit of flexibility, so I'm a bit skeptical about adding a fixed
> > controller for that. I think a better approach may be implementing
> > features which can make dynamic monitoring whether that's through bpf,
> > drgn or plain tracepoints easier and more efficient.
> >
> I agree with you, there are lots of io metrics needed in the real
> production system.
> The more flexible way is export all bio structure members of bio=E2=80=99=
s whole life to
> the userspace without re-compiling kernel, like what bpf did.
>
> Now the main block cgroup isolation policy:
>  blk-iocost and bfq are weght based, blk-iolatency is latency based.
> The blk-iotrack can track the real percentage for IOs,kB,on disk time(d2c=
),
> and total time, it=E2=80=99s a good indicator to the real weight. For blk=
-iolatency, the
> blk-iotrack has 8 lantency thresholds to show latency distribution, so if=
 we
> change these thresholds around to blk-iolateny.target.latency, we can tun=
e
> the target latency to a more proper value.
>
> blk-iotrack extends the basic io.stat. It just export the important
> basic io statistics
> for cgroup,like what /prof/diskstats for block device. And it=E2=80=99s e=
asy
> programming,
> iotrack just working like iostat, but focus on cgroup.
>
> blk-iotrack is friendly with these block cgroup isolation policies, a
> indicator for
> cgroup weight and lantency.
>

Hi Tejun,

I do a testing at cgroup v2 and monitoring them by iotrack,
then I compare the fio's output and iotrack's, they can match well.

cgroup weight test:
/sys/fs/cgroup/test1
/sys/fs/cgroup/test2
test1.weight : test2.weight =3D 8 : 1

Now I just run randread-4K fio test by these three policy:
iocost, bfq, and nvme-wrr
For blk-iocost I run "iocost_coef_gen.py" and set result to the "io.cost.mo=
del".
259:0 ctrl=3Duser model=3Dlinear rbps=3D3286476297 rseqiops=3D547837
rrandiops=3D793881 wbps=3D2001272356 wseqiops=3D482243 wrandiops=3D483037

But iocost_test1 cannot get 8/(8+1) iops,  and the total disk iops
is 737559 < 79388, even I change rrandiops=3D637000.

test case     bw         iops       rd_avg_lat  rd_p99_lat
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
iocost_test1  1550478    387619     659.76      1662.00
iocost_test2  1399761    349940     730.83      1712.00
wrr_test1     2618185    654546     390.59      1187.00
wrr_test2     362613     90653      2822.62     4358.00
bfq_test1     714127     178531     1432.43     489.00
bfq_test2     178821     44705      5721.76     552.00


The detail test report can be found at:
https://github.com/dublio/iotrack/wiki/cgroup-io-weight-test


> Thanks
