From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 6/6] zswap: memcg accounting
Date: Wed, 18 May 2022 10:23:26 +0200
Message-ID: <20220518082326.GH17557@blackbody.suse.cz>
References: <20220510152847.230957-1-hannes@cmpxchg.org>
 <20220510152847.230957-7-hannes@cmpxchg.org>
 <20220511173218.GB31592@blackbody.suse.cz>
 <YnwJUL90fuoHs3YW@cmpxchg.org>
 <20220513151426.GC16096@blackbody.suse.cz>
 <Yn6QfdouzkcrygTR@cmpxchg.org>
 <20220516143459.GA17557@blackbody.suse.cz>
 <YoKtgaxOAMBVKiCf@cmpxchg.org>
 <20220517165216.7acd8434f8b25606836e21e6@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652862207; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FJND1+favEk/cOgY0turwQ+6cBnWq+nsb19SAKTVPUA=;
        b=t/o5epZYvxiBIQDzueYrPOwwiW1warWt2xq1/43b4Mj1nJfRwe5l+xKZd0iZfTWfO74CG4
        7P318fbQMXRSCtWT9vlEpfhiCbavhA1HuRdRPC5UIYPhedEviCDhQ6jGCzMuYHoBDrdKt5
        No7H2oBTBt/Q01S/kFrhKyw7lnHceNo=
Content-Disposition: inline
In-Reply-To: <20220517165216.7acd8434f8b25606836e21e6-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Streetman <ddstreet-EkmVulN54Sk@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, May 17, 2022 at 04:52:16PM -0700, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Mon, 16 May 2022 16:01:05 -0400 Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > Thanks for your thoughts, Michal.

You're welcome. The change is well-reasoned...

> I think everything is settled here so I plan to import this series into
> mm-stable in a couple of days.

...and makes sense with the listed fixups.

Michal
