From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 0/9] memcg accounting from OpenVZ
Date: Wed, 10 Mar 2021 11:41:07 +0100
Message-ID: <YEiiQ2TGnJcEtL3d@dhcp22.suse.cz>
References: <5affff71-e503-9fb9-50cb-f6d48286dd52@virtuozzo.com>
 <CALvZod5YOtqXcSqn2Zj2Nb_SKgDRKOMW4o5i-u_yj7CanQVtGQ@mail.gmail.com>
 <ad68d004-fa84-3d21-60b7-d4a342ad4007@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615372875; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nZTPkVjV+mQdbkg1znHnpckUqBiD+p2S+HbVcCoP3kY=;
        b=bwZeSFYTFUaI6k5iEVR5XFMy1jPlekVWZKMv+nY/aKA6C+txpjGOWyhpx/j5aXqEg0ZQji
        57JZ+A9hVmISWq5KpmmR+Li43cWJMh4Y5jD9UtZz132HBk1cpZfQ1XYn5BEOOUvyy+mzPG
        /hk5kqKbchb70cq4l+HcBR/14KoqXwk=
Content-Disposition: inline
In-Reply-To: <ad68d004-fa84-3d21-60b7-d4a342ad4007-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed 10-03-21 13:17:19, Vasily Averin wrote:
> On 3/10/21 12:12 AM, Shakeel Butt wrote:
> > On Tue, Mar 9, 2021 at 12:04 AM Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
> >>
> >> OpenVZ many years accounted memory of few kernel objects,
> >> this helps us to prevent host memory abuse from inside memcg-limited container.
> >>
> > 
> > The text is cryptic but I am assuming you wanted to say that OpenVZ
> > has remained on a kernel which was still on opt-out kmem accounting
> > i.e. <4.5. Now OpenVZ wants to move to a newer kernel and thus these
> > patches are needed, right?
> 
> Something like this.
> Frankly speaking I badly understand which arguments should I provide to upstream
> to enable accounting for some new king of objects.
> 
> OpenVZ used own accounting subsystem since 2001 (i.e. since v2.2.x linux kernels) 
> and we have accounted all required kernel objects by using our own patches.
> When memcg was added to upstream Vladimir Davydov added accounting of some objects
> to upstream but did not skipped another ones.
> Now OpenVZ uses RHEL7-based kernels with cgroup v1 in production, and we still account
> "skipped" objects by our own patches just because we accounted such objects before.
> We're working on rebase to new kernels and we prefer to push our old patches to upstream. 

That is certainly an interesting information. But for a changelog it
would be more appropriate to provide information about how much memory
user can induce and whether there is any way to limit that memory by
other means. How practical those other means are and which usecases will
benefit from the containment.

-- 
Michal Hocko
SUSE Labs
