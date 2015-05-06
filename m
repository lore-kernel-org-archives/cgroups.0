From: Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH 1/2] gfp: add __GFP_NOACCOUNT
Date: Wed, 6 May 2015 17:29:51 +0300
Message-ID: <20150506142951.GC29387@esperanza>
References: <fdf631b3fa95567a830ea4f3e19d0b3b2fc99662.1430819044.git.vdavydov@parallels.com>
 <20150506115941.GH14550@dhcp22.suse.cz>
 <20150506122431.GA29387@esperanza>
 <20150506123541.GK14550@dhcp22.suse.cz>
 <20150506132510.GB29387@esperanza>
 <20150506135520.GN14550@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20150506135520.GN14550@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Greg Thelen <gthelen@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, May 06, 2015 at 03:55:20PM +0200, Michal Hocko wrote:
> On Wed 06-05-15 16:25:10, Vladimir Davydov wrote:
> > On Wed, May 06, 2015 at 02:35:41PM +0200, Michal Hocko wrote:
[...]
> > > NOACCOUNT doesn't imply kmem at all so it is not clear who is in charge
> > > of the accounting.
> > 
> > IMO it is a benefit. If one day for some reason we want to bypass memcg
> > accounting for some other type of allocation somewhere, we can simply
> > reuse it.
> 
> But what if somebody, say a highlevel memory allocator in the kernel,
> want's to (ab)use this flag for its internal purpose as well?

We won't let him :-)

If we take your argument about future (ab)users seriously, we should
also consider what will happen if one wants to use e.g. __GFP_HARDWALL,
which BTW has a generic name too although it's cpuset-specific.

My point is that MEMCG is the only subsystem of the kernel that tries to
do full memory accounting, and there is no point in introducing another
one, because we already have it. So we have full right to reserve
__GFP_NOACCOUNT for our purposes, just like cpuset reserves
__GFP_HARDWALL and kmemcheck __GFP_NOTRACK. Any newcomer must take this
into account.

Thanks,
Vladimir

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
