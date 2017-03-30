From: "Huang\, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -mm -v7 2/9] mm, memcg: Support to charge/uncharge multiple swap entries
Date: Thu, 30 Mar 2017 08:53:50 +0800
Message-ID: <87k277twip.fsf@yhuang-dev.intel.com>
References: <20170328053209.25876-1-ying.huang@intel.com>
        <20170328053209.25876-3-ying.huang@intel.com>
        <20170329165722.GB31821@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=intel;
  t=1490835235; x=1522371235;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=HOhwSZ7SpOsTsiPCarG5CTTbLQJ32Wrxzq+3g/HgQLk=;
  b=Ht+/Brtk4DbYcDa5tQMPcnaBW4CFFDSS3oltpwZ78VXcTlzCL+KSvpU4
   imnggheLLNouHossN9I4PIesQ8EGvg==;
In-Reply-To: <20170329165722.GB31821-druUgvl0LCNAfugRpC6u6w@public.gmane.org> (Johannes Weiner's message
        of "Wed, 29 Mar 2017 12:57:22 -0400")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> writes:

> On Tue, Mar 28, 2017 at 01:32:02PM +0800, Huang, Ying wrote:
>> @@ -5908,16 +5907,19 @@ void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
>>  		css_put(&memcg->css);
>>  }
>>  
>> -/*
>> - * mem_cgroup_try_charge_swap - try charging a swap entry
>> +/**
>> + * mem_cgroup_try_charge_swap - try charging a set of swap entries
>>   * @page: page being added to swap
>> - * @entry: swap entry to charge
>> + * @entry: the first swap entry to charge
>> + * @nr_entries: the number of swap entries to charge
>>   *
>> - * Try to charge @entry to the memcg that @page belongs to.
>> + * Try to charge @nr_entries swap entries starting from @entry to the
>> + * memcg that @page belongs to.
>>   *
>>   * Returns 0 on success, -ENOMEM on failure.
>>   */
>> -int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry)
>> +int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry,
>> +			       unsigned int nr_entries)
>
> I've pointed this out before,

Yes.  And I have replied to your original comments too :-)

> but there doesn't seem to be a reason to
> pass @nr_entries when we have the struct page. Why can't this function
> just check PageTransHuge() by itself?

Because sometimes we need to charge one swap entry for a THP.  Please
take a look at the original add_to_swap() implementation.  For a THP,
one swap entry will be allocated and charged to the mem cgroup before
the THP is split.  And I think it is not easy to change this, because we
don't want to split THP if the mem cgroup for swap exceeds its limit.

Best Regards,
Huang, Ying
