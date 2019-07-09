From: "Peng Wang" <rocking@whu.edu.cn>
Subject: RE: [PATCH] cgroup: simplify code for cgroup_subtree_control_write()
Date: Tue, 9 Jul 2019 09:55:54 +0800
Message-ID: <000301d535f9$71f1ab90$55d502b0$@whu.edu.cn>
References: <20190708130132.5582-1-rocking@whu.edu.cn> <20190708144121.GA657710@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190708144121.GA657710@devbig004.ftw2.facebook.com>
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 'Tejun Heo' <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Monday, July 8, 2019 10:41 PM, Tejun Heo wrote:
> On Mon, Jul 08, 2019 at 09:01:32PM +0800, Peng Wang wrote:
> > Process "enable" and "disable" earlier to simplify code.
> 
> I don't think this is correct and even if it were the value of this
> change is close to none, so nack on this one.

OK. 
Although I have tested this patch for common case, It's just somewhat trivial.

Thanks for your time :-).

> 
> Thanks.
> 
> --
> tejun

