From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Mon, 8 Jan 2018 19:42:11 -0800
Message-ID: <20180109034211.GC3668920@devbig577.frc2.facebook.com>
References: <20171211152059.GH2421075@devbig577.frc2.facebook.com>
 <cca9aea2-9bff-decf-d669-8f90b928ea18@codeaurora.org>
 <20171213160617.GQ3919388@devbig577.frc2.facebook.com>
 <9843d982-d201-8702-2e4e-0541a4d96b53@codeaurora.org>
 <20180102161656.GD3668920@devbig577.frc2.facebook.com>
 <20180102174408.GM7829@linux.vnet.ibm.com>
 <20180102180119.GA1355@linux.vnet.ibm.com>
 <20180108122823.GL3668920@devbig577.frc2.facebook.com>
 <20180108225238.GN9671@linux.vnet.ibm.com>
 <20180109003127.GA30224@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=07ilrIPGu0DKJICvZRQpO+EBoZC/e2JwxY2BuJ5ikiU=;
        b=aqW8+YWPo66guwZloOVKLjqKA9qJNeiakYXTveqt9x+SRW03TJJi4ceEBrl1J8gKPG
         pgsAX33r+r1SUoNzP3QH34r0RARIuDaLnUuOtPmLoOszg5tAavHzQIw/D7sFb5jBxUdT
         wSA+LbYFvcRNwmse3D1rweys4jdtaptj6GDu1jn4sOL4iq7j008p4cB0reKLkl7LNy6n
         UwVV2azzKs3FRVIChEsVui8ziTK+V/x0iqMwG4F7RIO/h5BDNfNkRKapBe7F9fRazoii
         Riw3BAedEs4Bf8cK/J7pasGwSHZY7cKsMmWV00rnQoefyyocyfShVd1r3yuKVZ8+UVIO
         tilg==
Content-Disposition: inline
In-Reply-To: <20180109003127.GA30224-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org

Hello, Paul.

On Mon, Jan 08, 2018 at 04:31:27PM -0800, Paul E. McKenney wrote:
> +static int __init rcu_init_wq_rescuer(void)
> +{
> +	WARN_ON(init_rescuer(rcu_gp_workqueue));
> +	return 0;
> +}
> +core_initcall(rcu_init_wq_rescuer);

So, what I don't get is why RCU needs to call this explicitly.
core_initcall() is after workqueue_init() anyway.  Why am I missing?

Thanks.

-- 
tejun
