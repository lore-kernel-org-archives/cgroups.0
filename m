From: =?UTF-8?B?56a56Iif6ZSu?= <ufo19890607@gmail.com>
Subject: Re: [PATCH] doc: cgroup: correct the wrong information about measure
 of memory pressure
Date: Tue, 19 Feb 2019 18:45:52 +0800
Message-ID: <CAHCio2g-S6snHsh84r0Wp1RQW1CR3t_eyUUjcdDaxnUHWTcdFw@mail.gmail.com>
References: <1550278564-81540-1-git-send-email-yang.shi@linux.alibaba.com> <20190218210504.GT50184@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ffG50zcYRZxWfUGn5WkhVM3jBYqv2vEwRvPWaUtideQ=;
        b=YpoYattijyPWHezIgZMKDwdjebSn69PKDuhJxtXkwpjt/p8HH2X1x+3YGadInP2Dx1
         rGlMK8oPorD/BJVjvzjPYOn/gp6hSvmVGAZ956FJHnKdzavF59LNoVdN9YDgc/JBqRM/
         DMoBFHlW/537VF0CeNabpK9+6W2AJ8K4ziSdeZh7zDDz34Oj9HlH7hYsMJzwv5j8UTKF
         /3gTZkXUKflREJJyEeTWV2M6GWGI/Tu8iuRyL3QeSNPeVcOHvR0lDn28auo4wrHXAkc4
         BFFliD+xepgc6tV+e4S7WKF07D5iNbCZwn3KyN38V83wZKBoOPwgJ6KE42M8l09V7GU2
         d6Pg==
In-Reply-To: <20190218210504.GT50184@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj@kernel.org>
Cc: Yang Shi <yang.shi@linux.alibaba.com>, hannes@cmpxchg.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Hi TeJun
I've built the 5.0.0-rc6 kernel with psi option, but I cannot find any
cgroup.controllers when I mounted cgroup2.

[root@bogon /]# uname -r
[root@bogon /]# 5.0.0-rc6+
[root@bogon /]# mount -t cgroup2 none cgroup2/
[root@bogon /]# cat cgroup2/cgroup.controllers
[root@bogon /]
[root@bogon /]# cat cgroup2/cgroup.subtree_control
[root@bogon /]#

What's wrong with this kernel? Or maybe I lost some mount option?

Thanks
Yuzhoujian

Tejun Heo <tj@kernel.org> =E4=BA=8E2019=E5=B9=B42=E6=9C=8819=E6=97=A5=E5=91=
=A8=E4=BA=8C =E4=B8=8A=E5=8D=8810:32=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sat, Feb 16, 2019 at 08:56:04AM +0800, Yang Shi wrote:
> > Since PSI has implemented some kind of measure of memory pressure, the
> > statement about lack of such measure is not true anymore.
> >
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Jonathan Corbet <corbet@lwn.net>
> > Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
> > ---
> >  Documentation/admin-guide/cgroup-v2.rst | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/ad=
min-guide/cgroup-v2.rst
> > index 7bf3f12..9a92013 100644
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -1310,8 +1310,7 @@ network to a file can use all available memory bu=
t can also operate as
> >  performant with a small amount of memory.  A measure of memory
> >  pressure - how much the workload is being impacted due to lack of
> >  memory - is necessary to determine whether a workload needs more
> > -memory; unfortunately, memory pressure monitoring mechanism isn't
> > -implemented yet.
> > +memory.
>
> Maybe refer to PSI?
>
> Thanks.
>
> --
> tejun
