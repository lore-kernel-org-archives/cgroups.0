From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2 09/11] memcg: propagate kmem limiting information to
 children
Date: Tue, 21 Aug 2012 13:22:09 +0400
Message-ID: <50335341.6010400@parallels.com>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-10-git-send-email-glommer@parallels.com> <20120817090005.GC18600@dhcp22.suse.cz> <502E0BC3.8090204@parallels.com> <20120817093504.GE18600@dhcp22.suse.cz> <502E17C4.7060204@parallels.com> <20120817103550.GF18600@dhcp22.suse.cz> <502E1E90.1080805@parallels.com> <20120821075430.GA19797@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120821075430.GA19797-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 08/21/2012 11:54 AM, Michal Hocko wrote:
> On Fri 17-08-12 14:36:00, Glauber Costa wrote:
>> On 08/17/2012 02:35 PM, Michal Hocko wrote:
>>>>> But I never said that can't happen. I said (ok, I meant) the static
>>>>> branches can't be disabled.
>>> Ok, then I misunderstood that because the comment was there even before
>>> static branches were introduced and it made sense to me. This is
>>> inconsistent with what we do for user accounting because even if we set
>>> limit to unlimitted we still account. Why should we differ here?
>>
>> Well, we account even without a limit for user accounting. This is a
>> fundamental difference, no ?
> 
> Yes, user memory accounting is either on or off all the time (switchable
> at boot time). 
> My understanding of kmem is that the feature is off by default because
> it brings an overhead that is worth only special use cases. And that
> sounds good to me. I do not see a good reason to have runtime switch
> off. It makes the code more complicated for no good reason. E.g. how do
> you handle charges you left behind? Say you charged some pages for
> stack?
> 
Answered in your other e-mail. About the code complication, yes, it does
make the code more complicated. See below.

> But maybe you have a good use case for that?
> 
Honestly, I don't. For my particular use case, this would be always on,
and end of story. I was operating under the belief that being able to
say "Oh, I regret", and then turning it off would be beneficial, even at
the expense of the - self contained - complication.

For the general sanity of the interface, it is also a bit simpler to say
"if kmem is unlimited, x happens", which is a verifiable statement, than
to have a statement that is dependent on past history. But all of those
need of course, as you pointed out, to be traded off by the code complexity.

I am fine with either, I just need a clear sign from you guys so I don't
keep deimplementing and reimplementing this forever.

