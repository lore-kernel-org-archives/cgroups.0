From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v4.4-rc7] sched: isolate task_struct bitfields according
 to synchronization domains
Date: Wed, 30 Dec 2015 12:10:12 -0800
Message-ID: <CA+55aFx0WxoUPrOPaq3HxM+YUQQ0DPV-c3f8kE1ec7agERb_Lg@mail.gmail.com>
References: <20150913185940.GA25369@htj.duckdns.org>
	<55FEC685.5010404@oracle.com>
	<20150921200141.GH13263@mtj.duckdns.org>
	<20151125144354.GB17308@twins.programming.kicks-ass.net>
	<20151125150207.GM11639@twins.programming.kicks-ass.net>
	<CAPAsAGwa9-7UBUnhysfek3kyWKMgaUJRwtDPEqas1rKwkeTtoA@mail.gmail.com>
	<20151125174449.GD17308@twins.programming.kicks-ass.net>
	<20151211162554.GS30240@mtj.duckdns.org>
	<20151215192245.GK6357@twins.programming.kicks-ass.net>
	<20151230092337.GD3873@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=sb/zNJJJ6oUXEcPZW5fwpuK62EYJv3DFo/f7oezpm0I=;
        b=lNK/L5s8yRkp5GrLkDcE0yYulyx3QsIvRkd2eBeyFGbOhAsGSpRYtvhlASTyCBPQRG
         iV+Odx9LpB9txaOjliCmUOGJMAAD76Dxf6lYbK/k6M+mK3ie2X+HGbF/p4r0buAsCTml
         EZIsJJxmiJ59PW262AAdZN0Iy+WyRVO2fpQH6jWsmbHhUyz8KJG+VKe4CucI67WRTx8T
         zyBt4Bbr04OdrtslNPnTEeGKIcn7bz49tQm4un1OIsnc7UXXAxo0rZubaCEKhQcjl1oW
         Vuj1I5j9TX2IBf3rjzXDMfNV1EG2rmzmFgm0K0khGezxik9K0kh5LBO3FApkLL4RFcJN
         yyJQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=sb/zNJJJ6oUXEcPZW5fwpuK62EYJv3DFo/f7oezpm0I=;
        b=h9v65AWTQtV3LyeqH1oh1VOpnldROXhwg3hNS/bxYJ0gOmweJC0TrRZIc8q9+yFzH0
         OFuZhh8iuIkApoFQ2l9xPlDMITygOq5jd7qZXjg5Lp4DTQfzjjcV3ljzs9f3llQPRpLP
         0ZUO5NUdG2IPBuXt+MOi1PT37QduxrTJbNAag=
In-Reply-To: <20151230092337.GD3873-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Wed, Dec 30, 2015 at 1:23 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Peter, I took the patch and changed the bitfields to ulong.

I wouldn't expect the unsigned long part to matter, except for the
forced split with

   unsigned long :0;

itself.

Also, quite frankly, since this is basically very close to other
fields that are *not* unsigned longs, I'd really prefer to not
unnecessarily use a 64-bit field for three bits each.

So why not just do it with plain unsigned "int", and then maybe just
intersperse them with the other int-sized fields in that neighborhood.

I'm also wondering if we shouldn't just put the scheduler bits in the
"atomic_flags" thing instead?

                     Linus
