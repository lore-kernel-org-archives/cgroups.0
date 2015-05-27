From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 11/51] memcg: implement mem_cgroup_css_from_page()
Date: Wed, 27 May 2015 13:48:17 -0400
Message-ID: <20150527174817.GP7099@htj.duckdns.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-12-git-send-email-tj@kernel.org>
 <20150527161344.GO7099@htj.duckdns.org>
 <20150527170955.GA25324@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=aW+h3BSBjSbsACHwogmNwxmyQhamiq47puj9Q0q06Tg=;
        b=wQyR88k2oQ8dDhp4YhJ8O3hJCNR0EfzbpiJChZVthBg9bjPhFAtdBLonjpsxoYHXOU
         tuMihzMwZyk/VNS6S3F5m/3lceYXbYtzyxC33vrH8SxxeucRWYR0Ph8OEI/Ju4AkcoPy
         HKEY7GgHjSFUQPxK43GJ1km0h9qb/sdNMHS369R+bQEn7VV5DPolEMyENAlmsLeh/qN3
         scBbyemLMse8Du+ltZoGrHbzx363Ixk4VJlLfdzA9F28PETJSRp/iM1BN4zU82s/f46l
         xIAsbkwOA7NzvUXK8Ga5uNI6ie9+jUf/tlXugwU2IiNqWGmTNq+ZD455ReK48CApHav2
         uoUQ==
Content-Disposition: inline
In-Reply-To: <20150527170955.GA25324-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org

Hello,

On Wed, May 27, 2015 at 01:09:55PM -0400, Johannes Weiner wrote:
> Regular page migration uses mem_cgroup_migrate() as well, but it's not
> a problem as it ensures that the old page doesn't have any outstanding
> references at that point.

Ooh, I see.

> It's only replace_page_cache_page() that calls mem_cgroup_migrate() on
> a live page breaking mem_cgroup_css_from_page().
> 
> So the page looks fine, I'd just update the culprit function in the
> changelog and kerneldoc.

Alright, will update the comment and description.

Thanks.

-- 
tejun
