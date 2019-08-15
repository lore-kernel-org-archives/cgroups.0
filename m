From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/4] writeback, memcg: Implement cgroup_writeback_by_id()
Date: Thu, 15 Aug 2019 09:12:11 -0700
Message-ID: <20190815161211.GC588936@devbig004.ftw2.facebook.com>
References: <20190803140155.181190-1-tj@kernel.org>
 <20190803140155.181190-4-tj@kernel.org>
 <20190815145421.GN14313@quack2.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iTIKIuhQjFmLzffUqNs0d7EM6m2UJCFz471NWYlW/kA=;
        b=QXjkEAHzvaI4d+a1jTu1uuBdBcwkiUcidF6xSV/xQKF2N7ucXBCF5Hej38FIPF0Lm3
         9fWE+N6hf68OLIhzBONo5J5LQOEGzbqPKECQp+aEdwFdT+opMpMJ1qGxqzQD9gdQCPEz
         IecizOukDzYwhTyD2KWejogmiAgKaK1vXPLIaF4L9biBH+TFPKprcr2WQ/6fGoTrK2rx
         p6Un0uytpeqSTUTd8k+dvepjTTMJOAFXt4wObsUiZTFbAJFHR3q+4a3Y/b8ZvK/foXDm
         wpA60ZcOdP6GWCrYCNX13gHb4P/T2mGkfQelkmBGCL+lGa6+8NnbqBd7hYAfkgZPkPEV
         CS9w==
Content-Disposition: inline
In-Reply-To: <20190815145421.GN14313@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, guro@fb.com, akpm@linux-foundation.org

On Thu, Aug 15, 2019 at 04:54:21PM +0200, Jan Kara wrote:
> > +	/* and find the associated wb */
> > +	wb = wb_get_create(bdi, memcg_css, GFP_NOWAIT | __GFP_NOWARN);
> > +	if (!wb) {
> > +		ret = -ENOMEM;
> > +		goto out_css_put;
> > +	}
> 
> One more thought: You don't want the "_create" part here, do you? If
> there's any point in writing back using this wb, it must be attached to
> some inode and thus it must exist. In the normal case wb_get_create() will
> just fetch the reference and be done with it but when you feed garbage into
> this function due to id going stale or frn structures getting corrupted due
> to concurrent access, you can be creating bogus wb structures in bdi...

Yeah, it can create wbs unnecessarily which isn't critical but also is
easy to fix.  Will update.

Thanks.

-- 
tejun
