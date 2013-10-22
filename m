From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 2/2] blk-throttle: trim tokens generated for an idle
 tree
Date: Tue, 22 Oct 2013 17:02:32 -0400
Message-ID: <20131022210232.GB2884@redhat.com>
References: <20131018155532.GD2277@redhat.com>
 <1382271072-15664-1-git-send-email-zhiguohong@tencent.com>
 <1382271072-15664-3-git-send-email-zhiguohong@tencent.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1382271072-15664-3-git-send-email-zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hong Zhiguo <honkiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

On Sun, Oct 20, 2013 at 08:11:12PM +0800, Hong Zhiguo wrote:
> From: Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> 
> Why
> ====
> Pointed out by Vivek: Tokens generated during idle period should
> be trimmed. Otherwise a huge bio may be permited immediately.
> Overlimit behaviour may be observed during short I/O throughput
> test.
> 
> Vivek also pointed out: We should not over-trim for hierarchical
> groups. Suppose a subtree of groups are idle when a big bio comes.
> The token of the child group is trimmed and not enough. So the bio is
> queued on the child group. After some jiffies the child group reserved
> enough tokens and the bio climbs up. If we trim the parent group at
> this time again, this bio will wait too much time than expected.
> 
> Analysis
> ========
> When the bio is queued on child group, all it's ancestor groups
> becomes non-idle. They should start to reserve tokens for that
> bio from this moment. And their reserved tokens before should be
> trimmed at this moment.
> 
> How
> ====
> service_queue now has a new member nr_queued_tree[2], to represent
> the the number of bios waiting on the subtree rooted by this sq.
> 
> When a bio is queued on the hierarchy first time, nr_queued_tree
> of all ancestors and the child group itself are increased. When a
> bio climbs up, nr_queued_tree of the child group is decreased.
> 
> When nr_queued_tree turns from zero to one, the tokens reserved
> before are trimmed. And after this switch, this group will never
> be trimmed to reserve tokens for the bio waiting on it's descendant
> group.
> 

Hi Hong,

This approach looks good in general. Only downside I can think of
updation of nr_requests throughout the hierarchy. So deeper the 
hierarchy, higher the overhead.

I am not sure if that's a concern or not. I will have a closer look
a the patches tomorrow and do some testing too.

Thanks
Vivek
