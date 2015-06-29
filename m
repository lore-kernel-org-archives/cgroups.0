From: nick <xerofoify@gmail.com>
Subject: Re: [PATCH] mm:Make the function alloc_mem_cgroup_per_zone_info bool
Date: Mon, 29 Jun 2015 11:50:27 -0400
Message-ID: <55916943.50402@gmail.com>
References: <1435587233-27976-1-git-send-email-xerofoify@gmail.com> <20150629150311.GC4612@dhcp22.suse.cz> <3320C010-248A-4296-A5E4-30D9E7B3E611@gmail.com> <20150629153623.GC4617@dhcp22.suse.cz> <559167D8.80803@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=P9XrD69yKbuwDSMv1pGGG4XYzV8ixDEIktCfuDEHd1I=;
        b=JLi4dy7IRPyB9p9jqr3KoUnED/58AIaWxsYiq/iRJJp1Z42gyLFjh6dtmcH2FD7gu8
         ZxEOfPZt+iVF/WvLJzLiXmPq9EBI371yE0YvK5oRESwtiXnJ0OGsFML+4KXqZZZ5jnCO
         59KCcAL+ZmXRsHjYVsuaFQocB40bUFG9t1IRYFr7p69Rq95tXjM86GAIdff9TGMkpjPp
         fB4RJ0yIEnkNF92UkQl8j6epfLFqOWCq7Vue+6DKLtxyYCfMetiMPOvb0vKl1HfP+VBW
         lITq2f33Dzzz7YaDskXb2RiUDWTaxKVp02Yv/OZrzBRyePZ8Qbl9Avz4GqzuuqM+31Bu
         sk+g==
In-Reply-To: <559167D8.80803@gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@suse.cz>
Cc: hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org



On 2015-06-29 11:44 AM, nick wrote:
> 
> 
> On 2015-06-29 11:36 AM, Michal Hocko wrote:
>> On Mon 29-06-15 11:23:08, Nicholas Krause wrote:
>> [...]
>>> I agree with and looked into the callers about this wasn't sure if you
>>> you wanted me to return - ENOMEM.  I will rewrite this patch the other
>>> way. 
>>
>> I am not sure this path really needs a cleanup.
>>
>>> Furthermore I apologize about this and do have actual useful
>>> patches but will my rep it's hard to get replies from maintainers.
>>
>> You can hardly expect somebody will be thrilled about your patches when
>> their fault rate is close to 100%. Reviewing each patch takes time and
>> that is a scarce resource. If you want people to follow your patches
>> make sure you are offering something that might be interesting or
>> useful. Cleanups like these usually are not interesting without
>> either building something bigger on top of them or when they improve
>> readability considerably.
>>
>> [...]
>>
> Actually my patch record is much better now it's at the worst case 60% are correct and 40 % are not
> and this based on the few that have been merged. Here is a patch series I have been trying to merge
> for a bug in the gma500 other the last few patches. There are other patches I have like this lying
> around.
> Nick 
> 
> From 2d2ddb5d9a2c4fcbae45339d4f775fcde49f36e1 Mon Sep 17 00:00:00 2001
> From: Nicholas Krause <xerofoify@gmail.com>
> Date: Wed, 13 May 2015 21:36:44 -0400
> Subject: [PATCH 1/2] gma500:Add proper use of the variable ret for the
>  function, psb_mmu_inset_pfn_sequence
> 
> This adds proper use of the variable ret by returning it
> at the end of the function, psb_mmu_inset_pfn_sequence for
> indicating to callers when an error has occurred. Further
> more remove the unneeded double setting of ret to the error
> code, -ENOMEM after checking if a call to the function,
> psb_mmu_pt_alloc_map_lock is successful.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/gpu/drm/gma500/mmu.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/gma500/mmu.c b/drivers/gpu/drm/gma500/mmu.c
> index 0eaf11c..d2c4bac 100644
> --- a/drivers/gpu/drm/gma500/mmu.c
> +++ b/drivers/gpu/drm/gma500/mmu.c
> @@ -677,10 +677,9 @@ int psb_mmu_insert_pfn_sequence(struct psb_mmu_pd *pd, uint32_t start_pfn,
>  	do {
>  		next = psb_pd_addr_end(addr, end);
>  		pt = psb_mmu_pt_alloc_map_lock(pd, addr);
> -		if (!pt) {
> -			ret = -ENOMEM;
> +		if (!pt)
>  			goto out;
> -		}
> +
>  		do {
>  			pte = psb_mmu_mask_pte(start_pfn++, type);
>  			psb_mmu_set_pte(pt, addr, pte);
> @@ -700,7 +699,7 @@ out:
>  	if (pd->hw_context != -1)
>  		psb_mmu_flush(pd->driver);
>  
> -	return 0;
> +	return ret;
>  }
>  
>  int psb_mmu_insert_pages(struct psb_mmu_pd *pd, struct page **pages,
> 
Sorry the second patch in the drm was the wrong one this was another patch I am lying around.
Below is the actual second patch for the bug fix.
Nick
From f1802ff61ef69ff9ecaaeadb941d4ed725a0255a Mon Sep 17 00:00:00 2001
From: Nicholas Krause <xerofoify@gmail.com>
Date: Fri, 22 May 2015 23:10:49 -0400
Subject: [PATCH 2/2] gma500: Add new error checking for the function, psb_driver_load

This adds new error checking to the function, psb_driver_load
for when the function, psb_mmu_inset_pfn_sequence fails to grab
memory for the internal function call to psb_pd_addr_end. In
addition we now implement this by checking for a error code
return  value from the internal call to the function,
psb_mmu_inset_pfn_sequence for the function, psb_driver_load.
If a error code is returned we must jump to a new label,
unlock_err in order to deallocate our usage count by
one for the usage of the semaphore, sem before unloading
the drm_device structure and returning a error code.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/gpu/drm/gma500/psb_drv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/gma500/psb_drv.c b/drivers/gpu/drm/gma500/psb_drv.c
index 92e7e57..4cef2c9 100644
--- a/drivers/gpu/drm/gma500/psb_drv.c
+++ b/drivers/gpu/drm/gma500/psb_drv.c
@@ -343,6 +343,8 @@ static int psb_driver_load(struct drm_device *dev, unsigned long flags)
 					  dev_priv->stolen_base >> PAGE_SHIFT,
 					  pg->gatt_start,
 					  pg->stolen_size >> PAGE_SHIFT, 0);
+	if (ret)
+		goto unlock_err;
 	up_read(&pg->sem);
 
 	psb_mmu_set_pd_context(psb_mmu_get_default_pd(dev_priv->mmu), 0);
@@ -405,6 +407,8 @@ static int psb_driver_load(struct drm_device *dev, unsigned long flags)
 #endif
 	/* Intel drm driver load is done, continue doing pvr load */
 	return 0;
+unlock_err:
+	up_read(&pg->sem);
 out_err:
 	psb_driver_unload(dev);
 	return ret;
-- 
2.1.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
