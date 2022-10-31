From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/vmscan: respect cpuset policy during page demotion
Date: Mon, 31 Oct 2022 10:18:53 +0100
Message-ID: <Y1+S/UkS1DNIwlp7@dhcp22.suse.cz>
References: <Y1lZV6qHp3gIINGc@dhcp22.suse.cz>
 <87wn8lkbk5.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Y1ou5DGHrEsKnhri@dhcp22.suse.cz>
 <87o7txk963.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Y1o63SWD2KmQkT3v@dhcp22.suse.cz>
 <87fsf9k3yg.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Y1p5vaN1AWhpNWZx@dhcp22.suse.cz>
 <87bkpwkg24.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Y1+J7+1V1nJXF+3b@dhcp22.suse.cz>
 <87wn8gcr5s.fsf@yhuang6-desk2.ccr.corp.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1667207934; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5f+L4lFYRpVQJbtga4qXT/E9MSZAjXCdeB1iVrLLAwE=;
        b=nuddbqq6TZ5pf7kcq2IG5RchiKUxQQg5buEf9Z/wa2aKMhbg7b3HUcgyRFp3A6JPC0e4Qc
        7IwSXh9euPvo2ECab2gA2wkXzqpsEoE/cAkSKxkTiovPpHcG+WOi708agMeYmFKIJzN6EH
        P5RsnzkHClZu3MXCxPxAvl0nryGA4GE=
Content-Disposition: inline
In-Reply-To: <87wn8gcr5s.fsf-fFUE1NP8JkzwuUmzmnQr+vooFf0ArEBIu+b9c/7xato@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Aneesh Kumar K V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hansen, Dave" <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Yin, Fengwei" <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Mon 31-10-22 16:51:11, Huang, Ying wrote:
> Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> writes:
> 
> > On Fri 28-10-22 07:22:27, Huang, Ying wrote:
> >> Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> writes:
> >> 
> >> > On Thu 27-10-22 17:31:35, Huang, Ying wrote:
> > [...]
> >> >> I think that it's possible for different processes have different
> >> >> requirements.
> >> >> 
> >> >> - Some processes don't care about where the memory is placed, prefer
> >> >>   local, then fall back to remote if no free space.
> >> >> 
> >> >> - Some processes want to avoid cross-socket traffic, bind to nodes of
> >> >>   local socket.
> >> >> 
> >> >> - Some processes want to avoid to use slow memory, bind to fast memory
> >> >>   node only.
> >> >
> >> > Yes, I do understand that. Do you have any specific examples in mind?
> >> > [...]
> >> 
> >> Sorry, I don't have specific examples.
> >
> > OK, then let's stop any complicated solution right here then. Let's
> > start simple with a per-mm flag to disable demotion of an address
> > space.
> 
> I'm not a big fan of per-mm flag.  Because we don't have users for that
> too and it needs to add ABI too.

OK, if there are no users for opt-out then let's jus document the
current limitations and be done with it.

> > Should there ever be a real demand for a more fine grained solution
> > let's go further but I do not think we want a half baked solution
> > without real usecases.
> 
> I'm OK to ignore per-task (and missing per-process) memory policy
> support for now.

I am against such a half baked solution.
-- 
Michal Hocko
SUSE Labs
