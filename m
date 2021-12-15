From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v9 6/7] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Wed, 15 Dec 2021 13:55:05 -0500
Message-ID: <58c06961-ffc4-27d7-01d2-4c91b0c9161d@redhat.com>
References: <20211205183220.818872-1-longman@redhat.com>
 <20211205183220.818872-7-longman@redhat.com>
 <Ybe0YWEo7Wp7wib9@slm.duckdns.org> <20211215144450.GC25459@blackbody.suse.cz>
 <96018978-6b7f-1e7f-1012-9df7f7996ec5@redhat.com>
 <Ybo1jmNvM6sblcJq@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639594522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6p2PMg3IHKSv9HJVSyU/jUSPqlHttS0kc0XgSmw+DTI=;
        b=IlmzxzopeT9hNUaavJY9qyshKFUlmyDcUrkIhXE8C4ZqTagtIbzapb+szqSOnuf8uLi3Xt
        1Z4AREVU5eQ+P4Rc9BIpWOpkun972m9YAxNE8UK+1G+PCCXSgXNuM2A6DbqXmLWr6aEPzv
        OfKmTE0506u8TSG67hFT/RGiOVYeUTU=
Content-Language: en-US
In-Reply-To: <Ybo1jmNvM6sblcJq@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>

On 12/15/21 13:35, Tejun Heo wrote:
> Hello, Waiman.
>
> On Wed, Dec 15, 2021 at 01:16:43PM -0500, Waiman Long wrote:
>> Allowing direct transition from member to invalid partition doesn't feel
>> right for me. A casual user may assume a partition is correctly formed
>> without double checking the "cpuset.partition" value. Returning an error
>> will prevent this kind of issue. If returning more information about the
>> failure is the main reason for allowing the invalid partition transition, we
>> can extend the "cpuset.partition" read syntax to also show the reason for
>> the previous failure.
> I don't think it's a good idea to display error messages without a way to
> link the error to the one who triggered it. This is the same problem we had
> with resettable counters. It only works for scenarios where one guy is
> sitting in front of the computer but gets nastry for more complex scnearios
> and automation.
Yes, I agree it is not a good way to handle this issue.
>
> I understand that allowing transitions to invalid state can feel jarring.
> There are pros and cons to both approaches. It's similar dynamics tho.
> Erroring out may be more intuitive for a casual user but makes it harder for
> more complex scenarios because whether a given operation errors or not is
> dependent on external asynchronous states, there's no good way of reporting
> the exact nature of the error or detecting when the operation would succeed
> in the future, and the error conditions are rather arbitrary.

Thanks for the explanation. Yes, there are always pros and cons for 
different approach to a problem. I am not totally against allowing 
member to invalid partition transition. In that case, reading back 
"cpuset.partition" is a must to verify that it is really a success.

How about we allow transition to an invalid partition state but still 
return an error?

Regards,
Longman

