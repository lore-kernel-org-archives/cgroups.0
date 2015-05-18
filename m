From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v12 4/8] cgroup, block: implement task_get_css() and use
 it in bio_associate_current()
Date: Mon, 18 May 2015 17:59:07 -0400
Message-ID: <20150518215907.GJ24861@htj.duckdns.org>
References: <1431960667-26593-1-git-send-email-cyphar@cyphar.com>
 <1431960667-26593-5-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=v+HgF8+bpUdyddRrWrtcT7NO6ycxqhqzuFcZzKj5i1k=;
        b=ikSlNKs4LazxlsmQvBm+zsT0jwA/eo9V8qCNHzvF8KqSWMBpj3KdHy+iOZlhpWHNlh
         eLCuucPxMs//E2R+TdGKiIaOVyG40NnfBCSGjHlKQ7hllVyMyj+O5RZquGTOZ5ohZGyb
         BlDavOZHFPww7+1Btnuu3HeIPRhIM6r28Zsw7dW4t8uqwLH7NIzHEv02sMK0jHnG1pGO
         5gYh8sAfjp+tuotmlP3jyimJELVqUwg7SAp6P3F1hL4HyZ3YnHVS4YuxeJThLRp6NWFK
         BI0e0h7wBBgSByapXW9QsNKUuOO5VCEQT+Suj94tJIVmoiA+Xjs5Ks32WC9fC9593pL/
         dy3g==
Content-Disposition: inline
In-Reply-To: <1431960667-26593-5-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Tue, May 19, 2015 at 12:51:03AM +1000, Aleksa Sarai wrote:
> From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 
> bio_associate_current() currently open codes task_css() and
> css_tryget_online() to find and pin $current's blkcg css.  Abstract it
> into task_get_css() which is implemented from cgroup side.  As a task
> is always associated with an online css for every subsystem except
> while the css_set update is propagating, task_get_css() retries till
> css_tryget_online() succeeds.
> 
> This is a cleanup and shouldn't lead to noticeable behavior changes.

Applied 1-4 but skipped bio_associate_current() changes from this
patch.  I'll route that part through a different patchset.

Thanks.

-- 
tejun
