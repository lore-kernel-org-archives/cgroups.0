From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 5/6] cgroup: implement cgroup v2 thread support
Date: Tue, 18 Jul 2017 13:23:14 -0400
Message-ID: <df14a222-f1f8-3415-b29a-2712c9e77f94@redhat.com>
References: <20170717020721.3612468-1-tj@kernel.org>
 <20170717020721.3612468-6-tj@kernel.org>
 <20170717141409.sqafufjupsiffnri@hirez.programming.kicks-ass.net>
 <825f2eaa-568a-a156-f04d-9235b20e2614@redhat.com>
 <5fa00590-551f-85d2-511b-ef4033781228@redhat.com>
 <20170718171034.GE585283@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 1C3814A6E6
In-Reply-To: <20170718171034.GE585283@devbig577.frc2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, lizefan@huawei.com, hannes@cmpxchg.org, mingo@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

On 07/18/2017 01:10 PM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Tue, Jul 18, 2017 at 10:37:41AM -0400, Waiman Long wrote:
>> Thinking about it some more. There is a place for invalid domain. It is
>> not the child of a threaded cgroup. It is the siblings of a threaded
>> cgroup whose parent is not root.
>>
>>        Root - A (domain) - B (domain)
>>                          \ C (domain)
>>
>> With "echo threaded > B/cgroup.type":
>>
>>        Root - A (threaded domain) - B (threaded)
>>                                   \ C (domain, invalid)
> Yes, I noted that when I was replying to Peter.
>
>> Any children of a threaded cgroup should be threaded.
> It's really difficult to discuss if you just declare that something
> should be a certain way without giving rationale for thinking so.
>
> If we could get rid of the invalid state completely that way, I'd
> completely agree with you but that isn't the case here as you noted
> yourself, so the choice between the two isn't something trivially
> clear.  Both choices come with their pros and cons.  We can absoultely
> discuss them comparing the pros and cons.
I am not advocating on removing the invalid state now as I note about
sibling cgroups. I am just saying that there is no point in not doing an
automatic conversion to threaded for newly created children of threaded
cgroups (not thread root). I don't see any cons in doing that.

Cheers,
Longman

