From: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Wed, 06 Apr 2022 08:48:47 +0800
Message-ID: <87o81fujdc.fsf@yhuang6-desk2.ccr.corp.intel.com>
References: <20220331084151.2600229-1-yosryahmed@google.com>
        <YkcEMdsi9G5y8mX4@dhcp22.suse.cz>
        <CAAPL-u_i-Mp-Bo7LtP_4aJscY=1JHG_y1H_-A7N_HRAgtz+arg@mail.gmail.com>
        <87y20nzyw4.fsf@yhuang6-desk2.ccr.corp.intel.com>
        <CAAPL-u8wjtBRE7KZyZjoQ0eTJecnW35uEXAE3KU0M+AvL=5-ug@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649206134; x=1680742134;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=JVq/0q1U8J0tjQQNcPkukCTp/eQviHcDu+kC6AMz/cE=;
  b=HPGRRLp4tR/ry/OLh+j36AyaN/1iKfQZ7peezzax2zeFm+qeXjaTYIsr
   1kP0MjoA0pgxla7EPRJNL725H0kQDtjrDse+OAoF9AkkYm9FUjp/KiWsL
   6U3LtmwLSBsL2TcUPexWaGukl6fNfQBTpojry7PjoKjIMJpGOsTJv35nv
   MYCPUS9ctizUosSQOHjeKK+oZrbuNOnFqAOb50if1U3euXsga7HIqN+4t
   IP+vHmP3j2712HgE4dMk7MZc0Q/Y/gcUTM5c5kfa+bp3Md4Bym8VHyY6M
   +fdE53QucJbPfETX/NbtONMreqtO6qxXjny7NacfgloW8HbD4AcuEZcF3
   Q==;
In-Reply-To: <CAAPL-u8wjtBRE7KZyZjoQ0eTJecnW35uEXAE3KU0M+AvL=5-ug@mail.gmail.com>
        (Wei Xu's message of "Sat, 2 Apr 2022 23:56:19 -0700")
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Xu <weixugc@google.com>
Cc: Michal Hocko <mhocko@suse.com>, Yosry Ahmed <yosryahmed@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Roman Gushchin <roman.gushchin@linux.dev>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Jonathan Corbet <corbet@lwn.net>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Greg Thelen <gthelen@google.com>

Wei Xu <weixugc@google.com> writes:

> On Sat, Apr 2, 2022 at 1:13 AM Huang, Ying <ying.huang@intel.com> wrote:
>>
>> Wei Xu <weixugc@google.com> writes:
>>
>> > On Fri, Apr 1, 2022 at 6:54 AM Michal Hocko <mhocko@suse.com> wrote:
>> >>
>> >> On Thu 31-03-22 08:41:51, Yosry Ahmed wrote:
>> >> > From: Shakeel Butt <shakeelb@google.com>
>> >> >
>>
>> [snip]
>>
>> >> > Possible Extensions:
>> >> > --------------------
>> >> >
>> >> > - This interface can be extended with an additional parameter or flags
>> >> >   to allow specifying one or more types of memory to reclaim from (e.g.
>> >> >   file, anon, ..).
>> >> >
>> >> > - The interface can also be extended with a node mask to reclaim from
>> >> >   specific nodes. This has use cases for reclaim-based demotion in memory
>> >> >   tiering systens.
>> >> >
>> >> > - A similar per-node interface can also be added to support proactive
>> >> >   reclaim and reclaim-based demotion in systems without memcg.
>> >> >
>> >> > For now, let's keep things simple by adding the basic functionality.
>> >>
>> >> Yes, I am for the simplicity and this really looks like a bare minumum
>> >> interface. But it is not really clear who do you want to add flags on
>> >> top of it?
>> >>
>> >> I am not really sure we really need a node aware interface for memcg.
>> >> The global reclaim interface will likely need a different node because
>> >> we do not want to make this CONFIG_MEMCG constrained.
>> >
>> > A nodemask argument for memory.reclaim can be useful for memory
>> > tiering between NUMA nodes with different performance.  Similar to
>> > proactive reclaim, it can allow a userspace daemon to drive
>> > memcg-based proactive demotion via the reclaim-based demotion
>> > mechanism in the kernel.
>>
>> I am not sure whether nodemask is a good way for demoting pages between
>> different types of memory.  For example, for a system with DRAM and
>> PMEM, if specifying DRAM node in nodemask means demoting to PMEM, what
>> is the meaning of specifying PMEM node? reclaiming to disk?
>>
>> In general, I have no objection to the idea in general.  But we should
>> have a clear and consistent interface.  Per my understanding the default
>> memcg interface is for memory, regardless of memory types.  The memory
>> reclaiming means reduce the memory usage, regardless of memory types.
>> We need to either extending the semantics of memory reclaiming (to
>> include memory demoting too), or add another interface for memory
>> demoting.
>
> Good point.  With the "demote pages during reclaim" patch series,
> reclaim is already extended to demote pages as well.  For example,
> can_reclaim_anon_pages() returns true if demotion is allowed and
> shrink_page_list() can demote pages instead of reclaiming pages.

These are in-kernel implementation, not the ABI.  So we still have
the opportunity to define the ABI now.

> Currently, demotion is disabled for memcg reclaim, which I think can
> be relaxed and also necessary for memcg-based proactive demotion.  I'd
> like to suggest that we extend the semantics of memory.reclaim to
> cover memory demotion as well.  A flag can be used to enable/disable
> the demotion behavior.

If so,

# echo A > memory.reclaim

means

a) "A" bytes memory are freed from the memcg, regardless demoting is
   used or not.

or

b) "A" bytes memory are reclaimed from the memcg, some of them may be
   freed, some of them may be just demoted from DRAM to PMEM.  The total
   number is "A".

For me, a) looks more reasonable.

Best Regards,
Huang, Ying

