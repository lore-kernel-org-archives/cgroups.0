From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 1/2] vmpressure: in-kernel notifications
Date: Tue, 23 Apr 2013 11:17:08 -0700
Message-ID: <5176D024.5090007@parallels.com>
References: <1366705329-9426-1-git-send-email-glommer@openvz.org> <1366705329-9426-2-git-send-email-glommer@openvz.org> <20130423171122.GA29983@teo>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20130423171122.GA29983@teo>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Anton Vorontsov <anton@enomsg.org>
Cc: Glauber Costa <glommer@openvz.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, John Stultz <john.stultz@linaro.org>, Joonsoo Kim <js1304@gmail.com>, Michal Hocko <mhocko@suse.cz>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>

On 04/23/2013 10:11 AM, Anton Vorontsov wrote:
> On Tue, Apr 23, 2013 at 12:22:08PM +0400, Glauber Costa wrote:
>> From: Glauber Costa <glommer@parallels.com>
> [...]
>> This patch extends that to also support in-kernel users.
>
> Yup, that is the next logical step. ;-) The patches look good to me, just
> one question...
>
>> @@ -227,7 +233,7 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
>>   	 * we account it too.
>>   	 */
>>   	if (!(gfp & (__GFP_HIGHMEM | __GFP_MOVABLE | __GFP_IO | __GFP_FS)))
>
> I wonder if we want to let kernel users to specify the gfp mask here? The
> current mask is good for userspace notifications, but in-kernel users
> might be interested in including (or excluding) different types of
> allocations, e.g. watch only for DMA allocations pressure?
>

That is outside of the scope of this patch anyway. For this one, if you 
believe it is good, could I have your tag? =)

But answering your question regardless of the scope, I believe the 
context of the allocation is an implementation detail of the kernel - 
regardless of how widely understood it is. The thing I like the most 
about your work, is precisely the fact that is hides the implementation 
details so well.

So unless there is a strong use case that would benefit from it, I am 
inclined to say this is not wanted.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
