From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v5 1/2] cpuset: Enable cpuset controller in default
 hierarchy
Date: Tue, 20 Mar 2018 18:01:31 -0400
Message-ID: <eae1cbd1-4b49-e79b-f6d4-bf62e828ebf1@redhat.com>
References: <1521148842-15486-1-git-send-email-longman@redhat.com>
 <1521148842-15486-2-git-send-email-longman@redhat.com>
 <20180319155937.GQ2943022@devbig577.frc2.facebook.com>
 <1881c1da-56ec-d76b-b736-fd0919737ec6@redhat.com>
 <20180320201029.GO519464@devbig577.frc2.facebook.com>
 <2b9261b8-6a3a-81d1-9c9a-394524a0d413@redhat.com>
 <20180320211417.GA2149215@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180320211417.GA2149215@devbig577.frc2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

On 03/20/2018 05:14 PM, Tejun Heo wrote:
> Hello,
>
> On Tue, Mar 20, 2018 at 04:53:37PM -0400, Waiman Long wrote:
>> ASAIK for v2, when cpuset.cpus is empty, cpuset.effective_cpus will show
>> all the cpus available from the parent. It is a different behavior from
>> v1. So do we still need a cpuset.cpus_available?
> Heh, you're right.  Let's forget about available and do
> cpuset.cpus.effective.  The primary reason for suggesting that was
> because of the similarity with cgroup.controllers and
> cgroup.subtree_control; however, they're that way because
> subtree_control is delegatable.  For a normal resource knob like
> cpuset.cpus, the knob is owned by the parent and what's interesting to
> the parent is its effective set that it's distributing from.

OK, will change the names as suggested.

-Longman
