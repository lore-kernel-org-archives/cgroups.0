From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v10 1/4] cgroups: use bitmask to filter for_each_subsys
Date: Mon, 27 Apr 2015 02:05:47 +1000
Message-ID: <CAOviyagvVTKjRp4wxyNo4Oke-w=Wbda+UyHAN-ih9yFX-8jqmw@mail.gmail.com>
References: <1429446154-10660-1-git-send-email-cyphar@cyphar.com>
	<1429446154-10660-2-git-send-email-cyphar@cyphar.com>
	<20150422152551.GA10738@htj.duckdns.org>
	<20150422154212.GE3007@worktop.Skamania.guest>
	<20150422160258.GE10738@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150422160258.GE10738@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, lizefan@huawei.com, mingo@redhat.com, richard@nod.at, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hey,

>> > >  static struct cftype cgroup_dfl_base_files[];
>> > > +#define for_each_subsys_which(ss_mask, ss, ssid) \
>> > > + for_each_subsys((ss), (ssid)) \
>> > > +         if ((ss_mask) & (1 << (ssid)))
>> >
>> > Maybe using for_each_set_bit() is better?
>> >
>> > #define for_each_subsys_which(ss_mask, ss, ssid)            \
>> >     for_each_set_bit(ssid, &(ss_mask), CGROUP_SUBSYS_COUNT) \
>> >             if ((ss) = group_subsys[ssid] && false)         \
>> >                     ;                                       \
>> >             else
>>
>> Clever that ;-)
>
> Thanks.  It kinda bothers me that for_each_set_bit() doesn't collapse
> to combo of ffs() + clearing bit off of a temp mask when size is const
> and <= ulong, which would be quite a bit lighter.  Right now it'd be
> calling into generic find_first/next_bit() functions unconditionally.
> Ah well, it can be optimized later.

This macro causes issues with lines like:
   for_each_subsys_which(ss, ssid, ~cgrp_dfl_root_inhibit_ss_mask)

In addition, there are a bunch of cgroup_* functions that use unsigned
ints for bitops (cgroup_calc_child_subsys_mask, rebind_subsystems,
cgroup_print_ss_mask). Is there a better solution to this problem, or
should I just switch back to my naive solution?

--
Aleksa Sarai (cyphar)
www.cyphar.com
