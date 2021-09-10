From: "taoyi.ty" <escape-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [RFC PATCH 2/2] support cgroup pool in v1
Date: Fri, 10 Sep 2021 10:15:02 +0800
Message-ID: <a91912e2-606a-0868-7a0c-38dec5012b02@linux.alibaba.com>
References: <cover.1631102579.git.escape@linux.alibaba.com>
 <03e2b37678c9b2aef4f5dee303b3fb87a565d56b.1631102579.git.escape@linux.alibaba.com>
 <YTiuLES5qd086qRu@kroah.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YTiuLES5qd086qRu-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shanpeic-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org


On 2021/9/8 下午8:35, Greg KH wrote:
> I thought cgroup v1 was "obsolete" and not getting new features added to
> it.  What is wrong with just using cgroups 2 instead if you have a
> problem with the v1 interface?
>
>    

There are two reasons for developing based on cgroup v1:


1. In the Internet scenario, a large number of services

are still using cgroup v1, cgroup v2 has not yet been

popularized.


2. The mechanism of cgroup pool refers to cgroup1_rename,

but for some reasons, a similar rename mechanism is not

implemented on cgroup v2, and I don't know the thoughts

behind this.

