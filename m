From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 6/6] cgroup: update debug controller to print out thread
 mode information
Date: Wed, 19 Jul 2017 11:41:09 -0400
Message-ID: <c857861d-ac8c-9fe6-c8d2-c023dcc26809@redhat.com>
References: <20170717020721.3612468-1-tj@kernel.org>
 <20170717020721.3612468-7-tj@kernel.org>
 <f6025fbf-bd53-dcd7-a5f7-d7e7a97da788@redhat.com>
 <20170719153105.GM3365493@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 59A363DBE5
In-Reply-To: <20170719153105.GM3365493@devbig577.frc2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

On 07/19/2017 11:31 AM, Tejun Heo wrote:
> Hello,
>
> On Mon, Jul 17, 2017 at 05:19:16PM -0400, Waiman Long wrote:
>>> +	if (cgroup_is_thread_root(css->cgroup))
>>> +		seq_puts(seq, "[thread root]\n");
>>> +	else if (cgroup_is_threaded(css->cgroup))
>>> +		seq_puts(seq, "[threaded]\n");
>> The cgroup status will not be needed anymore as you have introduced the
>> cgroup.type control file that returns the proper information.
> Ah, right, will drop this file.
>
> Thanks.
>
Oh, I am not saying that we should drop the whole patch. I just want to
drop the above 4 line of codes as they are not needed.

Thanks,
Longman

