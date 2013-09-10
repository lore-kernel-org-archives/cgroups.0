From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.12-fixes] cgroup: fix cgroup post-order
 descendant walk of empty subtree
Date: Tue, 10 Sep 2013 09:41:36 -0400
Message-ID: <20130910134136.GA7275@htj.dyndns.org>
References: <20130906193108.GH22763@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=u866HchPS5LrWACrkpwW8zac5Rw9oJkz99t5VVTpOwY=;
        b=JD7/nz+F9YMZeXG4lBAncoIwIDD9FEbyC8fk6cnuiLBOGF4aRlPl6iVVV5FakBuobS
         6/BPuOdC1QM4F2TrCy/WBykLa+G0kJkhPbEk/yxhcfbSif/f5dzf+SmhPJn5Pf+ywhe0
         M+M+C/2EYovAzlcz7wKgQQNnOmFp6oGRlu/xt9nIZl+LxZsehzdr38+kONCxIJeZLdzf
         OqXyGtyPrXhPpuNV9Sm69bR+hyKIrbhcFk0+ONU1p202o6ea8ZODpHSPP2T9hAqh+hE7
         yZOotLK3/rd+d4YMNhsDJSR8fz5+GXGJPw5MT5XVmC9w97AdH1E9uBUoVLP96hmI6JEe
         nkgQ==
Content-Disposition: inline
In-Reply-To: <20130906193108.GH22763-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Sep 06, 2013 at 03:31:08PM -0400, Tejun Heo wrote:
> bd8815a6d8 ("cgroup: make css_for_each_descendant() and friends
> include the origin css in the iteration") updated cgroup descendant
> iterators to include the origin css; unfortuantely, it forgot to drop
> special case handling in css_next_descendant_post() for empty subtree
> leading to failure to visit the origin css without any child.
> 
> Fix it by dropping the special case handling and always returning the
> leftmost descendant on the first iteration.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Applied to cgroup/for-3.12-fixes.

Thanks.

-- 
tejun
