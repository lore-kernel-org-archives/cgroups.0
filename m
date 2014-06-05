From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH 2/3] cgroup: make the default root invisible when it's
 umounted
Date: Thu, 5 Jun 2014 09:49:23 +0800
Message-ID: <538FCCA3.8060108@huawei.com>
References: <538D4956.5050205@huawei.com> <538D4982.10905@huawei.com> <20140603130144.GB26210@htj.dyndns.org> <538EE00F.10406@huawei.com> <20140605012011.GB14370@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140605012011.GB14370@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On 2014/6/5 9:20, Tejun Heo wrote:
> Hello,
> 
> On Wed, Jun 04, 2014 at 04:59:59PM +0800, Li Zefan wrote:
>> The example I gave is the same result if sane_behavior is not specified,
>> so this is a behavioural change for the old interface?
> 
> Hmmm?  Either the userland knows about unified hierarchy or not and
> there's no point in hiding it if we know that userland knows.  It's
> really a system-wide thing which happens once.
> 

Yeah, it's reasonable.

I thought "mount -t cgroup xxx /cgroup" will mount the default hierarchy,
but I was wrong.
