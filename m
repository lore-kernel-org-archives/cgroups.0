From: Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC Patch 0/2] KVM: SVM: Cgroup support for SVM SEV ASIDs
Date: Fri, 27 Nov 2020 19:01:08 +0100
Message-ID: <d738731e-bda2-031c-c301-94e3cf6b5e44@de.ibm.com>
References: <20201124191629.GB235281@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+EzQmBcpDdFMQ0B4y+2SmyFO/YnTKNjLD5kNjjGWmbs=;
 b=Q72yuXrJALzbwKkcWDd+gjyS2Kj9jhnSnh2CyKGHXd7ez9VzdQUBO7zj7nufTrF+kJ76
 bQTU+bRrxgIX+FJS7wz90Ciqf3StPFX0/CNKdOSQdoc4GqGGv0hby+2zL5wdZ0kNB0zb
 xllt9OkXCdJKcJcgJKgnveVMp4H1fteGryF8AX3gdU7aQVJv5U/sRcl55j0vA3eB+WL+
 nA15n7Fg9qdjWMkNFtLSIFgTl0zO3S1vwnaduEqLijG3hhoqlNj4/zox6Hi1JjZwRx8Z
 kGcuqjCEdG0EVlWH0Oj+OqszCHm9hfAXGB2ziX4AUfREnEiEoE0VOoBSNmi8nHm+p4MC BQ== 
In-Reply-To: <20201124191629.GB235281-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Janosch Frank <frankja-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lendacky-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Thomas <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, Singh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Brijesh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Grimm-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Jon <jon.grimm-5C7GfCeVMHo@public.gmane.org>, VanTassell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Eric <eric.vantassell-5C7GfCeVMHo@public.gmane.org>, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 24.11.20 20:16, Sean Christopherson wrote:
> On Fri, Nov 13, 2020, David Rientjes wrote:                                     
>>                                                                               
>> On Mon, 2 Nov 2020, Sean Christopherson wrote:                                
>>                                                                               
>>> On Fri, Oct 02, 2020 at 01:48:10PM -0700, Vipin Sharma wrote:               
>>>> On Fri, Sep 25, 2020 at 03:22:20PM -0700, Vipin Sharma wrote:             
>>>>> I agree with you that the abstract name is better than the concrete     
>>>>> name, I also feel that we must provide HW extensions. Here is one       
>>>>> approach:                                                               
>>>>>                                                                         
>>>>> Cgroup name: cpu_encryption, encryption_slots, or memcrypt (open to     
>>>>> suggestions)                                                            
>>>>>                                                                         
>>>>> Control files: slots.{max, current, events}                             
>>>                                                                             
>>> I don't particularly like the "slots" name, mostly because it could be confused
>>> with KVM's memslots.  Maybe encryption_ids.ids.{max, current, events}?  I don't
>>> love those names either, but "encryption" and "IDs" are the two obvious     
>>> commonalities betwee TDX's encryption key IDs and SEV's encryption address  
>>> space IDs.                                                                  
>>>                                                                             
>>                                                                               
>> Looping Janosch and Christian back into the thread.                           
>>                                                                               
>> I interpret this suggestion as                                                
>> encryption.{sev,sev_es,keyids}.{max,current,events} for AMD and Intel         
> 
> I think it makes sense to use encryption_ids instead of simply encryption, that
> way it's clear the cgroup is accounting ids as opposed to restricting what
> techs can be used on yes/no basis.

For what its worth the IDs for s390x are called SEIDs (secure execution IDs)

> 
>> offerings, which was my thought on this as well.                              
>>                                                                               
>> Certainly the kernel could provide a single interface for all of these and    
>> key value pairs depending on the underlying encryption technology but it      
>> seems to only introduce additional complexity in the kernel in string         
>> parsing that can otherwise be avoided.  I think we all agree that a single    
>> interface for all encryption keys or one-value-per-file could be done in      
>> the kernel and handled by any userspace agent that is configuring these       
>> values.                                                                       
>>                                                                               
>> I think Vipin is adding a root level file that describes how many keys we     
>> have available on the platform for each technology.  So I think this comes    
>> down to, for example, a single encryption.max file vs                         
>> encryption.{sev,sev_es,keyid}.max.  SEV and SEV-ES ASIDs are provisioned      
> 
> Are you suggesting that the cgroup omit "current" and "events"?  I agree there's
> no need to enumerate platform total, but not knowing how many of the allowed IDs
> have been allocated seems problematic.
> 
>> separately so we treat them as their own resource here.                       
>>                                                                               
>> So which is easier?                                                           
>>                                                                               
>> $ cat encryption.sev.max                                                      
>> 10                                                                            
>> $ echo -n 15 > encryption.sev.max                                             
>>                                                                               
>> or                                                                            
>>                                                                               
>> $ cat encryption.max                                                          
>> sev 10                                                                        
>> sev_es 10                                                                     
>> keyid 0                                                                       
>> $ echo -n "sev 10" > encryption.max                                           
>>                                                                               
>> I would argue the former is simplest (always preferring                       
>> one-value-per-file) and avoids any string parsing or resource controller      
>> lookups that need to match on that string in the kernel.                      

I like the idea of having encryption_ids.max for all platforms. 
If we go for individual files using "seid" for s390 seems the best name.

> 
> Ya, I prefer individual files as well.
> 
> I don't think "keyid" is the best name for TDX, it doesn't leave any wiggle room
> if there are other flavors of key IDs on Intel platform, e.g. private vs. shared
> in the future.  It's also inconsistent with the SEV names, e.g. "asid" isn't
> mentioned anywhere.  And "keyid" sort of reads as "max key id", rather than "max
> number of keyids".  Maybe "tdx_private", or simply "tdx"?  Doesn't have to be
> solved now though, there's plenty of time before TDX will be upstream. :-)
> 
>> The set of encryption.{sev,sev_es,keyid} files that exist would depend on     
>> CONFIG_CGROUP_ENCRYPTION and whether CONFIG_AMD_MEM_ENCRYPT or                
>> CONFIG_INTEL_TDX is configured.  Both can be configured so we have all        
>> three files, but the root file will obviously indicate 0 keys available       
>> for one of them (can't run on AMD and Intel at the same time :).              
>>                                                                               
>> So I'm inclined to suggest that the one-value-per-file format is the ideal    
>> way to go unless there are objections to it.
