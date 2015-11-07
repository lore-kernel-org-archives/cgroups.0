From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.4-fixes] cgroup: fix cftype->file_offset
 handling
Date: Sat, 7 Nov 2015 15:42:55 +0800
Message-ID: <563DAB7F.7020407@huawei.com>
References: <20151105051224.GA4914@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151105051224.GA4914-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Sedgwick <jsedgwick-b10kYP2dOMg@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org

On 2015/11/5 13:12, Tejun Heo wrote:
> 6f60eade2433 ("cgroup: generalize obtaining the handles of and
> notifying cgroup files") introduced cftype->file_offset so that the
> handles for per-css file instances can be recorded.  These handles
> then can be used, for example, to generate file modified
> notifications.
>
> Unfortunately, it made the wrong assumption that files are created
> once for a given css and removed on its destruction.  Due to the
> dependencies among subsystems, a css may be hidden from userland and
> then later shown again.  This is implemented by removing and
> re-creating the affected files, so the associated kernfs_node for a
> given cgroup file may change over time.  This incorrect assumption led
> to the corruption of css->files lists.
>
> Reimplement cftype->file_offset handling so that cgroup_file->kn is
> protected by a lock and updated as files are created and destroyed.
> This also makes keeping them on per-cgroup list unnecessary.
>
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reported-by: James Sedgwick <jsedgwick-b10kYP2dOMg@public.gmane.org>
> Fixes: 6f60eade2433 ("cgroup: generalize obtaining the handles of and notifying cgroup files")

Acked-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
