From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 16/16] memcg: enable accounting for ldt_struct objects
Date: Fri, 23 Apr 2021 08:20:37 +0200
Message-ID: <YIJnNfBgp3FK9A0z@dhcp22.suse.cz>
References: <dddf6b29-debd-dcb5-62d0-74909d610edb@virtuozzo.com>
 <94dd36cb-3abb-53fc-0f23-26c02094ddf4@virtuozzo.com>
 <20210422122615.GA7021@zn.tnic>
 <29fe6b29-d56a-6ea1-2fe7-2b015f6b74ef@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619158839; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gWQ/jtCp4l7XsOhkZSQRBGSW2Rsfk3107+x/NpXeseg=;
        b=A7byGxZJ2VZ7pDkLkKRG2KnUM7W0zOh0/5akvuiizh9QecTv8EvXb6ZXZgQ400875Yyrw1
        ULG9Ds0Q250X6OQ9pboXIPqa/ec2Zt05L4I49u1ONzGQqQTtXVHCGRNj7T9dctJ8Vq/hWA
        7VY6pYf2p3cVDgQMosqCCZnv7oUa98U=
Content-Disposition: inline
In-Reply-To: <29fe6b29-d56a-6ea1-2fe7-2b015f6b74ef-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>

On Fri 23-04-21 06:13:30, Vasily Averin wrote:
> On 4/22/21 3:26 PM, Borislav Petkov wrote:
> > On Thu, Apr 22, 2021 at 01:38:01PM +0300, Vasily Averin wrote:
> > 
> > You have forgotten to Cc LKML on your submission.
> I think it's OK, patch set is addressed to cgroups subsystem amiling list.
> Am I missed something and such patches should be sent to LKML anyway?

Yes, it is preferable to CC all patches to lkml. These patches are not
cgroup specit much. A specific subsystem knowledge is require to judge
them and most people are not subscribed to the cgroup ML.

> >> @@ -168,9 +168,10 @@ static struct ldt_struct *alloc_ldt_struct(unsigned int num_entries)
> >>  	 * than PAGE_SIZE.
> >>  	 */
> >>  	if (alloc_size > PAGE_SIZE)
> >> -		new_ldt->entries = vzalloc(alloc_size);
> >> +		new_ldt->entries = __vmalloc(alloc_size,
> >> +					     GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> > 
> > You don't have to break that line - just let it stick out.
> Hmm. I missed that allowed line limit was increased up to 100 bytes,
> Thank you, I will fix it in next patch version. 

Line limits are more of a guidance than a hard rule. Also please note
that different subsystems' maintainers insist on this guidance
differently.
-- 
Michal Hocko
SUSE Labs
