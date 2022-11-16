From: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Improve cpuset_css_alloc() description
Date: Wed, 16 Nov 2022 21:10:48 +0530
Message-ID: <c1c5910c-8f5d-1eea-8bd7-7d79f5b5ee87@oracle.com>
References: <20221116054415.79157-1-kamalesh.babulal@oracle.com>
 <7eb8d6f9-b54c-aedc-982b-8ed2bddb948b@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=rcAS/O7Cn4IuxKQIDgOTAD7UU2V1WYPHUwLpYvzLOzE=;
 b=YqaTpGu9XONh5LxE/PmpBOZ475UlDEuQzZQrNUZaWHxmA59PGvzaC8LBXQ8wPHpayjJV
 QDvm0AtqQTHDmqSkWoFF8eceylpq0npBrw431s4eNOKSwLv5M0pZN/uF4TJu5YtTneNY
 w05sVvAAxaRW/w2+qqgBNF0nooB5RWxSTfIUXjcl5zyh8jncdkdzW37eqBk9sSOCHnHk
 7CUWhSGqZxJXWFfiv03mJdmmVLB5aCAY28RmcobDqZPk4jCYANUgFBIrU0iZaBAgatr4
 sWtU+a9QxVUG3AETc8pJHpA/uQNNZlKXemGvWtqZvukPuP8OIxOM7PEZCCAovxd8l2o4 xQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rcAS/O7Cn4IuxKQIDgOTAD7UU2V1WYPHUwLpYvzLOzE=;
 b=gJ7yuFd/YTifg6RwULgdj41mNNqI3uckT7QvixmdLWWC0zkxnurHi7VKpwmjbb4oxbi0v/rHynR9JAdCm+QGprxW4cIo7rq75mU8g/tU+J6h9u9IVniDF9Rbsx3Lc737fOXwFQy1N5moqYI5pnG4Kwj1G8gTBWtV+oqLFr3VY2U=
Content-Language: en-US
In-Reply-To: <7eb8d6f9-b54c-aedc-982b-8ed2bddb948b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tom Hromatka <tom.hromatka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>



On 11/16/22 20:06, Waiman Long wrote:
> On 11/16/22 00:44, Kamalesh Babulal wrote:
>> Change the function argument in the description of cpuset_css_alloc()
>> from 'struct cgroup' -> 'struct cgroup_subsys_state'.  The change to the
>> argument type was introduced by commit eb95419b023a ("cgroup: pass
>> around cgroup_subsys_state instead of cgroup in subsystem methods").
>> Also, add more information to its description.
>>
>> Signed-off-by: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>>   kernel/cgroup/cpuset.c | 11 ++++++++---
>>   1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index b474289c15b8..aac790462e74 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -3046,9 +3046,14 @@ static struct cftype dfl_files[] = {
>>   };
>>     -/*
>> - *    cpuset_css_alloc - allocate a cpuset css
>> - *    cgrp:    control group that the new cpuset will be part of
>> +/**
>> + * cpuset_css_alloc - Allocate a cpuset css
>> + * @parent_css: Parent css of the control group that the new cpuset will be
>> + *              part of
>> + * Return: cpuset css on success, -ENOMEM on failure.
>> + *
>> + * Allocate and initialize a new cpuset css, for non-root cpuset or return the
>> + * top cpuset css for root cpuset.
> Strictly speaking, it returns the css of top cpuset set for NULL input parameter.

Thank you for reviewing the patch. Does the following, rephrase, sound right:

Allocate and initialize a new cpuset css, for non-NULL @parent_css, return                             
top cpuset css otherwise.

>>    */
>>     static struct cgroup_subsys_state *
> 
> While at it, could you also remove the blank line between the comment and the function body.

Sure, will remove it.

-- 
Thanks,
Kamalesh
