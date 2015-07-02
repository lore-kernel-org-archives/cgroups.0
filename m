From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 26/51] writeback: let balance_dirty_pages() work on the
 matching cgroup bdi_writeback
Date: Wed, 1 Jul 2015 21:26:51 -0400
Message-ID: <20150702012651.GD26440@mtj.duckdns.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-27-git-send-email-tj@kernel.org>
 <20150630143100.GL7252@quack.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=JNKWRZHCvjrvCd5H2yyAY40q8xVnww62ZK2fLGfyO7s=;
        b=wOK5CYKcl117MWpFDi9AitXG5g9z5uBAPv1Bj49aO6on/cMfWiiaqMWBzJyJPLCjS3
         nrc+6AqcbgrBk1jg0cUVjTSTKcNhV6f2Xh1OFxt+1qqaUxw0FdXzJv5f52V6mrMR2LbN
         OLVIfpfOh+XBjd9xdanl8e4I+Ux38QoWys6MiIZCJ7V1NTN3FQ3KUBH4IjSHCkouOC7g
         Kza/KvfhMoRKVPhjPGvPt3KYGwaszilUC6CBTut2ewebWIV+hcpJxIi5rxPIsVKsiqxG
         JZyy+IEcxeTry7if8GENrTHrV57do/rBsZIsz90gMjjrAbwyYDX24bD+wkw2oDUtl2eh
         UNgQ==
Content-Disposition: inline
In-Reply-To: <20150630143100.GL7252@quack.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru

Hello, Jan.

On Tue, Jun 30, 2015 at 04:31:00PM +0200, Jan Kara wrote:
...
> > +	if (inode_cgwb_enabled(inode))
> > +		wb = wb_get_create_current(bdi, GFP_KERNEL);
> > +	if (!wb)
> > +		wb = &bdi->wb;
> > +
> 
> So this effectively adds a radix tree lookup (of wb belonging to memcg) for
> every set_page_dirty() call. That seems relatively costly to me. And all

Hmmm... idk, radix tree lookups should be cheap especially when
shallow and set_page_dirty().  It's a glorified array indexing.  If
not, we should really be improving radix tree implementation.  That
said,

> that just to check wb->dirty_exceeded. Cannot we just use inode_to_wb()
> instead? I understand results may be different if multiple memcgs share an
> inode and that's the reason why you use wb_get_create_current(), right?
> But for dirty_exceeded check it may be good enough?

Yeah, that probably should work.  I'll think more about it.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
