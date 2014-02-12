From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] cgroup: protect modifications to cgroup_idr with cgroup_mutex
Date: Wed, 12 Feb 2014 17:26:40 +0800
Message-ID: <52FB3E50.8020809@huawei.com>
References: <52F9D9DA.7040108@huawei.com> <20140211102032.GA11946@dhcp22.suse.cz> <20140212091238.GC28085@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140212091238.GC28085@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On 2014/2/12 17:12, Michal Hocko wrote:
> Li has pointed out that my previous backport was not correct because
> err_unlock label releases a reference to supperblock which was not taken
> before idr_alloc. I've also removed cgroup_mutex from free_css_id as per
> Li.
> Fixed in this version.
> 

Looks good to me!

Are you going to send it to stable mailing list after the fix hits mainline
or use it internally?

It has small conflicts with this patch that will also be backported to 3.12:

https://git.kernel.org/cgit/linux/kernel/git/tj/cgroup.git/commit/kernel/cgroup.c?h=for-3.14-fixes&id=b58c89986a77a23658682a100eb15d8edb571ebb
