From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v11 3/8] cgroup/cpuset: Allow no-task partition to have
 empty cpuset.cpus.effective
Date: Sun, 12 Jun 2022 22:53:53 -0400
Message-ID: <ce3106c1-a3c4-b449-bafc-6940d672bd94@redhat.com>
References: <20220510153413.400020-1-longman@redhat.com>
 <20220510153413.400020-4-longman@redhat.com>
 <YqYlCRywdgSYtwKk@slm.duckdns.org> <YqYlOQjKtQCBsQuT@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655088836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=awNyHYB+B6d++/GUSUOZEZMC4V4Il/2xgLKKTfctnKo=;
        b=YXutdmp3VsWJmqQG7NIetHnTqzAXVxUtsCqEKlIsPTXg5D9waxHITTn5KiJGTY0FBL7fOO
        C13N8Ba7OT2090emTJSIgqIVGoZ1UpjuCsc5KrlObXOQMoqvOgZugOtzuQ0lgdZ1BmF9IN
        4Xb9XkGNjMUoiKN7DQVY1DJoHmEFFKQ=
Content-Language: en-US
In-Reply-To: <YqYlOQjKtQCBsQuT@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>


On 6/12/22 13:41, Tejun Heo wrote:
> On Sun, Jun 12, 2022 at 07:40:25AM -1000, Tejun Heo wrote:
>> Hello,
>>
>> Sorry about the long delay.
>>
>> On Tue, May 10, 2022 at 11:34:08AM -0400, Waiman Long wrote:
>>> Once a partition with empty "cpuset.cpus.effective" is formed, no
>>> new task can be moved into it until "cpuset.cpus.effective" becomes
>>> non-empty.
>> This is always true due to no-tasks-in-intermediate-cgroups requirement,
>> right?
> or rather, I should have asked, why does this need an explicit check?

Without this patch, cpus.effective will never be empty. It just falls 
back to its parent if it becomes empty. Now with an empty 
cpus.effective, I am afraid that if a task is somehow moved to such a 
cpuset, something bad may happen. So I add this check as a safeguard.

Cheers,
Longman

