From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATH] cgroup: add cgroup_favordynmods= command-line option
Date: Tue, 5 Sep 2023 14:59:43 -0400
Message-ID: <af394f53-224d-baff-5c7d-87eff7fcaad2@redhat.com>
References: <20230831142046.37177-1-luizcap@amazon.com>
 <20230905170318.GA16629@dev-dsk-luizcap-1d-37beaf15.us-east-1.amazon.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693940387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/0aAtKGZKY2TsC8NWxjXlesPhzcxWuJvtlmaEX2vDxs=;
        b=J66oMCG7L7rNsQyQIlX1UU9bP2yxneyDDQdjjMlAXDp3bGOa2r3sIIpHSVveSAaBBzL7Wn
        zM2CKPFUaGlsF2wetL2uLqaMyZ7i0H0Ja2zMuI6gMb9YYopvdd+kEVkhiiacB291UroP73
        fLlQdrCzf4g9rY8wjaMrjRHDmITBioE=
Content-Language: en-US
In-Reply-To: <20230905170318.GA16629-NRm0YHp59q2eMkSG5SGXcooQjOkzophpTTtiIo6RB15VimiU06bkFBpWQ8D1YOoY@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Luiz Capitulino <luizcap-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: lcapitulino-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org


On 9/5/23 13:03, Luiz Capitulino wrote:
> On Thu, Aug 31, 2023 at 10:20:46AM -0400, Luiz Capitulino wrote:
>> We have a need of using favordynmods with cgroup v1, which doesn't support
>> changing mount flags during remount. Enabling CONFIG_FAVOR_DYNMODS at
>> build-time is not an option because we want to be able to selectively
>> enable it for certain systems.
>>
>> This commit addresses this by introducing the cgroup_favordynmods=
>> command-line option. This option works for both cgroup v1 and v2 and
>> also allows for disabling favorynmods when the kernel built with
>> CONFIG_FAVOR_DYNMODS=y.
>>
>> Signed-off-by: Luiz Capitulino <luizcap-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>
> Hi,
>
> Would somebody take a look at this patch please?
>
> Thanks,
>
> - Luiz

The patch looks good to me. I do have a minor comment that it may be 
better to use the relatively new __ro_after_init qualifier instead of 
__read_mostly.

Cheers,
Longman

>> ---
>>   Documentation/admin-guide/kernel-parameters.txt |  4 ++++
>>   kernel/cgroup/cgroup.c                          | 14 +++++++++++---
>>   2 files changed, 15 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
>> index 0c38a8af95ce..672f76a3c002 100644
>> --- a/Documentation/admin-guide/kernel-parameters.txt
>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>> @@ -580,6 +580,10 @@
>>   			named mounts. Specifying both "all" and "named" disables
>>   			all v1 hierarchies.
>>   
>> +	cgroup_favordynmods= [KNL] Enable or Disable favordynmods.
>> +			Format: { "true" | "false" }
>> +			Defaults to the value of CONFIG_CGROUP_FAVOR_DYNMODS.
>> +
>>   	cgroup.memory=	[KNL] Pass options to the cgroup memory controller.
>>   			Format: <string>
>>   			nosocket -- Disable socket memory accounting.
>> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
>> index 5fa95f86cb4d..b625825e270b 100644
>> --- a/kernel/cgroup/cgroup.c
>> +++ b/kernel/cgroup/cgroup.c
>> @@ -207,6 +207,8 @@ static u16 have_exit_callback __read_mostly;
>>   static u16 have_release_callback __read_mostly;
>>   static u16 have_canfork_callback __read_mostly;
>>   
>> +static bool have_favordynmods __read_mostly = IS_ENABLED(CONFIG_CGROUP_FAVOR_DYNMODS);
>> +
>>   /* cgroup namespace for init task */
>>   struct cgroup_namespace init_cgroup_ns = {
>>   	.ns.count	= REFCOUNT_INIT(2),
>> @@ -2265,9 +2267,9 @@ static int cgroup_init_fs_context(struct fs_context *fc)
>>   	fc->user_ns = get_user_ns(ctx->ns->user_ns);
>>   	fc->global = true;
>>   
>> -#ifdef CONFIG_CGROUP_FAVOR_DYNMODS
>> -	ctx->flags |= CGRP_ROOT_FAVOR_DYNMODS;
>> -#endif
>> +	if (have_favordynmods)
>> +		ctx->flags |= CGRP_ROOT_FAVOR_DYNMODS;
>> +
>>   	return 0;
>>   }
>>   
>> @@ -6767,6 +6769,12 @@ static int __init enable_cgroup_debug(char *str)
>>   }
>>   __setup("cgroup_debug", enable_cgroup_debug);
>>   
>> +static int __init cgroup_favordynmods_setup(char *str)
>> +{
>> +	return (kstrtobool(str, &have_favordynmods) == 0);
>> +}
>> +__setup("cgroup_favordynmods=", cgroup_favordynmods_setup);
>> +
>>   /**
>>    * css_tryget_online_from_dir - get corresponding css from a cgroup dentry
>>    * @dentry: directory dentry of interest
>> -- 
>> 2.40.1
>>

