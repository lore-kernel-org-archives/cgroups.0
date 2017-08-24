From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] cpuset: Allow cpuset controller in default hierarchy
Date: Thu, 24 Aug 2017 10:56:21 -0400
Message-ID: <863b01d0-e724-dab6-258e-d5980f985938@redhat.com>
References: <1503585611-13496-1-git-send-email-longman@redhat.com>
 <20170824144322.GP491396@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170824144322.GP491396@devbig577.frc2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 08/24/2017 10:43 AM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Thu, Aug 24, 2017 at 10:40:11AM -0400, Waiman Long wrote:
>> Given the fact that thread mode is now queued for 4.14, it is now
>> time to enable cpuset to be used in the default hierarchy (cgroup v2)
>> as it is clearly threaded.
> I'm not sure we want things like exclusive settings in v2 as it
> directly violates basic hierarchy rules (a sibling shouldn't be able
> to affect what another sibling can or can't do).  We need to think
> more about what should be exposed in v2.

Thank for the quick response.

The main reason for sending out this patch is to figure out what exactly
is in your mind before enabling cpuset in v2.

From my point of view, the exclusive setting makes cpuset behave more
like a resource domain that a resource allocated to one cgroup won't be
available for another cgroup. So we can argue it both ways whether it
violates the basic hierarchy rules or not.

I will be in the Plumbers Conference next month and we can talk more
about this. My goal is to make cgroup v2 ready for prime time hopefully
by the end of the year.

Cheers,
Longman

