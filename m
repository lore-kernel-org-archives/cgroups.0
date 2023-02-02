From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 10/12] cgroup/drm: Introduce weight based drm cgroup control
Date: Thu, 2 Feb 2023 10:00:14 -1000
Message-ID: <Y9wWTspETnYYodDc@slm.duckdns.org>
References: <20230112165609.1083270-1-tvrtko.ursulin@linux.intel.com>
 <20230112165609.1083270-11-tvrtko.ursulin@linux.intel.com>
 <Y9R2N8sl+7f8Zacv@slm.duckdns.org>
 <27b7882e-1201-b173-6f56-9ececb5780e8@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KTEXTLdEtQvrB7aVFpBYAbH4Vf/ihPabgDflRw+s72o=;
        b=CuJhJ9UTVuPY/jraolwLg+hw6h/pKxRy1SLRd/hEO8GnE3cDoiPidADrjRGw4Tat7E
         jsPj+B5/JWPEzkR1ov2cP4QLjkGjelgudaCyhdc4WTw+8Tb5Oonu+M6rmd85VoAp+09n
         p29yqXXOCqF9Y85uU7Om7KJ2ttMYgVWNGXZB9YxNzDvxDzbpksNHc1G+p86CxKdlN0Ty
         +rwXXExzAQPU5AL4D29Etk7FWGP466Or/Daf4dCE9QSEqudpR8qq8SpggqjYy48/R5Nd
         XYVHbi+FsHBVz+Wv+DIRXgY0DRGWK3xQsCPpOzfidwB7nrd2hKVFHAH562MKRavuNJmY
         xtXQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <27b7882e-1201-b173-6f56-9ececb5780e8-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Hello,

On Thu, Feb 02, 2023 at 02:26:06PM +0000, Tvrtko Ursulin wrote:
> When you say active/inactive - to what you are referring in the cgroup
> world? Offline/online? For those my understanding was offline was a
> temporary state while css is getting destroyed.

Oh, it's just based on activity. So, for example, iocost puts a cgroup on
its active list which is canned periodically when an IO is issued from an
inactive cgroup. If an active cgroup doesn't have any activity between two
scans, it becomes inactive and dropped from the list. drm can prolly use the
same approach?

> Also, I am really postponing implementing those changes until I hear at
> least something from the DRM community.

Yeah, that sounds like a good idea.

Thanks.

-- 
tejun
