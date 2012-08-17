From: Ying Han <yinghan@google.com>
Subject: Re: [PATCH v2 04/11] kmem accounting basic infrastructure
Date: Thu, 16 Aug 2012 22:58:21 -0700
Message-ID: <CALWz4izCbCgrera2qJoVaG4a6hhNYeejOw-m-f+pa5WBLr3=+Q@mail.gmail.com>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com>
	<1344517279-30646-5-git-send-email-glommer@parallels.com>
	<20120814162144.GC6905@dhcp22.suse.cz>
	<CALWz4iwgnqwq5k_zhpsiiwrj8Y=OkCUg7H96khJWPZScSQE=nw@mail.gmail.com>
	<20120816152543.GG2817@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:x-system-of-record;
        bh=1qbUgAh5hukCOaWR1pNvsR5zKRCCTJvtdHAQ+cPQG/Y=;
        b=oQZADQNyC16jqiebNa2K41RJgDU1vBmYt5mpBI0xLhVRPw5Y28PkUy+69hnP34g5Av
         HAzT7wlEo+96Loa+EB4l4WsIDU4VCt78f5z5iYfdItM5txyZPMo2gw7dp1DuQ17I1jxO
         j/7IPeu84HOKItbkHDKi3LzjbL4UxVPYHzUWde7ep+1sQKqjhY6U4ffMZGKDDjmuiweh
         W3bdQdVSGVmXFByYhCoi6a9Sxwb7GFzTsNi6AZr95KpMnWw6UAKgNplkpXn+Th2XrSOe
         M4GhdSh7HJ4ZG+h6lsQNbUNosA9QKqjsfOiYtZlMLaSlp0INfAW6lSLZ1YqB96V/iiGJ
         qSmg==
In-Reply-To: <20120816152543.GG2817@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, kamezawa.hiroyu@jp.fujitsu.com, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>

On Thu, Aug 16, 2012 at 8:25 AM, Michal Hocko <mhocko@suse.cz> wrote:
> On Wed 15-08-12 12:50:55, Ying Han wrote:
>> On Tue, Aug 14, 2012 at 9:21 AM, Michal Hocko <mhocko@suse.cz> wrote:
>> > On Thu 09-08-12 17:01:12, Glauber Costa wrote:
>> >> This patch adds the basic infrastructure for the accounting of the slab
>> >> caches. To control that, the following files are created:
>> >>
>> >>  * memory.kmem.usage_in_bytes
>> >>  * memory.kmem.limit_in_bytes
>> >>  * memory.kmem.failcnt
>> >>  * memory.kmem.max_usage_in_bytes
>> >>
>> >> They have the same meaning of their user memory counterparts. They
>> >> reflect the state of the "kmem" res_counter.
>> >>
>> >> The code is not enabled until a limit is set. This can be tested by the
>> >> flag "kmem_accounted". This means that after the patch is applied, no
>> >> behavioral changes exists for whoever is still using memcg to control
>> >> their memory usage.
>> >>
>> >> We always account to both user and kernel resource_counters. This
>> >> effectively means that an independent kernel limit is in place when the
>> >> limit is set to a lower value than the user memory. A equal or higher
>> >> value means that the user limit will always hit first, meaning that kmem
>> >> is effectively unlimited.
>> >
>> > Well, it contributes to the user limit so it is not unlimited. It just
>> > falls under a different limit and it tends to contribute less. This can
>> > be quite confusing.  I am still not sure whether we should mix the two
>> > things together. If somebody wants to limit the kernel memory he has to
>> > touch the other limit anyway.  Do you have a strong reason to mix the
>> > user and kernel counters?
>>
>> The reason to mix the two together is a compromise of the two use
>> cases we've heard by far. In google, we only need one limit which
>> limits u & k, and the reclaim kicks in when the total usage hits the
>> limit.
>>
>> > My impression was that kernel allocation should simply fail while user
>> > allocations might reclaim as well. Why should we reclaim just because of
>> > the kernel allocation (which is unreclaimable from hard limit reclaim
>> > point of view)?
>>
>> Some of kernel objects are reclaimable if we have per-memcg shrinker.
>
> Agreed and I think we need that before this is merged as I state in
> other email.
>
>> > I also think that the whole thing would get much simpler if those two
>> > are split. Anyway if this is really a must then this should be
>> > documented here.
>>
>> What would be the use case you have in your end?
>
> I do not have any specific unfortunately but I would like to prevent us
> from closing other possible. I realize this sounds hand wavy and that is
> why I do not want to block this work but I think we should give it some
> time before this gets merged.

Agreed that we don't want to rush merge anything.

On the other hand, I was trying to understand your concern of the k &
u+k counter. After reading your previous replies,
I think I understand your concern of missing the target shrinker. I
posted the patch and please take a look :)

Meanwhile, can you help to clarify other concerns in your mind on
having the two counters? Please ignore me if you answered
the question somewhere and just give me the pointer.

--Ying

>
>> --Ying
> --
> Michal Hocko
> SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
