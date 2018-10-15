From: Tom Hromatka <tom.hromatka@oracle.com>
Subject: Re: [PATCH v13 01/11] cpuset: Enable cpuset controller in default
 hierarchy
Date: Mon, 15 Oct 2018 12:31:37 -0600
Message-ID: <bfa8d0a2-ce78-8a0b-2a2e-45b02d6a8239@oracle.com>
References: <1539366951-8498-1-git-send-email-longman@redhat.com>
 <1539366951-8498-2-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=lP3s8su0hYbbuQqJ17aoW8Pq6QaJdWfCtPAiwg6se4k=;
 b=gioilvQ+vzOiH5rqVOLOIyJNbEM5Mv7pD3bq4h+39Rggr91GnepZA61Ynb//5aDmbYUI
 youfGluYpd4B7Wpy7rf4IakZCRoaJVPnM3D8kmM5RIDICuuQfs7bFkU6VI8HuYgrNDRD
 vNmk7GPGYlNB8nEWFEVrTdZkwb9dXb1BtWuzv+AIoZ4G4LcG/z4hcqqmXOKsq9ZeEy2/
 kPacCZoPMQ43BI1eLjMKsAAF8MoGHo8n+3cekP7wg/gfN+mYwjmcO09h2fP10Q7QYRrK
 oYv3uNo4eLNP3zzz84QZjsVvkU8uAShG3q9bpVaDymKbSS/Ew4/pE9D4pd70exvnw+U6 NQ== 
In-Reply-To: <1539366951-8498-2-git-send-email-longman@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>



On 10/12/2018 11:55 AM, Waiman Long wrote:
> Given the fact that thread mode had been merged into 4.14, it is now
> time to enable cpuset to be used in the default hierarchy (cgroup v2)
> as it is clearly threaded.
>
> The cpuset controller had experienced feature creep since its
> introduction more than a decade ago. Besides the core cpus and mems
> control files to limit cpus and memory nodes, there are a bunch of
> additional features that can be controlled from the userspace. Some of
> the features are of doubtful usefulness and may not be actively used.
>
> This patch enables cpuset controller in the default hierarchy with
> a minimal set of features, namely just the cpus and mems and their
> effective_* counterparts.  We can certainly add more features to the
> default hierarchy in the future if there is a real user need for them
> later on.

I really appreciate this simplification of the cpuset controller.

I currently have an in-house customer that is unhappy with the
way cgroups cpuset v1 handles offlined CPUs.  This patchset makes two
significant improvements over current cpuset v1 behavior.  1) It allows
for offlined CPUs to be added to a cpuset (even though the CPU is
offline) and 2) it restores CPUs back to the requested cpuset when they
come back online.  This is more intuitive and secure for my customers.
Thank you!

In part because of this patchset, I plan on proposing similar behavior
for offlined CPUs to cpuset v1.

Thanks.

Tom
