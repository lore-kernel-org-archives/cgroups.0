From: Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH] cgroup: missing rcu read lock around task_css_set
Date: Mon, 03 Mar 2014 17:48:19 -0500
Message-ID: <531506B3.5030004@oracle.com>
References: <1393729211-937-1-git-send-email-sasha.levin@oracle.com> <20140303223327.GB26523@mtj.dyndns.org> <5315057F.3030602@oracle.com> <20140303224505.GE26523@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140303224505.GE26523@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 03/03/2014 05:45 PM, Tejun Heo wrote:
> On Mon, Mar 03, 2014 at 05:43:11PM -0500, Sasha Levin wrote:
>> On 03/03/2014 05:33 PM, Tejun Heo wrote:
>>> On Sat, Mar 01, 2014 at 10:00:11PM -0500, Sasha Levin wrote:
>>>> rcu read lock should be held when calling and working with task_css_set.
>>>>
>>>> This patch also fixes a related lockdep warning.
>>>
>>> Hmmm... PF_EXITING should be visible at that point and cset can't
>>> change anymore.  We prolly need to update lockdep annotation rather
>>> than adding spurious rcu locking around it.  Against which branch is
>>> it?  Can you please post the lockdep warning?
>>
>> I see it on -next.
>
> I think the right thing to do is using task_css_set_check() with
> PF_EXITING check and add comment explaining that cset can no longer
> change.  Can you please write up a patch?

Sure!


Thanks,
Sasha
