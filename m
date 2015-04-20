From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 18/49] bdi: make inode_to_bdi() inline
Date: Mon, 20 Apr 2015 14:21:53 -0400
Message-ID: <20150420182153.GE4206@htj.duckdns.org>
References: <1428350318-8215-1-git-send-email-tj@kernel.org>
 <1428350318-8215-19-git-send-email-tj@kernel.org>
 <20150420154050.GH17020@quack.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=NUJYPl8qQpa8CFQ1dngnUnqCAylfNvSta6ikkcc1O0g=;
        b=wqqdnlp4U1aYt89Rrb+65hEOOtkHOR74FR9Sfij/KHSb7+U62tvc846s30MSmamKB8
         HRKcnUODHrkgWNXZP/brhiCUCaIoIH0uzZZcaU1RC4lOWn2edyQUo9fieG8hhTbjHG6I
         BV+AyHkF6N1x6f7n0dMmSHjHlNERwEiTPESQCfsPaADga9uZqJmmFrtbNf2PWT8Vs1IW
         rML04vSbcoEYb+Hg0V5ZYm482i0/eSjSLIHJ3uXVJpzxp02WhnOkJNZJTM3q3gClw2LF
         nkxHT+iXnlhTEQ5jru2oL1orh7XoZL2ZQBJSbF9Ql+WzvcCUyyOEvXnpO29CdmNw1z+r
         /fdg==
Content-Disposition: inline
In-Reply-To: <20150420154050.GH17020@quack.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com

On Mon, Apr 20, 2015 at 05:40:50PM +0200, Jan Kara wrote:
> > This patch makes inode_to_bdi() and sb_is_blkdev_sb() that the
> > function calls inline.  blockdev_superblock and noop_backing_dev_info
> > are EXPORT_GPL'd to allow the inline functions to be used from
> > modules.
>   I somewhat hate making blockdev_superblock exported just for this. But
> OK.

Hopefully people won't get creative with it.

> > While at it, maske sb_is_blkdev_sb() return bool instead of int.
>                ^^^ make

Updated.

>   Otherwise the patch looks good. You can add:
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
