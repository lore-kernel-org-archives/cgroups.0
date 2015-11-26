From: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Subject: Re: WARNING in handle_mm_fault
Date: Thu, 26 Nov 2015 20:33:05 +0900
Message-ID: <201511262033.EAB48965.FVJOOOMLFHStFQ@I-love.SAKURA.ne.jp>
References: <CACT4Y+Zn+mK37-mvqDQTyt1Psp6HT2heT0e937SO24F7V1q7PA@mail.gmail.com>
	<201511260027.CCC26590.SOHFMQLVJOtFOF@I-love.SAKURA.ne.jp>
	<CACT4Y+ZdF09hOnb_bL4GNjytSMMGvNde8=9pdZt6gZQB1sp0hQ@mail.gmail.com>
	<20151125173730.GS27283@dhcp22.suse.cz>
	<CACT4Y+Y0EESD_HhgGE2pWPqfJsDgvSny=ZMfP1ewaSzd6z_bLg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACT4Y+Y0EESD_HhgGE2pWPqfJsDgvSny=ZMfP1ewaSzd6z_bLg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, kcc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org

Dmitry Vyukov wrote:
> On Wed, Nov 25, 2015 at 6:37 PM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > On Wed 25-11-15 18:21:02, Dmitry Vyukov wrote:
> > [...]
> >> I have some progress.
> >
> > Please have a look at Peter's patch posted in the original email thread
> > http://lkml.kernel.org/r/20151125150207.GM11639-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org
> 
> Yes, I've posted there as well. That patch should help.
> 
OK. This bug seems to exist since commit ca94c442535a "sched: Introduce
SCHED_RESET_ON_FORK scheduling policy flag". Should

  Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>  [2.6.32+]

line be added?

By the way, does use of "unsigned char" than "unsigned" save some bytes?
Simply trying not to change the size of "struct task_struct"...
According to C99, only "unsigned int", "signed int" and "_Bool" are
allowed. But many compilers accept other types such as "unsigned char",
given that we watch out for compiler bugs.
