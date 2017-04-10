From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Remove cpuset_update_active_cpus()'s parameter.
Date: Mon, 10 Apr 2017 09:45:07 +0800
Message-ID: <58EAE3A3.7010105@huawei.com>
References: <20170409013614.7138-1-rakib.mullick@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170409013614.7138-1-rakib.mullick-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Rakib Mullick <rakib.mullick-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org

On 2017/4/9 9:36, Rakib Mullick wrote:
> In cpuset_update_active_cpus(), cpu_online isn't used anymore. Remove
> it.
> 
> Signed-off-by: Rakib Mullick<rakib.mullick-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Acked-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

