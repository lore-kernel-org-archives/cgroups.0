From: Martin Sebor <msebor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 02/11] x86: tboot: avoid Wstringop-overread-warning
Date: Mon, 22 Mar 2021 16:07:50 -0600
Message-ID: <b944a853-0e4b-b767-0175-cc2c1edba759@gmail.com>
References: <20210322160253.4032422-1-arnd@kernel.org>
 <20210322160253.4032422-3-arnd@kernel.org>
 <20210322202958.GA1955909@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bp6cadiLp9JG4ot8VD8DrNUhLvtl3tOiutuJ7QXWznQ=;
        b=iaV83Ux9xBDgj/qom3Bk+Pnnd+Npq2g7l2Wcj4hhm0C9/Wqa5sWw8p1Jsa6IVtm0yS
         TdIiUfQGXTD6NiCLV6NBiRXyZP2uVw+Q2q6lU7LXwrWQJ/Maefvj0xV0Uec18FcSeRXF
         vIJU9u5du1ZOWFtkZrF5/qMHCMqhC93pFGIqrrKl6XUhkAUrPxcx4X0Batpu84izU0rl
         6nUs9IEvPSvLgj3W8ej7UliIwlqDMHRm/QB8uQcgZsL5UpAnoTMEMr+Ed2fl6upuTDTk
         ++B/wzn6EYS99xzPoQfKZFL2om7c/ZVOPmZEz09Ms8KU+NvgtrohB8esdB1kDZFPOvri
         10Xw==
In-Reply-To: <20210322202958.GA1955909-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Martin Sebor <msebor-/MQLu3FmUzdAfugRpC6u6w@public.gmane.org>, Ning Sun <ning.sun-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Kalle Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Simon Kelley <simon-xn1N/tgparsycpQjotevgVpr/1R2p/CL@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "James E.J. Bottomley" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Anders Larsen <al-V9/YLgxv/GvR7s880joybQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Imre Deak <imre.deak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, tboot-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, ath11k-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-wireless-u79uwXL29TbrhsbdSgBK9A@public.gmane.org

