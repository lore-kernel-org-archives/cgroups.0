From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [GIT PULL] blk-throttle: implement proper hierarchy support
Date: Wed, 15 May 2013 10:05:35 +0200
Message-ID: <20130515080535.GB3276@kernel.dk>
References: <20130514210933.GW6795@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130514210933.GW6795@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>, Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org, cgroups@vger.kernel.org

On Tue, May 14 2013, Tejun Heo wrote:
> Hello, Jens.
> 
> This is the pull request for patches which implement proper hierarchy
> support in blk-throttle and remove .broken_hierarchy tagging from
> blkcg.
> 
>   http://thread.gmane.org/gmane.linux.kernel.cgroups/7119
> 
> The implementation is fairly straight-forward in that it just repeats
> the same scheduling at each layer until it reaches the top and thus
> isn't very scalable.  It also still has an issue where a nested cgroup
> could get lower than configured limits as it travels towards root but
> the severity is at an acceptable level after Vivke's start time
> adjustment patch.  The issue ultimately is a problem in the scheduling
> algorithm itself and can also show up in flat hierarchy given the
> right (well, wrong) IO pattern.  If it still is an actual problem,
> which I don't think is, we should be able to work on it later on in
> fairly isolated manner.
> 
> While the implementation isn't perfect, it should be good enough in
> most cases with a few levels of nesting and this allows the rest of
> cgroup to proceed towards unified hierarchy handling.
> 
> The series is based on top of v3.10-rc1 and available in the following
> git branch
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blk-throttle-hierarchy
> 
> for you to fetch changes up to 9138125beabbb76b4a373d4a619870f6f5d86fc5:
> 
>   blk-throttle: implement proper hierarchy support (2013-05-14 13:52:38 -0700)

Thanks Tejun, I'll pull this in for 3.11.

-- 
Jens Axboe
