From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix device deny of DEV_ALL
Date: Tue, 22 May 2012 02:08:57 +0000
Message-ID: <20120522020857.GA10499@mail.hallyn.com>
References: <CAFeW=pZ8Y7ycxjxro7zBMqdtaCOYs4RmoxtDrsN8+mqLhOL--g@mail.gmail.com>
 <20120518081912.16779.21065.stgit@t>
 <20120521140324.GA5091@sergelap>
 <4FBADF1A.6040303@huawei.com>
 <20120522015426.GA10344@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120522015426.GA10344-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amos Kong <akong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

At line 135, there is

if (walk->type == DEV_ALL)
	goto remove;

I wonder if that was meant to be 'if (wh->type == DEV_ALL)'.  That
seems to fit better with what I would have meant to have happen.
But it's already handled by line 342.  So I think deleting lines
135-136 might be best.  What do you think?

Thanks again, Amos and Li.

-serge
