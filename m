From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg: flatten task_struct->memcg_oom
Date: Fri, 11 Dec 2015 11:25:54 -0500
Message-ID: <20151211162554.GS30240@mtj.duckdns.org>
References: <20150913185940.GA25369@htj.duckdns.org>
 <55FEC685.5010404@oracle.com>
 <20150921200141.GH13263@mtj.duckdns.org>
 <20151125144354.GB17308@twins.programming.kicks-ass.net>
 <20151125150207.GM11639@twins.programming.kicks-ass.net>
 <CAPAsAGwa9-7UBUnhysfek3kyWKMgaUJRwtDPEqas1rKwkeTtoA@mail.gmail.com>
 <20151125174449.GD17308@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=+FrgZ+xLQ5grmgrhjglU5ThMTljyRDdOebv8g9p1Ex0=;
        b=a6+mvkgy6U4ntmKFH5HkFa8iMepqFz+DBNS7hKdimE01E5HjrRw31iqP1M10cLDOCy
         3spyI4JjIwXQvWKhnB4xcheX+PZnwe6hgZe9HyCUb0tTZ9lbR/mL7z+9xC7b950ZW7g4
         fK/R1GmRs3+s+5cG6wvcldkNqh19fdndjRzhoMuCXmhbhVkpY5UGb0GLjSS/aR2r0nGc
         +g7hC+W9LaLyAjHbB9F6ZlBxgPtlDy3e/oKTt073/7vKAZbebSyO/UHawJBaQ/taKhoc
         UtVPRNbyH2/z+4dvNXHl8kSXaLjjwYK+X5kPO0PyoipPVdVu/2haBEG1nCBmr4hIt1IO
         ROLw==
Content-Disposition: inline
In-Reply-To: <20151125174449.GD17308-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello, Peter, Ingo.

On Wed, Nov 25, 2015 at 06:44:49PM +0100, Peter Zijlstra wrote:
> On Wed, Nov 25, 2015 at 06:31:41PM +0300, Andrey Ryabinin wrote:
> > > +       /* scheduler bits, serialized by scheduler locks */
> > >         unsigned sched_reset_on_fork:1;
> > >         unsigned sched_contributes_to_load:1;
> > >         unsigned sched_migrated:1;
> > > +       unsigned __padding_sched:29;
> > 
> > AFAIK the order of bit fields is implementation defined, so GCC could
> > sort all these bits as it wants.
> 
> We're relying on it doing DTRT in other places, so I'm fairly confident
> this'll work, otoh
> 
> > You could use unnamed zero-widht bit-field to force padding:
> > 
> >          unsigned :0; //force aligment to the next boundary.
> 
> That's a nice trick I was not aware of, thanks!

Has this been fixed yet?  While I'm not completely sure and I don't
think there's a way to be certain after the fact, we have a single
report of a machine which is showing ~4G as loadavg and one plausible
explanation could be that one of the ->nr_uninterruptible counters
underflowed from sched_contributes_to_load getting corrupted, so it'd
be great to get this one fixed soon.

Thanks.

-- 
tejun
