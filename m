From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v3 07/16] memcg: skip memcg kmem allocations in specified
 code regions
Date: Mon, 24 Sep 2012 13:09:23 +0400
Message-ID: <50602343.6040806@parallels.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com> <1347977530-29755-8-git-send-email-glommer@parallels.com> <20120921195929.GL7264@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120921195929.GL7264-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On 09/21/2012 11:59 PM, Tejun Heo wrote:
> Hello,
> 
> On Tue, Sep 18, 2012 at 06:12:01PM +0400, Glauber Costa wrote:
>> +static void memcg_stop_kmem_account(void)
>> +{
>> +	if (!current->mm)
>> +		return;
>> +
>> +	current->memcg_kmem_skip_account++;
>> +}
>> +
>> +static void memcg_resume_kmem_account(void)
>> +{
>> +	if (!current->mm)
>> +		return;
>> +
>> +	current->memcg_kmem_skip_account--;
>> +}
> 
> I can't say I'm a big fan of this approach.  If there are enough
> users, maybe but can't we just annotate the affected allocations
> explicitly?  Is this gonna have many more users?
> 

What exactly do you mean by annotating the affected allocations?

There are currently two users of this. In both places, we are interested
in disallowing recursion, because cache creation will trigger new cache
allocations that will bring us back here.

We can't rely on unsetting the GFP flag we're using for this, because
that affects only the page allocation, not the metadata allocation for
the cache.


> Also, in general, can we please add some comments?  I know memcg code
> is dearth of comments but let's please not keep it that way.
> 
All right here.
