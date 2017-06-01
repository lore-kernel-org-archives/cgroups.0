From: Waiman Long <longman@redhat.com>
Subject: Re: [RFC PATCH v2 11/17] cgroup: Implement new thread mode semantics
Date: Thu, 1 Jun 2017 14:41:24 -0400
Message-ID: <9e95a3b2-2922-f5f7-f424-7ae0639b6e68@redhat.com>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
 <1494855256-12558-12-git-send-email-longman@redhat.com>
 <20170519202624.GA15279@wtj.duckdns.org>
 <b1d02881-f522-8baa-5ebe-9b1ad74a03e4@redhat.com>
 <20170524203616.GO24798@htj.duckdns.org>
 <9b147a7e-fec3-3b78-7587-3890efcd42f2@redhat.com>
 <20170524212745.GP24798@htj.duckdns.org>
 <20170601145042.GA3494@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 9276C334588
In-Reply-To: <20170601145042.GA3494@htj.duckdns.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de

On 06/01/2017 10:50 AM, Tejun Heo wrote:
> Hello, Waiman.
>
> A short update.  I tried making root special while keeping the
> existing threaded semantics but I didn't really like it because we
> have to couple controller enables/disables with threaded
> enables/disables.  I'm now trying a simpler, albeit a bit more
> tedious, approach which should leave things mostly symmetrical.  I'm
> hoping to be able to post mostly working patches this week.

I am looking forward to your patches.

> Also, do you mind posting the debug patches as a separate series?
> Let's get the bits which make sense indepdently in the tree.

I am going to do that. The debug patches, however, will have dependency
on other cgroup patches and so will need to be posted after the core
patches.

Cheers,
Longman
