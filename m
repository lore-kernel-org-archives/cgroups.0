From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v2 1/4] cgroup: Child cgroup creation not allowed on
 invalid domain
Date: Mon, 24 Jul 2017 13:48:51 -0400
Message-ID: <0025abb5-8bff-0d17-4050-3a515891933d@redhat.com>
References: <1500669293-21792-1-git-send-email-longman@redhat.com>
 <1500669293-21792-2-git-send-email-longman@redhat.com>
 <20170722134358.GB3329631@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 89279C00C108
In-Reply-To: <20170722134358.GB3329631@devbig577.frc2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

On 07/22/2017 09:43 AM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Fri, Jul 21, 2017 at 04:34:50PM -0400, Waiman Long wrote:
>> When thread mode is used, it is possible that some cgroups may be
>> in an invalid state. Currently users may not be aware that they are
>> invalid until they try to migrate tasks over. This patch disallows
>> child cgroup creation on invalid domain. This adds one more failure
>> point in reminding users that they are dealing with invalid domains.
>> It also minimizes the number of invalid domains outstanding as much
>> as possible.
> It's a bit inconsistent because we can reach the same forbidden state
> by turning a sibling cgroup threaded.  Please consider the following.
>
>      A
>     / \
>    B   C
>         \
> 	 D
>
> Let's say all are domains and we make B threaded.  A becomes the
> threaded domain, C and D become invalid, which is the configuration
> you're trying to prevent.  We can either enabling threaded on B too or
> relax type modifications further so that people can make C threaded
> which makes sense given that that would lead to a topology which has
> to supported anyway (if C were threaded before D was created, it'd
> look the same).
>
> So, I'm leaning more towards relaxing restrictions and tightening it,
> and given that we have to expose invalid state anyway, I think there's
> actual benefit in doing so as it gives more flexibility while building
> the hierarchy.

Yes, I totally understand that we could have this happened in a sibling
node. It is just my idea to make users become more aware that they are
dealing with an invalid domain cgroup. It was just a suggestion on my
part and I am totally fine if it is not merged.

Cheers,
Longman


