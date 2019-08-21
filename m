From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 5/5] writeback, memcg: Implement foreign dirty flushing
Date: Wed, 21 Aug 2019 09:00:37 -0700
Message-ID: <20190821160037.GK2263813@devbig004.ftw2.facebook.com>
References: <20190815195619.GA2263813@devbig004.ftw2.facebook.com>
 <20190815195930.GF2263813@devbig004.ftw2.facebook.com>
 <20190816160256.GI3041@quack2.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SkQ1iRQmedFusEhYknXF0m0szFVCfve43ayyHL3P7UE=;
        b=PfRGf7dJmGlq/vFV6Y+jNfBdQj9FXFXpgr4U2sqHZkOOzikZqcKARWfm/Ay9cjoDSU
         SCX+h5EJLGStrV2y6/OzsiFWSydoRDIB8xs/LthT66NJMLZAYtyRP5nrnZgOEeHiNyJk
         1bf35F88LlY3ZL6xZzCIEGGOZVVSZr2saC2AonVkeLUBSZKclxcjROkdE6IhiIiZK18A
         z1eW4eMKnZKE5uALGEnUQyOrqFkSKIT6AjOY4D73Eu6oZ+ZkI6UO+7WVtIvPOc7iPQV5
         aAxUr8psXAumVPPm2Vln5wKADn3tcXCg2XrJ+MksLKbdQw0SqjF2hpb4xY0Ud7EO5OH2
         B8bg==
Content-Disposition: inline
In-Reply-To: <20190816160256.GI3041@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, guro@fb.com, akpm@linux-foundation.org

Hello,

On Fri, Aug 16, 2019 at 06:02:56PM +0200, Jan Kara wrote:
> 1) You ask to writeback LONG_MAX pages. That means that you give up any
> livelock avoidance for the flusher work and you can writeback almost
> forever if someone is busily dirtying pages in the wb. I think you need to
> pick something like amount of dirty pages in the given wb (that would have
> to be fetched after everything is looked up) or just some arbitrary
> reasonably small constant like 1024 (but then I guess there's no guarantee
> stuck memcg will make any progress and you've invalidated the frn entry
> here).

I see.  Yeah, I think the right thing to do would be feeding the
number of dirty pages or limiting it to one full sweep.  I'll look
into it.

> 2) When you invalidate frn entry here by writing 0 to 'at', it's likely to get
> reused soon. Possibly while the writeback is still running. And then you
> won't start any writeback for the new entry because of the
> atomic_read(&frn->done.cnt) == 1 check. This seems like it could happen
> pretty frequently?

Hmm... yeah, the clearing might not make sense.  I'll remove that.

Thanks.

-- 
tejun
