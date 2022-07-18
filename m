From: "taoyi.ty" <escape-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: Question about disallowing rename(2) in cgroup v2
Date: Mon, 18 Jul 2022 15:42:34 +0800
Message-ID: <5ee0bd70-5381-1219-7a52-772f80a11b52@linux.alibaba.com>
References: <1c9d5118-25fa-e791-8aed-b1430cf23d36@linux.alibaba.com>
 <20220715124538.GB8646@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220715124538.GB8646-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi, Michal

Thanks for your reply.

在 7/15/22 8:45 PM, Michal Koutný 写道:
> Strictly speaking, it's not critical if you decouple your job and cgroup
> naming scheme (i.e. use the cgroup with the old name).

Though using the cgroup with the old name is ok, but naming rule of 
cgroup used by container is containerd-<ID>, it's confusing for 
different containers to use cgroup with same name

> Do you have some numbers for this?
For 200 container concurrent startup, it can reduce 94% of the cgroups 
creation time if using cgroup pool based on cgroup1_rename(). More 
detail data can be seen in section 3.3 and 4.4 of 
https://www.usenix.org/system/files/atc22-li-zijun-rund.pdf

> You can save work with not rmdir/mkdir'ing but you mention
> concurrent startup specifically. And you still need to (re)setup
> the cgroups after reuse and that also isn't parallelizable (at least you
> need to (re)populate each reused cgroup, which is mostly under one
> lock). (Even cgroup1_rename() has an exclusive section under
> cgroup_mutex but it looks relatively simply.)
Yes, reusing cgroup isn't parallelizable, it just eases but doesn’t 
solve the underlying problem. The current bottleneck has been solved 
temporarily by cgroup pool, how to make creating cgroup and attaching 
tasks parallelizable requires more thought and research

Thanks.

Escape
