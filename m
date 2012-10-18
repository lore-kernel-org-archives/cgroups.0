From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v5 13/14] protect architectures where THREAD_SIZE >= PAGE_SIZE
 against fork bombs
Date: Thu, 18 Oct 2012 13:37:39 +0400
Message-ID: <507FCDE3.1050408@parallels.com>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com> <1350382611-20579-14-git-send-email-glommer@parallels.com> <20121017151245.f11c4d18.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121017151245.f11c4d18.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 10/18/2012 02:12 AM, Andrew Morton wrote:
> On Tue, 16 Oct 2012 14:16:50 +0400
> Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> 
>> @@ -146,7 +146,7 @@ void __weak arch_release_thread_info(struct thread_info *ti)
>>  static struct thread_info *alloc_thread_info_node(struct task_struct *tsk,
>>  						  int node)
>>  {
>> -	struct page *page = alloc_pages_node(node, THREADINFO_GFP,
>> +	struct page *page = alloc_pages_node(node, THREADINFO_GFP_ACCOUNTED,
>>  					     THREAD_SIZE_ORDER);
> 
> yay, we actually used all this code for something ;)
> 
Happy to be of use, sir!

> I don't think we really saw a comprehensive list of what else the kmem
> controller will be used for, but I believe that all other envisaged
> applications will require slab accounting, yes?
> 
> 
> So it appears that all we have at present is a
> yet-another-fork-bomb-preventer, but one which requires that the
> culprit be in a container?  That's reasonable, given your
> hosted-environment scenario.  It's unclear (to me) that we should merge
> all this code for only this feature.  Again, it would be good to have a
> clear listing of and plan for other applications of this code.
> 

I agree. This doesn't buy me much without slab accounting. But
reiterating what I've just said in another e-mail, slab accounting is
not really in plan stage, but had also been through extensive development.

As a matter of fact, it used to be only "slab accounting" in the
beginning, without this. I've split it more recently because I believe
it would allow people to do a more focused review, leading to better code.

