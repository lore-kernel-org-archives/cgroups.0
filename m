From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] writeback: synchronize sync(2) against cgroup
 writeback membership switches
Date: Tue, 19 Dec 2017 05:31:51 -0800
Message-ID: <20171219133151.GL3919388@devbig577.frc2.facebook.com>
References: <dc694ae2-f07f-61e1-7097-7c8411cee12d@gmail.com>
 <20171205182007.GV2421075@devbig577.frc2.facebook.com>
 <8844b550-d91c-38d5-997a-a899d1e4aa42@gmail.com>
 <20171211195052.GN2421075@devbig577.frc2.facebook.com>
 <20171212163830.GC3919388@devbig577.frc2.facebook.com>
 <20171213110004.GB23068@quack2.suse.cz>
 <20171213153930.GO3919388@devbig577.frc2.facebook.com>
 <20171219130454.GJ2277@quack2.suse.cz>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=akQekQZ8xslQFBMyZETv8r9/OdUAft/XaTQsKqLDe/k=;
        b=KtfgZAT18R4mV7wnpcIiNmcwW35cTwXQ3DUmlvzO243QUVm83hy1i4nlIm71f05h51
         EpT0TiGBxQAVlhbPQsV2ZijlmZ+GO8h1Pfiv5DNNkXj3mUnDdLPhAHQ0Pq240SFtdaPi
         jmZ8vF5dWupGhFXOcg3TrzHjqPAK3tlI6E4adBumV401p+Wf2I2cGOvLGduMv/dKo12V
         VPFn+JqQucfqgDHCU3zh9PDNxjVyBmTX67LCyV4dipHyHnNxrLOc1P4foOSQTp9bSeJY
         Jv1MXN/QgUsKPhf6a8MMToU27NiJOYogk7Bajk3Wqyi/T30cxA/vpNUfUfBGq4wtgIH1
         DE5w==
Content-Disposition: inline
In-Reply-To: <20171219130454.GJ2277@quack2.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, xuejiufei <xuejiufei@gmail.com>, kernel-team@fb.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Dec 19, 2017 at 02:04:54PM +0100, Jan Kara wrote:
> After some thinking about this I don't have a better solution. So you can
> add:
> 
> Acked-by: Jan Kara <jack@suse.cz>

Thanks, Jan.  Jens, can you please route this through block tree?

Thanks.

-- 
tejun
