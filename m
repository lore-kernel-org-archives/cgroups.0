From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v12 09/10] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Tue, 6 Sep 2022 10:57:51 -0400
Message-ID: <323f6375-0e1b-8326-2c74-b7a4db4693a1@redhat.com>
References: <20220901205745.323326-1-longman@redhat.com>
 <20220901205745.323326-10-longman@redhat.com> <YxRfy/SaKkJSm5jY@debian.me>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662476278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uYOnT3WdHbcwCr8H+t7+tWjbf0atY1c9YvOA6+hgbSo=;
        b=LVKSSiJlyHNN/2zIbGrZ2LITUa1Va8rEsUyp4396hucy9peNT3sPAJDyLsrD4L//erBtKY
        QG2rxjmwn9N9CNHNCQepe6cH9fmh2uPalyUCASj10+GRLvofuoXw/9PkJdnC8K/aPa8qQq
        DSkGD4J1v9hfwDqDD18L4OxQ4uORKwY=
Content-Language: en-US
In-Reply-To: <YxRfy/SaKkJSm5jY-awV0wQp4Vu2zQB+pC5nmwQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>


On 9/4/22 04:20, Bagas Sanjaya wrote:
> On Thu, Sep 01, 2022 at 04:57:44PM -0400, Waiman Long wrote:
>>   	It accepts only the following input values when written to.
>>   
>>   	  ========	================================
>> -	  "root"	a partition root
>> -	  "member"	a non-root member of a partition
>> +	  "member"	Non-root member of a partition
>> +	  "root"	Partition root
>> +	  "isolated"	Partition root without load balancing
>>   	  ========	================================
>>   
>> <snipped>
>> +	On read, the "cpuset.cpus.partition" file can show the following
>> +	values.
>> +
>> +	  ======================	==============================
>> +	  "member"			Non-root member of a partition
>> +	  "root"			Partition root
>> +	  "isolated"			Partition root without load balancing
>> +	  "root invalid (<reason>)"	Invalid partition root
>> +	  "isolated invalid (<reason>)"	Invalid isolated partition root
>> +	  ======================	==============================
>> +
> These tables above produced htmldocs warnings:
>
> Documentation/admin-guide/cgroup-v2.rst:2191: WARNING: Malformed table.
> Text in column margin in table line 4.
>
> ========      ================================
> "member"      Non-root member of a partition
> "root"        Partition root
> "isolated"    Partition root without load balancing
> ========      ================================
> Documentation/admin-guide/cgroup-v2.rst:2229: WARNING: Malformed table.
> Text in column margin in table line 5.
>
> ======================        ==============================
> "member"                      Non-root member of a partition
> "root"                        Partition root
> "isolated"                    Partition root without load balancing
> "root invalid (<reason>)"     Invalid partition root
> "isolated invalid (<reason>)" Invalid isolated partition root
> ======================        ==============================
>
> I have applied the fixup:
>
> ---- >8 ----
>
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 76b3ea9fd5c560..77b6faecf066cb 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -2185,11 +2185,11 @@ Cpuset Interface Files
>   
>   	It accepts only the following input values when written to.
>   
> -	  ========	================================
> +	  ==========	================================
>   	  "member"	Non-root member of a partition
>   	  "root"	Partition root
>   	  "isolated"	Partition root without load balancing
> -	  ========	================================
> +	  ==========	================================
>   
>   	The root cgroup is always a partition root and its state
>   	cannot be changed.  All other non-root cgroups start out as
> @@ -2222,13 +2222,13 @@ Cpuset Interface Files
>   	On read, the "cpuset.cpus.partition" file can show the following
>   	values.
>   
> -	  ======================	==============================
> +	  =============================	=====================================
>   	  "member"			Non-root member of a partition
>   	  "root"			Partition root
>   	  "isolated"			Partition root without load balancing
>   	  "root invalid (<reason>)"	Invalid partition root
>   	  "isolated invalid (<reason>)"	Invalid isolated partition root
> -	  ======================	==============================
> +	  =============================	=====================================
>   
>   	In the case of an invalid partition root, a descriptive string on
>   	why the partition is invalid is included within parentheses.
>
> Thanks.

Thanks for the fixes. Will apply that.

Cheers,
Longman

