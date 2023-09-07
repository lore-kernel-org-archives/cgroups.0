From: Kamalesh Babulal <kamalesh.babulal@oracle.com>
Subject: Re: [External] : Re: [PATH v2] cgroup: add cgroup_favordynmods=
 command-line option
Date: Thu, 7 Sep 2023 15:21:41 +0530
Message-ID: <a88173b8-0d87-37fe-3c4c-bd1d15d3f5bb@oracle.com>
References: <20230906005712.66461-1-luizcap@amazon.com>
 <5487ed0a-8483-0a92-c7c1-9ca3ed8e6162@oracle.com>
 <ac50c7a3-c2af-26c1-cdd3-0add6b299994@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=VMf00UbFBSXJ39KsE6ttNP8iTB316kppBLMUruDxTcg=;
 b=tbP1KMkZacdUNtRilViMjaTjMLIgwayXKQyrvM5ugr7EUJ+ykT/9+ULY+WC9KCXKlvJN
 fRMHYHn8QErskOVZViUI0LX7WlblYkLjFNvoOfosQ84LgGRByXlkQShT2Rei6GS88b/W
 vAmCl86O89CTNom4La5D3WyQc+lf1iB/BB1MmPmNGnHj4UI1iS172D3QRmQWAFfA0bxS
 MDsHSocfewsLFSpJ2rFUNtfXE+GfoQrKc7B/j+bH7H3lFqVw0g72RBcQs4rMLDUSICfa
 O5VqVqwSvwiMbEyRpKcEqtqExwrmcpYbpHQpdAhFmIYoONneFpPYA4n4+TnLQgbWjfXr xA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VMf00UbFBSXJ39KsE6ttNP8iTB316kppBLMUruDxTcg=;
 b=IBmEdIHWWJSOet6sU/0JLtIn27euKjZ2gwPi7Wr2q2nkbzMyoCwUkN4rbuqkwShjRM9KYSOENcMpweqflI7o5zC/hIQH5AJxTejGktsrQM+USRs/eupP8kmKSwna+6EPzUeDjKPdhbW8aFYOH9SRpERp7YKZWv1YV6oKilYA31s=
Content-Language: en-US
In-Reply-To: <ac50c7a3-c2af-26c1-cdd3-0add6b299994@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Waiman Long <longman@redhat.com>, Luiz Capitulino <luizcap@amazon.com>, tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: lcapitulino@gmail.com



On 9/6/23 18:29, Waiman Long wrote:
> On 9/6/23 02:58, Kamalesh Babulal wrote:
>> On 9/6/23 06:27, Luiz Capitulino wrote:
>> [...]
>>> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
>>> index 1fb7f562289d..2b7d74304606 100644
>>> --- a/kernel/cgroup/cgroup.c
>>> +++ b/kernel/cgroup/cgroup.c
>>> @@ -207,6 +207,8 @@ static u16 have_exit_callback __read_mostly;
>>>   static u16 have_release_callback __read_mostly;
>>>   static u16 have_canfork_callback __read_mostly;
>>>   +static bool have_favordynmods __ro_after_init = IS_ENABLED(CONFIG_CGROUP_FAVOR_DYNMODS);
>>> +
>>>   /* cgroup namespace for init task */
>>>   struct cgroup_namespace init_cgroup_ns = {
>>>       .ns.count    = REFCOUNT_INIT(2),
>>> @@ -2243,9 +2245,9 @@ static int cgroup_init_fs_context(struct fs_context *fc)
>>>       fc->user_ns = get_user_ns(ctx->ns->user_ns);
>>>       fc->global = true;
>>>   -#ifdef CONFIG_CGROUP_FAVOR_DYNMODS
>>> -    ctx->flags |= CGRP_ROOT_FAVOR_DYNMODS;
>>> -#endif
>>> +    if (have_favordynmods)
>>> +        ctx->flags |= CGRP_ROOT_FAVOR_DYNMODS;
>>> +
>>>       return 0;
>>>   }
>>>   @@ -6764,6 +6766,12 @@ static int __init enable_cgroup_debug(char *str)
>>>   }
>>>   __setup("cgroup_debug", enable_cgroup_debug);
>>>   +static int __init cgroup_favordynmods_setup(char *str)
>>> +{
>>> +    return (kstrtobool(str, &have_favordynmods) == 0);
>>> +}
>>> +__setup("cgroup_favordynmods=", cgroup_favordynmods_setup);
>>> +
>>>   /**
>>>    * css_tryget_online_from_dir - get corresponding css from a cgroup dentry
>>>    * @dentry: directory dentry of interest
>> Consider a case where the kernel is compiled with
>> CONFIG_CGROUP_FAVOR_DYNMODS=n and kernel command line is passed with
>> cgroup_favordynmods=true, this would set the have_favordynmods to true.
>> In cgroup_favordynmods_setup(), should it return 0 with a pr_warn(),
>> when CONFIG_CGROUP_FAVOR_DYNMODS=n in the above case, or is this
>> expected behavior?
> 
> According to the documentation of __setup:
> 
> /*
>  * NOTE: __setup functions return values:
>  * @fn returns 1 (or non-zero) if the option argument is "handled"
>  * and returns 0 if the option argument is "not handled".
>  */
> 
> So the return value should tell whether the input parameter is a recognizable true or false value, not whether it is true or false. kstrtobool returns 0 if it is a recognizable T/F value or -EINVAL otherwise. So the check is correct. I did double check that before I ack'ed the patch.
> 

Apologies for not being clear in the previous email. It was in two parts,  
where the first one was more of a question, where if a kernel is compiled
with CONFIG_CGROUP_FAVOR_DYNMODS config option disabled and the user    
attempts to pass cgroup_favordynmods=true in the kernel command line.   
                                                                        
In this scenario, the have_favordynmods is set to true regardless of    
the CONFIG_CGROUP_FAVOR_DYNMODS config option being enabled/disabled in 
the kernel. This allows the user to set CGRP_ROOT_FAVOR_DYNMODS flag    
without enabling the CONFIG_CGROUP_FAVOR_DYNMODS kernel config.         
                                                                        
Shouldn't the cgroup_favordynmods kernel parameter be valid only when   
the kernel is compiled with CONFIG_CGROUP_FAVOR_DYNMODS=y and allows the 
user to only disable it in the kernel command line instead of allowing  
them to set/unset have_favordynmods when CONFIG_CGROUP_FAVOR_DYNMODS is 
disabled.                                                               
                                                                        
If the above assumption is right, that's where the second part was of   
email, where I was suggesting the restriction by using ifdef guards in  
cgroup_favordynmods_setup(), something like:

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 2b7d74304606..5c7d1a0b1dbe 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6768,7 +6768,11 @@ __setup("cgroup_debug", enable_cgroup_debug);
 
 static int __init cgroup_favordynmods_setup(char *str)
 {
+#ifdef CGROUP_FAVOR_DYNMODS
        return (kstrtobool(str, &have_favordynmods) == 0);
+#endif
+       pr_warn("Favor Dynmods not supported\n");
+       return 0;
 }
 __setup("cgroup_favordynmods=", cgroup_favordynmods_setup);

-- 
Thanks,
Kamalesh
