From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: Re: [PATCH] mm: memcontrol: let v2 cgroups follow changes in system
 swappiness
Date: Sat, 9 Apr 2016 11:58:15 +0300
Message-ID: <20160409085815.GB11428@esperanza>
References: <1460155744-15942-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:To:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=1WSQ5RQWEq3n2yeuI5z1tU/6ll3mxPDVRd85HzSgkXQ=;
 b=QEtF4DJYfQi3QrJTsUsbSIjFu4W+Hfzv4XK/Iu9/nHZqzFKSL5AHrq04YNVfqPPGjyfWNpHYA7RNBR2Ml8fJTsiqhliyXfMsxEekaTtOlS/qpssr0D7VcqiP7h2hlE7v4qcdD49+amvQlw8bFFcePNu0mIKXVEJg2AhKKZxxAyw=
Content-Disposition: inline
In-Reply-To: <1460155744-15942-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Fri, Apr 08, 2016 at 06:49:04PM -0400, Johannes Weiner wrote:
> Cgroup2 currently doesn't have a per-cgroup swappiness setting. We
> might want to add one later - that's a different discussion - but
> until we do, the cgroups should always follow the system setting.
> Otherwise it will be unchangeably set to whatever the ancestor
> inherited from the system setting at the time of cgroup creation.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: stable@vger.kernel.org # 4.5

Acked-by: Vladimir Davydov <vdavydov@virtuozzo.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
