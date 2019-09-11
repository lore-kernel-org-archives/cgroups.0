From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 08/10] blkcg: implement blk-iocost
Date: Wed, 11 Sep 2019 07:16:30 -0700
Message-ID: <20190911141630.GV2263813@devbig004.ftw2.facebook.com>
References: <20190828220600.2527417-1-tj@kernel.org>
 <20190828220600.2527417-9-tj@kernel.org>
 <20190910125513.GA6399@blackbody.suse.cz>
 <20190910160855.GS2263813@devbig004.ftw2.facebook.com>
 <A69EF8D0-8156-46DB-A4DA-C5334764116E@linaro.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bz1mSsuTl+E4vAwMyWtdro8hF2w1GwA4uT5lSquTwhw=;
        b=XP5xHqZ7xOlRXj7HOW4YfjSKWQCcUqBQprIziluIiQnuAsTEkzCybcB7fFfJm27yPR
         GDds5yZIiLTxvxACCXmb197OBE3R2vYBFbX5oUURMbg2GGKciF0uxI85nxPNfswKjMSJ
         W0LYPjiH0p1Z6JT+dM8YBJOmfnn360bKFYmhkBPKstBRfZBnC9kt+Jn6sOkTNkutXH65
         /3JoF0p9BKrGEW2kPfjAkiwAPxJyIapUHhtb2UtDTYd7m2R18FXNoDQX7EiN8uvrfeaY
         m6jQPJfEBMe0sY3RlHXJKhkxcJ2G52HBucA1bVupG1GNaLxpC5whk5FvSs6tN/1JwvTL
         mz5g==
Content-Disposition: inline
In-Reply-To: <A69EF8D0-8156-46DB-A4DA-C5334764116E@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente@linaro.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, clm@fb.com, dennisz@fb.com, newella@fb.com, Li Zefan <lizefan@huawei.com>, Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, Josef Bacik <jbacik@fb.com>, kernel-team@fb.com, Rik van Riel <riel@surriel.com>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Wed, Sep 11, 2019 at 10:18:53AM +0200, Paolo Valente wrote:
> > The two being enabled at the same time doesn't make sense, so we can
> > just switch over to bfq when bfq is selected as the iosched.  I asked
> > what Paolo wanted to do in terms of interface a couple times now but
> > didn't get an answer and he posted a patch which makes the two
> > controllers conflict, so....  Paolo, so it looks like you want to
> > rename all bfq files to drop the bfq prefix, right?
> 
> Yep, mainly because ... this is the solution you voted and you
> yourself proposed [1] :)
> 
> [1] https://patchwork.kernel.org/patch/10988261/

So, that was then.  Since then the interface change has been published
and userspace, at least some of them, already had to adjust.  Now, I
don't have any opinion on the matter and flipping again will cause
inconveniences to some subset of users.  It's your call.

> >  I can implement
> > the switching if so.
> 
> That would be perfect.

Whichever way it gets decided, this is easy enough.  I'll prep a
patch.

Thanks.

-- 
tejun
