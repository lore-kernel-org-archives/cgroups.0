From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 09/12] cgroup: make sure parent won't be destroyed before
 its children
Date: Mon, 8 Apr 2013 08:36:35 -0700
Message-ID: <20130408153635.GB3021@htj.dyndns.org>
References: <5162648B.9070802@huawei.com>
 <51626516.3000603@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=FyHyaMHOwopN6lyMiN+6OPVF4KH0vs2S5V/0KTqCU4A=;
        b=HTowmxEJ91Qm6YaLjLKbKs1c2ymu+g84Bw/cV/VidHyNzHkRF3HKqG+J+4U4tOj4bb
         yfnciIcMBu6WVw5ZzDXvzsmcKJw2kQOQLbWJEggo4u2XkeAasIy0/MBliqRb4215KpE0
         zbk/kJWzMhtfPJSwg4UHk+h78GQIOt1heRbKCRSz0g1r4pcAbKofjEuVMjWIe1S+rj0/
         WtdWh4c6gEh3F0PzHzQk/UmxwZfeC2VZSZPMYKgk3lxmQnb5ixmFOz/SRTj+InTWMEY6
         TNdAEQ4e7JNq+ao9zEfKmr23m0osYH1/b2/h/adVX77Mzsn2fUS04G/cQgzuqi+m8WyT
         l6Kw==
Content-Disposition: inline
In-Reply-To: <51626516.3000603-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon, Apr 08, 2013 at 02:35:02PM +0800, Li Zefan wrote:
> Suppose we rmdir a cgroup and there're still css refs, this cgroup won't
> be freed. Then we rmdir the parent cgroup, and the parent is freed
> immediately due to css ref draining to 0. Now it would be a disaster if
> the still-alive child cgroup tries to access its parent.
> 
> Make sure this won't happen.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