On 3/22/21 2:29 PM, Ingo Molnar wrote:
> 
> * Arnd Bergmann <arnd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> 
>> From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
>>
>> gcc-11 warns about using string operations on pointers that are
>> defined at compile time as offsets from a NULL pointer. Unfortunately
>> that also happens on the result of fix_to_virt(), which is a
>> compile-time constant for a constantn input:
>>
>> arch/x86/kernel/tboot.c: In function 'tboot_probe':
>> arch/x86/kernel/tboot.c:70:13: error: '__builtin_memcmp_eq' specified bound 16 exceeds source size 0 [-Werror=stringop-overread]
>>     70 |         if (memcmp(&tboot_uuid, &tboot->uuid, sizeof(tboot->uuid))) {
>>        |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>
>> I hope this can get addressed in gcc-11 before the release.
>>
>> As a workaround, split up the tboot_probe() function in two halves
>> to separate the pointer generation from the usage. This is a bit
>> ugly, and hopefully gcc understands that the code is actually correct
>> before it learns to peek into the noinline function.
>>
>> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99578
>> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
>> ---
>>   arch/x86/kernel/tboot.c | 44 ++++++++++++++++++++++++-----------------
>>   1 file changed, 26 insertions(+), 18 deletions(-)
>>
>> diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
>> index 4c09ba110204..f9af561c3cd4 100644
>> --- a/arch/x86/kernel/tboot.c
>> +++ b/arch/x86/kernel/tboot.c
>> @@ -49,6 +49,30 @@ bool tboot_enabled(void)
>>   	return tboot != NULL;
>>   }
>>   
>> +/* noinline to prevent gcc from warning about dereferencing constant fixaddr */
>> +static noinline __init bool check_tboot_version(void)
>> +{
>> +	if (memcmp(&tboot_uuid, &tboot->uuid, sizeof(tboot->uuid))) {
>> +		pr_warn("tboot at 0x%llx is invalid\n", boot_params.tboot_addr);
>> +		return false;
>> +	}
>> +
>> +	if (tboot->version < 5) {
>> +		pr_warn("tboot version is invalid: %u\n", tboot->version);
>> +		return false;
>> +	}
>> +
>> +	pr_info("found shared page at phys addr 0x%llx:\n",
>> +		boot_params.tboot_addr);
>> +	pr_debug("version: %d\n", tboot->version);
>> +	pr_debug("log_addr: 0x%08x\n", tboot->log_addr);
>> +	pr_debug("shutdown_entry: 0x%x\n", tboot->shutdown_entry);
>> +	pr_debug("tboot_base: 0x%08x\n", tboot->tboot_base);
>> +	pr_debug("tboot_size: 0x%x\n", tboot->tboot_size);
>> +
>> +	return true;
>> +}
>> +
>>   void __init tboot_probe(void)
>>   {
>>   	/* Look for valid page-aligned address for shared page. */
>> @@ -66,25 +90,9 @@ void __init tboot_probe(void)
>>   
>>   	/* Map and check for tboot UUID. */
>>   	set_fixmap(FIX_TBOOT_BASE, boot_params.tboot_addr);
>> -	tboot = (struct tboot *)fix_to_virt(FIX_TBOOT_BASE);
>> -	if (memcmp(&tboot_uuid, &tboot->uuid, sizeof(tboot->uuid))) {
>> -		pr_warn("tboot at 0x%llx is invalid\n", boot_params.tboot_addr);
>> +	tboot = (void *)fix_to_virt(FIX_TBOOT_BASE);
>> +	if (!check_tboot_version())
>>   		tboot = NULL;
>> -		return;
>> -	}
>> -	if (tboot->version < 5) {
>> -		pr_warn("tboot version is invalid: %u\n", tboot->version);
>> -		tboot = NULL;
>> -		return;
>> -	}
>> -
>> -	pr_info("found shared page at phys addr 0x%llx:\n",
>> -		boot_params.tboot_addr);
>> -	pr_debug("version: %d\n", tboot->version);
>> -	pr_debug("log_addr: 0x%08x\n", tboot->log_addr);
>> -	pr_debug("shutdown_entry: 0x%x\n", tboot->shutdown_entry);
>> -	pr_debug("tboot_base: 0x%08x\n", tboot->tboot_base);
>> -	pr_debug("tboot_size: 0x%x\n", tboot->tboot_size);
> 
> This is indeed rather ugly - and the other patch that removes a debug
> check seems counterproductive as well.
> 
> Do we know how many genuine bugs -Wstringop-overread-warning has
> caught or is about to catch?
> 
> I.e. the real workaround might be to turn off the -Wstringop-overread-warning,
> until GCC-11 gets fixed?

In GCC 10 -Wstringop-overread is a subset of -Wstringop-overflow.
GCC 11 breaks it out as a separate warning to make it easier to
control.  Both warnings have caught some real bugs but they both
have a nonzero rate of false positives.  Other than bug reports
we don't have enough data to say what their S/N ratio might be
but my sense is that it's fairly high in general.

   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=wstringop-overread
   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=wstringop-overflow

In GCC 11, all access warnings expect objects to be either declared
or allocated.  Pointers with constant values are taken to point to
nothing valid (as Arnd mentioned above, this is to detect invalid
accesses to members of structs at address zero).

One possible solution to the known address problem is to extend GCC
attributes address and io that pin an object to a hardwired address
to all targets (at the moment they're supported on just one or two
targets).  I'm not sure this can still happen before GCC 11 releases
sometime in April or May.

Until then, another workaround is to convert the fixed address to
a volatile pointer before using it for the access, along the lines
below.  It should have only a negligible effect on efficiency.

diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index 4c09ba110204..76326b906010 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -67,7 +67,9 @@ void __init tboot_probe(void)
         /* Map and check for tboot UUID. */
         set_fixmap(FIX_TBOOT_BASE, boot_params.tboot_addr);
         tboot = (struct tboot *)fix_to_virt(FIX_TBOOT_BASE);
-       if (memcmp(&tboot_uuid, &tboot->uuid, sizeof(tboot->uuid))) {
+       if (memcmp(&tboot_uuid,
+                  (*(struct tboot* volatile *)(&tboot))->uuid,
+                  sizeof(tboot->uuid))) {
                 pr_warn("tboot at 0x%llx is invalid\n", 
boot_params.tboot_addr);
                 tboot = NULL;
                 return;

Martin

> 
> Thanks,
> 
> 	Ingo
> 

