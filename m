From: Waiman Long <longman@redhat.com>
Subject: Re: [RFC PATCH v2 08/17] cgroup: Move debug cgroup to its own file
Date: Thu, 18 May 2017 11:29:10 -0400
Message-ID: <03fe182f-92d5-0996-2d9c-d92c878dce35@redhat.com>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
 <1494855256-12558-9-git-send-email-longman@redhat.com>
 <20170517213603.GE942@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 870E8C04B92C
In-Reply-To: <20170517213603.GE942@htj.duckdns.org>
Sender: owner-linux-mm@kvack.org
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
The controller name is "debug". So it is pretty obvious what it is for.
However, the config prompt of "Example controller" is indeed a bit
vague. So I think we can make the prompt more descriptive here. As for
boot param, are you saying something like "cgroup_debug" has to be
specified in the command line also to have this controller activated
even if the CGROUP_DEBUG config parameter is specified? I am fine with
that if you think it is necessary.

Regards,
Longman


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
