From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH mm] vmalloc: back off when the current task is OOM-killed
Date: Mon, 27 Sep 2021 13:08:33 +0200
Message-ID: <YVGmMSJ3NrQZjLP8@dhcp22.suse.cz>
References: <YT8PEBbYZhLixEJD@dhcp22.suse.cz>
 <d07a5540-3e07-44ba-1e59-067500f024d9@virtuozzo.com>
 <YUsg4j8gEt+WOCzi@dhcp22.suse.cz>
 <fa29c6f9-a53c-83bd-adcb-1e09d4387024@virtuozzo.com>
 <YU2EXP5wrSKv+b/8@dhcp22.suse.cz>
 <508abe37-a044-7180-ac67-b4ce5e4cc149@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1632740914; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T0gN5P8Lx7ZyiqATEPAc473z/z83jxXVuqiEZE6U3VQ=;
        b=kre7iUxOWUIgYgzzKUhzw0x2WCHgHzMCUOqVIBpZ+x/aVr1dRjiWLufEXpDi/CmGC1TYI1
        px71aSp6Y8Zv4RfWxdoH2HFaiQnu6Shv0Ar9v2hzsX4tQvCY2YXDp53YHRpvaMi3o5GqQV
        TZ9vAVbHiIdSUzPF8ML3FYKqjacgdVY=
Content-Disposition: inline
In-Reply-To: <508abe37-a044-7180-ac67-b4ce5e4cc149-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Mon 27-09-21 12:36:15, Vasily Averin wrote:
> On 9/24/21 10:55 AM, Michal Hocko wrote:
> > On Thu 23-09-21 09:49:57, Vasily Averin wrote:
[...]
> >> Hypothetically, cancelled vmalloc called inside some filesystem's transaction
> >> forces its rollback, that in own turn it can call own vmalloc.
> > 
> > Do you have any specific example?
> 
> No, it was pure hypothetical assumption.
> I was thinking about it over the weekend, and decided that:
> a) such kind of issue (i.e. vmalloc call in rollback after failed vmalloc)
>    is very unlikely
> b) if it still exists -- it must have own failback with kmalloc(NOFAIL) 
>    or just accept/ignore such failure and should not lead to critical failures.
>    If this still happen -- ihis is a bug, we should detect and fix it ASAP.

I would even argue that nobody should rely on vmalloc suceeding. The
purpose of the allocator is to allow larger allocations and we do not
guarantee anything even for small reqests.

> >> Should we perhaps interrupt the first vmalloc only?
> > 
> > This doesn't make much sense to me TBH. It doesn't address the very
> > problem you are describing in the changelog.
> 
> Last question:
> how do you think, should we perhaps, instead, detect such vmallocs 
> (called in rollback after failed vmalloc) and generate a warnings,
> to prevent such kind of problems in future?

We do provide an allocation failure splat unless the request is
explicitly __GFP_NOWARN IIRC.
-- 
Michal Hocko
SUSE Labs
