From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/vmscan: respect cpuset policy during page demotion
Date: Thu, 27 Oct 2022 15:05:23 +0200
Message-ID: <Y1qCE8snHO2uKHKd@dhcp22.suse.cz>
References: <dc453287-015d-fd1c-fe7f-6ee45772d6aa@linux.ibm.com>
 <Y1jpDfwBQId3GkJC@feng-clx>
 <Y1j7tsj5M0Md/+Er@dhcp22.suse.cz>
 <d17698d2-c1b5-9aa3-6271-838830d36cc5@linux.ibm.com>
 <Y1kTz1qjfsY1UBPf@dhcp22.suse.cz>
 <44e485d4-acf5-865d-17fe-13be1c1b430b@linux.ibm.com>
 <Y1kmOaXvzwRv/tza@dhcp22.suse.cz>
 <22590f74-ec91-e673-32df-8a04b4ab3931@linux.ibm.com>
 <Y1pJG+d+kXJgjNMc@dhcp22.suse.cz>
 <5a6c29f9-1154-03af-c22e-55108feb155f@linux.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1666875925; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iLNO8fwHXhHPJ6MycKJ73w5HGMLMj9HlWspV0+LyiJY=;
        b=rDEM3ZnGroiojMFPrn3cjucEP3ymtmI5jrPZuAxvb5gEMPrn0HIj7PmXKMYgHo1+tO7yE2
        6urCMiTAG71A2qFslg+sHC6po5k0B6snagoA3ro5K29S4RuzkKtq0qdXHCrGD7CohRaAAK
        dRp+4plLctbuWS/EqHucGbLmAfiWebU=
Content-Disposition: inline
In-Reply-To: <5a6c29f9-1154-03af-c22e-55108feb155f-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aneesh Kumar K V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Cc: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hansen, Dave" <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Yin, Fengwei" <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Thu 27-10-22 15:46:07, Aneesh Kumar K V wrote:
> On 10/27/22 2:32 PM, Michal Hocko wrote:
> 
> >>
> >> Sorry, I meant MAP_ANONYMOUS | MAP_SHARED. 
> > 
> > I am still not sure where you are targeting to be honest. MAP_SHARED or
> > MAP_PRIVATE both can have page shared between several vmas.
> 
> 
> What I was checking was w.r.t demotion and shared pages do we need to
> cross-check all the related memory policies? On the page fault side, we don't do that.

Yes, because on the page fault we do have an originator and so we can
apply some reasonable semantic. For the memory reclaim there is no such
originator for a specific page. A completely unrelated context might be
reclaiming a page with some mempolicy constrain and you do not have any
records who has faulted it in. The fact that we have a memory policy
also at the task level makes a completely consistent semantic rather
hard if possible at all (e.g. what if different thread are simply bound
to a different node because shared memory is prefaulted and local thread
mappings will be always local).

I do not think shared mappings are very much special in that regards. It
is our mempolicy API that allows to specify a policy for vmas as well as
tasks and the later makes the semantic for reclaim really awkward.

-- 
Michal Hocko
SUSE Labs
