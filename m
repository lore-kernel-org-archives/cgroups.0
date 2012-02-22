From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 4/7] chained slab caches: move pages to a different cache
 when a cache is destroyed.
Date: Wed, 22 Feb 2012 18:50:58 +0400
Message-ID: <4F4500D2.9040207@parallels.com>
References: <1329824079-14449-1-git-send-email-glommer@parallels.com> <1329824079-14449-5-git-send-email-glommer@parallels.com> <CABCjUKBQZZ1fjKMAt5LdxzkVEhj3Ro9nxySH2rM8=N8Hk=OQzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABCjUKBQZZ1fjKMAt5LdxzkVEhj3Ro9nxySH2rM8=N8Hk=OQzQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hiroyouki Kamezawa <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

On 02/22/2012 03:40 AM, Suleiman Souhlal wrote:
> On Tue, Feb 21, 2012 at 3:34 AM, Glauber Costa<glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>  wrote:
>> In the context of tracking kernel memory objects to a cgroup, the
>> following problem appears: we may need to destroy a cgroup, but
>> this does not guarantee that all objects inside the cache are dead.
>> This can't be guaranteed even if we shrink the cache beforehand.
>>
>> The simple option is to simply leave the cache around. However,
>> intensive workloads may have generated a lot of objects and thus
>> the dead cache will live in memory for a long while.
>
> Why is this a problem?
>
> Leaving the cache around while there are still active objects in it
> would certainly be a lot simpler to understand and implement.
>

Yeah, I agree on the simplicity. The chained stuff was probably the 
hardest one in the patchset to get working alright. However, my 
assumptions are as follow:

1) If we bother to be tracking kernel memory, it is because we believe 
its usage can skyrocket under certain circumstances. In those scenarios, 
we'll have a lot of objects around. If we just let them flowing, it's 
just wasted memory that was created from the memcg, but can't be 
reclaimed on its behalf.

2) We can reclaim that, if we have, as a policy, to always start 
shrinking from those when global pressure kicks in. But then, we move 
the complication from one part to another.


