From: Weiping Zhang <zwp10758-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 0/3] blkcg: add blk-iotrack
Date: Thu, 26 Mar 2020 00:45:30 +0800
Message-ID: <CAA70yB5yH9H6-gaKfRSTmgd6vvzP4T9N7v-NAD0MsRL+YTexHw@mail.gmail.com>
References: <cover.1584728740.git.zhangweiping@didiglobal.com>
 <20200324182725.GG162390@mtj.duckdns.org> <CAA70yB7a7VjgPLObe-rzfV0dLAumeUVy0Dps+dY5r-Guq2Susg@mail.gmail.com>
 <20200325141236.GJ162390@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eNUeOGNC+DqnOKpMcPE0ACLXrDfm22ZmBEJ3IFoM+oc=;
        b=g8qcCd9PRxGBiwF85aE5iYlhbw2CijtCWSs3nyjSo0GOoqTepNjYsfDZXPDMhOQeB7
         Pp4RfdK6bGPix5F1v5baMp5fI+xO6jSu6PcffkQYuWJtNbElXGTPVve05YJdKYxvI47z
         DOKvQOIOhRlThaHzEHEktHPIraHIixq44zeZ/9vChOxRdxrjOpdBU+1UiLFzx6lAX67q
         nuIuRnMLn56yMmRzlZppxpeTnQKa6XxSpR4CpEVgH57q8cM552yWskXzhCC/3Xcw8zvI
         TYzKOxDodDXtiqmAI+GkajfuuZ60gFeMwQynRWiZAl7gOkg/mtbLYErMMr9Gq1PImP/S
         Pm2A==
In-Reply-To: <20200325141236.GJ162390-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> =E4=BA=8E2020=E5=B9=B43=E6=9C=8825=E6=97=A5=E5=91=
=A8=E4=B8=89 =E4=B8=8B=E5=8D=8810:12=E5=86=99=E9=81=93=EF=BC=9A
>
> On Wed, Mar 25, 2020 at 08:49:24PM +0800, Weiping Zhang wrote:
> > For this patchset, iotrack can work well, I'm using it to monitor
> > block cgroup for
> > selecting a proper io isolation policy.
>
> Yeah, I get that but monitoring needs tend to diverge quite a bit
> depending on the use cases making detailed monitoring often need fair
> bit of flexibility, so I'm a bit skeptical about adding a fixed
> controller for that. I think a better approach may be implementing
> features which can make dynamic monitoring whether that's through bpf,
> drgn or plain tracepoints easier and more efficient.
>
I agree with you, there are lots of io metrics needed in the real
production system.
The more flexible way is export all bio structure members of bio=E2=80=99s =
whole life to
the userspace without re-compiling kernel, like what bpf did.

Now the main block cgroup isolation policy:
 blk-iocost and bfq are weght based, blk-iolatency is latency based.
The blk-iotrack can track the real percentage for IOs,kB,on disk time(d2c),
and total time, it=E2=80=99s a good indicator to the real weight. For blk-i=
olatency, the
blk-iotrack has 8 lantency thresholds to show latency distribution, so if w=
e
change these thresholds around to blk-iolateny.target.latency, we can tune
the target latency to a more proper value.

blk-iotrack extends the basic io.stat. It just export the important
basic io statistics
for cgroup,like what /prof/diskstats for block device. And it=E2=80=99s eas=
y
programming,
iotrack just working like iostat, but focus on cgroup.

blk-iotrack is friendly with these block cgroup isolation policies, a
indicator for
cgroup weight and lantency.

Thanks
