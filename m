From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 45/51] writeback: implement wb_wait_for_single_work()
Date: Wed, 1 Jul 2015 23:07:23 -0400
Message-ID: <20150702030723.GN26440@mtj.duckdns.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-46-git-send-email-tj@kernel.org>
 <20150701190735.GI7252@quack.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=IdgXPYnjP/2HpR5cDOJOYPUxH9IMgD5FksaW77l6Te8=;
        b=LCqwYQuSbj08034QM8KTORhd7AOdgDzVcnUl0Lfs7M5MWSJmRBSkfz30O4yPejjDgr
         JmCX545rHNudxEKkFFqcjydDvdiy8CyPnzxxERMGVX7bZt5a9UskNH/nMHOYLBIi0jIT
         g8wZEuHoWOoDEw/bkm9zXX/hlBDYxlGW4xz8S4xPN6Vm+A3x7LbzbfuBQWdbAKrFq4y6
         ZXy0Kw3URiP5hAl+OVoF99VkGjF/3yfG/KSh3wEJpSfuSBB55BOYoC7t3TL/xDuUZyab
         JyzBVG5sxTIf3WUOCJNO7FEI9C/wvaVbhLpN4iVNuS0GiX8OpBnUSbVZLVovNJCvD/w/
         CzNw==
Content-Disposition: inline
In-Reply-To: <20150701190735.GI7252@quack.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru

Hello,

On Wed, Jul 01, 2015 at 09:07:35PM +0200, Jan Kara wrote:
> I don't understand, why is the special handling with single_wait,
> single_done necessary. When we fail to allocate work and thus use the
> base_work for submission, we can still use the standard completion mechanism
> to wait for work to finish, can't we?

Indeed.  I'm not sure why I didn't do that.  I'll try.

> BTW: Again it would be easier for me to review this if the implementation
> of this function was in one patch with the use of it so that one can see
> how it gets used...

Same point on this one as before.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
