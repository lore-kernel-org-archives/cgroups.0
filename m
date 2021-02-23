From: Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH 01/20] cgroup: Manual replacement of the deprecated
 strlcpy() with return values
Date: Tue, 23 Feb 2021 18:49:12 +0100
Message-ID: <CABgxDo+W3--A9Gy5jUjbYuPSJMcTz5Wn8A8GWd3v+V9zO9gLYw@mail.gmail.com>
References: <20210222151231.22572-1-romain.perier@gmail.com>
 <20210222151231.22572-2-romain.perier@gmail.com> <YDUpqn+cRWg1ZYYT@blackbook>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="000000000000f0515e05bc048913"
Return-path: <kernel-hardening-return-20815-glkh-kernel-hardening=m.gmane-mx.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <cgroups.vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s4LS5XCNRp5oX+FKr8Qy3XQXn0REfCMITuWxGTNshFM=;
        b=tbVMHFu3xeXOKHe8qLnVi7H1oIGCQBSrauKmdjVAs7E2Pv6LFNeUQPPtqtzm5Dzuyp
         YoJJbXpLa5bJ7s7YFms6Fy/HbHcmaWUXQFBOIuZMk2dWOvalQdmC4B24+mMYktFpUdGj
         vkHYBab5W7b47GOCy0QlIt/Fsl/W+l3b4f9mjrPHd/sUvJdk5H3GCDRfmSlO1Nb+x7Is
         UNQMwUaHe8zjFm0Ix0xNU175N3AOVD1rXMn3i1pWURwa2ZjnQmZ9ZNoq2Q0JeqafU+Yz
         6mK9pQg+tTSpwOZWbHM1GRtvgJsb59rdWtNF+Z31RaiPorhlaQ1dScX7scP/ZiLecm3m
         uK9A==
In-Reply-To: <YDUpqn+cRWg1ZYYT@blackbook>
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

--000000000000f0515e05bc048913
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mar. 23 f=C3=A9vr. 2021 =C3=A0 17:13, Michal Koutn=C3=BD <mkoutny@suse.c=
om> a =C3=A9crit :

> Hello.
>
> On Mon, Feb 22, 2021 at 04:12:12PM +0100, Romain Perier <
> romain.perier@gmail.com> wrote:
> > --- a/kernel/cgroup/cgroup.c
> > +++ b/kernel/cgroup/cgroup.c
> > @@ -2265,7 +2265,7 @@ int task_cgroup_path(struct task_struct *task,
> char *buf, size_t buflen)
> Actually, this function isn't used at all. So I'd instead propose the
> patch below.
>


+1 if it is dead code.

Thanks,
Romain

--000000000000f0515e05bc048913
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">Le=C2=A0mar. 23 f=C3=A9vr. 2021 =C3=A0=C2=
=A017:13, Michal Koutn=C3=BD &lt;<a href=3D"mailto:mkoutny@suse.com">mkoutn=
y@suse.com</a>&gt; a =C3=A9crit=C2=A0:<br></div><div class=3D"gmail_quote">=
<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left:1px solid rgb(204,204,204);padding-left:1ex">Hello.<br>
<br>
On Mon, Feb 22, 2021 at 04:12:12PM +0100, Romain Perier &lt;<a href=3D"mail=
to:romain.perier@gmail.com" target=3D"_blank">romain.perier@gmail.com</a>&g=
t; wrote:<br>
&gt; --- a/kernel/cgroup/cgroup.c<br>
&gt; +++ b/kernel/cgroup/cgroup.c<br>
&gt; @@ -2265,7 +2265,7 @@ int task_cgroup_path(struct task_struct *task, c=
har *buf, size_t buflen)<br>
Actually, this function isn&#39;t used at all. So I&#39;d instead propose t=
he<br>
patch below.<br></blockquote><div><br></div><div><br></div><div>+1 if it is=
 dead code.</div><div><br></div><div>Thanks,<br></div><div>Romain<br></div>=
<div>=C2=A0</div></div></div>

--000000000000f0515e05bc048913--
