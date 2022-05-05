From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: kernfs memcg accounting
Date: Thu, 5 May 2022 11:47:04 +0200
Message-ID: <20220505094704.GB10890@blackbody.suse.cz>
References: <7e867cb0-89d6-402c-33d2-9b9ba0ba1523@openvz.org>
 <20220427140153.GC9823@blackbody.suse.cz>
 <7509fa9f-9d15-2f29-cb2f-ac0e8d99a948@openvz.org>
 <YnBLge4ZQNbbxufc@blackbook>
 <52a9f35b-458b-44c4-7fc8-d05c8db0c73f@openvz.org>
 <20220504141001.GA10890@blackbody.suse.cz>
 <65244222-02c5-6e8d-7f4b-83651f378ce2@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651744025; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9UR1yAl5TuOKPXs8xewFpELkQ8J8mZZySCuXUINaiZ8=;
        b=ohURCbNOo2RJ/iazwraZdarADgzIdXUJbgxG/iAU7mBk1yalYm6Z3rluGWxuPENvMTsqsE
        fHfJZm+HCTsJND5hEJKSEt6nrFOm3ZeJaME2+RjY7Q2tcYOXOVnIC/3RYVTEweETeKq1UT
        aC9V3D1cYBJ8i9avDe84kHWVKwG58Pk=
Content-Disposition: inline
In-Reply-To: <65244222-02c5-6e8d-7f4b-83651f378ce2-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Thu, May 05, 2022 at 12:16:12AM +0300, Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
> I think it should allocate at least 2 pages.

After decoding kmalloc_type(), I agree this falls into a global
(unaccouted) kmalloc_cache.

> However if cgroup_mkdir() calls mem_cgroup_alloc() it correctly account huge percpu
> allocations but ignores neighbour multipage allocation.

So, the spillover is bound and proportional to memcg limit (same ration
like these two sizes).
But it may be better to account it properly, especially if it's
contribution form an offlined mem_cgroup.

Thanks,
Michal
