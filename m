From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH REBASED] mm, memcg: Make scan aggression always exclude
 protection
Date: Fri, 31 May 2019 12:27:40 -0700
Message-ID: <20190531192740.GA286159@chrisdown.name>
References: <20190228213050.GA28211@chrisdown.name>
 <20190322160307.GA3316@chrisdown.name>
 <20190530061221.GA6703@dhcp22.suse.cz>
 <20190530064453.GA110128@chrisdown.name>
 <20190530065111.GC6703@dhcp22.suse.cz>
 <20190530205210.GA165912@chrisdown.name>
 <20190531062854.GG6896@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3oPC7MpGNkmIv4lC37rTS0RoLjGGQjB5vfa5jgin/Xo=;
        b=SbI05ChMOHpTulNwmjhSR5ZbY9idO2IxEcT87P8CRpkS49RpLitZ6wSoqJeEdL1yVK
         cww6Si5nneZ2edimkGsX9/iIsmxdqDJDY5OVjkYb730pjSBbLnqr5fWiePVGdfkZ6x8p
         K2nnnRVs/YngzaK04SXScheJ4pWXrpnvyJLow=
Content-Disposition: inline
In-Reply-To: <20190531062854.GG6896@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

Michal Hocko writes:
>On Thu 30-05-19 13:52:10, Chris Down wrote:
>> Michal Hocko writes:
>> > On Wed 29-05-19 23:44:53, Chris Down wrote:
>> > > Michal Hocko writes:
>> > > > Maybe I am missing something so correct me if I am wrong but the new
>> > > > calculation actually means that we always allow to scan even min
>> > > > protected memcgs right?
>> > >
>> > > We check if the memcg is min protected as a precondition for coming into
>> > > this function at all, so this generally isn't possible. See the
>> > > mem_cgroup_protected MEMCG_PROT_MIN check in shrink_node.
>> >
>> > OK, that is the part I was missing, I got confused by checking the min
>> > limit as well here. Thanks for the clarification. A comment would be
>> > handy or do we really need to consider min at all?
>>
>> You mean as part of the reclaim pressure calculation? Yeah, we still need
>> it, because we might only set memory.min, but not set memory.low.
>
>But then the memcg will get excluded as well right?

I'm not sure what you mean, could you clarify? :-)

The only thing we use memory.min for in this patch is potentially as the 
protection size, which we then use to determine reclaim pressure. We don't use 
this information if the cgroup is below memory.min, because you'll never come 
in here. This is for if you *do* have memory.min or memory.low set and you are 
*exceeding* it (or we are in low reclaim), in which case we want it (or 
memory.low if higher) considered as the protection size.
