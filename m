From: Tianxianting <tian.xianting-vVzyEvZLFYE@public.gmane.org>
Subject: RE: [PATCH] blkcg: add plugging support for punt bio
Date: Wed, 9 Sep 2020 01:22:26 +0000
Message-ID: <a819f736609e44b6a75b7b877901b270@h3c.com>
References: <1596722082-31817-1-git-send-email-xianting_tian@126.com>
 <8f84e1fe-9fa5-b7e7-1f2f-b0c4a40614e2@kernel.dk>
 <42b939c2.e08.173c6f79af9.Coremail.xianting_tian@126.com>
 <1ded6246.2c67.17458ce4300.Coremail.xianting_tian@126.com>
 <65e1e040da644ed9a05edd166d06b5e3@h3c.com>
 <20200908180302.GE4295@mtj.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200908180302.GE4295-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Content-Language: zh-CN
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Thanks TJ and your previous guide to me.
I will summarize and resubmit the patch.

-----Original Message-----
From: Tejun Heo [mailto:htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org] On Behalf Of Tejun Heo
Sent: Wednesday, September 09, 2020 2:03 AM
To: tianxianting (RD) <tian.xianting-vVzyEvZLFYE@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org; cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [PATCH] blkcg: add plugging support for punt bio

On Sat, Sep 05, 2020 at 11:25:03AM +0000, Tianxianting wrote:
> Hi jens,tj
> Could you share a couple of  minutes to comment it?
> I really appreciate it

The result looks fine to me but can you please summarize that in the commit message of the patch?

Thanks.
