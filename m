From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.12-fixes] cgroup: fix cgroup post-order descendant
 walk of empty subtree
Date: Tue, 10 Sep 2013 17:19:07 +0800
Message-ID: <522EE40B.6070405@huawei.com>
References: <20130906193108.GH22763@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130906193108.GH22763-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2013/9/7 3:31, Tejun Heo wrote:
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

Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
