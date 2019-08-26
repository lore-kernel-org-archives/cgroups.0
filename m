From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 5/5] writeback, memcg: Implement foreign dirty flushing
Date: Mon, 26 Aug 2019 08:58:34 -0700
Message-ID: <20190826155834.GP2263813@devbig004.ftw2.facebook.com>
References: <20190815195619.GA2263813@devbig004.ftw2.facebook.com>
 <20190815195930.GF2263813@devbig004.ftw2.facebook.com>
 <20190821210235.GN2263813@devbig004.ftw2.facebook.com>
 <20190826135452.GF10614@quack2.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ualaw3vnF7au6b9X5hx4CHQJfw3fBI27o57pEiUgbJo=;
        b=GnZUYkQ4vVP/v3mu6UxwHdso20ta7Q+KhSdq+8YuwnxdWNjaUmry5GKa9icK1tWcPe
         i/Pa4V+XigAXejuiA1uK/adIfsd3tDcx7eNQWCvIoM7+QHoz4QqAu7XMNSgL7N8+zqdE
         Ok9jG1XQ3c//jnZbPEfKOODlmHb3a7fgG1xvkLv2WSTgnTZ0rDXfwKvAOEvY1x+5qNmd
         pm1xCF4GvRicJfJDbO+EIuu1fTxJrTXW/dSfkGdSesws3Z7Jjp9PFSy+eyS5KifycqKL
         eHHWeEryOX/9dFa/d+Z/gnxpRShYwQ/t30umzlPd2vtUN8mYXy8+GKymvgk7N/3qzv5V
         v2Eg==
Content-Disposition: inline
In-Reply-To: <20190826135452.GF10614@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, guro@fb.com, akpm@linux-foundation.org

Hello, Jan.

On Mon, Aug 26, 2019 at 03:54:52PM +0200, Jan Kara wrote:
> As I've checked, you should be using get_jiffies_64() to get value of
> jiffies_64. Also for comparisons of jiffie values, I think you should be
> using time_after64() and similar functions instead of direct comparisons...

Yeah, good point.  I always forget that with jiffies_64.  Will post an
updated series soon.

Thanks.

-- 
tejun
