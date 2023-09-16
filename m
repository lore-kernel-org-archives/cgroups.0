From: "Haitao Huang" <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v4 01/18] cgroup/misc: Add per resource callbacks for CSS
 events
Date: Fri, 15 Sep 2023 23:11:24 -0500
Message-ID: <op.2bci9anpwjvjmi@hhuan26-mobl.amr.corp.intel.com>
References: <20230913040635.28815-1-haitao.huang@linux.intel.com>
 <20230913040635.28815-2-haitao.huang@linux.intel.com>
 <CVHOU5G1SCUT.RCBVZ3W8G2NJ@suppilovahvero>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694837487; x=1726373487;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=Ocjm2Eh/KArqUPzrkBFSGZbna2Rd/Mr3+qd+5IcYzMg=;
  b=hm53PeNLgISk7VJdD+DxIEMCA2h1q1e4JNWNyU6FVfDSHNGMainxQ/a0
   k7XRP+n7SD/l4PdsWPbdlbdY7Nlk0oOSrtJqrJpDF6Vx8VlBAor9Fuzq+
   e6ASLpo2DqmArUbLaUvXDo5SZountN8EmwvEv/AXLPpuaN5xm8sUazyiB
   A4tZNPBM4JkKMh+L2N5TU3JrqAsoZQMwi0R1kBoykZJQvUS1y1g32eoK3
   X/STtGaQJj5YXt+fhaykOt4IveiGPpP0/22jsY0yedWX3abxATiS8IMLa
   DglhymxuxkhfG9lPBlvySR29mnLUHWa9+A85+Cs2fBMNUuvmj3eJToqcU
   w==;
In-Reply-To: <CVHOU5G1SCUT.RCBVZ3W8G2NJ@suppilovahvero>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"; delsp="yes"
To: dave.hansen@linux.intel.com, tj@kernel.org, linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, sohil.mehta@intel.com, Jarkko Sakkinen <jarkko@kernel.org>
Cc: zhiquan1.li@intel.com, kristen@linux.intel.com, seanjc@google.com, zhanb@microsoft.com, anakrish@microsoft.com, mikko.ylinen@linux.intel.com, yangjie@microsoft.com

Hi Jarkko

On Wed, 13 Sep 2023 04:39:06 -0500, Jarkko Sakkinen <jarkko@kernel.org>  
wrote:

> On Wed Sep 13, 2023 at 7:06 AM EEST, Haitao Huang wrote:
>> From: Kristen Carlson Accardi <kristen@linux.intel.com>
>>
>> Consumers of the misc cgroup controller might need to perform separate
>> actions for Cgroups Subsystem State(CSS) events: cgroup alloc and free.
>
> nit: s/State(CSS)/State (CSS)/
>
> "cgroup alloc" and "cgroup free" mean absolutely nothing.
>
>
>> In addition, writes to the max value may also need separate action. Add
>
> What "the max value"?
>
>> the ability to allow downstream users to setup callbacks for these
>> operations, and call the corresponding per-resource-type callback when
>> appropriate.
>
> Who are "the downstream users" and what sort of callbacks they setup?

How about this?

The misc cgroup controller (subsystem) currently does not perform resource  
type specific action for Cgroups Subsystem State (CSS) events: the  
'css_alloc' event when a cgroup is created and the 'css_free' event when a  
cgroup is destroyed, or in event of user writing the max value to the  
misc.max file to set the consumption limit of a specific resource  
[admin-guide/cgroup-v2.rst, 5-9. Misc].

Define callbacks for those events and allow resource providers to register  
the callbacks per resource type as needed. This will be utilized later by  
the EPC misc cgroup support implemented in the SGX driver:
- On cgroup alloc, allocate and initialize necessary structures for EPC  
reclaiming, e.g., LRU list, work queue, etc.
- On cgroup free, cleanup and free those structures created in alloc.
- On max write, trigger EPC reclaiming if the new limit is at or below  
current consumption.

Thanks
Haitao

