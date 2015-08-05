From: Zefan Li <lizefan@huawei.com>
Subject: Re: [PATCH 2/4] cgroup: define controller file conventions
Date: Wed, 5 Aug 2015 16:19:14 +0800
Message-ID: <55C1C702.3020400@huawei.com>
References: <1438547024-23497-1-git-send-email-tj@kernel.org> <1438547024-23497-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438547024-23497-3-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com, avanzini.arianna@gmail.com, cgroups@vger.kernel.org, kernel-team@fb.com

On 2015/8/3 4:23, Tejun Heo wrote:
> Traditionally, each cgroup controller implemented whatever interface
> it wanted leading to interfaces which are widely inconsistent.
> Examining the requirements of the controllers readily yield that there
> are only a few control schemes shared among all.
> 
> Two major controllers already had to implement new interface for the
> unified hierarchy due to significant structural changes.  Let's take
> the chance to establish common conventions throughout all controllers.
> 
> This patch defines CGROUP_WEIGHT_MIN/DFL/MAX to be used on all weight
> based control knobs and documents the conventions that controllers
> should follow on the unified hierarchy.  Except for io.weight knob,
> all existing unified hierarchy knobs are already compliant.  A
> follow-up patch will update io.weight.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>

acked
