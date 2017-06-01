From: Waiman Long <longman@redhat.com>
Subject: Re: [RFC PATCH v2 11/17] cgroup: Implement new thread mode semantics
Date: Thu, 1 Jun 2017 14:44:48 -0400
Message-ID: <ffa991a3-074d-ffd5-7a6a-556d6cdd08fe@redhat.com>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
 <1494855256-12558-12-git-send-email-longman@redhat.com>
 <20170519202624.GA15279@wtj.duckdns.org>
 <b1d02881-f522-8baa-5ebe-9b1ad74a03e4@redhat.com>
 <20170524203616.GO24798@htj.duckdns.org>
 <9b147a7e-fec3-3b78-7587-3890efcd42f2@redhat.com>
 <20170524212745.GP24798@htj.duckdns.org>
 <20170601145042.GA3494@htj.duckdns.org>
 <20170601151045.xhsv7jauejjis3mi@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com AB6383DBDE
In-Reply-To: <20170601151045.xhsv7jauejjis3mi@hirez.programming.kicks-ass.net>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de

On 06/01/2017 11:10 AM, Peter Zijlstra wrote:
> On Thu, Jun 01, 2017 at 10:50:42AM -0400, Tejun Heo wrote:
>> Hello, Waiman.
>>
>> A short update.  I tried making root special while keeping the
>> existing threaded semantics but I didn't really like it because we
>> have to couple controller enables/disables with threaded
>> enables/disables.  I'm now trying a simpler, albeit a bit more
>> tedious, approach which should leave things mostly symmetrical.  I'm
>> hoping to be able to post mostly working patches this week.
> I've not had time to look at any of this. But the question I'm most
> curious about is how cgroup-v2 preserves the container invariant.
>
> That is, each container (namespace) should look like a 'real' machine.
> So just like userns allows to have a uid-0 (aka root) for each container
> and pidns allows a pid-1 for each container, cgroupns should provide a
> root group for each container.
>
> And cgroup-v2 has this 'exception' (aka wart) for the root group which
> needs to be replicated for each namespace.

One of the changes that I proposed in my patches was to get rid of the
no internal process constraint. I think that will solve a big part of
the container invariant problem that we have with cgroup v2.

Cheers,
Longman
