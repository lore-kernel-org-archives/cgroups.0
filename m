From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 1/3] mm: embed the memcg pointer directly into struct page
Date: Mon, 3 Nov 2014 10:09:42 -0500
Message-ID: <20141103150942.GA32052@phnom.home.cmpxchg.org>
References: <1414898156-4741-1-git-send-email-hannes@cmpxchg.org>
 <20141103080208.GA7052@js1304-P5Q-DELUXE>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141103080208.GA7052@js1304-P5Q-DELUXE>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Joonsoo,

On Mon, Nov 03, 2014 at 05:02:08PM +0900, Joonsoo Kim wrote:
> On Sat, Nov 01, 2014 at 11:15:54PM -0400, Johannes Weiner wrote:
> > Memory cgroups used to have 5 per-page pointers.  To allow users to
> > disable that amount of overhead during runtime, those pointers were
> > allocated in a separate array, with a translation layer between them
> > and struct page.
> 
> Hello, Johannes.
> 
> I'd like to leave this translation layer.
> Could you just disable that code with #ifdef until next user comes?
> 
> In our company, we uses PAGE_OWNER on mm tree which is the feature
> saying who allocates the page. To use PAGE_OWNER needs modifying
> struct page and then needs re-compile. This re-compile makes us difficult
> to use this feature. So, we decide to implement run-time configurable
> PAGE_OWNER through page_cgroup's translation layer code. Moreover, with
> this infrastructure, I plan to implement some other debugging feature.
> 
> Because of my laziness, it didn't submitted to LKML. But, I will
> submit it as soon as possible. If the code is removed, I would
> copy-and-paste the code, but, it would cause lose of the history on
> that code. So if possible, I'd like to leave that code now.

Please re-introduce this code when your new usecase is ready to be
upstreamed.  There is little reason to burden an unrelated feature
with a sizable chunk of dead code for a vague future user.

Thanks
