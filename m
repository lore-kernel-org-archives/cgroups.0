From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 6/6] remove __must_check for
 res_counter_charge_nofail()
Date: Mon, 14 May 2012 13:09:25 -0700
Message-ID: <20120514200925.GH2366@google.com>
References: <4FACDED0.3020400@jp.fujitsu.com>
 <4FACE184.6020307@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=rXvXanY1RFa/OfPLAmAdts+WDrcxkyAYP709rTcNd1U=;
        b=J0G0KcIeqQHS/i34+a6Tjko4jMEKra5XScGUwh4buEoMxbJ3GxKfVm2lMjv1VetHu2
         TUZ/YJDfUTvZReSZgk2GVXvnAkV82BCsJx2ExYtjS7p08S6TPxEmItxbAf4QncIznKLL
         S8EymYeLSWNXMY6a0kXJ+flNIbTM5CwMVX34A09U9qX2nJKeeLL4CysIv7VKhusS7O+j
         DK74moyQrJgnSVupEDzT1W2Q0gqoRlwZ/UPrDKAwsSZBUQO8vK5Tj+bkS0fGOU/Or72I
         0cGhwVXKnvZDCBueuCbfPwZYKY4W0Szk93rfvFvprdIQNsSGHSHRu0+UppzXnPNeUPlW
         VQkg==
Content-Disposition: inline
In-Reply-To: <4FACE184.6020307-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hiroyuki Kamezawa <kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, May 11, 2012 at 06:53:08PM +0900, KAMEZAWA Hiroyuki wrote:
> I picked this up from Costa's slub memcg series. For fixing added warning
> by patch 4.
> ==
> From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Subject: [PATCH 6/6] remove __must_check for res_counter_charge_nofail()
> 
> Since we will succeed with the allocation no matter what, there
> isn't the need to use __must_check with it. It can very well
> be optional.
> 
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

For 3-6,

 Reviewed-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks a lot for doing this.  This doesn't solve all the failure paths
tho.  ie. what about -EINTR failures from lock contention?
pre_destroy() would probably need delay and retry logic with
WARN_ON_ONCE() on !-EINTR failures.

Thank you.

-- 
tejun
