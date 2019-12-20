From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] oom: choose a more suitable process to kill while all
 processes are not killable
Date: Fri, 20 Dec 2019 08:13:34 +0100
Message-ID: <20191220071334.GB20332@dhcp22.suse.cz>
References: <1576823172-25943-1-git-send-email-zgpeng.linux@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1576823172-25943-1-git-send-email-zgpeng.linux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: zgpeng.linux@gmail.com
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com, shakeelb@google.com, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, zgpeng <zgpeng@tencent.com>

On Fri 20-12-19 14:26:12, zgpeng.linux@gmail.com wrote:
> From: zgpeng <zgpeng@tencent.com>
> 
> It has been found in multiple business scenarios that when a oom occurs
> in a cgroup, the process that consumes the most memory in the cgroup is 
> not killed first. Analysis of the reasons found that each process in the
> cgroup oom_score_adj is set to -998, oom_badness in the calculation of 
> points, if points is negative, uniformly set it to 1.

Can you provide an example of the oom report?
-- 
Michal Hocko
SUSE Labs
