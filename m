From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] blk-ioprio: Introduce promote-to-rt policy
Date: Tue, 14 Feb 2023 09:52:36 +0100
Message-ID: <20230214085236.vamd2yuflnyljyid@quack3>
References: <b6b3c498-e90b-7d1f-6ad5-a31334e433ae@acm.org>
 <beb7782e-72a4-c350-3750-23a767c88753@huaweicloud.com>
 <aedc240d-7c9e-248a-52d2-c9775f3e8ca1@acm.org>
 <20230208134345.77bdep3kzp52haxu@quack3>
 <7fcd4c38-ccbe-6411-e424-a57595ad9c0b@acm.org>
 <20230209085603.dzqfcc3pp4hacqlz@quack3>
 <55a065e7-7d86-d58f-15ba-c631a427843e@acm.org>
 <20230210101244.zsmtmsoo4xjx7suj@quack3>
 <48620099-0311-e752-ba3b-cbb4351cf81e@huaweicloud.com>
 <0290f608-6ddf-ecb7-4c05-55b0f7dbfbea@acm.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1676364757; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FCM5fUI30hk/CWQ2CgtHO8OXcYicjnlXfEi2o9EEJgU=;
        b=T/Cq0T41wLhDEtRbo9/P3oUnDXSjS/ZP5vtU5NKZsWcmEiJEv8lD8Fabi8f8A8HfN4UIxM
        HEc75jRkl476RycFowuGXkA9gUqSAAebQGliI5pOu11P9aL8MaCRzFt4TZHdphjFsp67jI
        a3EuFPBm746wYdJsL478LWzWk5euQJ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1676364757;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FCM5fUI30hk/CWQ2CgtHO8OXcYicjnlXfEi2o9EEJgU=;
        b=2dBOVRGS4GK4ZtQ5IRwjk/ufawSnkfTjTwXhUnGFsURa02ld52b2sLAvBZZijQ5FCLz+vx
        uwBLWlJq4F7lz3DA==
Content-Disposition: inline
In-Reply-To: <0290f608-6ddf-ecb7-4c05-55b0f7dbfbea@acm.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>
Cc: Hou Tao <houtao@huaweicloud.com>, Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, houtao1@huawei.com

On Mon 13-02-23 09:10:26, Bart Van Assche wrote:
> On 2/13/23 04:51, Hou Tao wrote:
> > Should I keep "none-to-rt" and make it work just like "promote-to-rt" or should
> > I just remove "none-to-rt" and add "promote-to-rt" ? I think the latter will be
> > more appropriate.
> 
> Removing none-to-rt would break existing systems that use this policy. I
> prefer the former solution.

Agreed. I also think that keeping none-to-rt as an alias for promote-to-rt
allows for a smoother transition. However I'm all for documenting that
none-to-rt is deprecated and works as promote-to-rt.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
