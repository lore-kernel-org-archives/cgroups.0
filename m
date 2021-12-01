From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v8 5/6] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Wed, 1 Dec 2021 09:56:21 -0500
Message-ID: <ec6e2b89-385a-fcc7-7cfa-7e9119fc34bc@redhat.com>
References: <20211018143619.205065-1-longman@redhat.com>
 <20211018143619.205065-6-longman@redhat.com>
 <20211115193122.GA16798@blackbody.suse.cz>
 <8f68692b-bd8f-33fd-44ae-f6f83bf2dc00@redhat.com>
 <20211116175411.GA50019@blackbody.suse.cz>
 <293d7abf-aff6-fcd8-c999-b1dbda1cffb8@redhat.com>
 <YaZbXArNIMNvwJD/@slm.duckdns.org>
 <2347fe66-dc68-6d58-e63b-7ed2b8077b48@redhat.com>
 <20211201141350.GA54766@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638370632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nD9oVnkdNcgwBlZTLCOet/WJtrrHTgH+O1SlF9BlPpQ=;
        b=Me4O9JkuhDcSx1OCWDG8pbHOaUHrHmRtxt23dD1iBx91h2F+8dCfvS7mPYZdw2HhCDgcNE
        Y3GzPo6okk01ynkW8KNi0LL6XpQHEWnslzJoNf1CheIkxF6tkpsRXMvXtv/qnc++AW3S3z
        Sl2eDBkkOJqbgLwXMtvhWcgNjPwrMp0=
Content-Language: en-US
In-Reply-To: <20211201141350.GA54766-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 12/1/21 09:13, Michal Koutný wrote:
> On Tue, Nov 30, 2021 at 10:56:34PM -0500, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>>>       A valid parent partition may distribute out all its CPUs to
>>>>       its child partitions as long as it is not the root cgroup and
>>>>       there is no task associated with it.
>>> A valid parent partition which isn't root never has tasks in them to begin
>>> with.
>> I believe there is some corner cases where it is possible to put task in an
>> intermediate partition. That is why I put down this statement.
> Just mind the threads -- cpuset controller is threaded and having tasks
> in inner cgroup nodes is a real scenario. I wouldn't consider it a
> corner case.
>
> [ Actually, the paragraph could IMO be simplified:
Right, I shouldn't say corner cases. Having task in an intermediate 
partition is possible depending on event sequence. I am aware that there 
are code in the cpuset code to prevent that, but it didn't block all cases.
>> A valid parent partition may distribute out all its CPUs to
>>   its child partitions as long as there is no task associated with it.
> Assuming there's always at least one kernel thread in the root cgroup
> that can't be migrated anyway.]

I am aware of that. That is why I said root cgroup must have at least 
one cpu in its "cpuset.cpus.effective".

Cheers,
Longman

