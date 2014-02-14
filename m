From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: fix top cgroup refcnt leak
Date: Fri, 14 Feb 2014 11:02:25 -0500
Message-ID: <20140214160225.GD31544@htj.dyndns.org>
References: <52FDE393.6050607@huawei.com>
 <52FDFAC6.1080802@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=+etRBozYHVhZ25Nj0eDVVu8D3xpDVN0efwFXg9B8diw=;
        b=eRdkB1IDj9qhoT4usBHBjLH4yw8dW19KN7csXL1qBtcHnOIAANSxzIFiTJBT5S/zBR
         9qOib/lqVcjKM7w4fxQUGLhyctxJ2UQky0MUdGP9Fn+NdpPgX6nSa3k2p/uD64CN8D1H
         Ynoz537i6mMh+9D51RMyEqvTr4SO5fSH0Kz/DNGBW3fB7sys6MSSwHwEhXBjm9wuGoxz
         sqw23HcnXRYd0/313wTC9cSt/6F5XM7+le78LQ4peO868ohaeb5zHoT2JfeLeTQ6nfZ6
         3JtXK0uAO1VG8SVzInUl9taH21eoBu4g9jMS7UdaAP89UvS1HNReqi3WM2Z5g3gOiQ7s
         mjtQ==
Content-Disposition: inline
In-Reply-To: <52FDFAC6.1080802@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizf.kern@gmail.com>
Cc: Li Zefan <lizefan@huawei.com>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Fri, Feb 14, 2014 at 07:15:18PM +0800, Li Zefan wrote:
> >  		/*
> > +		 * A root's lifetime is governed by its top cgroup.  Zero
> > +		 * ref indicate that the root is being destroyed.  Wait for
> > +		 * destruction to complete so that the subsystems are free.
> > +		 * We can use wait_queue for the wait but this path is
> > +		 * super cold.  Let's just sleep for a bit and retry.
> > +		 */
> > +		if (!atomic_read(&root->top_cgroup.refcnt)) {
> 
> oops, this fix is wrong. We call kernfs_mount() without cgroup locks and it
> drops cgroup refcnt if failed.
> 
> I guess we need to bump the refcnt and then drop it after kernfs_mount().

Alright, will wait for the updated fix.

Thanks!

-- 
tejun
