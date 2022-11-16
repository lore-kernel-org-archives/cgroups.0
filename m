From: Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/26] x86/sgx: Call cond_resched() at the end of
 sgx_reclaim_pages()
Date: Tue, 15 Nov 2022 17:00:08 -0800
Message-ID: <a4eb5ab0-bf83-17a4-8bc0-a90aaf438a8e@intel.com>
References: <20221111183532.3676646-1-kristen@linux.intel.com>
 <20221111183532.3676646-2-kristen@linux.intel.com>
 <Y3QgZ+ZKAfJ92U5L@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668560427; x=1700096427;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QXTMzqqZDlGjkoTzfjYcmLuBmOWujGrc3tQIGgZRAH0=;
  b=Lb3Xp391zDwO8OZW7Wf6CZeqXEXhghkaAUu70amTgAQDChrxksIAJczf
   wJr3qJjYXxX89XA1u5S9wYCkRZ+WUnAmOh8QgInn0PjYA1Ca6Ppyq6lUk
   izjP7ZtCsii4vdB9Ge5QEjcePH/cJtmMGwRNxKY4CjVfmrlnBjTvoMyPw
   7ax0rzvX04VJPb0GPMzdt3WWmzPxd3p2OVU5duASm+JdcWb6TYs1jrdvb
   D0edoCMpsUPrGDmhHpkoEYtQfT1rBSNEt9rlGIEHSsz0ldWtJ91I3N9Sz
   aODUngbtCdKK6tBAZGYYhjKi9J5bqxF4GVUh8TA2QMKQ9ECTYO/CuByn3
   w==;
Content-Language: en-US
In-Reply-To: <Y3QgZ+ZKAfJ92U5L-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dave.hansen-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hi Jarkko,

On 11/15/2022 3:27 PM, Jarkko Sakkinen wrote:
> On Fri, Nov 11, 2022 at 10:35:06AM -0800, Kristen Carlson Accardi wrote:
>> From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> In order to avoid repetition of cond_resched() in ksgxd() and
>> sgx_alloc_epc_page(), move the invocation of post-reclaim cond_resched()
>> inside sgx_reclaim_pages(). Except in the case of sgx_reclaim_direct(),
>> sgx_reclaim_pages() is always called in a loop and is always followed
>> by a call to cond_resched().  This will hold true for the EPC cgroup
>> as well, which adds even more calls to sgx_reclaim_pages() and thus
>> cond_resched(). Calls to sgx_reclaim_direct() may be performance
>> sensitive. Allow sgx_reclaim_direct() to avoid the cond_resched()
>> call by moving the original sgx_reclaim_pages() call to
>> __sgx_reclaim_pages() and then have sgx_reclaim_pages() become a
>> wrapper around that call with a cond_resched().
>>
>> Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>> Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> ---
>>  arch/x86/kernel/cpu/sgx/main.c | 17 +++++++++++------
>>  1 file changed, 11 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
>> index 160c8dbee0ab..ffce6fc70a1f 100644
>> --- a/arch/x86/kernel/cpu/sgx/main.c
>> +++ b/arch/x86/kernel/cpu/sgx/main.c
>> @@ -287,7 +287,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
>>   * problematic as it would increase the lock contention too much, which would
>>   * halt forward progress.
>>   */
>> -static void sgx_reclaim_pages(void)
>> +static void __sgx_reclaim_pages(void)
>>  {
>>  	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN];
>>  	struct sgx_backing backing[SGX_NR_TO_SCAN];
>> @@ -369,6 +369,12 @@ static void sgx_reclaim_pages(void)
>>  	}
>>  }
>>  
>> +static void sgx_reclaim_pages(void)
>> +{
>> +	__sgx_reclaim_pages();
>> +	cond_resched();
>> +}
>> +
>>  static bool sgx_should_reclaim(unsigned long watermark)
>>  {
>>  	return atomic_long_read(&sgx_nr_free_pages) < watermark &&
>> @@ -378,12 +384,14 @@ static bool sgx_should_reclaim(unsigned long watermark)
>>  /*
>>   * sgx_reclaim_direct() should be called (without enclave's mutex held)
>>   * in locations where SGX memory resources might be low and might be
>> - * needed in order to make forward progress.
>> + * needed in order to make forward progress. This call to
>> + * __sgx_reclaim_pages() avoids the cond_resched() in sgx_reclaim_pages()
>> + * to improve performance.
>>   */
>>  void sgx_reclaim_direct(void)
>>  {
>>  	if (sgx_should_reclaim(SGX_NR_LOW_PAGES))
>> -		sgx_reclaim_pages();
>> +		__sgx_reclaim_pages();
> 
> Is it a big deal to have "extra" cond_resched?
> 

sgx_reclaim_direct() is used to ensure that there is enough
SGX memory available to make forward progress within a loop that
may span a large range of pages. sgx_reclaim_direct()
ensures that there is enough memory right before it depends on
that available memory. I think that giving other tasks an opportunity
to run in the middle is risky since these other tasks may end
up consuming the SGX memory that was just freed up and thus increase
likelihood of the operation to fail with user getting an EAGAIN error.
Additionally, in a constrained environment where sgx_reclaim_direct()
is needed to reclaim pages an additional cond_resched() could cause
user visible slow down when operating on a large memory range. 

Reinette
