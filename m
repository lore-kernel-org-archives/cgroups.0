From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 39/51] writeback: make writeback_in_progress() take
 bdi_writeback instead of backing_dev_info
Date: Wed, 1 Jul 2015 22:28:43 -0400
Message-ID: <20150702022843.GI26440@mtj.duckdns.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-40-git-send-email-tj@kernel.org>
 <20150701074708.GZ7252@quack.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=RmbP1cmZEUpmDlXbgPt0NcEJbzRR28C17wvWjdxSH7g=;
        b=gEptTDoeY8XQeOiS3kD+k/6VHf6dn7vwMdD0MKzD1Q+SEhi6fm6Nt4Pxozem+78HDC
         KY5DQzjDkOqyquF58O/NEU6AkEkt44z7oeD6O+WACMCk/ZHTtJszPWJjP2T+A+acpL23
         wKPUkqNJe5GDZI7lZiL0u9PJyy/8oB80hCEyYqR8Vilb8U/dRNpVJCI4cZx1/RO6nS7L
         hcCtwlNpadyMfKu1MdVaf8yreHUOGXNovrtpsosZ7EFPo6B566SL5IZDdqJxy9tRcCF9
         /DaETnJKVW/YSXXbXEF9HhqI9nSmYRQ97V2XkyejfkowgSLSPnOvzoWZMnaWHWixB6pw
         H4ow==
Content-Disposition: inline
In-Reply-To: <20150701074708.GZ7252@quack.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru

Hello, Jan.

On Wed, Jul 01, 2015 at 09:47:08AM +0200, Jan Kara wrote:
> BTW: It would have been easier for me to review this if e.g. a move from
> bdi to wb parameter was split among less patches. The intermediate state
> where some functions call partly bdi and party wb functions is strange and
> it always makes me go search in the series whether the other part of the
> function gets converted and whether they play well together...

Similar argument.  When reviewing big picture transitions, it *could*
be easier to have larger lumps but I believe that's not necessarily
because reviewing itself becomes easier but more because it becomes
easier to skip what's uninteresting like actually verifying each
change.  Another aspect is that some of the changes are spread out.
When each patch modifies one part, it's clear that all changes in the
patch belong to that specific part; however, in larger lumps, there
usually are a number of stragglers across the changes and associating
them with other parts aren't necessarily trivial.  This happens with
patch descrption too.  It becomes easier to slip in, intentionally or
by mistake, unrelated changes without explaining what's going on.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
