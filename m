From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v8 5/6] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Wed, 1 Dec 2021 12:49:15 -0500
Message-ID: <e16ccf4f-7302-8891-d9f6-081e0bc41c04@redhat.com>
References: <20211018143619.205065-1-longman@redhat.com>
 <20211018143619.205065-6-longman@redhat.com>
 <20211115193122.GA16798@blackbody.suse.cz>
 <8f68692b-bd8f-33fd-44ae-f6f83bf2dc00@redhat.com>
 <20211116175411.GA50019@blackbody.suse.cz>
 <293d7abf-aff6-fcd8-c999-b1dbda1cffb8@redhat.com>
 <YaZbXArNIMNvwJD/@slm.duckdns.org>
 <2347fe66-dc68-6d58-e63b-7ed2b8077b48@redhat.com>
 <20211201141350.GA54766@blackbody.suse.cz>
 <ec6e2b89-385a-fcc7-7cfa-7e9119fc34bc@redhat.com>
 <YaelRiqWOIzT5uRs@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638380964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d3IYU06NP1ap6vKovk21hhbdlMoBPkQcBNAwBXt/XDY=;
        b=OhsUsVUD/48gfapf93JSJAouyUgzw2OWmvoLlUFNw6aOSnxyRTb8xKVN6Dnd82y0xp0hjx
        hHtmQ4T5WSM6uKra4LWimh89MVXCMZU6Qyg92mqFWLNfg0K1mCUFzJkYN9tJI9hB1oAJyK
        IyMKtILcANm4LTh5mrnqYQR+kFkLfKM=
Content-Language: en-US
In-Reply-To: <YaelRiqWOIzT5uRs-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


On 12/1/21 11:39, Tejun Heo wrote:
> On Wed, Dec 01, 2021 at 09:56:21AM -0500, Waiman Long wrote:
>> Right, I shouldn't say corner cases. Having task in an intermediate
>> partition is possible depending on event sequence. I am aware that there=
 are
>> code in the cpuset code to prevent that, but it didn't block all cases.
>>>> A valid parent partition may distribute out all its CPUs to
>>>>   =C2=A0its child partitions as long as there is no task associated wi=
th it.
>>> Assuming there's always at least one kernel thread in the root cgroup
>>> that can't be migrated anyway.]
>> I am aware of that. That is why I said root cgroup must have at least one
>> cpu in its "cpuset.cpus.effective".
> In that case, let's explicitly describe that condition.

Yes, I will. Only non-root cgroup can distribute out all its CPUs. I=20
thought I said that in the documentation, maybe it is very clear.

Cheers,
Longman

