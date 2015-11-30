From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: WARNING in handle_mm_fault
Date: Mon, 30 Nov 2015 17:20:00 +0100
Message-ID: <20151130162000.GM17308@twins.programming.kicks-ass.net>
References: <CACT4Y+Zn+mK37-mvqDQTyt1Psp6HT2heT0e937SO24F7V1q7PA@mail.gmail.com>
 <201511260027.CCC26590.SOHFMQLVJOtFOF@I-love.SAKURA.ne.jp>
 <CACT4Y+ZdF09hOnb_bL4GNjytSMMGvNde8=9pdZt6gZQB1sp0hQ@mail.gmail.com>
 <20151125173730.GS27283@dhcp22.suse.cz>
 <CACT4Y+Y0EESD_HhgGE2pWPqfJsDgvSny=ZMfP1ewaSzd6z_bLg@mail.gmail.com>
 <201511262033.EAB48965.FVJOOOMLFHStFQ@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201511262033.EAB48965.FVJOOOMLFHStFQ-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Cc: dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, kcc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On Thu, Nov 26, 2015 at 08:33:05PM +0900, Tetsuo Handa wrote:

> By the way, does use of "unsigned char" than "unsigned" save some bytes?

There are architectures that cannot do independent byte writes. Best
leave it a machine word unless there's a real pressing reason otherwise.
