From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] cgroup: add cgroup.stat interface with basic hierarchy
 stats
Date: Thu, 27 Jul 2017 18:46:13 +0100
Message-ID: <20170727174613.GA6457@castle.DHCP.thefacebook.com>
References: <20170727161420.2552-1-guro@fb.com>
 <6a72e074-e01f-b93f-2c03-2bd0366d005b@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=eAO0Y6uh8OxXzAWyVr7cqDcN7fijo8rpgZrQHKsLVbk=;
 b=H2M2Yy57KO1RFl5lH2b2sDJ52f4ouj26CxkSoorscWq89E6lwcymvY63ZbPKp5nbwamz
 BeYq98YzajLFLE2tScM3+5wWHz4oOBBUb7uw4IVXVx5vrum8xBI04bVobE/zRwfrSWRo
 E34LNzKwYChBdV49e4R1UOCjmiPTtbG/1ng= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=eAO0Y6uh8OxXzAWyVr7cqDcN7fijo8rpgZrQHKsLVbk=;
 b=g5MqkhqeGzsom87OaYIPWFlrPRtgVVKsfiN6T+baaoNRvkpDmJ2C7xAvCO3SIfk0WUHpgn3xejsgJKOtPEmT0yfwXv4Zf6d18odrl/fnScIeH9yvgXNHitVvh9w4Gf5DrDVN8gjWp6/wfx9yYaPKgdTrxDJTk3F2ns2erIh5ubY=
Content-Disposition: inline
In-Reply-To: <6a72e074-e01f-b93f-2c03-2bd0366d005b@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, kernel-team@fb.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Jul 27, 2017 at 01:38:55PM -0400, Waiman Long wrote:
> On 07/27/2017 12:14 PM, Roman Gushchin wrote:
> > Add a cgroup.stat interface to the base cgroup control files
> > with the following metrics:
> >
> > nr_descendants		total number of descendant cgroups
> > nr_dying_descendants	total number of dying descendant cgroups
> > max_descendant_depth	maximum descent depth below the current cgroup
> 
> Both nr_descendants and max_descendant_depth can be found easily from
> userspace by scanning the cgroup directory. nr_dying_descendants is a
> transient figure and it should be 0 most of the time. So I wonder how
> useful it can be.
> 
> This new interface file will be more useful if it can reveal information
> that cannot be easily obtained by looking from userspace alone.

A cgroup can be in dying state for substantional amount of time
(imagine a memcg which holds a page mlocked by a process in an other cgroup).

The total amount of cgroups, as well as tree depth include dying cgroups,
which are not visible from the userspace.

The main purpose of this interface is to have a reasonable way to check if
there are no leaks/refcounting issues, which prevents cgroups from being
completely freed.

Thanks!

Roman
