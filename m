From: Nick Desaulniers <nick.desaulniers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cgroup: reorder flexible array members of struct cgroup_root
Date: Mon, 16 Oct 2017 23:45:53 -0700
Message-ID: <CAH7mPvhxfuBtCKkH1Zt_Np6Qs1oWFCUqau4fcAL662HrprgdWw@mail.gmail.com>
References: <20171017063322.11455-1-nick.desaulniers@gmail.com> <20171017064051.tudsi33f4spuyi25@lostoracle.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=bDtkpqv1Rqloy7DRLHCACNUvvqwXWb6nYmdx+g3uRPU=;
        b=abwJkjXIDglrmJcI0XYN5YJMDLmpOKkDcCPekZtoFCKODS6pyBHki22qTYqrdU07iF
         YUB32fSH8Mglp6BxAwK04YTGt7EgOcLlwXKc377rWTaRhgw9d7DRqtpL5TarmRpGPBU8
         u5vEIH6hRTS7hsio5ZdyOs01Ko0GhaN+ScGZXm5rCMpcxeFALhXiGuvI/yNKjMX7klgu
         RW7XWZ9ZKjCBnjCa6ReeMUhNTQ2g6ovNzDrODDS/LaMjA6bgqRtKQgT1PvQw3VjVzbgx
         J6YkBkaccvN5RSd4IyN9OCgMeAyqlOFGk15/B77t2EqPpsydPsAHFYkvvAQCrhVdtqT2
         jUIA==
In-Reply-To: <20171017064051.tudsi33f4spuyi25-i8pvpzbnxTwmroCTmvX//g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Oct 16, 2017 at 11:40 PM, Nick Desaulniers
<nick.desaulniers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Mon, Oct 16, 2017 at 11:33:21PM -0700, Nick Desaulniers wrote:
>> When compiling arch/x86/boot/compressed/eboot.c with HOSTCC=clang, the
>
> Actually, not sure this is because HOSTCC was specifically clang, I
> think that could be reworded to `When compiling ... with Clang, the
> ...`.

arch/x86/boot/compressed/Makefile:28 indeed overwrites KBUILD_CFLAGS,
so wording should be changed to as-suggested in my previous post,
since that means it's CC=clang, not HOSTCC=clang as the source of the
warning.
