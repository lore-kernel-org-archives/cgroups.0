From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v13 00/11] cpuset: Enable cpuset controller in default
 hierarchy
Date: Mon, 15 Oct 2018 13:04:21 -0400
Message-ID: <89b64577-f20e-47d8-03a6-c047e5107271@redhat.com>
References: <1539366951-8498-1-git-send-email-longman@redhat.com>
 <20181015163540.GQ270328@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181015163540.GQ270328@devbig004.ftw2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On 10/15/2018 12:35 PM, Tejun Heo wrote:
> Hello, Waiman.
>
> This looks great to me.  I have only one small nit in terms of
> interface.  Currently, cpuset.partition file uses -1, 0, 1; however,
> given that this is consistent with how cgroup.type behaves (something
> can be set but may be invalid), I wonder whether using a similar
> syntax would be more consistent.  e.g. sth like cpuset.type which
> takes "normal" or "partition" and shows one of "normal", "partition"
> and "partition invalid".  I'd be perfectly happy with that being a
> follow-up patch.

Sure. I can send a follow-up patch to add that.
> Peter, does the patchset look good to you?  It does everything we want
> it to in terms of sched domain partitioning and is compliant all
> cgroup2 conventions.  If so, I'll apply the series to the cgroup devel
> branch.
>
> Thank you very much for the work and persistence!
>
Thanks for the comment. There is a minor bug in patch 3 because of the 2
possibilities of how cpumask_var_t can be defined. I will send updated
version of that patch to fix that.

-Longman


