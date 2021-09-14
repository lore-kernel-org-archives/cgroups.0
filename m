From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] ipc: remove memcg accounting for sops objects in
 do_semtimedop()
Date: Tue, 14 Sep 2021 09:13:48 +0200
Message-ID: <YUBLrJOL6DGxmira@dhcp22.suse.cz>
References: <90e254df-0dfe-f080-011e-b7c53ee7fd20@virtuozzo.com>
 <YT8NrsaztWNDpKXk@dhcp22.suse.cz>
 <CALvZod7Y4pC4XvqVp+tJ==CnS5Ay8YPqrxeUzA8tMLu+0U3hjQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631603629; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=txwaKhwa12PBU46ZsNcF+1gome0TjZ9CBmHtWzH6uzc=;
        b=bGiWRdKv8qBHAYo6uY7okxzuUuqOtIaJnnsPyY0NBnjbC/UBbnRIdZrjuEinQDIEeh7Lua
        pyjg4ZJEJ3A8n65b9stkqC69eFv+zGRtYwaxhXW+yZRELmgGs5oe6WCjHomxHDgTCqmVFR
        C7erp512iGlIQLgVSZOetkBudr+b8pY=
Content-Disposition: inline
In-Reply-To: <CALvZod7Y4pC4XvqVp+tJ==CnS5Ay8YPqrxeUzA8tMLu+0U3hjQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon 13-09-21 21:32:25, Shakeel Butt wrote:
> On Mon, Sep 13, 2021 at 1:37 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >
> [...]
> > > However Shakeel Butt pointed that there are much more popular objects
> > > with the same life time and similar memory consumption, the accounting
> > > of which was decided to be rejected for performance reasons.
> >
> > Is there any measurable performance impact in this particular case?
> >
> 
> I don't think there was any regression report or any performance
> evaluation. Linus raised the concern on the potential performance
> impact. I suggested to backoff for this allocation for now and revisit
> again once we have improved the memcg accounting for kernel memory.

I am fine with the change, I am just not satisfied with the
justification. It is not really clear what the intention is except that
Linus wanted it. I have already asked Vasily to provide more
explanation. E.g. this part really begs for clarification
"
This object can consume up to 2 pages, syscall is sleeping one,
size and duration can be controlled by user, and this allocation
can be repeated by many thread at the same time.
"

It sounds like a problem, except it is not because? A worst case
scenario evaluation would be beneficial for example

Thanks!

-- 
Michal Hocko
SUSE Labs
