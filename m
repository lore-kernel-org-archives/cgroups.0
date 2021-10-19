From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Question] io cgroup subsystem threaded support
Date: Tue, 19 Oct 2021 07:57:15 -1000
Message-ID: <YW8G+6QZOUYlQ1TE@slm.duckdns.org>
References: <20211001110645.uzw2w5t4rknwqhma@T580.localdomain>
 <20211007133916.mgk6qb65d2r57fc2@T580.localdomain>
 <20211011153416.GB61605@blackbody.suse.cz>
 <20211015065135.5hauecjmri2lytpv@T580.localdomain>
 <20211015070745.zbzpistqrj6g4zxa@T580.localdomain>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YLohXwWhhTkoQPq47xX63nh19G3YNh9XY/6a/imyag8=;
        b=bE4UztpS09JP6k0FxL8qzRCmgmGOu7h35Ly+ryB0+uwFpWImRVkm8ypo5L/UOW1CWM
         O0unv30uo5Po3KqTqEe7G0wBV423YCjWaVW4yAL2wMuisjs9kkoLW3u8MMzPPAopAzHZ
         FEDNr1czg6363aU/zi4OMXrvf24H1EbvgWrppG8QphZYXtmmjzMmYTy7qql6buI5M5eh
         rWeUG3nEHzKjqzMszcPNyJwJb+E8uEOcu2CGl5zC73ZsJyMjUl3EhFSqNEeuTKwN3ItU
         VYi3sBDfIjb6uh+mdhjlO6cmabcxGKB4xh+LxDQbvVC3gf2KjvHtgifwKFb37CDFLfPS
         sw8g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20211015070745.zbzpistqrj6g4zxa-3Hjs5a4P6Kh82hYKe6nXyg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Odin Hultgren van der Horst <odin-KgRVb285F3Y0FkRhN5fn+A@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Fri, Oct 15, 2021 at 09:07:45AM +0200, Odin Hultgren van der Horst wrote:
> > IIUC, the application would have to be collaborative anyway (dividing
> > threads into cgroups) and given you're concered about reads,
> > set_ioprio(2) might be enough for this case.

One problem there is that set_ioprio(2) only works w/ bfq.

> > Also, if you've seen starvation (likely depends on IO scheduler), you
> > may raise this with linux-block ML.
> 
> I also want to be able to limit amount of io for a given thread, just
> like you could to with io.max. So a given client cant just use all my io
> even though there is no competing thread.

This isn't what cgroup is too useful at right now. CPU control is an
exception partly due to historical reasons but it's silly to enable support
for per-thread IO control when a chunk as big as buffered writes is not only
missing but doesn't even have a plausible future path for support.

Another rather fundamental problem is that cgroup interface ends up
entangling application behavior with system admin operations - e.g. whether
IO control is available for a given application is determined by not just
the kernel configuration but how the system's cgroup hierarchy is configured
at the moment and an application's configurations can be wiped out by system
configuration changing.

Being able to extend resource control to per-thread level can definitely be
useful but we'd need a lot more work in providing a usable programmable
interface which can make cgroup system configuration transparent to the
applications so that applications can basically do something like
set_ioprio(2) and have resource control working as best as possible on top
of the system configuration at the moment.

Thanks.

-- 
tejun
