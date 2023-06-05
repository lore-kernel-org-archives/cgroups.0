From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: fixed the cset refcnt leak when fork() failed
Date: Mon, 5 Jun 2023 10:51:50 -0400
Message-ID: <177cc1f5-3b11-cde1-5769-f18e87890083@redhat.com>
References: <20230605130444.1421-1-zoucao@kuaishou.com>
 <e0d1998f-c081-30e6-7646-cf6460c2d67c@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685976718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+jSjkiDWclAj9vqdgMGMiyGqF2MyWCPc8BsnONjQCIE=;
        b=YFJ9xfSSdQdjIJ/DQ6BUcjAtOT3IsQvhoxvWFfgjXSTcmfom1kDzuF7jYNGC/o70ut9oIj
        CsD/qfPKETAiJ3IO4qv700/wlh7ODa9MTP8NZ9EMPAAzwjcCE+Alzvh+e7N/a9x/gbOjr5
        BqOmaAohg5e3YDk5LpO42XXdojO0iY0=
Content-Language: en-US
In-Reply-To: <e0d1998f-c081-30e6-7646-cf6460c2d67c-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Zou Cao <zoucaox-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Zou Cao <zoucao-e2CXd7i0PsxWk0Htik3J/w@public.gmane.org>


On 6/5/23 10:12, Waiman Long wrote:
>> kernel/cgroup/cgroup.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
>> index d18c2ef..5ecd706 100644
>> --- a/kernel/cgroup/cgroup.c
>> +++ b/kernel/cgroup/cgroup.c
>> @@ -6284,6 +6284,11 @@ void cgroup_cancel_fork(struct task_struct 
>> *child,
>>           if (ss->cancel_fork)
>>               ss->cancel_fork(child, kargs->cset);
>>   +    if (!(kargs->flags & CLONE_INTO_CGROUP) &&
>> +            kargs->cset) {
>> +        put_css_set(kargs->cset);
>> +    }
>> +
> I believe the out_revert error path of cgroup_can_fork() has a similar 
> issue. Perhaps you may want to put the put_css_set() call in 
> cgroup_css_set_put_fork().

Sorry, it should not be done in cgroup_css_set_put_fork(). As the 
increase in reference is properly matched in css_post_fork(). That means 
similar change will be needed in cgroup_can_fork().

Cheers,
Longman

