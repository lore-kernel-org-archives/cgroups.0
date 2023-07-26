From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 16/17] cgroup/drm: Expose memory stats
Date: Wed, 26 Jul 2023 09:49:57 -1000
Message-ID: <ZMF45fhrZhiNdn53@slm.duckdns.org>
References: <20230712114605.519432-1-tvrtko.ursulin@linux.intel.com>
 <20230712114605.519432-17-tvrtko.ursulin@linux.intel.com>
 <ZLsFBHqCQdPHoZVw@slm.duckdns.org>
 <8959f665-4353-3630-a6c7-5dca60959faa@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690401000; x=1691005800;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o0fC+88gZBz8jtA7XWzXX83zAKhjWaVQ+UtgjI6/8g4=;
        b=oukBQFR9IQO7+GHjeNafPLNndng0nKABjpaczwth9BgzQpiqLcIQmG3R0hQGndcxJm
         cYdWVh5nwhTZeVggUqY+dTHuIGwyN30/6fp2sp0wyfL72IGfNgg/LyhmK/aOsL0qe9rh
         hdl08+mPzCse2OTUc3DCOSQQdlnPnOVKbMtUM7PQdS9pjxjPVU1Ss81NUNDkqum4hDE7
         kbOOH4W3oJ+SWJh62vMxckP4920VO+vrtvTrkBs9b9GwH/Y8ktjUNvzdGAnSNbKu64a/
         V4UOi3avOQ9xPragbr0BWF/d/6EXsVAYc16BmiSMrYcqsAW0FvN+x0wHlEhYvWG6eIOr
         cRAw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8959f665-4353-3630-a6c7-5dca60959faa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Eero Tamminen <eero.t.tamminen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Hello,

On Wed, Jul 26, 2023 at 05:44:28PM +0100, Tvrtko Ursulin wrote:
...
> > So, yeah, if you want to add memory controls, we better think through how
> > the fd ownership migration should work.
> 
> It would be quite easy to make the implicit migration fail - just the matter
> of failing the first ioctl, which is what triggers the migration, after the
> file descriptor access from a new owner.

So, it'd be best if there's no migration involved at all as per the
discussion with Maarten.

> But I don't think I can really add that in the RFC given I have no hard
> controls or anything like that.
> 
> With GPU usage throttling it doesn't really apply, at least I don't think it
> does, since even when migrated to a lower budget group it would just get
> immediately de-prioritized.
> 
> I don't think hard GPU time limits are feasible in general, and while soft
> might be, again I don't see that any limiting would necessarily have to run
> immediately on implicit migration.

Yeah, I wouldn't worry about hard allocation of GPU time. CPU RT control
does that but it's barely used.

> Second part of the story are hypothetical/future memory controls.
> 
> I think first thing to say is that implicit migration is important, but it
> is not really established to use the file descriptor from two places or to
> migrate more than once. It is simply fresh fd which gets sent to clients
> from Xorg, which is one of the legacy ways of doing things.
> 
> So we probably can just ignore that given no significant amount of memory
> ownership would be getting migrated.

So, if this is the case, it'd be better to clarify this. ie. if the summary is:

fd gets assigned to the user with a certain action at which point the fd
doesn't have significant resources attached to it and the fd can't be moved
to some other cgroup afterwards.

then, everything is pretty simple. No need to worry about migration at all.
fd just gets assigned once at the beginning and everything gets accounted
towards that afterwards.

> And for drm.memory.stat I think what I have is good enough - both private
> and shared data get accounted, for any clients that have handles to
> particular buffers.
> 
> Maarten was working on memory controls so maybe he would have more thoughts
> on memory ownership and implicit migration.
> 
> But I don't think there is anything incompatible with that and
> drm.memory.stats as proposed here, given how the categories reported are the
> established ones from the DRM fdinfo spec, and it is fact of the matter that
> we can have multiple memory regions per driver.
> 
> The main thing that would change between this RFC and future memory controls
> in the area of drm.memory.stat is the implementation - it would have to get
> changed under the hood from "collect on query" to "account at
> allocation/free/etc". But that is just implementation details.

I'd much prefer to straighten out this before adding a prelimiary stat only
thing. If the previously described ownership model is sufficient, none of
this is complicated, right? We can just add counters to track the resources
and print them out.

Thanks.

-- 
tejun
