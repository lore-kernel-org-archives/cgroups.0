From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 36/51] writeback: implement bdi_for_each_wb()
Date: Fri, 3 Jul 2015 13:06:51 -0400
Message-ID: <20150703170651.GE5273@mtj.duckdns.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-37-git-send-email-tj@kernel.org>
 <20150701072757.GW7252@quack.suse.cz>
 <20150702022226.GH26440@mtj.duckdns.org>
 <20150703122627.GK23329@quack.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=LnTvzaynHJDuDu+C221npfsVCmmqDCDYpvvxDqGWGKU=;
        b=iUYhEEUt4pc4bDOBx1IcwiwhKNH4mwxaksvIaRn0jG+J74odGJUuN3pu5PEdTp0BGN
         4lwrJwEWVI1fwDcny+9TgB+yguq9javWZo0P7B+pH87tyUjM28gCDbJKPv7Kv1sJGH73
         eWVNYmjQa/hW5Ry8sRdqKd2sxJKb9OJdDaoErxZF79tc7JPK6maCH7gPCRbXrqdII0GI
         fZsOtO6s81wORbhfDjEkOdSlWDM1aUKqrgYzHHdSvlX6ZNm1qb5cWNCs+/hmsedlYG28
         kohNNcfbke/6clIJsopNTGKLzLkurB6fnMBfPSACn6hQVRhfAl1bzNFJeyrpWty4Lg0C
         SZ/w==
Content-Disposition: inline
In-Reply-To: <20150703122627.GK23329@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru

On Fri, Jul 03, 2015 at 02:26:27PM +0200, Jan Kara wrote:
> That's a good point. Thanks for explanation. Maybe add a comment like:
> /*
>  * We use use this seemingly complicated 'for' loop so that 'break' and
>  * 'continue' continue to work as expected.
>  */

This kinda feel superflous for me.  This is something true for all
iteration wrappers which falls within the area of well-established
convention, I think.  If it's doing something weird like combining
if-else clause to do post-conditional processing, sure, but this is
really kinda standard.

Thanks.

-- 
tejun
