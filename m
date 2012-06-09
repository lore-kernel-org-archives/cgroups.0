From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 2/4] Add a __GFP_SLABMEMCG flag
Date: Sat, 9 Jun 2012 12:24:03 +0400
Message-ID: <4FD30823.8070808@parallels.com>
References: <1339148601-20096-1-git-send-email-glommer@parallels.com>  <1339148601-20096-3-git-send-email-glommer@parallels.com>  <alpine.DEB.2.00.1206081430380.4213@router.home> <1339203416.6893.10.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339203416.6893.10.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbeck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 06/09/2012 04:56 AM, James Bottomley wrote:
> On Fri, 2012-06-08 at 14:31 -0500, Christoph Lameter wrote:
>> On Fri, 8 Jun 2012, Glauber Costa wrote:
>>
>>>    */
>>>   #define __GFP_NOTRACK_FALSE_POSITIVE (__GFP_NOTRACK)
>>>
>>> -#define __GFP_BITS_SHIFT 25	/* Room for N __GFP_FOO bits */
>>> +#define __GFP_BITS_SHIFT 26	/* Room for N __GFP_FOO bits */
>>>   #define __GFP_BITS_MASK ((__force gfp_t)((1<<  __GFP_BITS_SHIFT) - 1))
>>
>> Please make this conditional on CONFIG_MEMCG or so. The bit can be useful
>> in particular on 32 bit architectures.
>
> I really don't think that's at all a good idea.  It's asking for trouble
> when we don't spot we have a flag overlap.  It also means that we're
> trusting the reuser to know that their use case can never clash with
> CONFIG_MEMGC and I can't think of any configuration where this is
> possible currently.
>
> I think making the flag define of __GFP_SLABMEMCG conditional might be a
> reasonable idea so we get a compile failure if anyone tries to use it
> when !CONFIG_MEMCG.
>

Which is also difficult since that's not code that we can BUG or WARN, 
but just a number people or and and into their own flags. And it is too 
fragile to rely on any given sequence we put here (like -1UL, etc) to 
provide predictable enough results to tell someone he is doing it wrong.

A much better approach if we want to protect against that, is to add 
code in the page or slab allocator (or both) to ignore and WARN upon 
seeing this flag when !memcg.

I'd leave the flag itself alone.
