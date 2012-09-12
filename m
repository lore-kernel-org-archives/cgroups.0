From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [cgroup:for-next 5/6] fs/xattr.c:882 __simple_xattr_set() error:
 potential NULL dereference 'new_xattr'.
Date: Wed, 12 Sep 2012 10:55:17 +0300
Message-ID: <20120912075517.GZ19396@mwanda>
References: <20120912022813.GA17922@localhost>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120912022813.GA17922@localhost>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Sep 12, 2012 at 10:28:13AM +0800, Fengguang Wu wrote:
> Hi Aristeu,
> 
> FYI, there are new smatch warnings show up in
> 
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
> head:   9814e970d7947dcc5ab7b37a53514c0098bfacc9
> commit: 38f38657444d15e1a8574eae80ed3de9f501737a xattr: extract simple_xattr code from tmpfs
> 
> 
> fs/xattr.c:882 __simple_xattr_set() error: potential NULL dereference 'new_xattr'.
> 

I don't know if this specific code is buggy or not.  It would depend
on how the function is called.

But potentially I should disable this Smatch rule.  It tends to have
a lot of false positives.  The thing is that GCC complains if you
don't initialize "new_xattr", but if you initialize it to NULL then
Smatch complains.

One solution might be to use the unitialized_var() macro.

-       struct simple_xattr *new_xattr = NULL;
+       struct simple_xattr *uninitialized_var(new_xattr);

That would make both GCC and Smatch happy.

regards,
dan carpenter
