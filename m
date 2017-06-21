From: Waiman Long <longman@redhat.com>
Subject: Re: [RFC PATCH-cgroup 1/6] cgroup: Relax the no internal process
 constraint
Date: Wed, 21 Jun 2017 17:37:00 -0400
Message-ID: <0c752151-f4aa-cda0-ba36-77cdc7dc25c6@redhat.com>
References: <1497452737-11125-1-git-send-email-longman@redhat.com>
 <1497452737-11125-2-git-send-email-longman@redhat.com>
 <20170621204050.GA14720@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com B59A230315C
In-Reply-To: <20170621204050.GA14720@htj.duckdns.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org

On 06/21/2017 04:40 PM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Wed, Jun 14, 2017 at 11:05:32AM -0400, Waiman Long wrote:
>>  2-4-3. No Internal Process Constraint
>>  
>> +When a non-root cgroup distributes resources to their children while
>> +having processes of its own, its internal processes will then compete
>> +against its children in term of resource allocation.  For some resource
>> +types, that is not a problem and the controllers are able to handle
>> +them correctly.  For others, the controllers may not be able to handle
>> +internal process competition correctly.  This type of controllers are
>> +called resource domain controllers in this document.
>> +
>> +Internal processes are not allowed on non-root cgroups which has
>> +any one of those resource domain controllers enabled.  Currently all
>> +controllers that are allowed in a threaded cgroup will be considered
>> +as a non-resource domain controller and hence will not block internal
>> +processes.  In other words, only cgroups which don't contain any
> This isn't on this patch but I'm not sure this is a good way to define
> resource domain controllers.  We probably should first define resource
> domains and walk our way in to the accompanying restrictions and then
> the distinction between the controller types.

This patch essentially allows internal process when non of the resource
domain controllers are enabled in the sense that they are activated by
the subtree_control file of the parent. I do agree that we should
probably define resource domain as a separate topic in this document. It
is true that a resource domain controller is not technically equivalent
to the !threaded controller, but this is the best that we have unless we
introduce another controller attribute for resource domain. I have tried
to do that in some of my past patches. I think PeterZ had suggested too.

The main purpose to not make thread mode special for internal process
handling. Instead, internal processes are allowed because no resource
domain controllers are enabled whether or not thread mode is enabled or
not. I think that is more consistent than treating thread mode as special.

> ...
>> +Note that the restriction doesn't get in the way if there is no resource
>> +domain controller enabled in the cgroup's "cgroup.subtree_control".
>> +This is important as otherwise it wouldn't be possible to create
>> +children of a populated cgroup.  To control resource distribution
>> +of a cgroup, the cgroup must create children and transfer all
>> +its processes to the children before enabling controllers in its
>> +"cgroup.subtree_control" file.
> What happens when we add domain handling to CPU so that it is both a
> domain and resource controller?  Even if that somehow can be resolved,
> wouldn't that come with a rather surprising userland behavior changes?
> Also, I'm not sure what we're achieving by doing this.  It doesn't
> really relax the restriction.  It just turns it off implicitly when
> certain conditions are met, which doesn't really allow any real
> capabilities and at least to me the behaviors feel more subtle and
> complicated than before.
>
> Thanks.

I think CPU isn't a good example for that.

Another alternative is to treat no internal process as a controller
attribute. Then we don't need to worry about this intricate question and
let the  controllers decide if they will allow internal processes.

Cheers,
Longman


