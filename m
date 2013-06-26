From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH cgroup/for-3.11] cgroup: grab cgroup_mutex in drop_parsed_module_refcounts()
Date: Wed, 26 Jun 2013 17:12:49 +0800
Message-ID: <51CAB091.1030405@huawei.com>
References: <51C9D17B.5090208@oracle.com> <20130626010454.GD30407@mtj.dyndns.org> <20130626010521.GE30407@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130626010521.GE30407@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, LKML <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, trinity@vger.kernel.org

On 2013/6/26 9:05, Tejun Heo wrote:
> This isn't strictly necessary as all subsystems specified in
> @subsys_mask are guaranteed to be pinned; however, it does spuriously
> trigger lockdep warning.  Let's grab cgroup_mutex around it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Li Zefan <lizefan@huawei.com>
