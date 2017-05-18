From: Waiman Long <longman@redhat.com>
Subject: Re: [RFC PATCH v2 09/17] cgroup: Keep accurate count of tasks in each
 css_set
Date: Thu, 18 May 2017 11:56:38 -0400
Message-ID: <b0a5ea12-317f-70a3-2efe-e0b7f7673e3e@redhat.com>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
 <1494855256-12558-10-git-send-email-longman@redhat.com>
 <20170517214034.GF942@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com CCD0A80C01
In-Reply-To: <20170517214034.GF942@htj.duckdns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de

On 05/17/2017 05:40 PM, Tejun Heo wrote:
> Hello,
>
> On Mon, May 15, 2017 at 09:34:08AM -0400, Waiman Long wrote:
>> The reference count in the css_set data structure was used as a
>> proxy of the number of tasks attached to that css_set. However, that
>> count is actually not an accurate measure especially with thread mode
>> support. So a new variable task_count is added to the css_set to keep
>> track of the actual task count. This new variable is protected by
>> the css_set_lock. Functions that require the actual task count are
>> updated to use the new variable.
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
> Looks good.  We probably should replace css_set_populated() to use
> this too.
>
> Thanks.
>
Yes, you are right. css_set_populated() can be replaced with a check on
the task_count.

Regards,
Longman

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
