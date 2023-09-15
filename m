From: "Haitao Huang" <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v4 03/18] x86/sgx: Add sgx_epc_lru_lists to encapsulate
 LRU lists
Date: Fri, 15 Sep 2023 11:28:28 -0500
Message-ID: <op.2bbmpqncwjvjmi@hhuan26-mobl.amr.corp.intel.com>
References: <20230913040635.28815-1-haitao.huang@linux.intel.com>
 <20230913040635.28815-4-haitao.huang@linux.intel.com>
 <851f9b3043732c17cd8f86a77ccee0b7c6caa22f.camel@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694795318; x=1726331318;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=cj9l7n2Bmb5XcYMcAhASPfEHm9/0gmYiOFma5VsXwGU=;
  b=MzFaLDBa+DuoIw3OwezMGLM0QNB+PCgUYfIHVyv5pH+iGEiTqMn/lGqi
   nmWDOWhMiRQtu3dOzyuuI2L9pHm1FpkAdd7Li/XG3ws0FYZciGeOmpb4p
   IT3TfIvujsF1XvIt4OaZP9n0qhIuiILFbhmB/jTbGt63+2eD2eK3U00SA
   isllENiclTUZcGsnBSsUB4+ZSPKwpnworVDmB7cWwLc7c2JXpN7KaPLnH
   N7Gcv1edFhFyArbsnp8tF6e543DRQ7DrM86evj17R58y+XTYsGR/54+wq
   tjgqsMkHNOoXqBRrNB4D8NYIernupCDUJPW65sOXnBbWg9uYMnLzqgEri
   g==;
In-Reply-To: <851f9b3043732c17cd8f86a77ccee0b7c6caa22f.camel@intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"; delsp="yes"
To: "hpa@zytor.com" <hpa@zytor.com>, "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "bp@alien8.de" <bp@alien8.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jarkko@kernel.org" <jarkko@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "Mehta, Sohil" <sohil.mehta@intel.com>, "tj@kernel.org" <tj@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "Huang, Kai" <kai.huang@intel.com>
Cc: "kristen@linux.intel.com" <kristen@linux.intel.com>, "yangjie@microsoft.com" <yangjie@microsoft.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Christopherson,, Sean" <seanjc@google.com>, "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>, "Zhang, Bo" <zhanb@microsoft.com>, "anakrish@microsoft.com" <anakrish@microsoft.com>

On Thu, 14 Sep 2023 05:31:30 -0500, Huang, Kai <kai.huang@intel.com> wrote:

> Some non-technical staff:
>
> On Tue, 2023-09-12 at 21:06 -0700, Haitao Huang wrote:
>> From: Kristen Carlson Accardi <kristen@linux.intel.com>
>
> The patch was from Kristen, but ...
>
>>
>> Introduce a data structure to wrap the existing reclaimable list and its
>> spinlock. Each cgroup later will have one instance of this structure to
>> track EPC pages allocated for processes associated with the same cgroup.
>> Just like the global SGX reclaimer (ksgxd), an EPC cgroup reclaims pages
>> from the reclaimable list in this structure when its usage reaches near
>> its limit.
>>
>> Currently, ksgxd does not track the VA, SECS pages. They are considered
>> as 'unreclaimable' pages that are only deallocated when their respective
>> owning enclaves are destroyed and all associated resources released.
>>
>> When an EPC cgroup can not reclaim any more reclaimable EPC pages to
>> reduce its usage below its limit, the cgroup must also reclaim those
>> unreclaimables by killing their owning enclaves. The VA and SECS pages
>> later are also tracked in an 'unreclaimable' list added to this  
>> structure
>> to support this OOM killing of enclaves.
>>
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
>
> ... it was firstly signed by Sean and then Kristen, which doesn't sound  
> right.
>
> If the patch was from Kristen, then either Sean's SoB should come after
> Kristen's (which means Sean took Kristen's patch and signed it), or you  
> need to
> have a Co-developed-by tag for Sean right before his SoB (which  
> indicates Sean
> participated in the development of the patch but likely he wasn't the  
> main
> developer).
>
> But I _guess_ the patch was just from Sean.
>
 From what I see:
In v1 kristen included a "From" tsg for Sean. In v2 she split the original  
patch into two and added some wrappers/ At that time, she removed the  
"From" tag for both patches but kept the SOB and CC.

@Kristen, could you confirm?

I only removed the wrappers from v2 based on Dave's comments.
So if confirmed by Kristen, should we add "From" tag for Sean?

I'll double check the other patches.
Thanks
Haitao
