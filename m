From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v11 7/8] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Mon, 13 Jun 2022 13:06:20 -0400
Message-ID: <c91a8c45-123d-dbae-b07c-83772add082d@redhat.com>
References: <20220510153413.400020-1-longman@redhat.com>
 <20220510153413.400020-8-longman@redhat.com>
 <YqYnQ4U4t6j/3UaL@slm.duckdns.org>
 <404171dc-0da3-21f2-5003-9718f875e967@redhat.com>
 <YqarMyNo9oHxhZFh@slm.duckdns.org>
 <8d7ddb5a-0d0b-3f2e-e049-900360e95fc6@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655139987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s7hhCYT7OGqCx5nH+qXS1ao3TYt75AzmKiJLPQv1MlY=;
        b=dN7XFuXy/NWHD2GALDrP/g+Tp4sT4W9Tv4HMrVJG6rUUtnNYuOkLd70ou+1H4i9IIEphie
        A8kaF705rtufmt6MmOPibuYCLTEA1qQj4oT3ThVchBnKt3CZo2DGW5qjvf9eX7Vd2uCnmH
        07Yxv6ZGdibYBrILf0/Rv5c+kgGsTMc=
Content-Language: en-US
In-Reply-To: <8d7ddb5a-0d0b-3f2e-e049-900360e95fc6@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>

On 6/13/22 09:18, Waiman Long wrote:
> On 6/12/22 23:12, Tejun Heo wrote:
>> Hello,
>>
>> On Sun, Jun 12, 2022 at 11:02:38PM -0400, Waiman Long wrote:
>>> That is the behavior enforced by setting the CPU_EXCLUSIVE bit in 
>>> cgroup v1.
>>> I haven't explicitly change it to make it different in cgroup v2. 
>>> The major
>>> reason is that I don't want change to one cpuset to affect a sibling
>>> partition as it may make the code more complicate to validate if a 
>>> partition
>>> is valid.
>> If at all possible, I'd really like to avoid situations where a 
>> parent can't
>> withdraw resources due to something that a descendant does.
>
> No, it doesn't affect parent at all. It just limit whats the siblings 
> can do due to their mutual constraint. If this is what the confusion 
> is about, I will try to reword the doc text.

I am planning to make the following change to the documentation patch. 
Please let me know if that can clarify the confusion, if any.

Thanks,
Longman

diff --git a/Documentation/admin-guide/cgroup-v2.rst 
b/Documentation/admin-guid>
index 9184a09e0fc9..9cbfa25dab97 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2176,7 +2175,8 @@ Cpuset Interface Files

         For a valid partition root or an invalid partition root with
         the exclusivity rule enabled, changes made to "cpuset.cpus"
-       that violate the exclusivity rule will not be allowed.
+       that violate the exclusivity rule with its siblings will not
+       be allowed.

         A valid non-root parent partition may distribute out all its CPUs
         to its child partitions when there is no task associated with it.

