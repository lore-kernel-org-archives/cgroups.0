From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: + memcg-do-not-report-racy-no-eligible-oom-tasks.patch added to
 -mm tree
Date: Sat, 26 Jan 2019 10:09:18 +0900
Message-ID: <38234fd5-d1eb-aa2d-b792-513855b2ae3b@i-love.sakura.ne.jp>
References: <20190109190306.rATpT%akpm@linux-foundation.org>
 <20190125165624.GA17719@cmpxchg.org> <20190125172416.GB20411@dhcp22.suse.cz>
 <20190125183333.GA19686@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190125183333.GA19686@cmpxchg.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>

On 2019/01/26 3:33, Johannes Weiner wrote:
> On Fri, Jan 25, 2019 at 06:24:16PM +0100, Michal Hocko wrote:
>> On Fri 25-01-19 11:56:24, Johannes Weiner wrote:
>>> It looks like this problem is happening in production systems:
>>>
>>> https://www.spinics.net/lists/cgroups/msg21268.html
>>>
>>> where the threads don't exit because they are trapped writing out the
>>> oom messages to a slow console (running the reproducer from this email
>>> thread triggers the oom flooding).
>>>
>>> So IMO we should put this into 5.0 and add:
>>
>> Please note that Tetsuo has found out that this will not work with the
>> CLONE_VM without CLONE_SIGHAND cases and his http://lkml.kernel.org/r/01370f70-e1f6-ebe4-b95e-0df21a0bc15e@i-love.sakura.ne.jp
>> should handle this case as well. I've only had objections to the
>> changelog but other than that the patch looked sensible to me.
> 
> I see. Yeah that looks reasonable to me too.
> 
> Tetsuo, could you include the Fixes: and CC: stable in your patch?
> 

Andrew Morton is still offline. Do we want to ask Linus Torvalds?
