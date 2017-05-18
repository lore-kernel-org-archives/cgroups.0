From: Waiman Long <longman@redhat.com>
Subject: Re: [RFC PATCH v2 08/17] cgroup: Move debug cgroup to its own file
Date: Thu, 18 May 2017 11:52:18 -0400
Message-ID: <ee36d4f8-9e9d-a5c7-2174-56c21aaf75af@redhat.com>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
 <1494855256-12558-9-git-send-email-longman@redhat.com>
 <20170517213603.GE942@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com B269F7700
In-Reply-To: <20170517213603.GE942@htj.duckdns.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de

On 05/17/2017 05:36 PM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Mon, May 15, 2017 at 09:34:07AM -0400, Waiman Long wrote:
>> The debug cgroup currently resides within cgroup-v1.c and is enabled
>> only for v1 cgroup. To enable the debug cgroup also for v2, it
>> makes sense to put the code into its own file as it will no longer
>> be v1 specific. The only change in this patch is the expansion of
>> cgroup_task_count() within the debug_taskcount_read() function.
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
> I don't mind enabling the debug controller for v2 but let's please
> hide it behind an unwieldy boot param / controller name so that it's
> clear that its interface isn't expected to be stable.
>
> Thanks.
>
The controller name is "debug" and so it is obvious what this controller
is for. However, the config prompt "Example controller" is indeed vague
in meaning. So we can make the prompt more descriptive here. As for the
boot param, are you saying something like "cgroup_debug" has to be
specified in the command line even if CGROUP_DEBUG config is there for
the debug controller to be enabled? I am fine with that if you think it
is necessary.

Regards,
Longman

