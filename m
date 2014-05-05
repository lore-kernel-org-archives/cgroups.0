From: Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH cgroup/for-3.15-fixes] blkcg: use trylock on blkcg_pol_mutex
 in blkcg_reset_stats()
Date: Mon, 05 May 2014 13:47:10 -0400
Message-ID: <5367CE9E.5010208@oracle.com>
References: <5363C04B.4010400@oracle.com> <20140505163730.GL11231@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140505163730.GL11231@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Cc: axboe@kernel.dk, LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>, cgroups@vger.kernel.org

Hey Tejun,

On 05/05/2014 12:37 PM, Tejun Heo wrote:
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Li Zefan <lizefan@huawei.com>
> References: http://lkml.kernel.org/g/5363C04B.4010400@oracle.com

I think that the Reported-by here should be me :)


Thanks,
Sasha
