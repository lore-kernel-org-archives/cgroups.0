From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH RESEND] mm: memcg: synchronize objcg lists with a
 dedicated spinlock
Date: Sat, 5 Feb 2022 08:58:26 -0800
Message-ID: <Yf6sskyXcffxTA+b@carbon.dhcp.thefacebook.com>
References: <Yfm1IHmoGdyUR81T@carbon.dhcp.thefacebook.com>
 <20220203151912.87d47b82c1bc3f0d56be0e3a@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=s2vIlAN/7DsTxLiP+mwrPc0mOmUin6NW3bRsxKydZ4M=;
 b=Ulk3+gg4Y+T4cbmvtkS4IYNUbhPTxGTXWU13ShGYoC4lNRfVyidgORBSIwJDocDobYnA
 972k/Aee33geuclOFOMlweyQHKrq9+7Ren3J6fKkvd24P//SKFRs6QhbMwKL0q9y9s/t
 m+Ax2ZglKB0jzuwjZBBjUEdsXNcfQrHenuQ= 
Content-Disposition: inline
In-Reply-To: <20220203151912.87d47b82c1bc3f0d56be0e3a-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Egorenkov <egorenar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Feb 03, 2022 at 03:19:12PM -0800, Andrew Morton wrote:
> On Tue, 1 Feb 2022 14:33:04 -0800 Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> 
> > Alexander reported a circular lock dependency revealed by the mmap1
> > ltp test:
> >   LOCKDEP_CIRCULAR (suite: ltp, case: mtest06 (mmap1))
> > 
> > ...
> >
> > Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
> 
> I'm thinking it needs cc:stable.  It sounds unlikely that we'll hit it
> in real life, but lockdep splats are concerning and I expect downstream
> kernel consumers will end up merging this anyway, for this reason.
> 

I agree.

I'm somewhat surprised that we haven't seen any such warnings until recently,
so I guess some recent kmem accounting change made it more probable.

Anyway, it feels like it's a low risk change and I see no reasons
to not backport it to stable.

Thank you!
