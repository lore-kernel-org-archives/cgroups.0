From: "Haitao Huang" <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v4 01/18] cgroup/misc: Add per resource callbacks for CSS
 events
Date: Fri, 15 Sep 2023 20:27:06 -0500
Message-ID: <op.2bcbngvpwjvjmi@hhuan26-mobl.amr.corp.intel.com>
References: <20230913040635.28815-1-haitao.huang@linux.intel.com>
 <20230913040635.28815-2-haitao.huang@linux.intel.com>
 <ZQSaoXBg-X4cwFdX@mtj.duckdns.org> <ZQSbM9ItXVyeIU7F@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694827630; x=1726363630;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=LSZ/Ims3Q2WIrfyaa9TBJMUmtRfQrZWhfLJol4CcGBY=;
  b=ZryqysY/1oiPe9J8CU+PFqvz3Ck8IETEaBf6jC9Mvt4JwsvLrULNivj8
   GvDstGNU/5so3AQ3+iYt5ZDDGnYnoxpnxUahtdOkzkrvbcMD5HpDOmL0X
   ObcsUcSeDlYL4qV/J7j6ZdjK+P2lcVWH7krzIlM2dtVXTvWj9Oiwu/ZJ2
   e1HvLCRfq75XXLCZvdzW95M5bwfHs3Sf+AeB0Mh0XFISI3UOpGvEq4wnC
   NveIir9QWgt0ZuLLkLVhvMTrb9Vbs+W3mT69r8p2Sw/MhTORW1DU6HYQi
   f8bUHgH5aqZZVutPw/uOiRwlcGniMVqMuln2xPrIT/RAF/YwDRn7uavdc
   w==;
In-Reply-To: <ZQSbM9ItXVyeIU7F@mtj.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"; delsp="yes"
To: Tejun Heo <tj@kernel.org>
Cc: jarkko@kernel.org, dave.hansen@linux.intel.com, linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, sohil.mehta@intel.com, zhiquan1.li@intel.com, kristen@linux.intel.com, seanjc@google.com, zhanb@microsoft.com, anakrish@microsoft.com, mikko.ylinen@linux.intel.com, yangjie@microsoft.com

On Fri, 15 Sep 2023 12:58:11 -0500, Tejun Heo <tj@kernel.org> wrote:

> On Fri, Sep 15, 2023 at 07:55:45AM -1000, Tejun Heo wrote:
>> On Tue, Sep 12, 2023 at 09:06:18PM -0700, Haitao Huang wrote:
>> > @@ -37,6 +37,11 @@ struct misc_res {
>> >  	u64 max;
>> >  	atomic64_t usage;
>> >  	atomic64_t events;
>> > +
>> > +	/* per resource callback ops */
>> > +	int (*misc_cg_alloc)(struct misc_cg *cg);
>> > +	void (*misc_cg_free)(struct misc_cg *cg);
>> > +	void (*misc_cg_max_write)(struct misc_cg *cg);
>>
>> A nit about naming. These are already in misc_res and cgroup_ and cgrp_
>> prefixes are a lot more common. So, maybe go for sth like cgrp_alloc?
>
> Ah, never mind about the prefix part. misc is using cg_ prefix widely
> already.
>


Change them to plain alloc, free, max_write? As they are per resource  
type, not per cgroup.
Also following no-prefix naming scheme like "open" for fops, vma_ops, etc.

Thanks for your review.

Haitao
