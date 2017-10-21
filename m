From: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] cgroup: reorder flexible array members of struct
 cgroup_root
Date: Sun, 22 Oct 2017 02:59:33 +1100
Message-ID: <85d7f6eb-7869-551d-01b1-fa1712f4bd40@suse.de>
References: <20171017063322.11455-1-nick.desaulniers@gmail.com>
 <20171018133010.GD1302522@devbig577.frc2.facebook.com>
 <CAH7mPvjksNSDo4o=z51YkH4yX+gDnGXU-g59gTkOUS-pEva8sA@mail.gmail.com>
 <20171021153253.GG1302522@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171021153253.GG1302522-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nick Desaulniers <nick.desaulniers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthias Kaehlcke <mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michael Davidson <md-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, android-llvm-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

> Here, not necessarily but I don't want to move it for a bogus reason.
> Why would we disallow embedding structs with flexible members in the
> middle when it can be done and is useful?  If we want to discuss
> whether we want to avoid such usages in the kernel (but why?), sure,
> let's have that discussion but we can't decide that on "clang warns on
> it by default".

There was a talk a few years ago by the clang folks[1] saying that while 
trying to build a kernel with clang, they discovered that several places 
in the kernel uses "VLAIS" (variable Length Arrays In Structs") and 
argued that this is a violation of the C specification, despite it being 
a GNU extension. They also submitted several patches that removed this 
code (even working around a user-space visible usage of VLAIS).

[1]: 
https://www.linuxplumbersconf.org/2013/ocw/system/presentations/1221/original/VLAIS.pdf

-- 
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
https://www.cyphar.com/
