From: "Haitao Huang" <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v4 15/18] x86/sgx: Prepare for multiple LRUs
Date: Fri, 15 Sep 2023 23:18:10 -0500
Message-ID: <op.2bcjkksxwjvjmi@hhuan26-mobl.amr.corp.intel.com>
References: <20230913040635.28815-1-haitao.huang@linux.intel.com>
 <20230913040635.28815-16-haitao.huang@linux.intel.com>
 <CVHWKO25RFOU.24Z5A88M1VZA1@suppilovahvero>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694837894; x=1726373894;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=wkm3rOxr4C9IPUoX1RTAJ+4N+SIgfrASdFwWlqgLlMw=;
  b=aQrm+SuB6OomIfeza++VE0vxqt06c5x5FMzK5cAb6ci2scqDW+a2uteJ
   9KHb1IgGua766JVDUNfL3QQ92U23D9JpZJ2DsN/zVLy8XERsRv6B2gYE5
   2D5IJbM3TyW9d+zLYC+Uv0DTzOOID8uEb5U/aueWDjVbaai6Og6guylRV
   N83sZwEGLUQeHz3LZadxRqYRV/EHI7etThXMImu8FhsYQEYNRTpfkVrM1
   ooKKhP4C7vXaB1sgbCrxClx6HWjYu/3EihRGlqePGBcnGjv8DLwzzaa9i
   c0wjGejEkOdlLglIdtmKcR/DrcJw6aDzBBgpftSQ+MVza+ZtGEfpCPlfK
   g==;
In-Reply-To: <CVHWKO25RFOU.24Z5A88M1VZA1@suppilovahvero>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"; delsp="yes"
To: dave.hansen@linux.intel.com, tj@kernel.org, linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, sohil.mehta@intel.com, Jarkko Sakkinen <jarkko@kernel.org>
Cc: zhiquan1.li@intel.com, kristen@linux.intel.com, seanjc@google.com, zhanb@microsoft.com, anakrish@microsoft.com, mikko.ylinen@linux.intel.com, yangjie@microsoft.com

On Wed, 13 Sep 2023 10:42:52 -0500, Jarkko Sakkinen <jarkko@kernel.org>  
wrote:

> On Wed Sep 13, 2023 at 7:06 AM EEST, Haitao Huang wrote:
>> Add sgx_can_reclaim() wrapper and encapsulate direct references to the
>> global LRU list in the reclaimer functions so that they can be called  
>> with
>> an LRU list per EPC cgroup.
>>
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
>> Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
>> Cc: Sean Christopherson <seanjc@google.com>
>> ---
>> V4:
>> - Re-organized this patch to include all changes related to
>> encapsulation of the global LRU
>> - Moved this patch to precede the EPC cgroup patch
>> ---
>>  arch/x86/kernel/cpu/sgx/main.c | 41 +++++++++++++++++++++++-----------
>>  1 file changed, 28 insertions(+), 13 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/sgx/main.c  
>> b/arch/x86/kernel/cpu/sgx/main.c
>> index ce316bd5e5bb..3d396fe5ec09 100644
>> --- a/arch/x86/kernel/cpu/sgx/main.c
>> +++ b/arch/x86/kernel/cpu/sgx/main.c
>> @@ -34,6 +34,16 @@ static DEFINE_XARRAY(sgx_epc_address_space);
>>   */
>>  static struct sgx_epc_lru_lists sgx_global_lru;
>>
>> +static inline struct sgx_epc_lru_lists *sgx_lru_lists(struct  
>> sgx_epc_page *epc_page)
>> +{
>> +	return &sgx_global_lru;
>> +}
>
> I'd simply export sgx_global_lru.
>
The purpose of this patch to to hide sgx_global_lru so later we can have  
LRU per cgroup.
I'll update the commit message to make it clear this is not just for   
sgx_can_reclaim

>> +static inline bool sgx_can_reclaim(void)
>> +{
>> +	return !list_empty(&sgx_global_lru.reclaimable);
>> +}
>
>
> Accessors for the object should be named so that this fact is reflected,
> e.g. sgx_global_lru_can_reclaim() in this case.
>
> I would just open code this to the call sites though.
>
ditto

Thanks
Haitao
