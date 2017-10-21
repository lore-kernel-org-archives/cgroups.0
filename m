From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: reorder flexible array members of struct
 cgroup_root
Date: Sat, 21 Oct 2017 09:03:08 -0700
Message-ID: <20171021160308.GN1302522@devbig577.frc2.facebook.com>
References: <20171017063322.11455-1-nick.desaulniers@gmail.com>
 <20171018133010.GD1302522@devbig577.frc2.facebook.com>
 <CAH7mPvjksNSDo4o=z51YkH4yX+gDnGXU-g59gTkOUS-pEva8sA@mail.gmail.com>
 <20171021153253.GG1302522@devbig577.frc2.facebook.com>
 <85d7f6eb-7869-551d-01b1-fa1712f4bd40@suse.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uSltkP2MEwX4jNFGuTw2Gpksbs3LkCGyb/oXEljXeZQ=;
        b=Na/r28gGnEYhDh0DI8aND8GF4hrJlzcydIk+VaxJuHqgsbmzhxfvJx1SUzJToQZjrt
         sxRt7fpC6cEv0SY8ea8OBOkVoXItoIxwtNr9iz45dwqRgYZNPsgXRt4sMslmXg7ViTkG
         jEL7nJvfLhusabE5SH477o9cU55v/v/ytjpME1WjKLYW09j/+au5ctL8rHyba2yDPtZT
         PhZUkbXbFbzgloDd7rBv0Rx5EFis/j9clW0UuhPcRzU41Fh6G7hEdg9RxNny6i/0xYX0
         bOAJdcCpYyN6LmSpQXQJqbEv1RhgFtPyQLXymo5KFcvmMdfQlz3UYOziwv9DYV2F0qAQ
         gEfw==
Content-Disposition: inline
In-Reply-To: <85d7f6eb-7869-551d-01b1-fa1712f4bd40-l3A5Bk7waGM@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Cc: Nick Desaulniers <nick.desaulniers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthias Kaehlcke <mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michael Davidson <md-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, android-llvm-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Sun, Oct 22, 2017 at 02:59:33AM +1100, Aleksa Sarai wrote:
> >Here, not necessarily but I don't want to move it for a bogus reason.
> >Why would we disallow embedding structs with flexible members in the
> >middle when it can be done and is useful?  If we want to discuss
> >whether we want to avoid such usages in the kernel (but why?), sure,
> >let's have that discussion but we can't decide that on "clang warns on
> >it by default".
> 
> There was a talk a few years ago by the clang folks[1] saying that
> while trying to build a kernel with clang, they discovered that
> several places in the kernel uses "VLAIS" (variable Length Arrays In
> Structs") and argued that this is a violation of the C
> specification, despite it being a GNU extension. They also submitted
> several patches that removed this code (even working around a
> user-space visible usage of VLAIS).

The kernel is explicitly using GNU extended version of C and has
always from the beginning, so not-std-c isn't a valid argument.

Thanks.

-- 
tejun
