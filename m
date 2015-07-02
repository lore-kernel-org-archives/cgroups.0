From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 44/51] writeback: implement bdi_wait_for_completion()
Date: Wed, 1 Jul 2015 23:06:24 -0400
Message-ID: <20150702030624.GM26440@mtj.duckdns.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-45-git-send-email-tj@kernel.org>
 <20150701160437.GG7252@quack.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=0QdZpCYb/GTXKMjJs3id6mSVeq9R+WYLy5v+kzAenRY=;
        b=R/cOBJugE8g3c3KwQeZirVmda5LpKYuPBQ50/2Y2iysh8bbcCB8kxlCnTvpCM49ZJs
         Fru/VsHORPBx/xwhZT+mg5yWeb+TLuTesPf1Nr2iAojKiJx2lpiaSOYrbj1bqDwxuz+d
         bMxR313x22s8xsvmrFukywenpBvABDWdFNq7Lpllc9DO43nIwQvoVuEZ1Z/w5KmYQWUp
         MaiPW038ZxtazMIw22yzpNk+5SjBOMbKWWNHg1VjjKelr8IMaswlmUicAVxFpd/LevD0
         YV9MIsc8UKdpj8p8SDXXoP7FGMA26lfXAB5KbMYCIR27Guol1FtFhOysOYd1lfGfctLp
         NpuQ==
Content-Disposition: inline
In-Reply-To: <20150701160437.GG7252@quack.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru

Hello, Jan.

On Wed, Jul 01, 2015 at 06:04:37PM +0200, Jan Kara wrote:
> I'd find it better to extend completions to allow doing what you need. It
> isn't that special. It seems it would be enough to implement
> 
> void wait_for_completions(struct completion *x, int n);
> 
> where @n is the number of completions to wait for. And the implementation
> can stay as is, only in do_wait_for_common() we change checks for x->done ==
> 0 to "x->done < n". That's about it...

I don't know.  While I agree that it'd be nice to have a generic event
count & trigger mechanism in the kernel, I don't think extending
completion is a good idea - the count then works both ways as the
event counter && listener counter and effectively becomes a semaphore
which usually doesn't end well.  There are very few cases where we
want the counter works both ways and I personally think we'd be far
better served if those rare cases implement something custom rather
than generic mechanism becoming cryptic trying to cover everything.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
