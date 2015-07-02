From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 36/51] writeback: implement bdi_for_each_wb()
Date: Wed, 1 Jul 2015 22:22:26 -0400
Message-ID: <20150702022226.GH26440@mtj.duckdns.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-37-git-send-email-tj@kernel.org>
 <20150701072757.GW7252@quack.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=rlET6wIqtmhuEdRPrN5HRDn9vv9DhF+pCT9K4J+gkn0=;
        b=s89ER3JRv9LE4r2VaJGk3bt1MNlLdzmIq8Po19pxdxGaTG+pfnB9T6KMDZ6dmTNe1r
         KneIy3kk6EfcuQbOiZyRG8UnQTQGzO7Dau2IhsebHhaA/JoJBugvZQjQj6EoRudUVQHO
         PIxt3M23rLTjkSaQD3ZyQrJw65SWkekiFvP75xmihsS0IyUrz+Aed2ktBAkOjphzwz8a
         7laPqBQsD6huvltxhuzdNmFziGObNJBWzBminy7kmvSgLRmMXlAaTiMvr+37eVFLht6K
         frqlbD2yZDz/N/kOmxs1Bz+3WBKESc5PL8hqy1VoKZUwsaLgPnC4ot5xynJRB4bImQot
         BUIA==
Content-Disposition: inline
In-Reply-To: <20150701072757.GW7252@quack.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru

On Wed, Jul 01, 2015 at 09:27:57AM +0200, Jan Kara wrote:
> > +#define bdi_for_each_wb(wb_cur, bdi, iter, start_blkcg_id)		\
> > +	for ((iter)->next_id = (start_blkcg_id);			\
> > +	     ({	(wb_cur) = !(iter)->next_id++ ? &(bdi)->wb : NULL; }); )
> > +
> 
> This looks quite confusing. Won't it be easier to understand as:
> 
> struct wb_iter {
> } __attribute__ ((unused));
> 
> #define bdi_for_each_wb(wb_cur, bdi, iter, start_blkcg_id) \
>   if (((wb_cur) = (!start_blkcg_id ? &(bdi)->wb : NULL)))

But then break or continue wouldn't work as expected.  It can get
really confusing when it's wrapped by an outer loop.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
