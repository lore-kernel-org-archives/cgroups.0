From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2 05/29] slab: rename gfpflags to allocflags
Date: Fri, 11 May 2012 12:54:03 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1205111253510.31049@router.home>
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-6-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1336758847; bh=s2+D3DFtO0ezm/n3U3eXWL+paVJGY7VnjhE8JuzhaX4=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=N0fDCWmCcTE+mvQ9b2uvmwHuH977YDi0TzGF1IZcofSixGxrwMfrVFb2EhKX9mu0lYJqDqu/nIhVTduh5FMBSGOaS461sTCCdO9W1UHsi+4O+9HAmourNjDNZyTdpUgfh9SJkda6B/MK94W22aNDXgHo8daDvVysa6RSah4tuIg=
In-Reply-To: <1336758272-24284-6-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>, Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org, Pekka Enberg <penberg@cs.helsinki.fi>

On Fri, 11 May 2012, Glauber Costa wrote:

> A consistent name with slub saves us an acessor function.
> In both caches, this field represents the same thing. We would
> like to use it from the mem_cgroup code.

Acked-by: Christoph Lameter <cl@linux.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
