From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 30/51] writeback: implement and use inode_congested()
Date: Wed, 1 Jul 2015 21:46:34 -0400
Message-ID: <20150702014634.GF26440@mtj.duckdns.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-31-git-send-email-tj@kernel.org>
 <20150630152105.GP7252@quack.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=/7R+6+gbiMd9PhnAtiXQWVKS/3zGUK4HHPl0UuX+ZJ4=;
        b=xDKSs5hKQ5eenPVatqWo/8f7OvFnKHwWKS2xpRN5cjVfhoN+gjGs1sL2x00OztMd5n
         KYFHB+YTKVAqXLo/iaRQOwQRkVdnmG8EKCO4q/iq5YqajC8qq9C5aOMa0NJLGEDAD6R2
         addVcmLp4IHYgsaba4/6MzFE54gZrrEL3fCHZwSukT4RjkwTGNPjTYPwi/X36pKOa6kI
         Zhc+QrBmAWBIILFUMk4ANNBxUok9avSEWfY/H3EFL3cJI/UmQdnuFM3CwRXv/NEVh+hu
         m+iP0zx0pBvmw2+pdT6kYJjXOZ106nx4Mb1srS6wsBeDfmx6cJ1ceU18J1KG/27zGHUu
         QcEw==
Content-Disposition: inline
In-Reply-To: <20150630152105.GP7252@quack.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru

Hello,

On Tue, Jun 30, 2015 at 05:21:05PM +0200, Jan Kara wrote:
> Hum, is there any point in supporting NULL inode with inode_congested()?
> That would look more like a programming bug than anything... Otherwise the
> patch looks good to me so you can add:

Those are inherited from the existing usages and all for swapper
space.  I think we should have a dummy inode instead of scattering
NULL mapping->host test all over the place but that's for another day.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
