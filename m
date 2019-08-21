From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 5/5] writeback, memcg: Implement foreign dirty flushing
Date: Wed, 21 Aug 2019 09:04:30 -0700
Message-ID: <20190821160430.GL2263813@devbig004.ftw2.facebook.com>
References: <20190815195619.GA2263813@devbig004.ftw2.facebook.com>
 <20190815195930.GF2263813@devbig004.ftw2.facebook.com>
 <20190816160256.GI3041@quack2.suse.cz>
 <20190821160037.GK2263813@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pSYvDILhSH8fJWFn1Ay93bkSas+NlIGIDDL+tHz2nnY=;
        b=FcPaI0pBK/tsTJ85fkJV0GzNaa0VI6xq2/3C77dJ9Ksg2LPi+NeYin58kEZaHWQ4+c
         yNts5ywVYjfMNCER2xvTfME0oKqC0YC2I4+K1tsuNpQiaJjKZTyj3LDo3/o+40aLy1b3
         xFROy6h268Qz/2709NunEce2lWelxf9pFlX7BM8kPI3y5yOWd5UyF8HaxBcv8mpUorwb
         8wJ1/du7AiJGYKqbpfRUjO9rT+TCM/8hnViWhPuAotTO6NOkCjN1Clp8ecE6hIl6tYqF
         MHer6bExHhfCK5pjD900mPPO3BKg9ILIPrD3FA13M/iRdL1oZqc+Ge1OIPSGrhdITT6H
         MvGA==
Content-Disposition: inline
In-Reply-To: <20190821160037.GK2263813@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, guro@fb.com, akpm@linux-foundation.org

On Wed, Aug 21, 2019 at 09:00:37AM -0700, Tejun Heo wrote:
> > 2) When you invalidate frn entry here by writing 0 to 'at', it's likely to get
> > reused soon. Possibly while the writeback is still running. And then you
> > won't start any writeback for the new entry because of the
> > atomic_read(&frn->done.cnt) == 1 check. This seems like it could happen
> > pretty frequently?
> 
> Hmm... yeah, the clearing might not make sense.  I'll remove that.

Oh, the reuse logic checks whether done.cnt == 1 and only reuse if no
writeback is still in flight, so this one should be fine.

Thanks.

-- 
tejun
