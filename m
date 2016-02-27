From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: fix written mistake in warning message
Date: Sat, 27 Feb 2016 08:43:01 +0800
Message-ID: <56D0F115.5000900@huawei.com>
References: <1456463258-6617-1-git-send-email-lixiubo@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456463258-6617-1-git-send-email-lixiubo-0p4V/sDNsUmm0O/7XYngnFaTQe2KTcn/@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Xiubo Li <lixiubo-0p4V/sDNsUmm0O/7XYngnFaTQe2KTcn/@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2016/2/26 13:07, Xiubo Li wrote:
> There is written mistake about the print format name:id <--> %d:%s,
> which the name is 'char *' type and id is 'int' type. Change "name:id"
> to "id:name" instead to be consistent with "cgroup_subsys %d:%s".
> 
> Signed-off-by: Xiubo Li <lixiubo-0p4V/sDNsUmm0O/7XYngnFaTQe2KTcn/@public.gmane.org>

Acked-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
