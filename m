From: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATH v2] cgroup: add cgroup_favordynmods= command-line option
Date: Fri, 8 Sep 2023 12:34:27 +0530
Message-ID: <4f4404a3-0bc3-b75f-6ff6-1725fd252f87@oracle.com>
References: <20230906005712.66461-1-luizcap@amazon.com>
 <5487ed0a-8483-0a92-c7c1-9ca3ed8e6162@oracle.com>
 <ac50c7a3-c2af-26c1-cdd3-0add6b299994@redhat.com>
 <a88173b8-0d87-37fe-3c4c-bd1d15d3f5bb@oracle.com>
 <e7675405-c910-340e-0679-0271dff76722@amazon.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=vzUArHqkJev+Nd04DgnrSxOKaShq00tG6YTO6CUmYZI=;
 b=MrBHdfUUKULiL9TktAwsQSaseY7A3izeQTTqKtCgU3rWsqUKeRLg30Pn/6TfMz0iMn0w
 8GzwxVSSah4UrTipr3MEKF6vpcVmzL1dgVs8lVv5hClOEVFB2877sMwpGAbWy4TdWzz6
 aXqLckd6hFmw2VyAXgh08vY2aak21poSPOfV8HXduvs9gfUNP5COE7W4PuLK+UU2oEcS
 vWrFAOYcCBR+lHoaLMjo34MwjSmp62r07TJVnde/gx+vzscQsmbvEw8Oo1d9Qvqan9mz
 ch/hs7tQEj7LEHLHVioLI/75E3K9lk3I8xEKFgtfbgwO8oYaxKahKJBL2ejNLo0bnfXD sQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzUArHqkJev+Nd04DgnrSxOKaShq00tG6YTO6CUmYZI=;
 b=vKzuSh4vwJItvT54IsnUp40vZm7sQoMBMiE3Lzz8xZM1bx3hExXdijQBiIMUPCkiwDpPuIYCs70fxpseafdGylJU9nlvIW1gs6qqA6R5O2MRZ/yfSQbo7H94ysnXJH80+c4cVyS16op+fQ8rvuef9C3EZf/Zz5eA4XC3XYgUfeo=
Content-Language: en-US
In-Reply-To: <e7675405-c910-340e-0679-0271dff76722-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Luiz Capitulino <luizcap-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: lcapitulino-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org



On 9/8/23 00:17, Luiz Capitulino wrote:

[...]

>>>> Consider a case where the kernel is compiled with
>>>> CONFIG_CGROUP_FAVOR_DYNMODS=n and kernel command line is passed with
>>>> cgroup_favordynmods=true, this would set the have_favordynmods to true.
>>>> In cgroup_favordynmods_setup(), should it return 0 with a pr_warn(),
>>>> when CONFIG_CGROUP_FAVOR_DYNMODS=n in the above case, or is this
>>>> expected behavior?
>>>
>>> According to the documentation of __setup:
>>>
>>> /*
>>>   * NOTE: __setup functions return values:
>>>   * @fn returns 1 (or non-zero) if the option argument is "handled"
>>>   * and returns 0 if the option argument is "not handled".
>>>   */
>>>
>>> So the return value should tell whether the input parameter is a recognizable true or false value, not whether it is true or false. kstrtobool returns 0 if it is a recognizable T/F value or -EINVAL otherwise. So the check is correct. I did double check that before I ack'ed the patch.
>>>
>>
>> Apologies for not being clear in the previous email. It was in two parts,
>> where the first one was more of a question, where if a kernel is compiled
>> with CONFIG_CGROUP_FAVOR_DYNMODS config option disabled and the user
>> attempts to pass cgroup_favordynmods=true in the kernel command line.
>>
>> In this scenario, the have_favordynmods is set to true regardless of
>> the CONFIG_CGROUP_FAVOR_DYNMODS config option being enabled/disabled in
>> the kernel. This allows the user to set CGRP_ROOT_FAVOR_DYNMODS flag
>> without enabling the CONFIG_CGROUP_FAVOR_DYNMODS kernel config.
> 
> Correct, that's exactly the goal of this patch: to give users the
> option to enable/disable favordynmods at boot-time regardless of
> CONFIG_FAVOR_DYNMODS.
> 
> This is especially useful with cgroup v1 where remounting with
> favordynmods is not supported.

Thank you so much for explaining. I understand the idea of the
patch better now.

>> Shouldn't the cgroup_favordynmods kernel parameter be valid only when
>> the kernel is compiled with CONFIG_CGROUP_FAVOR_DYNMODS=y and allows the
>> user to only disable it in the kernel command line instead of allowing
>> them to set/unset have_favordynmods when CONFIG_CGROUP_FAVOR_DYNMODS is
>> disabled.
> 
> This was my first idea as well, but since we'd allow for enabling why
> not allow for disabling as well? Besides, the resulting code is
> fairly simple.

Agreed, If it's independent of CONFIG_CGROUP_FAVOR_DYNMODS config
option, providing both enable and disable, is useful.

>> If the above assumption is right, that's where the second part was of
>> email, where I was suggesting the restriction by using ifdef guards in
>> cgroup_favordynmods_setup(), something like:
>>
>> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
>> index 2b7d74304606..5c7d1a0b1dbe 100644
>> --- a/kernel/cgroup/cgroup.c
>> +++ b/kernel/cgroup/cgroup.c
>> @@ -6768,7 +6768,11 @@ __setup("cgroup_debug", enable_cgroup_debug);
>>
>>   static int __init cgroup_favordynmods_setup(char *str)
>>   {
>> +#ifdef CGROUP_FAVOR_DYNMODS
>>          return (kstrtobool(str, &have_favordynmods) == 0);
>> +#endif
>> +       pr_warn("Favor Dynmods not supported\n");
>> +       return 0;
>>   }
> 
> Why should we do this? What's the benefit for the user?

This code was constructed on the idea of have_favordynmods, should
be available only when the kernel is compiled with CONFIG_CGROUP_FAVOR_DYNMODS
and it's of no benefit.
 
>>   __setup("cgroup_favordynmods=", cgroup_favordynmods_setup);
>>

-- 
Thanks,
Kamalesh
