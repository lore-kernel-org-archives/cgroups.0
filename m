From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] cgroup: Fix misspelling of CONFIG_SOCK_CGROUP_DATA in
 comments
Date: Tue, 26 Jan 2016 10:34:02 -0500
Message-ID: <20160126153402.GA3366@cmpxchg.org>
References: <1453819158-25380-1-git-send-email-andreas.ziegler@fau.de>
 <9B0331B6EBBD0E4684FBFAEDA55776F92CB53E91@HASMSX110.ger.corp.intel.com>
 <56A78D56.2030902@fau.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56A78D56.2030902-d40JDW7QUjc@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andreas Ziegler <andreas.ziegler-d40JDW7QUjc@public.gmane.org>
Cc: "Rosen, Rami" <rami.rosen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Jan 26, 2016 at 04:14:30PM +0100, Andreas Ziegler wrote:
> On 01/26/2016 16:08, Rosen, Rami wrote:
> > Hi, 
> > 
> > --- a/include/linux/cgroup.h
> > +++ b/include/linux/cgroup.h
> > @@ -604,11 +604,11 @@ static inline struct cgroup *sock_cgroup_ptr(struct sock_cgroup_data *skcd)
> >  #endif
> >  }
> > 
> > In this occasion, seems that maybe something else is also missing:
> > Shouldn't it be hereafter : +#else /* !CONFIG_SOCK_CGROUP_DATA */ 
> > instead ? 
> >    
> > -#else	/* CONFIG_CGROUP_DATA */
> > +#else	/* CONFIG_SOCK_CGROUP_DATA */
> 
> It seems that there is no real consensus among the developers for that
> particular case:
> 
> ziegler@box:~/linux$ git grep "#else \/\* \!CONFIG_" | wc -l
> 327
> ziegler@box:~/linux$ git grep "#else \/\* CONFIG_" | wc -l
> 564

The comments after #ifdef, #ifndef, #else, #endif name the condition
that is being branched on, not the condition that is in effect after
a specific line. Case in point: #endif /* CONFIG_SOCK_CGROUP_DATA */

Stick with the majority, and save a byte!
