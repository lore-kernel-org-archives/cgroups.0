From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm/backing-dev: show state of all bdi_writeback in
 debugfs
Date: Tue, 23 Jul 2019 13:07:29 -0700
Message-ID: <20190723130729.522976a1f075d748fc946ff6@linux-foundation.org>
References: <156388617236.3608.2194886130557491278.stgit@buzz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563912450;
        bh=aJAwIMG/PcNFQKUZTnI3xqTnmOSc6qBWaaEdBvulUpA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VX9USo4Gy2dVgkf+TNz6HITq9P3GchWQKOUSzY/le0qD3BWAE3Fbfj7zdKjsmUOzb
         Dd1tT7mXRLQHqbUBmsJ2jqrXD2UEQHY2yKfHn0GeQXCYvKA/9zMzwnYY5F7fXbovHX
         FImaoH6ldCnadpDFM15AqXu4eNYu4RKODmNdv8DM=
In-Reply-To: <156388617236.3608.2194886130557491278.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>

On Tue, 23 Jul 2019 15:49:32 +0300 Konstantin Khlebnikov <khlebnikov@yandex-team.ru> wrote:

> Currently /sys/kernel/debug/bdi/$maj:$min/stats shows only root bdi wb.
> With CONFIG_CGROUP_WRITEBACK=y there is one for each memory cgroup.
> 
> This patch shows here state of each bdi_writeback in form:
> 
> <global state>
> 
> Id: 1
> Cgroup: /
> <root wb state>
> 
> Id: xxx
> Cgroup: /path
> <cgroup wb state>
> 
> Id: yyy
> Cgroup: /path2
> <cgroup wb state>

Why is this considered useful?  What are the use cases.  ie, why should
we add this to Linux?

> mm/backing-dev.c |  106 +++++++++++++++++++++++++++++++++++++++++++++++-------
> 1 file changed, 93 insertions(+), 13 deletions(-)

No documentation because it's debugfs, right?

I'm struggling to understand why this is a good thing :(.  If it's
there and people use it then we should document it for them.  If it's
there and people don't use it then we should delete the code.

