From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] cgroup: add cgroup.stat interface with basic hierarchy
 stats
Date: Thu, 27 Jul 2017 13:38:55 -0400
Message-ID: <6a72e074-e01f-b93f-2c03-2bd0366d005b@redhat.com>
References: <20170727161420.2552-1-guro@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20170727161420.2552-1-guro@fb.com>
Content-Language: en-US
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <guro@fb.com>, cgroups@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, kernel-team@fb.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On 07/27/2017 12:14 PM, Roman Gushchin wrote:
> Add a cgroup.stat interface to the base cgroup control files
> with the following metrics:
>
> nr_descendants		total number of descendant cgroups
> nr_dying_descendants	total number of dying descendant cgroups
> max_descendant_depth	maximum descent depth below the current cgroup

Both nr_descendants and max_descendant_depth can be found easily from
userspace by scanning the cgroup directory. nr_dying_descendants is a
transient figure and it should be 0 most of the time. So I wonder how
useful it can be.

This new interface file will be more useful if it can reveal information
that cannot be easily obtained by looking from userspace alone.

Cheers,
Longman


