From: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
Date: Mon, 1 Feb 2021 11:47:38 -0500
Message-ID: <CAOWid-d5Z-xnn_MhMNoMs3HdW7n8e6Uw5YAGH7NNu7LX0Af_0A@mail.gmail.com>
References: <20201007152355.2446741-1-Kenny.Ho@amd.com>
 <CAOWid-d=a1Q3R92s7GrzxWhXx7_dc8NQvQg7i7RYTVv3+jHxkQ@mail.gmail.com>
 <20201103053244.khibmr66p7lhv7ge@ast-mbp.dhcp.thefacebook.com>
 <CAOWid-eQSPru0nm8+Xo3r6C0pJGq+5r8mzM8BL2dgNn2c9mt2Q@mail.gmail.com>
 <CAADnVQKuoZDB-Xga5STHdGSxvSP=B6jQ40kLdpL1u+J98bv65A@mail.gmail.com>
 <CAOWid-czZphRz6Y-H3OcObKCH=bLLC3=bOZaSB-6YBE56+Qzrg@mail.gmail.com>
 <20201103210418.q7hddyl7rvdplike@ast-mbp.dhcp.thefacebook.com>
 <CAOWid-djQ_NRfCbOTnZQ-A8Pr7jMP7KuZEJDSsvzWkdw7qc=yA@mail.gmail.com>
 <20201103232805.6uq4zg3gdvw2iiki@ast-mbp.dhcp.thefacebook.com>
 <YBgU9Vu0BGV8kCxD@phenom.ffwll.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1691413484=="
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=yIZiOJ02BYreIZzEaXfykuQ92i8lgVKM8HuqwHuBPWc=;
 b=qgZJnkcssMWM+89wIgyQw+SQ4SVW47u/G/Dc2hHiebYRA1VAndqCaGhfST0cohXPDj
 5z0ks432uKnR4bkAmOREXcHJ/TDOrB3N1WynzryP+HfANmi2jxQNnNVRiePRQbHnirUx
 rTepZWehTgMZ73kP1TT2hCJAhTSSf9blZIeVSRRZb78vScyCtkyUFoCJQ9WONlbTEy6t
 2fd9okCvRpH5tTrbm+WuP9PcrOOcPEadQRJhspoeXA+8bjgLZrH/H3R9ANIu0xiofxIj
 xOoRAxLnzOKZ8y49ocUK/9MCBsi3nbuxMnWFXHRjjUd6DVHKtxAbakzFoqiZn/tRVqEA
 V49g==
In-Reply-To: <YBgU9Vu0BGV8kCxD-dv86pmgwkMBes7Z6vYuT8azUEOm+Xw19@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Cc: Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Andrii Nakryiko <andriin-b10kYP2dOMg@public.gmane.org>, DRI Development <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Network Development <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KP Singh <kpsingh-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>

--===============1691413484==
Content-Type: multipart/alternative; boundary="0000000000003a990405ba491d13"

--0000000000003a990405ba491d13
Content-Type: text/plain; charset="UTF-8"

On Mon, Feb 1, 2021 at 9:49 AM Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org> wrote:

>
> - there's been a pile of cgroups proposal to manage gpus at the drm
>   subsystem level, some by Kenny, and frankly this at least looks a bit
>   like a quick hack to sidestep the consensus process for that.
>
No Daniel, this is quick *draft* to get a conversation going.  Bpf was
actually a path suggested by Tejun back in 2018 so I think you are
mischaracterizing this quite a bit.

"2018-11-20 Kenny Ho:
To put the questions in more concrete terms, let say a user wants to
 expose certain part of a gpu to a particular cgroup similar to the
 way selective cpu cores are exposed to a cgroup via cpuset, how
 should we go about enabling such functionality?

2018-11-20 Tejun Heo:
Do what the intel driver or bpf is doing?  It's not difficult to hook
into cgroup for identification purposes."

Kenny

--0000000000003a990405ba491d13
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><div class=3D"gmail_quote"><div=
 dir=3D"ltr" class=3D"gmail_attr">On Mon, Feb 1, 2021 at 9:49 AM Daniel Vet=
ter &lt;<a href=3D"mailto:daniel-/w4YWyX8dFk@public.gmane.org">daniel-/w4YWyX8dFk@public.gmane.org</a>&gt; wrote:<b=
r></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex=
;border-left:1px solid rgb(204,204,204);padding-left:1ex"><br>
- there&#39;s been a pile of cgroups proposal to manage gpus at the drm<br>
=C2=A0 subsystem level, some by Kenny, and frankly this at least looks a bi=
t<br>
=C2=A0 like a quick hack to sidestep the consensus process for that.<br></b=
lockquote><div>No Daniel, this is quick *draft* to get a conversation going=
.=C2=A0 Bpf was actually a path suggested by Tejun back in 2018 so I think =
you are mischaracterizing this quite a bit.<br><br></div><div>&quot;2018-11=
-20 Kenny Ho:<br><span class=3D"gmail-im">To put the questions in more conc=
rete terms, let say a user wants to<br>=C2=A0expose certain part of a gpu t=
o a particular cgroup similar to the<br>=C2=A0way selective cpu cores are e=
xposed to a cgroup via cpuset, how<br>=C2=A0should we go about enabling suc=
h functionality?<br>
<br>2018-11-20 Tejun Heo:<br></span>
Do what the intel driver or <span class=3D"gmail-il">bpf</span> is doing?=
=C2=A0 It&#39;s not difficult to hook<br>
into cgroup for identification purposes.&quot;</div></div><div class=3D"gma=
il_quote"><br></div><div class=3D"gmail_quote">Kenny<br></div></div>

--0000000000003a990405ba491d13--

--===============1691413484==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
amd-gfx mailing list
amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
https://lists.freedesktop.org/mailman/listinfo/amd-gfx

--===============1691413484==--
