From: Weiping Zhang <zwp10758@gmail.com>
Subject: Re: [RFC 0/3] blkcg: add blk-iotrack
Date: Fri, 27 Mar 2020 00:27:11 +0800
Message-ID: <CAA70yB66fBdAOnv+8rXauwbuPu+UY+gr9ZKeSsQNgq+ZHhJn3Q@mail.gmail.com>
References: <cover.1584728740.git.zhangweiping@didiglobal.com>
 <20200324182725.GG162390@mtj.duckdns.org> <CAA70yB7a7VjgPLObe-rzfV0dLAumeUVy0Dps+dY5r-Guq2Susg@mail.gmail.com>
 <20200325141236.GJ162390@mtj.duckdns.org> <CAA70yB5yH9H6-gaKfRSTmgd6vvzP4T9N7v-NAD0MsRL+YTexHw@mail.gmail.com>
 <CAA70yB4e65nbV=ZA8OT-SUkq+ZQOGGB9e-3QKJ_PqXjVaXGvFA@mail.gmail.com> <20200326161328.GN162390@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YvH8nAkRIhWjmEV+9kX4eoO50WVDe3LtRQC8pQNa05A=;
        b=uXKE2b7wkmnzI5GmZPrvAYbzQk2P/+sAOvmPrBZOw01lpLMbSeUUvFG8iT08TejXTm
         gVXNXk8ONo3VzqGk/RUq2FhPVbRS/WwuC3oH8al9lQEZPxR90XFMVcK+qjwpj41NXL3t
         A81Nej2jZkdxVL4fTPmJ9dXzTUjzPx2NXsAIlJ5FviAVgZ3ErTGm94NgWQxfTmuwVYaW
         N63LyOTACRCginyM8Uqlv4OS9bTm/aFqgPMb9NoKEhoWPszciYQxgIJpvUMS82bL9qAP
         ifCyacieEbveW/htPDeOtpva+IQKQN0Fpyqj+XqsMSeMR4btAaAoMo9yAMDXLwCFQKFr
         mi/Q==
In-Reply-To: <20200326161328.GN162390@mtj.duckdns.org>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, cgroups@vger.kernel.org

Tejun Heo <tj@kernel.org> =E4=BA=8E2020=E5=B9=B43=E6=9C=8827=E6=97=A5=E5=91=
=A8=E4=BA=94 =E4=B8=8A=E5=8D=8812:15=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, Mar 26, 2020 at 11:08:45PM +0800, Weiping Zhang wrote:
> > But iocost_test1 cannot get 8/(8+1) iops,  and the total disk iops
> > is 737559 < 79388, even I change rrandiops=3D637000.
>
> iocost needs QoS targets set especially for deep queue devcies. W/o QoS t=
argets,
> it only throttles when QD is saturated, which might not happen at all dep=
ending
> on fio job params.
>
> Can you try with sth like the following in io.cost.qos?
>
>   259:0 enable=3D1 ctrl=3Duser rpct=3D95.00 rlat=3D5000 wpct=3D50.00 wlat=
=3D10000
>
> In case you see significant bw loss, step up the r/wlat params.
>
OK, I'll try it.

I really appreciate that if you help review blk-iotrack.c, or just
drop io.iotrakc.stat
and append these  statistics to the io.stat? I think these metrics is usefu=
ll,
and it just extend io.stat output.

Thanks a ton
