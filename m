From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/4] kernfs: kvmalloc xattr value instead of kmalloc
Date: Tue, 10 Mar 2020 13:41:57 -0700
Message-ID: <CALvZod6mcoKTqi=OvyHQLbm1LszijDV-traf4Rx9oXmLSZe-Gg@mail.gmail.com>
References: <CALvZod62gypsxCYOpGsR6SWwp7roh8eEEKvZ8WNFtjB0bH=okg@mail.gmail.com>
 <C17G1V88F2XD.EQFO8E8QX1YO@dlxu-fedora-R90QNFJV>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/deQQvgAa+oP9j87xo/rUZaCa5U0Y9db6yvuNAirEL0=;
        b=Ai8FMPZwPDU7dLeUmmQ5IrGiGriK5BF4c8C/goY7nt9A9p0gwe5maK+FI7+io4/LeT
         TH75Po6PkJ8cLhul21gKVq5bWmL9bTskL2/wNLmg/UhfqLGQmIZTlDwwzbG4bhIx/8Wv
         nl67KGQquy1o2acEsx4cOKOda/SY8w9A9rZBy4UxDDi2XSDeodDuMiMmGE448FGGfIHQ
         US1d67PAbkslxP0i5Ev6LK+9hnyhEL4jnDxjpu/dzCkvxOA6VRtuB0PUXr6qtk9lROVD
         NYYE3TiPoonSAGo6CIxmgX00jAcsnM1upezPCYcMpmmNna94s8ehKfcP/zP+lB6K5b1w
         sjHQ==
In-Reply-To: <C17G1V88F2XD.EQFO8E8QX1YO@dlxu-fedora-R90QNFJV>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Tue, Mar 10, 2020 at 1:40 PM Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org> wrote:
>
> Hi Shakeel,
>
> On Tue Mar 10, 2020 at 12:40 PM, Shakeel Butt wrote:
> > Hi Daniel,
> >
> >
> > On Thu, Mar 5, 2020 at 1:16 PM Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org> wrote:
> > >
> > > It's not really necessary to have contiguous physical memory for xattr
> > > values. We no longer need to worry about higher order allocations
> > > failing with kvmalloc, especially because the xattr size limit is at
> > > 64K.
> > >
> > > Signed-off-by: Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>
> >
> >
> > The patch looks fine to me. However the commit message is too cryptic
> > i.e. hard to get the motivation behind the change.
> >
>
> Thanks for taking a look. The real reason I did it was because Tejun
> said so :).
>
> Tejun, is there a larger reason?
>

I understand the reason. I am just suggesting to rephrase it to be more clear.
