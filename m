From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v12 4/8] cgroup, block: implement task_get_css() and use
 it in bio_associate_current()
Date: Thu, 28 May 2015 16:47:39 -0400
Message-ID: <20150528204739.GD27479@htj.duckdns.org>
References: <1431960667-26593-1-git-send-email-cyphar@cyphar.com>
 <1431960667-26593-5-git-send-email-cyphar@cyphar.com>
 <20150518215907.GJ24861@htj.duckdns.org>
 <CAOviyagxp32_kr30+O2ATFarvyjuASBy0j9xuXORkwrXahZ79g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5I66aGQf48pQCWJlgOS3Lpcifi1aIk1463bLpIXWv1c=;
        b=uw5Fd5beLPoyusZl7gine/M6PIG8ahRYPfkEzNCkuqvmGY5tKjEfCgSzwnSzTV4c9E
         uoqaltYmnKBaIC8Jxv92EM5bKG6Rh8tkvinRDXL0YOC90rpb7KVmBd4qDYalFkGST0V0
         EMQINvxrU2yZvnI+htvQwr3PkcX9e0+DLOenix70O6/lq7RSdKRjG2Nadei3O+O8eXUy
         pV5+s787JIol0rqyi5+PsB95Wmxbw7rv5WVtc6l+Qknem+604EA9kQF00fBgHmsl50CK
         xY+1kC9E9+A0pU3bxkxu+vc5REwQlWeubo03ZoMOnsOKZbsw6mtyhT3cUd7c5LXLb4u/
         Spuw==
Content-Disposition: inline
In-Reply-To: <CAOviyagxp32_kr30+O2ATFarvyjuASBy0j9xuXORkwrXahZ79g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, richard-/L3Ra7n9ekc@public.gmane.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Tue, May 19, 2015 at 01:05:01PM +1000, Aleksa Sarai wrote:
> Hi Tejun,
> 
> > Applied 1-4 but skipped bio_associate_current() changes from this
> > patch.  I'll route that part through a different patchset.
> 
> Do you want the updated versions of 6-8 of the patchset to be based on
> your tree's for-next?

Can you please base changes on cgroups/for-4.2?  New features usually
should be based on cgroups branch headed for the next merge window.

Thanks.

-- 
tejun
